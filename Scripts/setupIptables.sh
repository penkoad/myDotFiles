#!/bin/bash
/etc/init.d/fail2ban stop
echo Setting firewall rules...
#
# config de base
#
# Vider les tables actuelles
iptables -t filter -F
iptables -t filter -X
echo - Vidage : [OK]
 
 
# Autoriser les connexions sur le serveur SSH
iptables -t filter -A INPUT -p tcp --dport 22 -j ACCEPT
echo - Autoriser SSH : [OK]
 
 
# Ne pas casser les connexions etablies
iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
echo - Ne pas casser les connexions établies : [OK]
 
 
# Interdire par défaut toute les connexions
iptables -t filter -P INPUT DROP
iptables -t filter -P FORWARD DROP
iptables -t filter -P OUTPUT DROP
echo - Interdire toute connexion : [OK]
 
 
# Autoriser les requetes DNS, FTP, HTTP, NTP (pour les mises a jour)
iptables -t filter -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -t filter -A OUTPUT -p udp --dport 123 -j ACCEPT
echo - Autoriser les requetes DNS, FTP, HTTP, NTP : [OK]
 
 
# Autoriser les connexions sur l'interface loopback
iptables -t filter -A INPUT -i lo -j ACCEPT
iptables -t filter -A OUTPUT -o lo -j ACCEPT
echo - Autoriser loopback : [OK]
 
 
# Autoriser le ping sur le serveur
iptables -t filter -A INPUT -p icmp -j ACCEPT
iptables -t filter -A OUTPUT -p icmp -j ACCEPT
echo - Autoriser ping : [OK]
 
 
# Gestion des connexions entrantes autorisées
 
# Autoriser les requêtes sur le serveur DNS Bind
iptables -t filter -A INPUT -p udp --dport 53 -j ACCEPT
echo - Autoriser serveur DNS Bind : [OK]
 
 
# Autoriser les requêtes sur le serveur  en mode normal et en mode SSL
iptables -t filter -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 443 -j ACCEPT
echo - Autoriser serveur Apache : [OK]
 
 
#Autoriser les requêtes sur le serveur FTP et le mode passif
modprobe ip_conntrack_ftp
iptables -t filter -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 20 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 50000:50400 -j ACCEPT
iptables -t filter -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
 
echo - Autoriser serveur FTP : [OK]
 
 
# Autoriser les requêtes sur le serveur de Mail
iptables -t filter -A INPUT -p tcp --dport 25 -j ACCEPT
ptables -t filter -A INPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A INPUT -p tcp --dport 143 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 25 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 110 -j ACCEPT
iptables -t filter -A OUTPUT -p tcp --dport 143 -j ACCEPT
echo - Autoriser serveur Mail : [OK]
 
 
#Autoriser les connexion SNMP des serveur de Monitoring du service dedibox
iptables -t filter -A INPUT -i eth0 -s 88.191.254.0/24 -p tcp --dport 161 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A INPUT -i eth0 -s 88.191.254.0/24 -p udp --dport 161 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -o eth0 -d 88.191.254.0/24 -p tcp --sport 161 -m state --state ESTABLISHED -j ACCEPT
iptables -t filter -A OUTPUT -o eth0 -d 88.191.254.0/24 -p udp --sport 161 -m state --state ESTABLISHED -j ACCEPT
echo - connexion Monitoring dedibox avancé: [OK]
 
 
# Empêcher le Syn-Flood
iptables -A FORWARD -p tcp --syn -m limit --limit 1/second -j ACCEPT
iptables -A FORWARD -p udp -m limit --limit 1/second -j ACCEPT
echo - Limiter le Syn-Flood : [OK]
 
 
# Empêcher le spoofing
iptables -N SPOOFED
iptables -A SPOOFED -s 127.0.0.0/8 -j DROP
iptables -A SPOOFED -s 169.254.0.0/12 -j DROP
iptables -A SPOOFED -s 172.16.0.0/12 -j DROP
iptables -A SPOOFED -s 192.168.0.0/16 -j DROP
iptables -A SPOOFED -s 10.0.0.0/8 -j DROP
echo - Bloquer le Spoofing : [OK]
 
# Redémarrer fail2ban
/etc/init.d/fail2ban start
echo Firewall mis a jour avec succes !
