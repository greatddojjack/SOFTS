<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="quote.aspx.cs" Inherits="taifex_Default" EnableEventValidation="false" ValidateRequest="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>Quote</title>

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
                <ul>
                    <li>報價。</li>
                </ul>
            </div>
        </div>
        <!-- Main content -->
        <section class="content">
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-6">
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
                        <form class="form-horizontal">
                            <div class="box-body">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="refreshInterval_label" for="refreshInterval_id">更新頻率</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="refreshInterval" name="refreshInterval" placeholder="秒數" value="600" />
                                        </div>
                                        <div class="col-xs-6">
                                            <span id="refreshSecond">幾</span>秒後更新
                                        </div>

                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="contractMonth_label" for="contractMonth_label_id">履約年月</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="contractMonth" name="contractMonth" placeholder="履約年月" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="lastClosePrice_label" for="lastClosePrice_id">上月結算價</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="lastClosePrice" name="lastClosePrice" placeholder="上月結算價" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="lastWeekClosePrice_label" for="lastWeekClosePrice_id">上週結算價</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="lastWeekClosePrice" name="lastWeekClosePrice" placeholder="上週結算價" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="upRange_label" for="upRange_id">上距</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="upRange" name="upRange" placeholder="上距" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="downRange_label" for="downRange_id">下距</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="downRange" name="downRange" placeholder="下距" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="stopMoney_label" for="stopMoney_id">停利</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="stopMoney" name="stopMoney" placeholder="停利" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="stopHurt_label" for="stopHurt_id">停損</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="stopHurt" name="stopHurt" placeholder="停損" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="email_label" for="email_id">通知mail</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="email" name="email" placeholder="email" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <div class="col-sm-offset-4 col-sm-10">
                                        <button class="btn btn-success btn-flat" id="saveSetting">設定</button>
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                        </form>

                    </div>
                    <!-- /.box -->
                </div>
                <div class="col-xs-6">
                    <div class="box box-warning">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="weapon_form_title">即時資訊</h3>
                            <div class="box-tools pull-right">
                                <span id="box_marker_count1" data-toggle="tooltip" title="" class="badge bg-lime"></span>
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
                        <form class="form-horizontal">
                            <div class="box-body">
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="realtimeTaifex_label" for="realtimeTaifex_id">台指期</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="realtimeTaifex" name="realtimeTaifex" placeholder="台指期" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="weapon1_label" for="weapon1">3x*1</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon1Call" name="weapon1Call" placeholder="武器1" />
                                        </div>
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon1Put" name="weapon1Put" placeholder="武器1" />
                                        </div>
                                    </div>
                                </div>

                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="weapon2_label" for="weapon2">7x*1</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon2Call" name="weapon2Call" placeholder="武器2" />
                                        </div>
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon2Put" name="weapon2Put" placeholder="武器2" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="weapon3_label" for="weapon3">7x*2</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon3Call" name="weapon3Call" placeholder="武器3" />
                                        </div>
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon3Put" name="weapon3Put" placeholder="武器3" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="weapon4_label" for="weapon4">1xx*1</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon4Call" name="weapon4Call" placeholder="武器4" />
                                        </div>
                                        <div class="col-xs-6">
                                            <input type="text" class="form-control" id="weapon4Put" name="weapon4Put" placeholder="武器4" />
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label class="col-sm-4 control-label" id="weapon5_label" for="weapon5">小台*1</label>
                                    <div class="col-sm-8 input-group">
                                        <div class="col-xs-12">
                                            <input type="text" class="form-control" id="weapon5" name="weapon5" placeholder="武器5" />
                                        </div>

                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                        </form>

                    </div>
                    <!-- /.box -->
                </div>
            </div>
            <div class="row">
                <div class="col-xs-12">
                    <div class="box collapsed-box">
                        <div class="box-header with-border">
                            <h3 class="box-title" id="calculateBuy_title">策略表</h3>
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
                            <div class="row">
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="cbWeapon_label" for="cbWeapon_id">武器</label>
                                        <input type="text" class="form-control" id="cbWeapon1" name="cbWeapon1" placeholder="1" />
                                        <input type="text" class="form-control" id="cbWeapon2" name="cbWeapon2" placeholder="2" />
                                        <input type="text" class="form-control" id="cbWeapon3" name="cbWeapon3" placeholder="3" />
                                        <input type="text" class="form-control" id="cbWeapon4" name="cbWeapon4" placeholder="4" />
                                        <input type="text" class="form-control" id="cbWeapon5" name="cbWeapon5" placeholder="5" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="cbDownRange_label" for="cbDownRange_id">結算價減</label>
                                        <input type="text" class="form-control" id="cbDownRange1" name="cbDownRange1" placeholder="1" />
                                        <input type="text" class="form-control" id="cbDownRange2" name="cbDownRange2" placeholder="2" />
                                        <input type="text" class="form-control" id="cbDownRange3" name="cbDownRange3" placeholder="3" />
                                        <input type="text" class="form-control" id="cbDownRange4" name="cbDownRange4" placeholder="4" />
                                        <input type="text" class="form-control" id="cbDownRange5" name="cbDownRange5" placeholder="5" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="cbBuyPoint_label" for="cbBuyPoint_id">做多點</label>
                                        <input type="text" class="form-control" id="cbBuyPoint1" name="cbBuyPoint1" placeholder="1" />
                                        <input type="text" class="form-control" id="cbBuyPoint2" name="cbBuyPoint2" placeholder="2" />
                                        <input type="text" class="form-control" id="cbBuyPoint3" name="cbBuyPoint3" placeholder="3" />
                                        <input type="text" class="form-control" id="cbBuyPoint4" name="cbBuyPoint4" placeholder="4" />
                                        <input type="text" class="form-control" id="cbBuyPoint5" name="cbBuyPoint5" placeholder="5" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="cbStopMoney_label" for="cbStopMoney_id">結算價加</label>
                                        <input type="text" class="form-control" id="cbUpRange1" name="cbUpRange1" placeholder="1" />
                                        <input type="text" class="form-control" id="cbUpRange2" name="cbUpRange1" placeholder="2" />
                                        <input type="text" class="form-control" id="cbUpRange3" name="cbUpRange1" placeholder="3" />
                                        <input type="text" class="form-control" id="cbUpRange4" name="cbUpRange1" placeholder="4" />
                                        <input type="text" class="form-control" id="cbUpRange5" name="cbUpRange1" placeholder="5" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="cbStophHurt_label" for="cbStophHurt_id">做空點</label>
                                        <input type="text" class="form-control" id="cbSellPoint1" name="cbSellPoint1" placeholder="1" />
                                        <input type="text" class="form-control" id="cbSellPoint2" name="cbSellPoint2" placeholder="2" />
                                        <input type="text" class="form-control" id="cbSellPoint3" name="cbSellPoint3" placeholder="3" />
                                        <input type="text" class="form-control" id="cbSellPoint4" name="cbSellPoint4" placeholder="4" />
                                        <input type="text" class="form-control" id="cbSellPoint5" name="cbSellPoint5" placeholder="5" />
                                    </div>
                                </div>
                                <div class="col-md-2">
                                    <div class="form-group">
                                        <label id="pbWeapon_label" for="pbWeapon_id">武器</label>
                                        <input type="text" class="form-control" id="pbWeapon1" name="pbWeapon1" placeholder="1" />
                                        <input type="text" class="form-control" id="pbWeapon2" name="pbWeapon2" placeholder="2" />
                                        <input type="text" class="form-control" id="pbWeapon3" name="pbWeapon3" placeholder="3" />
                                        <input type="text" class="form-control" id="pbWeapon4" name="pbWeapon4" placeholder="4" />
                                        <input type="text" class="form-control" id="pbWeapon5" name="pbWeapon5" placeholder="5" />
                                    </div>
                                </div>
                            </div>
                            <!-- /.box-body -->
                        </div>
                        <!-- /.box -->
                    </div>

                </div>
                </div>
                <div class="row">
                    <div class="col-xs-12">
                        <div class="box">
                            <div class="box-header with-border">
                                <h3 class="box-title" id="taifex_title">xx報價</h3>
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
                                                        <button type="button" class="btn btn-success btn-flat" id="sellPutTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('SellPut');">ST</button>
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
                                                        <button type="button" class="btn btn-success btn-flat" id="buyPutTrade" data-toggle="modal" data-target="#modal-tradeConfirm" onclick="AssembTradeString('BuyPut');">ST</button>
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
                            <button type="button" class="btn btn-outline pull-left" data-dismiss="modal" onclick="WriteTradeString();">確定下單</button>
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
    <script src="quote.js"></script>
    <script src="entrustAPI.js"></script>
</asp:Content>

