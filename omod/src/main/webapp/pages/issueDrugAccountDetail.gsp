<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Inventory Module"])
    ui.includeCss("billingui", "jquery.dataTables.min.css")
    ui.includeCss("registration", "onepcssgrid.css")

    ui.includeJavascript("billingui", "moment.js")
    ui.includeJavascript("billingui", "jquery.dataTables.min.js")
    ui.includeJavascript("laboratoryapp", "jq.browser.select.js")
    ui.includeJavascript("billingui", "jquery.PrintArea.js")
%>

<script>
    ACCOUNT= {
        detailDrugAccount: function (issueId) {
            if (SESSION.checkSession()) {
                url = "issueDrugAccountDetail.form?issueId=" + issueId + "&keepThis=false&TB_iframe=true&height=500&width=1000";
                tb_show("Detail Account Drug....", url, false);
            }
        }
    }
</script>

<script>
    jQuery(document).ready(function () {
        function print () {
            var printDiv = jQuery("#print").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Drugs To Account Detail</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        jQuery("#printButton").on("click", function(e){
            print().show();
        });
    });

</script>

<div id="print">
    <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
    <tr align="center">
        <th>category</th>
        <th>name</th>
        <th>formulation</th>
        <th>Date </th>
        <th>Quantity</th>
        </tr>
        <% if (listDrugIssue!=null || listDrugIssue!="") { %>
        <% listDrugIssue.each { pTransaction -> %>
        <tr align="center" class=' ' >
        <td>${pTransaction.transactionDetail.drug.category.name}</td>
        <td>${pTransaction.transactionDetail.drug.name} </td>
        <td>${pTransaction.transactionDetail.formulation.name}-${pTransaction.transactionDetail.formulation.dozage}</td>
        <td>${pTransaction.transactionDetail.dateExpiry}</td>
        <td>${pTransaction.quantity}</td>
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
</div>