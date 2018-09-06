#!/bin/bash

#Installation des dépendances
apt-get -qq --yes --force-yes install apt-transport-https ca-certificates curl gnupg2 software-properties-common

#Ajout de la clé GPG officielle 
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

#Ajout du repo dans la liste apt
add-apt-repository  "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

#Mise a jour pour renouveller le cache puis installation de Docker-ce
apt-get -qq update
apt-get -qq --yes --force-yes install docker-ce
