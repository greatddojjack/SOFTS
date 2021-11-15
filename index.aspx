<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="index" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <title>廣翰資訊平台</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="content-wrapper">
        <!-- Content Header (Page header) -->
        <section class="content-header">
            <h1>首頁
        <small></small>
            </h1>
            <ol class="breadcrumb">
                <li><a href="#"><i class="fa fa-dashboard"></i>Home</a></li>
            </ol>
        </section>

        <!-- Main content -->
        <section class="content">
            <!-- /.box -->
            <div class="row">
                <div class="col-xs-12 col-md-6">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title">一週天氣</h3>
                        </div>
                        <div class="box-body">
                            <!-- weather widget start -->
                            <div id="m-booked-weather-bl250-10767">
                                <div class="booked-wzs-250-175 weather-customize" style="background-color: #1594e8; width: 344px;" id="width2">
                                    <div class="booked-wzs-250-175_in">
                                        <div class="booked-wzs-250-175-data">
                                            <div class="booked-wzs-250-175-left-img wrz-18">
                                                <a target="_blank" href="http://www.booked.net/">
                                                    <img src="//s.bookcdn.com/images/letter/logo.gif" alt="booked.net" />
                                                </a>
                                            </div>
                                            <div class="booked-wzs-250-175-right">
                                                <div class="booked-wzs-day-deck">
                                                    <div class="booked-wzs-day-val">
                                                        <div class="booked-wzs-day-number"><span class="plus">+</span>27</div>
                                                        <div class="booked-wzs-day-dergee">
                                                            <div class="booked-wzs-day-dergee-val">&deg;</div>
                                                            <div class="booked-wzs-day-dergee-name">C</div>
                                                        </div>
                                                    </div>
                                                    <div class="booked-wzs-day">
                                                        <div class="booked-wzs-day-d">H: <span class="plus">+</span>27&deg;</div>
                                                        <div class="booked-wzs-day-n">L: <span class="plus">+</span>26&deg;</div>
                                                    </div>
                                                </div>
                                                <div class="booked-wzs-250-175-info">
                                                    <div class="booked-wzs-250-175-city">Tainan </div>
                                                    <div class="booked-wzs-250-175-date">星期四, 01 六月</div>
                                                    <div class="booked-wzs-left"><span class="booked-wzs-bottom-l">查看7天预报</span> </div>
                                                </div>
                                            </div>
                                        </div>
                                        <a target="_blank" href="http://ibooked.cn/weather/tainan-15680">
                                            <table cellpadding="0" cellspacing="0" class="booked-wzs-table-250">
                                                <tr>
                                                    <td>周三</td>
                                                    <td>周五</td>
                                                    <td>周六</td>
                                                    <td>周日</td>
                                                    <td>周一</td>
                                                    <td>周二</td>
                                                </tr>
                                                <tr>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                    <td class="week-day-ico">
                                                        <div class="wrz-sml wrzs-18"></div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>28&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>28&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>28&deg;</td>
                                                </tr>
                                                <tr>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>26&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>25&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>26&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                    <td class="week-day-val"><span class="plus">+</span>27&deg;</td>
                                                </tr>
                                            </table>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <script type="text/javascript"> var css_file = document.createElement("link"); css_file.setAttribute("rel", "stylesheet"); css_file.setAttribute("type", "text/css"); css_file.setAttribute("href", 'https://s.bookcdn.com/css/w/booked-wzs-widget-275.css?v=0.0.1'); document.getElementsByTagName("head")[0].appendChild(css_file); function setWidgetData(data) { if (typeof (data) != 'undefined' && data.results.length > 0) { for (var i = 0; i < data.results.length; ++i) { var objMainBlock = document.getElementById('m-booked-weather-bl250-10767'); if (objMainBlock !== null) { var copyBlock = document.getElementById('m-bookew-weather-copy-' + data.results[i].widget_type); objMainBlock.innerHTML = data.results[i].html_code; if (copyBlock !== null) objMainBlock.appendChild(copyBlock); } } } else { alert('data=undefined||data.results is empty'); } } </script>
                            <script type="text/javascript" charset="UTF-8" src="https://widgets.booked.net/weather/info?action=get_weather_info&ver=6&cityID=15680&type=3&scode=124&ltid=3457&domid=&anc_id=27324&cmetric=1&wlangID=17&color=1594e8&wwidth=344&header_color=ffffff&text_color=333333&link_color=08488D&border_form=1&footer_color=ffffff&footer_text_color=333333&transparent=0"></script>
                            <!-- weather widget end -->
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->


                </div>


                <div class="col-xs-12 col-md-6">
                    <div class="box">
                        <div class="box-header with-border">
                            <h3 class="box-title">LME鋁價格走勢</h3>
                        </div>
                        <div class="box-body" style="text-align:center">
                            <a href="http://www.scrapmonster.com/lme/lme-aluminum-cash-price/346/10" rel="nofollow" target="_blank">
                                <img src="http://www.scrapmonster.com/images/charts/LME-Aluminum-Cash-346-10.png" />
                            </a>
                        </div>
                        <!-- /.box-body -->
                    </div>
                    <!-- /.box -->
                </div>

            </div>
            <!-- /.box -->
        </section>
        <!-- /.content -->
    </div>
</asp:Content>

