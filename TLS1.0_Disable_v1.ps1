# RegeditTLV1.0Disable_v1
# Regedit TLS 1.0 for local machints


function regEdit-client{
$registryPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Client"
$Name = "DisabledByDefault"
$value = "1"

IF(!(Test-Path $registryPath)){
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}

 ELSE {
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}
}

function regEdit-server{
$registryPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.0\Server"
$Name = "Enabled"
$value = "0"

IF(!(Test-Path $registryPath)){
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}

 ELSE {
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}
}

function regEdit-ServerMinKeyBitLength{
$registryPath = "HKLM:SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms\Diffie-Hellman"
$Name = "ServerMinKeyBitLength"
$value = "0x800"

IF(!(Test-Path $registryPath)){
    New-Item -Path $registryPath -Force | Out-Null
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}

 ELSE {
    New-ItemProperty -Path $registryPath -Name $name -Value $value `
    -PropertyType DWORD -Force | Out-Null}
}

regEdit-client
regEdit-server
regEdit-ServerMinKeyBitLength