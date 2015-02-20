using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NuGet;
using Sitecore.Diagnostics;

namespace Sitecore.Strategy.Nuget.Configuration
{
    public class PackageDescriptor : IPackageDescriptor
    {
        public PackageDescriptor(string id)
        {
            Assert.ArgumentNotNullOrEmpty(id, "id");
            this.Id = id;
            this.Assemblies = new List<string>();
            this.Dependencies = new List<PackageDependency>();
        }
        public string Id { get; private set; }
        public string Version { get; set; }
        public string Authors { get; set; }
        public string Description { get; set; }
        public IList<string> Assemblies { get; private set; }
        public IList<PackageDependency> Dependencies { get; private set; }
        public void AddAssembly(string path)
        {
            if (this.Assemblies.Contains(path))
            {
                return;
            }
            this.Assemblies.Add(path);
        }

        protected virtual PackageDependency Convert(IDependencyDescriptor descriptor)
        {
            var version = new VersionSpec()
            {
                IsMaxInclusive = descriptor.IsMaxInclusive,
                IsMinInclusive = descriptor.IsMinInclusive,
            };
            if (!string.IsNullOrEmpty(descriptor.MinVersion))
            {
                version.MinVersion = new SemanticVersion(descriptor.MinVersion);
            }
            if (!string.IsNullOrEmpty(descriptor.MaxVersion))
            {
                version.MaxVersion = new SemanticVersion(descriptor.MaxVersion);
            }
            var dependency = new PackageDependency(descriptor.Id, version);
            return dependency;
        }

        public void AddDependency(IDependencyDescriptor descriptor)
        {
            var dependency = Convert(descriptor);
            if (this.Dependencies.Contains(dependency))
            {
                return;
            }
            this.Dependencies.Add(dependency);
        }
    }
}