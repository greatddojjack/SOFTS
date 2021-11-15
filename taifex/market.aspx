<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="market.aspx.cs" Inherits="taifex_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>Market</title>

    <style>
        canvas {
            -moz-user-select: none;
            -webkit-user-select: none;
            -ms-user-select: none;
        }
    </style>
    <style>
        .example-modal .modal {
            position: relative;
            top: auto;
            bottom: auto;
            right: auto;
            left: auto;
            display: block;
            z-index: 1;
        }

        .example-modal .modal {
            background: transparent !important;
        }
    </style>
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/jquery.dataTables.min.css" />
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/buttons.dataTables.min.css" />

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>報價
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">報價</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>

                <pre></pre>
                
            </div>
        </div>
        <!-- Main content -->
        <section class="content">
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-8">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="setting_form_title">基本參數</h3>
                            <div class="box-tools pull-right">
                                <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <!-- 
									<button type="button" class="btn btn-box-tool" data-widget="remove">
										<i class="fa fa-times"></i>
									</button>
									-->
                            </div>
                        </div>
                        <div class="box-body" id="stock_0050">
                           <iframe id="menuFrame" name="menuFrame" src="//www.google.com.tw" style="overflow:visible;" scrolling="auto"  frameborder="no" height="100%" width="100%"></iframe>

                        </div>
                    </div>
                </div>
                <!-- /.box-body -->
                <!-- /.box -->
                 <div class="col-xs-4">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="setting_form_title">下單條件判斷-目前期指<label id="p0_1">10400</label></h3>
                            <div class="box-tools pull-right">
                                <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>                               
                            </div>
                        </div>
                        <div class="box-body">
            <div class="form-group">
                1.近月價平CP加總<label id="p1_1">330</label><br />
                2.遠月價平CP加總<label id="p2_1">330</label><br />
                3.近月+遠月C加總<label id="p3_1">330</label><br />
                
              </div>
                        </div>
                        </div>
                     </div>
                </div>
            <!-- row -->
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="taifex_title">Taifex報價</h3>
                            <div class="box-tools pull-right">
                                <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <!-- 
									<button type="button" class="btn btn-box-tool" data-widget="remove">
										<i class="fa fa-times"></i>
									</button>
									-->
                            </div>
                        </div>
                        <div class="box-body">
                            <table id="taifex_table" class="display"></table>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header with-border">

                            <label class="col-sm-1 control-label" id="taiopt_title">OPT</label>
                            <div class="col-sm-2">
                                <select class="input-group" id="optContractMonth">
                                    <option>履約年月</option>
                                </select>
                            </div>

                            <div class="box-tools pull-right">
                                <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <!-- 
									<button type="button" class="btn btn-box-tool" data-widget="remove">
										<i class="fa fa-times"></i>
									</button>
									-->
                            </div>
                        </div>
                        <div class="box-body">
                            <table id="taiopt_table" class="display">
                                <thead>
                                    <tr>
                                        <th>CALL買進</th>
                                        <th>CALL賣出</th>
                                        <th>CALL成交</th>
                                        <th>CALL漲跌</th>
                                        <th>CALL未平倉</th>
                                        <th>CALL總量</th>
                                        <th>CALL時間</th>
                                        <th>履約價</th>
                                        <th>PUT買進</th>
                                        <th>PUT賣出</th>
                                        <th>PUT成交</th>
                                        <th>PUT漲跌</th>
                                        <th>PUT未平倉</th>
                                        <th>PUT總量</th>
                                        <th>PUT時間</th>
                                    </tr>
                                </thead>
                            </table>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
            <div class="row">
                <div class="col-xs-12">
                </div>
                <!-- /.box -->
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="vix_title">其他資訊</h3>
                            <div class="box-tools pull-right">
                                <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                    <i class="fa fa-minus"></i>
                                </button>
                                <!-- 
									<button type="button" class="btn btn-box-tool" data-widget="remove">
										<i class="fa fa-times"></i>
									</button>
									-->
                            </div>
                        </div>
                        <div class="box-body">
                            <table id="vix_table" class="display">
                                <caption>VIX</caption>
                            </table>
                        </div>
                        <div class="box-body">
                            <table id="stock_table" class="display">
                                <caption>個股報價</caption>
                            </table>
                        </div>
                        <div class="box-body">
                            <table id="trade_table" class="display">
                                <caption>未平倉表</caption>
                            </table>
                            PUT點數:<label id="put_point"></label>
                            CALL點數:<label id="call_point"></label>
                        </div>
                        <div class="box-body">
                            <table id="track_table" class="display">
                                <caption>到價提醒表</caption>
                            </table>
                        </div>
                        <!-- /.box-body -->
                        <div class="box-footer">
                            一般而言，在行情下跌時，Vix會上升，行情上漲時，Vix 會下跌。
                                波動率正常值來說12-15，波動率低是買方的市場，一有波動馬上跳動。若波動率來到最高時，反而是賣方進場的好時機。
                        </div>
                        <!-- /.box-footer-->
                    </div>
                    <!-- /.box -->
                </div>
            </div>

            <!-- /.modal -->
            <div class="modal fade" id="modal-info">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">買賣動作</h4>
                        </div>
                        <div class="modal-body">
                            <p>履約價格：<span id="actionValue"></span> 權利金：BuyCall=<span id="actionBuyCallPrice"></span>,SellCall=<span id="actionSellCallPrice"></span>, BuyPut=<span id="actionBuyPutPrice"></span>, SellPut=<span id="actionSellPutPrice"></span></p>
                            <button type="button" class="btn btn-default" onclick="WriteBCValue();">Buy Call</button>
                            <button type="button" class="btn btn-default" onclick="WriteSCValue();">Sell Call</button>
                            <button type="button" class="btn btn-default" onclick="WriteBPValue();">Buy Put</button>
                            <button type="button" class="btn btn-default" onclick="WriteSPValue();">Sell Put</button>
                            <div class="box">
                                <div class="box-header with-border">
                                    <label class="col-sm-1 control-label" id="trade_title">Trade</label>
                                    <div class="col-sm-2">
                                        <select class="input-group" id="tradeOpenClose">
                                            <option value="O">新倉</option>
                                            <option value="C">平倉</option>
                                        </select>
                                    </div>
                                    <label class="col-sm-1 control-label" id="company_title">期貨商</label>
                                    <div class="col-sm-2">
                                        <select class="input-group" id="tradeCompany">
                                            <option value="entrust">華南</option>
                                            <option value="jihsun">日盛</option>
                                        </select>
                                    </div>
                                    <div class="box-tools pull-right">
                                        <span id="box_marker_count" data-toggle="tooltip" title="" class="badge bg-light-blue"></span>
                                        <button type="button" class="btn btn-box-tool" data-widget="collapse">
                                            <i class="fa fa-minus"></i>
                                        </button>
                                    </div>
                                </div>
                                <form class="form-horizontal">
                                    <div class="box-body">
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-2 control-label" id="buyCall_label" for="buyCall_label_id">Buy Call</label>
                                                    <div class="col-sm-10 input-group">
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="buyCallValue" name="buyCallValue" placeholder="履約價格" />
                                                        </div>
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="buyCallPrice" name="buyCallPrice" placeholder="權利金" />
                                                        </div>
                                                        <div class="col-xs-2">
                                                            <button type="button" class="btn btn-success btn-flat" id="buyCallTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('BuyCall');">ST</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-2 control-label" id="sellCall_label" for="sellCall_label_id">Sell Call</label>
                                                    <div class="col-sm-10 input-group">
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="sellCallValue" name="sellCallValue" placeholder="履約價格" />
                                                        </div>
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="sellCallPrice" name="sellCallPrice" placeholder="權利金" />
                                                        </div>
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="callDiff" name="callDiff" placeholder="差價" />
                                                        </div>
                                                        <div class="col-xs-1">
                                                            <button type="button" class="btn btn-success btn-flat" id="sellCallTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('SellCall');">ST</button>
                                                        </div>
                                                        <div class="col-xs-1">
                                                            <button type="button" class="btn btn-warning btn-flat" id="buySellCallTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('BuySellCall');">MT</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-2 control-label" id="buyPut_label" for="buyPut_label_id">Buy Put</label>
                                                    <div class="col-sm-10 input-group">
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="buyPutValue" name="buyPutValue" placeholder="履約價格" />
                                                        </div>
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="buyPutPrice" name="buyPutPrice" placeholder="權利金" />
                                                        </div>
                                                        <div class="col-xs-2">
                                                            <button type="button" class="btn btn-success btn-flat" id="buyPutTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('BuyPut');">ST</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-2 control-label" id="sellPut_label" for="sellPut_label_id">Sell Put</label>
                                                    <div class="col-sm-10 input-group">
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="sellPutValue" name="sellPutValue" placeholder="履約價格" />
                                                        </div>
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="sellPutPrice" name="sellPutPrice" placeholder="權利金" />
                                                        </div>
                                                        <div class="col-xs-3">
                                                            <input type="text" class="form-control" id="putDiff" name="putPrice" placeholder="差價" />
                                                        </div>
                                                        <div class="col-xs-1">
                                                            <button type="button" class="btn btn-success btn-flat" id="SellPutTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('SellPut');">ST</button>
                                                        </div>
                                                        <div class="col-xs-1">
                                                            <button type="button" class="btn btn-warning btn-flat" id="buySellPutTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('BuySellPut');">MT</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label" id="quantityDepoist_label" for="profitAndLoss_label_id">參數</label>
                                                    <div class="col-sm-9 input-group">
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="quantity" value="1" name="quantity" placeholder="口數" />
                                                        </div>
                                                        <div class="col-xs-5">
                                                            <input type="text" class="form-control" id="deposit" name="depoist" placeholder="保證金" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-12">
                                                <div class="form-group">
                                                    <label class="col-sm-3 control-label" id="profitAndLoss_label" for="profitAndLoss_label_id">損益</label>
                                                    <div class="col-sm-9 input-group">
                                                        <div class="col-xs-5 has-success">
                                                            <input type="text" class="form-control" id="profitValue" name="profitValue" placeholder="最大收益" />
                                                        </div>
                                                        <div class="col-xs-5 has-error">
                                                            <input type="text" class="form-control" id="lossValue" name="lossValue" placeholder="最大損失" />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="form-group">
                                                <div class="col-sm-offset-5 col-sm-12">
                                                    <button type="button" class="btn btn-default btn-flat" id="renewOpt" onclick="ReNewOpt();">更新</button>
                                                    <button type="button" class="btn btn-default btn-flat" id="calculate" onclick="CalculateOpt();">計算</button>
                                                    <button type="button" class="btn btn-default btn-flat" id="createIcOpt" data-toggle="modal" data-target="#modal-icRange">組合</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /.box-body -->
                                </form>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-default pull-left" data-dismiss="modal">Close</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <div class="modal modal-info fade" id="modal-icRange">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">鐵兀鷹範圍</h4>
                        </div>
                        <div class="modal-body">
                            <p>履約價格範圍：</p>
                            <input type="text" class="form-control" id="icRange" name="icRange" placeholder="範圍" />
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline pull-left" data-dismiss="modal" onclick="CreateIcOpt($('#icRange').val(),50);">週選</button>
                            <button type="button" class="btn btn-outline pull-left" data-dismiss="modal" onclick="CreateIcOpt($('#icRange').val(),100);">月選</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
            <!-- /.modal -->
            <div class="modal modal-info fade" id="modal-tradeConfirm">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span></button>
                            <h4 class="modal-title">下單確認</h4>
                        </div>
                        <div class="modal-body">
                            <p>下單字串：</p>
                            <textarea class="form-control" rows="5" id="tradeString" name="tradeString" placeholder="下單字串"></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-outline pull-left" data-dismiss="modal" onclick="WriteTradeString('MANUAL','',0);">確定下單</button>
                            <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">取消</button>
                        </div>
                    </div>
                    <!-- /.modal-content -->
                </div>
                <!-- /.modal-dialog -->
            </div>
        </section>
    </div>
    <!-- /.modal -->

    <!-- /.content -->


</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" runat="Server">
    <script type="text/javascript" language="javascript" src="/plugins/datatables/jquery.dataTables.min.js">
    </script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/dataTables.buttons.min.js">
    </script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.flash.min.js">
    </script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/vfs_fonts.js">
    </script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.html5.min.js">
    </script>
    <script type="text/javascript" language="javascript" src="/plugins/datatables/buttons.print.min.js">
    </script>
    <!-- jQuery-csv -->
    <script src="/plugins/jquery-csv/jquery.csv.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mathjs/4.2.2/math.js"></script>
    <script src="market.js"></script>
    <script src="entrustAPI.js"></script>
</asp:Content>

