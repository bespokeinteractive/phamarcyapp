<%
    ui.decorateWith("appui", "standardEmrPage", [title: title])	
    ui.includeCss("pharmacyapp", "container.css")
%>



${ui.includeFragment("pharmacyapp", fragment)}