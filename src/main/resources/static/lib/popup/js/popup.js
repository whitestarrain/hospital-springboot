;(function($){
	var Popup = function(newconfig){
		// 保存this
		var self = this;
		// 初始配置
		this.config = {
			'type': 'info',
			'width': 'auto',
			'height': 'auto',
			'color': '#fff',
			'bgcolor': '#666',
			'title': '标题',
			'text': '操作成功',
			'autohide': false,
			'showtime': 3000,
			'closeCallBack': null,
			'submitvalue': '确认',
			'submitcolor': '#fff',
			'submitbgcolor': '#ff3333',
			'submitbordercolor': '#ff0000',
			'submitCallBack': null,
			'cancelbutton': false,
			'cancelvalue': '取消',
			'cancelcolor': '#333',
			'cancelbgcolor': '#fff',
			'cancelbordercolor': '#ccc'
		}
		// 扩展配置
		this.extendconfig = $.extend(this.config, newconfig);
		// 遮罩
		this.maskDom = '<div class="popup-mask">';
		// 弹窗基础DOM
		this.basicDom = '<div class="popup-wrap">' + 
											'<div class="popup-title"></div>' +
											'<div class="popup-body"><div class="popup-text"></div></div>' +
											'<div class="popup-close">×</div>' +
										'</div>';
		// 渲染弹窗
		this.renderPopup();

		// 关闭弹窗，回调函数为closeCallBack
		$('.popup-close').click(function(){
			if(self.extendconfig.closeCallBack != null ){
				self.extendconfig.closeCallBack();
			}
			self.destroy();
		})

		// 确认弹窗，
		$('.popup-wrap .submit-button').click(function(){
			if(self.extendconfig.submitCallBack != null){
				self.extendconfig.submitCallBack();
			}
			self.destroy();
		})

		// 点击取消按钮关闭弹窗，回调函数为closeCallBack，同关闭弹窗
		$('.popup-wrap .cancel-button').click(function(){
			if(self.extendconfig.closeCallBack != null ){
				self.extendconfig.closeCallBack();
			}
			self.destroy();
		})

	}
	Popup.prototype = {
		// 渲染弹窗
		renderPopup: function(){
			// 保存this
			var self = this;
			// 获取所有参数
			var config = this.extendconfig,
					type = config.type,
					width = config.width,
					height = config.height,
					color = config.color,
					bgcolor = config.bgcolor,
					title = config.title,
					text = config.text,
					autohide = config.autohide,
					showtime = config.showtime,
					submitvalue = config.submitvalue,
					submitcolor = config.submitcolor,
					submitbgcolor = config.submitbgcolor,
					submitbordercolor = config.submitbordercolor,
					cancelbutton = config.cancelbutton,
					cancelvalue = config.cancelvalue,
					cancelcolor = config.cancelcolor,
					cancelbgcolor = config.cancelbgcolor,
					cancelbordercolor = config.cancelbordercolor;

			// 获取并判断弹窗的类型，增加不同的按钮
			$('body').append(this.maskDom, this.basicDom);
			switch (type) {
				case 'info': 
					break;
				case 'submit':
					var submitDom = '';
					if(cancelbutton){
						submitDom = '<div class="popup-operate">' +
													'<input type="button" class="submit-button" value="' + submitvalue + '" />' +
													'<input type="button" class="cancel-button" value="' + cancelvalue + '" />' +
												'</div>';
					}else{
						submitDom = '<div class="popup-operate">' + 
													'<input type="button" class="submit-button" value="' + submitvalue + '" />' +
												'</div>';
					}
					$('.popup-body').append(submitDom);
					// 设置确定按钮及取消按钮的样式
					$('.popup-wrap .submit-button').css({
						'color': submitcolor,
						'background-color': submitbgcolor,
						'border-color': submitbordercolor
					})
					$('.popup-wrap .cancel-button').css({
						'color': cancelcolor,
						'background-color': cancelbgcolor,
						'border-color': cancelbordercolor
					})
					break;
			}

			// 获取弹窗DOM
			var popupDom = $('.popup-wrap');

			// 将用户设置的弹窗的宽高，赋值到弹窗上
			popupDom.css({
				'width': width,
				'height': height
			});

			// 根据弹窗的宽高，计算弹窗的位置
			var marginLeft = popupDom.outerWidth() / 2,
			 	  marginTop = popupDom.outerHeight() / 2;
			popupDom.css({
				'margin-left': -marginLeft,
				'margin-top': -marginTop
			});

			// 弹窗颜色及文字颜色的设置
			popupDom.find('.popup-title').css({
				'color': color,
				'background-color': bgcolor
			})

			// 弹窗标题及弹窗内部文字设置
			popupDom.find('.popup-title').text(title);
			popupDom.find('.popup-text').text(text);

			// 弹窗的自动关闭功能（仅有type=info的弹窗可以自动关闭）
			if(type === 'info' && autohide === true){
				if(isNaN(showtime)){
					showtime = 3000
				}
				var showTimer = setTimeout(function(){
					self.destroy();
				}, showtime)
			}

			// 显示弹窗及遮罩层
			$('.popup-mask').show();
			$('.popup-wrap').show();
		},
		// 销毁弹窗
		destroy: function(){
			$('.popup-mask').fadeOut(200, function(){
				$(this).remove();
			})
			$('.popup-wrap').fadeOut(200, function(){
				$(this).remove();
			});
		}
	}
	window.Popup = Popup;
})(jQuery);