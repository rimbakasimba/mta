<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FormCustomizer.aspx.cs" Inherits="FISCustomize.FormCustomizer" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <table style="width: 100%; border: solid black 1px">
                <tr>
                    <td colspan="2">Customize user interface</td>
                </tr>
                <tr style="border: solid black 1px">
                    <td>Client:</td>
                    <td>
                        <asp:TextBox ID="txtClient" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvClient" runat="server" ControlToValidate="txtClient" Display="Dynamic" ErrorMessage="*" ForeColor="Red" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td>Off-Canvas Style:</td>
                    <td><asp:DropDownList ID="ddlStyle" runat="server">
                        <asp:ListItem Selected="True" Text="Placed left and opens to right" Value="LR" />
                        <asp:ListItem Text="Placed right and opens to left" Value="RL" />
                    </asp:DropDownList></td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="btnSubmit" runat="server" Text="Generate Style" OnClick="btnSubmit_Click" /></td>
                    <td>
                        <asp:Label ID="lblStatus" runat="server" /></td>
                </tr>
            </table>
        </div>
    </form>
</body>
</html>
