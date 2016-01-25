    #!/bin/bash
    #set -x
    #. /etc/profile
    #################################################
    # 脚本有linux系统实战提供
    # linux系统实战致力于centos redhat linux实战
    # 网址http://www.linuxshizhan.com
    # 该脚本主要修改ip,主机名，网关，dns
    #使用方法: static_ip.sh -e "网卡名如eth0,eth1..." -i "ip" -m "子网掩码" -h "主机名" -d "dns1 dns2..." -g "网关"
    ###############################################
    pid=$
    file_name=`basename $0`
    #dir_name=`dirname $0`
    #echo "file name :$file_name"
    #echo "dir name: $dir_name"
    normal="\033[31;39m"
    red="33[1;35m"
    blue="33[0;36m"
    real_file=`lsof -p $pid |  awk '{print $9}' | grep -e "$file_name" `
    real_path=$(dirname $real_file)
    function Usage()
    {
     echo -e  "$blue使用方法:$normal $red$0 -e "网卡名如eth0,eth1..." -i "ip" -m "子网掩码" -h "主机名" -d "dns1 dns2..." -g "网关" $normal"
    }
    echo -e "$blue 脚本名 $normal $red :$file_name $normal"
    echo -e "$blue 脚本的PID is $normal $red : $pid $normal"
    echo -e "$blue 脚本所在目录 $normal $red: $real_path $normal"
    echo -e "$blue 脚本所在绝对路径 $normal $red : $real_file $normal"
    #echo -e "$blue ################### useage ########### $normal"
    #Usage
    function get_ip(){
    old_ip=$(ifconfig | sed -n '/Bcast/ { s/:/ /g; p }' | awk '{ print $3 }')
    echo -e "$blue本机的IP是：$normal  $red $old_ip$normal"
    }
    function get_mask(){
    old_mask=$(ifconfig | sed -n '/Bcast/p' | sed 's/mask:([0-9]*.[0-9]*.[0-9]*.[0-9]*||).*/1/' | awk -F':' '{print $4}')
    echo -e "$blue本机的子网掩码是：$normal  $red $old_mask$normal"
    }
    function get_gateway(){
    old_gw=$(netstat -nr | sed -n 5p | awk '{print $2}')
    echo -e "$blue本机的网关是：$normal  $red $old_gw $normal"
    }
    function get_hostname(){
    old_hostname=$(hostname)
    echo -e "$blue本机的主机名是：$normal  $red $old_hostname$normal"
    }
    show_all(){
    echo -e "$red重启网络服务,主机名需重启机器才生效哦...： $normal"
    /sbin/service  network restart
    echo -e "$red现在的主机和网卡信息：$normal"
    get_ip;
    get_mask;
    get_gateway;
    get_hostname;
    }
    # Execute getopt
    ARGS=$(getopt  -o e:i:m:h:d:g -l ethn:,ipadress:,mask:,host_name:,dns:,gateway  -- "$@");
    #Bad arguments
    if [ $? -ne 0 ];
    then
      Usage;
      exit 1
    fi
    flag=$(echo $@ | egrep -cv '-e|-i|-m|-d|-h|-g')
    if [ $flag -ne 0 ];
    echo -e "$red输入的信息不符合要求，请看帮助$normal"
    Usage
    then
      Usage;
      exit 1
    fi
    eval set -- "$ARGS";
    while true; do
      case "$1" in
        -e|--ethn)
          shift;
          if [ -n "$1" ]; then
                    # 检查网卡是否存在
                    ##去掉参数前后的空格，非常重要
                   ethn=$(echo "$1"|sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
                   ethn_file=/etc/sysconfig/network-scripts/ifcfg-$ethn
                   if [ -f "$ethn_file" ];then
                       echo "修改的是ethn网卡对应的是这个$ethn_file文件"
                       
                   else
                       echo "$ethn 网卡不存在哦，"
                   fi
            shift;
          else
          echo "参数-e不能为空，即网卡名不能为空"
          exit
          fi
          ;;
        -i|--ipadress)
          shift;
          if [ -n "$1" ]; then
                    ##去掉参数前后的空格，非常重要
                    ipadress=$(echo "$1"|sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
                    sed -i '/IPADDR/d' $ethn_file
                    echo "IPADDR="$ipadress"" >> $ethn_file
            shift;
          else
          echo "参数-i不能为空，即IP不能为空"
          exit      
          fi
          ;;
        -m|--mask)
          shift;
          if [ -n "$1" ]; then
               ##去掉参数前后的空格，非常重要
               mask=$(echo "$1" | sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
               sed -i '/NETMASK/d' $ethn_file
               echo  "NETMASK="$mask"" >> $ethn_file
          shift;
          else
          echo "参数-m不能为空，即mask不能为空"
          exit
          fi
          ;;
        -h|--host_name)
          shift;
          if [ -n "$1" ]; then
                 ##去掉参数前后的空格，非常重要
                 host_name=$(echo "$1"| sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
                 sed -i '/HOSTNAME/d' /etc/sysconfig/network
                 echo "HOSTNAME=$host_name" >> /etc/sysconfig/network
            shift;
          else
          echo "参数-h不能为空，即主机名不能为空"
          exit
          fi
          ;;
        -d|--dns)
          shift;
          if [ -n "$1" ]; then
                 ##去掉参数前后的空格，非常重要
                 dns=$(echo "$1"| sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
                 sed -i '/DNS/d' /etc/sysconfig/network-scripts/ifcfg-eth0
                 printf "$dns"  | sed  's/ /n/g'  | sed 's/^/="/g' | sed 's/$/"/g' | cat -n | sed 's/^[ t]*//g' | sed 's/^/DNS/g' | sed 's/[ t]//g' >> $ethn_file
                 echo "" >> $ethn_file
                 printf "$dns" | sed  's/ /n/g'   | sed 's/^/nameserver /g' > /etc/resolv.conf
            shift;
          else
          echo "参数-d不能为空，即dns不能为空"
          exit
          fi
          ;;
        -g|--gateway)
          shift;
          if [ -n "$1" ]; then
                 ##去掉参数前后的空格，非常重要
                 gateway=$(echo "$1"| sed 's/^[ ]{1,}//;s/[ ]{1,}$//g')
                 sed -i '/GATEWAY/d'  $ethn_file
                 echo "GATEWAY="$gateway"" >>$ethn_file
                 sed -i '/GATEWAY/d' /etc/sysconfig/network 
                 echo "GATEWAY=$gateway" >> /etc/sysconfig/network
          else
          echo "参数-g不能为空，即网关不能为空"
          exit
          fi
          ;;
        --)
          shift;
          break;
          ;;
      esac
    done
    show_all
