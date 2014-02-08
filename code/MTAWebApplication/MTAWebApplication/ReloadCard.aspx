<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ReloadCard.aspx.cs" Inherits="MTAWebApplication.ReloadCard" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
                <table><tr><td>Card Number</td><td>
                    <asp:TextBox runat="server" ID="txtCardNumber" /></td></tr>
                                                                                    <tr><td>Amount</td><td>
                    <asp:TextBox runat="server" ID="txtAmount" /></td></tr>
                </table>  <br />
        <asp:Button Text="Reload Card" ID="btnReloadCard" OnClick="btnReloadCard_Click" runat="server" />
    </div>
    </form>
</body>
</html>
