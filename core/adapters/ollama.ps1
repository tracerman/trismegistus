# ============================================================================
#  ⚗️ TRISMEGISTUS - Ollama Adapter
#  Adapter for Ollama (local models: Llama, Mistral, CodeLlama, etc.)
# ============================================================================

function Test-OllamaAvailable {
    return [bool](Get-Command ollama -ErrorAction SilentlyContinue)
}

function Test-OllamaRunning {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get -ErrorAction Stop
        return $true
    } catch {
        return $false
    }
}

function Get-OllamaVersion {
    if (Test-OllamaAvailable) {
        return (ollama --version 2>&1) -join ""
    }
    return $null
}

function Get-OllamaModels {
    <#
    .SYNOPSIS
        List locally installed Ollama models
    #>
    if (!(Test-OllamaRunning)) {
        Write-TrisMessage "CHAOS" "Ollama server is not running. Start it with: ollama serve"
        return @()
    }
    
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:11434/api/tags" -Method Get
        return $response.models | ForEach-Object { $_.name }
    } catch {
        return @()
    }
}

function Invoke-OllamaOracle {
    <#
    .SYNOPSIS
        Invoke Ollama with a prompt
    .PARAMETER Prompt
        The prompt to send
    .PARAMETER Model
        Model to use (default: llama3.2)
    .PARAMETER Interactive
        Launch in interactive chat mode
    #>
    param(
        [string]$Prompt = "",
        [string]$Model = "llama3.2",
        [switch]$Interactive
    )
    
    if (!(Test-OllamaAvailable)) {
        throw "Ollama is not installed. Visit: https://ollama.ai"
    }
    
    if (!(Test-OllamaRunning)) {
        Write-TrisMessage "INVOKE" "Starting Ollama server..."
        Start-Process ollama -ArgumentList "serve" -WindowStyle Hidden
        Start-Sleep -Seconds 2
    }
    
    if ($Interactive) {
        Write-TrisMessage "ORACLE" "Opening portal to local Oracle ($Model)..."
        & ollama run $Model
    } else {
        if ($Prompt) {
            # Use the API for non-interactive prompts
            $body = @{
                model = $Model
                prompt = $Prompt
                stream = $false
            } | ConvertTo-Json
            
            try {
                $response = Invoke-RestMethod -Uri "http://localhost:11434/api/generate" -Method Post -Body $body -ContentType "application/json"
                return $response.response
            } catch {
                Write-TrisMessage "CHAOS" "Failed to invoke Ollama: $_"
                throw
            }
        } else {
            & ollama run $Model
        }
    }
}

function Install-OllamaModel {
    <#
    .SYNOPSIS
        Pull/install an Ollama model
    .PARAMETER Model
        Model name to pull
    #>
    param([string]$Model)
    
    Write-TrisMessage "INVOKE" "Summoning model: $Model..."
    & ollama pull $Model
}

function Get-OllamaConfig {
    return @{
        name = "ollama"
        displayName = "Ollama (Local)"
        models = @(
            @{ id = "llama3.2"; name = "Llama 3.2 (8B)"; default = $true }
            @{ id = "llama3.2:70b"; name = "Llama 3.2 (70B)" }
            @{ id = "codellama"; name = "CodeLlama" }
            @{ id = "mistral"; name = "Mistral 7B" }
            @{ id = "mixtral"; name = "Mixtral 8x7B" }
            @{ id = "deepseek-coder"; name = "DeepSeek Coder" }
            @{ id = "qwen2.5-coder"; name = "Qwen 2.5 Coder" }
        )
        features = @{
            interactive = $true
            streaming = $true
            codeExecution = $false
            fileAccess = $false
            mcp = $false
            offline = $true
            privacy = $true
        }
        installCommand = "Visit https://ollama.ai for installation"
        authCommand = $null  # No auth needed for local
    }
}
