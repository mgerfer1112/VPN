#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Actualizamos el sistema
apt update -y

# Actualiza paquetes
apt upgrade -y  

# Copiar el certificado del cliente al directorio de claves del cliente
cp /tmp/client1.crt /home/$SUDO_USER/client-configs/keys/

# Copiar también los archivos ta.key y ca.crt al directorio de claves del cliente
cp /home/$SUDO_USER/easy-rsa/ta.key /home/$SUDO_USER/client-configs/keys/
cp /etc/openvpn/server/ca.crt /home/$SUDO_USER/client-configs/keys/

# Configuramos los permisos adecuados para el directorio de claves del cliente
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/client-configs/keys/*

rm -rf /etc/openvpn/server/server.conf
# Copiar el archivo de configuración de muestra de OpenVPN
cp /home/$SUDO_USER/VPN/Scripts/server.conf /etc/openvpn/server/

# Habilitar el reenvío de IP en el archivo sysctl.conf
echo "net.ipv4.ip_forward = 1" | sudo tee -a /etc/sysctl.conf

# Aplicar los cambios de configuración
sudo sysctl -p

# Verificación del reenvío de IP
echo "Reenvío de IP habilitado: $(sysctl net.ipv4.ip_forward)"


sudo rm -rf /etc/ufw/before.rules
sudo cp /home/$SUDO_USER/VPN/Scripts/before.rules /etc/ufw/before.rules

# Reemplazar las variables en el archivo /etc/ufw/before.rules
sudo sed -i "s#IPVPN#$IPVPN#" /etc/ufw/before.rules
sudo sed -i "s#INTERFACE#$INTERFACE#" /etc/ufw/before.rules
sudo sed -i "s#RutaCACRT#$RutaCACRT#" /etc/openvpn/server/server.conf
sudo sed -i "s#RutaServerCRT#$RutaServerCRT#" /etc/openvpn/server/server.conf
sudo sed -i "s#RutaSERVERKEY#$RutaSERVERKEY#" /etc/openvpn/server/server.conf


sudo sed -i 's/DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' /etc/default/ufw

#Como estoy en AWS no lo lanzo, abro los puertos
sudo ufw allow 1194/udp
sudo ufw allow OpenSSH
sudo ufw disable
sudo ufw enable


sudo mv /etc/openvpn/server/server.conf /etc/openvpn/server.conf

sudo systemctl -f enable openvpn-server@server.service

sudo systemctl start openvpn-server@server.service
