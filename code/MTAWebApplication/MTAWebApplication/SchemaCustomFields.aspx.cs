using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml;

namespace MTAWebApplication
{
    public partial class SchemaCustomFields : System.Web.UI.Page
    {                                  
        string tenant; 

        protected void Page_Load(object sender, EventArgs e)
        {        
            if (!IsPostBack)
            {
                txtTenantName.Text = "StarBucks";
                DataTable dt;
                tenant = txtTenantName.Text;
                // Get all tables for starbucks
                string query = "select distinct(table_name) from information_schema.columns where TABLE_SCHEMA='" + tenant + "'";
                try
                {
                    dt = new DB.DBCalls().ExecuteString(query);
                }
                catch (System.Data.SqlClient.SqlException)
                {
                    return;
                }
                ddlTableSchema.DataSource = dt;
                ddlTableSchema.DataTextField = "table_name";
                ddlTableSchema.DataValueField = "table_name";
                ddlTableSchema.DataBind();
                ddlTableSchema.Items.Insert(0, new ListItem("-- Select --", "-1"));
            }
        }

        [System.Web.Services.WebMethod]
        public static string AddSchema(string tenantName, string tenantStrategy, List<CustomField> customFields)
        {
            // Generate schema using these fields
            string init = "<?xml version='1.0' encoding='utf-8'?> <xs:schema id='XMLSchema1' targetNamespace='http://tempuri.org/XMLSchema1.xsd' elementFormDefault='qualified' xmlns='http://tempuri.org/XMLSchema1.xsd' xmlns:mstns='http://tempuri.org/XMLSchema1.xsd' xmlns:xs='http://www.w3.org/2001/XMLSchema' >";
            StringBuilder schema = new StringBuilder(init);
            schema.Append("<xs:element name='Custom'><xs:complexType><xs:sequence>");
            customFields.ForEach(field =>
            {
                // <xs:element name='Age' nillable='true' type='xs:int' />
                schema.AppendFormat("<xs:element name='{0}' ", field.FieldName);
                switch (field.DataType)
                {
                    case CustomField.SchemaDataType.Date: schema.Append(" type='xs:dateTime' "); break;
                    case CustomField.SchemaDataType.Int: schema.Append(" type='xs:int' "); break;
                    case CustomField.SchemaDataType.String: schema.Append(" type='xs:string' "); break;
                }
                if (!string.IsNullOrEmpty(field.Required))
                    schema.AppendFormat("nillable='{0}'", bool.Parse(field.Required).ToString().ToLower());

                schema.Append(" />");
            });
            schema.Append("</xs:sequence></xs:complexType></xs:element></xs:schema>");

            string schemaGenCommand;
            string schemaName;
            string returnMessage;
            if (tenantStrategy == "SDSS")
            {
                returnMessage = "Shared DB Shared Schema: each schema name should have the tenant's identifier and sent to table's metadata for use within individual subqueries";
                schemaName = tenantName + "_" + customFields[0].TableName + "_";
            }
            else if (tenantStrategy == "SDIS")
            {
                returnMessage = "Shared DB Individual Schema: The schema name will be stored as part of table definition and auto-validates the field's value";
                schemaName = customFields[0].TableName + "_";
            }
            else
            {
                returnMessage = "Individual DB: The schema name will be stored as part of table definition and auto-validates the field's value";
                schemaName = customFields[0].TableName + "_";
            }
            schemaGenCommand = string.Format("declare @Xsd xml; set @Xsd = '{0}'; create xml schema collection {1}Schema as  @Xsd;", 
                schema.ToString().Replace("'", "\""), schemaName);
            return returnMessage;
        }
    }

    public class CustomField
    {
        public string TableName { get; set; }
        public string FieldName { get; set; }
        public SchemaDataType DataType { get; set; }
        public string Required { get; set; }

        public enum SchemaDataType
        {
            String,
            Int,
            Date
        }
    }

    namespace DB
    {
        using System.Data;
        using System.Data.SqlClient;

        public struct Column
        {
            public string ColumnName { get; set; }
            public SqlDbType DataType { get; set; }
            public int Length { get; set; }
            public bool IsNullable { get; set; }
            public string DefaultValue { get; set; }
        }
        public class DBCalls
        {      
            private static string connection = "Server=172.16.8.76;Database=MultiTenentPOC;User Id=sa;Password=Tpg@1234";
            public DataTable ExecuteString(string SqlQuery)
            {
                DataTable dt = new DataTable();
                SqlConnection conn = new SqlConnection(connection);
                SqlDataAdapter sda = new SqlDataAdapter(SqlQuery, connection);
                sda.Fill(dt);
                return dt;
            }
        }
    }
}