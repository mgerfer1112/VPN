Country=ES
Province=Malaga
City=Malaga
Org=Canovas
MAIL=m.gervilla1112@gmail.com  
OU=Canovas
ALGO=ec #No cambiar
DIGEST=sha512 #No cambiar
#Variable CA directorio de PKI
EASYRSA_PKI="/home/$SUDO_USER/easy-rsa/pki" #No cambiar

UsuarioCA=ubuntu #Usuario máquina CA
IPPrivadaCA=172.31.82.186 #IP máquina CA
RutaPEM=/home/ubuntu/VPN/VPN-Seguridad.pem #Se puede copiar la clave por ssh o a mano.

IPPrivadaVPN=172.31.82.186
UsuarioVPN=ubuntu
RutaPEM2=/home/ubuntu/VPN/VPN-Seguridad.pem 