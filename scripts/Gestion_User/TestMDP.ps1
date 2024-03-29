#Création d'un utilisateur AD
function New-UserAD
{
    param
    (
        [string]$surName,
        [string]$name,
        [string]$department
    )
    $samAccountName = (($name)[0] + "." + $surName).ToLower()
    $displayName = ($name + ' ' + $surName)
    $fullName = $displayName

    New-ADUser `
    -Name $fullName `
    -GivenName $name `
    -Surname $surName `
    -SamAccountName $samAccountName `
    -AccountPassword $null `
    -ChangePasswordAtLogon $True `
    -Company "TotoChinken Inc." `
    -City "Lyon" `
    -Description "" `
    -Department $department `
    -DisplayName $displayName `
    -Country "fr" `
    -PostalCode "69003" `
    -Enabled $True

    #return "L'utilisateur [$fullname] a été créé avec succès."

    New-TempPassword
}


function Get-RandomPassword
{
    #Longueur du mot de passe
    param([int]$PasswordLength = 10)
 
    #Caractères ACSII du mot de passe
    $CharacterSet = @{
            Uppercase   = (97..122) | Get-Random -Count 10 | % {[char]$_}
            Lowercase   = (65..90)  | Get-Random -Count 10 | % {[char]$_}
            Numeric     = (48..57)  | Get-Random -Count 10 | % {[char]$_}
            SpecialChar = (33..47)+(58..64)+(91..96)+(123..126) | Get-Random -Count 10 | % {[char]$_}
    }

    $StringSet = $CharacterSet.Uppercase + $CharacterSet.Lowercase + $CharacterSet.Numeric + $CharacterSet.SpecialChar
 
    -join(Get-Random -Count $PasswordLength -InputObject $StringSet)
}
 
#Appel de la fonction
#$tempPassword = Get-RandomPassword -PasswordLength 10

#3 lignes suivantes à supprimer
#$name = "Louise-Anne"
#$surName = "Dayao"
#$department = "Direction"

Invoke-Command -ComputerName "10.1.1.16" -Credential "powershell\administrateur" -ScriptBlock ${function:New-UserAD} -ArgumentList "$name", "$surName", "$department"
return "Le mot de passe temporaire de l'utilisateur est [$tempPassword]."

$userid = "b.raphael"
function New-TempPassword
{
    $tempPassword = Get-RandomPassword -PasswordLength 10
    Set-ADAccountPassword -Identity $userid -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $tempPassword -Force)
}