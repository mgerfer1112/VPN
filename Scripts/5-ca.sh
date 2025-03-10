#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update -y

# Actualiza paquetes
apt upgrade -y  

#Importar la solicitud de certificado
sudo EASYRSA_PKI="$EASYRSA_PKI" /home/$SUDO_USER/easy-rsa/easyrsa import-req /tmp/client1.req client1

#Firmar
sudo EASYRSA_PKI="$EASYRSA_PKI" /home/$SUDO_USER/easy-rsa/easyrsa sign-req client client1

# copie los archivos server.crty ca.crtdel servidor CA al servidor OpenVPN:ç

#scp /home/$SUDO_USER/easy-rsa/pki/issued/client1.crt $UsuarioVPN@$IPPrivadaVPN:/tmp

#Descomentar y comentar el anterior si se usa clave privada
#scp -i $RutaPEM2 /home/$SUDO_USER/easy-rsa/pki/issued/client1.crt $UsuarioVPN@$IPPrivadaVPN:/tmp
