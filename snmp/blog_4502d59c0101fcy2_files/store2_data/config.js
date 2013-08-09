/* 1,694,44 2013-06-21 15:29:28 */

//version 1.3.1 upgrade guess2 to 0.0.6
//version 1.3.0 add sina.test
//version 1.2.9 upgrade product.guess to 1.1.0
//version 1.2.8 upgrade product.guess to 1.0.9
//version 1.2.7 upgrade product.guess to 1.0.8
//version 1.2.6 upgrade product.guess to 1.0.7
//version 1.2.5 upgrade product.guess to 1.0.6
//version 1.2.4 upgrade product.guess to 1.0.5
//version 1.2.3 upgrade product.guess2 to 0.0.5
//version 1.2.2   upgrade product.guess to 1.0.4
//version 1.1.9 upgrade product.guess to 1.0.1
//version 1.1.8 add product.guess...
//version 1.1.7 upgrade sina.util to 1.0.5 (strWidth, staticJsonp), upgrade guess2 to 0.0.4(add staticJsonp)
//version 1.1.6 add product.guess2.GuessInfo
//version 1.1.5 upgrade sina.util to 1.0.4 (add arale.class, base, events...)
//version 1.1.4 upgrade sina.util(add util.ud5, ...)
//version 1.1.3 add sina.ScrollPic, sina.FocusPic, sina.SubShow, update sina.util(appendStyle...)
//version 1.1.2 upgrade guess2.collect to 0.0.3
//version 1.1.1 upgrade guess2.colllect to 0.0.2
//version 1.1.0 upgrade to udvDefine, and upgrade all that matters
//version 1.0.2 add product.guess2; product.guess2.collect;
//version 1.0.1

seajs.config({
    base: 'http://i2.sinaimg.cn/jslib/modules2/'
    ,alias: {
        //gallery
        'jquery': 'gallery/jquery/1.8.2/jquery'
        ,'$': 'gallery/jquery/1.8.2/jquery'
        ,'async': 'gallery/async/0.1.23/async'
        ,'backbone': 'gallery/backbone/0.9.2/backbone'
        ,'coffee': 'gallery/coffee/1.4.0/coffee-script'
        ,'cookie': 'gallery/cookie/1.0.2/cookie'
        ,'es5-safe': 'gallery/es5-safe/0.9.2/es5-safe'
        ,'handlebars': 'gallery/handlebars/1.0.0/handlebars'
        ,'iscroll': 'gallery/iscroll/4.2.5/iscroll'
        ,'jasmine-jquery': 'gallery/jasmine-jquery/1.4.2/jasmine-jquery'
        ,'jasmine': 'gallery/jasmine/1.2.0/jasmine'
        ,'jquery-color': 'gallery/jquery-color/2.1.0/jquery-color'
        ,'json': 'gallery/json/1.0.2/json'
        ,'keymaster': 'gallery/keymaster/1.0.2/keymaster'
        ,'labjs': 'gallery/labjs/2.0.3/lab'
        ,'less': 'gallery/less/1.3.1/less'
        ,'marked': 'gallery/marked/0.2.4/marked'
        ,'moment': 'gallery/moment/1.7.2/moment'
        ,'mustache': 'gallery/mustache/0.5.0/mustache'
        ,'querystring': 'gallery/querystring/1.0.2/querystring'
        ,'raphael': 'gallery/raphael/2.1.0/raphael'
        ,'socketio': 'gallery/socketio/0.9.6/socketio'
        ,'store': 'gallery/store/1.3.5/store'
        ,'swfobject': 'gallery/swfobject/2.2.0/swfobject'
        ,'underscore': 'gallery/underscore/1.4.2/underscore'
        ,'zepto': 'gallery/zepto/1.0.0/zepto'
        ,'ztree': 'gallery/ztree/3.4.1/ztree'

        //arale
        ,'arale.autocomplete': 'arale/autocomplete/0.9.0/autocomplete'
        ,'arale.base': 'arale/base/1.0.1/base'
        ,'arale.calendar': 'arale/calendar/0.8.0/calendar'
        ,'arale.class': 'arale/class/1.0.0/class'
        ,'arale.color': 'arale/color/1.0.0/color'
        ,'arale.cookie': 'arale/cookie/1.0.2/cookie'
        ,'arale.anim-dialog': 'arale/dialog/0.9.1/anim-dialog'
        ,'arale.base-dialog': 'arale/dialog/0.9.1/base-dialog'
        ,'arale.confirm-box': 'arale/dialog/0.9.1/confirm-box'
        ,'arale.easing': 'arale/easing/1.0.0/easing'
        ,'arale.events': 'arale/events/1.0.0/events'
        ,'arale.iframe-shim': 'arale/iframe-shim/1.0.0/iframe-shim'
        ,'arale.iframe-uploader': 'arale/iframe-uploader/0.9.1/iframe-uploader'
        ,'arale.messenger': 'arale/messenger/1.0.0/messenger'
        ,'arale.overlay': 'arale/overlay/0.9.13/overlay'
        ,'arale.mask': 'arale/overlay/0.9.13/mask'
        ,'arale.placeholder': 'arale/placeholder/1.0.0/placeholder'
        ,'arale.popup': 'arale/popup/0.9.9/popup'
        ,'arale.position': 'arale/position/1.0.0/position'
        ,'arale.select': 'arale/select/1.0.0/select'
        ,'arale.switchable': 'arale/switchable/0.9.11/switchable'
        ,'arale.accordion': 'arale/switchable/0.9.11/accordion'
        ,'arale.carousel': 'arale/switchable/0.9.11/carousel'
        ,'arale.slide': 'arale/switchable/0.9.11/slide'
        ,'arale.tabs': 'arale/switchable/0.9.11/tabs'
        ,'arale.tip': 'arale/tips/0.9.2/tip'
        ,'arale.atip': 'arale/tips/0.9.2/atip'
        ,'arale.validator': 'arale/validator/0.8.9/validator'
        ,'arale.widget': 'arale/widget/1.0.2/widget'

        //sina
        ,'sina.util': 'sina/util/1.0.5/util'
        ,'sina.flashData': 'sina/flashData/1.0.0/flashData'
        ,'sina.permanent': 'sina/permanent/1.0.0/permanent'
        ,'sina.FocusPic': 'sina/FocusPic/1.0.1/FocusPic'
        ,'sina.ScrollPic': 'sina/ScrollPic/1.0.0/ScrollPic'
        ,'sina.SubShow': 'sina/SubShow/1.0.0/SubShow'
        ,'sina.ImageSlide': 'sina/ImageSlide/1.0.0/ImageSlide'
        ,'sina.test': 'sina/test/1.0.1/test'

        //product
        ,'product.guess.arti': 'product/guess/1.1.0/arti'
        ,'product.guess.auto': 'product/guess/1.1.0/auto'
        ,'product.guess.blog': 'product/guess/1.1.0/blog'
        ,'product.guess.slide': 'product/guess/1.1.0/slide'
        ,'product.guess.video': 'product/guess/1.1.0/video'
            ,'product.guess.collect': 'product/guess/1.1.0/collect'
            ,'product.guess.GuessInfo': 'product/guess/1.1.0/GuessInfo'
            ,'product.guess.readMem': 'product/guess/1.1.0/readMem'
            ,'product.guess.readArray': 'product/guess/1.1.0/readArray'
            ,'product.guess.legacy.path': 'product/guess/1.1.0/legacy/legacy.path'

        ,'product.guess2': 'product/guess2/0.1.2/guess2'
        ,'product.guess2.collect': 'product/guess2/0.1.2/collect'
        ,'product.guess2.GuessInfo': 'product/guess2/0.1.2/GuessInfo'
    }
    ,charset: 'utf-8'
});
