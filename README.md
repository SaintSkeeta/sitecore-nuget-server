# Nuget Server for Sitecore
Sitecore module that adds a Nuget server to your Sitecore server. It also dynamically generates Nuget packages for Sitecore assemblies.

### Installation instructions
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

### Configuration
Nuget Server for Sitecore dynamically generates Nuget packages based on configuration settings. The module includes 3 packages. These packages are defined in [Sitecore.Strategy.Nuget.config](https://github.com/adamconn/sitecore-nuget-server/raw/master/source/Sitecore.Strategy.Nuget/App_Config/Include/Sitecore.Strategy.Nuget.config).

It is probably easier for you to understand the configuration by looking at the file, but here's an overview of what you're configuring:
* **Package** - a package has an ID. This is a string value that uniquely identifies the package so it can be retrieved from the Nuget server and so other packages can identify a package as a dependency.  
* **Version** - a number that is used for dependencies. This value is important when breaking API changes are introduced to a package.
* **Assemblies** - dll files that are added to a project.
* **Dependencies** - other Nuget packages that must be downloaded.