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

    $configSections = $config.configSections

    $elmahSection = $configSections.SelectSingleNode("sectionGroup[@name='elmah']")

    if ($elmahSection -eq $null)
    {
        $elmahAttr = $xml.CreateAttribute("name")
        $elmahAttr.Value = "elmah"
        $elmahSection = $xml.CreateElement("sectionGroup")
        $elmahSection.Attributes.Append($elmahAttr) | Out-Null
        $configSections.AppendChild($elmahSection) | Out-Null
    }

    $elmahNode = $elmahSection.SelectSingleNode("section[@name='security']")
    if ($elmahNode -eq $null)
    {
        $elmahAttr1 = $xml.CreateAttribute("name")
        $elmahAttr1.Value = "security"
        $elmahAttr2 = $xml.CreateAttribute("requirePermission")
        $elmahAttr2.Value = "false"
        $elmahAttr3 = $xml.CreateAttribute("type")
        $elmahAttr3.Value = "Elmah.SecuritySectionHandler, Elmah"
        $elmahNode = $xml.CreateElement("section")
        $elmahNode.Attributes.Append($elmahAttr1) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr2) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr3) | Out-Null
        $elmahSection.AppendChild($elmahNode) | Out-Null
    }
    $elmahNode = $elmahSection.SelectSingleNode("section[@name='errorLog']")
    if ($elmahNode -eq $null)
    {
        $elmahAttr1 = $xml.CreateAttribute("name")
        $elmahAttr1.Value = "errorLog"
        $elmahAttr2 = $xml.CreateAttribute("requirePermission")
        $elmahAttr2.Value = "false"
        $elmahAttr3 = $xml.CreateAttribute("type")
        $elmahAttr3.Value = "Elmah.ErrorLogSectionHandler, Elmah"
        $elmahNode = $xml.CreateElement("section")
        $elmahNode.Attributes.Append($elmahAttr1) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr2) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr3) | Out-Null
        $elmahSection.AppendChild($elmahNode) | Out-Null
    }
    $elmahNode = $elmahSection.SelectSingleNode("section[@name='errorMail']")
    if ($elmahNode -eq $null)
    {
        $elmahAttr1 = $xml.CreateAttribute("name")
        $elmahAttr1.Value = "errorMail"
        $elmahAttr2 = $xml.CreateAttribute("requirePermission")
        $elmahAttr2.Value = "false"
        $elmahAttr3 = $xml.CreateAttribute("type")
        $elmahAttr3.Value = "Elmah.ErrorMailSectionHandler, Elmah"
        $elmahNode = $xml.CreateElement("section")
        $elmahNode.Attributes.Append($elmahAttr1) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr2) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr3) | Out-Null
        $elmahSection.AppendChild($elmahNode) | Out-Null
    }
    $elmahNode = $elmahSection.SelectSingleNode("section[@name='errorFilter']")
    if ($elmahNode -eq $null)
    {
        $elmahAttr1 = $xml.CreateAttribute("name")
        $elmahAttr1.Value = "errorFilter"
        $elmahAttr2 = $xml.CreateAttribute("requirePermission")
        $elmahAttr2.Value = "false"
        $elmahAttr3 = $xml.CreateAttribute("type")
        $elmahAttr3.Value = "Elmah.ErrorFilterSectionHandler, Elmah"
        $elmahNode = $xml.CreateElement("section")
        $elmahNode.Attributes.Append($elmahAttr1) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr2) | Out-Null
        $elmahNode.Attributes.Append($elmahAttr3) | Out-Null
        $elmahSection.AppendChild($elmahNode) | Out-Null
    }

    #################################################
    
    $appSettingsSection = $config.appSettings
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='requireApiKey']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'requireApiKey'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = 'true'
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='apiKey']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'apiKey'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = ''
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='packagesPath']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'packagesPath'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = ''
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='allowOverrideExistingPackageOnPush']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'allowOverrideExistingPackageOnPush'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = 'true'
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='enableDelisting']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'enableDelisting'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = 'false'
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    $appSetting = $appSettingsSection.SelectSingleNode("add[@key='enableFrameworkFiltering']")
    if ($appSetting -eq $null)
    {
        $appSettingAttr1 = $xml.CreateAttribute("key")
        $appSettingAttr1.Value = 'enableFrameworkFiltering'
        $appSettingAttr2 = $xml.CreateAttribute("value")
        $appSettingAttr2.Value = 'false'
        $appSetting = $xml.CreateElement("add")
        $appSetting.Attributes.Append($appSettingAttr1) | Out-Null
        $appSetting.Attributes.Append($appSettingAttr2) | Out-Null
        $appSettingsSection.AppendChild($appSetting) | Out-Null
    }
    
    #################################################

    $webserver = $config.'system.webServer'

    $modules = $webserver.modules

    $module = $modules.SelectSingleNode("add[@name='ErrorLog']")
    if ($module -eq $null)
    {
        $moduleAttr1 = $xml.CreateAttribute("name")
        $moduleAttr1.Value = 'ErrorLog'
        $moduleAttr2 = $xml.CreateAttribute("type")
        $moduleAttr2.Value = 'Elmah.ErrorLogModule, Elmah'
        $moduleAttr3 = $xml.CreateAttribute("preCondition")
        $moduleAttr3.Value = 'managedHandler'

        $module = $xml.CreateElement("add")
        $module.Attributes.Append($moduleAttr1) | Out-Null
        $module.Attributes.Append($moduleAttr2) | Out-Null
        $module.Attributes.Append($moduleAttr3) | Out-Null
        $modules.AppendChild($module) | Out-Null
    }
    $module = $modules.SelectSingleNode("add[@name='ErrorMail']")
    if ($module -eq $null)
    {
        $moduleAttr1 = $xml.CreateAttribute("name")
        $moduleAttr1.Value = 'ErrorMail'
        $moduleAttr2 = $xml.CreateAttribute("type")
        $moduleAttr2.Value = 'Elmah.ErrorMailModule, Elmah'
        $moduleAttr3 = $xml.CreateAttribute("preCondition")
        $moduleAttr3.Value = 'managedHandler'

        $module = $xml.CreateElement("add")
        $module.Attributes.Append($moduleAttr1) | Out-Null
        $module.Attributes.Append($moduleAttr2) | Out-Null
        $module.Attributes.Append($moduleAttr3) | Out-Null
        $modules.AppendChild($module) | Out-Null
    }
    $module = $modules.SelectSingleNode("add[@name='ErrorFilter']")
    if ($module -eq $null)
    {
        $moduleAttr1 = $xml.CreateAttribute("name")
        $moduleAttr1.Value = 'ErrorFilter'
        $moduleAttr2 = $xml.CreateAttribute("type")
        $moduleAttr2.Value = 'Elmah.ErrorFilterModule, Elmah'
        $moduleAttr3 = $xml.CreateAttribute("preCondition")
        $moduleAttr3.Value = 'managedHandler'

        $module = $xml.CreateElement("add")
        $module.Attributes.Append($moduleAttr1) | Out-Null
        $module.Attributes.Append($moduleAttr2) | Out-Null
        $module.Attributes.Append($moduleAttr3) | Out-Null
        $modules.AppendChild($module) | Out-Null
    }

    #################################################

    $staticContent = $webserver.SelectSingleNode("staticContent")
    if ($staticContent -eq $null) 
    {
        $staticContent = $xml.CreateElement("staticContent")
        $webserver.AppendChild($staticContent) | Out-Null
    }

    $mimeMap = $staticContent.SelectSingleNode("mimeMap[@fileExtension='.nupkg']")
    if ($mimeMap -eq $null)
    {
        $mimeMapAttr1 = $xml.CreateAttribute("fileExtension")
        $mimeMapAttr1.Value = '.nupkg'
        $mimeMapAttr2 = $xml.CreateAttribute("mimeType")
        $mimeMapAttr2.Value = 'application/zip'

        $mimeMap = $xml.CreateElement("mimeMap")
        $mimeMap.Attributes.Append($mimeMapAttr1) | Out-Null
        $mimeMap.Attributes.Append($mimeMapAttr2) | Out-Null

        $staticContent.AppendChild($mimeMap) | Out-Null
    }

    #################################################

    $httpModules = $config.'system.web'.httpModules

    $httpModule = $httpModules.SelectSingleNode("add[@name='ErrorLog']")
    if ($httpModule -eq $null)
    {
        $httpModuleAttr1 = $xml.CreateAttribute("name")
        $httpModuleAttr1.Value = 'ErrorLog'
        $httpModuleAttr2 = $xml.CreateAttribute("type")
        $httpModuleAttr2.Value = 'Elmah.ErrorLogModule, Elmah'

        $httpModule = $xml.CreateElement("add")
        $httpModule.Attributes.Append($httpModuleAttr1) | Out-Null
        $httpModule.Attributes.Append($httpModuleAttr2) | Out-Null
        $httpModules.AppendChild($httpModule) | Out-Null
    }
    $httpModule = $modules.SelectSingleNode("add[@name='ErrorMail']")
    if ($httpModule -eq $null)
    {
        $httpModuleAttr1 = $xml.CreateAttribute("name")
        $httpModuleAttr1.Value = 'ErrorMail'
        $httpModuleAttr2 = $xml.CreateAttribute("type")
        $httpModuleAttr2.Value = 'Elmah.ErrorMailModule, Elmah'

        $httpModule = $xml.CreateElement("add")
        $httpModule.Attributes.Append($httpModuleAttr1) | Out-Null
        $httpModule.Attributes.Append($httpModuleAttr2) | Out-Null
        $httpModules.AppendChild($httpModule) | Out-Null
    }
    $httpModule = $modules.SelectSingleNode("add[@name='ErrorFilter']")
    if ($httpModule -eq $null)
    {
        $httpModuleAttr1 = $xml.CreateAttribute("name")
        $httpModuleAttr1.Value = 'ErrorFilter'
        $httpModuleAttr2 = $xml.CreateAttribute("type")
        $httpModuleAttr2.Value = 'Elmah.ErrorFilterModule, Elmah'

        $httpModule = $xml.CreateElement("add")
        $httpModule.Attributes.Append($httpModuleAttr1) | Out-Null
        $httpModule.Attributes.Append($httpModuleAttr2) | Out-Null
        $httpModules.AppendChild($httpModule) | Out-Null
    }

    #################################################

    $elmah = $config.SelectSingleNode("elmah")
    if ($elmah -eq $null)
    {
        $elmah = $xml.CreateElement("elmah")
        $config.AppendChild($elmah) | Out-Null
    }

    $security = $elmah.SelectSingleNode("security")
    if ($security -eq $null)
    {
        $security = $xml.CreateElement("security")
        $elmah.AppendChild($security) | Out-Null
        $securityAttr1 = $xml.CreateAttribute("allowRemoteAccess")
        $securityAttr1.Value = "false"
        $security.Attributes.Append($securityAttr1) | Out-Null
    }
    $errorLog  = $elmah.SelectSingleNode("errorLog")
    if ($errorLog -eq $null)
    {
        $errorLog  = $xml.CreateElement("errorLog")
        $elmah.AppendChild($errorLog ) | Out-Null
        $errorLogAttr1 = $xml.CreateAttribute("type")
        $errorLogAttr1.Value = "Elmah.XmlFileErrorLog, Elmah"
        $errorLog.Attributes.Append($errorLogAttr1) | Out-Null
        $errorLogAttr2 = $xml.CreateAttribute("logPath")
        $errorLogAttr2.Value = "~/App_Data"
        $errorLog.Attributes.Append($errorLogAttr2) | Out-Null
    }

    #################################################

    $location = $config.SelectSingleNode("location")
    if ($location -eq $null)
    {
        $location = $xml.CreateElement("location")
        $config.AppendChild($location) | Out-Null
        $locationAttr1 = $xml.CreateAttribute("path")
        $locationAttr1.Value = 'elmah.axd'
        $location.Attributes.Append($locationAttr1) | Out-Null
        $locationAttr2 = $xml.CreateAttribute("inheritInChildApplications")
        $locationAttr2.Value = 'false'
        $location.Attributes.Append($locationAttr2) | Out-Null
    }

    $systemWeb = $location.SelectSingleNode("system.web")
    if ($systemWeb -eq $null)
    {
        $systemWeb = $xml.CreateElement("system.web")
        $location.AppendChild($systemWeb) | Out-Null
    }
    $httpHandlers = $systemWeb.SelectSingleNode("httpHandlers")
    if ($httpHandlers -eq $null)
    {
        $httpHandlers = $xml.CreateElement("httpHandlers")
        $systemWeb.AppendChild($httpHandlers) | Out-Null
    }
    $httpHandler = $systemWeb.SelectSingleNode("add[@path='elmah.axd']")
    if ($httpHandler -eq $null)
    {
        $httpHandler = $xml.CreateElement("add")
        $httpHandlers.AppendChild($httpHandler) | Out-Null
        $httpHandlerAttr1 = $xml.CreateAttribute("verb")
        $httpHandlerAttr1.Value = 'POST,GET,HEAD'
        $httpHandler.Attributes.Append($httpHandlerAttr1) | Out-Null
        $httpHandlerAttr2 = $xml.CreateAttribute("path")
        $httpHandlerAttr2.Value = 'elmah.axd'
        $httpHandler.Attributes.Append($httpHandlerAttr2) | Out-Null
        $httpHandlerAttr3 = $xml.CreateAttribute("type")
        $httpHandlerAttr3.Value = 'Elmah.ErrorLogPageFactory, Elmah'
        $httpHandler.Attributes.Append($httpHandlerAttr3) | Out-Null
    }

    $systemWebServer = $location.SelectSingleNode("system.webServer")
    if ($systemWebServer -eq $null)
    {
        $systemWebServer = $xml.CreateElement("system.webServer")
        $location.AppendChild($systemWebServer) | Out-Null
    }
    $handlers = $systemWebServer.SelectSingleNode("handlers")
    if ($handlers -eq $null)
    {
        $handlers = $xml.CreateElement("handlers")
        $systemWebServer.AppendChild($handlers) | Out-Null
    }
    $handler = $systemWebServer.SelectSingleNode("add[@path='elmah.axd']")
    if ($handler -eq $null)
    {
        $handler = $xml.CreateElement("add")
        $handlers.AppendChild($handler) | Out-Null
        $handlerAttr1 = $xml.CreateAttribute("verb")
        $handlerAttr1.Value = 'POST,GET,HEAD'
        $handler.Attributes.Append($handlerAttr1) | Out-Null
        $handlerAttr2 = $xml.CreateAttribute("path")
        $handlerAttr2.Value = 'elmah.axd'
        $handler.Attributes.Append($handlerAttr2) | Out-Null
        $handlerAttr3 = $xml.CreateAttribute("type")
        $handlerAttr3.Value = 'Elmah.ErrorLogPageFactory, Elmah'
        $handler.Attributes.Append($handlerAttr3) | Out-Null
        $handlerAttr4 = $xml.CreateAttribute("preCondition")
        $handlerAttr4.Value = 'integratedMode'
        $handler.Attributes.Append($handlerAttr4) | Out-Null
    }

    $xml.Save($path)
}
