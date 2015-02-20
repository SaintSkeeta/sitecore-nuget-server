using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Sitecore.Diagnostics;

namespace Sitecore.Strategy.Nuget.Configuration
{
    public class DependencyDescriptor : IDependencyDescriptor
    {
        public DependencyDescriptor(string id)
        {
            Assert.ArgumentNotNullOrEmpty(id, "id");
            this.Id = id;
        }
        public string Id { get; private set; }
        public string MinVersion { get; set; }
        public string MaxVersion { get; set; }
        public bool IsMinInclusive { get; set; }
        public bool IsMaxInclusive { get; set; }
    }
}