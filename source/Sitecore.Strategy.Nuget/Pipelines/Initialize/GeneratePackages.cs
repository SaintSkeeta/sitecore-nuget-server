using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using NuGet;
using Sitecore.Diagnostics;
using Sitecore.Pipelines;
using Sitecore.Strategy.Nuget.Configuration;

namespace Sitecore.Strategy.Nuget.Pipelines.Initialize
{
    public class GeneratePackages
    {
        public INugetConfiguration Configuration { get; set; }

        public virtual void Process(PipelineArgs args)
        {
            Assert.IsNotNull(this.Configuration, "Configuration must be specified");
            var packagePath = NuGet.Server.Infrastructure.PackageUtility.PackagePhysicalPath; 
            RemoveExistingPackages(packagePath);
            foreach (var package in this.Configuration.Packages)
            {
                var path = Path.Combine(packagePath, GetPackageFileName(package));
                using (var stream = File.Open(path, FileMode.OpenOrCreate))
                {
                    package.Save(stream);
                }
            }
        }

        protected virtual string GetPackageFileName(PackageBuilder package)
        {
            Assert.ArgumentNotNull(package, "package");
            var nameBuilder = new StringBuilder(package.Id);
            if (package.Version != null)
            {
                nameBuilder.AppendFormat(".{0}", package.Version.ToString());
            }
            nameBuilder.Append(".nupkg");
            return nameBuilder.ToString();
        }

        protected virtual void RemoveExistingPackages(string path)
        {
            var directory = new DirectoryInfo(path);
            foreach (var file in directory.GetFiles())
            {
                file.Delete();
            }
        }
    }
}