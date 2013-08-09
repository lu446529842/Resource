//verion 1.0
//by ConciseTony (xiaolong1@)
//为博客部门单独发布的猜你喜欢启动代码，发布到线上

(function(){
    if (window.top !== window.self) {
        return;
    }
    if (window.seajs) {
        seajs.use('product.guess.blog'); 
    } else {
           (function(cb){
            ;(function(m, o, d, u, l, a, r) {
              if(m[d]) {(typeof cb === 'function') && cb(); return}
              function f(n, t) { return function() { r.push(n, arguments); return t } }
              m[d] = a = { args: (r = []), config: f(0, a), use: f(1, a) }
              m.udvDefine = f(2)
              u = o.createElement('script')
              u.id = d + 'node'
              u.src = 'http://i2.sinaimg.cn/jslib/modules2/seajs/1.3.0/sea.js'
              l = o.getElementsByTagName('head')[0]
              a = o.getElementsByTagName('base')[0]
              a ? l.insertBefore(u, a) : l.appendChild(u)
            })(window, document, 'seajs');

            //config
            seajs.use('http://news.sina.com.cn/js/modules2/config/lib/config.1.1.x.js?ver=1.2.9', function(){
                (typeof cb === 'function') && cb();
            });
        })(function(){
            seajs.use('product.guess.blog'); 
        }); 
    }
})();
