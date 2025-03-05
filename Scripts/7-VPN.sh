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

echo -e "\nkey-direction 1" >> /home/$SUDO_USER/client-configs/base.conf
echo -e "\n; script-security 2\n; up /etc/openvpn/update-resolv-conf\n; down /etc/openvpn/update-resolv-conf" >> /home/$SUDO_USER/client-configs/base.conf
echo -e "\n; script-security 2\n; up /etc/openvpn/update-systemd-resolved\n; down /etc/openvpn/update-systemd-resolved\n; down-pre\n; dhcp-option DOMAIN-ROUTE ." >> /home/$SUDO_USER/client-configs/base.conf

# Crear el script make_config
# Crear el script make_config

echo "#!/bin/bash" > /home/$SUDO_USER/client-configs/make_config.sh
echo "" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "# First argument: Client identifier" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "KEY_DIR=/home/$SUDO_USER/client-configs/keys" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "OUTPUT_DIR=/home/$SUDO_USER/client-configs/files" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "BASE_CONFIG=/home/$SUDO_USER/client-configs/base.conf" >> /home/$SUDO_USER/client-configs/make_config.sh
echo "" >> /home/$SUDO_USER/client-configs/make_config.sh

echo 'cat ${BASE_CONFIG} \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    <(echo -e "<ca>") \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    ${KEY_DIR}/ca.crt \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    <(echo -e "</ca>\n<cert>") \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    ${KEY_DIR}/${1}.crt \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    <(echo -e "</cert>\n<key>") \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    ${KEY_DIR}/${1}.key \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    <(echo -e "</key>\n<tls-crypt>") \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    ${KEY_DIR}/ta.key \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    <(echo -e "</tls-crypt>") \\' >> /home/$SUDO_USER/client-configs/make_config.sh
echo '    > ${OUTPUT_DIR}/${1}.ovpn' >> /home/$SUDO_USER/client-configs/make_config.sh

#Marcamos el archivo como ejecutable:
chmod 700  /home/$SUDO_USER/client-configs/make_config.sh


# Generar la configuración para el cliente
echo "Generando configuración para el cliente: ${1}"
./home/$SUDO_USER/client-configs/make_config.sh ${1}

# Confirmar la ubicación del archivo de configuración
echo "Archivo de configuración generado en: ${OUTPUT_DIR}/${1}.ovpn"
ls ${OUTPUT_DIR}