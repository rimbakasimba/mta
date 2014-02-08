<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SchemaCustomFields.aspx.cs" Inherits="MTAWebApplication.SchemaCustomFields" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Extend your schema</title>
     <link href="css/bootstrap.css" rel="stylesheet" />
    <link href="css/custom.css" rel="stylesheet"/>
    <script src="jquery-2.0.3.min.js"></script>

    <script>

        var fieldsToBeAdded = [];

        function AddField() {

            var dbType = ["String", "Integer", "Date"];

            var table = $("#" + "<%=ddlTableSchema.ClientID%>").val();
            var fieldName = $("#fieldName").val();
            var dataType = $("#dataType").val();
            var requiredField = $("input[name='required']:checked").val();

            var message = "Adding a field [" + fieldName + "] with datatype [" + dbType[dataType] + "] as required [" + requiredField + "] in table [" + table + "]";

            var field = new Object();
            field.TableName = table;
            field.FieldName = fieldName;
            field.DataType = dataType;
            field.Required = requiredField;
            fieldsToBeAdded.push(field);

            $("#divMessage").append(message + "<br />");
        }

        function SubmitChanges() {

            var webmethod = "SchemaCustomFields.aspx/AddSchema";
            var strategy = $("#tenantStrategy").val();
            var tenantName = $("#" + '<%=txtTenantName.ClientID%>').val();
            var param = JSON.stringify({ tenantName: tenantName, customFields: fieldsToBeAdded, tenantStrategy: strategy });
            //alert(param);
            // debugger;

            $.ajax({
                type: "POST",
                url: webmethod,
                data: param,
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (msg) {
                    alert(msg.d);
                },
                error: function (err) {
                    //debugger;
                    //alert("Error: " + err.responseText);
                }
            });
        }
    </script>
</head>
<body>
     <div class="header">
    	<div class="navbar-header">
            <h2>Multi Tenant Architecture Demo</h2>
          </div>
        <div class="navbar-collapse collapse">
            <ul class="nav navbar-nav navbar-right" style="display:none">
              <li><a href="#/getForm">Get form</a></li>
              <li><a href="#/postForm">post form</a></li>
            </ul>
          </div>
    </div>
    <div class="container">
    	<div class="row">
            <div class="col-lg-2"> </div>
            <div class="col-lg-8">
                <h3>Customize Tenant's Schema</h3>
                <form id="form1" runat="server">
                <div class="form-group">
                    <label for="exampleInputEmail1">Tenant's Name: </label>
                    <asp:Label ID="txtTenantName" runat="server" />
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Select schema to edit</label>
                    <asp:DropDownList ID="ddlTableSchema" class="form-control" runat="server" />
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Field name:</label>
                    <input type="text" class="form-control" id="fieldName" placeholder="Enter your field name" required>
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Field data-type:</label>
                    <select id="dataType" required="required" class="form-control">
                        <option value="0" selected="selected">String</option>
                        <option value="1">Integer</option>
                        <option value="2">Date</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="exampleInputPassword1">Is required field:</label>
                     <input type="radio" name="required" value="true" title="Yes" />Yes&nbsp;
                    <input type="radio" name="required" value="false" title="No" />No
                </div>
                <input class="btn btn-default" type="button" value="Add Field" onclick="javascript: AddField();" />
                    <br /><br />
                <div class="form-group">
                    <label for="exampleInputPassword1">Tenant Strategy:</label>
                    <select id="tenantStrategy" required="required"  class="form-control">
                        <option value="SDSS">Shared Database/Shared Schema</option>
                        <option value="SDIS">Shared Database/Individual Schema</option>
                        <option value="ID">Individual Database</option>
                    </select>
                </div>
                     <div id="divMessage"></div>
                    <input type="button" value="Submit Changes" class="btn btn-default" onclick="javascript: SubmitChanges();" />
                </form>
            </div>
            <div class="col-lg-2"> </div>
        </div>
    </div>
    <!--
    <form id="form1">
        <div id="divDbObjectSelector">
            <table>
                <tr><td>Tenant's Name: </td><td></td></tr>
                <tr>
                    <td>Select schema to edit</td>
                    <td>
                        </td>
                </tr>
            </table>
        </div>
        <div id="divAddSchema" visible="false"></div>
        <div id="divEditSchema" visible="false"></div>
        <div id="divDeleteSchema" visible="false"></div>
    </form>
      
    <div id="divFieldDefinition">
        <table>
            <tr>
                <td>Field name:</td>
                <td>
                    <input type="text" id="fieldName" required="required" /></td>
            </tr>
            <tr>
                <td>Field data-type:</td>
                <td>
                    <select id="dataType" required="required">
                        <option value="0" selected="selected">String</option>
                        <option value="1">Integer</option>
                        <option value="2">Date</option>
                    </select></td>
            </tr>
            <tr>
                <td>Is required field: </td>
                <td>
                    <input type="radio" name="required" value="true" title="Yes" />Yes&nbsp;
                    <input type="radio" name="required" value="false" title="No" />No
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="button" value="Add Field" onclick="javascript: AddField();" /></td>
            </tr>
            <tr>
                <td>Tenant Strategy: </td>
                <td>
                    <select id="tenantStrategy" required="required">
                        <option value="SDSS">Shared Database/Shared Schema</option>
                        <option value="SDIS">Shared Database/Individual Schema</option>
                        <option value="ID">Individual Database</option>
                    </select>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div id="divMessage"></div>
                </td>
            </tr>

            <tr>
                <td colspan="2">
                    <input type="button" value="Submit Changes" onclick="javascript: SubmitChanges();" /></td>
            </tr>
        </table>
    </div>
    -->
</body>

</html>
