var mailAddr;
var refreshQuoteTimer;
var refreshSecondTimer;
var optTableM;
var taioptDataM, taioptDataW;
$("#saveSetting").on("click", function () {
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/UpdateSetting",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: JSON.stringify({ refreshTime: $("#refreshInterval").val(), preMonthClosePrice: $("#lastClosePrice").val(), preWeekClosePrice: $("#lastWeekClosePrice").val(), contractMonth: $("#contractMonth").val(), contractMonthWeek: $("#contractMonthWeek").val(), upRange: $("#upRange").val(), downRange: $("#downRange").val(), stopMoney: $("#stopMoney").val(), stopHurt: $("#stopHurt").val(), email: $("#email").val() }),
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                result = JSON.parse(data.d);
            }
            else {
                result = JSON.parse(data);
            }
            if (result.result >0) {
                alert("儲存成功");
                //SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
            }
        }
    });    
    getTaiQuote();
    window.clearInterval(refreshQuoteTimer);
    window.clearInterval(refreshSecondTimer);
    var refreshInterval = $('#refreshInterval').val() * 1000;
    $('#refreshSecond').text($('#refreshInterval').val());
    refreshQuoteTimer=window.setInterval(function () { getTaiQuote(); $('#refreshSecond').text($('#refreshInterval').val()); }, refreshInterval);
    refreshSecondTimer=window.setInterval(function () {
        $('#refreshSecond').text($('#refreshSecond').text() - 1);
    }, 1000);
    renewPlan();
	return false;
});
$("#optContractMonth").on("change", function () {
    ReNewOpt();
});

$(document).ready(function () {
    "use strict";
    $.blockUI();    
    var settingData;
    var taioptContractMonth;
    var deferred = $.Deferred();
    var deferreds = [];
    //get setting    
    deferreds.push(
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/GetSetting",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                settingData = JSON.parse(data.d);
            }
            else {
                settingData = JSON.parse(data);
            }
            $('#lastClosePrice').val(settingData[0]["pre_month_close_price"]);
            $('#lastWeekClosePrice').val(settingData[0]["pre_week_close_price"]);
            $('#contractMonth').val(settingData[0]["contract_month"]);
            $('#contractMonthWeek').val(settingData[0]["contract_month_week"]);
            $('#upRange').val(settingData[0]["up_range"]);
            $('#downRange').val(settingData[0]["down_range"]);
            $('#stopMoney').val(settingData[0]["stop_money"]);
            $('#stopHurt').val(settingData[0]["stop_hurt"]);
            $('#refreshInterval').val(settingData[0]["refresh_time"]);
            $('#email').val(settingData[0]["email"]);
            var refreshInterval = $('#refreshInterval').val() * 1000;
            $('#refreshSecond').text($('#refreshInterval').val());
            getTaiQuote();
            refreshQuoteTimer=window.setInterval(function () { getTaiQuote(); $('#refreshSecond').text($('#refreshInterval').val()); }, refreshInterval);
            refreshSecondTimer=window.setInterval(function () {
                $('#refreshSecond').text($('#refreshSecond').text() - 1);
            }, 1000);
            mailAddr = settingData[0]["email"].split(';');            
        }
    }));
    deferreds.push(
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/GetTaiOptContractMonth",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                taioptContractMonth = JSON.parse(data.d);
            }
            else {
                taioptContractMonth = JSON.parse(data);
            }
            taioptContractMonth["ContractMonth"].forEach(function (value, index) { $('#optContractMonth').append('<option value="' + value.ContractMonth + '">' + value.ContractMonth + '</option>'); });
            
        }
    }));
    $.when.apply($, deferreds).then(function () {
        $('#optContractMonth').val($('#contractMonth').val());
        ReNewOpt();
    });
});

function getTaiQuote() {
    $.blockUI();
    getStockPrice();
    getTrack();
    var deferred = $.Deferred();
    var deferreds = [];
    var taifexData;
    var vixData;
    //get taifex
    deferreds.push(
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/GetTaiFexInfo",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    taifexData = JSON.parse(data.d);
                }
                else {
                    taifexData = JSON.parse(data);
                }
                $('#taifex_table').DataTable({
                    data: taifexData,
                    destroy: true,
                    searching: false,
                    "bSort": false,
                    columns: [{
                        "title": "商品",
                        "data": "商品"
                    }, {
                        "title": "買價",
                        "data": "買價"
                    }, {
                        "title": "賣價",
                        "data": "賣價"
                    }, {
                        "title": "成交價",
                        "data": "成交價"
                    }, {
                        "title": "漲跌",
                        "data": "漲跌"
                    }, {
                        "title": "漲幅",
                        "data": "漲幅"
                    }, {
                        "title": "成交量",
                        "data": "成交量"
                    }, {
                        "title": "開盤",
                        "data": "開盤"
                    }, {
                        "title": "最高",
                        "data": "最高"
                    }, {
                        "title": "最低",
                        "data": "最低"
                    }, {
                        "title": "價差",
                        "data": "價差"
                    }, {
                        "title": "參考價",
                        "data": "參考價"
                    }, {
                        "title": "未平倉",
                        "data": "未平倉"
                    }, {
                        "title": "時間",
                        "data": "時間"
                    }]
                });
                /*
                var today = new Date();
                var thisMonth = (today.getMonth() + 1 < 10 ? '0' : '') + (today.getMonth() + 1);
                var thisYear = today.getFullYear().toString().substr(3, 1);
                //find object in list
                var result = $.map(taifexData, function (item, index) {
                    return item.商品
                }).indexOf('臺指期' + thisMonth + thisYear.substr(3, 1));
                */
                $('#realtimeTaifex').val(parseInt(taifexData[1].成交價.replace(",","")));
            }
        }));
    //抓近月選
    deferreds.push(        
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/GetTaiOptInfo",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '{"contractMonth":"' + $('#optContractMonth').val() + '"}',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    taioptDataM = JSON.parse(data.d);
                }
                else {
                    taioptDataM = JSON.parse(data);
                }
                var optkey = Object.keys(taioptDataM);
                //$('#taiopt_title').text(optkey + '報價');                
                optTableM = $('#taiopt_table').DataTable({
                    data: taioptDataM[optkey],
                    destroy: true,
                    searching: true,
                    order: [[7, "asc"]],
                    "columnDefs": [
                {
                    // The `data` parameter refers to the data for the cell (defined by the
                    // `data` option, which defaults to the column being worked with, in
                    // this case `data: 0`.
                    "render": function (data, type, row) {
                        var bcPrice = row["CALL買進"] === '--' ? 0 : row["CALL買進"];
                        var scPrice = row["CALL賣出"] === '--' ? 0 : row["CALL賣出"];
                        var bpPrice = row["PUT買進"] === '--' ? 0 : row["PUT買進"];
                        var spPrice = row["PUT賣出"] === '--' ? 0 : row["PUT賣出"];
                        return "<a data-toggle='modal' href='#modal-info' onclick='SendPriceToModals(" + data + "," + bcPrice + "," + scPrice + "," + bpPrice + "," + spPrice + ");'>" + data + "</a>";
                    },
                    "targets": 7
                }
                    ],
                    columns: [{
                        "title": "CALL買進",
                        "data": "CALL買進"
                    }, {
                        "title": "CALL賣出",
                        "data": "CALL賣出"
                    }, {
                        "title": "CALL成交",
                        "data": "CALL成交"
                    }, {
                        "title": "CALL漲跌",
                        "data": "CALL漲跌"
                    }, {
                        "title": "CALL未平倉",
                        "data": "CALL未平倉"
                    }, {
                        "title": "CALL總量",
                        "data": "CALL總量"
                    }, {
                        "title": "CALL時間",
                        "data": "CALL時間"
                    }, {
                        "title": "履約價",
                        "data": "履約價"
                    }, {
                        "title": "PUT買進",
                        "data": "PUT買進"
                    }, {
                        "title": "PUT賣出",
                        "data": "PUT賣出"
                    }, {
                        "title": "PUT成交",
                        "data": "PUT成交"
                    }, {
                        "title": "PUT漲跌",
                        "data": "PUT漲跌"
                    }, {
                        "title": "PUT未平倉",
                        "data": "PUT未平倉"
                    }, {
                        "title": "PUT總量",
                        "data": "PUT總量"
                    }, {
                        "title": "PUT時間",
                        "data": "PUT時間"
                    }]
                });
            }
        }));
    //抓週選
    deferreds.push(
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/GetTaiOptInfo",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '{"contractMonth":"' + $('#optContractMonthWeek').val() + '"}',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    taioptDataW = JSON.parse(data.d);
                }
                else {
                    taioptData = JSON.parse(data);
                }
                var optkey = Object.keys(taioptData);
                //$('#taiopt_title').text(optkey + '報價');                
                optTableW = $('#taiopt_table').DataTable({
                    data: taioptData[optkey],
                    destroy: true,
                    searching: true,
                    order: [[7, "asc"]],
                    "columnDefs": [
                {
                    // The `data` parameter refers to the data for the cell (defined by the
                    // `data` option, which defaults to the column being worked with, in
                    // this case `data: 0`.
                    "render": function (data, type, row) {
                        var bcPrice = row["CALL買進"] === '--' ? 0 : row["CALL買進"];
                        var scPrice = row["CALL賣出"] === '--' ? 0 : row["CALL賣出"];
                        var bpPrice = row["PUT買進"] === '--' ? 0 : row["PUT買進"];
                        var spPrice = row["PUT賣出"] === '--' ? 0 : row["PUT賣出"];
                        return "<a data-toggle='modal' href='#modal-info' onclick='SendPriceToModals(" + data + "," + bcPrice + "," + scPrice + "," + bpPrice + "," + spPrice + ");'>" + data + "</a>";
                    },
                    "targets": 7
                }
                    ],
                    columns: [{
                        "title": "CALL買進",
                        "data": "CALL買進"
                    }, {
                        "title": "CALL賣出",
                        "data": "CALL賣出"
                    }, {
                        "title": "CALL成交",
                        "data": "CALL成交"
                    }, {
                        "title": "CALL漲跌",
                        "data": "CALL漲跌"
                    }, {
                        "title": "CALL未平倉",
                        "data": "CALL未平倉"
                    }, {
                        "title": "CALL總量",
                        "data": "CALL總量"
                    }, {
                        "title": "CALL時間",
                        "data": "CALL時間"
                    }, {
                        "title": "履約價",
                        "data": "履約價"
                    }, {
                        "title": "PUT買進",
                        "data": "PUT買進"
                    }, {
                        "title": "PUT賣出",
                        "data": "PUT賣出"
                    }, {
                        "title": "PUT成交",
                        "data": "PUT成交"
                    }, {
                        "title": "PUT漲跌",
                        "data": "PUT漲跌"
                    }, {
                        "title": "PUT未平倉",
                        "data": "PUT未平倉"
                    }, {
                        "title": "PUT總量",
                        "data": "PUT總量"
                    }, {
                        "title": "PUT時間",
                        "data": "PUT時間"
                    }]
                });
                SearchOptPriceDiff(taioptData[optkey]);
                //find object in list
                var result = $.map(taioptData[optkey], function (item, index) {
                    return item.CALL成交
                });
                var foundIndex = closestIndex(30, result);
                //var foundIndex = result.findIndex(function (element) {
                //    if (element >= 30 && element<=50)
                //        return element;
                //});
                //CALL
                $('#weapon1Call').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].CALL成交);
                var foundIndex = closestIndex(70, result);
                $('#weapon2Call').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].CALL成交);
                $('#weapon3Call').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_2_" + taioptData[optkey][foundIndex].CALL成交);
                var foundIndex = closestIndex(110, result);
                $('#weapon4Call').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].CALL成交);
                //PUT
                result = $.map(taioptData[optkey], function (item, index) {
                    return item.PUT成交
                });
                foundIndex = closestIndex(30, result);
                $('#weapon1Put').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].PUT成交);
                var foundIndex = closestIndex(70, result);
                $('#weapon2Put').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].PUT成交);
                $('#weapon3Put').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_2_" + taioptData[optkey][foundIndex].PUT成交);
                var foundIndex = closestIndex(110, result);
                $('#weapon4Put').val(optkey + "_" + taioptData[optkey][foundIndex].履約價 + "_1_" + taioptData[optkey][foundIndex].PUT成交);
            }
        }));
    deferreds.push(
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/GetVixInfo",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    vixData = JSON.parse(data.d);
                }
                else {
                    vixData = JSON.parse(data);
                }
                $('#vix_table').DataTable({
                    data: vixData,
                    destroy: true,
                    searching: false,
                    "lengthChange": false,
                    paging: false,
                    "bSort": false,
                    columns: [{
                        "title": "商品",
                        "data": "商品"
                    }, {
                        "title": "目前指數",
                        "data": "目前指數"
                    }, {
                        "title": "開盤",
                        "data": "開盤"
                    }, {
                        "title": "最高",
                        "data": "最高"
                    }, {
                        "title": "最低",
                        "data": "最低"
                    }, {
                        "title": "昨收",
                        "data": "昨收"
                    }, {
                        "title": "時間",
                        "data": "時間"                    
                    }]
                });                
            }
        }));
    
    $.when.apply($, deferreds).then(function () {
        getTrade();
        /*停用阿Q
        $('#weapon5').val($('#contractMonth').val() + "_小台_1_" + $('#realtimeTaifex').val());
        renewPlan();
        var taifex = parseInt($('#realtimeTaifex').val());
        var cbBuyPoint1 = parseInt($('#cbBuyPoint1').val());
        var msg="";
        if (taifex < parseInt($('#cbBuyPoint5').val())) {
            msg = "5_BUY_CALL_TXO_" + $('#weapon5').val();
        }
        else if (taifex < parseInt($('#cbBuyPoint4').val())) {
            msg = "4_BUY_CALL_TXO_" + $('#weapon4Call').val();
        }
        else if (taifex < parseInt($('#cbBuyPoint3').val())) {
            msg = "3_BUY_CALL_TXO_" + $('#weapon3Call').val();
        }
        else if (taifex < parseInt($('#cbBuyPoint2').val())) {
            msg = "2_BUY_CALL_TXO_" + $('#weapon2Call').val();
        }
        else if (taifex < parseInt($('#cbBuyPoint1').val())) {
            msg = "1_BUY_CALL_TXO_" + $('#weapon1Call').val();
        }
        else if (taifex > parseInt($('#cbSellPoint5').val())) {
            msg = "5_BUY_PUT_TXO_" + $('#weapon5').val();
        }
        else if (taifex > parseInt($('#cbSellPoint4').val())) {
            msg = "4_BUY_PUT_TXO_" + $('#weapon4Put').val();
        }
        else if (taifex > parseInt($('#cbSellPoint3').val())) {
            msg = "3_BUY_PUT_TXO_" + $('#weapon3Put').val();
        }
        else if (taifex > parseInt($('#cbSellPoint2').val())) {
            msg = "2_BUY_PUT_TXO" + $('#weapon2Put').val();
        }
        else if (taifex > parseInt($('#cbSellPoint1').val())) {
            msg = "1_BUY_PUT_TXO_" + $('#weapon1Put').val();
        }
        if (msg != "") {
            var tradeData, result;
            //check trade
            $.ajax({
                type: "POST",
                url: "../WebService.asmx/CheckTrade",
                contentType: "application/json; charset=utf-8",
                async: true,
                cache: false,
                dataType: 'json',
                data: JSON.stringify({ tradeString: msg }),
                success: function (data) {
                    if (data.hasOwnProperty("d")) {
                        if (data.d != "")
                            tradeData = JSON.parse(data.d);
                    }
                    else {
                        if (data != "")
                            tradeData = JSON.parse(data);
                    }
                    if (tradeData != null) {
                        if (tradeData.length == 0)//沒有庫存
                        {
                            $.ajax({
                                type: "POST",
                                url: "../WebService.asmx/TradeSaveDB",
                                contentType: "application/json; charset=utf-8",
                                async: true,
                                cache: false,
                                dataType: 'json',
                                data: JSON.stringify({ tradeString: msg }),
                                success: function (data) {
                                    if (data.hasOwnProperty("d")) {
                                        result = JSON.parse(data.d);
                                    }
                                    else {
                                        result = JSON.parse(data);
                                    }
                                    if (result.result == "success") {
                                        //alert(msg);
                                        SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
                                    }
                                }
                            });
                        }
                    }
                }
            });
            
        }*/
        
        deferred.resolve();
    });
}

// global hook - unblock UI when ajax request completes
$(document).ajaxStop($.unblockUI);

function getStockPrice() {
    var dt = new Date();
    if (dt.getDay() == 0 || dt.getDay() == 6 || dt.getHours() < 9 || dt.getHours() > 14)
        return;
    var deferred = $.Deferred();
    var deferreds = [];    
    var stockData = [];
    var trackStock=["t00","0050","2330","2317","3008","2327","2353","2409","3481","2888"]
    trackStock.forEach(function (element) {
        deferreds.push(
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/GetStockData",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '{"stockID":"' + element + '"}',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    result = JSON.parse(data.d);
                }
                else {
                    result = JSON.parse(data);
                }
                stockData.push(result["msgArray"][0]);
            }
        }));
    });
    $.when.apply($, deferreds).then(function () {
        $('#stock_table').DataTable({
            data: stockData,
            destroy: true,
            searching: false,
            "lengthChange": true,
            paging: false,            
            "order": [[ 0, "asc" ]],
            "columnDefs": [
                {
                    // The `data` parameter refers to the data for the cell (defined by the
                    // `data` option, which defaults to the column being worked with, in
                    // this case `data: 0`.
                    "render": function (data, type, row) {
                        var upDown = Math.round(((row["z"] - row["o"]) / row["o"])*10000)/100+'%';
                        return upDown;
                    },
                    "targets": 3
                }, {
                    // The `data` parameter refers to the data for the cell (defined by the
                    // `data` option, which defaults to the column being worked with, in
                    // this case `data: 0`.
                    "render": function (data, type, row) {
                        if (row["c"] == 't00') {
                            return row["v"] / 100+'億';
                        }
                        else
                            return row["v"];
                    },
                    "targets": 4
                }],
            columns: [{
                "title": "代號",
                "data": "c"
            }, {
                "title": "簡稱",
                "data": "n"
            }, {
                "title": "成交價",
                "data": "z"
            }, {
                "title": "漲跌"                
            }, {
                "title": "成交量",
                "data": "v"
            }, {
                "title": "開盤",
                "data": "o"
            }, {
                "title": "最高",
                "data": "h"
            }, {
                "title": "最低",
                "data": "l"
            }, {
                "title": "成交時刻",
                "data": "t"
            }]
        });
    });
}
function getTrade() {
    var tradeData = [];
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/GetTrade",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                tradeData = JSON.parse(data.d);
            }
            else {
                tradeData = JSON.parse(data);
            }
            //trackData.push(result);
            $('#trade_table').DataTable({
                data: tradeData,
                destroy: true,
                searching: false,
                "lengthChange": false,
                paging: false,
                "bSort": false,
                "columnDefs": [
                {
                    // The `data` parameter refers to the data for the cell (defined by the
                    // `data` option, which defaults to the column being worked with, in
                    // this case `data: 0`.
                    "render": function (data, type, row) {
                        //var upDown = Math.round(((row["z"] - row["o"]) / row["o"]) * 10000) / 100 + '%';
                        return 5;
                    },
                    "targets": 8
                }],
                columns: [{
                    "title": "商品",
                    "data": "product"
                }, {
                    "title": "買賣",
                    "data": "buy_sell"
                }, {
                    "title": "單/複式",
                    "data": "product_part"
                }, {
                    "title": "call/put",
                    "data": "call_put"
                }, {
                    "title": "年月",
                    "data": "year_month"
                }, {
                    "title": "履約價",
                    "data": "contract_value"
                }, {
                    "title": "成交價",
                    "data": "real_price"
                }, {
                    "title": "數量",
                    "data": "volum"
                }, {
                    "title": "當前價"
                }, {
                    "title": "目標價",
                    "data": "looking_price"
                }, {
                    "title": "自動平倉",
                    "data": "auto_cover"
                }]
            });
        }
    });
}

function getTrack() {
    var trackData=[];
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/GetTrack",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                trackData = JSON.parse(data.d);
            }
            else {
                trackData = JSON.parse(data);
            }
            //trackData.push(result);
            $('#track_table').DataTable({
                data: trackData,
                destroy: true,
                searching: false,
                "lengthChange": false,
                paging: false,
                "bSort": false,
                columns: [{
                    "title": "商品",
                    "data": "type"
                }, {
                    "title": "代號(履約價)",
                    "data": "strike"
                }, {
                    "title": "CALL/PUT",
                    "data": "cp"
                }, {
                    "title": "月份",
                    "data": "mth"
                }, {
                    "title": "提醒價格",
                    "data": "price"
                }]
            });
        }
    });
}
function SearchOptPriceDiff(taioptData) {
    
    var i=0;
    for (i = 1; i < taioptData.length - 1; i++) {
        var bcQuote = taioptData[i].CALL買進;
        var scQuote1 = taioptData[i - 1].CALL賣出;
        var scQuote2 = taioptData[i + 1].CALL賣出;
        //alert(taioptData[i].履約價 + ":" + (bcQuote * 2 - scQuote1 - scQuote2));
        if (bcQuote * 2 - scQuote1 - scQuote2>5)
        {
            //alert(taioptData[i].履約價 + "CALL有價差");
            var msg = $('#contractMonth').val() +'_'+ taioptData[i].履約價 + "_CALL有上下價差"
            SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
        }
        var bpQuote = taioptData[i].PUT買進;
        var spQuote1 = taioptData[i - 1].PUT賣出;
        var spQuote2 = taioptData[i + 1].PUT賣出;
        //alert(taioptData[i].履約價 + ":" + (bcQuote * 2 - scQuote1 - scQuote2));
        if (bpQuote * 2 - spQuote1 - spQuote2 > 5) {
            //alert(taioptData[i].履約價 + "PUT有價差");
            var msg = $('#contractMonth').val() + '_' + taioptData[i].履約價 + "_PUT有上下價差"
            SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
        }
    }
}
function GetSetting() {
    $.blockUI();
    
}

function SendEmail(addrFrom,addrTo,bodyMsg) {    
    var returnData;
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/SendEmail",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: JSON.stringify({ strEmailAddrFrom: addrFrom, strEmailAddrTo: addrTo, intTotalEmailTo: addrTo.length, bodyMsg: bodyMsg }),
        success: function (data) {
            
        }
    });
}
function renewPlan()
{
    $('#cbWeapon1').val($('#weapon1Call').val());
    $('#cbWeapon2').val($('#weapon2Call').val());
    $('#cbWeapon3').val($('#weapon3Call').val());
    $('#cbWeapon4').val($('#weapon4Call').val());
    $('#cbWeapon5').val($('#weapon5').val());
    $('#cbDownRange1').val($('#downRange').val() * 1);
    $('#cbDownRange2').val($('#downRange').val() * 2);
    $('#cbDownRange3').val($('#downRange').val() * 3);
    $('#cbDownRange4').val($('#downRange').val() * 4);
    $('#cbDownRange5').val($('#downRange').val() * 5);
    $('#cbBuyPoint1').val($('#lastClosePrice').val() - $('#cbDownRange1').val());
    $('#cbBuyPoint2').val($('#lastClosePrice').val() - $('#cbDownRange2').val());
    $('#cbBuyPoint3').val($('#lastClosePrice').val() - $('#cbDownRange3').val());
    $('#cbBuyPoint4').val($('#lastClosePrice').val() - $('#cbDownRange4').val());
    $('#cbBuyPoint5').val($('#lastClosePrice').val() - $('#cbDownRange5').val());
    $('#cbUpRange1').val($('#upRange').val() * 1);
    $('#cbUpRange2').val($('#upRange').val() * 2);
    $('#cbUpRange3').val($('#upRange').val() * 3);
    $('#cbUpRange4').val($('#upRange').val() * 4);
    $('#cbUpRange5').val($('#upRange').val() * 5);
    $('#cbSellPoint1').val(parseInt($('#lastClosePrice').val()) + parseInt($('#cbUpRange1').val()));
    $('#cbSellPoint2').val(parseInt($('#lastClosePrice').val()) + parseInt($('#cbUpRange2').val()));
    $('#cbSellPoint3').val(parseInt($('#lastClosePrice').val()) + parseInt($('#cbUpRange3').val()));
    $('#cbSellPoint4').val(parseInt($('#lastClosePrice').val()) + parseInt($('#cbUpRange4').val()));
    $('#cbSellPoint5').val(parseInt($('#lastClosePrice').val()) + parseInt($('#cbUpRange5').val()));
    $('#pbWeapon1').val($('#weapon1Put').val());
    $('#pbWeapon2').val($('#weapon2Put').val());
    $('#pbWeapon3').val($('#weapon3Put').val());
    $('#pbWeapon4').val($('#weapon4Put').val());
    $('#pbWeapon5').val($('#weapon5').val());
}
function SendPriceToModals(value, bcPrice, scPrice, bpPrice, spPrice) {
    $('#actionValue').text(value);
    $('#actionBuyCallPrice').text(bcPrice);
    $('#actionSellCallPrice').text(scPrice);
    $('#actionBuyPutPrice').text(bpPrice);
    $('#actionSellPutPrice').text(spPrice);
}
function WriteBCValue() {
    $('#buyCallValue').val($('#actionValue').text());
    $('#buyCallPrice').val($('#actionSellCallPrice').text());
    CalculateProfit();
}
function WriteSCValue() {
    $('#sellCallValue').val($('#actionValue').text());
    $('#sellCallPrice').val($('#actionBuyCallPrice').text());
    CalculateProfit();
}
function WriteBPValue() {
    $('#buyPutValue').val($('#actionValue').text());
    $('#buyPutPrice').val($('#actionSellPutPrice').text());
    CalculateProfit();
}
function WriteSPValue() {
    $('#sellPutValue').val($('#actionValue').text());
    $('#sellPutPrice').val($('#actionBuyPutPrice').text());
    CalculateProfit();
}

function ReNewOpt() {
    var deferred = $.Deferred();
    $.blockUI();    
    var taioptData;    
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/GetTaiOptInfo",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '{"contractMonth":"' + $('#optContractMonth').val() + '"}',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                taioptData = JSON.parse(data.d);
            }
            else {
                taioptData = JSON.parse(data);
            }
            var optkey = Object.keys(taioptData);
            //$('#taiopt_title').text(optkey + '報價');
            optTableM = $('#taiopt_table').DataTable({
                data: taioptData[optkey],
                destroy: true,
                searching: true,
                order: [[7, "asc"]],
                "columnDefs": [
            {
                // The `data` parameter refers to the data for the cell (defined by the
                // `data` option, which defaults to the column being worked with, in
                // this case `data: 0`.
                "render": function (data, type, row) {
                    var bcPrice = row["CALL買進"] === '--' ? 0 : row["CALL買進"];
                    var scPrice = row["CALL賣出"] === '--' ? 0 : row["CALL賣出"];
                    var bpPrice = row["PUT買進"] === '--' ? 0 : row["PUT買進"];
                    var spPrice = row["PUT賣出"] === '--' ? 0 : row["PUT賣出"];
                    return "<a data-toggle='modal' href='#modal-info' onclick='SendPriceToModals(" + data + "," + bcPrice + "," + scPrice + "," + bpPrice + "," + spPrice + ");'>" + data + "</a>";
                },
                "targets": 7
            }
                ],
                columns: [{
                    "title": "CALL買進",
                    "data": "CALL買進"
                }, {
                    "title": "CALL賣出",
                    "data": "CALL賣出"
                }, {
                    "title": "CALL成交",
                    "data": "CALL成交"
                }, {
                    "title": "CALL漲跌",
                    "data": "CALL漲跌"
                }, {
                    "title": "CALL未平倉",
                    "data": "CALL未平倉"
                }, {
                    "title": "CALL總量",
                    "data": "CALL總量"
                }, {
                    "title": "CALL時間",
                    "data": "CALL時間"
                }, {
                    "title": "履約價",
                    "data": "履約價"
                }, {
                    "title": "PUT買進",
                    "data": "PUT買進"
                }, {
                    "title": "PUT賣出",
                    "data": "PUT賣出"
                }, {
                    "title": "PUT成交",
                    "data": "PUT成交"
                }, {
                    "title": "PUT漲跌",
                    "data": "PUT漲跌"
                }, {
                    "title": "PUT未平倉",
                    "data": "PUT未平倉"
                }, {
                    "title": "PUT總量",
                    "data": "PUT總量"
                }, {
                    "title": "PUT時間",
                    "data": "PUT時間"
                }]
            });
            deferred.resolve();            
        }
    });
    return deferred.promise();
}
function CalculateProfit() {
    var callDiff = Number($('#sellCallPrice').val()) - Number($('#buyCallPrice').val());
    var putDiff = Number($('#sellPutPrice').val()) - Number($('#buyPutPrice').val());
    var maxProfit = (Number($('#sellCallPrice').val()) + Number($('#sellPutPrice').val()) - Number($('#buyCallPrice').val()) - Number($('#buyPutPrice').val())).toFixed(1);
    var pointRange = parseInt($('#buyCallValue').val()) - parseInt($('#sellCallValue').val());
    var quantity = parseInt($('#quantity').val());
    var deposit = pointRange * 2 * 50;
    $('#callDiff').val(callDiff.toFixed(1));
    $('#putDiff').val(putDiff.toFixed(1));
    $('#profitValue').val(((maxProfit - 3) * quantity).toFixed(1) + "(" + (maxProfit - 3).toFixed(1) * quantity * 50 + ")");
    $('#lossValue').val((pointRange - maxProfit + 3) * quantity+ "(" + (pointRange - maxProfit + 3) * quantity * 50 + ")");
    $('#deposit').val(deposit * quantity);
}
function CalculateOpt() {
    $.when(ReNewOpt()).then(function () {
        var data = optTableM.rows().data();
        //find object in list
        var result = $.map(data, function (item, index) {
            return item.履約價
        });
        var buyCallValue = $('#buyCallValue').val();
        var sellCallValue = $('#sellCallValue').val();
        var buyPutValue = $('#buyPutValue').val();
        var sellPutValue = $('#sellPutValue').val();
        var foundIndex = closestIndex(sellCallValue, result);
        $('#sellCallPrice').val(data[foundIndex].CALL買進.replace('--', 0));
        foundIndex = closestIndex(buyCallValue, result);
        $('#buyCallPrice').val(data[foundIndex].CALL賣出.replace('--', 0));
        foundIndex = closestIndex(sellPutValue, result);
        $('#sellPutPrice').val(data[foundIndex].PUT買進.replace('--', 0));       
        foundIndex = closestIndex(buyPutValue, result);
        $('#buyPutPrice').val(data[foundIndex].PUT賣出.replace('--', 0));
        CalculateProfit();
    }); 
}
function CreateIcOpt(icRange,step) {
    var range = parseInt(icRange);
    var data = optTableM.rows().data();
    //find object in list
    var result = $.map(data, function (item, index) {
        return item.履約價
    });
    var closePrice;
    if (step == 50)
        closePrice = parseInt($('#lastWeekClosePrice').val());
    else
        closePrice = parseInt($('#lastClosePrice').val());
    var upTarget1 = closePrice + range;
    var foundIndex = closestIndex(upTarget1, result);
    $('#sellCallValue').val(data[foundIndex].履約價);
    $('#sellCallPrice').val(data[foundIndex].CALL買進.replace('--', 0));
    upTarget2 = closePrice + range + step;
    foundIndex = closestIndex(upTarget2, result);
    $('#buyCallValue').val(data[foundIndex].履約價);
    $('#buyCallPrice').val(data[foundIndex].CALL賣出.replace('--', 0));

    var downTarget1 = closePrice - range;
    foundIndex = closestIndex(downTarget1, result);
    $('#sellPutValue').val(data[foundIndex].履約價);
    $('#sellPutPrice').val(data[foundIndex].PUT買進.replace('--', 0));
    downTarget2 = closePrice - range - step;
    foundIndex = closestIndex(downTarget2, result);
    $('#buyPutValue').val(data[foundIndex].履約價);
    $('#buyPutPrice').val(data[foundIndex].PUT賣出.replace('--', 0));

    CalculateProfit();
}

function AssembTradeString(action)
{
    var varData = {};
    var tradeString='';
    var uuid = uuidv4();
    var month = $('#optContractMonth').val();
    var product = "TX";
    if (month.search("W") >= 0)
    {
        product = product + month.substr(7, 1);
        month = month.substr(0, 6)
    }
    else
    {
        product = product + "O";
    }
    if (action == 'BuyCall')
    {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"]="C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#buyCallPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "R";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉
    }
    else if (action == 'BuySellCall') {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#callDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "S";;////BS
        varData["ORDER_ARGS_MTH2"] = month;//交易月份
        varData["ORDER_ARGS_CP2"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#sellCallValue').val();
    }
    else if (action == 'SellCall')
    {
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#sellCallPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "R";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉
    }
    else if (action == 'BuyPut') {
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyPutValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#buyPutPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "R";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉
    }
    else if (action == 'SellPut') {
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellPutValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#sellPutPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "R";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉
    }
    else if (action == 'BuySellPut') {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyPutValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month;//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#putDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "S";;////BS
        varData["ORDER_ARGS_MTH2"] = month;//交易月份
        varData["ORDER_ARGS_CP2"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#sellPutValue').val();
    }
    //varData.forEach(function (value, index) { tradeString += value + "," });
    var jsonStr = JSON.stringify(varData);
    $('#tradeString').val(jsonStr);
}
function WriteTradeString() {    
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/WriteTradeString",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: "{'str':'" + $('#tradeString').val() + "'}",
        success: function () {
            alert('已送出');
        }
    });
}

function isBetweenValue(value1,value2) {
    return function (element, index, array) {
        return (element >= value1 && Element <= value2);
    }
}

function closest(num, arr) {
    var curr = arr[0];
    if (isNaN(curr)) curr = 0;
    var diff = Math.abs(num - curr);
    for (var val = 0; val < arr.length; val++) {
        var newdiff = Math.abs(num - arr[val]);
        if (newdiff < diff) {
            diff = newdiff;
            curr = arr[val];
        }
    }
    return curr;
}

function closestIndex(num, arr) {    
    var curr = arr[0];
    if (isNaN(curr)) curr = 0;
    var diff = Math.abs(num - curr);
    var index = 0;
    for (var val = 0; val < arr.length; val++) {
        var newdiff = Math.abs(num - arr[val]);
        if (newdiff < diff) {
            diff = newdiff;
            curr = arr[val];
            index = val;
        }
    }
    return index;
}

function uuidv4() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
        return v.toString(16);
    });
}

var roundDecimal = function (val, precision) {
    return Math.round(Math.round(val * Math.pow(10, (precision || 0) + 1)) / 10) / Math.pow(10, (precision || 0));
}