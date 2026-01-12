# ============================================================================
#  ⚗️ TRISMEGISTUS - Claude Adapter
#  Adapter for Anthropic's Claude CLI
# ============================================================================

function Test-ClaudeAvailable {
    return [bool](Get-Command claude -ErrorAction SilentlyContinue)
}

function Get-ClaudeVersion {
    if (Test-ClaudeAvailable) {
        return (claude --version 2>&1) -join ""
    }
    return $null
}

function Invoke-ClaudeOracle {
    <#
    .SYNOPSIS
        Invoke Claude CLI with a prompt
    .PARAMETER Prompt
        The prompt to send (used with --print for non-interactive)
    .PARAMETER Model
        Model to use (currently Claude CLI uses default)
    .PARAMETER Interactive
        Launch in interactive mode (user pastes from clipboard)
    .PARAMETER DangerouslySkipPermissions
        Skip permission prompts (for automated workflows)
    #>
    param(
        [string]$Prompt = "",
        [string]$Model = "",
        [switch]$Interactive,
        [switch]$DangerouslySkipPermissions
    )
    
    if (!(Test-ClaudeAvailable)) {
        throw "Claude CLI is not installed. Run: npm install -g @anthropic-ai/claude-cli"
    }
    
    $args = @()
    
    if ($DangerouslySkipPermissions -or $Interactive) {
        $args += "--dangerously-skip-permissions"
    }
    
    if ($Interactive) {
        # Interactive mode - user will paste prompt
        Write-TrisMessage "ORACLE" "Opening portal to Claude..."
        & claude @args
    } else {
        # Direct invocation with prompt
        if ($Prompt) {
            # Use --print for non-interactive output
            $args += "--print"
            $args += $Prompt
            & claude @args
        } else {
            # No prompt - just open interactive
            & claude @args
        }
    }
}

function Get-ClaudeConfig {
    <#
    .SYNOPSIS
        Get Claude-specific configuration defaults
    #>
    return @{
        name = "claude"
        displayName = "Claude (Anthropic)"
        models = @(
            @{ id = "claude-opus-4-5-20251101"; name = "Claude Opus 4.5"; default = $true }
            @{ id = "claude-sonnet-4-5-20250929"; name = "Claude Sonnet 4.5" }
            @{ id = "claude-haiku-4-5-20251001"; name = "Claude Haiku 4.5" }
        )
        features = @{
            interactive = $true
            streaming = $true
            codeExecution = $true
            fileAccess = $true
            mcp = $true
        }
        installCommand = "npm install -g @anthropic-ai/claude-cli"
        authCommand = "claude login"
    }
}
