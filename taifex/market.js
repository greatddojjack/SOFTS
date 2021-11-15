$(document).ready(function () {
    calliframe('http://www.google.com.tw', 'stock_0050')
});

function calliframe(url, div) {
    var param = "";
    var ifr=document.createElement("iframe");//以下创建一个隐藏的iframe   
    ifr.setAttribute("width",0);   
    ifr.setAttribute("height",0);
    document.body.appendChild(ifr);
    ifr.src = encodeURI(url + param);
}