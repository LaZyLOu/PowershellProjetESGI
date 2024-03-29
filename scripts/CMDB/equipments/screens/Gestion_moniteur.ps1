# script création des ordinateurs dans la base de données
# by Dimitri Lepoutre
# le 11/12/2022
#
#
# Import du module pour la connexion avec la base de données
Import-Module ..\..\Connexion.ps1

#Connexion à la base de donnée
set_database_connexion

function create_moniteur_cmdb {
param ($uuid)
$marque
$modele
$numSerie

    $query = "
    INSERT INTO moniteur(
       
    )
    VALUES ()"

$command = New-Object MariaDB.Data.MariaDBClient.MariaDBCommand($query,$connexion)
$command.Executequery()

Close-SqlConnection
}


function recup_moniteur_cmdb {
    param ($num_serie)

    $query = New-Object MariaDB.Data.MariaDBClient.MariaDBCommand
    $query.CommandText = "SELECT * FROM moniteur WHERE num_serie = $num_serie"
    $query.Connection = $connexion
    
    # Resultat
    
    $Result = Invoke-MariaDBCommand -Command $query
    $Result | Format-Table
    
    Close-SqlConnection}


function modif_moniteur_cmdb {}

function recup_moniteur_cmdb {
    param ($num_serie)

    $query = New-Object MariaDB.Data.MariaDBClient.MariaDBCommand
    $query.CommandText = "DELETE * FROM moniteur WHERE num_serie = $num_serie"
    $query.Connection = $connexion
    
    # Resultat
    
    $Result = Invoke-MariaDBCommand -Command $query
    $Result | Format-Table
    
    Close-SqlConnection}



