<%
    ui.decorateWith("appui", "standardEmrPage", [title: title])	
    ui.includeCss("pharmacyapp", "container.css")
	
    ui.includeJavascript("billingui", "moment.js")
%>

${ui.includeFragment("pharmacyapp", fragment)}