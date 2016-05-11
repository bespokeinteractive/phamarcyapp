<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
	ui.includeCss("pharmacyapp", "container.css")
%>

<script>
    jq(function(){

    });//end of doc ready
    function printDiv(){
        var printDiv = jQuery("#printDiv").html();
        var printWindow = window.open('', '', 'height=400,width=800');
        printWindow.document.write('<html><head><title>Indent Slip :-Support by KenyaEHRS</title>');
        printWindow.document.write('</head>');
        printWindow.document.write(printDiv);
        printWindow.document.write('</body></html>');
        printWindow.document.close();
        printWindow.print();
    }
    function mainPage() {
        window.location.href = emr.pageLink("pharmacyapp", "container", {
            "rel": "indent-drugs"
        });
    }

</script>

<style>
	table{
		font-size: 14px;
	}
</style>

<div id="indents-div">
	<div class="container">
		<div class="example">
			<ul id="breadcrumbs">
				<li>
					<a href="${ui.pageLink('referenceapplication', 'home')}">
						<i class="icon-home small"></i></a>
				</li>
				
				<li>
					<a href="${ui.pageLink('pharmacyapp', 'dashboard')}">
						<i class="icon-chevron-right link"></i>
						Pharmacy
					</a>
				</li>
				
				<li>
					<a href="${ui.pageLink('pharmacyapp', 'container',['rel':'indent-drugs'])}">
						<i class="icon-chevron-right link"></i>
						Indent List
					</a>
				</li>

				<li>
					<i class="icon-chevron-right link"></i>
					Ident Details
				</li>
			</ul>
		</div>
		
		<div class="patient-header new-patient-header">
			<div class="demographics" style="margin-bottom: 2px;">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span>&nbsp;INDENT DRUG DETAILS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>				
			</div>			
			
			<div class="show-icon">
				&nbsp;
			</div>
		</div>
		
	</div>
</div>

<% if (listTransactionDetail == null) { %>
<table width="100%" cellpadding="5" cellspacing="0">
    <tr>
        <th>S.No</th>
        <th>Category</th>
        <th>Drug Name</th>
        <th>Formulation</th>
        <th>Quantity</th>
        <th>Transfer Quantity</th>
    </tr>

    <% if (listIndentDetail != null) { %>
    <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
    <tr align="center" class='${varStatus.index % 2 == 0 ? "oddRow" : "evenRow"} '>
        <td>${varStatus +1}</td>
        <td>${indent.drug.category.name}</td>
        <td>${indent.drug.name}</td>
        <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
        <td>${indent.quantity}</td>
        <td>${indent.mainStoreTransfer}</td>
    </tr>

    <% }
    } %>
</table>

<div style="margin-top: 10px;">
	<span class="button task right" onClick="printDiv();">
		<i class="icon-print small"> </i>Print		
	</span>
	
	<span class="button cancel" onClick="mainPage();">
		Return to List  
	</span>
</div>
	   
	   
	   
<!-- PRINT DIV -->
<div id="printDiv" style="display: none;">
    <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
        <br/>
        <br/>
        <center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
        <br/>
        <br/>
        <span style="float:right;font-size: 1.7em">Date: ${date}</span>
        <br/>
        <br/>
        <table border="1">
            <tr>
                <th>S.No</th>
                <th>Category</th>
                <th>Drug Name</th>
                <th>Formulation</th>
                <th>Quantity</th>
                <th>Transfer Quantity</th>
            </tr>

            <% if (listIndentDetail != null) { %>
            <% listIndentDetail.eachWithIndex { indent, varStatus -> %>
            <tr align="center" class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
                <td>${varStatus+1}</td>
                <td>${indent.drug.category.name}</td>
                <td>${indent.drug.name}</td>
                <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                <td>${indent.quantity}</td>
                <td>${indent.mainStoreTransfer}</td>
            </tr>

            <% }
            } %>

        </table>

        <br/><br/><br/><br/><br/><br/>
        <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
            style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
        <br/><br/><br/><br/><br/><br/>
        <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
    </div>
</div>
<!-- END PRINT DIV -->


<% } else { %>

<table width="100%" cellpadding="5" cellspacing="0">
			<tr>
				<thead>
					<th>#</th>
					<th>CATEGORY</th>
					<th>DRUG</th>
					<th>FORMULATION</th>
					<th>QUANTITY</th>
					<th>BATCH#</th>
					<th>EXPIRY</th>
					<th>COMPANY</th>
					<th>TRANSFER</th>
				</thead>
            </tr>

<% if (listIndentDetail != null) {
    def count = 0;
    def check = 0;
    listIndentDetail.eachWithIndex { indent, varStatus -> %>
<tr class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
    <td>${varStatus +1}</td>
    <td>${indent.drug.category.name}</td>
    <td>${indent.drug.name}</td>
    <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
    <td>${indent.quantity}</td>
    <% listTransactionDetail.each { trDetail -> %>
    <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) {
        check = 1; %>
    <% if (count > 0) { %>
	
    <td>${trDetail.batchNo}</td>
    <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
    <td>${trDetail.companyName}</td>
    <td>${trDetail.issueQuantity}</td>
</tr>

<% } else { %>
<td>${trDetail.batchNo}</td>
<td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
<td>${trDetail.companyName}</td>
<td>${trDetail.issueQuantity}</td>
</tr>

<% }
    count++;
} %>

<% } %>
<% if (check == 0) { %>
<td>N/A</td>
<td>N/A</td>
<td>N/A</td>
<td>0</td>
</tr>
<% } %>

<% }
} %>

</table>

<div style="margin-top: 10px;">
	<span class="button task right" onClick="printDiv();">
		<i class="icon-print small"> </i>Print		
	</span>
	
	<span class="button cancel" onClick="mainPage();">
		Return to List  
	</span>
</div>

<!-- PRINT DIV -->
<div id="printDiv" style="display: none;">
    <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
        <br/>
        <br/>
        <center style="float:center;font-size: 2.2em">Indent From ${store.name}</center>
        <br/>
        <br/>
        <span style="float:right;font-size: 1.7em">Date: ${date}</span>
        <br/>
        <br/>
        <table border="1">
            <tr>
				<thead>
					<th>#</th>
					<th>CATEGORY</th>
					<th>DRUG</th>
					<th>FORMULATION</th>
					<th>QUANTITY</th>
					<th>BATCH#</th>
					<th>EXPIRY</th>
					<th>COMPANY</th>
					<th>TRANSFER</th>
				</thead>
            </tr>

            <% if (listIndentDetail != null) {
                def count = 0;
                def check = 0;
                listIndentDetail.eachWithIndex { indent, varStatus -> %>
            <tr align="center" class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
                <td>${varStatus+1}</td>
                <td>${indent.drug.category.name}</td>
                <td>${indent.drug.name}</td>
                <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
                <td>${indent.quantity}</td>
                <% listTransactionDetail.each { trDetail -> %>
                <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) {
                    check = 1; %>
                <% if (count > 0) { %>
           
                <td>${trDetail.batchNo}</td>
                <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
                <td>${trDetail.companyName}</td>
                <td>${trDetail.issueQuantity}</td>
            </tr>

            <% } else { %>
            <td>${trDetail.batchNo}</td>
            <td>${ui.formatDatePretty(trDetail.dateExpiry)}</td>
            <td>${trDetail.companyName}</td>
            <td>${trDetail.issueQuantity}</td>
        </tr>

            <% }
                count++;
            } %>

            <% } %>
            <% if (check == 0) { %>
            <td>N/A</td>
            <td>N/A</td>
            <td>N/A</td>
            <td>0</td>
        </tr>
            <% } %>

            <% }
            } %>

        </table>

        <br/><br/><br/><br/><br/><br/>
        <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
            style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
        <br/><br/><br/><br/><br/><br/>
        <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
    </div>
</div>
<!-- END PRINT DIV -->


<% } %>
