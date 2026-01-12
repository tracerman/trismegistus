# ============================================================================
#  ⚗️ TRISMEGISTUS - Configuration Manager
#  Setup wizard and runtime configuration
# ============================================================================

function Invoke-TrisSetup {
    <#
    .SYNOPSIS
        Interactive setup wizard for first-time configuration
    #>
    
    Write-TrisBanner
    Write-Host ""
    Write-TrisMessage "INIT" "Welcome, Seeker. Let us configure your Oracle."
    Write-Host ""
    
    # Detect available providers
    Write-TrisMessage "INVOKE" "Scanning for installed Oracles..."
    Start-Sleep -Milliseconds 500
    
    $providers = @{
        claude = [bool](Get-Command claude -ErrorAction SilentlyContinue)
        gemini = [bool](Get-Command gemini -ErrorAction SilentlyContinue)
        ollama = [bool](Get-Command ollama -ErrorAction SilentlyContinue)
        openai = [bool](Get-Command openai -ErrorAction SilentlyContinue) -or [bool](Get-Command codex -ErrorAction SilentlyContinue)
    }
    
    $available = $providers.GetEnumerator() | Where-Object { $_.Value } | ForEach-Object { $_.Key }
    
    if ($available.Count -eq 0) {
        Write-Host ""
        Write-TrisMessage "VOID" "No AI oracles detected!"
        Write-Host ""
        Write-Host "  Install at least one:" -ForegroundColor Yellow
        Write-Host "    • Claude:  npm install -g @anthropic-ai/claude-cli" -ForegroundColor Gray
        Write-Host "    • Gemini:  npm install -g @google/gemini-cli" -ForegroundColor Gray
        Write-Host "    • Ollama:  https://ollama.ai" -ForegroundColor Gray
        Write-Host "    • OpenAI:  npm install -g openai-cli" -ForegroundColor Gray
        Write-Host ""
        return
    }
    
    Write-Host ""
    Write-TrisMessage "REVEAL" "Detected Oracles:"
    foreach ($p in $providers.GetEnumerator()) {
        $status = if ($p.Value) { "✓ Installed" } else { "✗ Not found" }
        $color = if ($p.Value) { "Green" } else { "DarkGray" }
        Write-Host "    $($p.Key.PadRight(10)) $status" -ForegroundColor $color
    }
    Write-Host ""
    
    # Select default provider
    Write-TrisMessage "ORACLE" "Select your default Oracle:"
    $i = 1
    $options = @{}
    foreach ($p in $available) {
        Write-Host "    [$i] $p" -ForegroundColor Cyan
        $options[$i] = $p
        $i++
    }
    Write-Host ""
    
    $selection = Read-Host "  Enter number (1-$($available.Count))"
    $defaultProvider = $options[[int]$selection]
    
    if (!$defaultProvider) {
        $defaultProvider = $available[0]
    }
    
    Write-TrisMessage "BIND" "Setting $defaultProvider as your primary Oracle."
    
    # Create configuration
    $config = Get-TrisConfig  # Get defaults
    $config.default = $defaultProvider
    
    # Enable detected providers
    foreach ($p in $available) {
        $config.providers[$p].enabled = $true
    }
    
    # Theme selection
    Write-Host ""
    Write-TrisMessage "VISION" "Select your theme:"
    Write-Host "    [1] Hermetic (Alchemical - default)" -ForegroundColor Magenta
    Write-Host "    [2] Minimal (Clean, simple)" -ForegroundColor Gray
    Write-Host "    [3] Matrix (Hacker aesthetic)" -ForegroundColor Green
    Write-Host ""
    
    $themeSelection = Read-Host "  Enter number (1-3)"
    $config.theme = switch ($themeSelection) {
        "2" { "minimal" }
        "3" { "matrix" }
        default { "hermetic" }
    }
    
    # Save configuration
    Save-TrisConfig -Config $config
    
    Write-Host ""
    Write-TrisMessage "SEAL" "Configuration saved to: $(Get-TrisConfigPath)"
    Write-Host ""
    Write-TrisMessage "COMPLETE" "The Great Work begins. Run 'ai-help' to see available commands."
    Write-Host ""
    
    # Show quote
    $quote = Get-TrisQuote -Context "Completion"
    Write-Host "  `"$quote`"" -ForegroundColor DarkGray
    Write-Host ""
}

function Set-TrisConfigValue {
    <#
    .SYNOPSIS
        Set a configuration value
    .PARAMETER Key
        Configuration key (e.g., "default", "theme", "routing.ai-plan", "providers.gemini.enabled")
    .PARAMETER Value
        New value
    #>
    param(
        [Parameter(Mandatory)]
        [string]$Key,
        [Parameter(Mandatory)]
        [string]$Value
    )
    
    $config = Get-TrisConfig
    
    # Convert string booleans to actual booleans
    $typedValue = switch ($Value.ToLower()) {
        "true"  { $true }
        "false" { $false }
        default { $Value }
    }
    
    # Handle nested keys (e.g., "routing.ai-plan" or "providers.gemini.enabled")
    $parts = $Key -split '\.'
    
    if ($parts.Count -eq 1) {
        # Top-level key
        $config[$Key] = $typedValue
    } elseif ($parts.Count -eq 2) {
        # Two-level nested key (e.g., routing.ai-plan)
        if (!$config[$parts[0]]) {
            $config[$parts[0]] = @{}
        }
        $config[$parts[0]][$parts[1]] = $typedValue
    } elseif ($parts.Count -eq 3) {
        # Three-level nested key (e.g., providers.gemini.enabled)
        if (!$config[$parts[0]]) {
            $config[$parts[0]] = @{}
        }
        if (!$config[$parts[0]][$parts[1]]) {
            $config[$parts[0]][$parts[1]] = @{}
        }
        $config[$parts[0]][$parts[1]][$parts[2]] = $typedValue
    } else {
        throw "Invalid key format. Use 'key', 'parent.key', or 'parent.child.key'"
    }
    
    Save-TrisConfig -Config $config
    Write-TrisMessage "CONFIG" "Set $Key = $typedValue"
}

function Get-TrisConfigValue {
    <#
    .SYNOPSIS
        Get a configuration value
    .PARAMETER Key
        Configuration key (optional - returns all if not specified)
    #>
    param([string]$Key = "")
    
    $config = Get-TrisConfig
    
    if (!$Key) {
        return $config
    }
    
    $parts = $Key -split '\.'
    
    if ($parts.Count -eq 1) {
        return $config[$Key]
    } elseif ($parts.Count -eq 2) {
        return $config[$parts[0]][$parts[1]]
    }
    
    return $null
}

function Show-TrisConfig {
    <#
    .SYNOPSIS
        Display current configuration
    #>
    
    $config = Get-TrisConfig
    
    Write-TrisBanner -Mini
    Write-Host ""
    Write-TrisMessage "CONFIG" "Current Configuration"
    Write-Host ""
    
    # General settings
    Write-Host "  General:" -ForegroundColor Yellow
    Write-Host "    Default Provider: $($config.default)" -ForegroundColor Gray
    Write-Host "    Theme:            $($config.theme)" -ForegroundColor Gray
    Write-Host ""
    
    # Providers
    Write-Host "  Providers:" -ForegroundColor Yellow
    foreach ($p in $config.providers.GetEnumerator()) {
        $status = if ($p.Value.enabled) { "Enabled " } else { "Disabled" }
        $color = if ($p.Value.enabled) { "Green" } else { "DarkGray" }
        $model = $p.Value.model
        Write-Host "    $($p.Key.PadRight(10)) [$status] Model: $model" -ForegroundColor $color
    }
    Write-Host ""
    
    # Routing
    Write-Host "  Command Routing:" -ForegroundColor Yellow
    foreach ($r in $config.routing.GetEnumerator()) {
        Write-Host "    $($r.Key.PadRight(15)) → $($r.Value)" -ForegroundColor Gray
    }
    Write-Host ""
    
    # Preferences
    Write-Host "  Preferences:" -ForegroundColor Yellow
    Write-Host "    Protected Branches: $($config.preferences.protectedBranches -join ', ')" -ForegroundColor Gray
    Write-Host "    Max Context Files:  $($config.preferences.maxContextFiles)" -ForegroundColor Gray
    Write-Host "    Lessons Warn at:    $($config.preferences.lessonsWarnThreshold) lines" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "  Config File: $(Join-Path (Get-TrisConfigPath) 'config.json')" -ForegroundColor DarkGray
    Write-Host ""
}

function Enable-TrisProvider {
    param([Parameter(Mandatory)][string]$Provider)
    
    $config = Get-TrisConfig
    if ($config.providers[$Provider]) {
        $config.providers[$Provider].enabled = $true
        Save-TrisConfig -Config $config
        Write-TrisMessage "BIND" "Provider '$Provider' enabled."
    } else {
        Write-TrisMessage "CHAOS" "Unknown provider: $Provider"
    }
}

function Disable-TrisProvider {
    param([Parameter(Mandatory)][string]$Provider)
    
    $config = Get-TrisConfig
    if ($config.providers[$Provider]) {
        $config.providers[$Provider].enabled = $false
        Save-TrisConfig -Config $config
        Write-TrisMessage "BIND" "Provider '$Provider' disabled."
    } else {
        Write-TrisMessage "CHAOS" "Unknown provider: $Provider"
    }
}

function Set-TrisRoute {
    <#
    .SYNOPSIS
        Set routing for a specific command
    .PARAMETER Command
        The ai-* command to route
    .PARAMETER Provider
        Provider to route to (or "auto" for default)
    #>
    param(
        [Parameter(Mandatory)][string]$Command,
        [Parameter(Mandatory)][string]$Provider
    )
    
    Set-TrisConfigValue -Key "routing.$Command" -Value $Provider
    Write-TrisMessage "BIND" "Command '$Command' now routes to '$Provider'"
}
