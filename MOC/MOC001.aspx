<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MOC001.aspx.cs" Inherits="MOC_Default" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>鋁圓條耗用統計</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        鋁圓條耗用統計
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>        
        <li class="active">鋁圓條耗用統計</li>
      </ol>
    </section>
      <div class="pad margin no-print">
          <div class="callout callout-info" style="margin-bottom: 0!important;">
              <h4><i class="fa fa-info"></i>說明:</h4>
              廖副總的需求：列出生產的回單重量，並依材質分類。<br />
              印出:6005、6061、6061B、6061H、6063、6063B、6063C、6063D、6063G、6063H、6066、6082、6463<br />
          </div>
      </div>
    <!-- Main content -->
      <section class="content">
          <!-- /.box -->
                  <div class="row">
                      <div class="col-xs-12">
                          <div class="box">
                              <div class="box-header">
                                                                  
                              </div>
                              <div class="box-body table-responsive no-padding">
                                  <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
              <asp:Label ID="Label2" runat="server" Font-Size="24pt" Text="年月起迄："></asp:Label>
        ：<asp:TextBox ID="date_start" runat="server" Font-Size="24pt" Width="120px">201606</asp:TextBox>
                                  <ajaxToolkit:CalendarExtender ID="date_start_CalendarExtender" runat="server" TargetControlID="date_start" Format="yyyyMM" />
&nbsp;&nbsp;&nbsp;&nbsp; 
        <asp:Label ID="Label1" runat="server" Font-Size="28pt" Text="~"></asp:Label>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="date_end" runat="server" Font-Size="24pt" Width="120px">201608</asp:TextBox>
                                  <ajaxToolkit:CalendarExtender ID="date_end_CalendarExtender" runat="server" TargetControlID="date_end" Format="yyyyMM" />
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label3" runat="server" Font-Size="24pt" Text="機台："></asp:Label>
        <asp:DropDownList ID="machine_list" 
            runat="server" Font-Size="24pt">            
            <asp:ListItem Value="41">41</asp:ListItem>
	    <asp:ListItem Value="42">42</asp:ListItem>
            <asp:ListItem>51</asp:ListItem>
            <asp:ListItem Value="52">52</asp:ListItem>
            <asp:ListItem Value="53">53</asp:ListItem>
            <asp:ListItem>71</asp:ListItem>
            <asp:ListItem>81</asp:ListItem>
        </asp:DropDownList>
        &nbsp;&nbsp;&nbsp;
        <asp:Button ID="ok_Button" runat="server" onclick="ok_Button_Click" Text="搜尋" 
            BackColor="#006666" Font-Bold="True" Font-Size="18pt" ForeColor="#CCFFFF" />
<asp:Button ID="print_Button" runat="server" onclick="PrintCurrentPage" Text="列印" 
            BackColor="#006666" Font-Bold="True" Font-Size="18pt" ForeColor="#CCFFFF" />＊僅可於IE列印
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="style1">
        <br />
        <br />
        </span>
        <asp:GridView ID="GridView1" runat="server" ondatabound="GridView1_DataBound" 
            BackColor="#CCCCCC" BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" 
            CellPadding="4" CellSpacing="2" Font-Size="22pt" ForeColor="Black">
            <FooterStyle BackColor="#CCCCCC" Font-Size="Large" />
            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />
            <RowStyle BackColor="White" />
            <SelectedRowStyle BackColor="#000099" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#808080" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#383838" />
        </asp:GridView>
        <br />
	<asp:Panel ID="pnl_data" runat="server" />
        <br />
 </div>
                              <!-- /.box-body -->
                          </div>
                          <!-- /.box -->
                      </div>
                  </div>
      </section>
    <!-- /.content -->
  </div>
</asp:Content>

