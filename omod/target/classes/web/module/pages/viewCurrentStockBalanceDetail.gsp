<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")
    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
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

    jQuery(document).ready(function () {
        function print () {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jQuery("#printButton").on("click", function(e){
            print().show();
        });

        jq("#returnToDrugList").on("click", function (e) {
            window.location.href = emr.pageLink("pharmacyapp", "main", {
                "tabId": "stock"
            });
        });
    });


</script>
<div id="print">
    <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
        <tr align="center">
            <th>Drug Name</th>
            <th>Drug Category</th>
            <th>Drug formulation</th>
            <th>Drug Transaction</th>
            <th>Drug OpeningBalance</th>
            <th>Drug ReceiptQuantity</th>
            <th>Issue Quantity</th>
            <th>Closing Balance</th>
            <th>Date Expiry</th>
            <th>Receipt Date</th>
            <% if (listViewStockBalance!=null || listViewStockBalance!="") { %>
            <% listViewStockBalance.each { pTransaction -> %>
        <tr align="center" class=' ' >
            <td>${pTransaction.drug.name}</td>
            <td>${pTransaction.drug.category.name}</td>
            <td>${pTransaction.formulation.name}:${pTransaction.formulation.dozage}</td>
            <td>${pTransaction.transaction.typeTransactionName}</td>
            <td>${pTransaction.openingBalance}</td>
            <td>${pTransaction.quantity}</td>
            <td>${pTransaction.issueQuantity}</td>
            <td>${pTransaction.closingBalance}</td>
            <td>${pTransaction.dateExpiry}</td>
            <td>${pTransaction.receiptDate}</td>
            <% } %>
            <% } else { %>
        <tr align="center" >
            <td colspan="9">No drug found</td>
        </tr>
        <% } %>
    </table>
</div>
<div>
    <button class="button" type="button" id="printButton">Print</button>
    <input type="button" value="Back To List" name="returnToDrugList"
           id="returnToDrugList" style="margin-top:20px;">
</div>