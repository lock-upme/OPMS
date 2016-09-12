KindEditor.plugin('hide', function(K) {
        var editor = this, name = 'hide';
		var content = '', newcontent = '', tmp = '';		
        // 点击图标时执行
        editor.clickToolbar(name, function() {
                //editor.insertHtml(1);
				//alert(editor.cmd.range.startOffset+' '+editor.cmd.range.endOffset);
				content = editor.html();				
				var str = editor.selectedHtml();
			
				if (str) {					
					newcontent = content.replace(editor.selectedHtml(),'<span class="hide" style="background-color:#e53333;">'+str+'</span>');					
					editor.html(newcontent);				
				}
				//alert(newcontent);
				//alert(editor.selectedHtml());
        });
});