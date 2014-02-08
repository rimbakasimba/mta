using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using Microsoft.Practices.Unity;

namespace MTAWebApplication
{
    public class UnityIntegration
    {
        private IUnityContainer container;

        public IUnityContainer UnityContainer { get { return this.container; } }

        public UnityIntegration()
        {
            ConfigureUnity();
        }

        private void ConfigureUnity()
        {
            container = new UnityContainer();

            // setup all types of cards and their overloads
            container.RegisterType<BL.IReloadCard, BL.CoreCard>("Core");
            container.RegisterType<BL.IReloadCard, BL.StarBucksCard>("StarBucks");
        }
    }
}