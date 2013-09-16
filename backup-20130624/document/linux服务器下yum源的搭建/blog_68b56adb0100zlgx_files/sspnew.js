(function (document, window) {
    var _ssp_ad = window._ssp_ad = {
        reqUrl: 'http://sax.sina.com.cn/impress',
        t: +new Date(),
        timeout: 5000,
        pdpslist: {},
        count: 0,
        getCount: function () {
            var rnd = Math.round(Math.random());
            if (_ssp_ad.getCookie("rotatecount")) {
                _ssp_ad.count = parseInt(_ssp_ad.getCookie("rotatecount"), 10) + 1;
            } else {
                _ssp_ad.count = rnd;
            }
            _ssp_ad.setCookie("rotatecount", _ssp_ad.count);
        },
        setCookie: function (key, value, expires) {
            var l = new Date();
            var z = new Date(l.getTime() + expires * 60000);
            document.cookie = key + "=" + escape(value) + ";path=/;expires=" + z.toGMTString() + ";domain=sina.com.cn";
        },
        getCookie: function (key) {
            var c = document.cookie.split("; ");
            for (var i = 0; i < c.length; i++) {
                var d = c[i].split("=");
                if (d[0] == key) {
                    return unescape(d[1]);
                }
            }
            return '';
        },
        _rmScr: function (scr) {
            if (scr && scr.parentNode) {
                scr.parentNode.removeChild(scr);
            }
            scr = null;
        },
        _creScr: function (scr, url, charset) {
            scr.setAttribute('type', 'text/javascript');
            charset && scr.setAttribute('charset', charset);
            scr.async = true;
            scr.setAttribute('src', url);
            var head = document.getElementsByTagName('head')[0];
            head.insertBefore(scr, head.childNodes[0]);
        },
        jsonp: function (url, opt_cb, opt_conf) {
            var scr = document.createElement('SCRIPT'),
                scrLoaded = 0,
                conf = opt_conf || {},
                cb = opt_cb ||
            function () {}, charset = conf['charset'] || 'utf-8', timeout = conf['timeout'] || 0, timer;
            if (scr.readyState) {
                scr.onreadystatechange = ready();
            } else {
                scr.onload = ready();
            }

            function ready() {
                return function () {
                    if (scrLoaded) {
                        return;
                    }
                    var readyState = scr.readyState;
                    if ('undefined' == typeof readyState || readyState == "loaded" || readyState == "complete") {
                        scrLoadeded = 1;
                        try {
                            cb();
                            clearTimeout(timer);
                        } finally {
                            scr.onerror = scr.onload = scr.onreadystatechange = null;
                            _ssp_ad._rmScr(scr);
                        }
                    }
                }
            };

            scr.onerror = function () {
                scr.onerror = scr.onload = scr.onreadystatechange = null;
                _ssp_ad._rmScr(scr);
                conf.onfailure && conf.onfailure();
                clearTimeout(timer);
            };

            if (timeout) {
                timer = setTimeout(function () {
                    scr.onerror = scr.onload = scr.onreadystatechange = null;
                    _ssp_ad._rmScr(scr);
                    conf.onfailure && conf.onfailure();
                }, timeout);
            }
            _ssp_ad._creScr(scr, url, charset);

        },
        callback: function (data) {
            if (typeof data == "object" && typeof data.ad == "object") {
                _ssp_ad.pdpslist[data.ad[0].id] = data;
            }
        },
        id2PDPS: function (id) {
            if (typeof id == "string") {
                return "PDPS0000000" + id.split("_")[1];
            } else {
                return id;
            }
        },
        isDZ: function (pdps) {
            return {
                'PDPS000000000000': 1
            }[pdps];
        },
        cookieMapping: function (mapping) {
            var map, i = 0,
                img;
            if (mapping instanceof Array && mapping.length > 0) {
                img = new Image();
                img.width = 1;
                img.height = 1;
                document.body.appendChild(img);
                while(map = mapping[i++]) {
                    img.src = map;
                }
                document.body.removeChild(img);
            }
        },
        dspCM: function (map) {
            var img = new Image();
            img.width = 1;
            img.height = 1;
            document.body.insertBefore(img, document.body.childNodes[0]);
            img.src = map;
            img.onload = function () {
                document.body.removeChild(img);
            }
        },
        showAE: function (src, el, w, h) {
            var rad = [];
            var nad = [];
            //eval(src);
            src = decodeURIComponent(src);
            (new Function('rad', 'nad', src))(rad, nad);
            if (rad.length > 0) {
                var formatSrc = rad[0][0];
                var formatUrl = rad[0][1];
            } else {
                var formatSrc = nad[0][0];
                var formatUrl = nad[0][1];
            }
            //el.innerHTML = formatSrc;
            var filetype = formatSrc.substring(formatSrc.length - 3).toLowerCase();
            switch(filetype) {
            case "swf":
                var of = new sinaFlash(formatSrc, el.id + '_swf', w, h, "7", "", false, "High");
                of.addParam("wmode", "opaque");
                of.addParam("allowScriptAccess", "always");
                of.write(el.id);
                if (formatUrl != "") {
                    of.addVariable("_did", formatUrl);
                }
                (function () {
                    var url = formatUrl;
                    if (url) {
                        var ell = document.createElement('a'),
                            flashEl = document.getElementById(el.id);
                        flashEl.style.position = "relative";
                        ell.setAttribute("href", url);
                        ell.setAttribute("target", "_blank");
                        ell.style.cssText += ";display:block;width:" + w + "px;height:" + h + "px;position:absolute;left:0px;top:0px;filter:alpha(opacity:0)";
                        if (ell.style.filter) {
                            ell.style.backgroundColor = "white";
                        }
                        flashEl.appendChild(ell);
                    }
                })();
                break;
            case "jpg":
            case "gif":
            case "png":
                el.innerHTML = '<a href="' + formatUrl + '" target="_blank"><img src="' + formatSrc + '" border="0" width="' + w + '" height="' + h + '"/></a>';
                break;
            case "htm":
            case "tml":
                el.innerHTML = '<iframe id="ifm_' + el.id + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="' + formatSrc + '"></iframe>';
                break;
            case ".js":
                break;
            default:

            }
        },
        showAMP: function (src, el, w, h) {
            src += (src.indexOf('?') > 0 ? '&' : '?') + 'i_ssp=1';
            el.innerHTML = '<iframe id="ifm_' + el.id + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="' + src + '"></iframe>';
        },

        showDSP: function (src, el, w, h) {
            el.innerHTML = src;
        },
        showNetwork: function (networkId, posId, el, w, h) {
            var src = "";
            switch(networkId) {
            case "1": // taobao
                src = '<iframe id="network_' + networkId + posId + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="http://d3.sina.com.cn/litong/zhitou/union/taobao.html?w=' + w + '&h=' + h + '&pid=' + posId + '"></iframe>'
                break;
            case "2": //google
                src = '<iframe id="network_' + networkId + posId + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="http://d3.sina.com.cn/litong/zhitou/union/google.html?w=' + w + '&h=' + h + '&pid=' + posId + '"></iframe>';
                break;
            case "3": //yihaodian
                src = '<iframe id="network_' + networkId + posId + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="http://d3.sina.com.cn/litong/zhitou/union/yihaodian.html?w=' + w + '&h=' + h + '&pid=' + posId + '"></iframe>'
                break;
            case "4": //baidu
                src = '<iframe id="network_' + networkId + posId + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="http://d3.sina.com.cn/litong/zhitou/union/baidu.html?pid=' + posId + '"></iframe>'
                break;
            default:
            }
            el.innerHTML = src;
        },
        failCB: function (pdps, el, adid, cb, w, h) {
            if (_ssp_ad.isDZ(pdps)) {
                var srcList = {
                    "950*90": "http://d1.sina.com.cn/litong/zhitou/gongyi/gongyi-banner.html",
                    "300*250": "http://d1.sina.com.cn/litong/zhitou/gongyi/gongyi-pip.html",
                    "250*230": "http://d1.sina.com.cn/litong/zhitou/gongyi/gongyi-square.html"
                };
                var src = srcList[w + "*" + h];
                el.innerHTML = '<iframe id="ifm_' + adid + '" frameborder="0" scrolling="no" width="' + w + '" height="' + h + '" src="' + src + '"></iframe>';
            } else {
                cb();
            }
        },
        domReady: function (d, f) {
            var ie = !! (window.attachEvent && !window.opera);
            var wk = /webkit\/(\d+)/i.test(navigator.userAgent) && (RegExp.$1 < 525);
            var fn = [];
            var run = function () {
                    for (var i = 0; i < fn.length; i++) fn[i]();
                };
            if (!ie && !wk && d.addEventListener) {
                return d.addEventListener('DOMContentLoaded', f, false);
            }
            if (fn.push(f) > 1) {
                return;
            }
            if (ie) {
                (function () {
                    try {
                        d.documentElement.doScroll('left');
                        run();
                    } catch(err) {
                        setTimeout(arguments.callee, 0);
                    }
                })();
            } else if (wk) {
                var t = setInterval(function () {
                    if (/^(loaded|complete)$/.test(d.readyState)) {
                        clearInterval(t), run();
                    }
                }, 0);
            }
        },
        loadIdentityIframe: function () {
            if (!document.getElementById("identityFrame")) {
                var frameUrl = "http://d1.sina.com.cn/litong/zhitou/identity.html";
                var ifr = document.createElement('iframe');
                ifr.width = 0;
                ifr.height = 0;
                ifr.frameBorder = 0;
                ifr.style.display = "none";
                ifr.src = frameUrl;
                ifr.id = "identityFrame";
                this.domReady(document, function () {
                    // _ssp_ad.dspCM("http://ads.ad.sina.com.cn/cm?sina_nid=4"); //mediaV
                    document.body.insertBefore(ifr, document.body.childNodes[0]);
                });
            }
        },
        referral: function () {
            var ref = "";
            try {
                ref = encodeURIComponent(window.top.location.href) || "";
            }catch(err) {
                ref = encodeURIComponent(document.referrer || window.location.href)
            }
            return ref;
        },
        load: function (adid, cb, w, h, rotateId) {
            var url = _ssp_ad.reqUrl,
                pdps = this.id2PDPS(adid);
            var el = document.getElementById(adid);
            if (pdps && el) {
                el.setAttribute('data-asp', 1);
                this.isDZ(pdps) && el.setAttribute('data-dz', 1);

                _ssp_ad.jsonp(
                url + (url.indexOf('?') >= 0 ? '&' : '?rotate_count=' + (isNaN(rotateId) ? 0 : (rotateId + 1)) + '&adunitid=' + this.id2PDPS(adid) + '&TIMESTAMP=' + _ssp_ad.t + '&referral=' + _ssp_ad.referral()), function () {
                    var _ssp_ads = _ssp_ad.pdpslist[pdps];
                    if (_ssp_ads && _ssp_ads.ad instanceof Array && _ssp_ads.ad.length > 0 && _ssp_ads.ad[0].value instanceof Array && _ssp_ads.ad[0].value.length > 0 && _ssp_ads.ad[0].value[0].content) {
                        w = _ssp_ads.ad[0].size.split("*")[0];
                        h = _ssp_ads.ad[0].size.split("*")[1];
                        var src = _ssp_ads.ad[0].value[0].content;
                        switch(_ssp_ads.ad[0].engineType) {
                        case "sina":
                            if (_ssp_ads.ad[0].value[0].manageType === 'AE') {
                                _ssp_ad.showAE(src, el, w, h);
                            } else {
                                _ssp_ad.showAMP(src, el, w, h);
                            }
                            break;
                        case "dsp":
                            _ssp_ad.showDSP(src, el, w, h);
                            break;
                        case "network":
                            var networkId = _ssp_ads.ad[0].value[0].manageType;
                            _ssp_ad.showNetwork(networkId, src, el, w, h);
                            break;
                        default:
                            cb();
                        }
                        //_ssp_ad.cookieMapping(_ssp_ads.mapUrl);
                        //_ssp_ads = window["_ssp_ads"] = null;
                    } else {
                        _ssp_ad.failCB(pdps, el, adid, cb, w, h);
                    }
                    if(_ssp_ads && _ssp_ads.mapUrl instanceof Array && _ssp_ads.mapUrl.length > 0){
                        _ssp_ad.cookieMapping(_ssp_ads.mapUrl);
                    }
                    _ssp_ad.pdpslist[pdps] = false;
                }, {
                    timeout: _ssp_ad.timeout,
                    onfailure: function () {
                        _ssp_ad.failCB(pdps, el, adid, cb, w, h);
                    }
                });
            } else {
                cb();
            }
        },
        init: function (cb) {
            this.domReady(document, function () {
                var allDom = document.getElementsByTagName("*");
                for (var i = 0, il = allDom.length; i < il; i++) {
                    var pdps = allDom[i].getAttribute("pdps");
                    if (pdps) {
                        if (_ssp_ad.pdpslist[pdps] == undefined) {
                            _ssp_ad.pdpslist[pdps] = true;
                        }
                    }
                }
                for (var j in _ssp_ad.pdpslist) {
                    if (_ssp_ad.pdpslist[j]) {
                        var divid = "ad_" + j.substring(11, 16);
                        _ssp_ad.load(divid, cb);
                    }
                }
            });
        }
    };
})(document, window);
_ssp_ad.loadIdentityIframe();
_ssp_ad.getCount();



var Tracker = (function (win, doc, DEFAULT_CONFIG) {
    var util = {
        E : win.encodeURIComponent,
        ref : doc.referrer,
        loc : win.location,
        ifr : win.self != win.top ? 1 : 0,
        top : "",
        cookie : {
            getRaw : function (key) {
                var reg = new RegExp("(^| )" + key + "=([^;]*)(;|\x24)"),
                    result = reg.exec(document.cookie);
                     
                if (result) {
                    return result[2] || null;
                }
            },
            get : function (key) {
                var value = util.cookie.getRaw(key);
                if ('string' == typeof value) {
                    value = decodeURIComponent(value);
                    return value;
                }
                return null;
            }
        },
        ie : /msie (\d+\.\d)/i.test(navigator.userAgent),

        rnd : function () {
            return Math.floor(Math.random() * 2147483648).toString(36);
        },

        rand : function (min, max) {
            return Math.floor(min + Math.random() * (max - min + 1));
        },

        uid : function () {
            var hash = 0,
                i = 0,
                w,
                s = util.loc.href;

            for(; !isNaN(w = s.charCodeAt(i++));) {
                hash = ((hash << 5) - hash) + w;
                hash = hash & hash;
            }

            return Math.abs(hash).toString(36);
        },
        attr : function (dom, attrName) {
            return dom.getAttribute ? dom.getAttribute(attrName) : null;
        },

        serialize : function (json) {
            var str = [];
            for (var key in json) {
                str.push(key + '=' + json[key]);
            }
            return str.join('&');
        },

        strProp2jsonProp : function (str) {
            var i = 0,
                result = {},
                prop;

            if (!str) return null;

            str = str.split(';');

            while (prop = str[i++]) {
                if (prop) {
                    prop = prop.split(':');
                    result[prop[0]] = prop[1];
                }
            }
            return result;
        },

        getPos : function (e) {
            var e = e || win.event;
            var targetX, targetY, offsetX, offsetY, scrollTop, scrollLeft;
            scrollTop = Math.max(doc.documentElement.scrollTop, doc.body.scrollTop);
            scrollLeft = Math.max(doc.documentElement.scrollLeft, doc.body.scrollLeft);
            if (util.ie) {
                targetX = e.clientX + scrollLeft;
                targetY = e.clientY + scrollTop;
            } else {
                targetX = e.pageX;
                targetY = e.pageY;
            }
            if (this.documentWidth) {
                var clientWidth = Math.max(doc.documentElement.clientWidth, doc.body.clientWidth);
                offsetX = (clientWidth - this.documentWidth) / 2;
                offsetY = 0;
            } else {
                offsetX = 0;
                offsetY = 0;
            }

            function getRelativePos(targetX, targetY) {
                return {
                    x : targetX - offsetX,
                    y : targetY - offsetY
                };
            }
            var pos = getRelativePos(targetX, targetY);
            targetX = Math.round(pos.x / 10) * 10;
            targetY = Math.round(pos.y / 10) * 10;
            return {
                x : targetX,
                y : targetY
            };
        },
        forEach : function (arr, iterator) {
            var i = 0, 
                item;
            if (arr) {
                while (item = arr[i++]) {
                    iterator && iterator(item, i);
                }
            }
        },
        inArray : function (arr, item) {
            var r = false;
            for (var len = arr.length - 1; len >=0; len--) {
                if (arr[len] === item) {
                    r = true;
                }
            }
            return r;
        },
        delegate : function (dom, type, callback, filter) {
            util.on(dom, type, function (e) {
                var target = e.realTarget;
                if ('function' === typeof filter) {
                    while (target && target !== dom) {
                        if (filter(target)) {
                            e.delegateTarget = target;
                            callback.call(this, e);
                        }
                        target = target.parentNode;
                    }
                } else {
                    callback.call(this, e);
                }
            });
        },

        on : function (dom, type, callback) {
            var handler = function (e) {
               e = e || window.event;
               e.realTarget = e.srcElement || e.target;
               e.relTarget = e.relatedTarget || e.toElement || e.fromElement || null;
               callback.call(dom, e);
            };

            if (dom.addEventListener) {
                dom.addEventListener(type, handler, false);
            } else if (dom.attachEvent) {
                dom.attachEvent('on' + type, handler);
            }
        },
        findTarget : function (from, to, filter) {
            while (from && from !== to) {
                if (filter(from)) {
                    return from;
                }
                from = from.parentNode;
            }
            if (filter(from)) {
                return from;
            }
            return null;
        }
    };


    function Tracker(bid, types, opt_conf) {
        var config = opt_conf || {},
            THIS = this,
            _obj;

        this.bid = bid;
        this.tag = config.tag || Tracker.DEFAULT_CONFIG.tag || 'sadt';
        this.url = config.url || Tracker.DEFAULT_CONFIG.url;
        this.exdata = config.exdata || Tracker.DEFAULT_CONFIG.exdata;

        this._cache = [];
        this._events = {};
        this._loadtime = +new Date();
        this._cookie = (function (keys) {
            var r = [];
            util.forEach(keys, function (key, i) {
                var value = util.cookie.get(key);
                if (value) {
                    r.push(key + '=' + value);
                }
            });
            return r.join(';');
        })(config.cookie || Tracker.DEFAULT_CONFIG.cookie || []);

        util.forEach(types, function (type, i) {
            if (type === 'load') {
                THIS.log(THIS.format({
                    _ev : 'load',
                    _t : THIS._loadtime,
                    _bid : THIS.bid
                }));
            }
            if (type === 'unload') {
                util.on(win, 'beforeunload', function () {
                    var now = +new Date();
                    THIS.log(THIS.format({
                        _dur    : now - THIS._loadtime,
                        _ev     : 'unload',
                        _t      : now,
                        _bid    : THIS.bid
                    }));
                });
            }
            if (Tracker.BIND_MAP[type]) {
                _obj = opt_conf[type] || Tracker.DEFAULT_CONFIG[type] || {};

                THIS._cache[type] = [];
                THIS._events[type] = {
                    max : _obj.max || 1,
                    filter : _obj.filter
                };

                util.delegate(
                    doc,
                    Tracker.BIND_MAP[type], 
                    THIS._getMonitorHandle(type),
                    THIS._getFilter(bid)
                );
            }
        });
        util.on(win, 'beforeunload', function () {
            for (var type in THIS._cache) {
                THIS.send(type, 0);
            }
        });
    }
    (function () {
        var top;
        try {
            top = win.top.location.href;
        } catch (e) {
            top = util.ref;
        }
        return top;
    })()

    Tracker.prototype = {
        _getMonitorHandle : function (type) {
            var THIS = this;
            return function (e) {
                var msg,
                    pos,
                    conf = THIS._events[type];
                    monitorTarget = conf.filter ? util.findTarget(e.realTarget, e.delegateTarget, conf.filter) : e.realTarget;

                e.monitorType = type;
                e.monitorTarget = monitorTarget;

                if (e.monitorTarget) {
                    msg = THIS.getMessage(e);
                    THIS._cache[type].push(THIS.format(msg));
                    THIS.send(type, conf.max)
                }
            };
        },
        _getFilter : function (name) {
            var THIS = this;
            return function (dom) {
                return util.attr(dom, THIS.tag) === name;
            };
        },
        format : util.serialize,
        getUrl: function () {
            var len,
                url = this.url;
            if ((url instanceof Array) && (len = url.length)) {
                return url[util.rand(0, len - 1)];
            } else if ('string' === typeof url) {
                return url;
            } else {
                throw new Error("url must string or array, and array must not empty.");
            }
        },

        getMessage : function (e) {
            var target = e.monitorTarget,
                type = e.monitorType,
                pos = util.getPos(e),
                exdata = this.exdata || {},
                msg = {
                    '_id' : target.id || 'noid' + util.rnd(), 
                    '_tagn' : target.tagName || 'notagname',   
                    '_x' : pos.x,                              
                    '_y' : pos.y,                             
                    '_t' : +new Date(),                       
                    '_ev' : type,                             
                    '_bid' : this.bid                  
                };

            (function (exdata, msg, target) {
                var i = 0,
                    list = exdata.glo || [],
                    tn = exdata.tagname || {},
                    k,
                    v;

                if (tn[target.tagName.toUpperCase()]) {
                    list = list.concat(tn[target.tagName.toUpperCase()]);
                }
                while (k = list[i++]) {
                    (v = util.attr(target, k)) && (msg[k] = util.E(v));
                }
            })(exdata, msg, target);

            return msg;
        },

        log : function (msg) {
            var img = new Image(1, 1),
                key = Tracker.UID + '_' + util.rnd(),
                info,
                url = this.getUrl();

            window[key] = img;
            img.onload = img.onerror = img.onabort = function () {
                img.onload = img.onerror = img.onabort = null;
                window[key] = null;
                img = null;
            };
            img.src = url
                + '?log=' + Tracker.UID
                + '&ifr=' + util.ifr
                + '&ref=' + util.E(util.ref)
                + '&top=' + util.E(util.top)
                + (Tracker.gloPar ? '&' + Tracker.gloPar : '')
                + '&t=' + (+new Date())
                + (this._cookie ? '&ck=' + util.E(this._cookie) : '')
                + '&msg=' + util.E(msg);
        },

        send : function (type, max) {
            var msgs = [],
                msg = '',
                tracks = this._cache[type];
            if (!max) {
                while (msg = tracks.shift()) {
                    msgs.push(msg);
                }
            } else if (tracks.length >= max) {
                while (max-- > 0 && (msg = tracks.shift())) {
                    msgs.push(msg);
                }
            }
            msgs.length > 0 && this.log(msgs.join('|'));
        }
    };

    Tracker.manager = {};

    Tracker.UID = util.uid();

    Tracker.BIND_MAP = {
        "click" : "click",
        "move" : "mousemove",
        "enter" : "mouseover",
        "leave" : "mouseout"
    };

    Tracker.DEFAULT_CONFIG = DEFAULT_CONFIG;

    return function (bid, types, opt_conf) {
        new Tracker(bid, types || Tracker.DEFAULT_CONFIG.types, opt_conf || {});
    };
})(window, document, {
    url: [
        "http://d00.sina.com.cn/a.gif",
        "http://d01.sina.com.cn/a.gif"
    ],
    types: ["click", "enter", "leave", "load", "unload"],
    exdata : {
        glo : ["remarks"],
        tagname : {
            "A" : ["href"]
        }
    },
    cookie: ["SINAGLOBAL"],
    tag: "digger",
    click : {
        max : 1,
        filter : function (dom) {
            return dom.getAttribute('clk') !== null;
        }
    },
    enter : {
        max : 5,
        filter : function (dom) {
            return dom.getAttribute('enter') !== null;
        }
    },
    leave : {
        max : 5,
        filter : function (dom) {
            return dom.getAttribute('leave') !== null;
        }
    }
});