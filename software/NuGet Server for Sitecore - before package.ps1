$dialog = New-Object System.Windows.Forms.OpenFileDialog
$dialog.Title = "Please select web.config"
$dialog.InitialDirectory = "C:\"
$dialog.FileName = "Web.config"
$dialog.Filter = "Config Files (*.config)|*.config"
$result = $dialog.ShowDialog()
if ($result -ne “OK”) 
{
    Write-Host “Cancelled by user”
    Exit-PSSession
}
else 
{
    $path = $dialog.FileName

    $xml = [xml](Get-Content $path)

    $config = $xml.configuration;

    $shEnv = $config.'system.serviceModel'.SelectSingleNode("serviceHostingEnvironment")
    if ($shEnv -eq $null)
    {
        $shEnv = $xml.CreateElement("serviceHostingEnvironment")
        $config.'system.serviceModel'.AppendChild($shEnv) | Out-Null
    }

    $attr = $shEnv.Attributes["aspNetCompatibilityEnabled"]
    if ($attr -eq $null)
    {
        $attr = $xml.CreateAttribute("aspNetCompatibilityEnabled")
        $shEnv.Attributes.Append($attr) | Out-Null
    }
    $attr.Value = "true"

    $xml.Save($path)
}
