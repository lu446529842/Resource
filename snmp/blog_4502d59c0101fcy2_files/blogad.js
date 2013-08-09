function BlogAd(cfg) {
	this.version = "0.3.3";
	this.date = "Sep. 5th, 2011";
	this.info = "Sina Media Strategy Center, yafeng2@staff. ";
	this.getAd = function(cb) {
		var res = new Object();
		var nowTime = new Date().getTime();
		var site = 'sina';
		var adPos = 'ads';
		var rIndex = "";
		var tagList = '';
		var keyList = '';
		var gender = '';
		var age = '';
		var income = '';
		var cat1 = '';
		var cat2 = '';
		var blogID = '';
		if (typeof cfg == 'object') {
			if (cfg.pos != null)
			 adPos = cfg.pos;
			if (cfg.rIndex != null)
			 rIndex = cfg.rIndex;
			if (cfg.tagList != null)
			 tagList = cfg.tagList;
			if (cfg.keyList != null)
			 keyList = cfg.keyList;
			if (cfg.gender != null)
			 gender = cfg.gender;
			if (cfg.age != null)
			 age = cfg.age;
			if (cfg.income != null)
			 income = cfg.income;
			if (cfg.cat1 != null)
			 cat1 = cfg.cat1;
			if (cfg.cat2 != null)
			 cat2 = cfg.cat2;
			if (cfg.blogID != null)
			 blogID = cfg.blogID;
		}		
		srcUrl = "http://blog.sina.com.cn/lm/iframe/js/blognew2011.js";
		if (typeof BLOG_AD == "object") {
			if (BLOG_AD[adPos] == null) {
				res.code = '2102';
				res.ads = {};
			} else {
				res.code = '0';
				var posads = BLOG_AD[adPos].ads;
				if (BLOG_AD[adPos].ad == 1 && typeof posads == "object") {
					startTime = 0;
					endTime = 0;
					if (BLOG_AD[adPos].rtt != null && BLOG_AD[adPos].rtt == 1) {
						var r = new RotatorAD(BLOG_AD[adPos]);
						if (r[0] != null ) {
							if (r[0].enddate != null && r[0].enddate.match(/:\d{2}$/) == null)
							 r[0].enddate += ' 23:59:59';
							if ((r[0].startdate != null && Date.parse(r[0].startdate.replace(/-/g, "/")) >= nowTime) || (r[0].enddate != null && Date.parse(r[0].enddate.replace(/-/g, "/")) <= nowTime)) {
								res.code = '2201';
							} else {
								if (r[0].warp != null && r[0].warp == 1) {
									if (r[0].ads != null) {
										r[0].ads.startdate = r[0].startdate;
										r[0].ads.enddate = r[0].enddate;
										r = r[0].ads;
									} else {
										res.code = '2205';
									}
								}
								if (r[0].type != 'mixed' && (r[0].ref == null || r[0].ref == '')) {
									res.code = '2203';
								} else {
									if (r[0].type == 'flv') {
										r[0].type = 'mixed';
										r[0].content = playerize(r[0]);
										r[0].ref = '';
									}
								}
							}
						} else {
							res.code = '2111';
						}
						posads = r;
					} else {
						var r = BLOG_AD[adPos].ads;
						if (r[0].enddate != null && r[0].enddate.match(/:\d{2}$/) == null)
						 r[0].enddate += ' 23:59:59';
						if ((r[0].startdate != null && Date.parse(r[0].startdate.replace(/-/g, "/")) >= nowTime) || (r[0].enddate != null && Date.parse(r[0].enddate.replace(/-/g, "/")) <= nowTime)) {
							res.code = '2201';
						}
					}
					res.ads = posads;
				} else {
					res.code = '2101';
					res.ads = {};
				}
			}
			cb(res);
		} else {
			var script = document.createElement("script");
			script.type = "text/javascript";
			script.charset = "gb2312";
			script.src = srcUrl;
			document.body.appendChild(script);
			script.onload = script.onreadystatechange = function() {
				if (this.readyState == null || this.readyState == "loaded" || this.readyState == "complete") {
					if (typeof BLOG_AD == "object") {
						if (BLOG_AD[adPos] == null) {
							res.code = '2102';
							res.ads = {};
						} else {
							res.code = '0';
							var posads = BLOG_AD[adPos].ads;
							if (BLOG_AD[adPos].ad == 1 && typeof posads == "object") {
								if (BLOG_AD[adPos].rtt != null && BLOG_AD[adPos].rtt == 1) {
									var r = new RotatorAD(BLOG_AD[adPos]);
									if (r[0] != null) {
										if (r[0].enddate != null && r[0].enddate.match(/:\d{2}$/) == null)
										 r[0].enddate += ' 23:59:59';
										if ((r[0].startdate != null && Date.parse(r[0].startdate.replace(/-/g, "/")) >= nowTime) || (r[0].enddate != null && Date.parse(r[0].enddate.replace(/-/g, "/")) <= nowTime)) {
											res.code = '2201';
										} else {
											if (r[0].warp != null && r[0].warp == 1) {
												if (r[0].ads != null) {
													r[0].ads[0].startdate = r[0].startdate;
													r[0].ads[0].enddate = r[0].enddate;
													r = r[0].ads;
												} else {
													res.code = '2205';
												}
											}
											if (r[0].type != 'mixed' && (r[0].ref == null || r[0].ref == '')) {
												res.code = '2203';
											} else {
												if (r[0].type == 'flv') {
													r[0].type = 'mixed';
													r[0].content = playerize(r[0]);
													r[0].ref = '';
												}
											}
										}
									} else {
										res.code = '2111';
									}
									posads = r;
								} else {
									var r = BLOG_AD[adPos].ads;
									if (r[0].enddate != null && r[0].enddate.match(/:\d{2}$/) == null)
									 r[0].enddate += ' 23:59:59';
									if ((r[0].startdate != null && Date.parse(r[0].startdate.replace(/-/g, "/")) >= nowTime) || (r[0].enddate != null && Date.parse(r[0].enddate.replace(/-/g, "/")) <= nowTime)) {
										res.code = '2201';
									}
								}
								res.ads = posads;
							} else {
								res.code = '2103';
								res.ads = {};
							}
						}
					} else {
						res.code = '2001';
						res.ads = {};
					}
					cb(res);
				}
			}
		}
	}
}
var playerize = function(obj) {
	return '<div id="player" style="overflow:hidden;position:fixed;right:0px;bottom:0px;">\
 <div style="width: 40px; height: 18px; cursor: pointer; background: url(http://d1.sina.com.cn/shh/tianyi/bg/audi_zty_cls1.jpg); position: absolute; right: 0px;" onclick="javascript:document.getElementById(\'blogVideoAd\').style.display=\'none\';"></div>\
<object id="playerobj" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9" classid=clsid:d27cdb6e-ae6d-11cf-96b8-444553540000 width="' + obj.width + '" height="' + obj.height + '" type="application/x-shockwave-flash">\
 <param name="flashvars" value="url=' + encodeURIComponent(obj.ref) + '&link=' + encodeURIComponent(obj.click) + '">\
 <param name="movie" value="http://pfp.sina.com.cn/blog/swf/player.swf">\
 <param name="wmode" value="transparent">\
 <param name="quality" value="high">\
 <param name="allowscriptaccess" value="always">\
 <param name="allowfullscreen" value="false">\
 <embed name="playerobj" width="' + obj.width + '" height="' + obj.height + '" src="http://pfp.sina.com.cn/blog/swf/player.swf" flashvars="url=' + encodeURIComponent(obj.ref) + '&link=' + encodeURIComponent(obj.click) + '" quality="high" allowScriptAccess="always" \
 pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" wmode="transparent">  \
 </embed>\
</object>\
</div>';
}
if (typeof(RotatorAD) != 'function') {
	var RotatorAD = function(obj) {		
		var date = new Date();
		var id = 0;
		var max = 9999;
		var url = document.location.href;
		var cookiename = 'SinaRotAD';
		var timeout = 1440;
		var num = obj.adnum;
		if (num == 0)
		 num = 1;
		var ary = new Array();
		if (typeof(globalRotatorId) == 'undefined' || globalRotatorId == null || isNaN(globalRotatorId)) {
			curId = G(cookiename);
			curId = curId == "" ? Math.floor(Math.random() * max) : ++curId;
			if (curId > max || curId == null || isNaN(curId)) curId = 0;
			S(cookiename, curId, timeout);
			globalRotatorId = curId;
		}
		id = globalRotatorId % num;
		var ad = {
			'0': obj.ads[id]
		};		
		return ad;
		function G(N) {
			var c = document.cookie.split("; ");
			for (var i = 0; i < c.length; i++) {
				var d = c[i].split("=");
				if (d[0] == N) return unescape(d[1]);
			}
			return '';
		};
		function S(N, V, Q) {
			var L = new Date();
			var z = new Date(L.getTime() + Q * 60000);
			document.cookie = N + "=" + escape(V) + ";path=/;expires=" + z.toGMTString() + ";";
		};
	}
}
