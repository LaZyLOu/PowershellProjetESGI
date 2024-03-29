# script importation des données de l'AD dans la BDD
# by DAYAO Louise-Anne  
#
#
# Import de la fonction pour la connexion avec la base de données
Import-Module SimplySql
Import-Module '.\Connexion.ps1'

function get_info_users {
    Get-ADUser -Filter * -Properties * 
}

function get_info_computers {
    Get-ADComputer -Filter * -Properties * 
}

function get_info_CimInstance {
    param([string]$propriete)
    Get-CimInstance -CimSession $session $propriete
}

#Fonction pour importer les données de l'AD dans la BDD
function import_data_to_CMDB {
    set_database_connexion

    

    #Création du fichier export.csv
    $exportAD = (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_users}) | Export-Csv -Path "c:\temp\ExportDataADuser.csv" -Encoding UTF8 -NoTypeInformation

    $exportAD = (invoke-command -ComputerName 10.1.1.16 -Credential "powershell\administrateur" -ScriptBlock ${function:get_info_computers}) | Export-Csv -Path "c:\temp\ExportDataADcomputer.csv" -Encoding UTF8 -NoTypeInformation

    #Conversion du fichier csv en sql
    $csvPathUser = "c:\temp\ExportDataADuser.csv"
    $csv1 = Import-Csv $csvPathUser

    $csvPathComputer = "c:\temp\ExportDataADcomputer.csv"
    $csv2 = Import-Csv $csvPathComputer

    #Insertion des utilisateurs dans la BDD
    ForEach ($row in $csv1) {
        $query = "INSERT IGNORE INTO user (guid,nom_prenom, email, computer_id, service_id, licence_id, telephone_id) VALUES ('$($row.ObjectGUID)', '$($row.DisplayName)', '$($row.EmailAddress)',null , null, null, null );"
        Invoke-SqlUpdate -Query $query
    }

    ForEach ($row in $csv2) {
        $query += "INSERT IGNORE INTO computer (guid, nom_computer, marque, modele, num_serie, num_mac, processeur, ram, disque, bitlocker, adress_ip, moniteur_id) VALUES ('$($row.ObjectGUID)','$($row.Name)', null, null, null, null, null, null, null, null, '$($row.IPv4Address)',null );`n"
        Invoke-SqlUpdate -Query $query
    }

    Close-SqlConnection
}

import_data_to_CMDB

    <# ForEach ($row in $csv2) {
        
        #Si Adresse IP 10.1.0.100 et 10.1.0.102 ignoré car carte réseau supplémentaire du VPN
        If ("$($row.IPv4Address)" -eq '10.1.0.100' -and "$($row.IPv4Address)" -eq '10.1.0.102') 
            { break }
        #Récupérer les données sur le PC en question
        $session = New-CimSession -ComputerName "$($row.IPv4Address)" -Credential "powershell\administrateur"
        $marque =  (get_info_CimInstance Win32_ComputerSystemProduct).Vendor
        $modele =  (get_info_CimInstance Win32_ComputerSystem).Model 
        $numSerie =  (get_info_CimInstance Win32_ComputerSystem).SerialNumber
        $numMac = (get_info_CimInstance Win32_NetworkAdapterConfiguration).MACAddress | Where-Object {$_.IPEnabled -eq "True"}
        $processeur = (get_info_CimInstance Win32_Processor).Name
        $ram = ((get_info_CimInstance Win32_PhysicalMemory) | Measure-Object -Property capacity -Sum).sum /1gb            
        $disque = Get-Volume | Select-Object DriveLetter, @{n='SizeGB';e={$_.Size/1GB}}
        
        $bitlocker = Get-BitLockerVolume -MountPoint "C:"
        $bitlocker.ProtectionStatus -eq "On"

        $query = "UPDATE computer
        SET marque = '$marque',
            modele = '$modele'
        WHERE adress_ip = '$($row.IPv4Address)';"

        Invoke-SqlQuery -Query $query
    }
    
    Remove-CimSession -CimSession $session
    #>
