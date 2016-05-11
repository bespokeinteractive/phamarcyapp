<%
    ui.decorateWith("appui", "standardEmrPage", [title: "View Current Stock"])
	ui.includeCss("pharmacyapp", "views.css")
	ui.includeJavascript("billingui", "moment.js")
%>

<script>
STOCKBALLANCE={
    detailSubStoreDrug : function(drugId, formulationId)
    {
        if (SESSION.checkSession()) {
            url = "viewCurrentStockBalanceDetail.form?drugId=" + drugId +"&formulationId"+formulationId+ "&keepThis=false&TB_iframe=true&height=500&width=1000";
            tb_show("Detail Drug....", url, false);
        }
    }


}
</script>
<script>

    jq(document).ready(function () {
        function print () {
            var printDiv = jq("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jq("#printButton").on("click", function(e){
            print().show();
        });

        jq("#returnToDrugList").on("click", function (e) {
            window.location.href = emr.pageLink("pharmacyapp", "container", {
                "rel": "current-stock"
            });
        });
    });


</script>

<style>
	table{
		margin-top: 3px;
	}
	.name {
		color: #f26522;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	th:first-child{
		width: 5px;
	}
</style>

<div class="clear"></div>

<div id="current" class="container">
	<div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
					<i class="icon-home small"></i>
				</a>
            </li>
			
			<li>
                <a href="${ui.pageLink('pharmacyapp', 'dashboard')}">
					<i class="icon-chevron-right link"></i>Pharmacy
				</a>
            </li>
			
			<li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('pharmacyapp', 'container', [rel:'current-stock'])}">Current Stock</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                View Details
            </li>
        </ul>
    </div>
	
	<div class="patient-header new-patient-header">
		<div class="demographics">
            <h1 class="name" style="border-bottom: 1px solid #ddd;">
                <span>VIEW EXPIRED DRUGS STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
            </h1>
        </div>
		
		<div class="show-icon">
			&nbsp;
		</div>
		
		<div class="exampler">
			
			<div>
				<span>Drug Name:</span><b>${drug.name}</b><br/>
				<span>Category:</span>${drug.category.name}<br/>
				<span>Formulation:</span>${formulation.name}: ${formulation.dozage}<br/>
			</div>
		</div>
	</div>
</div>

<div id="print">
    <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
        <tr align="center">
			<thead>
				<th>#</th>
				<th>DATE</th>
				<th>TRANSACTION</th>
				<th>OPENING</th>
				<th>RECEIVED</th>
				<th>ISSUED</th>
				<th>CLOSING</th>
				<th>EXPIRY</th>
			</thead>
		</tr>
		
		<% if (listViewStockBalance!=null || listViewStockBalance!="") { %>
		<% listViewStockBalance.eachWithIndex { pTransaction, index -> %>		
		<tr>
			<td>${index+1}</td>
			<td>${ui.formatDatePretty(pTransaction.receiptDate)}</td>
			<td>${pTransaction.transaction.typeTransactionName}</td>
			<td>${pTransaction.openingBalance}</td>
			<td>${pTransaction.quantity}</td>
			<td>${pTransaction.issueQuantity}</td>
			<td>${pTransaction.closingBalance}</td>
			<td>${ui.formatDatePretty(pTransaction.dateExpiry)}</td>
		</tr>
		<% } %>
		<% } else { %>
        <tr align="center" >
            <td>&nbsp;</td>
            <td colspan="9">No drug found</td>
        </tr>
        <% } %>
    </table>
</div>
<div style="margin:10px 0 20px;">
    <span class="button task right" id="printButton"><i class="icon-print"> </i>Print</span>
    <span class="button cancel" id="returnToDrugList">Back To List</span>
</div>