#Créer un utilisateur AD
function Add_ESGIAD_User
{
    param
    (
        [string]$name,
        [string]$surName,
        [string]$department
    )

    #Fabriquer des variables
    $samAccountName = (($name)[0] + "." + $surName).ToLower()
    $displayName = ($surName + ' ' + $name)
    $fullName = $displayName

    New-ADUser `
    -Name $fullName `
    -GivenName $name `
    -Surname $surName `
    -SamAccountName $samAccountName `
    -AccountPassword (Read-Host -AsSecureString "Input User Password") `
    -ChangePasswordAtLogon $True `
    -Company "ESGI" `
    -City "Lyon" `
    -Description "" `
    -Department $department `
    -DisplayName $displayName `
    -Country "fr" `
    -PostalCode "69003" `
    -Enabled $True

    return "L'utilisateur [$fullName] a été créé avec succès. ($samAccountName)"
}

<#Liaison serveur AD ->
Invoke-Command -ComputerName "10.1.1.16" -Credential "powershell\administrateur" -ScriptBlock ${function:Add-ESGIAD_User}#>

#Supprimer un utilisateur en demandant confirmation
function Remove_ESGIAD_User{ 
    param(
        [string]$userID
    )
    
    Remove-ADUser -Identity $userID
}

#Activer un utilisateur AD
function Enable_ESGIAD_User{ 
    param(
        [string]$userID
    )

    Set-ADUser -Identity $userID -Enabled $true
}

#Désactiver un utilisateur AD
function Disable_ESGIAD_User{
    param(
        [string]$userID
    )

    Set-ADUser -Identity $userID -Enabled $false
}

#Lister les utilisateurs de l'AD
function Get_ESGIAD_Users {

    Write-Verbose -Verbose "Voilà les utilisateurs présents de l'AD : "

    Get-ADUser -Filter * -Properties Name | 

    #Récupère les noms des utilisateurs AD en excluant les "faux" utilisateurs dans la ligne du dessous

    Where-Object { $_.Name -notmatch '\d{2,}' -and $_.Name -notlike 'Administrateur' -and $_.Name -notlike 'Invité' -and $_.Name -notlike '*Exchange*' } |
    Select-Object Name, SamAccountName 
}

#Voir quelques paramètres d'un utilisateur AD
function Get_ESGIAD_UserDetails {
    param(
        [string]$userID
    )


    $user = Get-ADUser -Identity $userID -Properties Name, GivenName, Surname, SamAccountName, Company, Department, City, Country, PostalCode, DisplayName

    if ($null -eq $user) {
        Write-Host "User $userID not found in Active Directory."
        return
    }


    $user | Select-Object Name, GivenName, Surname, SamAccountName, Company, Department, City, Country, PostalCode, DisplayName | Format-Table
}

#Voir tous les paramètres d'un utilisateur AD
function Get_ESGIAD_AllUserDetails { 
    param (
        [string]$userID
    )
    $user = Get-ADUser -Identity $userID -Properties *

    if ($null -eq $user) {
        Write-Host "User $userID not found in Active Directory."
        return
    }

    Write-Output $user
}

#Réinitialiser un mot de passe par un mot de passe temporaire
function Set_ESGIAD_UserPassword 
{
    param
    (
        [string]$name
    )
    <#
    $caracteres = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    $texteAleatoire = -join ($caracteres | Get-Random -Count 8)
    return $texteAleatoire
    #>
    $newPassword = ConvertTo-SecureString "P@sst3mp" -AsPlainText -Force 
    Set-ADAccountPassword -Identity $name -NewPassword $newPassword -Reset
    Set-ADUser -Identity $name -ChangePasswordAtLogon $true
    return "P@sst3mp"
}

#Changer le nom de famille d'un utilisateur AD
function Set_ESGIAD_UserSurname
{
    param(
        [string]$userID,
        [string]$newSurName
    )

    $user = Get-ADUser -Filter "Name -eq '$userID'"

    if ($null -eq $user) {
        Write-Host "User $userID not found in Active Directory."
        return
    }

    $user.Surname = $newSurName
    Set-ADUser -Instance $user

    Write-Host "Name for user $userID has been updated to $newSurName."
}

#Changer le prénom d'un utilisateur AD
function Set_ESGIAD_UserName
{
    param(
        [string]$name,
        [string]$newGivenName
    )

    $user = Get-ADUser -Filter "Name -eq '$name'"

    if ($null -eq $user) {
        Write-Host "User $name not found in Active Directory."
        return
    }

    $user.GivenName = $newGivenName
    Set-ADUser -Instance $user

    Write-Host "Given name for user $name has been updated to $newGivenName."
}

#Ajouter un utilisateur à un groupe AD
function Add_ESGIAD_GroupMember
{ 
    param(
        [string]$userID,
        [string]$groupName
    )

    $group = Get-ADGroup -Filter "Name -eq '$groupName'"

    if ($null -eq $group) {
        Write-Host "Group $groupName not found in Active Directory."
        return
    }

    $user = Get-ADUser -Identity $userID

    if ($null -eq $user) {
        Write-Host "User $userID not found in Active Directory."
        return
    }

    Add-ADGroupMember -Identity $group -Members $user

    Write-Host "User $userID has been added to group $groupName."
}

#Retirer un utilisateur d'un groupe AD
function Remove_ESGIAD_GroupMember
{ 
    param(
        [string]$userID,
        [string]$groupName
    )

    $group = Get-ADGroup -Filter "Name -eq '$groupName'"

    if ($null -eq $group) {
        Write-Host "Group $groupName not found in Active Directory."
        return
    }

    $user = Get-ADUser -Identity $userID

    if ($null -eq $user) {
        Write-Host "User $userID not found in Active Directory."
        return
    }

    Remove-ADGroupMember -Identity $group -Members $user

    Write-Host "User $userID has been removed from group $groupName."
}

#Voir les utilisateurs d'un groupe AD
function Get_ESGIAD_GroupMembers
{  
    param(
        [string]$groupName
    )

    $group = Get-ADGroup -Filter "Name -eq '$groupName'"

    if ($null -eq $group) {
        Write-Host "Group $groupName not found in Active Directory."
        return
    }

    Get-ADGroupMember -Identity $group | Select-Object Name, SamAccountName

}


#Afficher les groupes d'un utilisateur AD
function Get_ESGIAD_UserGroups
{ 
    param (
        [string]$userID
    )
    $user = Get-ADUser $userID -Properties MemberOf
    $user.MemberOf | Get-ADGroup | Select-Object Name
}

function Get_ESGIAD_AllGroup {
    Get-ADGroup -Filter *
}

function Get_ESGIAD_Computer {
    Get-ADComputer -Filter *
}
