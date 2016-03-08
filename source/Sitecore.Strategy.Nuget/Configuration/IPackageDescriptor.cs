using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using NuGet;

namespace Sitecore.Strategy.Nuget.Configuration
{
    public interface IPackageDescriptor
    {
        string Id { get; }
        string Title { get; }
        string Version { get; }
        string Tags { get; }
        string Authors { get; }
        string Owners { get; }
        string Description { get; }
        IList<string> Assemblies { get; }
        IList<PackageDependency> Dependencies { get; }
        void AddAssembly(string path);
        void AddDependency(IDependencyDescriptor descriptor);
    }
}