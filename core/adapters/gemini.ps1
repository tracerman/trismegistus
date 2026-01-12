# ============================================================================
#  ⚗️ TRISMEGISTUS - Gemini Adapter
#  Adapter for Google's Gemini CLI
# ============================================================================

function Test-GeminiAvailable {
    return [bool](Get-Command gemini -ErrorAction SilentlyContinue)
}

function Get-GeminiVersion {
    if (Test-GeminiAvailable) {
        return (gemini --version 2>&1) -join ""
    }
    return $null
}

function Invoke-GeminiOracle {
    <#
    .SYNOPSIS
        Invoke Gemini CLI with a prompt
    .PARAMETER Prompt
        The prompt to send
    .PARAMETER Model
        Model to use
    .PARAMETER Interactive
        Launch in interactive mode
    #>
    param(
        [string]$Prompt = "",
        [string]$Model = "gemini-2.5-pro",
        [switch]$Interactive
    )
    
    if (!(Test-GeminiAvailable)) {
        throw "Gemini CLI is not installed. Run: npm install -g @anthropic-ai/gemini-cli (or check Google's installation instructions)"
    }
    
    if ($Interactive) {
        Write-TrisMessage "ORACLE" "Opening portal to Gemini..."
        & gemini
    } else {
        if ($Prompt) {
            # Gemini CLI typically uses stdin or -p flag
            $Prompt | & gemini -m $Model
        } else {
            & gemini
        }
    }
}

function Get-GeminiConfig {
    return @{
        name = "gemini"
        displayName = "Gemini (Google)"
        models = @(
            @{ id = "gemini-3-pro"; name = "Gemini 3 Pro"; default = $true }
            @{ id = "gemini-3-flash"; name = "Gemini 3 Flash" }
            @{ id = "gemini-2.5-pro"; name = "Gemini 2.5 Pro" }
        )
        features = @{
            interactive = $true
            streaming = $true
            codeExecution = $true
            fileAccess = $true
            mcp = $false
        }
        installCommand = "npm install -g @google/gemini-cli"
        authCommand = "gemini auth"
    }
}
