<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="MOC002.aspx.cs" Inherits="MOC_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>生產線別預估成品率計算</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        生產線別預估成品率計算
        <small></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-dashboard"></i> Home</a></li>        
        <li class="active">生產線別預估成品率計算</li>
      </ol>
    </section>
      <div class="pad margin no-print">
          <div class="callout callout-info" style="margin-bottom: 0!important;">
              <h4><i class="fa fa-info"></i>說明:</h4>
              <br />
              <br />
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
              <span class="style2">日期區間：</span><asp:TextBox ID="start_date" 
            runat="server" Font-Size="Medium" Width="110px"></asp:TextBox>
&nbsp;&nbsp;&nbsp; <span class="style1">~</span>&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="end_date" runat="server" Font-Size="Medium" Width="110px"></asp:TextBox>        
        生產線別：<asp:TextBox ID="line_texbox" runat="server" Font-Size="Medium" 
            Width="110px">P</asp:TextBox>
        (輸入P代表全部)
        <asp:Button ID="ok_Button" runat="server" Text="搜尋" Font-Size="Medium" 
            onclick="ok_Button_Click" />
        <br /><br />
        <asp:GridView ID="GridView999" runat="server" 
            onprerender="GridView999_PreRender" BackColor="White" 
            BorderColor="#CCCCCC" BorderStyle="None" BorderWidth="1px" CellPadding="3">
            <FooterStyle BackColor="White" ForeColor="#000066" />
            <HeaderStyle BackColor="#006699" Font-Bold="True" ForeColor="White" />
            <PagerStyle BackColor="White" ForeColor="#000066" HorizontalAlign="Left" />
            <RowStyle ForeColor="#000066" />
            <SelectedRowStyle BackColor="#669999" Font-Bold="True" ForeColor="White" />
            <SortedAscendingCellStyle BackColor="#F1F1F1" />
            <SortedAscendingHeaderStyle BackColor="#007DBB" />
            <SortedDescendingCellStyle BackColor="#CAC9C9" />
            <SortedDescendingHeaderStyle BackColor="#00547E" />
        </asp:GridView>
        <br />
        <br />
        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" 
            DataSourceID="SqlDataSource1" onprerender="GridView1_PreRender" 
            Visible="False">
            <Columns>
            <asp:BoundField DataField="預產日" HeaderText="預產日" ReadOnly="True" SortExpression="預產日" />
            <asp:BoundField DataField="生產線別" HeaderText="生產線別" SortExpression="生產線別" />
                <asp:BoundField DataField="預估成品率(平均)" HeaderText="預估成品率(平均)" ReadOnly="True" 
                    SortExpression="預估成品率(平均)" />
            </Columns>
        </asp:GridView>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT convert(varchar,convert(datetime,XC003),111)'預產日',XC015'生產線別',(CONVERT(VARCHAR(50),CONVERT(FLOAT(50),ROUND(AVG(XD031)*100,2)))+'%')'預估成品率(平均)' FROM MOCXC LEFT JOIN MOCXD ON XC001=XD001
WHERE XC010='Y' AND XC017='1' AND XC003&gt;=@START AND XC003&lt;=@END  AND XC015 LIKE '%'+@LINE+'%'
GROUP BY XC003,XC015
ORDER BY XC003">
            <SelectParameters>
                <asp:ControlParameter ControlID="start_date" Name="START" PropertyName="Text" />
                <asp:ControlParameter ControlID="end_date" Name="END" PropertyName="Text" />
                <asp:ControlParameter ControlID="line_texbox" Name="LINE" PropertyName="Text" />
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

