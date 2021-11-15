//Date range picker
$('#daterange').daterangepicker({
    locale: {
        format: 'YYYY/MM/DD'
    }
});
$("#start").on("click", function () {
    var uprange1 = $('#uprange1').val();
    var uprange2 = $('#uprange2').val();
    var uprangesize = $('#uprange_size').val();
    var downrange1 = $('#downrange1').val();
    var downrange2 = $('#downrange2').val();
    var downrangesize = $('#downrange_size').val();
    var stopmoneyrange1 = $('#stopmoneyrange1').val();
    var stopmoneyrange2 = $('#stopmoneyrange2').val();
    var stopmoneyrangesize = $('#stopmoneyrange_size').val();
    var stophurtrange1 = $('#stophurtrange1').val();
    var stophurtrange2 = $('#stophurtrange2').val();
    var stophurtrangesize = $('#stophurtrange_size').val();
    var daterange = $('#daterange').val();
    $.ajax({
        type: "POST",
        url: "/WebService.asmx/StartAQTest",
        contentType: "application/json; charset=utf-8",
        async: true,
        cache: false,
        dataType: 'json',
        data: '{"uprange1":"' + uprange1 + '","uprange2":"' + uprange2 + '","uprangesize":"' + uprangesize + '","downrange1":"' + downrange1 + '","downrange2":"' + downrange2 + '","downrangesize":"' + downrangesize + '","stopmoneyrange1":"' + stopmoneyrange1 + '","stopmoneyrange2":"' + stopmoneyrange2 + '","stopmoneyrangesize":"' + stopmoneyrangesize + '","stophurtrange1":"' + stophurtrange1 + '","stophurtrange2":"' + stophurtrange2 + '","stophurtrangesize":"' + stophurtrangesize + '","daterange":"' + daterange + '"}',
        success: function (data) {
            alert("success");
        }
    });
    return false;
});