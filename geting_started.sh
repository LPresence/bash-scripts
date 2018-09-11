#!/bin/bash

###############################################################
#On récupère toutes les variables nécéssaires ici
###############################################################

read -p "Nom d'utilisateur : " username
read -s -p "Mot de passe : " password
read -p "Ip du rebond : " ipRebond

###############################################################
#On met a jour et on installe tout le bouzin
###############################################################

echo "Mise a jour du système et installation des paquets de base"
apt-get -qq update && apt-get -qq upgrade && apt-get -qq --yes --force-yes install vim openssh-client openssh-server qemu-guest-agent git ncdu

###############################################################
#
###############################################################



###############################################################
#Creation d'un utilisateur avec droits sudo
###############################################################

echo "Création de l'utilisateur demandé et attribution des droits sudo"
egrep "^$username" /etc/passwd >/dev/null
if [ $? -eq 0 ]; then
        echo "$username existe déja!"
        exit 1
else
        pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
        useradd -m -d /home/$username -s /bin/bash -p $pass $username
        [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
fi

#ajout aux sudoers en dessous de l'utilisateur root
sed -i "/^root/a$username\tALL=(ALL)\tALL" /etc/sudoers

###############################################################
#Configuration ssh
###############################################################

echo "Configuration du serveur ssh"
sshd_path="/etc/ssh/sshd_config"
sed -i 's/^PermitRootLogin.*/PermitRootLogin no/' $sshd_path
sed -i 's/^PermitEmptyPasswords.*/PermitEmptyPasswords no/' $sshd_path
sed -i 's/^#ListenAddress.*/#ListenAddress $ipRebond/g' $sshd_path
echo "MaxAuthTries 3" >> $sshd_path

#get current user : echo $(who am i | awk '{print $1}')

#Ajout d'alias

echo "alias ls='ls -lrtu'"  >> /home/$username/.bashrc
