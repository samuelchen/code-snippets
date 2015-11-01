# -*- coding: utf-8 -*-
import telnetlib

'''Telnet远程登录：Windows客户端连接Linux服务器'''

#配置选项
Host = '192.168.1.1' # Telnet服务器IP
username = 'root'   # 登录用户名
password = 'admin'  # 登录密码
finish = 'WAP>'
finish_shell = 'WAP(Dopra Linux) # '      # 命令提示符（标识着上一条命令已执行完毕）

# 连接Telnet服务器
tn = telnetlib.Telnet(Host, timeout=3)
tn.set_debuglevel(2)

# 输入登录用户名
tn.read_until('Login:')
tn.write(username + '\n')

# 输入登录密码
tn.read_until('Password:')
tn.write(password + '\n')

# 登录完毕后，执行ls命令
tn.read_until(finish)
tn.write('shell\n')

tn.read_until(finish_shell)
tn.write('grep telecomadmin /mnt/jffs2/hw_ctree.xml\n')

# ls命令执行完毕后，终止Telnet连接（或输入exit退出）
xml = tn.read_until(finish_shell)
tn.write('exit\n')

tn.read_until(finish)
tn.write('quit\n')

tn.close() # tn.write('exit\n'))


# obtain password
i = xml.find('Password=') + 10
p = xml[i:]
j = p.find('"')
p = p[:j]
u = 'telecomadmin'

# login
import urllib,urllib2,cookielib
import base64
p = base64.encode(p)
cj = cookielib.CookieJar()
cj.set_cookie('Cookie=UserName:%s:PassWord:%s:Language::id=-1;path=/')
url_login = 'http://192.168.1.1/login.cgi'
#body = (('logintype','login'), ('u','*****'), ('psw', '******'))
#data = {'Username':u, 'Password':p, 'Language':'', 'id':'-1;path=/'}
#data = urllib.urlencode()
opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders = [('User-agent', 'Opera/9.23')]
urllib2.install_opener(opener)
req=urllib2.Request(url_login)
u=urllib2.urlopen(req)
print u.read().decode('utf-8').encode('gbk')

