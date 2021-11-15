<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="INV001.aspx.cs" Inherits="INV_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>盤點盈虧清單</title>

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
            background-color: Gray;
            filter: alpha(opacity=70);
            opacity: 0.7;
        }


        .modalPopup {
            background-color: #FFFFFF;
            width: 650px;
            height: 550px;
            border: 3px solid #0DA9D0;
            border-radius: 12px;
            padding: 0;
        }

            .modalPopup .header {
                background-color: #2FBDF1;
                height: 30px;
                color: White;
                line-height: 30px;
                text-align: center;
                font-weight: bold;
                border-top-left-radius: 6px;
                border-top-right-radius: 6px;
            }

            .modalPopup .body {
                min-height: 50px;
                line-height: 30px;
                text-align: center;
                font-weight: bold;
            }

            .modalPopup .footer {
                padding: 6px;
            }

        .close {
            DISPLAY: block;
            BACKGROUND: url(/image/close.png) no-repeat 0px 0px;
            RIGHT: -38px;
            WIDTH: 48px;
            TEXT-INDENT: -1000em;
            POSITION: absolute;
            TOP: -38px;
            HEIGHT: 48px;
        }
    </style>
    <!-- daterange picker -->
    <link rel="stylesheet" href="../../plugins/daterangepicker/daterangepicker.css">
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../plugins/datepicker/datepicker3.css">
    <!-- Bootstrap time Picker -->
    <link rel="stylesheet" href="../../plugins/timepicker/bootstrap-timepicker.min.css">
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/jquery.dataTables.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>盤點盈虧清單
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">盤點盈虧清單</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <ul>
                    <li>從2017年1月開始，每月關帳後產生的盤盈虧報表可由此下載。</li>                    
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
                            <div class="row">
                                <div class="col-xs-6 col-md-3">
                                    <div class="form-group">
                                        <label>盤點月份:</label>

                                        <div class="input-group date">
                                            <div class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </div>
                                            <input type="text" class="form-control pull-right" id="datepicker" placeholder="yyyymm">

                                        </div>

                                    </div>
                                </div> 
                                <!-- /.input group -->
                            </div>
                        </div>
                        <!-- /.box-body -->
                        <div class="box-footer">
                            <button type="button" class="btn btn-primary" id="datesubmit">查詢</button>
                            <button type="button" class="btn btn-link" id="zipfile">當月全部下載</button>
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
                            <table id="filelist" class="display" width="100%" cellspacing="0">
                                <thead>
                                    <tr>
                                        <th>年月份</th>
                                        <th>檔名</th>
                                        <th>下載</th>

                                    </tr>
                                </thead>  
                                <tbody></tbody>                              
                                <tfoot>
                                    <tr>
                                        <th>年月份</th>
                                        <th>檔名</th>
                                        <th>下載</th>

                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>
                <!-- /.box-body -->
            </div>
            <!-- /.box -->
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box box-default collapsed-box">
                        <div class="box-header with-border">
                            <h5>產生盤盈虧報表(資管操作)</h5>
                            <div class="box-tools pull-right">
                <button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-plus"></i>
                </button>
              </div>
                        </div>
                        <div class="box-body">
                            <div class="row">
                                <div class="col-xs-6 col-md-3">
                                    <div class="form-group">
                                        <label>測試資料庫:</label>

                                        <div class="input-group date">
                                            <div class="input-group-addon">
                                                <i class="fa fa-database"></i>
                                            </div>
                                            <input type="text" class="form-control" id="db" placeholder="GH20xxxxxx">
                                            <input type="password" class="form-control" id="inputPassword" placeholder="共用密碼">
                                        </div>

                                    </div>
                                </div> 
                                <!-- /.input group -->
                            </div>
                            <div class="row">
                                <div class="col-xs-6 col-md-3">
                                    <div class="form-group">
                                        <label>盤點月份:</label>

                                        <div class="input-group date">
                                            <div class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </div>
                                            <input type="text" class="form-control pull-right" id="ym" placeholder="yyyymm">
                                            <input type="text" class="form-control" id="closeday" placeholder="關帳日" />                                            
                                        </div>
                                        <span class="help-block"><label id='msg'></label></span>
                                    </div>
                                </div> 
                                <!-- /.input group -->
                            </div>                            
                        </div>
                        <!-- /.box-body -->
                        <div class="box-footer">
                            <button type="button" class="btn btn-primary" id="reportsubmit">產生</button>
                        </div>
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
    <!-- date-range-picker -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
    <script src="../../plugins/daterangepicker/daterangepicker.js"></script>    
    <!-- bootstrap datepicker -->
    <script src="../../plugins/datepicker/bootstrap-datepicker.js"></script>
    <script src="../../plugins/datepicker/locales/bootstrap-datepicker.zh-TW.js"></script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/jquery.dataTables.min.js">
    </script>    
    <script>

        //
        
        function ListFileTable(dir, ext) {
            var $tmpData;
            var $FileData;            
            $("#filelist tbody").remove();
            $.ajax({
                type: "POST",
                url: "/WebService.asmx/GetFileList",
                contentType: "application/json; charset=utf-8",
                async: false,
                cache: false,
                dataType: 'json',
                data: '{"dir":"' + dir + '","fileext":"' + ext + '"}',
                success: function (data) {
                    if (data.hasOwnProperty("d")) {
                        tmpData = data.d;
                    }
                    else
                        tmpData = data;
                }

            });
            if(tmpData != '')
            {
                FileData = JSON.parse(tmpData);
                if (FileData.length > 0) {
                  $('#filelist').append('<tbody></tbody>');
                    for (i = 0; i < FileData.length; i++) {
                        $('#filelist tbody').append('<tr><td>' + $("#datepicker").val() + '</td><td>' + FileData[i].OriginalPath + '</td><td><a href="' + FileData[i].FullPath + '"><i class="fa fa-download"></i></a></td></tr>');
                    }
                }
            }            
        }

        Date.prototype.yyyymm = function () {
            var mm = this.getMonth(); // getMonth() is zero-based            

            return [this.getFullYear(),
                    (mm > 9 ? '' : '0') + mm
            ].join('');
        };
        

        $(document).ready(function () {            
            //Date picker
            $('#datepicker').datepicker({
                format: 'yyyymm',
                autoclose: true,
                language: 'zh-TW'
            });
            var date = new Date();
            
            $("#datepicker").val(date.yyyymm());
            ListFileTable('/INV/INV001/' + $("#datepicker").val(), '*');
            $('#filelist').DataTable({
                destroy:true,
                "pageLength": 50                
            });
        });
        $('#zipfile').click(function () {
            location.href = '/INV/INV001/' + $("#datepicker").val() + '.zip';
        })
        $('#datesubmit').click(function () {
            ListFileTable('/INV/INV001/' + $("#datepicker").val(), '*');
            $('#filelist').DataTable({               
                "pageLength": 50,
                destroy: true
            });           
        })
        $('#reportsubmit').click(function () {
            $.blockUI();
            $.ajax({
                type: "POST",
                url: "/WebService.asmx/createINVCount",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: false,
                dataType: 'json',
                data: '{"pwd":"' + $('#inputPassword').val() + '","db":"' + $('#db').val() + '","ym":"' + $('#ym').val() + '","closeday":"' + $('#closeday').val() + '"}',
                success: function (data) {
                    if (data.hasOwnProperty("d")) {
                        tmpData = data.d;
                    }
                    else
                        tmpData = data;
                    var msgData;
                    if (tmpData != '') {
                        msgData = JSON.parse(tmpData);                        
                        for (i = 0; i < msgData.length; i++) {
                            $("#msg").text(msgData[i].msg);
                        }
                    }
                }
            });
        })

        // global hook - unblock UI when ajax request completes
        $(document).ajaxStop($.unblockUI);
    </script>    
</asp:Content>

