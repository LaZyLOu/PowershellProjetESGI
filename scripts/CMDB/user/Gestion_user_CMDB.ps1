# script importation des données de l'AD dans la BDD
# by DAYAO Louise-Anne  
#
#
# Import du module pour la connexion avec la base de données
Import-Module SimplySql
Import-Module '..\..\Connexion.ps1'

function get_info_users {
    param([string]$propriete)
    Get-ADUser -Identity "$login" -Properties $propriete
}

function add_user_cmdb {
    param ([string]$login)
    set_database_connexion
    #récupération des informations 

    $guid= (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_users} ObjectGUID) | Select-Object -ExpandProperty ObjectGUID
    $fullName= (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_users}DisplayName) | Select-Object DisplayName
    $email= (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_users} EmailAddress) | Select-Object EmailAddress
    #$service = (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_users} "service")

    #$rechercheService = "SELECT id INTO service WHERE nom = $service"
    #$resultService = Invoke-SqlQuery -Query $rechercheService

 #Lancement des commandes

    $query = "INSERT INTO user (guid, nom_prenom, email, service_id, computer_id, telephone_id, licence_id)
        VALUES (
            $guid,
            $fullName,
            $email,
            null,
            null,
            null,
            null
        );"
    
    # Resultat
    
    Invoke-SqlQuery -Query $query
    Close-SqlConnection
    }

function get_user_cmdb {
    param ($nom_prenom)

    set_database_connexion
    $query = "SELECT * FROM user WHERE nom_prenom = $nom_prenom;"
    
    # Resultat
    
    $Result = Invoke-SqlQuery -Query $query
    $Result | Format-Table
    
    Close-SqlConnection
}