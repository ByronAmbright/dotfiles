#!/bin/bash
set -euo pipefail
########################################################################################################################
# Network Related Functions                                                                                            #
########################################################################################################################
ETC_HOSTS="/etc/hosts"

##########################################################################################
# Download Functions.                                                                    #
##########################################################################################

function download_file_if_it_does_not_exist_already() {
  local source_file_path_to_check="$1"
  local target_file_path="$2"
  local download_url="$3"

  if [ ! -f $source_file_path_to_check ]; then
    echo "${source_file_path_to_check} was not found! Downloading dependency to ${target_file_path}"
    sudo wget -O $target_file_path $download_url
  else
    echo "${source_file_path_to_check} was found! No download need."
  fi
}

##########################################################################################
# Ip Related Functions                                                                   #
##########################################################################################

function check_ip_reachable() {
  local ip="$1"

  # Check if IP is reachable
  if ping -c 1 "$ip" > /dev/null 2>&1; then
    echo "IP $ip is reachable"
    return 0
  else
    echo "IP $ip is not reachable"
    return 1
  fi
}

function is_ip_address() {
  local ip=$1
  if [[ $ip =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    IFS='.' read -r -a octets <<< "$ip"
    for octet in "${octets[@]}"; do
      if (( octet < 0 || octet > 255 )); then
        return 1 # Not a valid IP octet
      fi
    done
    return 0 # Valid IP address
  fi
  return 1 # Does not match IP patternbL
}

function get_external_ip_address() {
  dig +short myip.opendns.com @resolver1.opendns.com
  # The following might be a better way if the above is not working consistently 
  # PUBLIC_IP=$(curl -s http://ipinfo.io/ip)
}

##########################################################################################
# System Functions.                                                                      #
##########################################################################################

function add_host() {
    local ip_address="$1"
    local hostname="$2"
    local hosts_line="$ip_address\t$hostname"

    if grep -q -E "^$ip_address\s+$hostname(\s|$)" "$ETC_HOSTS"; then
        echo "Entry '$hosts_line' already exists in $ETC_HOSTS."
    else
        echo "Adding '$hosts_line' to $ETC_HOSTS..."
        sudo -- sh -c -e "echo '$hosts_line' >> $ETC_HOSTS"
        if grep -q -E "^$ip_address\s+$hostname(\s|$)" "$ETC_HOSTS"; then
            echo "Entry added successfully."
        else
            echo "Failed to add entry. Please check permissions or syntax."
        fi
    fi
}

function remove_host() {
    local hostname="$1"

    if grep -q -E "\s+$hostname(\s|$)" "$ETC_HOSTS"; then
        echo "Removing entries for '$hostname' from $ETC_HOSTS..."
        # Create a backup before modifying
        sudo cp "$ETC_HOSTS" "${ETC_HOSTS}.bak"
        sudo sed -i.sedbak "/$hostname/d" "$ETC_HOSTS" && sudo rm -rf "$ETC_HOSTS.sedbak"
        # sudo sed '/$hostname/d' "$ETC_HOSTS"
        if ! grep -q -E "\s+$hostname(\s|$)" "$ETC_HOSTS"; then
            echo "Entries for '$hostname' removed successfully."
        else
            echo "Failed to remove entries for '$hostname'. Please check permissions or syntax."
        fi
    else
        echo "No entries for '$hostname' found in $ETC_HOSTS."
    fi
}

# ================ USAGE ================

# Define ADDRESS_OR_HOST_TO_SET as an environment variable. This can be an ip address or host name
# Define HOSTNAME_TO_SET as an environment variable. This can be any number of hostnames

# Script will remove any previous definition of HOSTNAME_TO_SET and then set it to ADDRESS_OR_HOST_TO_SET
# If ADDRESS_OR_HOST_TO_SET is a hostname, it will attempt to resolve it to its current ip address and use that
# The script will make a backup of the previous definition of /etc/hosts as /etc/hosts.bak just in case

# Example 1: 
# export ADDRESS_OR_HOST_TO_SET=bambright0l.ptcnet.ptc.com
# export HOSTNAME_TO_SET="=vagrant vagrant.ptcnet.ptc.com"
# manageHosts

# Example 2: 
# export ADDRESS_OR_HOST_TO_SET=192.168.1.123 # The local IP of the windows machine on the home network
# export HOSTNAME_TO_SET="vagrant vagrant.ptcnet.ptc.com"
# manageHosts

# ======================================

function manageHosts() {
  # Be sure the ADDRESS_OR_HOST_TO_SET environment variable is set
  if [ -z ${ADDRESS_OR_HOST_TO_SET} ]; then
    echo "ADDRESS_OR_HOST_TO_SET needs to be provided as an environment variable"
    exit 1
  fi

  # Be sure the HOSTNAME_TO_SET environment variable is set
  if [ -z "${HOSTNAME_TO_SET}" ]; then
    echo "HOSTNAME_TO_SET needs to be provided as an environment variable"
    exit 1
  fi

  # IS_IP_ADDRESS_TEST=$(is_ip_address ${ADDRESS_OR_HOST_TO_SET})
  if is_ip_address ${ADDRESS_OR_HOST_TO_SET}; then
      echo "Provided ADDRESS_OR_HOST_TO_SET is already an IP address so using it"
      address_or_host_to_set_ip=${ADDRESS_OR_HOST_TO_SET}
  else
      address_or_host_to_set_ip=$(nslookup ${ADDRESS_OR_HOST_TO_SET} | awk '/^Address: / {print $2}')
  fi

  current_hosts_file_content=$(cat ${ETC_HOSTS})

  echo -e "${ETC_HOSTS} file before changes:\n${current_hosts_file_content}\n\n"
  echo "Setting '${HOSTNAME_TO_SET}' to IP Address: '${address_or_host_to_set_ip}'"

  remove_host "${HOSTNAME_TO_SET}"
  add_host ${address_or_host_to_set_ip} "${HOSTNAME_TO_SET}"
  echo -e "\n"
  current_hosts_file_content=$(cat ${ETC_HOSTS})
  echo -e "${ETC_HOSTS} file updated to:\n${current_hosts_file_content}"
}

function autoSetHostsFileToBasedOnNetwork() {
  echo "Checking Addresses to find which one is reachable"
  ipAddressOrHostThatWorked="";
  if check_ip_reachable $WORK_WINDOWS_LOCAL_NETWORK_ETHERNET_IP_ADDRESS; then
    ipAddressOrHostThatWorked=$WORK_WINDOWS_LOCAL_NETWORK_ETHERNET_IP_ADDRESS
  elif check_ip_reachable $WORK_WINDOWS_LOCAL_NETWORK_WIFI_IP_ADDRESS; then
    ipAddressOrHostThatWorked=$WORK_WINDOWS_LOCAL_NETWORK_WIFI_IP_ADDRESS
  elif check_ip_reachable $WORK_WINDOWS_PTC_NETWORK_HOSTNAME; then
    ipAddressOrHostThatWorked=$WORK_WINDOWS_PTC_NETWORK_HOSTNAME
  else
    echo "Couldn't find IP Address that worked, exiting early"
    return;
  fi

  export ADDRESS_OR_HOST_TO_SET=$ipAddressOrHostThatWorked
  export HOSTNAME_TO_SET=$WORK_HOSTS_LINE_TO_SET

  manageHosts
}


##########################################################################################
# SSH Functions                                                                          #
##########################################################################################

function in_SSH_session() {
  if [[ -z ${SSH_CONNECTION+x} ]]; then
    return 0
  else
    return 1
  fi
}
