<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="FISCustomize._Default" %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        Rimba ka Simba
    </section>

</asp:Content>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server" ID="head">
    <script>
        $(document).ready(function () {
            
        });
             
    </script>
</asp:Content>
<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <div style="width: 100%; height: 100px; overflow-x: scroll">
        Select table to modify
        <br />

        <asp:ListBox runat="server" ID="lstTables" OnSelectedIndexChanged="lstTables_SelectedIndexChanged" AutoPostBack="true"></asp:ListBox>
    </div>
    <div style="width: 600px; height: 600px; overflow-x: scroll">
        <asp:GridView ID="grdColumns" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="Column_Name" HeaderText="Name" />
                <asp:BoundField DataField="Data_Type" HeaderText="Data Type" />
                <asp:BoundField DataField="character_maximum_length" HeaderText="Max Length" />
                <asp:BoundField DataField="Is_Nullable" HeaderText="Is Nullable" />
            </Columns>
        </asp:GridView>
        <div id="divNewColumnControl">
            <table>
                <tr>
                    <td>Name: </td>
                    <td>
                        <asp:TextBox ID="txtColumnName" runat="server" /></td>
                </tr>
                <tr>
                    <td>Datatype: </td>
                    <td>
                        <asp:DropDownList ID="ddlDataType" runat="server">
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td>Is Nullable
                    <asp:CheckBox ID="chkIsNullable" runat="server" Checked="true" />&nbsp;
                        <div id="nullSubstitute">Enter default (if not null) <asp:TextBox ID="txtDefault" runat="server" /></div></td>
                </tr>
                <tr>
                    <td>Length (for char type only)</td>
                    <td>
                        <input type="number" id="txtColumnLength" runat="server" /></td>
                </tr>
            </table>

            <asp:LinkButton Text="Add New" ID="btnAddNewColumn" runat="server" OnClick="btnAddNewColumn_Click" /><br />
            <div ID="divColumnAddStatus" runat="server"></div>
        </div>

    </div>
    <asp:Button ID="btnSubmit" Text="Submit" runat="server" OnClick="btnSubmit_Click" Visible="false" />


</asp:Content>
