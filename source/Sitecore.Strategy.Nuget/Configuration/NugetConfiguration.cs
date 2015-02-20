using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using NuGet;
using Sitecore.Diagnostics;

namespace Sitecore.Strategy.Nuget.Configuration
{
    // https://searchcode.com/codesearch/view/27865725/
    // http://stackoverflow.com/questions/6808868/howto-create-a-nuget-package-using-nuget-core
    public class NugetConfiguration : INugetConfiguration
    {
        public NugetConfiguration()
        {
            this.Packages = new List<PackageBuilder>();
        }
        public string AssemblyPath { get; set; }
        public IList<PackageBuilder> Packages { get; private set; }
        public void AddPackage(IPackageDescriptor descriptor)
        {
            var package = Convert(descriptor);
            if (package == null || this.Packages.Contains(package))
            {
                return;
            }
            this.Packages.Add(package);
        }

        protected virtual PackageBuilder Convert(IPackageDescriptor descriptor)
        {
            Assert.ArgumentNotNull(descriptor, "descriptor");
            //
            var metadata = new ManifestMetadata()
            {
                Id = descriptor.Id,
                Authors = descriptor.Authors,
                Description = descriptor.Description,
                Version = descriptor.Version
            };
            //
            var builder = new PackageBuilder();
            builder.Populate(metadata);
            try
            {
                AddAssemblies(builder, descriptor, this.AssemblyPath);
                AddDependencies(builder, descriptor);
            }
            catch (FileNotFoundException ex)
            {
                Log.Error(string.Format("Unable to convert the IPackageDescriptor {0} to a PackageBuilder because the file {1} cannot be found.", descriptor.Id, ex.FileName),ex, this);
                return null;
            }
            return builder;
        }

        protected virtual void AddAssemblies(PackageBuilder builder, IPackageDescriptor descriptor, string assemblyPath)
        {
            if (descriptor.Assemblies.Count == 0)
            {
                return;
            }
            var assemblies = new List<ManifestFile>();
            var tempPath = System.Web.Hosting.HostingEnvironment.MapPath(this.AssemblyPath);
            if (tempPath != null)
            {
                assemblyPath = tempPath;
            }
            foreach (var path in descriptor.Assemblies)
            {
                if (string.IsNullOrWhiteSpace(path))
                {
                    continue;
                }
                var sourcePath = Path.Combine(assemblyPath, path);
                if (! File.Exists(sourcePath))
                {
                    throw new FileNotFoundException("Cannot add assembly because file cannot be found", sourcePath);
                }
                var assembly = new ManifestFile()
                {
                    Source = sourcePath,
                    Target = "lib"
                };
                assemblies.Add(assembly);
            }
            builder.PopulateFiles(assemblyPath, assemblies);
        }
        protected virtual void AddDependencies(PackageBuilder builder, IPackageDescriptor descriptor)
        {
            if (descriptor.Dependencies.Count == 0)
            {
                return;
            }
            var dependencySet = new PackageDependencySet(VersionUtility.DefaultTargetFramework, descriptor.Dependencies);
            builder.DependencySets.Add(dependencySet);
        }



    }
}