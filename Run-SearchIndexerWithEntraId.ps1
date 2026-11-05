param(
    [Parameter(Mandatory = $true)]
    [string]$SearchServiceName,

    [Parameter(Mandatory = $true)]
    [string]$IndexerName,

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [string]$ManagedIdentityClientId,

    [Parameter(Mandatory = $false)]
    [string]$ApiVersion = "2023-11-01"
)

$ErrorActionPreference = "Stop"

Disable-AzContextAutosave -Scope Process | Out-Null

if ([string]::IsNullOrWhiteSpace($ManagedIdentityClientId)) {
    Connect-AzAccount -Identity | Out-Null
}
else {
    Connect-AzAccount -Identity -AccountId $ManagedIdentityClientId | Out-Null
}

if (-not [string]::IsNullOrWhiteSpace($SubscriptionId)) {
    Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
}

$token = (Get-AzAccessToken -ResourceUrl "https://search.azure.com").Token

$encodedIndexer = [System.Uri]::EscapeDataString($IndexerName)
$uri = "https://$SearchServiceName.search.windows.net/indexers/$encodedIndexer/run?api-version=$ApiVersion"

$headers = @{
    Authorization = "Bearer $token"
    "Content-Type" = "application/json"
}

try {
    Invoke-RestMethod -Method Post -Uri $uri -Headers $headers | Out-Null
    Write-Output "Indexer '$IndexerName' triggered successfully using Entra ID."
}
catch {
    throw "Failed to run indexer '$IndexerName': $($_.Exception.Message)"
}
