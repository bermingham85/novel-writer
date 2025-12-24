# Novel Writer - Automated Deployment Script
# This script automates as much as possible of the deployment process

param(
    [Parameter(Mandatory=$false)]
    [string]$SupabaseUrl,
    
    [Parameter(Mandatory=$false)]
    [string]$SupabaseKey,
    
    [Parameter(Mandatory=$false)]
    [string]$OpenAIKey
)

Write-Host "`n🚀 Novel Writer Deployment Script`n" -ForegroundColor Cyan

# Check if n8n Docker container is running
Write-Host "📦 Checking n8n Docker container..." -ForegroundColor Yellow
$n8nContainer = docker ps --filter "name=n8n-local" --format "{{.Names}}"
if ($n8nContainer -eq "n8n-local") {
    Write-Host "✅ n8n-local container is running" -ForegroundColor Green
} else {
    Write-Host "❌ n8n-local container is not running" -ForegroundColor Red
    Write-Host "   Starting n8n-local..." -ForegroundColor Yellow
    docker start n8n-local
    Start-Sleep -Seconds 3
}

# Open n8n
Write-Host "`n🌐 Opening n8n in browser..." -ForegroundColor Yellow
Start-Process "http://localhost:5678"

# Open Supabase
Write-Host "🌐 Opening Supabase dashboard..." -ForegroundColor Yellow
Start-Process "https://supabase.com/dashboard"

# Copy SQL to clipboard
Write-Host "`n📋 Copying DEPLOY_ALL.sql to clipboard..." -ForegroundColor Yellow
$sqlContent = Get-Content "$PSScriptRoot\DEPLOY_ALL.sql" -Raw
Set-Clipboard -Value $sqlContent
Write-Host "✅ SQL copied to clipboard!" -ForegroundColor Green

# Display instructions
Write-Host "`n" -NoNewline
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  MANUAL STEPS REQUIRED" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

Write-Host "`n📌 STEP 1: Deploy SQL to Supabase" -ForegroundColor Cyan
Write-Host "   1. In Supabase Dashboard → SQL Editor → New Query"
Write-Host "   2. Paste (Ctrl+V) - SQL is already in clipboard!"
Write-Host "   3. Click 'Run' (or Ctrl+Enter)"
Write-Host "   4. Verify success message appears"

Write-Host "`n📌 STEP 2: Get Supabase Connection String" -ForegroundColor Cyan
Write-Host "   1. Supabase → Settings → Database"
Write-Host "   2. Connection String → Connection pooling tab"
Write-Host "   3. Click 'Show' to reveal password"
Write-Host "   4. Copy the connection string"

Write-Host "`n📌 STEP 3: Configure n8n Credentials" -ForegroundColor Cyan
Write-Host "   In n8n (http://localhost:5678):"
Write-Host "   1. Settings → Credentials → Add Credential"
Write-Host "   2. Select 'Postgres'"
Write-Host "   3. Fill in Supabase connection details"
Write-Host "   4. Test Connection → Save"
Write-Host "   5. Add/verify OpenAI credential"

Write-Host "`n📌 STEP 4: Import Workflow" -ForegroundColor Cyan
Write-Host "   1. n8n → + → Import from File"
Write-Host "   2. Select: $PSScriptRoot\workflow.json"
Write-Host "   3. Update all node credentials (9 Postgres + 3 OpenAI)"
Write-Host "   4. Save → Activate → Execute Workflow"

Write-Host "`n═══════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Wait for user confirmation
Write-Host "Press any key when you've completed the steps above..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

Write-Host "`n✅ Deployment preparation complete!" -ForegroundColor Green
Write-Host "📖 For detailed instructions, see: LOCAL_DOCKER_SETUP.md`n" -ForegroundColor Cyan
