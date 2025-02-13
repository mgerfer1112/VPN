#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

#Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update

# Actualiza paquetes
apt upgrade -y  

#Instalación de Easy-RSA
sudo apt install easy-rsa -y

#Eliminar instalaciones anteriores
rm -rf /home/$SUDO_USER/easy-rsa


#Preparación de un directorio de infraestructura de clave pública
mkdir -p /home/$SUDO_USER/easy-rsa 


#Creación de enlaces simbólicos.
ln -s /usr/share/easy-rsa/* /home/$SUDO_USER/easy-rsa/ 

#Restringir el acceso al directorio PKI al propietario. 
#PKI ->  infraestructura de clave pública
chmod 700 /home/$SUDO_USER/easy-rsa/

sudo rm -rf pki

#Inicializamos el servicio.
echo "yes" | sudo /home/$SUDO_USER/easy-rsa/easyrsa init-pki
