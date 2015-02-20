using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NuGet;

namespace Sitecore.Strategy.Nuget.Configuration
{
    public interface INugetConfiguration
    {
        string AssemblyPath { get; }
        IList<PackageBuilder> Packages { get; }
        void AddPackage(IPackageDescriptor descriptor);
    }
}
