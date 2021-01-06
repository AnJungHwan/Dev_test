/**
* @class
* jquery.layerPopup.js 엘리먼트 클릭시 레이어를 뛰움
*
* @example
*
*
* @name layerPopup
* @author JsYang <yakuyaku@gmail.com>
* @since 2009-10-16
* @version 1.0
*/

(function($) {

	$.fn.layerPopup = function(el,options) {

		var opts  = $.extend({}, $.fn.layerPopup.defaults, options);
		var layer = $(opts.name);
		var popupStatus  = 0;
		var closebtn     = false;
		var tgt = false; //current target
		var preObject = false;

		//options
		if(opts.center) {
			opts.left =  $(window).width()/2  - layer.width()/2;
			opts.top  =  $(window).height()/2 - layer.height()/2;
			$(window).bind('resize scroll',function(){ centerScreen($(layer)); });
		}

		//Background Opacity Layer
		if(opts.backgroundDisplay) {
			if(!$("#backgroundPopup").get(0)) {
				var backgroundElement = $("<div id='backgroundPopup'></div>")
					.css({
						"display" : "none" ,
						"position" : "absolute" ,
						"height" : "100%" ,
						"width"  : "100%" ,
						"top"  : "0px" ,
						"left" : "0px" ,
						"background" : "#000000" ,
						"border" : "1px solid #cecece" ,
						"z-index" : "10" ,
						"opacity": "0.5"
					});

				$('body').prepend(backgroundElement);
			}
		}

		this.click(function(e){	loadPopup(e); });

		$(opts.closeButton).bind("click" , function(e) { disablePopup(e); });
		if(opts.backgroundDisplay) $(backgroundElement).bind("click" , function(e) { disablePopup(e); });

		$(document).keypress(function(e){
			if(e.keyCode==27 && popupStatus==1) disablePopup(e);
		});

		function disablePopup(e) {
			if(popupStatus==1) {
				e.stopPropagation();
				$(tgt).removeClass(opts.active);
				layer.fadeOut(opts.speed);
				if(opts.backgroundDisplay) $(backgroundElement).fadeOut(opts.speed);
				popupStatus = 0;
			}
		};

		function loadPopup(e) {
			if(popupStatus==0) {
				if(!e) e = window.event;
				tgt = (e.target) ? e.target : e.srcElement;
				//currentValue = $(tgt).attr("value");
				$(tgt).addClass(opts.active);

				layer.css({
					"position": "absolute",
					"z-index" : "100" ,
					"top":  opts.top  ,
					"left": opts.left
				});

				e.stopPropagation();
				layer.fadeIn(opts.speed);
				if(opts.backgroundDisplay)  $(backgroundElement).fadeIn(opts.speed);
				popupStatus = 1;

			}else disablePopup(e);

		};

		function centerScreen(obj) {
			obj.css('top',  $(window).height()/2-obj.height()/2);
			obj.css('left', $(window).width()/2-obj.width()/2);
		}
	};

	$.fn.layerPopup.defaults = {
		name  : '#popupLayer' ,
		closeButton : '#close' ,
		active : 'activeBgLayer' ,
		backgroundDisplay  : false ,
		center : true ,
		speed  : 'fast' ,
		width : '300px' ,
		height: '300px' ,
		left  : '100px' ,
		top   : '200px'
	};

})(jQuery);