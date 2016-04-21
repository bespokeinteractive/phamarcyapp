<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])

%>
<style>
@media print {
    .donotprint {
        display: none;
    }

    .spacer {
        margin-top: 100px;
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

<style>
.retired {
    text-decoration: line-through;
    color: darkgrey;
}
</style>
<script>
    jq(function () {
        var listOfDrugToIssue =
        ${listDrugIssue}.
        listDrugIssue;
        var listNonDispensed =
        ${listOfNotDispensedOrder}.
        listOfNotDispensedOrder;

        function DrugOrderViewModel() {
            var self = this;
            self.availableOrders = ko.observableArray([]);
            self.nonDispensed = ko.observableArray([]);
            var mappedOrders = jQuery.map(listOfDrugToIssue, function (item) {
                return new DrugOrder(item);
            });
            var mappedNonDispensed = jQuery.map(listNonDispensed, function (item) {
                return new NonDrugOrder(item);
            });

            self.availableOrders(mappedOrders);
            self.nonDispensed(mappedNonDispensed);

            //observable waiver
            self.waiverAmount = ko.observable(0.00);

            //observable comment
            self.comment = ko.observable("");

            //observable drug
            self.flag = ko.observable(${flag});

            // Computed data
            self.totalSurcharge = ko.computed(function () {
                var total = 0;
                for (var i = 0; i < self.availableOrders().length; i++) {
                    total += self.availableOrders()[i].orderTotal();
                }
                return total.toFixed(2);
            });

            self.runningTotal = ko.computed(function () {
                var rTotal = self.totalSurcharge() - self.waiverAmount();
                return rTotal.toFixed(2);
            });


            //submit bill
            self.submitBill = function () {
                var flag =${flag };
                if (flag === 0) {
                    //no need to submit, just print and set
//                    jq("#drugBillsForm").submit();
                    //drug has been processed, we just do a reprint
                    jq().toastmessage('showErrorToast', "Drug Processed Already- Do a reprint!");
                    var printDiv = jQuery("#printDiv").html();
                    var printWindow = window.open('', '', 'height=400,width=800');
                    printWindow.document.write('<html><head><title>Print Drug Order :-Support by KenyaEHRS</title>');
                    printWindow.document.write('</head>');
                    printWindow.document.write(printDiv);
                    printWindow.document.write('</body></html>');
                    printWindow.document.close();
                    printWindow.print();

                } else {
                    //drug has been processed, we just do a reprint
                    jq().toastmessage('showErrorToast', "Drug Processed Already- Do a reprint!");
                    var printDiv = jQuery("#printDiv").html();
                    var printWindow = window.open('', '', 'height=400,width=800');
                    printWindow.document.write('<html><head><title>Print Drug Order :-Support by KenyaEHRS</title>');
                    printWindow.document.write('</head>');
                    printWindow.document.write(printDiv);
                    printWindow.document.write('</body></html>');
                    printWindow.document.close();
                    printWindow.print();
                }
            }

            self.isNonPaying = ko.computed(function () {
                var cat = "${paymentSubCategory}";
                var catArray = ["GENERAL", "EXPECTANT MOTHER", "TB PATIENT", "CCC PATIENT"];
                var exists = jq.inArray(cat, catArray);
                if (exists >= 0) {
                    return false;
                } else {
                    return true;
                }
            });
        }

        function DrugOrder(item) {
            var self = this;
            self.initialBill = ko.observable(item);
            self.orderTotal = ko.computed(function () {
                var quantity = self.initialBill().quantity;
                var price = self.initialBill().transactionDetail.costToPatient;
                return quantity * price;
            });
        }

        function NonDrugOrder(item) {
            var self = this;
            self.initialNonBill = ko.observable(item);
        }

        var orders = new DrugOrderViewModel();
        ko.applyBindings(orders, jq("#dispensedDrugs")[0]);

    });//end of document ready
</script>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('billingui', 'billingQueue')}">Pharmacy</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('billingui', 'listOfOrder')}?patientId=${patientId}">Drug Orders</a>
            </li>


            <li>
                <i class="icon-chevron-right link"></i>
                Pharmacy Order
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span id="surname">${familyName},<em>surname</em></span>
                <span id="othname">${givenName} ${middleName}  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em>
                </span>

                <span class="gender-age">
                    <span>
                        ${gender}
                    </span>
                    <span id="agename">${age} years</span>

                </span>
            </h1>

            <br/>

            <div id="stacont" class="status-container">
                <span class="status active"></span>
                Order Date : ${date}
            </div>

            <div class="tag">Receipt Id: ${receiptid}</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${identifier}</span>
            <br>

            <div class="catg">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small>${paymentSubCategory}
            </div>
        </div>

        <div class="close"></div>
    </div>

    <div class="dashboard clear" id="dispensedDrugs">
        <table width="100%" id="orderBillingTable" class="tablesorter thickbox">
            <thead>
            <tr align="center">
                <th>S.No</th>
                <th>Drug</th>
                <th>Formulation</th>
                <th>Frequency</th>
                <th>Days</th>
                <th>Comments</th>
                <th>Expiry</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Item Total</th>
            </tr>
            </thead>

            <tbody data-bind="foreach: availableOrders, visible: availableOrders().length > 0">
            <tr>
                <td data-bind="text: \$index()+1"></td>
                <td data-bind="text: initialBill().transactionDetail.drug.name"></td>
                <td>
                    <span data-bind="text: initialBill().transactionDetail.formulation.name"></span> -
                    <span data-bind="text: initialBill().transactionDetail.formulation.dozage"></span>
                </td>
                <td data-bind="text: initialBill().transactionDetail.frequency.name"></td>
                <td data-bind="text: initialBill().transactionDetail.noOfDays"></td>
                <td data-bind="text: initialBill().transactionDetail.comments"></td>
                <td data-bind="text: initialBill().transactionDetail.dateExpiry"></td>
                <td data-bind="text: initialBill().quantity"></td>
                <td data-bind="text: initialBill().transactionDetail.costToPatient.toFixed(2)"></td>
                <td data-bind="text: orderTotal().toFixed(2)"></td>
            </tr>
            </tbody>
        </table>
        <br/>


        <div id="nonDispensedDrugs" data-bind="visible: nonDispensed().length > 0">
            <center><h3>Drugs Not Issued</h3></center>
            <table width="100%" id="nonDispensedDrugsTable" class="tablesorter thickbox">
                <thead>
                <tr align="center">
                    <th>S.No</th>
                    <th>Drug</th>
                    <th>Formulation</th>
                    <th>Frequency</th>
                    <th>Days</th>
                    <th>Comments</th>
                </tr>
                </thead>

                <tbody data-bind="foreach: nonDispensed">
                <tr>
                    <td data-bind="text: \$index()+1"></td>
                    <td data-bind="text: initialNonBill().inventoryDrug.name"></td>
                    <td>
                        <span data-bind="text: initialNonBill().inventoryDrugFormulation.name"></span> -
                        <span data-bind="text: initialNonBill().inventoryDrugFormulation.dozage"></span> -
                    </td>
                    <td data-bind="text: initialNonBill().frequency.name"></td>
                    <td data-bind="text: initialNonBill().noOfDays"></td>
                    <td data-bind="text: initialNonBill().comments"></td>
                </tr>
                </tbody>
            </table>

        </div>


        <br/>

        <div>
            <div style="float:right;">Total :
                <span data-bind="text: totalSurcharge, css:{'retired': isNonPaying()}"></span>
                <span data-bind="visible: isNonPaying()">0.00</span>
            </div><br/>

            <div style="float:right;">Amount To Pay :
                <span data-bind="text: runningTotal,css:{'retired': isNonPaying()}"></span>
                <span data-bind="visible: isNonPaying()">0.00</span>
            </div>

            <div data-bind="visible: flag() == 0">
                Waiver Amount: <input id="waiverAmount" data-bind="value: waiverAmount"/><br/>

                <div data-bind="visible: waiverAmount() > 0">
                    Waiver Comment:<textarea type="text" id="waiverComment" name="waiverComment"
                                             size="7" class="hasborder" style="width: 99.4%; height: 60px;"
                                             data-bind="value: comment"></textarea> <br/>
                </div>
            </div>

        </div>

        <div>
            Attending Pharmacistw: ${cashier} &nbsp;&nbsp;
        </div>

        <input type="button" class="button cancel"
               onclick="javascript:window.location.href = 'billingQueue.page?'"
               value="Cancel">
        <% if (flag == 1) { %>
        <input id="printOrder" name="printOrder" style="float:right;" class=" confirm"
               value="Reprint" data-bind="click: submitBill, enable: availableOrders().length > 0 ">
        <% } else { %>
        <input id="printOrder" name="printOrder" style="float:right;" class="confirm"
               value="Print" data-bind="click: submitBill, enable: availableOrders().length > 0 ">
        <% } %>


        <!-- PRINT DIV -->
        <div id="printDiv" style="display: none;">
            <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">

                <table class="spacer" style="margin-left: 60px;">
                    <tr>
                        <h3>
                            <center><b><u>${userLocation}</u></b></center>
                        </h3>
                    </tr>
                    <tr>
                        <h5><b>
                            <center>CASH RECEIPT</center>
                        </b></h5>
                    </tr>
                </table>
                <br/>
                <br/>

                <table class="spacer" style="margin-left: 60px;">
                    <tr>
                        <td>Date/Time:</td>
                        <td>:${date}</td>
                    </tr>
                    <tr>
                        <td>Name</td>
                        <td>
                            :${givenName}&nbsp;${familyName}&nbsp;${middleName}</td>
                    </tr>
                    <tr>
                        <td>Patient ID</td>
                        <td>:${identifier}</td>
                    </tr>
                    <tr>
                    <tr>
                        <td>Age</td>
                        <td>:
                        ${age}
                        </td>
                    </tr>
                </tr>
                    <tr>
                        <td>Gender</td>
                        <td>:${gender}</td>
                    </tr>
                    <tr>
                        <td>Payment Category</td>
                        <td>:${paymentSubCategory}</td>
                    </tr>

                </table>
                <table width="100%" class="tablesorter thickbox">
                    <thead>
                    <tr align="center">
                        <th>S.No</th>
                        <th>Drug</th>
                        <th>Formulation</th>
                        <th>Frequency</th>
                        <th>Days</th>
                        <th>Comments</th>
                        <th>Expiry</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Item Total</th>
                    </tr>
                    </thead>

                    <tbody data-bind="foreach: availableOrders, visible: availableOrders().length > 0">
                    <tr>
                        <td data-bind="text: \$index()+1"></td>
                        <td data-bind="text: initialBill().transactionDetail.drug.name"></td>
                        <td>
                            <span data-bind="text: initialBill().transactionDetail.formulation.name"></span> -
                            <span data-bind="text: initialBill().transactionDetail.formulation.dozage"></span>
                        </td>
                        <td data-bind="text: initialBill().transactionDetail.frequency.name"></td>
                        <td data-bind="text: initialBill().transactionDetail.noOfDays"></td>
                        <td data-bind="text: initialBill().transactionDetail.comments"></td>
                        <td data-bind="text: initialBill().transactionDetail.dateExpiry"></td>
                        <td data-bind="text: initialBill().quantity"></td>
                        <td data-bind="text: initialBill().transactionDetail.costToPatient.toFixed(2)"></td>
                        <td data-bind="text: orderTotal().toFixed(2)"></td>
                    </tr>
                    </tbody>
                </table>
                <br/>


                <div data-bind="visible: nonDispensed().length > 0">
                    <center><h3>Drugs Not Issued</h3></center>
                    <table width="100%" class="tablesorter thickbox">
                        <thead>
                        <tr align="center">
                            <th>S.No</th>
                            <th>Drug</th>
                            <th>Formulation</th>
                            <th>Frequency</th>
                            <th>Days</th>
                            <th>Comments</th>
                        </tr>
                        </thead>

                        <tbody data-bind="foreach: nonDispensed">
                        <tr>
                            <td data-bind="text: \$index()+1"></td>
                            <td data-bind="text: initialNonBill().inventoryDrug.name"></td>
                            <td>
                                <span data-bind="text: initialNonBill().inventoryDrugFormulation.name"></span> -
                                <span data-bind="text: initialNonBill().inventoryDrugFormulation.dozage"></span> -
                            </td>
                            <td data-bind="text: initialNonBill().frequency.name"></td>
                            <td data-bind="text: initialNonBill().noOfDays"></td>
                            <td data-bind="text: initialNonBill().comments"></td>
                        </tr>
                        </tbody>
                    </table>

                </div>


                <br/>

                <div>
                    <div style="float:right;">Total :
                        <span data-bind="text: totalSurcharge, css:{'retired': isNonPaying()}"></span>
                        <span data-bind="visible: isNonPaying()">0.00</span>
                    </div><br/>

                    <div style="float:right;">Amount To Pay :
                        <span data-bind="text: runningTotal,css:{'retired': isNonPaying()}"></span>
                        <span data-bind="visible: isNonPaying()">0.00</span>
                    </div>
                </div>

                <br/><br/><br/><br/><br/><br/>
                <span style="float:left;font-size: 1.5em">Attending Pharmacist: ${cashier}</span>
                <br/><br/><br/><br/><br/><br/>
                <span style="margin-left: 13em;font-size: 1.5em">Signature of Inventory Clerk/ Stamp</span>
            </div>
        </div>
        <!-- END PRINT DIV -->

    </div>

</div>