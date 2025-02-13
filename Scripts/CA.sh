#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

#Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update

# Actualiza paquetes
apt upgrade -y  

rm -f /home/ubuntu/easy-rsa/vars
# Creación de la CA
cp ../vars /home/$SUDO_USER/easy-rsa

sed -i "s#\"Country\"#\"$Country\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"Province\"#\"$Province\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"City\"#\"$City\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"Org\"#\"$Org\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"MAIL\"#\"$MAIL\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"OU\"#\"$OU\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"ALGO\"#\"$ALGO\"#" /home/$SUDO_USER/easy-rsa/vars
sed -i "s#\"DIGEST\"#\"$DIGEST\"#" /home/$SUDO_USER/easy-rsa/vars


#Creación del par de claves
sudo /home/$SUDO_USER/easy-rsa/easyrsa build-ca
