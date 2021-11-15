<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="KPI001.aspx.cs" Inherits="MOC_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>ERP建單即時率</title>

    <style>
        canvas {
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }
    </style>
    <style type="text/css">
        .GvGrid:hover {
            background-color: #A1DCF2;
        }

        .tableBackground {
            background-color:Gray;filter:alpha(opacity=70);opacity:0.7;
        }


    .modalPopup
    {
        background-color: #FFFFFF;
        width: 650px;
        height:550px;
        border: 3px solid #0DA9D0;
        border-radius: 12px;
        padding:0
      
    }
    .modalPopup .header
    {
        background-color: #2FBDF1;
        height: 30px;
        color: White;
        line-height: 30px;
        text-align: center;
        font-weight: bold;
        border-top-left-radius: 6px;
        border-top-right-radius: 6px;
    }
    .modalPopup .body
    {
        min-height: 50px;
        line-height: 30px;
        text-align: center;
        font-weight: bold;
    }
    .modalPopup .footer
    {
        padding: 6px;
    }
.close { 
    DISPLAY: block;BACKGROUND: url(/image/close.png) no-repeat 0px 0px; 
    RIGHT: -38px;WIDTH: 48px;TEXT-INDENT: -1000em;POSITION: absolute; 
    TOP: -38px;HEIGHT: 48px; 
}  

    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>ERP建單即時率
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">ERP建單即時率</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <ul>
                <li>點擊單別可查看補單建立人員與落後天數，僅計算工作日（已排除節假日）。</li>
                <li>建單即時率：(總筆數-補單數)/總筆數</li>
                <li>落後平均天數：落後總天數/補單數</li>
                </ul>
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
                        <div class="box-body">
                            <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                <Triggers>                                    
                                    <asp:PostBackTrigger ControlID="print_Button" />
                                    <asp:PostBackTrigger ControlID="excel_Button" />
                                    <asp:PostBackTrigger ControlID="btnSubExcel" />
                                </Triggers>
                                <ContentTemplate>
                                    <asp:HiddenField ID="hf_xx001" runat="server" />
                                    <asp:HiddenField ID="hf_kpi" runat="server" />
                                    <asp:HiddenField ID="hf_qs" runat="server" />
                                    <asp:Label ID="Label2" runat="server" Text="年月日起迄："></asp:Label>
                                    <asp:TextBox ID="date_start" runat="server" Width="120px"></asp:TextBox>
                                    <ajaxToolkit:CalendarExtender ID="date_start_CalendarExtender" runat="server" TargetControlID="date_start" Format="yyyyMMdd" TodaysDateFormat="yyyyMMdd" />
                                    &nbsp;&nbsp;&nbsp;&nbsp; 
        <asp:Label ID="Label1" runat="server" Text="~"></asp:Label>
                                    &nbsp;&nbsp;&nbsp;&nbsp;
        <asp:TextBox ID="date_end" runat="server" Width="120px">201608</asp:TextBox>
                                    <ajaxToolkit:CalendarExtender ID="date_end_CalendarExtender" runat="server" Format="yyyyMMdd" TargetControlID="date_end" />
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        <asp:Label ID="Label3" runat="server" Text="系統別："></asp:Label>
                                    <asp:DropDownList ID="sys_list" runat="server">
                                        <asp:ListItem Value="0">全部</asp:ListItem>
                                        <asp:ListItem Value="1">庫存</asp:ListItem>
                                        <asp:ListItem Value="3">採購</asp:ListItem>
                                        <asp:ListItem Value="4">製令</asp:ListItem>
                                        <asp:ListItem Value="5">製程</asp:ListItem>
                                    </asp:DropDownList>
                                    &nbsp;&nbsp;&nbsp;
        <asp:Button ID="ok_Button" runat="server" OnClick="ok_Button_Click" Text="搜尋"
            BackColor="#006666" Font-Bold="True" ForeColor="#CCFFFF" OnClientClick="$.blockUI();GetChartData();" />
                                    <asp:Button ID="excel_Button" runat="server" OnClick="excel_Button_Click" Text="儲存excel"
                                        BackColor="#006666" Font-Bold="True" ForeColor="#CCFFFF" />
                                    <asp:Button ID="print_Button" runat="server" OnClick="PrintCurrentPage" Text="列印"
                                        BackColor="#006666" Font-Bold="True" ForeColor="#CCFFFF" />＊僅可於IE列印
        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <span class="style1">
            <br />

            <br />
        </span>
                                    <asp:GridView ID="GridView1" runat="server" OnDataBound="GridView1_DataBound"
                                        BorderColor="#999999" BorderStyle="Solid" BorderWidth="3px" RowStyle-CssClass="GvGrid"
                                        CellPadding="4" CellSpacing="2" ForeColor="Black" OnRowDataBound="GridView1_RowDataBound" AutoGenerateColumns="False" OnRowCommand="GridView1_RowCommand">
                                        <Columns>
                                            <asp:BoundField DataField="KPI編號" HeaderText="KPI編號" SortExpression="KPI編號" />
                                            <asp:BoundField DataField="分析項目" HeaderText="分析項目" SortExpression="分析項目" />
                                            <asp:BoundField DataField="年月" HeaderText="年月" SortExpression="年月" />
                                            <asp:TemplateField HeaderText="單別">
                                                <ItemTemplate>
                                                    <asp:LinkButton ID="LB" runat="server" Text='<%# Eval("單別") %>' CommandName="ShowGridView" CommandArgument='<%# Eval("單別")+","+Eval("KPI編號") %>'></asp:LinkButton>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="單據名稱" HeaderText="單據名稱" ReadOnly="True" SortExpression="單據名稱" />
                                            <asp:BoundField DataField="分子單位" HeaderText="分子單位" SortExpression="分子單位" />
                                            <asp:BoundField DataField="分母單位" HeaderText="分母單位" SortExpression="分母單位" />
                                            <asp:BoundField DataField="總筆數" HeaderText="總筆數" SortExpression="總筆數" />
                                            <asp:BoundField DataField="補單數" HeaderText="補單數" SortExpression="補單數" />
                                            <asp:BoundField DataField="建檔即時率" HeaderText="建檔即時率" ReadOnly="True" SortExpression="建檔即時率" />
                                            <asp:BoundField DataField="落後總天數" HeaderText="落後總天數" SortExpression="落後總天數" />
                                            <asp:BoundField DataField="落後平均天數" HeaderText="落後平均天數" SortExpression="落後平均天數" />
                                        </Columns>
                                        <FooterStyle BackColor="#CCCCCC" Font-Size="Large" />
                                        <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                                        <PagerStyle BackColor="#CCCCCC" ForeColor="Black" HorizontalAlign="Left" />

                                        <RowStyle CssClass="GvGrid"></RowStyle>
                                    </asp:GridView>
                                    <asp:Button ID="modelPopup" runat="server" Style="display: none" />
                                    <ajaxToolkit:ModalPopupExtender ID="ModalPopupExtender1" runat="server" TargetControlID="modelPopup" PopupControlID="gv2_panel"
                                        CancelControlID="btnCancel" BackgroundCssClass="tableBackground">
                                    </ajaxToolkit:ModalPopupExtender>
                                    <asp:Panel ID="gv2_panel" runat="server" Style="display: none" BackColor="White"  CssClass="modalPopup">
                                        <asp:LinkButton ID="btnCancel" runat="server" CssClass="close" />
                                        <asp:Button ID="btnSubExcel" runat="server" OnClick="btnSubExcel_Click" Text="儲存excel"
                                            BackColor="#006666" Font-Bold="True" ForeColor="#CCFFFF" />
                                        <br />
                                        <br />
                                        <asp:GridView ID="GridView2" runat="server" BackColor="White" AllowPaging="True" PageSize="20" OnPageIndexChanging="GridView2_PageIndexChanging">
                                            <HeaderStyle BackColor="Black" Font-Bold="True" ForeColor="White" />
                                        </asp:GridView>

                                    </asp:Panel>
                                </ContentTemplate>
                            </asp:UpdatePanel>

                            <br />

                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                        </div>
                        <div class="box-body">
                            <canvas id="canvas"></canvas>
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
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="Server">
    <!-- ChartJS 1.0.1 -->
    <script src="/plugins/chartjs/Chart.bundle.js"></script>
    <script src="/plugins/chartjs/utils.js"></script>

    <script>
        var myChart;

        function getDate(datestr) {
            //var temp = datestr.split("-");
            var date = new Date(datestr.substr(0, 4), datestr.substr(4, 2), datestr.substr(6, 2));
            return date;
        }
        function getRandomColor() {
            var letters = '0123456789ABCDEF'.split('');
            var color = '#';
            for (var i = 0; i < 6; i++) {
                color += letters[Math.floor(Math.random() * 16)];
            }
            return color;
        }
        
        function GetChartData() {

            var start = $('#ContentPlaceHolder1_date_start').val();
            var end = $('#ContentPlaceHolder1_date_end').val();
            var chk = $('#ContentPlaceHolder1_sys_list').val();

            var startTime = getDate(start);
            var endTime = getDate(end);            
            var MONTHS = new Array();
            var allformtype = new Array();
            var everydaydata = new Array();
            var ajaxRequest = [];
            while ((endTime.getTime() - startTime.getTime()) >= 0) {
                var year = startTime.getFullYear();
                var month = startTime.getMonth().toString().length == 1 ? "0" + startTime.getMonth().toString() : startTime.getMonth();
                var day = startTime.getDate().toString().length == 1 ? "0" + startTime.getDate() : startTime.getDate();

                MONTHS.push(year + month + day);
                var nowday = year + month + day;
                //取linedata數據
                var tmpData;
                
                ajaxRequest.push(
                $.ajax({
                    type: "POST",
                    url: "/WebService.asmx/GetKPI001LineData",
                    contentType: "application/json; charset=utf-8",
                    async: true,
                    cache: false,
                    dataType: 'json',
                    data: '{"sys":' + chk + ',"startdate":' + nowday + ',"enddate":' + nowday + '}',
                    success: function (data) {
                        if (data.hasOwnProperty("d")) {
                            tmpData = data.d;
                        }
                        else
                            tmpData = data;
                        var lineData;
                        lineData = JSON.parse(tmpData);

                        var formtype = new Array();
                        var value = new Array();
                        for (i = 0; i < lineData.length; i++) {
                            if (allformtype.indexOf(lineData[i].單別) < 0) {
                                allformtype.push(lineData[i].單別);
                            }
                            formtype.push(lineData[i].單別);
                            value.push(lineData[i].落後平均天數)
                        }
                        everydaydata.push(new Array(formtype, value));

                    }
                }));
                //累加
                startTime.setDate(startTime.getDate() + 1);
            }
            $.when.apply($, ajaxRequest).done(function () {
                var alldatasets = new Array();
                for (i = 0; i < allformtype.length; i++) {
                    var label = allformtype[i];
                    var tmpdata = new Array();
                    for (j = 0; j < everydaydata.length; j++) {
                        var tmpindex = everydaydata[j][0].indexOf(allformtype[i]);
                        if (tmpindex >= 0) {
                            tmpdata.push(everydaydata[j][1][tmpindex]);
                        }
                        else {
                            tmpdata.push(0);
                        }
                    }
                    var randomcolor = getRandomColor();
                    alldatasets.push({ 'label': label, 'data': tmpdata, 'backgroundColor': randomcolor, 'borderColor': randomcolor, 'fill': false });
                }
                alldatasets.sort(function (a, b) {
                    var x = a.label.toLowerCase();
                    var y = b.label.toLowerCase();
                    if (x < y) { return -1; }
                    if (x > y) { return 1; }
                    return 0;
                });
                var config = {
                    type: 'line',
                    data: {
                        labels: MONTHS,
                        datasets: alldatasets
                    },
                    options: {
                        responsive: true,
                        title: {
                            display: true,
                            text: '各單別每日平均落後天數'
                        },
                        legend: {
                            position: 'bottom'
                        },
                        layout: {
                            padding: {
                                left: 20,
                                right: 20,
                                top: 0,
                                bottom: 0
                            }
                        },
                        responsive: true,
                        hoverMode: 'index',
                        stacked: false,
                        scales: {
                            xAxes: [{
                                display: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: '日期'
                                }
                            }],
                            yAxes: [{
                                display: true,
                                scaleLabel: {
                                    display: true,
                                    labelString: '平均落後天數'
                                }
                            }]
                        }
                    }
                };
                var ctx = document.getElementById("canvas").getContext("2d");                
                if (typeof myChart != 'undefined') {
                    myChart.destroy();
                }
                myChart = new Chart(ctx, config);
                //window.myLine = new Chart(ctx, config);
                
            });
        }
        // global hook - unblock UI when ajax request completes
        $(document).ajaxStop($.unblockUI);

        $(document).ready(function () {
            $.blockUI();
            GetChartData();
        });       
        
    </script>
</asp:Content>

