#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update -y

# Actualiza paquetes
apt upgrade -y  

# Instalamos Openvpn y easy-rsa
sudo apt install openvpn easy-rsa

# Eliminamos cualquier instalación previa de easy-rsa
rm -rf /home/$SUDO_USER/easy-rsa/
mkdir /home/$SUDO_USER/easy-rsa/

# Creación del enlace simbólico
ln -s /usr/share/easy-rsa/* /home/$SUDO_USER/easy-rsa/

# Cambiamos el propietario del directorio easy-rsa
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/easy-rsa

# Ajustamos los permisos del directorio easy-rsa
chmod 700 /home/$SUDO_USER/easy-rsa


# Copiamos vars de vpn y le ponemos el nombre correcto
rm -rf /home/$SUDO_USER/easy-rsa/vars
cp ../vars-vpn /home/$SUDO_USER/easy-rsa
mv /home/$SUDO_USER/easy-rsa/vars-vpn /home/$SUDO_USER/easy-rsa/vars


sed -i "s#\"ALGO\"#\"$ALGO\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"DIGEST\"#\"$DIGEST\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"EASYRSA_PKI\"#\"$EASYRSA_PKI\"#" /home/$SUDO_USER/easy-rsa/vars


# Creación del directorio PKI
echo "yes" | sudo EASYRSA_PKI=$EASYRSA_PKI /home/$SUDO_USER/easy-rsa/easyrsa init-pki

chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/easy-rsa/pki
chmod 700 /home/$SUDO_USER/easy-rsa/pki


# Generación de la solicitud de certificado
EASYRSA_VARS_FILE=/home/$SUDO_USER/easy-rsa/vars /home/$SUDO_USER/easy-rsa/easyrsa gen-req server nopass

cp /home/$SUDO_USER/easy-rsa/pki/private/server.key /etc/openvpn/server/

scp -i $RutaPEM /home/$SUDO_USER/easy-rsa/pki/reqs/server.req $UsuarioCA@$IPPrivadaCA:/tmp 