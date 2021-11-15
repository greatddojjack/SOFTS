<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="aQTest.aspx.cs" Inherits="taifex_aQTest" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>阿Q回測</title>
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/jquery.dataTables.min.css"/>
    <link rel="stylesheet" type="text/css" href="/plugins/datatables/buttons.dataTables.min.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div class="se-pre-con"></div>
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>阿Q回測
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="/index.aspx"><i class="fa fa-dashboard"></i>Home</a></li>
                <li class="active">阿Q回測</li>
            </ol>
        </section>
        <div class="pad margin no-print">
            <div class="callout callout-info" style="margin-bottom: 0!important;">
                <h4><i class="fa fa-info"></i>說明:</h4>
                <pre>阿Q是個小小兵,武器不足,也非藍波,百戰百勝,高手請略過忽視.......
武器介紹:手榴彈(選擇權[3X]),槍榴彈(選擇權[7X]),刺針飛彈(選擇權[10X]),洲際導彈(小台)。
以上月結算價為主,不管其他技術分析,只要記得八字箴言即可『逢低買進，逢高賣出』只需看數字,不要看線。
1.結算價加減245>>手榴彈x1
2.結算價加減490>>槍榴彈x1
3.結算價加減735>>槍榴彈x2
4.結算價加減980>>刺針飛彈x1
5.結算價加減1225>>洲際導彈x1
eg.10510+245=10755,比結算價高,放空手榴彈x1。上月結算價:10510,10510-245=10265,比結算價低,作多手榴彈x1。</pre>
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
                            <div class="form-group">
                                <label class="col-sm-3 control-label" id="uprange_label" for="uprange_id">漲範圍與間距</label>
                                <div class="col-sm-9 input-group">
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="uprange1" name="uprange1" placeholder="範圍1" value="10">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="uprange2" name="uprange2" placeholder="範圍2"  value="100">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="uprange_size" name="uprange_size" placeholder="間距" value="10">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label" id="downrange_label" for="downrange_id">跌範圍與間距</label>
                                <div class="col-sm-9 input-group">
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="downrange1" name="downrange1" placeholder="範圍1" value="10">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="downrange2" name="downrange2" placeholder="範圍2" value="100">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="downrange_size" name="downrange_size" placeholder="間距" value="10">
                                    </div>
                                </div>
                            </div>
							<div class="form-group">
                                <label class="col-sm-3 control-label" id="stopmoney_label" for="stopmoney_id">停利範圍與間距</label>
                                <div class="col-sm-9 input-group">
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stopmoneyrange1" name="stopmoneyrange1" placeholder="範圍1" value="10">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stopmoneyrange2" name="stopmoneyrange2" placeholder="範圍2" value="100">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stopmoneyrange_size" name="stopmoneyrange_size" placeholder="間距" value="10">
                                    </div>
                                </div>
                            </div>
							<div class="form-group">
                                <label class="col-sm-3 control-label" id="stophurt_label" for="stophurt_id">停損範圍與間距</label>
                                <div class="col-sm-9 input-group">
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stophurtrange1" name="stophurtrange1" placeholder="範圍1" value="10">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stophurtrange2" name="stophurtrange2" placeholder="範圍2" value="100">
                                    </div>
                                    <div class="col-xs-4">
                                        <input type="text" class="form-control" id="stophurtrange_size" name="stophurtrange_size" placeholder="間距" value="10">
                                    </div>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="col-sm-3 control-label" id="daterange_label" for="downrange_id">日期範圍</label>
                                <div class="col-sm-9 input-group">
                                    
                                        <div class="input-group-addon">
                                            <i class="fa fa-calendar"></i>
                                        </div>
                                        <input type="text" class="form-control pull-right" id="daterange">
                                    
                                </div>                                
                            </div>
                            <div class="form-group">
                                <button class="btn btn-success btn-flat" id="start">回測</button>&nbsp;
									<button class="btn btn-danger btn-flat " id="clear">清空</button>
                                </div>
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
                            <table id="aQ_table" class="display"></table>                            
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
<asp:Content ID="Content3" ContentPlaceHolderID="FooterPlaceHolder" Runat="Server">
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
    <script src="aQTest.js"></script>  
</asp:Content>

