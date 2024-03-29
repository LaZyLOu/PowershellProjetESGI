# script création des ordinateurs dans la base de données
# by DAYAO Louise-Anne
#
#
# Import du module pour la connexion avec la base de données
Import-Module SimplySql
Import-Module '..\..\Connexion.ps1'


#Fonction pour créer le PC dans la BDD
function add_computer_cmdb {
    param ($nom_computer)

    set_database_connexion

    #Récupérer les données sur le PC en question
    $guid =  (Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystemProduct).UUID
    $nom_computer = Get-ADComputer -Identity "$nom_computer" | Select-Object -ExpandProperty Name
    $marque =  (Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystemProduct).Vendor
    $modele =  (Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystem).Model
    <#$numSerie =  Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystem | Select-Object SerialNumber
    $numMac = Get-CimInstance -ComputerName "$nom_computer" Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select-Object MACAddress
    $processeur = Get-CimInstance -ComputerName "$nom_computer" Win32_Processor | Select-Object Name
    $ram = (Get-CimInstance -ComputerName "$nom_computer" Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
    $disque = Get-Volume | Select-Object DriveLetter, @{n='SizeGB';e={$_.Size/1GB}}

    $bitlocker = Get-BitLockerVolume -MountPoint "C:"
    $bitlocker.ProtectionStatus -eq "On"

    $adressIP = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter).Name -AddressState Preferred | Select-Object IPAddress
    #>

    #Lancement de la commande

        $query = "
        INSERT IGNORE INTO computer(
            guid
            adress_ip,
            nom_computer,
            marque,
            modele,
            bitlocker,
            disque,
            num_serie,
            num_mac,
            processeur,
            ram,
            moniteur_id
        )
        VALUES (
            $guid,
            $adressIP,
            $nom_computer,
            $marque,
            $modele,
            null,
            null,
            null,
            null,
            null,
            null,
            null
        );"

    Invoke-SqlQuery -Query $query 


    Close-SqlConnection
}

#Fonction pour récupérer et afficher les données de l'ordinateur depuis la BDD
function get_computer_cmdb {
    param ($nom_computer)

    set_database_connexion

    $query = "SELECT * FROM computer WHERE nom_computer = $nom_computer;"
    
    $Result = Invoke-SqlQuery -Query $query 
    $Result | Format-Table
    
    Close-SqlConnection
}


#Fonction normalement utilisé pour ajouter un moniteur ou les spécifités non importé par l'AD
function update_computer_cmdb {  
    param ($nom_computer)

    #Récupérer les données sur le PC en question
    $marque =  Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystemProduct | Select-Object Vendor
    $modele =  Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystem | Select-Object Model
    <#$numSerie =  Get-CimInstance -ComputerName "$nom_computer" Win32_ComputerSystem | Select-Object SerialNumber
    $numMac = Get-CimInstance -ComputerName "$nom_computer" Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq "True"} | Select-Object MACAddress
    $processeur = Get-CimInstance -ComputerName "$nom_computer" Win32_Processor | Select-Object Name
    $ram = (Get-CimInstance -ComputerName "$nom_computer" Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum /1gb
    $disque = Get-Volume | Select-Object DriveLetter, @{n='SizeGB';e={$_.Size/1GB}}

    $bitlocker = Get-BitLockerVolume -MountPoint "C:"
    $bitlocker.ProtectionStatus -eq "On"

    $adressIP = Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias (Get-NetAdapter).Name -AddressState Preferred | Select-Object IPAddress
#>
    #Lancement de la commande SQL

    $query = "UPDATE computer
    SET marque = '$marque'
    SET modele = '$modele'
    WHERE nom_computer = $nom_computer ;"

    Invoke-SqlQuery -Query $query 

    Close-SqlConnection
    }

#Fonction pour supprimer les données d'un ordinateur si l'ordinateur ne fait plus partir de l'AD
function suppr_computer_cmdb {
    param ($nom_computer)

    $query = "DELETE * FROM computer WHERE nom_computer = $nom_computer;"

    Invoke-SqlQuery -Query $query 
    
    Close-SqlConnection
}



