<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="COP001.aspx.cs" Inherits="COP_COP001" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>ERP銷貨單庫存不足清單</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        ERP銷貨單庫存不足清單
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>        
        <li class="active">ERP銷貨單庫存不足清單</li>
      </ol>
    </section>
      <div class="pad margin no-print">
          <div class="callout callout-info" style="margin-bottom: 0!important;">
              <h4><i class="fa fa-info"></i>說明:</h4>
              ERP銷貨單庫存不足清單!!&nbsp; (只有庫存不足的項目才會列出來)<br />              
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
              組別：<asp:DropDownList 
            ID="DropDownList2" runat="server" AutoPostBack="True" 
                onselectedindexchanged="DropDownList2_SelectedIndexChanged">
            <asp:ListItem Selected="True" Value="231">營一</asp:ListItem>
            <asp:ListItem Value="232">營二</asp:ListItem>
            <asp:ListItem Value="233">營三</asp:ListItem>
        </asp:DropDownList>
        <br />
        客戶：<asp:DropDownList 
            ID="DropDownList1" runat="server" AutoPostBack="True" 
            DataSourceID="guest" DataTextField="SHOW" DataValueField="MA001" 
                ondatabound="DropDownList1_DataBound" 
                onselectedindexchanged="DropDownList1_SelectedIndexChanged">
        </asp:DropDownList>
        <br />
        清單：
        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" onprerender="GridView2_PreRender">
            <Columns>
                <asp:BoundField DataField="銷貨單號" HeaderText="銷貨單號" ReadOnly="True" 
                    SortExpression="銷貨單號" />
                <asp:BoundField DataField="訂單單號" HeaderText="訂單單號" SortExpression="訂單單號" 
                    ReadOnly="True" />
                <asp:BoundField DataField="出貨日期" HeaderText="出貨日期" SortExpression="出貨日期" />
                <asp:BoundField DataField="品號" HeaderText="品號" SortExpression="品號" />
                <asp:BoundField DataField="品名" HeaderText="品名" SortExpression="品名" />
                <asp:BoundField DataField="規格" HeaderText="規格" SortExpression="規格" />
                <asp:BoundField DataField="數量" HeaderText="數量" SortExpression="數量" />
                <asp:BoundField DataField="現有庫存數量" HeaderText="現有庫存數量" 
                    SortExpression="現有庫存數量" />
                <asp:BoundField DataField="包裝數量" HeaderText="包裝數量" SortExpression="包裝數量" />
                <asp:BoundField DataField="庫存包裝量" HeaderText="庫存包裝量" 
                    SortExpression="庫存包裝量" />
                <asp:BoundField DataField="倉庫" HeaderText="倉庫" SortExpression="倉庫" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT TG001+'-'+TG002 as '銷貨單號',TH014+'-'+TH015 as '訂單單號',TG003 as '出貨日期',TH004 as '品號',TH005 as '品名',TH006 as '規格',TH008 as '數量',MB064 as '現有庫存數量',TH220 as '包裝數量',MB089 as '庫存包裝量',TH007 as '倉庫'
  FROM [GH].[dbo].[COPTG] left join [GH].[dbo].[COPTH] ON TG001=TH001 AND TG002=TH002 left join [GH].[dbo].[INVMB] ON TH004=MB001
  WHERE RTRIM(TG004) LIKE '%' + @TG004 + '%' and TG023='N' AND (MB064&lt;TH008 or MB089&lt;TH220)
AND TG001 LIKE @TG001 +'%' 
ORDER BY TG003">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList1" Name="TG004" 
                    PropertyName="SelectedValue" />
                <asp:ControlParameter ControlID="DropDownList2" Name="TG001" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
        <asp:SqlDataSource ID="guest" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" 
            SelectCommand="SELECT '%'AS MA001,''AS MA002,'全部'AS SHOW UNION SELECT DISTINCT RTRIM(MA001)as MA001,MA002,MA001+MA002 AS SHOW
  FROM [GH].[dbo].[COPTG] LEFT JOIN [GH].[dbo].[COPMA] ON TG004=MA001
  WHERE TG001 LIKE '%' +@MA001 +'%' AND TG023='N' ORDER BY MA001">
            <SelectParameters>
                <asp:ControlParameter ControlID="DropDownList2" Name="MA001" 
                    PropertyName="SelectedValue" />
            </SelectParameters>
        </asp:SqlDataSource>
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

