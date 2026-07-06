# PS.VaultWarden

## Authentication

### Initial Connection
```powershell

$VaultConfig = @{
    Url          = "https://vaultwarden.local"
    ClientId     = "user.GUID"
    ClientSecret = "SECRET"
}
Connect-VaultWarden @VaultConfig
```

### Unlocking Vault
```powershell
Unlock-VaultWarden -MasterPassword (Read-Host "Vault Master Password" -AsSecureString)
```


