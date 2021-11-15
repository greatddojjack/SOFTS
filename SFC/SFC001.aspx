<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="SFC001.aspx.cs" Inherits="SFC_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>重工倉例外數量統計</title>

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
        width: 600px;
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
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/jquery.dataTables.min.css"/>
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/buttons.dataTables.min.css" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>重工倉例外數量統計
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">重工倉例外數量統計</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <ul>
                <li>查詢由SFT例外數量出站進入重工倉的相關資訊。</li>                
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
                                    
        <asp:Button ID="ok_Button" runat="server" OnClick="ok_Button_Click" Text="篩選"
            BackColor="#006666" Font-Bold="True" ForeColor="#CCFFFF"/><br /><br />
                                    <asp:GridView ID="GridView1" runat="server" OnDataBound="GridView1_DataBound"
                                         OnRowDataBound="GridView1_RowDataBound" OnRowCommand="GridView1_RowCommand" cssclass="display hover" CellSpacing="0" GridLines="None">                                        
                                        
                                    </asp:GridView>                                    
                                </ContentTemplate>
                            </asp:UpdatePanel>

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
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="Server">      
    <script type="text/javascript" language="javascript" src="/plugins/datatables/jquery.dataTables.min.js">
	</script>    
    	<script type="text/javascript" language="javascript" src="/plugins/datatables/dataTables.buttons.min.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.flash.min.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/jszip.min.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/pdfmake.min.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/vfs_fonts.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.html5.min.js">
	</script>
	<script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.print.min.js">
    </script>
        <script>
                       
            function InitTable() {
                $('#ContentPlaceHolder1_GridView1').DataTable({
                    destroy:true,
                    dom: 'Bfrtip',
                    "paging": true,
                    "pageLength": 50,
                    buttons: [
                        'pageLength', 'excel', 'print'
                    ]
                });
            }

            $(document).ready(function () {
                InitTable();
            });
        </script>    
</asp:Content>

