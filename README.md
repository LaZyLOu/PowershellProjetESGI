# PowershellProjectESGI

## Projet

Le projet consiste à créer un outils en powershell pour faire de l'automatisation de gestion de parc et d'utilisateurs.<br>
La première partie consiste à gérer les utilisateurs : 

Côté infrastructure : 

- serveurs windows pour faire un AD
- serveurs windows pour faire un serveur VPN
- un exchange pour faire les mails
- un serveur linux pour faire base de données

Côté point du projet
- interface (web?): 
    - Interface qui permet d'entrer un nom d'utilisateur et ensuite de faire les points suivants.
        - Si l'utilisateur n'existe pas, crée l'utilisateur
        - Si l'utilisateur existe, permet de modifier l'utilisateur et de le supprimer
- gestion utilisateurs :
    - création/suppression/modification/desactivation des utilisateurs dans l'AD
        - nom/prenom
        - nom complet/nom ouverture de session
        -  gestion mot de passe
               - modifier
        - expiration
        - chemin profil/accès local
         - Fonction/service
         -
    - Gestion des groupes de l'utilisateur
    - Gestion des accès réseau (vlan/plage dhcp)
- Gestion mail
    - création/suppression/modification des adresses mails des utilisateurs
    - gestions taille boite mail (en mb/gb)
- Gestion VPN
    - création/suppression/modification des utilisateurs dans le VPN
    - Gestion des accès réseau (vlan/plage dhcp)
- Gestion CMDB
    - création/suppression/modification des differents équipements
        - Ecran
        - PC
        - License logiciel attribuer ?
        - autre 

## Base de données

La base de données concerne les équipements. C'est simplement une base dans laquelle on retrouve les différents équipements de l'entreprise, relier à un utilisateur. <br>
Information complémentaire : <br>
IP -> permet réservation dhcp avec service utilisateur pour choisir le vlan donc réseau dhcp correspondant

BDD : PPE
User : toto
mdp  : toto

- Table user
	- ID : int
	- Name : varchar 255
	- Firstname : varchar 255
	- Id_Service : int
	- ...
- Table Service : 
	- ID : int
	- Name : varchar 255
	- Réseau : varchar 255
- Table computer
	- ID : int
	- ID_owner : int
	- Modele : varchar 255
	- Num_Serie : varchar 255
	- Num_Mac : varchar 255
	- Processeur : varchar 255
	- Ram : varchar 255
	- Disque : varchar 255
	- Bitlocker : int -> 0 ou 1 (0: desactiver, 1: activer)
	- IP (permet reservation DHCP) : varchar 255 -> format x.x.x.x/xx
- Table screen 
	- ID : int
	- Id_owner : int
	- Modele : varchar 255
	- Taille : int
- Table equipement
	- ID : int
	- Id_owner : int
	- Modele : varchar 255
	- Description : varchar 255
