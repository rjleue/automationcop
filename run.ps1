$port = 9000
$url = "http://localhost:$port/"
$indexFilePath = "$PWD\index.html"

# Create HttpListener instance
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($url)

# Start listening for requests
$listener.Start()

Write-Host "Web server is running. Press Ctrl+C to stop."

# Process incoming requests
while ($listener.IsListening) {
    $context = $listener.GetContext()
    $response = $context.Response

    # Serve the index.html file
    if ($context.Request.Url.LocalPath -eq "/") {
        $content = Get-Content -Path $indexFilePath -Raw
        $buffer = [System.Text.Encoding]::UTF8.GetBytes($content)

        $response.StatusCode = 200
        $response.ContentLength64 = $buffer.Length
        $response.OutputStream.Write($buffer, 0, $buffer.Length)
        $response.OutputStream.Close()
    } else {
        # Handle other requests (e.g., 404)
        $response.StatusCode = 404
        $response.StatusDescription = "Not Found"
        $response.Close()
    }
}

# Stop the listener
$listener.Stop()
