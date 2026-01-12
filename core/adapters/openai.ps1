# ============================================================================
#  ⚗️ TRISMEGISTUS - OpenAI Adapter
#  Adapter for OpenAI's CLI / Codex
# ============================================================================

function Test-OpenAIAvailable {
    # Check for various OpenAI CLI tools
    return [bool](Get-Command openai -ErrorAction SilentlyContinue) -or 
           [bool](Get-Command codex -ErrorAction SilentlyContinue)
}

function Get-OpenAIVersion {
    if (Get-Command openai -ErrorAction SilentlyContinue) {
        return (openai --version 2>&1) -join ""
    }
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        return (codex --version 2>&1) -join ""
    }
    return $null
}

function Invoke-OpenAIOracle {
    <#
    .SYNOPSIS
        Invoke OpenAI CLI with a prompt
    .PARAMETER Prompt
        The prompt to send
    .PARAMETER Model
        Model to use
    .PARAMETER Interactive
        Launch in interactive mode
    #>
    param(
        [string]$Prompt = "",
        [string]$Model = "gpt-4o",
        [switch]$Interactive
    )
    
    # Determine which CLI to use
    $cli = $null
    if (Get-Command codex -ErrorAction SilentlyContinue) {
        $cli = "codex"
    } elseif (Get-Command openai -ErrorAction SilentlyContinue) {
        $cli = "openai"
    } else {
        throw "OpenAI CLI is not installed. Run: npm install -g openai-cli (or install Codex)"
    }
    
    if ($Interactive) {
        Write-TrisMessage "ORACLE" "Opening portal to OpenAI ($Model)..."
        if ($cli -eq "codex") {
            & codex
        } else {
            & openai chat
        }
    } else {
        if ($Prompt) {
            if ($cli -eq "codex") {
                # Codex CLI
                & codex --model $Model --prompt $Prompt
            } else {
                # OpenAI CLI - use chat completions
                $Prompt | & openai api chat_completions.create -m $Model
            }
        } else {
            if ($cli -eq "codex") {
                & codex
            } else {
                & openai chat
            }
        }
    }
}

function Get-OpenAIConfig {
    return @{
        name = "openai"
        displayName = "OpenAI (GPT-4 / Codex)"
        models = @(
            @{ id = "gpt-4o"; name = "GPT-4o"; default = $true }
            @{ id = "gpt-4o-mini"; name = "GPT-4o Mini" }
            @{ id = "gpt-4-turbo"; name = "GPT-4 Turbo" }
            @{ id = "o1"; name = "o1 (Reasoning)" }
            @{ id = "o1-mini"; name = "o1 Mini" }
        )
        features = @{
            interactive = $true
            streaming = $true
            codeExecution = $true  # With Codex
            fileAccess = $true
            mcp = $false
        }
        installCommand = "npm install -g openai-cli"
        authCommand = "openai api auth"
    }
}
