/**
 * @author Chine
 */
var locked = false;

$(function(){
	$("#commentform").ajaxForm({
		beforeSubmit: checkComment,
		success: dealResponse
	});
	
	$("input#not-robot").click(function() {
		$("#commentform").append("<input type=\"hidden\" name=\"not_robot\" value=\"1\" />");
		$(this).hide();
	});
	
	$('div.reply').live('click', function() {
		var name = $.trim($(this).siblings('header').children('cite').text());
		var id = $.trim($(this).parents('li:first').attr('id'));
		var commentId = id.split('-')[1];
		
		$('form#commentform input[type=button]:last')
			.val('取消对' + name + '回应').show();
		$('html, body').scrollTop($('#commentform').offset().top);
		$('#id_reply_to_comment').val(commentId);
	});
	$('form#commentform input[type=button]:last').click(function() {
		var $hideId = $('#id_reply_to_comment');
		var commentId = $hideId.val();
		$hideId.val('');
		$(this).hide();
		$('html, body').scrollTop($('#comment-'+commentId).offset().top);
	});
});

function block(msg) {
	$.blockUI({
		message: msg,
        css: { 
            width: '350px', 
            border: 'none', 
            padding: '15px 5px', 
            backgroundColor: '#000', 
            '-webkit-border-radius': '3px', 
            '-moz-border-radius': '3px', 
			'border-radius': '3px', 
            opacity: .6, 
            color: '#fff' ,
			'font-weight': 'bold'
        } 
	});
}

function checkComment(arr, $form, options) {
	if(locked)
		return false;
	
	for(itm in arr) {
		var obj = arr[itm];
		
		var name = obj.name;
		var value = obj.value;
		
		if(name == 'username'|| name=='email_address' || name=="content") {
			if(value == '' || typeof value == undefined) {
				block(commentTips['miss']);
				setTimeout($.unblockUI, 1500);
				return false;
			}
		}
	}
	
	if(!locked)
		locked = true;
}

function dealResponse(responseText, statusText){
	if (responseText == "0") {
		block(commentTips['fail']);
		setTimeout($.unblockUI, 1500);
	}
	else if (responseText == "-1") {
		block(commentTips['nochn']);
		setTimeout($.unblockUI, 1500);
	}
	else if (responseText == "-2") {
		block(commentTips['notrobot']);
		setTimeout($.unblockUI, 1500);
	}
	else {
		block(commentTips['success']);
		$.get(ajaxUrl, function(data) {
			$("section#comments").replaceWith(data)
			// empty the comment content
			$('textarea#message').val('');
			// set reply comment id to empty and hide cancel replay button
			$('#id_reply_to_comment').val('');
			$('form#commentform input[type=button]:last').hide();
			//scroll to the new comment
			$('html, body').scrollTop($('#comment-'+responseText).offset().top);
			$.unblockUI();
		});
	}
	if(locked) locked = false;
}