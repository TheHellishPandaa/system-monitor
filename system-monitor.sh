#!/bin/bash

# clear the terminal
clear

#show a welcome message.
echo "*******************************************************************"
echo "****** MONITORING CPU, MEMORY, DISK AND NETWORK INFORMATION *******"
echo "*******************************************************************"

echo "To run this script successfully, we must have 'curl' installed, to install 'curl': 'snap install curl' or 'apt install curl'"
echo
#Funcion para ver el nombre de la maquina
get_HOSTNAME() {
        HOSTNAME=$(cat /etc/hostname)
}
# Función para obtener el uso de CPU
get_cpu_usage() {
    echo "CPU USAGE:"
    top -bn1 | grep "Cpu(s)" | \
    awk '{print "CPU en uso: " $2 + $4 "%"}'
}

# Función para obtener el uso de memoria en GB
get_memory_usage() {
    echo "MEMORY USAGE:"

    free -m | grep Mem | awk '{printf "Memoria usada: %.2fGB de %.2fGB\n", $3/1024, $2/1024}'
}

# Función para obtener el uso del disco
get_disk_usage() {
    echo "Disk usage:"
    df -h / | grep / | awk '{print "Disco en uso: " $5 " (" $3 " usados de " $2 ")"}'
}
# Function to get swap memory usage
get_swap_usage() {
    echo "Swap Use:"
    free -m | grep Swap | awk '{printf "Swap usada: %.2fGB de %.2fGB\n", $3/1024, $2/1024}'
}
get_network_interface() {
        #Search the name of a network interface in use.
    interfaz=$(ip route | grep '^default' | awk '{print $5}')
    # If not be search any interfaces
    if [[ -z "$interfaz" ]]; then
        echo "A network interface could not be detected"
        return 1
    fi
 echo "Your network iinteeerface is: $interfaz"
}

# Function to obtain local IP
get_local_ip() {
    echo "IP local:"
    hostname -I 
get_DIR_MAC() {
echo "Dirección MAC"
        # Intentar obtener la interfaz con la ruta por defecto.
        interfaz=$(ip route | grep '^default' | awk '{print $5}')
        #Mostrar la dirección MAC de la interfaz obtenida.
#Con la variable, es mas dinamico, porque cada sistema tendrá una interfaz distinta.
       cat /sys/class/net/$interfaz/address 

}
get_DEFAULT_GATEWAY() {
        echo "Default getewaay"
        ip route show default 
}

# Función para obtener la IP pública
get_public_ip() {
    echo "Públic IP:"
    # Consultamos a un servicio externo para obtener la IP pública
    PUBLIC_IP=$(curl -s ifconfig.me)
        #Ponemos -n al lado de la variable para comprobar que la variable tiene contenido.
        #Si la variable no tiene ningun valor da el mensaje del 2ºndo echo.
if [[ -n  $PUBLIC_IP ]]; then
    echo "public IP: $PUBLIC_IP"
else
        echo "Could not obtain your Public IP Address. Check your Internet connection"

fi
}
get_INTERNET_CONNECTION() {
    echo "Internet Connection:"
   # Check if the Google website is accessible.
    var=$(curl -s --head http://www.google.com | head -n 1)

    #execute a conditional to verify if the internet connection is active, if the variable responds '200 OK', it will tell me that my internet connection is active, if not, it will tell me that there is no connectivity.
    if [[ $var == *"200 OK"* ]]; then
        echo "Internet Connection: Active"
    else
        echo "No internet connection detected. Please check your network adapter and rerun the script."
    fi
}

# show information of the system
echo "-----------------------------------"
echo 
echo "The Hostname of the system is: $HOSTNAME"
echo "-----------------------------------"
get_cpu_usage
echo "-----------------------------------"
get_memory_usage
echo "-----------------------------------"
get_disk_usage
echo "-----------------------------------"
get_swap_usage
echo "-----------------------------------"
get_network_interface
echo "-----------------------------------"
get_local_ip
echo "-----------------------------------"
get_DIR_MAC
echo "-----------------------------------"
get_DEFAULT_GATEWAY
echo "-----------------------------------"
get_public_ip
echo "-----------------------------------"
get_COMPROBAR_INTERNET
echo "-----------------------------------"
