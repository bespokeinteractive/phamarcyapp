<%
    ui.decorateWith("appui", "standardEmrPage", [title: title])	
    ui.includeCss("pharmacyapp", "dashboard.css")
%>

${ui.includeFragment("pharmacyapp", fragment)}