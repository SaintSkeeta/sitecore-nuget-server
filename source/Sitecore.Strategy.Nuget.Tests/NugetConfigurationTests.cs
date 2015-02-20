using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NuGet;
using Sitecore.Strategy.Nuget.Configuration;

namespace Sitecore.Strategy.Nuget.Tests
{
    [TestClass]
    public class NugetConfigurationTests
    {
        [TestMethod]
        public void ReadConfigurationTest()
        {
            var config = Sitecore.Configuration.Factory.CreateObject("nuget/configuration", true) as INugetConfiguration;
            Assert.IsNotNull(config);
            Assert.AreEqual(1, config.Packages.Count);
            Assert.AreEqual(1, config.Packages.FirstOrDefault().Files.Count);
            Assert.AreEqual(1, config.Packages.FirstOrDefault().DependencySets.FirstOrDefault().Dependencies.Count);
            Assert.AreEqual("Sitecore", config.Packages.FirstOrDefault().Authors.FirstOrDefault());
            Assert.AreEqual("This package contains the runtime assemblies for Sitecore 8.", config.Packages.FirstOrDefault().Description);
            Assert.AreEqual("Sitecore.Kernel", config.Packages.FirstOrDefault().Id);
            Assert.AreEqual(new SemanticVersion("8.0"), config.Packages.FirstOrDefault().Version);
        }
    }
}
