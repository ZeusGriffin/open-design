param(
    [string]$BaseUrl = "http://127.0.0.1:8080/v1",
    [string]$Token = ""
)

$ErrorActionPreference = "Stop"

$rootUrl = $BaseUrl.TrimEnd("/") -replace "/v1$", ""
$headers = @{
    "Content-Type" = "application/json"
}

if ($Token) {
    $headers["Authorization"] = "Bearer $Token"
}

Write-Host "Checking bridge health..." -ForegroundColor Cyan
$health = Invoke-RestMethod -Method Get -Uri "$rootUrl/health" -Headers $headers

if (-not $health.ok) {
    throw "Health endpoint did not report ok=true."
}

Write-Host "[ OK ] Bridge is responding." -ForegroundColor Green

$body = @{
    model = "pooled"
    messages = @(
        @{
            role = "user"
            content = "Reply with exactly: PHONE-CLUSTER-OK"
        }
    )
    max_tokens = 32
    temperature = 0
} | ConvertTo-Json -Depth 8

Write-Host "Sending verification prompt..." -ForegroundColor Cyan

$response = Invoke-RestMethod -Method Post -Uri "$BaseUrl/chat/completions" -Headers $headers -Body $body

$text = $response.choices[0].message.content

Write-Host ""
Write-Host "Model response:" -ForegroundColor Cyan
Write-Host $text

if ($text -match "PHONE-CLUSTER-OK") {
    Write-Host ""
    Write-Host "[PASS] Distributed model + OpenAI-compatible API are working." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "[WARN] The API worked, but the model did not return the exact verification phrase." -ForegroundColor Yellow
exit 2
