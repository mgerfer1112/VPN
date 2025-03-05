#!/bin/bash 

# Configuramos para mostrar los comandos y finalizar
set -ex

# Importamos el archivo .env
source .env

# Instrucciones para transferir el archivo de forma segura
scp $UsuarioVPN@$IPPrivadaVPN:$OUTPUT_DIR/${1}.ovpn ~/"

