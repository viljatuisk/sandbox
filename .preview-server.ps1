$ErrorActionPreference = 'Stop'
$root = 'C:\Users\Viljatui\SandBox'
$prefix = 'http://localhost:8790/'
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($prefix)
$listener.Start()
Write-Host "Serving $root at $prefix"
$mime = @{ '.html'='text/html'; '.png'='image/png'; '.jpeg'='image/jpeg'; '.jpg'='image/jpeg'; '.css'='text/css'; '.js'='application/javascript' }
while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $rel = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ([string]::IsNullOrEmpty($rel)) { $rel = 'hankija-automaatika-koolitus.html' }
    $path = Join-Path $root $rel
    if (Test-Path $path -PathType Leaf) {
      $bytes = [System.IO.File]::ReadAllBytes($path)
      $ext = [System.IO.Path]::GetExtension($path).ToLower()
      if ($mime.ContainsKey($ext)) { $ctx.Response.ContentType = $mime[$ext] }
      $ctx.Response.Headers.Add('Cache-Control','no-store, no-cache, must-revalidate')
      $ctx.Response.Headers.Add('Pragma','no-cache')
      $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
    } else {
      $ctx.Response.StatusCode = 404
    }
    $ctx.Response.Close()
  } catch {}
}
