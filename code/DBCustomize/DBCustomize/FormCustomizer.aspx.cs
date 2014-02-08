using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FISCustomize
{
    public partial class FormCustomizer : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            var clientName = txtClient.Text;
            var style = ddlStyle.SelectedValue;
            StringBuilder lessGenerator = new StringBuilder();
            lessGenerator.Append("@import '../base/offcanvas.less';");
            lessGenerator.Append(".row-off-canvas-slide{");
            if (style == "LR")
            {
                lessGenerator.Append(".canvasforleft(@left);} ");
            }
            else
            {
                lessGenerator.Append(".canvasforright(@right);} ");
            }
            
            var fileName = Server.MapPath(@"lessStyle\client\" + clientName + ".less");
            if (File.Exists(fileName)) File.Delete(fileName);

            var  lessFile = new StreamWriter(fileName);
            lessFile.Write(lessGenerator.ToString());
            lessFile.Close();

            lblStatus.Text = "Style has been customized. Please reload/refresh the application to see the changes";
        }
    }
}