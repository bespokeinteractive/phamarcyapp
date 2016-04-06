<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
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

</script>



<div class="dashboard clear">
    <div class="info-section">
        <div class="info-header">
            <i class="icon-external-link"></i>

            <h3>Detail Drug Indent</h3>
        </div>
    </div>
</div>

<% if (listTransactionDetail == null) { %>
<table width="100%" cellpadding="5" cellspacing="0">
    <tr align="center">
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
<input type="button" class="ui-button ui-widget ui-state-default ui-corner-all" value="Print" onClick="printDiv();"/>
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
            <tr align="center">
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
			<tr align="center">
			<th>S.No</th>
			<th>Category</th>
            <th>Drug Name</th>
            <th>Formulation</th>
            <th>Quantity Indent</th>
            <th>Batch No.</th>
            <th>Date of Expiry</th>
            <th>Company Name</th>
            <th>Transfer Quantity</th>
            </tr>

<% if (listIndentDetail != null) {
    def count = 0;
    def check = 0;
    listIndentDetail.eachWithIndex { indent, varStatus -> %>
<tr align="center" class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
    <td>${varStatus +1}</td>
    <td>${indent.drug.category.name}</td>
    <td>${indent.drug.name}</td>
    <td>${indent.formulation.name}-${indent.formulation.dozage}</td>
    <td>${indent.quantity}</td>
    <% listTransactionDetail.each { trDetail -> %>
    <% if (trDetail.drug.id == indent.drug.id && trDetail.formulation.id == indent.formulation.id) {
        check = 1; %>
    <% if (count > 0) { %>
</tr>
<tr align="center" class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td>${trDetail.batchNo}</td>
    <td>${trDetail.dateExpiry}</td>
    <td>${trDetail.companyName}</td>
    <td>${trDetail.issueQuantity}</td>
</tr>

<% } else { %>
<td>${trDetail.batchNo}</td>
<td>${trDetail.dateExpiry}</td>
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
<input type="button" class="ui-button ui-widget ui-state-default ui-corner-all"
       value="Print" onClick="printDiv();"/>

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
            <tr align="center">
                <th>S.No</th>
                <th>Category</th>
                <th>Drug Name</th>
                <th>Formulation</th>
                <th>Quantity Indent</th>
                <th>Batch No.</th>
                <th>Date of Expiry</th>
                <th>Company Name</th>
                <th>Transfer Quantity</th>
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
            </tr>
            <tr align="center" class='${varStatus % 2 == 0 ? "oddRow" : "evenRow"} '>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td>${trDetail.batchNo}</td>
                <td>${trDetail.dateExpiry}</td>
                <td>${trDetail.companyName}</td>
                <td>${trDetail.issueQuantity}</td>
            </tr>

            <% } else { %>
            <td>${trDetail.batchNo}</td>
            <td>${trDetail.dateExpiry}</td>
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
