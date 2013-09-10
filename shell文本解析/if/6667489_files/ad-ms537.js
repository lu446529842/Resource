//bbs 
var cloudad_type = 'ms537';
var cloudad_urls = [
'http://ad.csdn.net/adsrc/gaotong-bbs-homepage-760-90-0701.swf'
];
var cloudad_clks = [
'http://adclick-cn.imrworldwide.com/cgi-bin/b?ci=cn-gaotong2012click&cg=0&cc=1&si=gaotong/b2b/20130529/2/click&tu=http%3A//www.qualcomm.cn/snapdragon/customers%3Fsource%3Dcsdn%26type%3Dstandard_banner%26variation%3Ddesktop%26campaignid%3DCN0000160'
];

var can_swf = (function () {
    if (document.all) swf = new ActiveXObject('ShockwaveFlash.ShockwaveFlash');
    else if (navigator.plugins) swf = navigator.plugins["Shockwave Flash"];
    return !!swf;
})();

function cloudad_show() {
    var rd = Math.random();
    var ad_url, log_url;
    if (rd < 0.8 && can_swf) {
        ad_url = cloudad_urls[0];

        log_url = 'http://ad.csdn.net/log.ashx';
        log_url += '?t=view&adtype=' + cloudad_type + '&adurl=' + encodeURIComponent(ad_url);
        cloudad_doRequest(log_url, true);
    }
    if (rd < 0.004) {
        ad_url = cloudad_clks[0];

        log_url = 'http://ad.csdn.net/log.ashx';
        log_url += '?t=click&adtype=' + cloudad_type + '&adurl=' + encodeURIComponent(ad_url);
        cloudad_doRequest(log_url, true);
    }
}

function cloudad_doRequest(url, useFrm) {
    var e = document.createElement(useFrm ? "iframe" : "img");

    e.style.width = "1px";
    e.style.height = "1px";
    e.style.position = "absolute";
    e.style.visibility = "hidden";

    if (url.indexOf('?') > 0) url += '&r_m=';
    else url += '?r_m=';
    url += new Date().getMilliseconds();
    e.src = url;

    document.body.appendChild(e);
}

setTimeout(function () {
    cloudad_show();
}, 1000);
