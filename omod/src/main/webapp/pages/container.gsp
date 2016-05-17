<%
    ui.decorateWith("appui", "standardEmrPage", [title: title])	
    ui.includeCss("pharmacyapp", "container.css")
	
    ui.includeJavascript("billingui", "moment.js")
	ui.includeJavascript("billingui", "jq.browser.select.js")
%>

${ui.includeFragment("pharmacyapp", fragment)}
