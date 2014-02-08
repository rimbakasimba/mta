using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace FISCustomize
{
    public partial class _Default : Page
    {
        string client = string.Empty;
        Dictionary<string, List<DB.Column>> tableColumns = null;
        DataTable dt = null;

        protected void Page_Load(object sender, EventArgs e)
        {
            // this will be got from external agent
            client = "starbucks";
            if (!IsPostBack)
            {
                // load all tables from the client template
                string query = "select distinct(table_name) from information_schema.columns where TABLE_SCHEMA='" + client + "'";
                try
                {
                    dt = new DB.DBCalls().ExecuteString(query);
                }
                catch (System.Data.SqlClient.SqlException sqlE)
                {
                    return;
                }
                lstTables.DataSource = dt;
                lstTables.DataTextField = "table_name";
                lstTables.DataValueField = "table_name";
                lstTables.DataBind();
                lstTables.Items.Insert(0, new ListItem("-- Select --", "-1"));

                ddlDataType.DataSource = Enum.GetValues(typeof(System.Data.SqlDbType)).Cast<System.Data.SqlDbType>()
                                               .Select(a => new
                                               {
                                                   Text = a,
                                                   Value = (Int32)a
                                               }).OrderBy(a => a.Text);
                ddlDataType.DataTextField = "Text";
                ddlDataType.DataValueField = "Value";
                ddlDataType.DataBind();

                divColumnAddStatus.InnerHtml = string.Empty;
            }                                                                   
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            tableColumns = (Dictionary<string, List<DB.Column>>)Session["tableColumns"];
            if (null == tableColumns) return;
            var dbo = new DB.DBCalls();

            tableColumns.ToList().ForEach(table =>
            {
                var query = "alter table [" + client + "].[" + table.Key + "] add ";
                table.Value.ForEach(column =>
                {
                    query += "[" + column.ColumnName + "] " + column.DataType.ToString();
                    if ((column.DataType == System.Data.SqlDbType.VarChar) || (column.DataType == System.Data.SqlDbType.NVarChar) || (column.DataType == System.Data.SqlDbType.Char) || (column.DataType == System.Data.SqlDbType.Char) || (column.DataType == System.Data.SqlDbType.NChar))
                    {
                        query += "(" + column.Length.ToString() + ")";
                    }
                    query += (column.IsNullable) ? " null " : " not null ";
                    query +=  (string.IsNullOrEmpty(column.DefaultValue)) ? "" : " default '" + column.DefaultValue + "'";
                    query += ", ";
                });
                query = query.Remove(query.LastIndexOf(","), 2);
                try
                {
                    dbo.ExecuteString(query);
                }
                catch (System.Data.SqlClient.SqlException sqlE)
                {
                }
            });
            
        }

        protected void lstTables_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (lstTables.SelectedValue != "-1")
            {
                // Get data for the table and bind to grid
                var tableName = lstTables.SelectedValue;
                string query = "select column_name, data_type, character_maximum_length, Is_Nullable " +
           "from information_schema.columns where TABLE_SCHEMA='" + client + "' and table_name = '" + tableName + "'";

                try
                {
                    dt = new DB.DBCalls().ExecuteString(query);
                }
                catch (System.Data.SqlClient.SqlException sqlE)
                {
                    return;
                }
                grdColumns.DataSource = dt;
                grdColumns.DataBind();
            }
        }

        protected void btnAddNewColumn_Click(object sender, EventArgs e)
        {
            tableColumns = (Dictionary<string, List<DB.Column>>)Session["tableColumns"];
            if (null == tableColumns) tableColumns = new Dictionary<string, List<DB.Column>>();

            // Get the new column detail and add those to session
            DB.Column newColumn = new DB.Column()
            {
                ColumnName = txtColumnName.Text.Trim(),
                DataType = (System.Data.SqlDbType)Enum.Parse(System.Data.SqlDbType.BigInt.GetType(), ddlDataType.SelectedValue),
                IsNullable = chkIsNullable.Checked,
                Length = (string.IsNullOrWhiteSpace(txtColumnLength.Value)) ? 0 : int.Parse(txtColumnLength.Value)                
            };
            if ((!chkIsNullable.Checked) && (string.IsNullOrEmpty(txtDefault.Text)) )
            {
                // ALTER TABLE only allows columns to be added that can contain nulls, or have a DEFAULT definition specified, or the column being added is an identity or timestamp column, or alternatively if none of the previous conditions are satisfied the table must be empty to allow addition of this column.
                divColumnAddStatus.InnerHtml += "<br /> Please provide default value for column " + txtColumnName.Text;
                return;
            }
            else
            {
                newColumn.DefaultValue = txtDefault.Text.Trim();
            }
            var keyPresent = tableColumns.ContainsKey(lstTables.SelectedValue);
            if ((keyPresent &&
                (null == tableColumns[lstTables.SelectedValue])) || (!keyPresent))
            {
                tableColumns[lstTables.SelectedValue] = new List<DB.Column>();
            }

            tableColumns[lstTables.SelectedValue].Add(newColumn);
            Session["tableColumns"] = tableColumns;

            divColumnAddStatus.InnerHtml += "<br /> " + txtColumnName.Text + " added in package";
            btnSubmit.Visible = true;
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

