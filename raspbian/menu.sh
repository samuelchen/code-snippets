#/bin/sh

menu() {
  echo '
  ============================================================
  | Utility Menu                                             |
  | 1. kodi (xbmc media center)                              |
  | 2. links (browser with gui)                              |
  | 3. w3m (browser w/o gui)                                 |
  |----------------------------------------------------------|
  | w. WIFI list (iwlist scan)                               |
  | x. WIFI connect (need sudo)                              |
  | y. bluetooth config (bluetoothctl)                       |
  | z. Raspberry PI config (sudo raspi-config)               |
  | 0. exit                                                  | 
  ============================================================
  '
  read choice
  
  case $choice in
  
  0)
  exit 0
  ;;
  
  1)
  echo "starting kodi..."
  kodi
  ;;

  2)
  links
  ;;

  3)
  echo "Enter the URL for w3m:"
  read w3m_url
  w3m $w3m_url
  ;;
  
  w)
  iwlist scan
  ;;
  
  x)
  wifi_connect
  ;;

  y)
  echo '
  bluetoothctl basic commands:
    help		- show commands
    list 		- list controllers
    power on 		- power on bluetooth device
    power off 		- 
    scan on 		- scan devices
    agent on 		- to register agent (need to be on before pair)
    pair <DEVICE ID> 	- pair a device
    trust <DEVICE ID> 	- trust a device
    connect <DEVICE ID> - connect to a device
    quit		- quit
  
  Common steps to connect a device:
    power on -> scan on -> agent on -> pair -> (optional) trust -> connect -> quit
  '
  bluetoothctl
  ;;

  z)
  sudo raspi-config
  ;;
  
  *)
  echo "Incorrect choice. Please select again."
  
  esac
  
  menu
}

wifi_connect() {
  echo "Enter WIFI SSID (name):"
  read wifi_ssid
  echo "Enter WIFI password:"
  read wifi_pwd

  echo '
  network={
    ssid="'${wifi_ssid}'" 
    psk="'${wifi_pwd}'"
  }' |sudo tee -a /etc/wpa_supplicant/wpa_supplicant.conf >/dev/null
  echo "WIFI $wifi_ssid added."
}

menu


