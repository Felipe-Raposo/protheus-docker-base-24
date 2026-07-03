#!/bin/bash

export LC_ALL=C
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:.

# Descompacta a SystemLoad em background.
if [[ -f "/protheus12/protheus_data/systemload.tar.xz" ]]; then
	cd /protheus12/protheus_data/
	(tar -xvf systemload.tar.xz && rm systemload.tar.xz) &
fi

# Descompacta o binário.
if [[ -f "/protheus12/bin/appserver.tar.xz" ]]; then
	cd /protheus12/bin/
	tar -xvf appserver.tar.xz
	rm appserver.tar.xz
fi

# Verifica limites de /proc/sys/fs/file-max antes de subir o serviço.
FILE_MAX=$( cat /proc/sys/fs/file-max )
printf -- '-%.0s' {1..69}; printf '\n'
echo "Valor atual de /proc/sys/fs/file-max: $FILE_MAX"
if [[ $FILE_MAX -gt 2147483647 ]]; then
	echo "Tente o comando abaixo, no host, como root, antes de inicializar o container:"
	echo "# echo 2147483647 > /proc/sys/fs/file-max"
elif [[ $FILE_MAX -lt 65536 ]]; then
	echo "Tente o comando abaixo, no host, como root, antes de inicializar o container:"
	echo "# echo 65536 > /proc/sys/fs/file-max"
fi
printf -- '-%.0s' {1..69}; printf '\n'

# Configura e inicia serviço do Protheus.
cd /protheus12/bin/appserver/
sed 's/{{APPSERVER_DATABASE}}/'"${APPSERVER_DATABASE}"'/' -i ./appserver.ini
echo "Inicializando Protheus AppServer $(./appsrvlinux --version) ${APPSERVER_DATABASE}"
# exec: appsrvlinux assume o PID 1 e recebe SIGTERM do "docker stop" (shutdown gracioso).
exec ./appsrvlinux
