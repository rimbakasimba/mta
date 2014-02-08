using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
﻿using Microsoft.Practices.Unity;

namespace MTAWebApplication
{
    public partial class ReloadCard : System.Web.UI.Page
    {
        BL.CoreCard coreCard = new BL.CoreCard();

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnReloadCard_Click(object sender, EventArgs e)
        {
            string client = Request.QueryString["client"];
            var unityContainer = (Application["UnityInit"] as UnityIntegration).UnityContainer;

            BL.IReloadCard reloadAPI;
            
            if (client == "starbucks")
            {
                reloadAPI = unityContainer.Resolve<BL.IReloadCard>("StarBucks");
            }
            else
            {
                reloadAPI = unityContainer.Resolve<BL.IReloadCard>("Core");
            }
               
            reloadAPI.ReloadCard(txtCardNumber.Text, float.Parse(txtAmount.Text));
        }
    }
}