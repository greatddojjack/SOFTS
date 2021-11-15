var table = $('#taifex_table').DataTable({
    columns: [{
        "title": "交易日期",
        "data": "trade_date"
    }, {
        "title": "契約",
        "data": "contract"
    }, {
        "title": "到期月份(週別)",
        "data": "end_date"
    }, {
        "title": "開盤價",
        "data": "open_price"
    }, {
        "title": "最高價",
        "data": "high_price"
    }, {
        "title": "最低價",
        "data": "low_price"
    }, {
        "title": "收盤價",
        "data": "close_price"
    }, {
        "title": "漲跌價",
        "data": "diff_price"
    }, {
        "title": "漲跌%",
        "data": "diff_percent"
    }, {
        "title": "成交量",
        "data": "volum"
    }, {
        "title": "結算價",
        "data": "contract_close_price"
    }, {
        "title": "未沖銷契約數",
        "data": "stay_volum"
    }
    ]
});
$("#fileinput").on("change", function (evt) {
    var f = evt.target.files[0];
    var importdata;
    if (f) {
        var r = new FileReader();
        r.onload = function (e) {
            importdata = $.csv.toObjects(e.target.result);
            //table.rows.add($.csv.toObjects(e.target.result)).draw();
            for (var item in importdata) {

                table.row.add(importdata[item]).draw();

                var myJSON = JSON.stringify(importdata[item]);
                
            }
        }
        r.readAsText(f);        
    } else {
        alert("Failed to load file");
    }
    
});

$("#save").on("click", function () {
    var obj = table.rows().data();
    var myJSON = JSON.stringify(obj);
    $.ajax({
        type: "POST",
        url: "/WebService.asmx/SaveTaifexToDataBase",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '{"tabledata":"' + myJSON + '"}',
        success: function (data) {
            alert("success");
        }
    });
    return false;
});

$(document).ready(function () {

});

// global hook - unblock UI when ajax request completes
$(document).ajaxStop($.unblockUI);