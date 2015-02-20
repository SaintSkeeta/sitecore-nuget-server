# NuGet Server for Sitecore
Sitecore module that adds a NuGet server to your Sitecore server. It also dynamically generates Nuget packages for Sitecore assemblies.

* [Demo video](#demo)
* [Installation instructions (scripted)](#installation-scripted)
* [Installation instructions (manual)](#installation-manual)
* [Visual Studio configuration](#vsconfig)
* [NuGet package configuration](#nugetconfig)

### <a name="demo">Demo video</a>
[This video](https://www.youtube.com/watch?v=vgehATYyvYw) shows how to configure Visual Studio to use NuGet Server for Sitecore and how to add references to NuGet packages hosted on NuGet Server for Sitecore.

### <a name="installation-scripted">Installation instructions (scripted)</a>
These instructions use a PowerShell script to modify `web.config`. If you don't feel comfortable letting a script modify this file you should follow the [manual installation instructions](#installation-manual).

*NOTE: While these scripts have been tested and work just fine, they may be some of the ugliest PowerShell scripts ever written.*

**Step 1.** Run the [before package](https://github.com/adamconn/sitecore-nuget-server/raw/master/software/NuGet%20Server%20for%20Sitecore%20-%20before%20package.ps1) PowerShell script
**Step 2.** Install the [Sitecore installation package](https://github.com/adamconn/sitecore-nuget-server/raw/master/software/Nuget%20Server%20for%20Sitecore-1.0.zip)
**Step 3.** Run the [after package](https://github.com/adamconn/sitecore-nuget-server/raw/master/software/NuGet%20Server%20for%20Sitecore%20-%20after%20package.ps1) PowerShell script

### <a name="installation-manual">Installation instructions (manual)</a>
**Step 1.** Add the following to `configuration > system.serviceModel` 

```xml
<serviceHostingEnvironment aspNetCompatibilityEnabled="true"/>
```

**Step 2.** Install the [Sitecore installation package](https://github.com/adamconn/sitecore-nuget-server/raw/master/software/Nuget%20Server%20for%20Sitecore-1.0.zip)
**Step 3.** Add the following to `configuration > configSections`
```xml
    <sectionGroup name="elmah">
      <section name="security" requirePermission="false" type="Elmah.SecuritySectionHandler, Elmah"/>
      <section name="errorLog" requirePermission="false" type="Elmah.ErrorLogSectionHandler, Elmah"/>
      <section name="errorMail" requirePermission="false" type="Elmah.ErrorMailSectionHandler, Elmah"/>
      <section name="errorFilter" requirePermission="false" type="Elmah.ErrorFilterSectionHandler, Elmah"/>
    </sectionGroup>
```

**Step 4.** Add the following to `configuration > appSettings`
```xml
    <add key="requireApiKey" value="true"/>
    <add key="apiKey" value=""/>
    <add key="packagesPath" value=""/>
    <add key="allowOverrideExistingPackageOnPush" value="true"/>
    <add key="enableDelisting" value="false"/>
    <add key="enableFrameworkFiltering" value="false"/>
```

**Step 5.** Add the following to `configuration > system.webServer > modules`
```xml
      <add name="ErrorLog" type="Elmah.ErrorLogModule, Elmah" preCondition="managedHandler"/>
      <add name="ErrorMail" type="Elmah.ErrorMailModule, Elmah" preCondition="managedHandler"/>
      <add name="ErrorFilter" type="Elmah.ErrorFilterModule, Elmah" preCondition="managedHandler"/>
```

**Step 6**. Add the following to `configuration > system.webServer`
```xml
    <staticContent>
      <mimeMap fileExtension=".nupkg" mimeType="application/zip"/>
    </staticContent>
```

**Step 7.** Add the following to `configuration > system.web > httpModules`
```xml
      <add name="ErrorLog" type="Elmah.ErrorLogModule, Elmah"/>
      <add name="ErrorMail" type="Elmah.ErrorMailModule, Elmah"/>
      <add name="ErrorFilter" type="Elmah.ErrorFilterModule, Elmah"/>
```

**Step 8.** Add the following to `configuration`
```xml
  <elmah>
    <security allowRemoteAccess="false"/>
    <errorLog type="Elmah.XmlFileErrorLog, Elmah" logPath="~/App_Data"/>
  </elmah>
  <location path="elmah.axd" inheritInChildApplications="false">
    <system.web>
      <httpHandlers>
        <add verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah"/>
      </httpHandlers>
    </system.web>
    <system.webServer>
      <handlers>
        <add name="ELMAH" verb="POST,GET,HEAD" path="elmah.axd" type="Elmah.ErrorLogPageFactory, Elmah" preCondition="integratedMode"/>
      </handlers>
    </system.webServer>
  </location>
```

### <a name="vsconfig">Visual Studio configuration</a>
After you have installed the module on your Sitecore server you must add your Sitecore server as a package source in Visual Studio.

1. In Visual Studio open `Tools > Options > NuGet Package Manager > Package Sources`
2. Add a new source. For the URL use `http://[yourhost]/nuget`

### <a name="nugetconfig">NuGet package configuration</a>
NuGet Server for Sitecore dynamically generates NuGet packages based on configuration settings. The module includes 3 packages. These packages are defined in [Sitecore.Strategy.Nuget.config](https://github.com/adamconn/sitecore-nuget-server/raw/master/source/Sitecore.Strategy.Nuget/App_Config/Include/Sitecore.Strategy.Nuget.config).

It is probably easier for you to understand the configuration by looking at the file, but here's an overview of what you're configuring:
* **Package** - a package has an ID. This is a string value that uniquely identifies the package so it can be retrieved from the Nuget server and so other packages can identify a package as a dependency.  
* **Version** - a number that is used for dependencies. This value is important when breaking API changes are introduced to a package.
* **Assemblies** - dll files that are added to a project.
* **Dependencies** - other Nuget packages that must be downloaded.