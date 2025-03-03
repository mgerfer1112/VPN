#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update -y

# Actualiza paquetes
apt upgrade -y  

# Importar la solicitud de certificado
sudo EASYRSA_PKI="$EASYRSA_PKI" /home/$SUDO_USER/easy-rsa/easyrsa import-req /tmp/server.req server


# Asegurar que el archivo vars existe antes de usar Easy-RSA
if [ ! -f "/home/$SUDO_USER/easy-rsa/vars" ]; then
    cp ../vars /home/$SUDO_USER/easy-rsa/vars
fi

# Asegurar que no haya solicitudes duplicadas antes de importar
rm -f /home/$SUDO_USER/easy-rsa/pki/reqs/server.req

# Importar la solicitud de certificado
sudo EASYRSA_PKI="/home/$SUDO_USER/easy-rsa/pki" /home/$SUDO_USER/easy-rsa/easyrsa import-req /tmp/server.req server


#Firmar
sudo EASYRSA_PKI="$EASYRSA_PKI" /home/$SUDO_USER/easy-rsa/easyrsa sign-req server server

# copie los archivos server.crty ca.crtdel servidor CA al servidor OpenVPN:
scp -i $RutaPEM2 /home/$SUDO_USER/easy-rsa/pki/issued/server.crt $UsuarioVPN@$IPPrivadaVPN:/tmp
scp -i $RutaPEM2 /home/$SUDO_USER/easy-rsa/pki/ca.crt $UsuarioVPN@$IPPrivadaVPN:/tmp


