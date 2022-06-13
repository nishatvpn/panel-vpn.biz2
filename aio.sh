#!/bin/bash
#OS Version Ubuntu 16
#SSH OVPN SOCKS AUTO SCRIPT
#Build By NISHAT SOFTWARE Solution

NAMEVPN="NishatSoft
";
WEBSCRIPT="panel-vpn.biz";
DBHOST="174.138.183.243";
DBNAME="abolirez_yooy";
DBUSER="abolirez_yooy";
DBPASS="abolirez_yooy";
APISYNCLOGIN="authentication";
APISYNC="firenetdev";
SERVERZ=$(curl -4s http://ipinfo.io/org);
SERVERIPZ=$(curl -4s http://ipinfo.io/ip);
SERVERLCZ=$(curl -4s http://ipinfo.io/country);
Filename_alias="authenticate";

MYIP=$(wget -qO- ipv4.icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";

apt-get update && apt update && apt-get --fix-missing install -y && apt-get autoremove -y && apt-get install mysql-client -y && apt install firewalld -y

curl -s https://swupdate.openvpn.net/repos/repo-public.gpg | apt-key add -

echo "deb http://build.openvpn.net/debian/openvpn/stable xenial main" > /etc/apt/sources.list.d/openvpn-aptrepo.list

apt-get install openvpn privoxy apache2 zip whois ngrep unzip unrar nano iptables dnsutils -y

apt install python-minimal php-mysqli php7.0-cli -y

ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf

cd
sed -i 's/Port 22/Port 22/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 445' /etc/ssh/sshd_config
service ssh restart

cat > /etc/openvpn/server.conf <<-END
dev tun
proto tcp
port 443
sndbuf 393216
rcvbuf 393216
push "sndbuf 393216"
push "rcvbuf 393216"
reneg-sec 432000
push "persist-key"
push "persist-tun"
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh.pem
server 10.8.0.0 255.255.255.0
username-as-common-name
client-cert-not-required
auth-user-pass-verify /etc/openvpn/login.sh via-env
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
client-to-client
keepalive 10 120
comp-lzo
script-security 3
persist-key
persist-tun
status openvpn-status.log
verb 3
END

cat > /etc/openvpn/server2.conf <<-END
dev tun
proto udp
port 110
sndbuf 393216
rcvbuf 393216
push "sndbuf 393216"
push "rcvbuf 393216"
reneg-sec 432000
push "persist-key"
push "persist-tun"
ca /etc/openvpn/ca.crt
cert /etc/openvpn/server.crt
key /etc/openvpn/server.key
dh /etc/openvpn/dh.pem
server 10.9.0.0 255.255.255.0
username-as-common-name
client-cert-not-required
auth-user-pass-verify /etc/openvpn/login.sh via-env
push "redirect-gateway def1 bypass-dhcp"
push "dhcp-option DNS 8.8.8.8"
push "dhcp-option DNS 8.8.4.4"
client-to-client
keepalive 10 120
comp-lzo
script-security 3
persist-key
persist-tun
status openvpn-status2.log
verb 3
END

cat > /etc/rc.local <<-END
#!/bin/sh -e
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "nameserver 8.8.4.4" >> /etc/resolv.conf
iptables -t nat -A POSTROUTING -j SNAT --to-source $(wget -qO- ipv4.icanhazip.com)
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -s 10.9.0.0/24 -o eth0 -j MASQUERADE
END

cat > /etc/openvpn/ca.crt <<-END
-----BEGIN CERTIFICATE-----
MIIFQjCCBCqgAwIBAgIJAJ2gk8rEecedMA0GCSqGSIb3DQEBCwUAMIHGMQswCQYD
VQQGEwJQSDEPMA0GA1UECBMGTWFuaWxhMQ8wDQYDVQQHEwZNYW5pbGExGjAYBgNV
BAoTEVNORlggTmV0IFNvbHV0aW9uMRowGAYDVQQLExFTTkZYIE5ldCBTb2x1dGlv
bjEdMBsGA1UEAxMUU05GWCBOZXQgU29sdXRpb24gQ0ExDzANBgNVBCkTBnNlcnZl
cjEtMCsGCSqGSIb3DQEJARYec3VwcG9ydEBzbmZ4bmV0c29sdXRpb24ub25saW5l
MB4XDTE5MDcyMjE0MTYyNloXDTI5MDcxOTE0MTYyNlowgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmUwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCrYKUuhHpCFB8bcNB8FG054yoqELj2
vFeiEPopxQEBMRrZZDXDOPBNBgsS8UuuNnqEjG9GEuQZ4OnI1JCJi9K+HKPStqUf
Z1hyLCui8Wy2Ek1jtZb6Vvzr1xnGMbtpgsScOzrM8kVRtviYkBBJHFXRWIQo9Ijj
wkwLbyY8W4f75lRizf96RVxPQifaOt0p4YdZ98/wC1AlhIYoJNQJ2JL3HIaxlO66
CjNuUjDtd7AmF38FyxOKBr4XF9TodvQq4DGusdPTIsGtBGf3MYP01pj9S2x+aiKr
kPr7jx6AQuOf/BdwQsBzGIYQnQHXB6DNpEEv0mXcT1tas73p39o6pHcfAgMBAAGj
ggEvMIIBKzAdBgNVHQ4EFgQUYiAzxdIwLp34f0NamgFpret3Pf8wgfsGA1UdIwSB
8zCB8IAUYiAzxdIwLp34f0NamgFpret3Pf+hgcykgckwgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmWCCQCdoJPK
xHnHnTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAPOFiH8JU8EImx
JNU1QBUb+JN6El/yuSydxdAFWNv6/3XKIZ3DECdUZl9mitWomhl5oXjA1xcNqCej
HDZvASmURihFhQs0PPppt+nBlLSGCzBJZF+1HvBqNyspnubbHAR8XDTyUsJkC9O4
oetFIDcoJm4X7n+Qi1B1v42f29KngzbFejXZgZHYT96LZ74Fd+fnIXewkuVy0Beh
mzeIUkCPR9Jp9qe/C8ZpJlwXhtOtVTzVadBaDbxRNKKYjMw0W7qry6e5NlQdi5pQ
z6uEZ5Fkb2kA3G1mo5xGenQX3N3gy1oYJSRn/RQYjMPpDh/7YskMJhb/YtdC3UJ2
Iea/UsVA
-----END CERTIFICATE-----
END

cat > /etc/openvpn/server.crt <<-END
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 1 (0x1)
    Signature Algorithm: sha256WithRSAEncryption
        Issuer: C=PH, ST=Manila, L=Manila, O=SNFX Net Solution, OU=SNFX Net Solution, CN=SNFX Net Solution CA/name=server/emailAddress=support@snfxnetsolution.online
        Validity
            Not Before: Jul 22 14:16:56 2019 GMT
            Not After : Jul 19 14:16:56 2029 GMT
        Subject: C=PH, ST=Manila, L=Manila, O=SNFX Net Solution, OU=SNFX Net Solution, CN=server/name=server/emailAddress=support@snfxnetsolution.online
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    00:96:3c:46:91:a3:b4:f8:30:75:e4:d4:61:09:30:
                    12:45:53:88:97:43:29:26:ec:02:62:1c:87:19:d0:
                    85:16:ab:a9:ad:0e:d7:5d:f4:36:7d:b0:d7:1b:aa:
                    29:7e:f2:bf:91:c5:88:16:42:64:b4:dc:60:59:72:
                    94:d3:21:73:ff:f9:3e:08:40:72:24:43:46:a7:cd:
                    1a:7d:a3:6c:95:7e:2a:60:57:a3:cc:76:81:a5:ed:
                    48:6a:17:ca:e9:a3:73:1a:ee:79:be:5c:01:d4:c9:
                    b0:c6:a2:16:67:15:89:67:27:15:b7:89:8b:96:4a:
                    0f:70:f7:d9:f0:a2:04:87:50:91:3f:43:5f:33:d4:
                    cf:a4:ee:e8:0e:1d:94:2d:fb:5f:0a:34:8e:07:5f:
                    43:5a:86:cb:95:18:2b:5e:23:11:1e:c5:50:2e:0f:
                    04:57:3e:7a:eb:46:19:ff:fa:25:3c:db:8f:31:ad:
                    57:d3:3c:bd:07:67:70:e1:ac:61:98:df:18:13:d4:
                    51:d0:b3:52:a3:98:d4:43:42:4c:37:ee:02:ec:99:
                    ee:b6:aa:3f:8a:18:83:91:1d:cf:8a:1e:0a:a6:95:
                    89:4b:4c:fc:7f:1d:87:d4:28:12:18:1f:95:4e:ca:
                    93:f5:69:46:fd:a2:14:eb:03:18:e2:63:f9:03:c7:
                    12:d3
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints: 
                CA:FALSE
            Netscape Cert Type: 
                SSL Server
            Netscape Comment: 
                Easy-RSA Generated Server Certificate
            X509v3 Subject Key Identifier: 
                40:7A:30:A8:21:25:E0:DD:1B:94:4C:F8:E8:91:64:5A:58:84:D0:0B
            X509v3 Authority Key Identifier: 
                keyid:62:20:33:C5:D2:30:2E:9D:F8:7F:43:5A:9A:01:69:AD:EB:77:3D:FF
                DirName:/C=PH/ST=Manila/L=Manila/O=SNFX Net Solution/OU=SNFX Net Solution/CN=SNFX Net Solution CA/name=server/emailAddress=support@snfxnetsolution.online
                serial:9D:A0:93:CA:C4:79:C7:9D

            X509v3 Extended Key Usage: 
                TLS Web Server Authentication
            X509v3 Key Usage: 
                Digital Signature, Key Encipherment
            X509v3 Subject Alternative Name: 
                DNS:server
    Signature Algorithm: sha256WithRSAEncryption
         71:a6:9a:4a:e2:71:b4:53:39:dc:fe:85:4b:35:39:3e:18:58:
         34:41:ae:56:f5:b9:ae:b2:c3:e7:14:dd:60:e6:9f:2f:12:77:
         01:69:15:ae:6e:f6:29:cd:d2:70:22:8f:ae:68:ce:04:1a:59:
         95:a4:d9:da:c8:06:8a:f1:36:95:de:27:30:aa:25:95:b6:11:
         b8:ac:1f:81:18:2c:70:7f:51:c6:7e:48:ae:5f:11:62:16:27:
         28:27:c4:d7:41:88:63:dc:c8:7f:61:2e:7e:72:13:c7:37:a4:
         ce:bd:81:46:2e:00:16:e5:aa:2e:0d:b5:98:a0:f7:c8:63:ac:
         c4:d0:17:e1:f1:4d:0a:36:48:c5:0a:ce:f8:ce:76:ae:ae:b6:
         d0:32:be:7c:08:56:6d:74:07:60:5b:4c:23:69:12:09:40:57:
         6a:74:34:af:86:58:ff:aa:40:d2:38:55:47:cb:93:4f:40:44:
         a6:15:79:13:f1:f5:23:23:5f:eb:4a:3d:71:bb:1f:22:06:95:
         8e:5a:87:d9:da:86:a6:74:90:1c:05:08:d8:39:98:a5:87:64:
         d7:c0:5f:a5:89:23:c4:00:9a:b1:ca:a0:52:ac:7f:96:d0:39:
         f6:4e:c2:4a:0d:fa:45:52:d9:fa:ff:e3:c0:df:90:ce:52:e4:
         40:79:35:16
-----BEGIN CERTIFICATE-----
MIIFpzCCBI+gAwIBAgIBATANBgkqhkiG9w0BAQsFADCBxjELMAkGA1UEBhMCUEgx
DzANBgNVBAgTBk1hbmlsYTEPMA0GA1UEBxMGTWFuaWxhMRowGAYDVQQKExFTTkZY
IE5ldCBTb2x1dGlvbjEaMBgGA1UECxMRU05GWCBOZXQgU29sdXRpb24xHTAbBgNV
BAMTFFNORlggTmV0IFNvbHV0aW9uIENBMQ8wDQYDVQQpEwZzZXJ2ZXIxLTArBgkq
hkiG9w0BCQEWHnN1cHBvcnRAc25meG5ldHNvbHV0aW9uLm9ubGluZTAeFw0xOTA3
MjIxNDE2NTZaFw0yOTA3MTkxNDE2NTZaMIG4MQswCQYDVQQGEwJQSDEPMA0GA1UE
CBMGTWFuaWxhMQ8wDQYDVQQHEwZNYW5pbGExGjAYBgNVBAoTEVNORlggTmV0IFNv
bHV0aW9uMRowGAYDVQQLExFTTkZYIE5ldCBTb2x1dGlvbjEPMA0GA1UEAxMGc2Vy
dmVyMQ8wDQYDVQQpEwZzZXJ2ZXIxLTArBgkqhkiG9w0BCQEWHnN1cHBvcnRAc25m
eG5ldHNvbHV0aW9uLm9ubGluZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoC
ggEBAJY8RpGjtPgwdeTUYQkwEkVTiJdDKSbsAmIchxnQhRarqa0O1130Nn2w1xuq
KX7yv5HFiBZCZLTcYFlylNMhc//5PghAciRDRqfNGn2jbJV+KmBXo8x2gaXtSGoX
yumjcxrueb5cAdTJsMaiFmcViWcnFbeJi5ZKD3D32fCiBIdQkT9DXzPUz6Tu6A4d
lC37Xwo0jgdfQ1qGy5UYK14jER7FUC4PBFc+eutGGf/6JTzbjzGtV9M8vQdncOGs
YZjfGBPUUdCzUqOY1ENCTDfuAuyZ7raqP4oYg5Edz4oeCqaViUtM/H8dh9QoEhgf
lU7Kk/VpRv2iFOsDGOJj+QPHEtMCAwEAAaOCAaowggGmMAkGA1UdEwQCMAAwEQYJ
YIZIAYb4QgEBBAQDAgZAMDQGCWCGSAGG+EIBDQQnFiVFYXN5LVJTQSBHZW5lcmF0
ZWQgU2VydmVyIENlcnRpZmljYXRlMB0GA1UdDgQWBBRAejCoISXg3RuUTPjokWRa
WITQCzCB+wYDVR0jBIHzMIHwgBRiIDPF0jAunfh/Q1qaAWmt63c9/6GBzKSByTCB
xjELMAkGA1UEBhMCUEgxDzANBgNVBAgTBk1hbmlsYTEPMA0GA1UEBxMGTWFuaWxh
MRowGAYDVQQKExFTTkZYIE5ldCBTb2x1dGlvbjEaMBgGA1UECxMRU05GWCBOZXQg
U29sdXRpb24xHTAbBgNVBAMTFFNORlggTmV0IFNvbHV0aW9uIENBMQ8wDQYDVQQp
EwZzZXJ2ZXIxLTArBgkqhkiG9w0BCQEWHnN1cHBvcnRAc25meG5ldHNvbHV0aW9u
Lm9ubGluZYIJAJ2gk8rEecedMBMGA1UdJQQMMAoGCCsGAQUFBwMBMAsGA1UdDwQE
AwIFoDARBgNVHREECjAIggZzZXJ2ZXIwDQYJKoZIhvcNAQELBQADggEBAHGmmkri
cbRTOdz+hUs1OT4YWDRBrlb1ua6yw+cU3WDmny8SdwFpFa5u9inN0nAij65ozgQa
WZWk2drIBorxNpXeJzCqJZW2EbisH4EYLHB/UcZ+SK5fEWIWJygnxNdBiGPcyH9h
Ln5yE8c3pM69gUYuABblqi4NtZig98hjrMTQF+HxTQo2SMUKzvjOdq6uttAyvnwI
Vm10B2BbTCNpEglAV2p0NK+GWP+qQNI4VUfLk09ARKYVeRPx9SMjX+tKPXG7HyIG
lY5ah9nahqZ0kBwFCNg5mKWHZNfAX6WJI8QAmrHKoFKsf5bQOfZOwkoN+kVS2fr/
48DfkM5S5EB5NRY=
-----END CERTIFICATE-----
END

cat > /etc/openvpn/server.key <<-END
-----BEGIN PRIVATE KEY-----
MIIEuwIBADANBgkqhkiG9w0BAQEFAASCBKUwggShAgEAAoIBAQCWPEaRo7T4MHXk
1GEJMBJFU4iXQykm7AJiHIcZ0IUWq6mtDtdd9DZ9sNcbqil+8r+RxYgWQmS03GBZ
cpTTIXP/+T4IQHIkQ0anzRp9o2yVfipgV6PMdoGl7UhqF8rpo3Ma7nm+XAHUybDG
ohZnFYlnJxW3iYuWSg9w99nwogSHUJE/Q18z1M+k7ugOHZQt+18KNI4HX0NahsuV
GCteIxEexVAuDwRXPnrrRhn/+iU8248xrVfTPL0HZ3DhrGGY3xgT1FHQs1KjmNRD
Qkw37gLsme62qj+KGIORHc+KHgqmlYlLTPx/HYfUKBIYH5VOypP1aUb9ohTrAxji
Y/kDxxLTAgMBAAECggEABIZwQbbCnq8m/et/uL0f78KiXJwDQ07ci4P8dcSYHaSy
Capmxkey1HpdIFIxyccaChP/E1yQl/oDVO5kmS9qxQ0G10zJo1n7aNZ+s8YWYTJZ
qGk7X885/Ht3MOrii8MGlosUU62FyJkCoBkFv7kgWGEPAGY+NBqq+GYexGa86C5z
QQk2E72Zs0icwI5raihWu7aijHFTrOuj+9CAP21ENRLT0utv/z3DsRX/36E7tXpP
/SN0OVz0MJyHfA1xuj7GYLk83pjiXnBJmev/H9mUSEO0ANr8+VGpIE443EZZDgVC
XSKyYQSR1tQVlHGUDT3NBguxjIcilhZsbq5FW1qB4QKBgQDFgxA9mQttZw52mB+U
Sam5NpJv+b7D/Sc8tS3XFDZqEAgzSpa1uQjSYJyZtGifVYqJwG8SBajI8/JhSy0r
nZ0TSYjxi30oRPKp9V2uGU3Ennmr7vI2kEv1hnX6Bx21uOQC8jihoS6xtVWDojjX
c4OpaA2tRJm6zaJGVYWoSMl5+wKBgQDCuUlK+w4wlkgv8pkbkd7jz05Oan+Kvrn2
LOLMpYux6Det6QM2JibAz/RVzmheYwi5xuiA1Xc4m0Zci74B41Sc2N5+HpjcYvko
uIwJQpZevzbKnlmlVk//pp9iBt1nS84Bf5afYMrulFPuGayT/crm8N0UYH+EwKbJ
EdXATxwLCQJ/bANA3m7T0QCK6FBI9M9UAfXWH2Z07LmEu65ZY0WqfFZIJcSkpryK
FoK/IU+H55rgKHUUSMbPhxXhd1OlYDTRsbqFKZMe3ubVzhxhHtS3ss73uw7xZuWC
pMLjwdgiZz61cucEEWAUKRsBqPsOGsURO5Or5xWc/It4Mv6SGXW0uQKBgDpgD5/h
2aQpOWTeZpYESfyjhkct2CSA/wDU/fz52AIyqpaBV0whbda5wPcEVPeO2uvOvJ76
363hpttRrVmljBUlUrYeeBcBuM5DXP/drXSkAEoH5LoTQRJUIk3h3vf7mruKQ15u
Rwf1AaBMpBcNq4lGRhC4ySHEG3wF072+OZr5AoGBAL4B/4TJDFNfDX9SQYPX9NpK
PIkq+H341b/dVTAAUWMhI0iwdZez+jTpxBwMf+jlixZcbR2UL3OijsYqoVL1tRjl
RaTSYjE9VRJdyiHrO9LQOt0a2DOgnQBe+6jglf6x2xSQaXvW5L1QVRG1xR29tnXw
1e5bxrr55KcZT/srvbUq
-----END PRIVATE KEY-----
END

# Generating openvpn dh.pem file using openssl
openssl dhparam -out /etc/openvpn/dh.pem 1024
 
cat > /etc/privoxy/config <<-END
user-manual /usr/share/doc/privoxy/user-manual
confdir /etc/privoxy
logdir /var/log/privoxy
filterfile default.filter
logfile logfile
listen-address 0.0.0.0:8118
toggle 1
enable-remote-toggle 0
enable-remote-http-toggle 0
enable-edit-actions 0
enforce-blocks 0
buffer-limit 4096
enable-proxy-authentication-forwarding 1
forwarded-connect-retries 1
accept-intercepted-requests 1
allow-cgi-request-crunching 1
split-large-forms 0
keep-alive-timeout 5
tolerate-pipelining 1
socket-timeout 300
permit-access 0.0.0.0/0 $(wget -qO- ipv4.icanhazip.com)
END

systemctl enable firewalld
systemctl start firewalld
NIC=$(ip route get 8.8.8.8 | awk 'NR==1 {print $(NF-2)}')
firewall-cmd --get-active-zones
firewall-cmd --quiet --zone=public --permanent --add-port=1-65534/tcp
firewall-cmd --quiet --zone=public --permanent --add-port=1-65534/udp
firewall-cmd --zone=trusted --add-service openvpn
firewall-cmd --zone=trusted --add-service openvpn --permanent
firewall-cmd --list-services --zone=trusted
firewall-cmd --add-masquerade
firewall-cmd --permanent --add-masquerade
firewall-cmd --query-masquerade
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.8.0.0/24 -o "$NIC" -j MASQUERADE
firewall-cmd --permanent --direct --passthrough ipv4 -t nat -A POSTROUTING -s 10.9.0.0/24 -o "$NIC" -j MASQUERADE
firewall-cmd --zone=public --permanent --add-port=8118/tcp # Privoxy
firewall-cmd --zone=public --permanent --add-port=7777/tcp # Magic Proxy
firewall-cmd --zone=public --permanent --add-port=8888/tcp # Magic Proxy
firewall-cmd --zone=public --permanent --add-port=8080/tcp # Squid Proxy
firewall-cmd --zone=public --permanent --add-port=9999/tcp # Squid Proxy
firewall-cmd --zone=public --permanent --add-port=444/tcp # Dropbear SSL
firewall-cmd --zone=public --permanent --add-port=443/tcp # OpenVPN TCP
firewall-cmd --zone=public --permanent --add-port=442/tcp # Dropbear SSL
firewall-cmd --zone=public --permanent --add-port=110/udp # OpenVPN UDP
firewall-cmd --zone=public --permanent --add-port=143/tcp # Dropbear
firewall-cmd --zone=public --permanent --add-port=3128/tcp # Dropbear
firewall-cmd --reload

# install dropbear
apt-get install dropbear -y
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=3128/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 143"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
service ssh restart
service dropbear restart

# OpenVPN Login
cd ~
wget -O /etc/openvpn/login.sh "https://raw.githubusercontent.com/nishatvpn/allinone/main/login.sh"
sed -i 's/\r$//' /etc/openvpn/login.sh
echo \> Done!
sleep 1
clear
chmod 755 /etc/openvpn/*
chmod 755 /etc/openvpn/login.sh
sed -i "s/APILink/$WEBSCRIPT/g" /etc/openvpn/login.sh
sed -i "s/APIKey/$APISYNC/g" /etc/openvpn/login.sh
sed -i "s/authKey/$APISYNCLOGIN/g" /etc/openvpn/login.sh

## Setting Permission
chmod 755 /etc/openvpn/*
chmod 755 /etc/openvpn/login.sh

## Download & Setup SOCKS Proxy
apt-get install screen -y
wget -O /root/socksDirect.py "https://raw.githubusercontent.com/nishatvpn/allinone/main/socksDirect.py"
chmod +x /root/socksDirect.py
screen -d -m python socksDirect.py

wget -O /root/socksDirect2.py "https://raw.githubusercontent.com/nishatvpn/allinone/main/socksDirect2.py"
chmod +x /root/socksDirect2.py
screen -d -m python socksDirect2.py

#### Setting up SSH CRON jobs for panel
cat <<'SSHPanel1' > "/etc/$Filename_alias.cron.php"
<?php
error_reporting(E_ERROR | E_PARSE);
ini_set('display_errors', '1');

$DB_host = 'DatabaseHost';
$DB_user = 'DatabaseUser';
$DB_pass = 'DatabasePass';
$DB_name = 'DatabaseName';

$mysqli = new MySQLi($DB_host,$DB_user,$DB_pass,$DB_name);
if ($mysqli->connect_error) {
    die('Error : ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
}

function encrypt_key($paswd)
    {
      $mykey=getEncryptKey();
      $encryptedPassword=encryptPaswd($paswd,$mykey);
      return $encryptedPassword;
    }
     
    function decrypt_key($paswd)
    {
      $mykey=getEncryptKey();
      $decryptedPassword=decryptPaswd($paswd,$mykey);
      return $decryptedPassword;
    }
     
    function getEncryptKey()
    {
        $secret_key = md5('raxel');
        $secret_iv = md5('gumboc');
        $keys = $secret_key . $secret_iv;
        return encryptor('encrypt', $keys);
    }
    function encryptPaswd($string, $key)
    {
      $result = '';
      for($i=0; $i<strlen ($string); $i++)
      {
        $char = substr($string, $i, 1);
        $keychar = substr($key, ($i % strlen($key))-1, 1);
        $char = chr(ord($char)+ord($keychar));
        $result.=$char;
      }
        return base64_encode($result);
    }
     
    function decryptPaswd($string, $key)
    {
      $result = '';
      $string = base64_decode($string);
      for($i=0; $i<strlen($string); $i++)
      {
        $char = substr($string, $i, 1);
        $keychar = substr($key, ($i % strlen($key))-1, 1);
        $char = chr(ord($char)-ord($keychar));
        $result.=$char;
      }
     
        return $result;
    }
    
    function encryptor($action, $string) {
        $output = false;

        $encrypt_method = "AES-256-CBC";
        $secret_key = md5('raxel gumboc');
        $secret_iv = md5('gumboc raxel');

        $key = hash('sha256', $secret_key);
        
        $iv = substr(hash('sha256', $secret_iv), 0, 16);

        if( $action == 'encrypt' ) {
            $output = openssl_encrypt($string, $encrypt_method, $key, 0, $iv);
            $output = base64_encode($output);
        }
        else if( $action == 'decrypt' ){
            $output = openssl_decrypt(base64_decode($string), $encrypt_method, $key, 0, $iv);
        }

        return $output;
    }

$data = '';
$data2 = '';
$data3 = '';
$data4 = '';
$data5 = '';

$user_durationx = "user_duration = 0";

$query = $mysqli->query("SELECT * FROM users
WHERE user_duration > 0 ORDER by user_id DESC");

if($query->num_rows > 0)
{
    while($row = $query->fetch_assoc())
    {
        $data .= '';
        $username = $row['user_name'];
        $password = $row['user_pass'];
        $data .= '/usr/sbin/useradd -p $(openssl passwd -1 '.$password.') -s /bin/false -M '.$username.' &> /dev/null;'.PHP_EOL;
    }
}

$query2 = $mysqli->query("SELECT * FROM users 
WHERE ".$user_durationx." ORDER by user_id DESC");
if($query2->num_rows > 0)
{
    while($row2 = $query2->fetch_assoc())
    {
        $data2 .= '';
        $toadd2 = $row2['user_name'];    
        $data2 .= '/usr/sbin/userdel -r -f '.$toadd2.' &> /dev/null;'.PHP_EOL;
    }
}

$query3 = $mysqli->query("SELECT * FROM users 
WHERE is_freeze=1 ORDER by user_id DESC");
if($query3->num_rows > 0)
{
    while($row3 = $query3->fetch_assoc())
    {
        $data3 .= '';
        $toadd3 = $row3['user_name'];    
        $data3 .= '/usr/sbin/userdel -r -f '.$toadd3.' &> /dev/null;'.PHP_EOL;
    }
}

$query4 = $mysqli->query("SELECT * FROM delete_users ORDER by user_id DESC");
if($query4->num_rows > 0)
{
    while($row4 = $query4->fetch_assoc())
    {
        $data4 .= '';
        $toadd4 = $row4['user_name'];    
        $data4 .= '/usr/sbin/userdel -r -f '.$toadd4.' &> /dev/null;'.PHP_EOL;
    }
}

$query5 = $mysqli->query("SELECT * FROM users WHERE user_update > 0 ORDER by user_id DESC");
if($query5->num_rows > 0)
{
    while($row5 = $query5->fetch_assoc())
    {
        $data5 .= '';
        $toadd5 = $row5['user_name'];    
        $data5 .= '/usr/sbin/userdel -r -f '.$toadd5.' &> /dev/null;'.PHP_EOL;
    }
}

$location = '/etc/openvpn/active.sh';
$fp = fopen($location, 'w');
fwrite($fp, $data) or die("Unable to open Active file!");
fclose($fp);

$location2 = '/etc/openvpn/inactive.sh';
$fp2 = fopen($location2, 'w');
fwrite($fp2, $data2) or die("Unable to open InActive file!");
fclose($fp2);

$location3 = '/etc/openvpn/freeze.sh';
$fp3 = fopen($location3, 'w');
fwrite($fp3, $data3) or die("Unable to open Freeze file!");
fclose($fp3);

$location4 = '/etc/openvpn/delete.sh';
$fp4 = fopen($location4, 'w');
fwrite($fp4, $data4) or die("Unable to open Delete file!");
fclose($fp4);

$location5 = '/etc/openvpn/userupdate.sh';
$fp5 = fopen($location5, 'w');
fwrite($fp5, $data5) or die("Unable to open User Update file!");
fclose($fp5);

$mysqli->close();

?>
SSHPanel1

cd ~
wget -O /root/update.sh "https://raw.githubusercontent.com/nishatvpn/allinone/main/update.sh"
sed -i 's/\r$//' /root/update.sh
dos2unix /root/update.sh
chmod +x /root/update.sh
echo \> Done!
sleep 1
clear

chmod 755 /etc/openvpn/*
chmod 755 /etc/openvpn/login.sh
chmod 755 /etc/openvpn/server.conf
chmod 755 /etc/openvpn/server2.conf

sed -i "s|DatabaseHost|$DBHOST|g" "/etc/$Filename_alias.cron.php"
sed -i "s|DatabaseName|$DBNAME|g" "/etc/$Filename_alias.cron.php"
sed -i "s|DatabaseUser|$DBUSER|g" "/etc/$Filename_alias.cron.php"
sed -i "s|DatabasePass|$DBPASS|g" "/etc/$Filename_alias.cron.php"

crontab -r
crontab -l | { cat; echo "* * * * * bash update.sh"; } | crontab -
crontab -l | { cat; echo "* * * * * fuser -f -k 7777/tcp && screen -dmS proxy python socksDirect.py 7777"; } | crontab -
crontab -l | { cat; echo "* * * * * fuser -f -k 8888/tcp && screen -dmS proxy python socksDirect2.py 8888"; } | crontab -
crontab -l | { cat; echo "@reboot /usr/bin/python /root/socksDirect.py
* * * * * /root/check.sh"; } | crontab -
crontab -l | { cat; echo "@reboot /usr/bin/python /root/socksDirect2.py
* * * * * /root/check.sh"; } | crontab -
crontab -l | { cat; echo "* * * * * sudo pkill dropbear && sudo /etc/init.d/dropbear restart"; } | crontab -
crontab -l | { cat; echo "0 0 * * * sleep 5 && reboot"; } | crontab -

# Disabled SSH Multiple Login
wget -O /home/multilogin "https://raw.githubusercontent.com/nishatvpn/allinone/main/multilogin"
chmod 755 /home/multilogin
echo -e "* \t * *\troot bash /home/multilogin 1" >> "/etc/cron.d/multilogin"

cat <<'Startupnishat' > /etc/profile.d/nishat.sh
clear
echo -e "\n NISHAT Server Script"
echo -e " UBUNTU16 | OPENVPN / SSH / SSL / SOCKS"
echo -e " Server ISP: $(curl -4s http://ipinfo.io/org)"
echo -e " Server IP Address: $(curl -4s http://ipinfo.io/ip)"
echo -e " Server Location: $(curl -4s http://ipinfo.io/country)"
echo -e " For commands and assistance, ask FirenetDev - [DEVELOPER] for more details.\n"
echo -e " Powered by NISHAT | COPYRIGHT 2022\n"
Startupnishat
chmod a+x /etc/profile.d/nishat.sh
clear

# install stunnel4 From Premium Script
apt-get install stunnel4 -y
wget -O /etc/stunnel/stunnel.pem "https://raw.githubusercontent.com/nishatvpn/allinone/main/stunnel.pem"
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/nishatvpn/allinone/main/stunnel.conf"
sed -i "$MYIP2" /etc/stunnel/stunnel.conf
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
service stunnel4 restart

# install ddos deflate
cd
apt-get install dnsutils dsniff -y
wget -O /root/ddos-deflate-master.zip "https://github.com/nishatvpn/allinone/blob/main/ddos-deflate-master.zip?raw=true"
unzip ddos-deflate-master.zip
cd ddos-deflate-master
bash ./install.sh
rm -rf /root/ddos-deflate-master.zip
cd
clear

cd /root/
touch check.sh
echo "#!/bin/bash

memfree=$(cat /proc/meminfo | grep MemFree | awk '{print $2}');
tostop=3000000

if [ ""$memfree"" -lt ""$tostop"" ];
then
  echo 'Good shape';
else
  echo 'Bad shape';
  /sbin/shutdown -r now
fi" >> check.sh
chmod +x check.sh

chmod +x /etc/openvpn/*
apt-get install apache2
systemctl enable apache2
systemctl restart apache2
systemctl enable privoxy
systemctl restart privoxy
systemctl enable cron
systemctl restart cron
service ssh restart

rm -f /var/www/html/index.html
touch /var/www/html/index.html
echo "<!DOCTYPE html>
<html>
<head>
<title>$NAMEVPN</title>
<style>
h1 {
  border: 5px solid gray;
}

div {
  border: 4px double;
  font-size: 30px;
}

b {
    color: green;
}
</style>
</head>
<body>

<h1><center>$NAMEVPN</center></h1>

<div>Real Time : <b><iframe src='https://free.timeanddate.com/clock/i6nv8h9a/n145/tlph/fcfff/tct/pct/ftb/th2' style='background-color: gray;' frameborder='0' width='150' height='18' allowTransparency='hidden'></iframe></b></div>
<hr>
<div>Script OS : UBUNTU SCRIPT / $SERVERZ</div>
<div>Server IP Address : $SERVERIPZ</div>
<div>Server Location : $SERVERLCZ</div>
<hr>
<div>Server Information</div>
<div>SSH Port : <b>22, 445</b></div>
<div>SSH SSL Port : <b>444</b></div>
<div>OVPN SSL Port : <b>442</b></div>
<div>TCP Port : <b>443</b></div>
<div>UDP Port : <b>110</b></div>
<div>Dropbear Port : <b>143, 3128</b></div>
<div>Squid Port : <b>8080, 9999</b></div>
<div>Privoxy Port : <b>8118</b></div>
<div>Magic Proxy : <b>7777</b></div>
<hr>
<div>OpenVPN Client Configuration</div>
<div>Click <a href='client-tcp.ovpn' download>Here</a> to download TCP Config</div>
<div>Click <a href='client-udp.ovpn' download>Here</a> to download UDP Config</div>
<hr>
<div>Experiment Features</div>
<div>DDOS Protection : <b><font color='red'>Enable</font></b></div>
<div>SSH Protection : <b><font color='red'>Enable</font></b></div>
<div>Anti MultiLogin SSH : <b><font color='red'>Enable</font></b></div>
<hr>
<div>Developed by <b>Nishat</b> | Bograwebhost</div>

</body>
</html>" >> /var/www/html/index.html

touch /var/www/html/client-tcp.ovpn
echo "
#### NISHAT SCRIPT INSTALLER ####
## Created by : Bograwebhost ##
###############################

client
dev tun
proto tcp
remote $SERVERIPZ 443
http-proxy $SERVERIPZ 8080
nobind
sndbuf 0
rcvbuf 0
auth-user-pass
comp-lzo
keepalive 5 60 
reneg-sec 432000
verb 3
script-security 3
setenv CLIENT_CERT 0
<ca>
-----BEGIN CERTIFICATE-----
MIIFQjCCBCqgAwIBAgIJAJ2gk8rEecedMA0GCSqGSIb3DQEBCwUAMIHGMQswCQYD
VQQGEwJQSDEPMA0GA1UECBMGTWFuaWxhMQ8wDQYDVQQHEwZNYW5pbGExGjAYBgNV
BAoTEVNORlggTmV0IFNvbHV0aW9uMRowGAYDVQQLExFTTkZYIE5ldCBTb2x1dGlv
bjEdMBsGA1UEAxMUU05GWCBOZXQgU29sdXRpb24gQ0ExDzANBgNVBCkTBnNlcnZl
cjEtMCsGCSqGSIb3DQEJARYec3VwcG9ydEBzbmZ4bmV0c29sdXRpb24ub25saW5l
MB4XDTE5MDcyMjE0MTYyNloXDTI5MDcxOTE0MTYyNlowgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmUwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCrYKUuhHpCFB8bcNB8FG054yoqELj2
vFeiEPopxQEBMRrZZDXDOPBNBgsS8UuuNnqEjG9GEuQZ4OnI1JCJi9K+HKPStqUf
Z1hyLCui8Wy2Ek1jtZb6Vvzr1xnGMbtpgsScOzrM8kVRtviYkBBJHFXRWIQo9Ijj
wkwLbyY8W4f75lRizf96RVxPQifaOt0p4YdZ98/wC1AlhIYoJNQJ2JL3HIaxlO66
CjNuUjDtd7AmF38FyxOKBr4XF9TodvQq4DGusdPTIsGtBGf3MYP01pj9S2x+aiKr
kPr7jx6AQuOf/BdwQsBzGIYQnQHXB6DNpEEv0mXcT1tas73p39o6pHcfAgMBAAGj
ggEvMIIBKzAdBgNVHQ4EFgQUYiAzxdIwLp34f0NamgFpret3Pf8wgfsGA1UdIwSB
8zCB8IAUYiAzxdIwLp34f0NamgFpret3Pf+hgcykgckwgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmWCCQCdoJPK
xHnHnTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAPOFiH8JU8EImx
JNU1QBUb+JN6El/yuSydxdAFWNv6/3XKIZ3DECdUZl9mitWomhl5oXjA1xcNqCej
HDZvASmURihFhQs0PPppt+nBlLSGCzBJZF+1HvBqNyspnubbHAR8XDTyUsJkC9O4
oetFIDcoJm4X7n+Qi1B1v42f29KngzbFejXZgZHYT96LZ74Fd+fnIXewkuVy0Beh
mzeIUkCPR9Jp9qe/C8ZpJlwXhtOtVTzVadBaDbxRNKKYjMw0W7qry6e5NlQdi5pQ
z6uEZ5Fkb2kA3G1mo5xGenQX3N3gy1oYJSRn/RQYjMPpDh/7YskMJhb/YtdC3UJ2
Iea/UsVA
-----END CERTIFICATE-----
</ca>" >> /var/www/html/client-tcp.ovpn

touch /var/www/html/client-udp.ovpn
echo "
#### NISHAT SCRIPT INSTALLER ####
## Created by : Bograwebhost ##
###############################

client
dev tun
proto udp
remote $SERVERIPZ 110
nobind
sndbuf 0
rcvbuf 0
auth-user-pass
comp-lzo
keepalive 5 60 
reneg-sec 432000
verb 3
script-security 3
setenv CLIENT_CERT 0
<ca>
-----BEGIN CERTIFICATE-----
MIIFQjCCBCqgAwIBAgIJAJ2gk8rEecedMA0GCSqGSIb3DQEBCwUAMIHGMQswCQYD
VQQGEwJQSDEPMA0GA1UECBMGTWFuaWxhMQ8wDQYDVQQHEwZNYW5pbGExGjAYBgNV
BAoTEVNORlggTmV0IFNvbHV0aW9uMRowGAYDVQQLExFTTkZYIE5ldCBTb2x1dGlv
bjEdMBsGA1UEAxMUU05GWCBOZXQgU29sdXRpb24gQ0ExDzANBgNVBCkTBnNlcnZl
cjEtMCsGCSqGSIb3DQEJARYec3VwcG9ydEBzbmZ4bmV0c29sdXRpb24ub25saW5l
MB4XDTE5MDcyMjE0MTYyNloXDTI5MDcxOTE0MTYyNlowgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmUwggEiMA0G
CSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCrYKUuhHpCFB8bcNB8FG054yoqELj2
vFeiEPopxQEBMRrZZDXDOPBNBgsS8UuuNnqEjG9GEuQZ4OnI1JCJi9K+HKPStqUf
Z1hyLCui8Wy2Ek1jtZb6Vvzr1xnGMbtpgsScOzrM8kVRtviYkBBJHFXRWIQo9Ijj
wkwLbyY8W4f75lRizf96RVxPQifaOt0p4YdZ98/wC1AlhIYoJNQJ2JL3HIaxlO66
CjNuUjDtd7AmF38FyxOKBr4XF9TodvQq4DGusdPTIsGtBGf3MYP01pj9S2x+aiKr
kPr7jx6AQuOf/BdwQsBzGIYQnQHXB6DNpEEv0mXcT1tas73p39o6pHcfAgMBAAGj
ggEvMIIBKzAdBgNVHQ4EFgQUYiAzxdIwLp34f0NamgFpret3Pf8wgfsGA1UdIwSB
8zCB8IAUYiAzxdIwLp34f0NamgFpret3Pf+hgcykgckwgcYxCzAJBgNVBAYTAlBI
MQ8wDQYDVQQIEwZNYW5pbGExDzANBgNVBAcTBk1hbmlsYTEaMBgGA1UEChMRU05G
WCBOZXQgU29sdXRpb24xGjAYBgNVBAsTEVNORlggTmV0IFNvbHV0aW9uMR0wGwYD
VQQDExRTTkZYIE5ldCBTb2x1dGlvbiBDQTEPMA0GA1UEKRMGc2VydmVyMS0wKwYJ
KoZIhvcNAQkBFh5zdXBwb3J0QHNuZnhuZXRzb2x1dGlvbi5vbmxpbmWCCQCdoJPK
xHnHnTAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQAPOFiH8JU8EImx
JNU1QBUb+JN6El/yuSydxdAFWNv6/3XKIZ3DECdUZl9mitWomhl5oXjA1xcNqCej
HDZvASmURihFhQs0PPppt+nBlLSGCzBJZF+1HvBqNyspnubbHAR8XDTyUsJkC9O4
oetFIDcoJm4X7n+Qi1B1v42f29KngzbFejXZgZHYT96LZ74Fd+fnIXewkuVy0Beh
mzeIUkCPR9Jp9qe/C8ZpJlwXhtOtVTzVadBaDbxRNKKYjMw0W7qry6e5NlQdi5pQ
z6uEZ5Fkb2kA3G1mo5xGenQX3N3gy1oYJSRn/RQYjMPpDh/7YskMJhb/YtdC3UJ2
Iea/UsVA
-----END CERTIFICATE-----
</ca>" >> /var/www/html/client-udp.ovpn

clear

sudo echo

#Add Trusty Sources
sudo touch /etc/apt/sources.list.d/trusty_sources.list
echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty main universe" | sudo tee --append /etc/apt/sources.list.d/trusty_sources.list > /dev/null

#Update
sudo apt update

#Install Squid
sudo apt install squid3=3.3.8-1ubuntu6 squid=3.3.8-1ubuntu6 squid3-common=3.3.8-1ubuntu6 -y

#Install missing init.d script
curl -O https://raw.githubusercontent.com/nishatvpn/allinone/main/squid3
sudo cp squid3 /etc/init.d/
sudo chmod +x /etc/init.d/squid3
sudo update-rc.d squid3 defaults
chmod +x /etc/init.d/squid3
sed -i -e 's/\r$//' /etc/init.d/squid3

#Start squid
sudo service squid3 start

cat > /etc/squid3/squid.conf <<-END
access_log none
http_port 8080
http_port 9999
acl to_vpn dst all
via off
forwarded_for off
http_access allow all
request_header_access Authorization allow all
request_header_access WWW-Authenticate allow all
request_header_access Proxy-Authorization allow all
request_header_access Proxy-Authenticate allow all
request_header_access Cache-Control allow all
request_header_access Content-Encoding allow all
request_header_access Content-Length allow all
request_header_access Content-Type allow all
request_header_access Date allow all
request_header_access Expires allow all
request_header_access Host allow all
request_header_access If-Modified-Since allow all
request_header_access Last-Modified allow all
request_header_access Location allow all
request_header_access Pragma allow all
request_header_access Accept allow all
request_header_access Accept-Charset allow all
request_header_access Accept-Encoding allow all
request_header_access Accept-Language allow all
request_header_access Content-Language allow all
request_header_access Mime-Version allow all
request_header_access Retry-After allow all
request_header_access Title allow all
request_header_access Connection allow all
request_header_access Proxy-Connection allow all
request_header_access User-Agent allow all
request_header_access Cookie allow all
request_header_access All deny all
END

sudo service squid3 stop
sudo service squid3 start

rm -f installer.sh*
sleep 3
reboot
exit 1
