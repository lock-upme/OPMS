<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>{{config "String" "globaltitle" ""}}</title>
{{template "inc/meta.tpl" .}}
</head><body class="sticky-header">
<section> {{template "inc/left.tpl" .}}
  <!-- main content start-->
  <div class="main-content" >
    <!-- header section start-->
    <div class="header-section">
      <!--toggle button start-->
      <a class="toggle-btn"><i class="fa fa-bars"></i></a>
      <!--toggle button end-->
      <!--search start-->
      <!--search end-->
      {{template "inc/user-info.tpl" .}} </div>
    <!-- header section end-->
    <!-- page heading start-->
    <div class="page-heading">
      <h3> 项目管理 </h3>
      <ul class="breadcrumb pull-left">
        <li> <a href="/user/show/{{.LoginUserid}}">OPMS</a> </li>
        <li> <a href="/project/{{.project.Id}}">{{substr .project.Name 0 8}}</a> </li>
        <li class="active"> 报表 </li>
      </ul>
      <div class="pull-right"><a href="/project/team/{{.project.Id}}" class="btn btn-success">团队</a> <a href="/project/need/{{.project.Id}}" class="btn btn-success">需求</a> <a href="/project/task/{{.project.Id}}" class="btn btn-success">任务</a> <a href="/project/test/{{.project.Id}}" class="btn btn-success">Bug</a> <a href="/project/chart/{{.project.Id}}" class="btn btn-warning">报表</a></div>
    </div>
    <div class="clearfix"></div>
    <!-- page heading end-->
    <!--body wrapper start-->
    <div class="wrapper">
      <div class="row">
                <div class="col-sm-6">
                    <section class="panel" >
                        <header class="panel-heading">
                            项目成员职称比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTeam"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目需求接受人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartNeedsAccept"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目需求创建人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartNeedsUser"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目需求来源比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartNeedsSource"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目任务接受人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTasksAccept"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目任务创建人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTasksUser"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目任务完成人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTasksComplete"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目任务类型比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTasksSource"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目Bug接受人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTestsAccept"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目Bug创建人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTestsUser"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                <div class="col-sm-6">
                    <section class="panel">
                        <header class="panel-heading">
                            项目Bug完成人比例
                        <span class="tools pull-right">
                            <a href="javascript:;" class="fa fa-chevron-down"></a>
                            <a href="javascript:;" class="fa fa-times"></a>
                         </span>
                        </header>
                        <div class="panel-body">
                            <div id="chartTestsComplete"  style="width: 620px;height:400px;" class="pie-chart">
                            </div>
                        </div>
                    </section>
                </div>
                
                
            </div>
    </div>
    <!--body wrapper end-->
    <!--footer section start-->
    {{template "inc/foot-info.tpl" .}}
    <!--footer section end-->
  </div>
  <!-- main content end-->
</section>
{{template "inc/foot.tpl" .}}
<script src="/static/js/echarts.common.min.js"></script>
<script>
$(function(){
	var workday = workDay({{getDate .project.Started}},{{getDate .project.Ended}});
	$('.js-workday').text(workday+'天');

	option = {
		    title : {
		        text: '项目团队人员',
		        subtext: '职称比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTeams}}
				        {{$v.Name}}{{if lt $k $.chartTeamsNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '职称比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTeams}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTeamsNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTeam = echarts.init(document.getElementById('chartTeam'));
	chartTeam.setOption(option);


	option = {
		    title : {
		        text: '项目需求指派人',
		        subtext: '需求指派比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartNeedsAccept}}
				        {{$v.Name}}{{if lt $k $.chartNeedsAcceptNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '需求指派比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartNeedsAccept}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartNeedsAcceptNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartNeedsAccept = echarts.init(document.getElementById('chartNeedsAccept'));
	chartNeedsAccept.setOption(option);

	option = {
		    title : {
		        text: '项目需求创建人',
		        subtext: '需求创建人比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartNeedsUser}}
				        {{$v.Name}}{{if lt $k $.chartNeedsUserNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '需求创建人比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartNeedsUser}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartNeedsUserNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartNeedsUser = echarts.init(document.getElementById('chartNeedsUser'));
	chartNeedsUser.setOption(option);

	option = {
		    title : {
		        text: '项目需求来源',
		        subtext: '需求来源比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartNeedsSource}}
				        {{getNeedsSource $v.Name}}{{if lt $k $.chartNeedsSourceNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '需求来源比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartNeedsSource}}
						{value:{{$v.Value}}, name:{{getNeedsSource $v.Name}}}{{if lt $k $.chartNeedsSourceNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartNeedsSource = echarts.init(document.getElementById('chartNeedsSource'));
	chartNeedsSource.setOption(option);


	option = {
		    title : {
		        text: '项目任务指派人',
		        subtext: '任务指派比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTasksAccept}}
				        {{$v.Name}}{{if lt $k $.chartTasksAcceptNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '任务指派比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTasksAccept}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTasksAcceptNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTasksAccept = echarts.init(document.getElementById('chartTasksAccept'));
	chartTasksAccept.setOption(option);

	option = {
		    title : {
		        text: '项目任务创建人',
		        subtext: '任务创建人比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTasksUser}}
				        {{$v.Name}}{{if lt $k $.chartTasksUserNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '任务创建人比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTasksUser}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTasksUserNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTasksUser = echarts.init(document.getElementById('chartTasksUser'));
	chartTasksUser.setOption(option);

	option = {
		    title : {
		        text: '项目任务完成人',
		        subtext: '任务完成人比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTasksComplete}}
				        {{$v.Name}}{{if lt $k $.chartTasksCompleteNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '任务完成人比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTasksComplete}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTasksCompleteNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTasksComplete = echarts.init(document.getElementById('chartTasksComplete'));
	chartTasksComplete.setOption(option);

	option = {
		    title : {
		        text: '项目任务类型',
		        subtext: '任务类型比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTasksSource}}
				        {{getTaskType $v.Name}}{{if lt $k $.chartTasksSourceNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: '任务类型比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTasksSource}}
						{value:{{$v.Value}}, name:{{getTaskType $v.Name}}}{{if lt $k $.chartTasksSourceNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTasksSource = echarts.init(document.getElementById('chartTasksSource'));
	chartTasksSource.setOption(option);


	option = {
		    title : {
		        text: '项目Bug指派人',
		        subtext: 'Bug指派比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTestsAccept}}
				        {{$v.Name}}{{if lt $k $.chartTestsAcceptNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: 'Bug指派比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTestsAccept}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTestsAcceptNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTestsAccept = echarts.init(document.getElementById('chartTestsAccept'));
	chartTestsAccept.setOption(option);

	option = {
		    title : {
		        text: '项目Bug创建人',
		        subtext: 'Bug创建人比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTestsUser}}
				        {{$v.Name}}{{if lt $k $.chartTestsUserNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: 'Bug创建人比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTestsUser}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTestsUserNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTestsUser = echarts.init(document.getElementById('chartTestsUser'));
	chartTestsUser.setOption(option);

	option = {
		    title : {
		        text: '项目Bug完成人',
		        subtext: 'Bug完成人比例',
		        x:'center'
		    },
		    tooltip : {
		        trigger: 'item',
		        formatter: "{a} <br/>{b} : {c} ({d}%)"
		    },
		    legend: {
		        orient: 'vertical',
		        left: 'left',
		        data: [ 
				        {{range $k,$v := .chartTestsComplete}}
				        {{$v.Name}}{{if lt $k $.chartTestsCompleteNum}},{{end}}
				        {{end}}
				      ]
		    },
		    series : [
		        {
		            name: 'Bug完成人比例',
		            type: 'pie',
		            radius : '55%',
		            center: ['50%', '60%'],
		            data:[
						{{range $k,$v := .chartTestsComplete}}
						{value:{{$v.Value}}, name:{{$v.Name}}}{{if lt $k $.chartTestsCompleteNum}},{{end}}
						{{end}}
		            ],
		            itemStyle: {
		                emphasis: {
		                    shadowBlur: 10,
		                    shadowOffsetX: 0,
		                    shadowColor: 'rgba(0, 0, 0, 0.5)'
		                }
		            }
		        }
		    ]
	};
	var chartTestsComplete = echarts.init(document.getElementById('chartTestsComplete'));
	chartTestsComplete.setOption(option);
	
});
</script>
</body>
</html>
