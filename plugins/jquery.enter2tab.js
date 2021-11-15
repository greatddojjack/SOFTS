/*

* Copyright (c) 2007 Betha Sidik (bethasidik at gmail dot com)

* Licensed under the MIT License:

* http://www.opensource.org/licenses/mit-license.php

*

* This plugin developed based on jquery-numeric.js developed by Sam Collett (http://www.texotela.co.uk)

*/



/*

* Change the behaviour of enter key pressed in web based to be tab key

* So if this plugin used, a enter key will be a tab key

* User must explicitly give a tabindex in element such as text or select

* this version will assumed one form in a page

* applied to element text and select

*

*/



/*

* I modified the plugin to work for my need

* This will work even if the next tabindex is non-existent, or disabled so

* it will find the very next element on the tabindex series until the maximum tabindex

* which must be defined manually.

*

* ALL CREDITS GOES TO THE ORIGINAL AUTHOR

*/



jQuery.fn.enter2tab = function () {

    this.keypress(function (e) {

        // get key pressed (charCode from Mozilla/Firefox and Opera / keyCode in IE)

        var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0;



        var tmp = null;

        var maxTabIndex = 9999;



        // get tabindex from which element keypressed

        var nTabIndex = this.tabIndex + 1;



        // get element type (text or select)

        var myNode = this.nodeName.toLowerCase();



        // allow enter/return key (only when in an input box or select)

        if (nTabIndex > 0

            && key == 13

            && nTabIndex <= maxTabIndex

            && ((myNode == "textarea") || (myNode == "input") || (myNode == "select") || (myNode == "a"))) {

            for (var x = 0; x < 3; x++) {

                tmp = $("a[tabIndex='" + nTabIndex + "'],textarea[tabIndex='" + nTabIndex + "'],select[tabIndex='" + nTabIndex + "'],input[tabIndex='" + nTabIndex + "']").get(0);

                if (typeof tmp != "undefined" && !$(tmp).attr("disabled")) {

                    $(tmp).focus();

                    return false;

                    //break;

                }

                else {

                    //如果要循環的話，就解開以下的封印

                    //var first = $("a[tabIndex='1'],textarea[tabIndex='1'],select[tabIndex='1'],input[tabIndex='1']").get(0);

                    //$(first).focus();



                    return false;

                }

            }

            return false;

        }

        else if (key == 13) {

            return false;

        }

    })

    return this;

}