using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Sitecore.Strategy.Nuget.Configuration
{
    public interface IDependencyDescriptor
    {
        string Id { get; }
        string MinVersion { get; }
        string MaxVersion { get; }
        bool IsMinInclusive { get; }
        bool IsMaxInclusive { get; }
    }
}
