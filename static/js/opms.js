$(function(){
	if (is_mobile()) {
		//$('body').removeClass('left-side-collapsed');
		//$('.left-side').hide();
	}
	
	//左侧菜单显示
	/*
	var str = $('#permissionModel').val();
	if (str != "") {
		var str2 = $('#permissionModelc').val();
			
		var strArr = str.split(',');
		var strtmp;
		var str2Arr = str2.split(',');
		var str2tmp;
		var html = '';
		var html2= '';
	
		for(var i=0;i<strArr.length;i++) {
			strArrc =strArr[i].split('||');
			strtmp = strArrc[0].split('-');		
			var m = 0;	
			for(var j=0;j<str2Arr.length;j++) {
				str2Arrc =str2Arr[j].split('||');
				str2tmp = str2Arrc[0].split('-');			
				if (str2tmp[1]==strtmp[1]) {		
					m++;
					if (m == 1) { html2 += '<ul class="sub-menu-list">'; }			
					html2 += '<li><a href="/'+(str2Arrc[1].replace(/-/, '/'))+'"> '+str2tmp[0]+'</a></li>';
				}			
			}
			if (m >0) {
				html2 += '</ul>';
				html += '<li class="menu-list">';			
			} else {
				html += '<li>';
			}
			html += '<a href="'+(strArrc[1] == '#' ? '#' : '/'+strArrc[1].replace(/-/, '/'))+'"><i class="fa fa-'+strtmp[2]+'"></i> <span>'+strtmp[0]+'</span></a>';
			html+=html2
			html2 = '';
			html += '</li>';		
		}	
		//$('.js-left-nav').append(html);
	}
	
	
	//左边菜单加选中状态
	var pre = location.pathname;
	var qstr = pre.split('/');       
    if (qstr) {            
        var lefthref = '/'+qstr[1]+'/'+qstr[2];
        $('.sub-menu-list a').filter(function(){           
        	return $(this).attr('href') == lefthref;
        }).parent().addClass('active').parents('.menu-list').addClass('nav-active');
    };
	*/
	$('.js_checkboxAll').on('click', function(){
		var that = $(this);
		var chk = that.parent().prev('table').find('input[type="checkbox"]');
		if (that.is(':checked')) {
			chk.prop('checked', true);
		} else {
			chk.prop('checked', false);
		}
	});
	
	//顶部消息点击更新状态
	$('.js-msg-status').on('click', function(){
		var that = $(this);
		var id = that.attr('data-id');
		$.post('/message/ajax/status', {id:id},function(data){
						
		},'json');
	});
	
    $('#login-form').validate({
        ignore:'',
        rules : {
            username:{ required: true},
            password:{required: true}
        },
        messages : {
            username : {required: '请填写用户名'},
            password : {required: '请填写密码'}
        },
        submitHandler:function(form) {
            var url = '/login';
            $(form).ajaxSubmit({
                url:url,
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/"}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
    
    $('.js-user-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/user/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.attr('data-status', status == 2 ? 1 : 2).text(status == 2 ? '正常' : '屏蔽').parents('td').prev('td').text(status == 2 ? '屏蔽' : '正常');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });    
   
    $('#userprofile-form').validate({
        ignore:'',        
		rules : {
			username:{required: true},
			depart:{required: true},
			position:{required: true},
            realname:{required: true},
            birth:{ required: true},
			email:{ required: true},
			phone:{ required: true}, 
			emercontact:{ required: true}, 
			emerphone:{ required: true}
        },
        messages : {
			username:{required: '请填写用户名'},
			depart:{required: '请选择部门'},
			position:{required: '请选择职位'},
            realname : {required: '请填写姓名'},
            birth : {required: '请选择出生日期'},
			email : {required: '请填写邮箱'},
			phone : {required: '请填写手机号'},
			emercontact : {required: '请填写紧急联系人'},
			emerphone : {required: '请填写紧急联系人电话'},      
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						if (data.type) {
                       		setTimeout(function(){window.location.href="/user/show/"+data.id}, 2000);
						} else {							
							setTimeout(function(){window.location.href="/user/manage"}, 2000);
						}
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	$('#userprofilepwd-form').validate({
        ignore:'',        
		 rules : {
            oldpwd :{ required:true},
            newpwd :{ required:true,rangelength:[6,15]},
            confpwd :{ required:true,equalTo:'#newpwd'}
        },
        messages : {
            oldpwd :{ required:"当前密码不能为空"},
            newpwd :{ required:"新密码不能为空",rangelength:  $.validator.format("密码长度{0}-{1}位")},
            confpwd :{ required:"确认密码不能为空",equalTo:'两次输入密码不一致'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {						
                       	setTimeout(function(){window.location.href="/user/show/"+data.id}, 2000);						
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	$('.js-depart-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/department/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.attr('data-status', status == 2 ? 1 : 2).text(status == 2 ? '正常' : '屏蔽').parents('td').prev('td').text(status == 2 ? '屏蔽' : '正常');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });    
   
    $('#depart-form').validate({
        ignore:'',        
		rules : {
			name:{required: true}
        },
        messages : {
			name:{required: '请填写名称'}     
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/department/manage"}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	$('.js-position-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/position/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.attr('data-status', status == 2 ? 1 : 2).text(status == 2 ? '正常' : '屏蔽').parents('td').prev('td').text(status == 2 ? '屏蔽' : '正常');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });    
   
    $('#position-form').validate({
        ignore:'',        
		rules : {
			name:{required: true}
        },
        messages : {
			name:{required: '请填写名称'}     
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/position/manage"}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });	
	
	$('.js-notice-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/notice/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.attr('data-status', status == 2 ? 1 : 2).text(status == 2 ? '正常' : '屏蔽').parents('td').prev('td').text(status == 2 ? '屏蔽' : '正常');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('.js-notice-delete').on('click', function(){
    	var that = $(this);
    	var id = that.attr('data-id');
		$.post('/notice/ajax/delete', { id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parents('tr').remove();
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });    
   
    $('#notice-form').validate({
        ignore:'',        
		rules : {
			title:{required: true},
			content:{required:true}
        },
        messages : {
			title:{required: '请填写标题'},
			content:{required:'请填写内容'}   
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/notice/manage"}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	$('#project-form').validate({
        ignore:'',		    
		rules : {
			name:{required: true},
			aliasname:{required: true},
			started:{required: true},
			ended:{required: true},
			desc:{required: true}
        },
        messages : {
			name:{required: '请填写名称'},
			aliasname:{required: '请填写别名'}, 
			started:{required: '请选择开始日期'}, 
			ended:{required: '请选择结束日期'}, 
			desc:{required: '请填写项目介绍'}  
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    
                    if (data.code) {
						if (data.id) {
							var html = '<a href="/project/team/'+data.id+'" class="btn btn-success">添加团队成员</a> <a href="/project/team/'+data.id+'" class="btn btn-warning">建立需求</a> <a href="/project/team/'+data.id+'" class="btn btn-info">建立任务</a>'
							$('#projectModal').modal('toggle').find('.modal-body').html(html);
						} else {
							dialogInfo(data.message)
							setTimeout(function(){window.location.href="/project/manage"}, 2000);
						}
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000); 
                    }
                }
            });
        }
    });
	
	$('.js-project-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/project/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });


	$('.js-team-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/team/ajax/delete', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parents('tr').remove();
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('.js-search-username').on('keydown.autocomplete', function(){
        var ob = $(this);
		var obid = ob.attr('id');
		//alert(obid)
		var hideid;
		if (obid == 'accept-username') {
			hideid = '#acceptid';
		} else if (obid == 'cc-username') {
			hideid = '#ccid';	
		} else {
			hideid = '#userid';
		}
        $(this).autocomplete({
            source: "/user/ajax/search",
            minLength: 1,
            autoFocus: true,
            select: function(e, ui) {              
	            ob.val(ui.item.label).blur();
				$(hideid).val(ui.item.value);               
                return false;
            }
        })
    });
	
	
	$('#cc-username').on('click', function(){
		$('#acceptModal').modal('show');
	});
	$('.js-dialog-taskcc').on('click', function(){
		var that = $(this);		
		var cc = $('#cc-username');	
		var ccid = $('#ccid');
		cc.val('');
		ccid.val('');
		var ccnamestr,ccidstr
		$('.modal-body input[type="checkbox"]').each(function(i){
			if ($(this).is(':checked')) {
				ccnamestr = $(this).attr('data-name')+','+cc.val();		
				cc.val($.unique(ccnamestr.split(',').sort()).join(',').replace(/,$/gi,''));
				
				ccidstr = $(this).attr('data-value')+','+ccid.val();		
				ccid.val($.unique(ccidstr.split(',').sort()).join(',').replace(/,$/gi,''));
			}
		 });
		
		$('#acceptModal').modal('hide');
	});
	
	$('#team-form').validate({
        ignore:'',		    
		rules : {
			username:{required: true}
        },
        messages : {
			username:{required: '请填写姓名'} 
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/team/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	$('#needs-form').validate({
        ignore:'',		    
		rules : {
			name:{required: true},
			source:{required: true},
			level:{required: true},
			stage:{required: true},
			username:{required: true},
			desc: {required: true}
        },
        messages : {
			name:{required: '请填写需求名称'},
			source:{required: '请选择来源'},
			level:{required: '请选择优先级'},
			stage:{required: '请选择需求阶段'},
			username:{required: '请填写指派给'},
			desc:{required:'请填写描述'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/need/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000); 
                    }
                }
            });
        }
    });
	
	$('.js-needs-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/need/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.siblings('.active').removeClass('active');
				that.addClass('active');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });

	$('#task-form').validate({
        ignore:'',		    
		rules : {
			needsid:{required: true},
			type:{required: true},
			name:{required: true}
        },
        messages : {
			needsid:{required: '请选择需求'},
			type:{required: '请选择类型'},
			name:{required: '请填写任务名称'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/task/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	//任务指派
	$('.js-dialog-taskaccept').on('click', function(){
    	var that = $(this);
    	var acceptid = $('#acceptid').val();
		if ($.trim(acceptid) == '') { return false; }
    	var note = $.trim($('#note').val());
		var taskid = $('#taskid').val();
		$.post('/task/ajax/accept', {taskid:taskid, acceptid: acceptid, note: note },function(data){
			$('#acceptModal').modal('hide');
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	//任务开始/完成
	$('.js-task-status').on('click', function(){
    	var that = $(this);
		var taskid = that.attr('data-id');
		var status = that.attr('data-status');		
		$.post('/task/ajax/status', {taskid:taskid, status: status },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parent().prevAll('td:eq(5)').text(status == 2?'进行中':'完成');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	//任务删除
	$('.js-task-delete').on('click', function(){
    	var that = $(this);
		var taskid = that.attr('data-id');	
		$.post('/task/ajax/delete', {id:taskid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.history.back(); }, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	$('#taskbatch-form').validate({
        ignore:'',		    
		rules : {
			'needsid[]':{required: true},
			'name[]':{required: true},
			'type[]':{required: true},
			'acceptid[]':{required: true},
			'tasktime[]':{required: true},
			'desc[]':{required: true},
			'level[]':{required: true}			
        },
        messages : {
			'needsid[]':{required: '必填'},
			'name[]':{required: '必填'},
			'type[]':{required: '必填'},
			'acceptid[]':{required: '必填'},
			'tasktime[]':{required: '必填'},
			'desc[]':{required: '必填'},
			'level[]':{required: '必填'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/task/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	//bug
	$('#test-form').validate({
        ignore:'',		    
		rules : {
			name:{required: true}
        },
        messages : {
			name:{required: '请填写Bug标题'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/test/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	//Bug指派
	$('.js-dialog-testaccept').on('click', function(){
    	var that = $(this);
    	var acceptid = $('#acceptid').val();
		if ($.trim(acceptid) == '') { return false; }
    	var note = $.trim($('#note').val());
		var testid = $('#testid').val();
		$.post('/test/ajax/accept', {testid:testid, acceptid: acceptid, note: note },function(data){
			$('#acceptModal').modal('hide');
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	$('.js-dialog-testcomplete').on('click', function(){
    	var that = $(this);
    	var status = $('#cstatus').val();
		if ($.trim(status) == '') { return false; }
    	var note = $.trim($('#cnote').val());
		var testid = $('#ctestid').val();
		$.post('/test/ajax/status', {testid:testid, status: status, note: note },function(data){
			$('#acceptModal').modal('hide');
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	//Bug完成
	$('.js-test-status').on('click', function(){
    	var that = $(this);
		var testid = that.attr('data-id');
		var status = that.attr('data-status');		
		$.post('/test/ajax/status', {testid:testid, status: status },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parent().prevAll('td:eq(5)').text(status == 2?'进行中':'完成');
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	//Bug删除
	$('.js-test-delete').on('click', function(){
    	var that = $(this);
		var testid = that.attr('data-id');	
		$.post('/test/ajax/delete', {id:testid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.history.back(); }, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	//文档
	$('#doc-form').validate({
        ignore:'',		    
		rules : {
			title:{required: true},
			sort: {required: true}			
        },
        messages : {
			title:{required: '请填写文档名称'},
			sort:{required: '请选择类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/doc/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	$('.js-doc-delete').on('click', function(){
    	var that = $(this);
		var docid = that.attr('data-id');	
		$.post('/doc/ajax/delete', {ids:docid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.history.back(); }, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	//版本
	$('#version-form').validate({
        ignore:'',		    
		rules : {
			title:{required: true},
			versioned: {required: true}			
        },
        messages : {
			title:{required: '请填写版本名称'},
			versioned:{required: '请选择打包日期'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/project/version/"+$('#projectid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	$('.js-version-delete').on('click', function(){
    	var that = $(this);
		var versionid = that.attr('data-id');	
		$.post('/version/ajax/delete', {ids:versionid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.history.back(); }, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('#knowledge-form').validate({
        ignore:'',		    
		rules : {
			sortid:{required:true},
			title:{required: true},
			summary:{required: true},
			content:{required:true}
        },
        messages : {
			sortid:{required:'请选择分类'},
			title:{required: '请填写标题'},
			summary:{required: '请填写简介'},
			content:{required:'请填写正文'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {						
                       setTimeout(function(){window.location.href="/knowledge/"+data.id}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });	
	$('.js-knowledage-delete').on('click', function(){
    	var that = $(this);
		var knowledgeid = that.attr('data-id');	
		$.post('/knowledge/ajax/delete', {id:knowledgeid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload();}, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('#knowledge-comment-form').validate({
        ignore:'',		    
		rules : {
			comment:{required:true}
        },
        messages : {
			comment:{required:'请填写评论内容'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){window.location.reload();}, 2000);
                    } else {
                        
                    }
					setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                }
            });
        }
    });
	
	$('.js-knowledge-laud').on('click', function(){
		var that = $(this);
		var knowid = that.attr('data-id');
		$.post('/knowledge/ajax/laud', {knowid:knowid},function(data){
			dialogInfo(data.message)
			if (data.code) {

			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
	});
	
	//多图上传	
	$('#uploadMulti-form').validate({        
        ignore:'',
        rules : {
            uploadFiles:{ required : true}
        },
        messages : {
            uploadFiles:{required : '请选择上传图片，可以多选'}
        },
        submitHandler:function(form) {
			var id = $('input[name="id"]').val();
			var url = '/uploadmulti';
            $(form).ajaxSubmit({
                url:url,
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code == 1) {						
						setTimeout(function(){window.location.href='/album/manage?filter=me'}, 1000);
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	
	$('body').delegate('.js-album-submit', 'click', function(){
		var that = $(this);
		var form = $('#album-form');
		var title = form.find('input[name="title"]');
		if (title.val() == '') { title.focus(); return; }
		var summary = form.find('textarea[name="summary"]');
		if (summary.val() == '') { summary.focus(); return; }
		var id = form.find('input[name="id"]');
		if (id.val() == '') { return; }
		var status = form.find('input[name="status"]:checked').val();
		
		$.post("/album/edit", { id: id.val(), title:title.val(), summary:summary.val(), status:status}, function(data){			
			if (data.code == 1) {				
				that.text(data.message)
			} else {
				dialogInfo(data.message)
			}
			setTimeout(function(){ $('#dialogAlbum').modal('hide'); }, 1000);
		},'json');	
		
	});	
	
	
	$('.js-album-edit').on('click', function(){
		var that = $(this);
		var title = that.attr('data-title');
		var summary = that.attr('data-summary');
		var id = that.attr('data-id');
		var status = that.attr('data-status');
		dialogAlbum(id, title, summary, status);
	});
	
	$('.js-album-delete').on('click', function(){
    	var that = $(this);
		var albumid = that.attr('data-id');	
		$.post('/album/ajax/delete', {id:albumid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload();}, 1000);
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('#album-comment-form').validate({
        ignore:'',		    
		rules : {
			comment:{required:true}
        },
        messages : {
			comment:{required:'请填写评论内容'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){window.location.reload();}, 2000);
                    } else {
                        
                    }
					setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                }
            });
        }
    });
	
	$('.js-album-laud').on('click', function(){
		var that = $(this);
		var albumid = that.attr('data-id');
		$.post('/album/ajax/laud', {albumid:albumid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
	});
	
	
	$('#resume-form').validate({
        ignore:'',		    
		rules : {
			realname:{required:true},
			phone:{required:true,digits:true}
        },
        messages : {
			realname:{required:'请填写姓名'},
			phone:{required:'请填写手机号',digits:'请输入正确的手机号'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){window.location.href='/resume/manage';}, 2000);
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });


	$('.js-resumes-single').on('click', function(){
    	var that = $(this);
    	var status = that.attr('data-status')
    	var id = that.attr('data-id');
		$.post('/resume/ajax/status', { status: status, id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parents('td').prev('td').text(that.text());
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('.js-resumes-delete').on('click', function(){
    	var that = $(this);
    	var id = that.attr('data-id');
		$.post('/resume/ajax/delete', { id: id },function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parents('tr').remove();
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
	$('#permission-btn-new').on('click', function(){
		var str = '', model = '', modelc = '';
		
		$('input[name="permission[]"]:checked').each(function(i){
			str += $(this).val() + ',';
			if ($(this).parents('li').parents('li').attr('data-pmodel')) {
				model += $(this).parents('li').parents('li').attr('data-pmodel')+',';
				
				if ($(this).parents('div').attr('data-cmodel')) {
					modelc += $(this).parents('div').attr('data-cmodel')+',';
				}
			}
			
		});
		if (str == '') {
			return false;
		}
		
		model = uniqueString(model).toString();	
		model = model.substring(0, model.length-1);
		
		modelc = uniqueString(modelc).toString();		
		modelc = modelc.substring(0, modelc.length-1);
		
		str = str.substring(0, str.length-1)
		var groupid = $('#groupid').val();
		var url = '/group/permission/'+groupid;
		$.post(url, { groupid: groupid, permission: str, model:model, modelc:modelc },function(data){
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
	});
	
	$('#permission-btn').on('click', function(){
		var str = '', model = '', modelc = '';
		
		$('input[name="permission[]"]:checked').each(function(i){
			str += $(this).val() + ',';
			if ($(this).parents('li').parents('li').attr('data-pmodel')) {
				model += $(this).parents('li').parents('li').attr('data-pmodel')+',';
				
				if ($(this).parents('div').attr('data-cmodel')) {
					modelc += $(this).parents('div').attr('data-cmodel')+',';
				}
			}
			
		});
		if (str == '') {
			return false;
		}
		
		model = uniqueString(model).toString();	
		model = model.substring(0, model.length-1);
		
		modelc = uniqueString(modelc).toString();		
		modelc = modelc.substring(0, modelc.length-1);
		
		str = str.substring(0, str.length-1)
		var userid = $('#userid').val();
		var url = '/user/permission/'+userid;
		$.post(url, { userid: userid, permission: str, model:model, modelc:modelc },function(data){
			dialogInfo(data.message)
			if (data.code) {
				
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
	});
	
	
	//审批请假
	$('#leave-form').validate({
        ignore:'',		    
		rules : {
			type:{required:true},
			started:{required:true},
			ended:{required:true},
			days:{required:true,number:true},
			reason:{required:true}
        },
        messages : {
			type:{required:'请选择请假类型'},
			started:{required:'请选择开始日期'},
			ended:{required:'请选择结束日期'},
			days:{required:'请填写天数',number:'请填写数字'},
			reason:{required:'请填写请假事由'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href="/leave/manage" }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	
	$('.js-leave-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/leave/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-leave-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/leave/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	
	$('#leave-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.reload() }, 2000);
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
    
	//审批报销
	$('#expense-form').validate({
        ignore:'',		    
		rules : {
			'amounts[]':{required:true},
			'types[]':{required:true},
			'contents[]':{required:true}
        },
        messages : {
			'amounts[]':{required:'请填写报销金额'},
			'types[]':{required:'请填写报销类型'},
			'contents[]':{required:'请填写报销明细'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href="/expense/manage" }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-expense-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/expense/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-expense-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/expense/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#expense-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.reload() }, 2000);
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	//审批出差
	$('#businesstrip-form').validate({
        ignore:'',		    
		rules : {
			'destinations[]':{required:true},
			'starteds[]':{required:true},
			'endeds[]':{required:true},
			'days':{required:true},
			'reason':{required:true}
        },
        messages : {
			'destinations[]':{required:'请填写目的地'},
			'starteds[]':{required:'请填写开始日期'},
			'endeds[]':{required:'请填写结束日期'},
			'days':{required:'请填写天数'},
			'reason':{required:'请填写出差事由'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href="/businesstrip/manage" }, 2000);
                    } else {
                    	setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-businesstrip-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/businesstrip/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-businesstrip-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/businesstrip/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#businesstrip-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.reload() }, 2000);
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	//审批外出
	$('#goout-form').validate({
        ignore:'',		    
		rules : {
			'started':{required:true},
			'ended':{required:true},
			'hours':{required:true},
			'reason':{required:true}
        },
        messages : {		
			'started':{required:'请填写开始时间'},
			'ended':{required:'请填写结束时间'},
			'hours':{required:'请填写小时数'},
			'reason':{required:'请填写外出事由'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href='/goout/manage'; }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-goout-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/goout/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-goout-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/goout/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#goout-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						window.location.reload();
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	//审批物品领用
	$('#oagood-form').validate({
        ignore:'',		    
		rules : {
			'purpose':{required:true},
			'names[]':{required:true},
			'quantitys[]':{required:true}
        },
        messages : {		
			'purpose':{required:'请填写物品用途'},
			'names[]':{required:'请填写物品名称'},
			'quantitys[]':{required:'请填写物品数量'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href='/oagood/manage'; }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-oagood-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/oagood/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-oagood-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/oagood/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#oagood-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						window.location.reload();
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	//审批加班
	$('#overtime-form').validate({
        ignore:'',		    
		rules : {
			'started':{required:true},
			'ended':{required:true},
			'longtime':{required:true},
			'way':{required:true},
			'holiday':{required:true}
        },
        messages : {		
			'started':{required:'请选择开始时间'},
			'ended':{required:'请选择结束时间'},
			'longtime':{required:'请填时长'},
			'way':{required:'请选择核算方式'},
			'holiday':{required:'请选择是否为法定假日'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href='/overtime/manage'; }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-overtime-status').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/overtime/ajax/status', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('.js-overtime-delete').on('click', function(){
		var that = $(this);
		var leaveid = that.attr('data-id');
		$.post('/overtime/ajax/delete', {id:leaveid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload(); }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#overtime-approvers-form').validate({
        ignore:'',		    
		rules : {
			status:{required:true}
        },
        messages : {
			status:{required:'请选择请假类型'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						window.location.reload();
                    } else {
                        setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }					
                }
            });
        }
    });
	
	//组权限
	$('#group-form').validate({
        ignore:'',		    
		rules : {
			'name':{required:true},
			'summary':{required:true}
        },
        messages : {		
			'name':{required:'请填写组名称'},
			'summary':{required:'请填写组描述'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href='/group/manage'; }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	
	$('.js-group-delete').on('click', function(){
		var that = $(this);
		var id = that.attr('data-id');
		$.post('/group/ajax/delete', {ids:id},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#permission-form').validate({
        ignore:'',		    
		rules : {
			'name':{required:true},
			'ename':{required:true}
        },
        messages : {		
			'name':{required:'请填写名称'},
			'ename':{required:'请填写英文名称'}
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
						setTimeout(function(){ window.location.href='/permission/manage'; }, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }															
                }
            });
        }
    });
	$('.js-permission-delete').on('click', function(){
		var that = $(this);
		var id = that.attr('data-id');
		$.post('/permission/ajax/delete', {ids:id},function(data){
			dialogInfo(data.message)
			if (data.code) {
				setTimeout(function(){ window.location.reload() }, 2000);
			} else {
				setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
			}
			
		},'json');
	});
	
	$('#group-user-form').validate({
        ignore:'',		    
		rules : {
			username:{required: true}
        },
        messages : {
			username:{required: '请填写姓名'} 
        },
        submitHandler:function(form) {
            $(form).ajaxSubmit({
                type:'POST',
                dataType:'json',
                success:function(data) {
                    dialogInfo(data.message)
                    if (data.code) {
                       setTimeout(function(){window.location.href="/group/user/"+$('#groupid').val()}, 2000);
                    } else {
                       setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
                    }
                }
            });
        }
    });
	$('.js-group-user-single').on('click', function(){
    	var that = $(this);
		var testid = that.attr('data-id');	
		$.post('/group/user/ajax/delete', {id:testid},function(data){
			dialogInfo(data.message)
			if (data.code) {
				that.parents('tr').remove();
			} else {
				
			}
			setTimeout(function(){ $('#dialogInfo').modal('hide'); }, 1000);
		},'json');
    });
	
});

function dialogInfo(msg) {
	$('#dialogInfo').remove();
	var html = '';
	html = '<div class="modal fade" id="dialogInfo" tabindex="-1" role="dialog" aria-labelledby="dialogInfoTitle">';
  	html += '<div class="modal-dialog" role="document">';
    html += '<div class="modal-content">';
    html += '<div class="modal-header">';
    html += '<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>';
    html += '<h4 class="modal-title" id="dialogInfoTitle">OPMS提示</h4>';
    html += ' </div>';
    html += '<div class="modal-body">';
    html += '<p>'+msg+'</p>';
    html += '</div>';
    //html += '<div class="modal-footer">';
    //html += ' <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>';
    //html += ' <button type="button" class="btn btn-primary">Send message</button>';
    //html += '</div>';
    html += '</div>';
  	html += '</div>';
	html += '</div>';
	$('body').append(html);
	$('#dialogInfo').modal('show')  
}

function dialogAlbum(id, title, summary, status) {
	$('#dialogAlbum').remove();
	var html = '';
	html += '<div class="modal fade in" id="dialogAlbum" tabindex="-1" role="dialog" aria-labelledby="dialogAlbumTitle">';
    html += '  <div class="modal-dialog" role="document">';
	html += '   <form id="album-form">';
    html += '    <div class="modal-content">';
    html += '      <div class="modal-header">';
    html += '        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>';
    html += '        <h4 class="modal-title" id="dialogAlbumTitle">编辑'+title+'</h4>';
    html += '      </div>';
    html += '      <div class="modal-body">';
    html += '          <div class="form-group">';
    html += '            <label for="recipient-name" class="control-label">标题:</label>';
    html += '           <input type="text" class="form-control" name="title" value="'+title+'">';
    html += '          </div>';
	
    html += '          <div class="form-group">';
    html += '            <label for="message-text" class="control-label">说明:</label>';
    html += '            <textarea class="form-control" name="summary">'+summary+'</textarea>';
    html += '          </div>';
	
	
	html += '<div class="form-group">';
	html += '<label class="radio-inline">';
  	html += '<input type="radio" name="status" value="0" '+(status == 0 ? 'checked' : '')+'> 屏蔽';
	html += '</label>';
	html += '<label class="radio-inline">';
	html += '<input type="radio" name="status" value="1" '+(status == 1 ? 'checked' : '')+'> 正常';
	html += '</label>';
	html += '          </div>';
	
	
	
    html += '      </div>';
    html += '      <div class="modal-footer"><input type="hidden" name="id" value="'+id+'">';
    html += '        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>';
    html += '        <button type="button" class="btn btn-primary js-album-submit">提交</button>';
    html += '      </div>';
    html += '    </div>';
	html += '   </form>';
    html += '  </div>';
    html += '</div>';
	$('body').append(html);
	$('#dialogAlbum').modal('show');
}

function workDay(started, ended) {
	var beginDate = new Date(started.replace(/-/g, "/"));  
	//结束日期  
	var endDate = new Date(ended.replace(/-/g, "/"));  
	//日期差值,即包含周六日、以天为单位的工时，86400000=1000*60*60*24.  
	var workDayVal = (endDate - beginDate)/86400000 + 1;  
	//工时的余数  
	var remainder = workDayVal % 7; 
	//工时向下取整的除数  
	var divisor = Math.floor(workDayVal / 7);  
	var weekendDay = 2 * divisor;  
	  
	//起始日期的星期，星期取值有（1,2,3,4,5,6,0）  
	var nextDay = beginDate.getDay();  
	//从起始日期的星期开始 遍历remainder天  
	for(var tempDay = remainder; tempDay>=1; tempDay--) {  
	    //第一天不用加1  
	    if(tempDay == remainder) {  
	        nextDay = nextDay + 0;  
	    } else if(tempDay != remainder) {  
	        nextDay = nextDay + 1;  
	    }  
	    //周日，变更为0  
	    if(nextDay == 7) {  
	        nextDay = 0;  
	    }  
	  
	    //周六日  
	    if(nextDay == 0 || nextDay == 6) {  
	        weekendDay = weekendDay + 1;  
	    }  
	}  
	//实际工时（天） = 起止日期差 - 周六日数目。  
	workDayVal = workDayVal - weekendDay; 
	return  workDayVal;
}

function is_mobile() { 
	var regex_match = /(nokia|iphone|android|motorola|^mot-|softbank|foma|docomo|kddi|up.browser|up.link|htc|dopod|blazer|netfront|helio|hosin|huawei|novarra|CoolPad|webos|techfaith|palmsource|blackberry|alcatel|amoi|ktouch|nexian|samsung|^sam-|s[cg]h|^lge|ericsson|philips|sagem|wellcom|bunjalloo|maui|symbian|smartphone|midp|wap|phone|windows ce|iemobile|^spice|^bird|^zte-|longcos|pantech|gionee|^sie-|portalmmm|jigs browser|hiptop|^benq|haier|^lct|operas*mobi|opera*mini|320x320|240x320|176x220)/i; 
	var u = navigator.userAgent; 
	if (null == u) { 
		return true; 
	} 
	var result = regex_match.exec(u);
	if (null == result) { 
		return false 
	} else { 
		return true 
	} 
}

function myPrint(obj){  
    var newWindow=window.open("打印窗口","_blank");
    var docStr = obj.innerHTML;  
    newWindow.document.write(docStr);  
    newWindow.document.close();  
    newWindow.print();  
    newWindow.close();  
}

function uniqueString(str) {
	var strArr = str.split(',');  
	for(var i=0;strArr.length-1>i;i++){		
		for(var j=i+1;j<strArr.length;j++){		
			if(strArr[j]==strArr[i]){
				strArr.splice(j,1);
				j--; 
			} 
		} 
	}
	return strArr;
}

function addZero(v){
	return parseInt(v)<10 ? '0'+v : v;
}
	
function fixDate(time) {
	if (!document.all) {
		return new Date(time);
	}
	var arr = time.split(time.match(/\D+/g)[0]);
	return new Date(arr[0], arr[1] - 1, arr[2]);
}