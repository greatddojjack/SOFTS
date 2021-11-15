var mailAddr;
var refreshQuoteTimer;
var refreshSecondTimer;
var optTable;
var taioptDataM = {};
var taioptDataW = {};
var tradeHighPrice = [];
var ATMPrice = [];
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
	return false;
});
$("#optContractMonth").on("change", function () {
    ReNewOpt();
});

$(document).ready(function () {
    "use strict";
    alert("如需自動下單，請輸入PassCode！");
    var settingData;
    var taioptContractMonth;
    var refreshInterval;
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
            refreshInterval = $('#refreshInterval').val() * 1000;
            $('#refreshSecond').text($('#refreshInterval').val());            
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
        data: JSON.stringify({ContractMonth: $("#contractMonth").val() }),
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                if (data.d != '')
                    taioptContractMonth = JSON.parse(data.d);
            }
            else {
                if (data != '')
                    taioptContractMonth = JSON.parse(data);
            }
            if (typeof taioptContractMonth["ContractMonth"] != 'undefined')
                taioptContractMonth["ContractMonth"].forEach(function (value, index) { $('#optContractMonth').append('<option value="' + value.ContractMonth + '">' + value.ContractMonth + '</option>'); });
            
        }
    }));
    $.when.apply($, deferreds).then(function () {
        $('#optContractMonth').val($('#contractMonth').val());
        //ReNewOpt();
        getTaiQuote();
        refreshQuoteTimer = window.setInterval(function () { getTaiQuote(); $('#refreshSecond').text($('#refreshInterval').val()); }, refreshInterval);
        refreshSecondTimer = window.setInterval(function () {
            $('#refreshSecond').text($('#refreshSecond').text() - 1);
        }, 1000);
    });
});

function getTaiQuote() {
    //$.blockUI();
    getStockPrice();    
    var deferred = $.Deferred();
    var deferreds = [];
    var taifexData;
    var vixData;
    //sync track and trade
    deferreds.push(
        $.ajax({
            type: "POST",
            url: "../WebService.asmx/SyncTrackAndTrade",
            contentType: "application/json; charset=utf-8",
            async: true,
            cache: false,
            dataType: 'json',
            data: '',
            success: function (data) {
                if (data.hasOwnProperty("d")) {
                    result = JSON.parse(data.d);
                }
                else {
                    result = JSON.parse(data);
                }
                //if (result.result > 0) {
                    //alert("儲存成功");
                    //SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
                //}
            }
        }));
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
                    if (data.d != "")
                        taifexData = JSON.parse(data.d);
                }
                else {
                    if (data != "")
                        taifexData = JSON.parse(data);
                }
                $('#taifex_table').DataTable({
                    data: taifexData,
                    destroy: true,
                    searching: false,
                    "scrollX": true,
                    "bSort": false,
                    autoWidth: false,
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
                if (typeof taifexData != 'undefined')
                    $('#p0_1').text(parseInt(taifexData[1].成交價.replace(",", "")));
            }
        }));
    //抓近月選
    var i = 0;
    ATMPrice = [];
    $("#optContractMonth option").each(function () {
        var ymw = $(this).val();        
        if (ymw.search("W") < 0  &&ymw !='履約年月') {
            i++;
            deferreds.push(
                $.ajax({
                    type: "POST",
                    url: "../WebService.asmx/" + $('#quoteSource').val(),//GetTaiOptInfoFromDDE
                    contentType: "application/json; charset=utf-8",
                    async: true,
                    cache: false,
                    dataType: 'json',
                    data: '{"contractMonth":"' + ymw + '"}',
                    success: function (data) {
                        if (data.hasOwnProperty("d")) {
                            if (data.d != "") {
                                var tmpData = JSON.parse(data.d);
                                taioptDataM[ymw] = tmpData[ymw];
                            }
                        }
                        else {
                            if (data != "") {
                                var tmpData = JSON.parse(data);
                                taioptDataM[ymw] = tmpData[ymw];
                            }
                        }
                        if (ymw == $('#optContractMonth').val()) {
                            if (typeof taioptDataM != 'undefined')
                                DrawOptTable(taioptDataM, $('#optContractMonth').val());
                        }
                        //find object in list
                        var result = $.map(taioptDataM[ymw], function (item, index) {
                            return item.履約價
                        });
                        //alert(parseInt($('#p0_1').text()));
                        var foundIndex = closestIndex(parseInt($('#p0_1').text()), result);
                        if (foundIndex >= 0)
                            ATMPrice.push([ymw, taioptDataM[ymw][foundIndex].CALL成交, taioptDataM[ymw][foundIndex].PUT成交]);

                    }
                }));
        }
    });
    //抓週選
    var hasWeek = 0;
    $("#optContractMonth option").each(function () {
        var ymw = $(this).val();
        if (ymw.search("W") >= 0) {
            hasWeek = 1;
        }
    });
    if (hasWeek == 1) {
        $("#optContractMonth option").each(function () {
            // Add $(this).val() to your list
            var ymw = $(this).val();
            if (ymw.search("W") >= 0) {
                deferreds.push(
                $.ajax({
                    type: "POST",
                    url: "../WebService.asmx/" + $('#quoteSource').val(),//GetTaiOptInfoFromDDE
                    contentType: "application/json; charset=utf-8",
                    async: true,
                    cache: false,
                    dataType: 'json',
                    data: '{"contractMonth":"' + ymw + '"}',
                    success: function (data) {
                        //taioptDataW[ymw] = {};
                        if (data.hasOwnProperty("d")) {
                            if (data.d != "") {
                                var tmpData = JSON.parse(data.d);
                                taioptDataW[ymw] = tmpData[ymw];
                            }
                        }
                        else {
                            if (data != "") {
                                var tmpData = JSON.parse(data);
                                taioptDataW[ymw] = tmpData[ymw];
                            }
                        }
                        if (ymw == $('#optContractMonth').val()) {
                            if (typeof taioptDataW != 'undefined')
                                DrawOptTable(taioptDataW, $('#optContractMonth').val());
                        }
                    }
                }));
            }
        });
    }
    
    //
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
                try {
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
                        paging: false,
                        "scrollX": true,
                        "bSort": false,
                        autoWidth: false,
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
                catch (e) {
                    
                }
            }
        }));

    $.when.apply($, deferreds).then(function () {
        cpoint = 0, ppoint = 0;
        getTrade();
        getTrack();
        getATM();
        //deferred.resolve();
    });
}

// global hook - unblock UI when ajax request completes
$(document).ajaxStart(function () {
    $.blockUI();
}).ajaxStop($.unblockUI);
//$(document).ajaxStop($.unblockUI);
$(document).ajaxError(function () {
    $.unblockUI();
    // Display error message here
    //alert('Some error message');
});
function DrawOptTable(taioptData,optkey)
{
    //var optkey = Object.keys(taioptData);
    //$('#taiopt_title').text(optkey + '報價');                
    optTable = $('#taiopt_table').DataTable({
        data: taioptData[optkey],
        destroy: true,
        searching: true,
        "scrollX": true,
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
function getStockPrice() {
    var dt = new Date();
    if (dt.getDay() == 0 || dt.getDay() == 6 || dt.getHours() < 9 || dt.getHours() > 14)
        return;
    var deferred = $.Deferred();
    var deferreds = [];    
    var stockData = [];
    var trackStock = ["t00", "0050", "2330"];
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
                    if (data.d != "") {
                        result = JSON.parse(data.d);
                        if (result["msgArray"].length > 0)
                            stockData.push(result["msgArray"][0]);
                    }
                }
                else {
                    if (data != "") {
                        result = JSON.parse(data);
                        if (result["msgArray"].length > 0)
                            stockData.push(result["msgArray"][0]);
                    }
                }
                
            }
        }));
    });
    $.when.apply($, deferreds).then(function () {
        $('#stock_table').DataTable({
            data: stockData,
            destroy: true,
            searching: false,            
            autoWidth: false,
            paging: false,
            "scrollX": true,
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
var cpoint = 0, ppoint = 0;
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
                paging: false,
                autoWidth: false,
                bSort: false,
                "scrollX": true,
                "columnDefs": [
                {
                    "render": function (data, type, row) {
                        var dealPrice = 0;
                        var dt = new Date();
                        if (type == "display") {
                            var yearMonth = row["year_month"].split(':');

                            if (row["product"].search("TX") >= 0) {
                                
                                var cp = row["call_put"].split(':');
                                var buySell = row["buy_sell"].split(':');
                                var contractValue = row["contract_value"].split(':');
                                var volum = row["volum"] - row["cover_volum"];
                                if (buySell.length > 1 && cp.length == 1) cp[1] = cp[0];
                                if (row["product"] == "TXO") {
                                    if (typeof taioptDataM != 'undefined') {
                                        dealPrice = checkOptDataPrice(taioptDataM[yearMonth[0]], buySell, contractValue, cp, 'COVER');
                                        if (yearMonth.length > 1) {
                                            if (buySell[0] == 'S' && buySell[1] == 'B')
                                                dealPrice = checkOptDataPrice(taioptDataM[yearMonth[1]], buySell, contractValue, cp, 'COVER') - dealPrice;
                                            else if (buySell[0] == 'B' && buySell[1] == 'S')
                                                dealPrice = dealPrice - checkOptDataPrice(taioptDataM[yearMonth[1]], buySell, contractValue, cp, 'COVER');
                                        }
                                        else
                                            yearMonth[1] = yearMonth[0];
                                    }
                                }
                                else {
                                    var yearMonthWeek = yearMonth[0] + 'W' + row["product"].substr(2, 1);
                                    if (typeof taioptDataW != 'undefined')
                                        dealPrice = checkOptDataPrice(taioptDataW[yearMonthWeek], buySell, contractValue, cp, 'COVER');
                                    if (yearMonth.length == 1) {
                                        yearMonth[1] = yearMonth[0];
                                    }

                                }
                                //alert(dt.getHours() + '-' + dt.getMinutes());
                                //非開盤時間不平倉
                                //if (dt.getDay() == 0) return dealPrice;
                                if ((dt.getHours() == 8 && dt.getMinutes() < 45) || (dt.getHours() >= 5 && dt.getHours() < 8)) return dealPrice;
                                if ((dt.getHours() == 13 && dt.getMinutes() > 45) || (dt.getHours() >= 14 && dt.getHours() < 15)) return dealPrice;
                                if ((buySell.length > 1 && buySell[0] == 'B' && buySell[1] == 'S') || (buySell.length == 1 && buySell[0] == 'S')) {
                                    //計算總點數
                                    if (cp[0] == "CALL") cpoint += volum * dealPrice;
                                    if (cp[0] == "PUT") ppoint += volum * dealPrice;
                                    if (dealPrice <= row["looking_price"] && dealPrice != 0) {
                                        //自動平倉
                                        if (dealPrice <= row["looking_price"] && typeof tradeHighPrice[row["trade_id"]] == 'undefined') {//賣方移動停利                                        
                                            tradeHighPrice[row["trade_id"]] = dealPrice;
                                        }
                                        else if (dealPrice < tradeHighPrice[row["trade_id"]]) {
                                            tradeHighPrice[row["trade_id"]] = dealPrice;
                                        }
                                        row["high_price"] = tradeHighPrice[row["trade_id"]];
                                        if (dealPrice >= (tradeHighPrice[row["trade_id"]] * 1.10) && typeof tradeHighPrice[row["trade_id"]] != 'undefined') {
                                            
                                            var tradeKey;
                                            if (row["auto_cover"] == true && volum > 0) {
                                                var msg = "自動平倉通知:\r\n" + row["product"] + "_" + row["year_month"] + "_" + buySell + "_" + cp + "_" + contractValue + "_成本" + row["real_price"] + "_目前成交價" + dealPrice + "_已到達目標價" + row["looking_price"] + "_平倉數量" + volum;
                                                //alert(msg);
                                                SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
                                                $('#quantity').val(volum);
                                                $('#tradeOpenClose').val("C");

                                                if (buySell.length > 1) {//複式單平倉
                                                    if (cp[0] == "CALL" && cp[1] == "CALL") {
                                                        $('#callDiff').val(dealPrice);
                                                        if (buySell[0] == 'B' && buySell[1] == 'S') {
                                                            $('#sellCallValue').val(contractValue[0]);
                                                            $('#buyCallValue').val(contractValue[1]);
                                                            tradeKey = AssembTradeString("SellBuyCall", yearMonth, row["product"], row["company"]);
                                                        }
                                                    }
                                                    else if (cp[0] == "PUT" && cp[1] == "PUT") {
                                                        if (buySell[0] == 'B' && buySell[1] == 'S') {
                                                            $('#putDiff').val(dealPrice);
                                                            $('#sellPutValue').val(contractValue[0]);
                                                            $('#buyPutValue').val(contractValue[1]);
                                                            tradeKey = AssembTradeString("SellBuyPut", yearMonth, row["product"], row["company"]);
                                                        }
                                                    }
                                                }
                                                else //單式單平倉
                                                {
                                                    if (cp[0] == "CALL") {
                                                        if (buySell[0] == 'S') {
                                                            $('#buyCallPrice').val(dealPrice);
                                                            $('#buyCallValue').val(contractValue[0]);
                                                            tradeKey = AssembTradeString("BuyCall", yearMonth, row["product"], row["company"]);
                                                        }
                                                    }
                                                    else if (cp[0] == "PUT") {
                                                        if (buySell[0] == 'S') {
                                                            $('#buyPutPrice').val(dealPrice);
                                                            $('#buyPutValue').val(contractValue[0]);
                                                            tradeKey = AssembTradeString("BuyPut", yearMonth, row["product"], row["company"]);
                                                        }
                                                    }
                                                }
                                                WriteTradeString('COVER', tradeKey, row["trade_id"]);
                                            }
                                        }
                                    }
                                }
                                else if ((buySell.length > 1 && (buySell[0] == 'S' || buySell[0] == 'B') && buySell[1] == 'B') || (buySell.length == 1 && buySell[0] == 'B')) {
                                    //計算總點數
                                    if (cp[0] == "CALL") cpoint -= volum * dealPrice;
                                    if (cp[0] == "PUT") ppoint -= volum * dealPrice;
                                    if (dealPrice >= row["looking_price"] && typeof tradeHighPrice[row["trade_id"]] == 'undefined') {//買方移動停利                                        
                                        tradeHighPrice[row["trade_id"]] = dealPrice;
                                    }
                                    else if (dealPrice > tradeHighPrice[row["trade_id"]]) {
                                        tradeHighPrice[row["trade_id"]] = dealPrice;
                                    }
                                    //紀錄最大點數
                                    if (dealPrice > row["high_price"]) {
                                        saveTradeHighPrice(row["trade_id"]);
                                        row["high_price"] = dealPrice;
                                        $("#highPrice_" + row["trade_id"]).val(dealPrice);
                                    }
                                    //row["high_price"] = tradeHighPrice[row["trade_id"]];
                                    if (dealPrice >= row["looking_price"] && dealPrice <= (tradeHighPrice[row["trade_id"]] * 0.90) && typeof tradeHighPrice[row["trade_id"]] != 'undefined') {
                                        //自動平倉
                                        var volum = row["volum"] - row["cover_volum"];
                                        var tradeKey;
                                        if (row["auto_cover"] == true && volum > 0) {
                                            var msg = "自動平倉通知:\r\n" + row["product"] + "_" + row["year_month"] + "_" + buySell + "_" + cp + "_" + contractValue + "_成本" + row["real_price"] + "_目前成交價" + dealPrice + "_已到達目標價" + row["looking_price"] + "_平倉數量" + volum;
                                            //alert(msg);
                                            SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
                                            $('#quantity').val(volum);
                                            $('#tradeOpenClose').val("C");

                                            if (buySell.length > 1) {//複式單平倉
                                                if (cp[0] == 'CALL' && cp[1] == 'CALL') {
                                                    if (buySell[0] == 'S' && buySell[1] == 'B') {
                                                        $('#callDiff').val(dealPrice);
                                                        $('#sellCallValue').val(contractValue[1]);
                                                        $('#buyCallValue').val(contractValue[0]);
                                                        tradeKey = AssembTradeString("BuySellCall", yearMonth, row["product"], row["company"]);
                                                    }
                                                }
                                                if (cp[0] == 'PUT' && cp[1] == 'PUT') {
                                                    if (buySell[0] == 'S' && buySell[1] == 'B') {
                                                        $('#putDiff').val(dealPrice);
                                                        $('#sellPutValue').val(contractValue[1]);
                                                        $('#buyPutValue').val(contractValue[0]);
                                                        tradeKey = AssembTradeString("BuySellPut", yearMonth, row["product"], row["company"]);
                                                    }
                                                }
                                                if (cp[0] == 'CALL' && cp[1] == 'PUT') {
                                                    if (buySell[0] == 'B' && buySell[1] == 'B') {
                                                        $('#callDiff').val(dealPrice);
                                                        $('#sellCallValue').val(contractValue[0]);
                                                        $('#sellPutValue').val(contractValue[1]);
                                                        tradeKey = AssembTradeString("SellCallSellPut", yearMonth, row["product"], row["company"]);
                                                    }
                                                }
                                            }
                                            else //單式單平倉
                                            {
                                                if (cp[0] == 'CALL') {
                                                    if (buySell[0] == 'B') {
                                                        $('#sellCallPrice').val(dealPrice);
                                                        $('#sellCallValue').val(contractValue[0]);
                                                        tradeKey = AssembTradeString("SellCall", yearMonth, row["product"], row["company"]);
                                                    }
                                                }
                                                if (cp[0] == 'PUT') {
                                                    if (buySell[0] == 'B') {
                                                        $('#sellPutPrice').val(dealPrice);
                                                        $('#sellPutValue').val(contractValue[0]);
                                                        tradeKey = AssembTradeString("SellPut", yearMonth, row["product"], row["company"]);
                                                    }
                                                }
                                            }
                                            WriteTradeString('COVER', tradeKey, row["trade_id"]);
                                        }
                                    }
                                }
                            }
                        }
                        return dealPrice;
                    },
                    "targets": 8
                },
               ],
                columns: [{
                    "title": "ID",
                    "data": "trade_id"
                }, {
                    "title": "商品",
                    "data": "product"
                }, {
                    "title": "買賣",
                    "data": "buy_sell"
                }, {
                    "title": "單/複式",
                    "data": "product_part", "visible": false
                }, {
                    "title": "cp",
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
                    "title": "當前價"
                }, {
                    "title": "目標價",
                    "data": "looking_price",
                    "render": lookingPriceRender
                }, {
                    "title": "數量",
                    "data": "volum",
                    "render": volumRender
                }, {
                    "title": "自動平倉",
                    "data": "auto_cover",
                    "render": autoCoverRender
                }, {
                    "title": "已平倉量",
                    "data": "cover_volum"
                }, {
                    "data": 'trade_id',
                    "visible": false
                }, {
                    "title": "最高價",
                    "data": 'high_price',
                    "render": highPriceRender
                }, {
                    "title": "備註",
                    "data": "desc"
                }, {
                    "title": "公司",
                    "data": "company"
                },
                {
                    "render": saveTradeConditionRender
                },
                {
                    "render":tradeRightNowRender
                }
                ]
            });
            $('#call_point').text(cpoint);
            $('#put_point').text(ppoint);
            //alert(cpoint + ";" + ppoint);
        }
    });
}
var autoCoverRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="autoCover_' + row.trade_id + '" type="checkbox" ' + (data ? 'checked' : '') + '>';
};
var highPriceRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="highPrice_' + row.trade_id + '" type="text" size="2" value="' + data + '">';
};
var volumRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="volum_' + row.trade_id + '" type="text" size="2" value="' + data + '">';
};
var lookingPriceRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="lookingPrice_' + row.trade_id + '" type="text" size="2" value="' + data + '">';
};
var saveTradeConditionRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="saveTrade_' + row.trade_id + '" type="button" size="2" value="儲存" onclick="saveTradeCondition(' + row.trade_id + ');">';
};
var tradeRightNowRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    var volum = parseInt(row.volum) - parseInt(row.cover_volum);
    return '<input id="tradeRightNow_' + row.trade_id + '" type="button" size="2" value="平倉" onclick="tradeRightNow(' + row.trade_id + ',\'' + row.product + '\',\'' + row.buy_sell + '\',\'' + row.call_put + '\',\'' + row.year_month + '\',\'' + row.contract_value + '\',' + row.looking_price + ',' + volum + ',\'' + row.company + '\');">';
};
function saveTradeCondition(trade_id)
{
    //alert($('#autoCover_' + trade_id).is(':checked'));
    
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/SaveTradeCondition",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: JSON.stringify({ trade_id: trade_id, auto_cover: $('#autoCover_' + trade_id).is(':checked'), volum: $("#volum_" + trade_id).val(), looking_price: $("#lookingPrice_" + trade_id).val()}),
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                result = JSON.parse(data.d);
            }
            else {
                result = JSON.parse(data);
            }
            if (result.result > 0) {
                alert("儲存成功");
                //SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
            }
        }
    });
}
function saveTradeHighPrice(trade_id) {
    //alert($('#autoCover_' + trade_id).is(':checked'));

    $.ajax({
        type: "POST",
        url: "../WebService.asmx/SaveHighPrice",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: JSON.stringify({ trade_id: trade_id, high_price: $("#highPrice_" + trade_id).val() }),
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                result = JSON.parse(data.d);
            }
            else {
                result = JSON.parse(data);
            }
            if (result.result > 0) {
                //alert("儲存成功");
                //SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
            }
        }
    });
}
function getATM() {
    if (ATMPrice.length > 0) {
        ATMPrice.sort(function (x, y) {
            return x[0] - y[0];
        });
        $('#p1_1').text(parseFloat(ATMPrice[0][1]) + parseFloat(ATMPrice[0][2]));
        $('#p2_1').text(parseFloat(ATMPrice[1][1]) + parseFloat(ATMPrice[1][2]));
        $('#p3_1').text(parseFloat(ATMPrice[0][1]) + parseFloat(ATMPrice[1][1]));
    }
}
function tradeRightNow(trade_id, product, buy_sell, call_put, year_month, contract_value, looking_price, volum,company) {
    var tradeKey;
    var yearMontn = [];
    yearMontn=year_month.split(':');
   
    $('#quantity').val(volum);
    $('#tradeOpenClose').val("C");
    if (call_put == 'CALL') {
        if (buy_sell == 'B') {
            $('#sellCallPrice').val(looking_price);
            $('#sellCallValue').val(contract_value);
            tradeKey = AssembTradeString("SellCall", yearMontn, product, company);
        }
        else if (buy_sell == 'S') {
            $('#buyCallPrice').val(looking_price);
            $('#buyCallValue').val(contract_value);
            tradeKey = AssembTradeString("BuyCall", yearMontn, product, company);
        }
    }
    else if(call_put == 'PUT')
    {
        if (buy_sell == 'B') {
            $('#sellPutPrice').val(looking_price);
            $('#sellPutValue').val(contract_value);
            tradeKey = AssembTradeString("SellPut", yearMontn, product, company);
        }
        else if (buy_sell == 'S') {
            $('#buyPutPrice').val(looking_price);
            $('#buyPutValue').val(contract_value);
            tradeKey = AssembTradeString("BuyPut", yearMontn, product, company);
        }
    }
    WriteTradeString('COVER', tradeKey, trade_id);
}
function checkOptDataPrice(taioptData, buySell, contractValue,cp,tradeType)
{
    var arrPrice = [];
    var data = taioptData;
    //find object in list
    var result = $.map(data, function (item, index) {
        return item.履約價;
    });
    //平倉互換Sell,Buy
    if (tradeType == 'COVER')
    {
        if (buySell.length > 1 && buySell[0] != buySell[1]) {
            buySell.reverse();
        }
        else {
            for (i = 0; i < buySell.length; i++) {
                if (buySell[i] == 'B') buySell[i] = 'S';
                else if (buySell[i] == 'S') buySell[i] = 'B';
            }
        }
    }
    
    for (i = 0; i < buySell.length; i++) {
        var foundIndex = closestIndex(contractValue[i], result);
        if (foundIndex > -1) {
            if (buySell[i] == "B" && cp[i] == "CALL") {
                arrPrice[i] = data[foundIndex].CALL賣出.replace('--', 0);
            }
            else if (buySell[i] == "S" && cp[i] == "CALL") {
                arrPrice[i] = data[foundIndex].CALL買進.replace('--', 0);
            }
            else if (buySell[i] == "B" && cp[i] == "PUT") {
                arrPrice[i] = data[foundIndex].PUT賣出.replace('--', 0);
            }
            else if (buySell[i] == "S" && cp[i] == "PUT") {
                arrPrice[i] = data[foundIndex].PUT買進.replace('--', 0);
            }
        }
    }
    //平倉互換Sell,Buy
    if (tradeType == 'COVER') {
        if (buySell.length > 1 && buySell[0] != buySell[1]) {
            buySell.reverse();
        }
        else {
            for (i = 0; i < buySell.length; i++) {
                if (buySell[i] == 'B') buySell[i] = 'S';
                else if (buySell[i] == 'S') buySell[i] = 'B';
            }
        }
    }
    if (buySell.length > 1) {
        if (buySell[0] == 'B' && buySell[1] == 'S')
            return Math.abs(roundDecimal(parseFloat(arrPrice[0]) - parseFloat(arrPrice[1]), 1));
        else if(buySell[0] == 'B' && buySell[1] == 'B')
            return Math.abs(roundDecimal(parseFloat(arrPrice[0]) + parseFloat(arrPrice[1]), 1));
        else 
            return parseFloat(arrPrice[1]);
    }
    else
        return parseFloat(arrPrice[0]);
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
                paging: false,
                autoWidth: false,
                bSort: false,
                "scrollX": true,
                "columnDefs": [
                {
                    "render": function (data, type, row) {
                        var dealPrice = 0;
                        var dt = new Date();
                        if (type == "display") {
                            var yearMonth = row["year_month"];
                            var cp = row["call_put"].split(':');

                            if (row["product"].search("TX") >= 0) {
                                var buySell = row["buy_sell"].split(':');
                                var contractValue = row["contract_value"].split(':');
                                if (row["product"] == "TXO") {
                                    if (typeof taioptDataM != 'undefined')
                                        dealPrice = checkOptDataPrice(taioptDataM[yearMonth], buySell, contractValue, cp, 'APPEND');
                                }
                                else {
                                    var yearMonthWeek = yearMonth + 'W' + row["product"].substr(2, 1);
                                    if (typeof taioptDataW != 'undefined')
                                        dealPrice = checkOptDataPrice(taioptDataW[yearMonthWeek], buySell, contractValue, cp, 'APPEND');

                                }
                                //alert(dt.getHours() + '-' + dt.getMinutes());
                                //非開盤時間不追蹤價格
                                if (dt.getDay() == 0) return dealPrice;
                                if ((dt.getHours() == 8 && dt.getMinutes() < 45) || (dt.getHours() >= 5 && dt.getHours() < 8)) return dealPrice;
                                if ((dt.getHours() == 13 && dt.getMinutes() > 45) || (dt.getHours() >= 14 && dt.getHours() < 15)) return dealPrice;
                                if (dealPrice >= row["price"] && dealPrice != 0) {
                                    //自動建倉
                                    var volum = row["volum"] - row["trade_volum"];
                                    var tradeKey;
                                    if (row["auto_trade"] == true && volum > 0) {
                                        var msg = "自動建倉通知:\r\n" + row["product"] + "_" + yearMonth + "_" + cp + "_" + contractValue + "_目前成交價" + dealPrice + "_已到達目標價" + row["price"] + "_下單數量" + volum;
                                        //alert(msg);
                                        SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
                                        $('#quantity').val(volum);
                                        $('#tradeOpenClose').val("O");
                                        if (cp.length == 2) {
                                            if (cp[0] == "CALL" && cp[1]=="CALL") {
                                                $('#callDiff').val(dealPrice);
                                                if (buySell[0] == 'B' && buySell[1] == 'S') {
                                                    $('#buyCallValue').val(contractValue[0]);
                                                    $('#sellCallValue').val(contractValue[1]);
                                                    tradeKey = AssembTradeString("BuySellCall", yearMonth, row["product"], row["company"]);
                                                }
                                            }
                                            else if (cp[0] == "PUT" && cp[1]=="PUT") {
                                                $('#putDiff').val(dealPrice);
                                                if (buySell[0] == 'B' && buySell[1] == 'S') {
                                                    $('#buyPutValue').val(contractValue[0]);
                                                    $('#sellPutValue').val(contractValue[1]);
                                                    tradeKey = AssembTradeString("BuySellPut", yearMonth, row["product"], row["company"]);
                                                }
                                            }
                                        }
                                        else
                                        {
                                            if (cp[0] == "CALL") {
                                                $('#sellCallPrice').val(dealPrice);
                                                if (buySell[0] == 'S') {
                                                    $('#sellCallValue').val(contractValue[0]);
                                                    tradeKey = AssembTradeString("SellCall", yearMonth, row["product"], row["company"]);
                                                }
                                            }
                                            else if (cp[0] == "PUT") {
                                                $('#sellPutPrice').val(dealPrice);
                                                if (buySell[0] == 'S') {
                                                    $('#sellPutValue').val(contractValue[0]);
                                                    tradeKey = AssembTradeString("SellPut", yearMonth, row["product"], row["company"]);
                                                }
                                            }
                                        }
                                        WriteTradeString('APPEND',tradeKey,row["track_id"]);
                                    }
                                }
                            }
                        }
                        return dealPrice;
                    },
                    "targets": 7
                }],
                columns: [{
                    "title": "ID",
                    "data": "track_id"
                }, {
                    "title": "商品",
                    "data": "product"
                }, {
                    "title": "買賣",
                    "data": "buy_sell"
                }, {
                    "title": "單/複式",
                    "data": "product_part",
                    "visible": false
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
                    "title": "當前價"
                }, {
                    "title": "目標價",
                    "data": "price",
                    "render": trackPriceRender
                }, {
                    "title": "數量",
                    "data": "volum",
                    "render": trackVolumRender
                }, {
                    "title": "自動下單",
                    "data": "auto_trade",
                    "render": autoTradeRender
                }, {
                    "title": "已下單量",
                    "data": "trade_volum"
                }, {                    
                    "data": "track_id",
                    "visible": false
                }, {
                    "title": "公司",
                    "data": "company"
                }, {
                    "render": saveTrackConditionRender
                }
                ]
            });
        }
    });
}
var autoTradeRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="autoTrade_' + row.track_id + '" type="checkbox" ' + (data ? 'checked' : '') + '>';
};
var trackVolumRender = function (data, type, row) {    
    return '<input id="trackVolum_' + row.track_id + '" type="text" size="2" value="' + data + '">';
};
var trackPriceRender = function (data, type, row) {
    return '<input id="trackPrice_' + row.track_id + '" type="text" size="2" value="' + data + '">';
};
var saveTrackConditionRender = function (data, type, row) {
    //return '<span row_id="' + row.id + '"><i class="fa fa-lg ' + (data ? 'fa-check-square-o' : 'fa-square-o') + '"></i></span>';
    return '<input id="saveTrack_' + row.track_id + '" type="button" size="2" value="儲存" onclick="saveTrackCondition(' + row.track_id + ');">';
};
function saveTrackCondition(track_id) {
    //alert($('#autoCover_' + trade_id).is(':checked'));

    $.ajax({
        type: "POST",
        url: "../WebService.asmx/SaveTrackCondition",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: JSON.stringify({ track_id: track_id, auto_trade: $('#autoTrade_' + track_id).is(':checked'), volum: $("#trackVolum_" + track_id).val(), price: $("#trackPrice_" + track_id).val() }),
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                result = JSON.parse(data.d);
            }
            else {
                result = JSON.parse(data);
            }
            if (result.result > 0) {
                alert("儲存成功");
                //SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
            }
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
            var msg = $('#contractMonth').val() + '_' + taioptData[i].履約價 + "_CALL有上下價差";
            SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
        }
        var bpQuote = taioptData[i].PUT買進;
        var spQuote1 = taioptData[i - 1].PUT賣出;
        var spQuote2 = taioptData[i + 1].PUT賣出;
        //alert(taioptData[i].履約價 + ":" + (bcQuote * 2 - scQuote1 - scQuote2));
        if (bpQuote * 2 - spQuote1 - spQuote2 > 5) {
            //alert(taioptData[i].履約價 + "PUT有價差");
            var msg = $('#contractMonth').val() + '_' + taioptData[i].履約價 + "_PUT有上下價差";
            SendEmail("peihsu.wang@seed.net.tw", mailAddr, msg);
        }
    }
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
    //$.blockUI();
    var taioptData;
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/"+$('#quoteSource').val(),//GetTaiOptInfoFromDDE
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '{"contractMonth":"' + $('#optContractMonth').val() + '"}',
        success: function (data) {
            if (data.hasOwnProperty("d")) {
                if (data.d != "")
                    taioptData = JSON.parse(data.d);
            }
            else {
                if (data != "")
                    taioptData = JSON.parse(data);
            }
            if (taioptData != null) {
                var optkey = Object.keys(taioptData);
                //$('#taiopt_title').text(optkey + '報價');
                optTable = $('#taiopt_table').DataTable({
                    data: taioptData[optkey],
                    destroy: true,
                    searching: true,
                    "scrollX": true,
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
        var data = optTable.rows().data();
        //find object in list
        var result = $.map(data, function (item, index) {
            return item.履約價;
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
    var data = optTable.rows().data();
    //find object in list
    var result = $.map(data, function (item, index) {
        return item.履約價;
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

function AssembTradeString(action,month,product,company)
{
    var varData = {};
    var tradeString='';
    var uuid = uuidv4();
    if (month == null) {
        month[0] = $('#optContractMonth').val();
    }
    if (product == null) {
        product = "TX";
        if (month[0].search("W") >= 0) {
            product = product + month[0].substr(7, 1);
            month[0] = month[0].substr(0, 6);
        }
        else {
            product = product + "O";
        }
    }
    //下單passcode
    varData["PASS_CODE"] = $('#passCode').val();
    if (company == null)
        varData["COMPANY"] = $('#tradeCompany').val();
    else
        varData["COMPANY"] = company;
    
    if (action == 'BuyCall')
    {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"]="C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#buyCallPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "R";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉
    }    
    else if (action == 'SellCall')
    {
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#sellCallPrice').val();        //'委託價格需乘上1000, 末三位是小數位數
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
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#callDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "S";;////BS
        varData["ORDER_ARGS_MTH2"] = month[1];//交易月份
        varData["ORDER_ARGS_CP2"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#sellCallValue').val();
    }
    else if (action == 'SellBuyCall') {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[1];//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#callDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "B";;////BS
        varData["ORDER_ARGS_MTH2"] = month[0];//交易月份
        varData["ORDER_ARGS_CP2"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#buyCallValue').val();
    }
    else if (action == 'BuyPut') {
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#buyPutValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
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
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
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
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
        varData["ORDER_ARGS_BS"] = "B";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#putDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "S";;////BS
        varData["ORDER_ARGS_MTH2"] = month[1];//交易月份
        varData["ORDER_ARGS_CP2"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#sellPutValue').val();
    }
    else if (action == 'SellBuyPut') {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellPutValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[1];//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#putDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "B";;////BS
        varData["ORDER_ARGS_MTH2"] = month[0];//交易月份
        varData["ORDER_ARGS_CP2"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#buyPutValue').val();
    }
    else if (action == 'SellCallSellPut') {
        //tradeString = "TXO,BUY,ROD,0," + $('#buyCallPrice').val() + "," + $('#quantity').val() + ",";
        varData["ORDER_ARGS_ID"] = product;//商品代號
        varData["ORDER_ARGS_CP"] = "C";//CAll/PUT
        varData["ORDER_ARGS_STRIKE"] = $('#sellCallValue').val();//履約價
        varData["ORDER_ARGS_MTH"] = month[0];//交易月份
        varData["ORDER_ARGS_BS"] = "S";//BuySell
        varData["ORDER_ARGS_PRICE_FLAG"] = "0";//限市價,市價=1,限價=0
        varData["ORDER_ARGS_ODPRICE"] = $('#callDiff').val();        //'委託價格需乘上1000, 末三位是小數位數
        varData["ORDER_ARGS_ODQTY"] = $('#quantity').val();
        varData["ORDER_ARGS_ODTYPE"] = "I";  //'ROD/IOC/FOK

        varData["ORDER_ARGS_ODKEY"] = uuid;  //'此筆下單的key, 每次下單必須有一個unique的key
        varData["ORDER_ARGS_OPENCLOSE"] = $('#tradeOpenClose').val(); //O=新倉,C=平倉

        varData["ORDER_ARGS_ID2"] = product;//商品代號
        varData["ORDER_ARGS_BS2"] = "S";;////BS
        if(month.length==1)
            varData["ORDER_ARGS_MTH2"] = month[0];//交易月份
        else
            varData["ORDER_ARGS_MTH2"] = month[1];//交易月份
        varData["ORDER_ARGS_CP2"] = "P";//CAll/PUT
        varData["ORDER_ARGS_STRIKE2"] = $('#sellPutValue').val();
    }
    //varData.forEach(function (value, index) { tradeString += value + "," });
    var jsonStr = JSON.stringify(varData);
    $('#tradeString').val(jsonStr);
    return uuid;
}
function WriteTradeString(action, tradeKey, actionID) {
    $.ajax({
        type: "POST",
        url: "../WebService.asmx/WriteTradeString",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: "{'str':'" + $('#tradeString').val() + "','action':'" + action + "','tradeKey':'" + tradeKey + "','actionID':'" + actionID + "'}",
        success: function () {
            //alert('已送出');
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
    var index = -1;
    for (var val = 0; val < arr.length; val++) {
        var newdiff = Math.abs(num - arr[val]);
        if (newdiff < diff) {
        //if(num==arr[val]) {
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