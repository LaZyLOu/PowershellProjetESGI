# script Connexion dans la base de données
# by DAYAO Louise-Anne
#
#
# Import du module pour la connexion avec la base de données
Import-Module SimplySql

function set_database_connexion {
    # paramètres de connexion
    $server = "10.1.1.15"
    $database = "Powershell"
    $credentialFile = "..\..\config\credentialsdb.txt"

    # Lecture du nom d'utilisateur et du mot de passe à partir du fichier
    $credentials = Get-Content $credentialFile
    $utilisateur = $credentials[0]
    $mot_de_passe = $credentials[1]

    # chaine de connexion
    $connexionString = "server=$server;uid=$utilisateur;pwd=$mot_de_passe;database=$database"

    # Connexion au serveur
    #$connexion = Open-MySqlConnection -Server 10.1.1.15 -Database Powershell
    $connexion = Open-MySqlConnection -ConnectionString $connexionString
}

set_database_connexion