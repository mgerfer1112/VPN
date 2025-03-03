#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update -y

# Actualiza paquetes
apt upgrade -y  

#copie los archivos desde /tmpa /etc/openvpn/server
sudo cp /tmp/{server.crt,ca.crt} /etc/openvpn/server/

# Generamos una solicitud de certificado para un cliente
openvpn --genkey --secret /home/$SUDO_USER/easy-rsa/ta.key

# Copiamos la clave tls-crypt al directorio de OpenVPN
cp /home/$SUDO_USER/easy-rsa/ta.key /etc/openvpn/server/

# Configuramos directorio de claves y certificados de cliente
mkdir -p /home/$SUDO_USER/client-configs/keys
chmod -R 700 /home/$SUDO_USER/client-configs

# Generamos una solicitud de certificado para un cliente
EASYRSA_VARS_FILE=/home/$SUDO_USER/easy-rsa/vars /home/$SUDO_USER/easy-rsa/easyrsa gen-req client1 nopass

# Copiamos la clave privada del cliente al directorio de claves del cliente
cp /home/$SUDO_USER/easy-rsa/pki/private/client1.key /home/$SUDO_USER/client-configs/keys/

# Transferimos la solicitud de certificado del cliente al servidor CA
scp -i $RutaPEM /home/$SUDO_USER/easy-rsa/pki/reqs/client1.req $UsuarioCA@$IPPrivadaCA:/tmp
