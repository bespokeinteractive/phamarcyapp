<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Dashboard"])	
    ui.includeCss("pharmacyapp", "dashboard.css")
%>

<script>
	jq(function () {
		var redirectLink = '';
		
		jq('#queue').on('click', function(){
			window.location.href = emr.pageLink("pharmacyapp", "container", {
				rel: 'patients-queue'
			});
		});
		
		jq(window).resize(function(){
			var d=jq('#main-dashboard');
			var m=0.5306122;
			
			d.height((d.width()*m));
			
			console.log(d.height());
		}).resize();
		
	});
</script>

<div class="clear"></div>
<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication','home')}">
				<i class="icon-home small"></i></a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				Pharmacy Dasboard
			</li>
		</ul>
	</div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
			<h1 class="name" style="border-bottom: 1px solid #ddd;">
				<span>PHARMACY DASHBOARD &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
			</h1>
		</div>

		<div class="identifiers">
			<em>&nbsp; &nbsp; Current Time:</em>
			<span>${currentTime}</span>
		</div>
	</div>
</div>


<div id='main-dashboard'>
	<div id="queue">
		<i class="icon-group"></i><br/>
		<span>PHARMACY QUEUE</span>
	
	</div>



</div>
Link to <a href="main.page">main</a>

