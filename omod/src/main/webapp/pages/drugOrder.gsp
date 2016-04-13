<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy"]);
    ui.includeJavascript("billingui", "knockout-3.4.0.js")
    ui.includeJavascript("billingui", "moment.js")
%>
<style>
input[type="text"],
input[type="password"],
select {
    border: 1px solid #aaa;
    border-radius: 0px !important;
    box-shadow: none !important;
    box-sizing: border-box !important;
    height: 38px !important;
    line-height: 18px !important;
    padding: 8px 10px !important;
    width: 100% !important;
}

input[type="text"]:focus, textarea:focus {
    outline: 2px solid #007fff !important;
}

textarea {
    width: 97%;
}

.append-to-value {
    color: #999;
    float: right;
    left: auto;
    margin-left: -50px;
    margin-top: 5px;
    padding-right: 10px;
    position: relative;
}

form h2 {
    margin: 10px 0 0;
    padding: 0 5px
}

.col1, .col2, .col3, .col4, .col5, .col6, .col7, .col8, .col9, .col10, .col11, .col12 {
    float: left;
}

form label, .form label {
    margin: 5px 0 0;
    padding: 0 5px
}

#datetime label {
    display: none;
}

.add-on {
    float: right;
    left: auto;
    margin-left: -29px;
    margin-top: 10px;
    position: absolute;
}

.dashboard .info-section {
    margin: 0 5px 5px;
}

.dashboard .info-body li {
    padding-bottom: 2px;
}

.dashboard .info-body li span {
    margin-right: 10px;
}

.dashboard .info-body li small {

}

.dashboard .info-body li div {
    width: 150px;
    display: inline-block;
}

.info-body ul li {
    display: none;
}

.simple-form-ui section.focused {
    width: 75%;
}

.new-patient-header .demographics .gender-age {
    font-size: 14px;
    margin-left: -55px;
    margin-top: 12px;
}

.new-patient-header .demographics .gender-age span {
    border-bottom: 1px none #ddd;
}

.new-patient-header .identifiers {
    margin-top: 5px;
}

.tag {
    padding: 2px 10px;
}

.tad {
    background: #666 none repeat scroll 0 0;
    border-radius: 1px;
    color: white;
    display: inline;
    font-size: 0.8em;
    padding: 2px 10px;
}

.status-container {
    padding: 5px 10px 5px 5px;
}

.catg {
    color: #363463;
    margin: 25px 10px 0 0;
}

.ui-tabs {
    margin-top: 5px;
}

.simple-form-ui section.focused {
    width: 74.6%;
    min-height: 400px;
}

.col15 {
    min-width: 22%;
    max-width: 22%;
    float: left;
    display: inline-block;
}

.col16 {
    min-width: 56%;
    max-width: 56%;
    float: left;
    display: inline-block;
}
</style>

<script>
    var drugOrders = [];
    var processdrugdialog;
    var listOfDrugQuantity = "";
    var focusItem;

    jq(function () {
        var jSonOrders = ${drugOrderListJson};
        var orderList = jSonOrders.simpleObjects;
        processdrugdialog = emr.setupConfirmationDialog({
            selector: '#processDrugDialog',
            actions: {
                confirm: function () {
                    processdrugdialog.close();
                    listOfDrugQuantity = "";
                },
                cancel: function () {

                    processdrugdialog.close();
                }
            }
        });
        jq(".dashboard-tabs").tabs();

        jq('#surname').html(strReplace('${patient.names.familyName}') + ',<em>surname</em>');
        jq('#othname').html(strReplace('${patient.names.givenName}') + ' &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <em>other names</em>');
        jq('#agename').html('${patient.age} years (' + moment('${patient.birthdate}').format('DD,MMM YYYY') + ')');


        function OrderListViewModel() {
            var self = this;
            // Editable data
            self.listItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(orderList, function (item) {
                return item;
            });

            self.viewDetails = function (item) {
                window.location.replace("viewCurrentStockBalanceDetail.page?drugId=" + item.drug.id + "&formulationId=" + item.formulation.id);

            }
            self.listItems(mappedStockItems);


            self.processDrugItem = function (item) {
                processDrug(item.inventoryDrug.id, item.inventoryDrugFormulation.id, item.frequency.name, item.noOfDays, item.comments, item);
            }

            self.removeOrderItem = function () {
                
                self.listItems.remove(focusItem);
            }
        }

        var list = new OrderListViewModel();
        ko.applyBindings(list, jq("#indent-search-result")[0]);
    });//end of doc ready

    function cancelDrugProcess() {
        window.location.href = emr.pageLink("pharmacyapp", "main", {
            "tabId": "queues"
        });
    }

    function printDiv2() {
        var printer = window.open('', '', 'width=300,height=300');
        printer.document.open("text/html");
        printer.document.write(document.getElementById('printDiv').innerHTML);
        printer.print();
        printer.document.close();
        printer.window.close();
    }

    function checkValueExt(thiz, value) {
        if (parseInt(jq(thiz).val()) > parseInt(value)) {
            jq().toastmessage('showNoticeToast', "Issue Quantity is greater that available quantity!");
            jq(thiz).val("");
            jq(thiz).focus();
        }
    }

    function strReplace(word) {
        var res = word.replace("[", "");
        res = res.replace("]", "");
        return res;
    }
    function processDrug(drugId, formulationId, frequencyName, days, comments, item) {
        focusItem = item;
        jq.ajax({
            url: '${ ui.actionLink("pharmacyapp", "drugOrder", "listReceiptDrugAvailable") }',
            dataType: 'json',
            async: false,
            data: {
                drugId: drugId,
                formulationId: formulationId,
                frequencyName: frequencyName,
                days: days,
                comments: comments
            },
            success: function (data) {
                if (data.length === 0) {
                    jq('#processDrugOrderFormTable > tbody > tr').remove();
                    var tbody = jq('#processDrugOrderFormTable > tbody');
                    var row = '<tr align="center">';
                    row += '<td colspan="7"> This drug is empty in your store, please indent it</td>'
                    row += '<input id="' + drugId + '" name="' + drugId + '" type="hidden" />';
                    row += '</tr>';
                    tbody.append(row);
                    jq("#drugIssue").attr("disabled",true);
                    jq("#drugIssue").addClass("disabled");

                } else {
                    jq("#drugIssue").removeClass('disabled');
                    jq("#drugIssue").attr("disabled",false);
                    jq('#processDrugOrderFormTable > tbody > tr').remove();
                    var tbody = jq('#processDrugOrderFormTable > tbody');
                    var row = "";
                    jq.each(data, function (i, item) {
                        listOfDrugQuantity += item.id + ".";
                        row += '<tr align="center">' +
                                '<td>' + (i + 1) + '</td>' +
                                '<td>' + item.dateExpiry + '</td>' +
                                '<td>' + item.dateManufacture + '</td>' +
                                '<td title="' + item.companyName + '">' + item.companyNameShort + '</td>' +
                                '<td>' + item.batchNo + '</td>' +
                                '<td>' + item.currentQuantity + '</td>';
                        if (i === 0) {
                            row += '<td><input type="text" onchange="checkValueExt(this,' + item.currentQuantity + ')" type="text" size="3" name="' + item.id + '_quantity" id="' + item.id + '_quantity" /></td>';
                        } else {
                            row += '<td><input type="text" onchange="checkValueExt(this,' + item.currentQuantity + ')" value="0" type="text" size="3" id="' + item.id + '_quantity" name="' + item.id + '_quantity" style="color:red;"/></td>';
                        }
                        row += '<input id="' + item.id + '_drugName" name="' + item.id + '_drugName" type="hidden" value="' + item.drug.name + '" />';
                        row += '<input id="' + item.id + '_formulation" name="' + item.id + '_formulation" type="hidden" value="' + item.formulation.name + "-" + item.formulation.dozage + '" />';
                        row += '<input id="' + item.id + '_formulationId" name="' + item.id + '_formulationId" type="hidden" value="' + item.formulation.id + '" />';
                        row += '<input id="' + item.id + '_frequencyName" name="' + item.id + '_frequencyName" type="hidden" value="' + frequencyName + '" />';
                        row += '<input id="' + item.id + '_noOfDays" name="' + item.id + '_noOfDays" type="hidden" value="' + days + '" />';
                        row += '<input id="' + item.id + '_comments" name="' + item.id + '_comments" type="hidden" value="' + comments + '" />';
                        row += '<input id="' + item.id + '_price" name="' + item.id + '_price" type="hidden" value="' + item.costToPatient + '" />';
                        row += '<input id="listOfDrugQuantity" name="listOfDrugQuantity" type="hidden" value="' + listOfDrugQuantity + '" />';
                        row += '</tr>';
                    });
                    tbody.append(row);
                }
            },
            error: function (xhr, status, err) {
                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
            }
        });
        processdrugdialog.show();
    }
</script>

<div class="clear"></div>

<div id="content">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('pharmacyapp', 'opdQueue', [app: 'pharmacyapp.main'])}">PHARMACY</a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                LIST OF ORDER
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span id="surname">${patient.names.familyName},<em>surname</em></span>
                <span id="othname">${patient.names.givenName} &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em>
                </span>

                <span class="gender-age">
                    <span>
                        <% if (patient.gender == "F") { %>
                        Female
                        <% } else { %>
                        Male
                        <% } %>
                    </span>
                    <span id="agename">${patient.age} years (15.Oct.1996)</span>

                </span>
            </h1>

            <br/>

            <div id="stacont" class="status-container">
                <span class="status active"></span>
                Visit Status
            </div>

            <div class="tad">Last Visit</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${patient.getPatientIdentifier()}</span>
            <br>

            <div class="catg">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small> ${patientType}
            </div>
        </div>

        <div class="close"></div>
    </div>

    <div id="indent-search-result" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="indent-search-result-table_wrapper">

            <table id="orderList">
                <thead>
                <tr role="row">
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>S.No</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Drug Name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Formulation</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Frequency</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Days</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Comments</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Actions</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                </tr>
                </thead>

                <tbody data-bind="foreach: listItems">
                <tr>
                    <td data-bind="text: \$index() + 1"></td>
                    <td data-bind="text: inventoryDrug.name"></td>
                    <td>
                        <span data-bind="text: inventoryDrugFormulation.name"></span> - <span
                            data-bind="text: inventoryDrugFormulation.dozage"></span>
                    </td>
                    <td data-bind="text: frequency.name"></td>
                    <td data-bind="text: noOfDays"></td>
                    <td data-bind="text: comments"></td>
                    <td style="text-align: center;">
                        <a class="remover" href="#" data-bind="click: \$root.processDrugItem">
                            <i class="icon-signin small">Process</i>
                        </a>
                    </td>
                </tr>
                </tbody>
            </table>
            <input type="button" value="Cancel" onclick="cancelDrugProcess();" class="cancel"/>
            <input type="submit" id="subm" name="subm" value="Finish" class="confirm" style="float: right;"/>
            <input type="button" id="print" name="print" value="Print" onClick="printDiv2();" class="task"
                   style="float: right;"/> &nbsp;&nbsp;

        </div>

        <div id="processDrugDialog" class="dialog" style="display: none; width: 80%">
            <div class="dialog-header">
                <i class="icon-folder-open"></i>

                <h3>Process Drug Order</h3>
            </div>


            <div class="dialog-content">
                <form method="post" id="processDrugOrderForm" class="box">
                    <table class="box" id="processDrugOrderFormTable">
                        <thead>
                        <tr>
                            <th>S.No</th>
                            <th>Expiry</th>
                            <th title="Date of manufacturing">DM</th>
                            <th>Company</th>
                            <th>Batch No.</th>
                            <th title="Quantity available">Available</th>
                            <th title="Issue quantity">Issue</th>
                        </tr>
                        </thead>
                        <tbody>

                        </tbody>
                    </table>
                    <br/>
                    <button class="button confirm right" data-bind="click: \$root.removeOrderItem" id="drugIssue">Issue Drug</button>
                    <span class="button cancel">Cancel</span>
                </form>
            </div>

        </div>
    </div>



    <!--PRINT DIV  -->
    <div id="printDiv" class="hidden" style="width: 1280px; font-size: 0.8em">

        <style>
        @media print {
            .donotprint {
                display: none;
            }

            .spacer {
                margin-top: 50px;
                font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
                font-style: normal;
                font-size: 14px;
            }

            .printfont {
                font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
                font-style: normal;
                font-size: 14px;
            }
        }
        </style>
        <center><img width="100" height="100" align="center" title="OpenMRS" alt="OpenMRS"
                     src="kenya_logo.bmp">
        </center>
        <h5>
            <center>${userLocation}</center>
        </h5>
        <br><br>
        <table align='Center'>
            <tr>
                <td>Patient ID :</td>
                <td>&nbsp;&nbsp;&nbsp;</td>
                <td>&nbsp;${patientSearch.identifier}</td>
            </tr>
            <tr>
                <td>Name :</td>
                <td>&nbsp;</td>
                <td>&nbsp;${patientSearch.givenName}&nbsp;
                    ${patientSearch.familyName}&nbsp;&nbsp;${patientSearch.middleName}</td>
            </tr>
            <tr>
                <td>Age:</td>
                <td>&nbsp;</td>
                <td>
                    <% if (patientSearch.age == 0) { %>
                    &lt 1
                    <% } else { %>
                    ${patientSearch.age}
                    <% } %>
                </td>

            </tr>
            <tr>
                <td>Gender:</td>
                <td>&nbsp;</td>
                <td>&nbsp;${patientSearch.gender}</td>
            </tr>
            <tr>
                <td>Date :</td>
                <td>&nbsp;</td>
                <td>${date}</td>
            </tr>
        </table>


        <table id="myTablee" class="tablesorter" class="thickbox" style="width:100%; margin-top:30px">
            <thead>
            <tr>
                <th style="text-align: center;">S.No</th>
                <th style="text-align: center;">Drug Name</th>
                <th style="text-align: center;">Formulation</th>
                <th style="text-align: center;">Days</th>
                <th style="text-align: center;">Frequency</th>
                <th style="text-align: center;">Comments</th>
                <!-- <th style="text-align: center;">Quantity</th> -->
            </tr>
            </thead>
            <tbody>
            <% drugOrderList.eachWithIndex { drug, idx -> %>
            <tr class="class" id="${drug.inventoryDrug.name}">
                <td align="center">${idx}</td>
                <td align="center">${drug.inventoryDrug.name}</td>
                <td align="center">${drug.inventoryDrugFormulation.name}-${drug.inventoryDrugFormulation.dozage}</td>
                <td align="center">${drug.noOfDays}</td>
                <td align="center">${drug.frequency.name}</td>
                <td align="center">${drug.comments}</td>
            </tr>
            <% } %>

            </tbody>
        </table>
        <br><br><br><br><br><br><br>
        <table class="spacer" style="margin-left: 60px;width:100%;">
            <tr>
                <td width="20%"><b>Treating Doctor</b></td>
                <td>:${doctor}</td>
            </tr>
            <tr>
                <td width="20%"><b>Treating Pharmacist</b></td>
                <td>:${pharmacist}</td>
            </tr>
        </table>
    </div>
</div>
