/*! Copyright 2012 Baidu Inc. All Rights Reserved. */
(function(){

	var createCFlash = function(swfurl, wad, had, clickurl, target, clickTAG, wmode){
		var now = (new Date()).getTime(),
		fid = "BAIDU_CLB_FLASH" + now,
		fname = "BAIDU_CLB_FLASH_N" + now;

        wmode = wmode ? 'opaque' : 'transparent';
        if (clickTAG === 'none') {
            clickTAG = '';
        }
		
		if(wad <=0 ){wad = '100%';}if(had <= 0){had = '100%';}
		return '<div style=\"font-size:0;position:relative;width:' + wad +'px;height:' + had + 'px;\">'
		+ (clickTAG ? '' : '<a style=\"position:absolute;top:0;left:0;bottom:0;right:0;display:block;width:100%;height:expression(this.parentNode.scrollHeight);filter:alpha(opacity=0);opacity:0;background:#FFF;\" href=\"'+ clickurl +'\" target=\"' + target + '\"></a>')
		+ '<object classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\" codebase=\"http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0\" id=\"' + fid + '\" width=\"' + wad + '\" height=\"' + had + '\" align=\"middle\">'
		+ '<param name=\"allowScriptAccess\" value=\"never\">'
		+ '<param name=\"quality\" value=\"high\">'
		+ '<param name="wmode" value="' + wmode + '">'
		+ '<param name=\"movie\" value=\"' + swfurl + '\">'
        + (clickTAG ? '<param name="flashvars" value="' + clickTAG + '=' + clickurl + '">' : '')
		+ '<embed ' + (clickTAG ? 'flashvars="' + clickTAG + '=' + clickurl + '" ' : '')
		+ 'wmode=\"' + wmode + '\" name=\"' + fname + '\" src=\"' + swfurl + '\" quality=\"high\" width=\"' + wad + '\" height=\"' + had + '\" align=\"middle\" allowScriptAccess=\"never\" type=\"application/x-shockwave-flash\" pluginspage=\"http://www.macromedia.com/go/getflashplayer\">'
		+ '</object>'
		+ '</div>';
		//document.write(str);
		//return str;
	};
	
	var chkFlash = function() {
        var n = navigator;
        if (n.plugins && n.mimeTypes.length) {
            var plugin = n.plugins["Shockwave Flash"];
            return !!plugin;
        }
        else if (window.ActiveXObject && !window.opera) {
            for (var i = 12; i >= 2; i--) {
                try {
                    var c = new ActiveXObject('ShockwaveFlash.ShockwaveFlash.' + i);
                    if (c) {
                        return true;
                    }
                }
                catch(ex) {
                }
            }
        }
        return false;
	}
	
	var createImg = function(w,h,clickurl,imgurl,target){
		var str = '<a href=\"' + clickurl + '\" target=\"' + target + '\"><img src=\"' + imgurl + '\" border=\"0\" ';
		if(w > 0){
			str += ' width=\"' + w + '\"';
		}
		if(h > 0){
			str += ' height=\"' + h + '\"';
		}
		return str + ' /></a>';
		//document.write(str);
		//return str;
	}
	var d = document.createElement("div");
	
    // 必须先进入到DOM中再设置innerHTML
    // 不然在某些小版本的IE6和IE8下flash会停留在第一帧
    // http://icafe.baidu.com:8100/jtrac/app/item/CBBS-133/
	document.body.appendChild(d);
    
    var flash = window['BD']['MC']['ADFlash'];
    var image = window['BD']['MC']['ADImg'];
	if( (chkFlash() == 0) && (image['flag'] == 1) ){
		d.innerHTML = createImg(image['w'],image['h'],image['cu'],image['mu'],image['tw']);
	}else{
		d.innerHTML = createCFlash(flash['mu'],flash['w'],flash['h'],flash['cu'],image['tw'],flash['ct'],flash['wm']);
	}
})();