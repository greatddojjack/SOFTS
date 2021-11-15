<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="COP002.aspx.cs" Inherits="COP_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>營一備料單</title>

    <style>
        canvas {
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }
    </style>
    <style type="text/css">
        .dataTables_filter {
            display: none;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/jquery.dataTables.min.css" />    

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>營一備料單
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">營一備料單</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <ul>
                    <li>將當天相同送貨地點的訂單整理在一起</li>
                </ul>
            </div>
        </div>
        <!-- Main content -->
        <section class="content">
            <!-- /.modal -->
            <div class="modal fade" id="modal-default">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">開窗查詢</h4>
                        </div>
                        <div class="modal-body">
                            <label>重查</label>
                            <div class="form-group">
                                <div class="row">
                                    <div class="col-xs-4">
                                        <select class="form-control" id="sel_filterkey">
                                            <option value="TC002">單號</option>
                                            <option value="TC003">訂單日期</option>
                                            <option value="TC004">客戶代號</option>
                                            <option value="MA002">客戶簡稱</option>
                                            <option value="TC012">客戶單號</option>
                                        </select>
                                    </div>

                                    <div class="col-xs-4">
                                        <select class="form-control" id="sel_filter">
                                            <option value=">=">>=</option>
                                            <option value="like">%Like%</option>

                                        </select>
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control pull-right" id="txt_filtervalue">
                                    </div>
                                </div>
                            </div>
                            <table id="poporderlist" class="table table-striped table-bordered" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th><input name="selectall" id="chk_selectall" type="checkbox"/></th>
                                        <th>單號</th>
                                        <th>訂單日期</th>
                                        <th>客戶代號</th>
                                        <th>客戶簡稱</th>
                                        <th>客戶單號</th>
                                    </tr>
                                </thead>
                                <tbody></tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">取消</button>
                            <button type="button" class="btn btn-primary" id="btn_saveorderlist">確定</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header">
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-xs-6 col-md-4">
                                    <div class="form-group">
                                        <label>選擇訂單單號:</label>
                                        <div class="checkbox">
                                            <label>
                                                <asp:CheckBox ID="chk_isbetween" runat="server" />                                                
                                                區間選擇
                                            </label>
                                        </div>
                                        <div id="div1">
                                            <div class="input-group">
                                                <div class="input-group-addon">起：</div>
                                                <asp:TextBox ID="txt_startorder" class="form-control" runat="server"></asp:TextBox>                                                
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-flat" id="btn_startorder"><i class="fa fa-calendar"></i></button>
                                                </span>
                                            </div>
                                            <div class="input-group">
                                                <div class="input-group-addon">迄：</div>
                                                <input type="text" class="form-control" id="txt_endorder">
                                                <span class="input-group-btn">
                                                    <button type="button" class="btn btn-flat" id="btn_endorder"><i class="fa fa-calendar"></i></button>
                                                </span>
                                            </div>
                                        </div>
                                    <div id="div2">
                                        <div class="form-group">
                                            <div class="input-group date">
                                                <asp:ListBox ID="sel_multiorder" runat="server" class="form-control" SelectionMode="Multiple">                                                    
                                                </asp:ListBox>
                                                <div class="input-group-addon">
                                                    <button type="button" class="btn btn-flat" id="btn_multiorder"><i class="fa fa-calendar"></i></button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- /.input group -->
                        </div>
                    </div>
                    <!-- /.box-body -->
                    <div class="box-footer">
                        <button type="button" class="btn btn-primary" id="ordersubmit">查詢</button>                        
                        <asp:Button ID="excel_Button" runat="server" class="btn btn-primary" Text="儲存excel" OnClick="excel_Button_Click" UseSubmitBehavior="False" />   
                        <asp:HiddenField ID="ordervalue" runat="server" />
                    </div>
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
                    <table id="orderlist" class="display" width="100%" cellspacing="0">
                        <thead>
                            <tr>
                                <th>客戶</th>
                                <th>訂單號碼</th>
                                <th>備註</th>
                                <th>圖檔</th>
                                <th>點料</th>
                                <th>儲位</th>
                                <th>要隱藏</th>
                                <th>型號</th>
                                <th>長度</th>
                                <th>數量</th>
                                <th>實出</th>
                                <th>裁切</th>
                                <th>客戶單號</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                        <tfoot>
                            <tr>
                                <th>客戶</th>
                                <th>訂單號碼</th>
                                <th>備註</th>
                                <th>圖檔</th>
                                <th>點料</th>
                                <th>儲位</th>
                                <th>要隱藏</th>
                                <th>型號</th>
                                <th>長度</th>
                                <th>數量</th>
                                <th>實出</th>
                                <th>裁切</th>
                                <th>客戶單號</th>
                            </tr>
                        </tfoot>
                    </table>
                </div>
            </div>
        </div>
        <!-- /.box-body -->
    </div>
    <!-- /.box -->
    </section>
        <!-- /.content -->
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="Server">

    <script src="/plugins/datatables/jquery.dataTables.min.js"></script>    
    <script>

        //
        var poptable;
        function ListOrderTable(TC001, filterkey, filter, filtervalue, isdiv1show) {
            var $tmpData;
            var $FileData;
            $.blockUI();
            $("#poporderlist tbody").remove();
            $.ajax({
                type: "POST",
                url: "/WebService.asmx/GetPopOrderData",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: false,
                dataType: 'json',
                data: '{"TC001":"' + TC001 + '","filterkey":"' + filterkey + '","filter":"' + filter + '","filtervalue":"' + filtervalue + '"}'

            }).done(function (data) {
                if (data.hasOwnProperty("d")) {
                    tmpData = data.d;
                }
                else {
                    tmpData = data;
                }
                if (tmpData != '') {
                    FileData = JSON.parse(tmpData);
                    if (FileData.length > 0) {
                        $('#poporderlist').append('<tbody></tbody>');
                        for (i = 0; i < FileData.length; i++) {
                            if (isdiv1show == true)
                                $('#poporderlist tbody').append('<tr><td><input name="selector[]" id="chk_ordercheck_"' + i + ' type="checkbox" value="' + FileData[i].TC002 + '"></td><td>' + FileData[i].TC002 + '</td><td>' + FileData[i].TC003 + '</td><td>' + FileData[i].TC004 + '</td><td>' + FileData[i].MA002 + '</td><td>' + FileData[i].TC012 + '</td></tr>');
                            else
                                $('#poporderlist tbody').append('<tr><td><input name="selector[]" id="chk_ordercheck_"' + i + ' type="radio" value="' + FileData[i].TC002 + '"></td><td>' + FileData[i].TC002 + '</td><td>' + FileData[i].TC003 + '</td><td>' + FileData[i].TC004 + '</td><td>' + FileData[i].MA002 + '</td><td>' + FileData[i].TC012 + '</td></tr>');
                        }
                    }
                }
                poptable = $('#poporderlist').DataTable({
                    scrollY: "300px",
                    scrollCollapse: true,
                    paging: false,
                    destroy: true
                });
                setTimeout(function () {
                    poptable.columns.adjust();
                }, 100);
                setTimeout(function () {
                    $('#txt_filtervalue').focus();
                }, 500);
            });
        }

        function GetOrderData(TC001, TC002, isbetween) {
            var $tmpData;
            var $FileData;
            $.blockUI();
            $("#orderlist tbody").remove();
            $.ajax({
                type: "POST",
                url: "/WebService.asmx/GetOrderData",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: false,
                dataType: 'json',
                data: '{"TC001":"' + TC001 + '","TC002":"' + TC002 + '","isbetween":"' + isbetween + '"}'

            }).done(function (data) {
                if (data.hasOwnProperty("d")) {
                    tmpData = data.d;
                }
                else {
                    tmpData = data;
                }
                if (tmpData != '') {
                    FileData = JSON.parse(tmpData);
                    if (FileData.length > 0) {
                        $('#orderlist').append('<tbody></tbody>');
                        for (i = 0; i < FileData.length; i++) {
                            $('#orderlist tbody').append('<tr><td>' + FileData[i].客戶 + '</td><td>' + FileData[i].訂單號碼 + '</td><td>' + FileData[i].備註 + '</td><td><img width="100px" src="http://192.168.0.188/GH_Image/thumb/' + FileData[i].型號 + '.jpg"></img></td><td>' + FileData[i].點料 + '</td><td>' + FileData[i].儲位 + '</td><td>' + FileData[i].要隱藏 + '</td><td>' + FileData[i].型號 + '</td><td>' + FileData[i].長度 + '</td><td>' + FileData[i].數量 + '</td><td>' + FileData[i].實出 + '</td><td>' + FileData[i].裁切 + '</td><td>' + FileData[i].客戶單號 + '</td></tr>');
                        }
                    }
                }
                 var ordertable = $('#orderlist').DataTable({
                    destroy: true,                    
                    "paging": true,
                    "pageLength": 50                    
                });                
            });

        }

        $(document).ready(function () {
            //區間選擇
            if ($('#chk_isbetween').prop('checked') == true) {
                $("#div1").show();
                $("#div2").hide();
            }
            else {
                $("#div1").hide();
                $("#div2").show();
            }
            $('#ContentPlaceHolder1_excel_Button').attr('disabled', true);
        });
        //區間選擇
        $('#ContentPlaceHolder1_chk_isbetween').click(function () {
            if ($('#ContentPlaceHolder1_chk_isbetween').prop('checked') == true) {
                $("#div1").show();
                $("#div2").hide();
            }
            else {
                $("#div1").hide();
                $("#div2").show();
            }
        });
        $('#btn_saveorderlist').click(function () {
            if ($('#ContentPlaceHolder1_chk_isbetween').prop('checked') == false) {
                $("#ContentPlaceHolder1_sel_multiorder option").remove();
                $('#poporderlist :checked').each(function () {
                    $('#ContentPlaceHolder1_sel_multiorder').append('<option value="' + $(this).val() + '">' + $(this).val() + '</option>')
                });
            }
            else {
                $('#poporderlist :checked').each(function () {
                    if (whichorder == 0)
                        $('#ContentPlaceHolder1_txt_startorder').val($(this).val());
                    else
                        $('#txt_endorder').val($(this).val());
                });
            }
            $('#modal-default').modal('hide');
        })
        var whichorder = 0;
        $('#btn_startorder').click(function () {
            whichorder = 0;
            $('#modal-default').modal('show');
            showPopOrderWindow();
        })
        $('#btn_endorder').click(function () {
            whichorder = 1;
            $('#modal-default').modal('show');
            showPopOrderWindow();
        })
        $('#btn_multiorder').click(function () {
            $('#modal-default').modal('show');
            showPopOrderWindow();
        })
        $('#ordersubmit').click(function () {
            $('#ContentPlaceHolder1_excel_Button').attr('disabled', false);
            var orderno = '';
            if ($('#ContentPlaceHolder1_chk_isbetween').prop('checked') == true) {
                orderno = $('#ContentPlaceHolder1_txt_startorder').val() + "," + $('#txt_endorder').val();
                $('#ContentPlaceHolder1_ordervalue').val(orderno);
                GetOrderData('2210', orderno, true);
            }
            else {
                $("#ContentPlaceHolder1_sel_multiorder option").each(function () {
                    if (orderno == '') {
                        orderno += "'" + $(this).val() + "'";
                    }
                    else
                    {
                        orderno += ",'" + $(this).val() + "'";
                    }
                });
                $('#ContentPlaceHolder1_ordervalue').val(orderno);
                GetOrderData('2210', orderno, false);
            }
        })
        
        $('#txt_filtervalue').bind("enterKey", function (e) {
            showPopOrderWindow();
        });
        $('#txt_filtervalue').keyup(function (e) {
            if (e.keyCode == 13) {
                $(this).trigger("enterKey");
            }
        });
        // global hook - unblock UI when ajax request completes
        $(document).ajaxStop($.unblockUI);

        function showPopOrderWindow()
        {
            var tmpfiltervalue;
            $('#chk_selectall').prop('checked', false);
            if ($('#sel_filter').val() == '>=') {
                tmpfiltervalue = $('#txt_filtervalue').val();
            }
            else {
                tmpfiltervalue = '%' + $('#txt_filtervalue').val() + '%';
            }
            if ($('#ContentPlaceHolder1_chk_isbetween').prop('checked') == false) {
                ListOrderTable('2210', $('#sel_filterkey').val(), $('#sel_filter').val(), tmpfiltervalue, true);
            }
            else {
                ListOrderTable('2210', $('#sel_filterkey').val(), $('#sel_filter').val(), tmpfiltervalue, false);
            }
        }

        $('#chk_selectall').click(function () {
            $('#poporderlist input:checkbox').prop('checked', this.checked);
        });
    </script>
</asp:Content>

