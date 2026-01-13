# ============================================================================
#  ⚗️ TRISMEGISTUS - Router Module
#  The Great Dispatcher - Routes invocations to the appropriate Oracle
# ============================================================================

# Global state
$script:TrisConfig = $null
$script:AvailableProviders = @{}

function Initialize-TrisRouter {
    <#
    .SYNOPSIS
        Initialize the router with configuration and detect available providers
    #>
    
    # Load configuration
    $script:TrisConfig = Get-TrisConfig
    
    # Detect available CLIs
    $script:AvailableProviders = @{
        claude = [bool](Get-Command claude -ErrorAction SilentlyContinue)
        gemini = [bool](Get-Command gemini -ErrorAction SilentlyContinue)
        ollama = [bool](Get-Command ollama -ErrorAction SilentlyContinue)
        openai = [bool](Get-Command openai -ErrorAction SilentlyContinue)
        llm    = [bool](Get-Command llm -ErrorAction SilentlyContinue)
        aichat = [bool](Get-Command aichat -ErrorAction SilentlyContinue)
    }
}

function Get-TrisConfigPath {
    <#
    .SYNOPSIS
        Get the configuration directory path (cross-platform)
    #>
    if ($IsWindows -or $env:OS -match "Windows") {
        return Join-Path $env:USERPROFILE ".trismegistus"
    } else {
        return Join-Path $env:HOME ".trismegistus"
    }
}

function Get-TrisConfig {
    <#
    .SYNOPSIS
        Load configuration from file or return defaults
    #>
    $configDir = Get-TrisConfigPath
    $configFile = Join-Path $configDir "config.json"
    
    if (Test-Path $configFile) {
        try {
            return Get-Content $configFile -Raw | ConvertFrom-Json -AsHashtable
        } catch {
            Write-TrisMessage "CHAOS" "Configuration corrupted. Using defaults."
        }
    }
    
    # Default configuration
    return @{
        default = "claude"
        theme = "hermetic"
        routing = @{
            "ai-plan"     = "claude"
            "ai-exec"     = "claude"
            "ai-verify"   = "claude"
            "ai-architect"= "claude"
            "ai-commit"   = "auto"      # Uses default or cheapest available
            "ai-ask"      = "auto"
            "ai-debug"    = "auto"
        }
        providers = @{
            claude = @{ enabled = $true; model = "claude-opus-4-5-20251101" }
            gemini = @{ enabled = $false; model = "gemini-3-pro" }
            ollama = @{ enabled = $false; model = "llama4" }
            openai = @{ enabled = $false; model = "gpt-5.2-codex" }
        }
        preferences = @{
            autoConfirmCommit = $false
            protectedBranches = @("main", "master", "production", "prod")
            maxContextFiles = 3000
            lessonsWarnThreshold = 100
        }
    }
}

function Save-TrisConfig {
    param([hashtable]$Config)
    
    $configDir = Get-TrisConfigPath
    $configFile = Join-Path $configDir "config.json"
    
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    $Config | ConvertTo-Json -Depth 10 | Set-Content $configFile -Encoding UTF8
    $script:TrisConfig = $Config
}

function Get-ProviderForCommand {
    param([string]$CommandName)
    
    $config = $script:TrisConfig
    if (!$config) { Initialize-TrisRouter; $config = $script:TrisConfig }
    
    # Check if there's a specific route for this command
    $provider = $config.routing[$CommandName]
    
    if (!$provider -or $provider -eq "auto") {
        $provider = $config.default
    }
    
    # Verify provider is available and enabled
    if (!$script:AvailableProviders[$provider]) {
        Write-TrisMessage "CHAOS" "Provider '$provider' is not installed."
        
        # Fallback to any available provider
        foreach ($p in @("claude", "gemini", "ollama", "openai", "llm", "aichat")) {
            if ($script:AvailableProviders[$p] -and $config.providers[$p].enabled) {
                Write-TrisMessage "TRANSMUTE" "Falling back to '$p'..."
                return $p
            }
        }
        
        throw "No AI providers available. Install at least one: claude, gemini, ollama, openai, llm, or aichat"
    }
    
    return $provider
}

function Invoke-Oracle {
    <#
    .SYNOPSIS
        The core invocation function - sends prompt to the appropriate AI
    .PARAMETER Prompt
        The prompt to send
    .PARAMETER CommandName
        The ai-* command that triggered this (for routing)
    .PARAMETER Provider
        Override the provider (optional)
    .PARAMETER UseClipboard
        Use clipboard method instead of direct invocation
    #>
    param(
        [string]$Prompt,
        [string]$CommandName = "default",
        [string]$Provider = $null,
        [switch]$UseClipboard,
        [switch]$Interactive
    )
    
    # Determine provider
    if (!$Provider) {
        $Provider = Get-ProviderForCommand -CommandName $CommandName
    }
    
    $config = $script:TrisConfig
    $providerConfig = $config.providers[$Provider]
    
    # Show oracle consulting animation
    Show-TrisOracle -Provider $Provider
    
    Write-TrisMessage "INVOKE" "Channeling the Oracle of $($Provider.ToUpper())..."
    
    # Get the appropriate adapter
    $adapterPath = Join-Path $PSScriptRoot "adapters\$Provider.ps1"
    if (!(Test-Path $adapterPath)) {
        throw "Adapter not found for provider: $Provider"
    }
    
    # Source the adapter if not already loaded
    . $adapterPath
    
    # Invoke through adapter
    $adapterFunction = "Invoke-$($Provider)Oracle"
    
    if ($UseClipboard) {
        Set-Clipboard -Value $Prompt
        Write-TrisMessage "SCRIBE" "Invocation inscribed to clipboard. Press Ctrl+V when the portal opens."
        & $adapterFunction -Interactive
    } elseif ($Interactive) {
        Set-Clipboard -Value $Prompt
        Write-TrisMessage "SCRIBE" "Invocation inscribed to clipboard. Press Ctrl+V when the portal opens."
        & $adapterFunction -Interactive
    } else {
        & $adapterFunction -Prompt $Prompt -Model $providerConfig.model
    }
}

function Get-AvailableProviders {
    <#
    .SYNOPSIS
        Return list of installed and enabled providers
    #>
    if (!$script:TrisConfig) { Initialize-TrisRouter }
    
    $available = @()
    foreach ($provider in $script:AvailableProviders.Keys) {
        if ($script:AvailableProviders[$provider]) {
            $enabled = $script:TrisConfig.providers[$provider].enabled
            $available += [PSCustomObject]@{
                Name = $provider
                Installed = $true
                Enabled = $enabled
                Model = $script:TrisConfig.providers[$provider].model
            }
        }
    }
    return $available
}

