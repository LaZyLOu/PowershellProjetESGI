# script création des equipements dans la base de données
# by Dimitri Lepoutre
# le 17/12/2022
#
#


# Import du module pour la connexion avec la base de données
Import-Module MariaDB.Data.MariaDBClient

# paramètres de connexion
$server = "10.1.1.15"
$database = "Powershell"
$credentialFile = "/home/toto/projet/PowershellProjectESGI/config/credentialsdb.txt"

# charge les credentials
$credentials = Import-Clixml -Path $credentialFile

# chaine de connexion
$connexionString = "server=$server;database=$database,uid=$($credentials.UserName);pwd=$($credentials.GetNetworkCredentials().Password);"

# Connexion au serveur
$connexion = New-Object MariaDB.Data.MariaDBClient.MariaDBConnection
$connexion.ConnectionString = $connexionString
$connexion.Open()

# insert query

$query = "insert into equipements (id,id_owner,modele,description) values (id,id_owner,modele,description)"

$command = New-Object MariaDB.Data.MariaDBClient.MariaDBCommand($query,$connexion)
$command.Executequery()

Close-SqlConnection


