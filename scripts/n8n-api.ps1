# n8n API Helper Script
# Uses API key from agent-agency-mcp/.env

$N8N_URL = "http://localhost:5678"
$API_KEY = (Get-Content "C:\Users\bermi\Projects\agent-agency-mcp\.env" | Select-String "N8N_API_KEY").Line.Split('=')[1]

function Invoke-N8nApi {
    param(
        [string]$Method = "GET",
        [string]$Endpoint,
        [string]$Body = $null
    )
    
    $headers = @{
        "X-N8N-API-KEY" = $API_KEY
        "Accept" = "application/json"
        "Content-Type" = "application/json"
    }
    
    $url = "$N8N_URL/api/v1/$Endpoint"
    
    if ($Body) {
        curl -X $Method $url -H "X-N8N-API-KEY: $API_KEY" -H "Accept: application/json" -H "Content-Type: application/json" -d $Body
    } else {
        curl -X $Method $url -H "X-N8N-API-KEY: $API_KEY" -H "Accept: application/json"
    }
}

# Export function
Export-ModuleMember -Function Invoke-N8nApi

# Quick commands
Write-Host "n8n API Helper loaded. Available commands:"
Write-Host "  Invoke-N8nApi -Endpoint 'workflows' - List workflows"
Write-Host "  Invoke-N8nApi -Endpoint 'workflows/ID' - Get specific workflow"
Write-Host "  Invoke-N8nApi -Method POST -Endpoint 'workflows/ID/activate' - Activate workflow"
