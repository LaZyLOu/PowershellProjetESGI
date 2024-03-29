function New-UserAD
{
    param
    (
        [string]$name,
        [string]$surName,
        [string]$department
    )

    #3 lignes suivantes pour test seulement, à delete
    $name = "Jim"
    $surName = "Carret"
    $department = "Marketing"

    #Fabrication de variable
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
    -Company "TotoChinken Inc." `
    -City "Lyon" `
    -Description "" `
    -Department $department `
    -DisplayName $displayName `
    -Country "fr" `
    -PostalCode "69003" `
    -Enabled $True

    return "L'utilisateur [$fullname] a été créé avec succès. [$samAccountName]"
}


Invoke-Command -ComputerName "10.1.1.16" -Credential "powershell\administrateur" -ScriptBlock ${function:New-UserAD}