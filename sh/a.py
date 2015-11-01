

u = 'telecomadmin'
p = 'telecomadmin63870586'


def base64encode(s):
    len = str.length;
    i = 0;
    out = "";

    while i < len:
        c1 = str.charCodeAt(i++) & 0xff;
        if i == len:
            out += base64EncodeChars[c1 >> 2]
            out += base64EncodeChars.charAt[(c1 & 0x3) << 4]
            out += "=="
            break

c2 = str.charCodeAt(i++);
if (i == len) {
out += base64EncodeChars.charAt(c1 >> 2);
out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
out += base64EncodeChars.charAt((c2 & 0xF) << 2);
out += "=";
break;
}
c3 = str.charCodeAt(i++);
out += base64EncodeChars.charAt(c1 >> 2);
out += base64EncodeChars.charAt(((c1 & 0x3) << 4) | ((c2 & 0xF0) >> 4));
out += base64EncodeChars.charAt(((c2 & 0xF) << 2) | ((c3 & 0xC0) >> 6));
out += base64EncodeChars.charAt(c3 & 0x3F);
}
return out;
}

# login
import tempfile
import urllib,urllib2,cookielib
import base64

p = base64.b64encode(p)
f = tempfile.NamedTemporaryFile(prefix='cookie_', suffix='.txt')
s = 'Cookie=UserName:%s:PassWord:%s:Language:chinese:id=-1' % (u, p)
print s
f.write(s)
fn = f.name

cj = cookielib.FileCookieJar(fn)
url_login = 'http://192.168.1.1/login.cgi'
opener=urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
opener.addheaders = [('User-agent', 'Opera/9.23')]

urllib2.install_opener(opener)
req=urllib2.Request(url_login)
resp=urllib2.urlopen(req)

req=urllib2.Request('http://192.168.1.1/html/status/networkinfo.asp')
resp = urllib2.urlopen(req)
print resp.read().decode('utf-8').encode('gbk')


f.close()
del f
