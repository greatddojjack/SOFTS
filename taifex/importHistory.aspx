<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="importHistory.aspx.cs" Inherits="taifex_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>匯入歷史資料</title>

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
            <h1>匯入歷史資料
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">匯入歷史資料</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <ul>
                <li>匯入歷史資料。</li>                
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
                            <input id="fileinput" type="file" />
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                        </div>
                        <div class="box-body">                            
                            <table id="taifex_table" class="display"></table>
                            <div class="form-group" style="margin-top:10px;">
									<button class="btn btn-success btn-flat" id="save">儲存</button>&nbsp;
									<button class="btn btn-danger btn-flat pull-right" id="clear">清空</button>
							</div>
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
            <!-- jQuery-csv -->
<script src="/plugins/jquery-csv/jquery.csv.js"></script>   
    <script src="importHistory.js"></script>        
</asp:Content>

