#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

#Creamos el diretorio para las configuraciones de los clientes.
rm -rf /home/$SUDO_USER/client-configs/files
mkdir -p /home/$SUDO_USER/client-configs/files

#Copiamos el archivo de configuración por defecto
cp /usr/share/doc/openvpn/examples/sample-config-files/client.conf /home/$SUDO_USER/client-configs/base.conf

#Añadimos la IP Publica de nuestro servidor VPN
sudo sed -i "s#my-server-1#$IPPublicaVPN#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#;user openvpn#user nobody#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#;group openvpn#group nobody#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#ca ca.crt#;ca ca.crt#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#cert client.crt#;cert client.crt#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#key client.key#;key client.key#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#tls-auth ta.key 1#;tls-auth ta.key 1#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#;;tls-auth ta.key 1#;tls-auth ta.key 1#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#;user openvpn#user nobody#" /home/$SUDO_USER/client-configs/base.conf
sudo sed -i "s#;data-ciphers AES-256-GCM:AES-128-GCM:?CHACHA20-POLY1305:AES-256-CBC#cipher AES-256-GCM\nauth SHA256#" /home/$SUDO_USER/client-configs/base.conf
