<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Issue Drug"])
%>

<script>
    var drugIdnt = 0;
    var issueList;

    jq(function () {
        jq("#issueDetails").hide();
        var cleared = false;
        jq("#drugSelection").hide();

        var slipName = [];

        function IssueViewModel() {
            var self = this;

//            Editable Data
            self.drugOrder = ko.observableArray([]);

//            List of Drugs By Formulation
            self.listReceiptDrug = ko.observableArray([]);

//            Operations
            self.addDrugToList = function (item, quantity) {
                self.drugOrder.push(new DrugIssue(item, quantity));
            };


            self.removeDrugFromList = function (drug) {
                self.drugOrder.remove(drug);
            };

            self.addDrugItem = function () {
                processCounts = 0;

                jq.map(self.listReceiptDrug(), function (val, i) {
                    if (val.quantity() > 0) {
                        self.addDrugToList(val.item(), val.quantity());
                        processCounts++;
                    }
                });
            };

            self.clearList = function () {
                if (self.drugOrder().length > 0) {
                    self.drugOrder().removeAll();
                } else {
                    jq().toastmessage('showErrorToast', "No Drugs in Issue List!");
                }
            };

            self.returnToList = function () {
                window.location.href = emr.pageLink("pharmacyapp", "container", {
                    "rel": "issue-to-patient"
                });
            };

            self.printList = function () {
                if (isAccountCreated) {
                    printAccountDiv();
                } else {
                    jq().toastmessage('showErrorToast', "Create Issue Account!");
                }
            };
            self.processIssueDrugToAccount = function () {
                if (isAccountCreated) {
                    //process drug addition to issue list
                    accountObject = JSON.stringify(accountObject);
                    var drugsJson = ko.toJSON(self.selectedDrugs());

                    var addIssueDrugsData = {
                        'accountObject': accountObject,
                        'selectedDrugs': drugsJson
                    };
                    jq.getJSON('${ ui.actionLink("pharmacyapp", "issueDrugAccountList", "processIssueDrugAccount") }', addIssueDrugsData)
                            .success(function (data) {
                                jq().toastmessage('showNoticeToast', "Save Indent Successful!");
                                window.location.href = emr.pageLink("pharmacyapp", "main", {
                                    "tabId": "accountdrug"
                                });

                            })
                            .error(function (xhr, status, err) {
                                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                            })

                } else {
                    jq().toastmessage('showErrorToast', "Create Issue Account!");
                }
            };

        }

        var addpatientdrugdialog = emr.setupConfirmationDialog({
            selector: '#addPatientDrugDialog',
            actions: {
                confirm: function () {
                    if (jq("#issueDrugCategory").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Category!");
                    } else if (jq("#drugPatientName").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Name!");
                    } else if (jq("#drugPatientFormulation").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Formulation!");
                    } else {
                        if (cleared) {
                            jq('#addDrugsTable > tbody > tr').remove();
                            var tbody = jq('#addDrugsTable > tbody');
                            cleared = false;
                        }
                        var tbody = jq('#addDrugsTable').children('tbody');


                        var commt = jq('#comment').val().trim();

                        if (commt == '') {
                            commt = 'N/A'
                        }

                        issueList.drugOrder.push(
                                {
                                    issueDrugCategoryId: jq("#issueDrugCategory").children(":selected").attr("id"),
                                    drugId: jq("#drugPatientName").children(":selected").attr("id"),
                                    drugPatientFormulationId: jq("#drugPatientFormulation").children(":selected").attr("id"),
                                    noOfDays: jq("#patientNoOfDays").val(),
                                    issueDrugCategoryName: jq('#issueDrugCategory :selected').text(),
                                    drugPatientName: jq('#drugPatientName :selected').text(),
                                    drugPatientFormulationName: jq('#drugPatientFormulation :selected').text(),
                                    drugPatientFrequencyName: jq('#patientFrequency :selected').text(),
                                    drugPatientFrequencyId: jq("#patientFrequency").children(":selected").attr("id"),
                                    issueComment: commt
                                }
                        );

                        jq("#patientQuantity").val('');
                        jQuery("#drugKey").show();
                        jQuery("#drugSelection").hide();

                        addpatientdrugdialog.close();
                    }

                },
                cancel: function () {
                    jq("#patientQuantity").val('');
                    jQuery("#drugKey").show();
                    jQuery("#drugSelection").hide();

                    addpatientdrugdialog.close();
                }
            }
        });

        jq("#addPatientDrugsButton").on("click", function (e) {
            jq('#issueDrugCategory option').eq(0).prop('selected', true).change();
            jq("#searchPhrase").val('');
            jq("#comment").val('');
            jq("#patientNoOfDays").val('');
            jq("#drugKey").show();
            jq("#drugSelection").hide();

            addpatientdrugdialog.show();
        });

        jq("#printSlip").on("click", function (e) {
            if (issueList.drugOrder().length === 0) {
                jq().toastmessage('showErrorToast', "No drugs added to the List!");
                return false;
            }

            jq('#printList > tbody > tr').remove();
            var tbody = jq('#printList > tbody');


            var printDiv = jQuery("#printDiv").html();

            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Drug Slip :-Support by KenyaEHRS</title>');
            printWindow.document.write('</head>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();

        });

        jq("#saveSlip").on("click", function () {
            if (issueList.drugOrder().length === 0) {
                jq().toastmessage('showErrorToast', "No drugs added to the List!");
                return false
            } else {
                //process drug addition to issue list
                accountObject = JSON.stringify(accountObject);
                var drugsJson = ko.toJSON(self.selectedDrugs());

                var addIssueDrugsData = {
                    'accountObject': accountObject,
                    'selectedDrugs': drugsJson
                };
                jq.getJSON('${ ui.actionLink("pharmacyapp", "issueDrugAccountList", "processIssueDrugAccount") }', addIssueDrugsData)
                        .success(function (data) {
                            jq().toastmessage('showNoticeToast', "Save Indent Successful!");
                            window.location.href = emr.pageLink("pharmacyapp", "main", {
                                "tabId": "accountdrug"
                            });

                        })
                        .error(function (xhr, status, err) {
                            jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                        })
            }


            //Code for Saving here

            //redirect Successful Saving
            window.location.href = emr.pageLink("pharmacyapp", "container", {"rel": "issue-to-patient"});
        });

        jq("#issueDrugCategory").on("change", function (e) {
            var categoryId = jq(this).children(":selected").attr("value");
            var drugPatientNameData = "";
            jq('#drugPatientName').empty();

            if (categoryId === "0") {
                jq('<option value="">Select Drug</option>').appendTo("#drugPatientName");
                jq('#drugPatientName').change();

            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "fetchDrugNames") }', {
                    categoryId: categoryId
                }).success(function (data) {


                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugPatientNameData = drugPatientNameData + '<option id="' + j + '"' + ' value="' + j + '"';
                                    }
                                    else {
                                        drugPatientNameData = drugPatientNameData + 'name="' + j + '">' + j + '</option>';
                                    }
                                }
                            }
                        }
                    }

                    jq(drugPatientNameData).appendTo("#drugPatientName");
                    jq('#drugPatientName').change();

                    if (jq('#searchPhrase').val() !== "") {
                        jq("select option").filter(function () {
                            return jq(this).text() == jq('#searchPhrase').val();
                        }).prop('selected', true);

                        if (jq("#drugPatientName").children(":selected").text() != jq('#searchPhrase').val()) {
                            jq('#searchPhrase').val('');

                            jq("#drugKey").hide();
                            jq("#drugSelection").show();
                        }

                        jq('#drugPatientName').change();
                    }
                    else {
                        jq("#drugKey").hide();
                        jq("#drugSelection").show();
                    }
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });

            }

        });

        jq("#drugPatientName").on("change", function (e) {
            var drugPatientName = jq(this).children(":selected").attr("name");
            var drugPatientFormulationData = "";
            jq('#drugPatientFormulation').empty();

            if (jq(this).children(":selected").attr("value") === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#drugPatientFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugName: drugPatientName
                }).success(function (data) {
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                var name, dozage;
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugPatientFormulationData = drugPatientFormulationData + '<option id="' + j + '">';
                                    } else if (i == "name") {
                                        name = j;
                                    }
                                    else {
                                        dozage = j;
                                        drugPatientFormulationData = drugPatientFormulationData + (name + "-" + dozage) + '</option>';
                                    }
                                }
                            }
                        }
                    }
                    jq(drugPatientFormulationData).appendTo("#drugPatientFormulation");
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });
            }

        });

        jq("#searchPhrase").autocomplete({
            minLength: 3,
            source: function (request, response) {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "fetchDrugListByName") }',
                        {
                            searchPhrase: request.term
                        }
                ).success(function (data) {
                            var results = [];
                            for (var i in data) {
                                var result = {label: data[i].name, value: data[i]};
                                results.push(result);
                            }
                            response(results);
                        });
            },
            focus: function (event, ui) {
                jq("#searchPhrase").val(ui.item.value.name);
                return false;
            },
            select: function (event, ui) {
                event.preventDefault();
                jQuery("#searchPhrase").val(ui.item.value.name);

                //set parent category
                var catId = ui.item.value.category.id;
                var drgId = ui.item.value.id;
                console.log(drgId);

                jq("#issueDrugCategory").val(catId).change();
                //set background drug name - frusemide
                jq('#drugPatientName').val(drgId);


            }
        });


        issueList = new IssueViewModel();
        ko.applyBindings(issueList, jq("#accountDrugIssue")[0]);

    });//end of doc ready



</script>

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

.toast-item {
    background-color: #222;
}

.name {
    color: #f26522;
}

#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
    text-decoration: none;
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
    margin: 35px 10px 0 0;
}

.title {
    border: 1px solid #eee;
    margin: 3px 0;
    padding: 5px;
}

.title i {
    font-size: 1.5em;
    padding: 0;
}

.title span {
    font-size: 20px;
}

.title em {
    border-bottom: 1px solid #ddd;
    color: #888;
    display: inline-block;
    font-size: 0.5em;
    margin-right: 10px;
    text-transform: lowercase;
    width: 200px;
}

table {
    font-size: 14px;
}

th:first-child {
    width: 5px;
}

th:nth-child(4) {
    min-width: 40px;
}

th:nth-child(5) {
    width: 40px;
}

th:last-child {
    width: 55px;
}

th:nth-child(6) {
    min-width: 40px;
}

.dialog .dialog-content li {
    margin-bottom: 0px;
}

.dialog label {
    display: inline-block;
    width: 115px;
}

.dialog select option {
    font-size: 1.0em;
}

.dialog select {
    display: inline-block;
    margin: 4px 0 0;
    width: 270px;
}

.dialog input {
    display: inline-block;
    width: 248px;
    min-width: 10%;
}

.dialog textarea {
    display: inline-block;
    width: 248px;
    min-width: 10%;
    resize: none
}

form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus {
    outline: 2px none #007fff;
}
</style>

<div class="container" id="accountDrugIssue">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('pharmacyapp', 'dashboard')}">Pharmacy</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                <a href="${ui.pageLink('pharmacyapp', 'container', [rel: 'issue-to-patient'])}">Get Patient</a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Issue Drug
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
                    <span id="agename">${age} years (${ui.formatDatePretty(birthdate)})</span>

                </span>
            </h1>

            <br/>

            <div id="stacont" class="status-container">
                <span class="status active"></span>
                Visit Status
            </div>

            <div class="tag">Outpatient</div>

            <div class="tad" id="lstdate">Last Visit: ${ui.formatDatetimePretty(lastVisit)}</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${identifier}</span>
            <br>

            <div class="catg">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small>${category}
            </div>
        </div>

        <div class="close"></div>
    </div>

    <div class="title">
        <i class="icon-quote-left"></i>
        <span>
            DRUGS SLIP
            <em>&nbsp; of pharmacy</em>
        </span>
    </div>

    <table id="addDrugsTable" class="dataTable">
        <thead>
        <tr role="row">
            <th>#</th>
            <th>DRUG CATEGORY</th>
            <th>DRUG NAME</th>
            <th>FORMULATION</th>
            <th>FREQUENCY</th>
            <th># Of DAYS</th>
            <th>COMMENT</th>
            <th>QUANTITY</th>
            <th>PRICE</th>
            <th>TOTAL</th>
        </tr>
        </thead>

        <tbody data-bind="foreach: drugOrder">
        <tr>
            <td data-bind="text: \$index() + 1"></td>
            <td data-bind="text: issueDrugCategoryName"></td>
            <td data-bind="text: drugPatientName"></td>
            <td data-bind="text: drugPatientFormulationName"></td>
            <td data-bind="text: drugPatientFrequencyName"></td>
            <td data-bind="text: noOfDays"></td>
            <td data-bind="text: issueComment"></td>
            <td data-bind="text: issueComment"></td>
            <td data-bind="text: issueComment"></td>
            <td data-bind="text: issueComment"></td>

        </tr>
        </tbody>
    </table>

    <div class="container">
        <input type="button" value="Issue Drug" class="button confirm" name="addPatientDrugsButton"
               id="addPatientDrugsButton"
               style="margin-top:20px;">

        <span id="saveSlip" class="button task right" type="button" style="margin-top:20px;">
            <i class="icon-save small"></i>
            Finish
        </span>

        <span id="printSlip" class="button task right" type="button" style="margin:20px 5px 0 0;">
            <i class="icon-print small"></i>
            Print
        </span>
    </div>

    <div id="addPatientDrugDialog" class="dialog" style="width: 900px">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Drug Information</h3>
        </div>

        <form id="dialogForm">
            <div class="dialog-content">
                <ul>
                    <li>
                        <label for="issueDrugCategory">Drug Category</label>
                        <select name="issueDrugCategory" id="issueDrugCategory">
                            <option value="0">Select Category</option>
                            <% if (listCategory != null || listCategory != "") { %>
                            <% listCategory.each { issueDrugCategory -> %>
                            <option id="${issueDrugCategory.id}"
                                    value="${issueDrugCategory.id}">${issueDrugCategory.name}</option>
                            <% } %>
                            <% } %>
                        </select>
                    </li>
                    <li>
                        <div id="drugKey">
                            <label for="searchPhrase">Drug Name</label>
                            <input id="searchPhrase" name="searchPhrase"/>
                        </div>

                        <div id="drugSelection">
                            <label for="drugPatientName">Drug Name</label>
                            <select name="drugPatientName" id="drugPatientName"/>
                            <option value="0">Select Drug</option>
                        </select>
                        </div>
                    </li>
                    <li>
                        <label for="drugPatientFormulation">Formulation</label>
                        <select name="drugPatientFormulation" id="drugPatientFormulation"/>
                        <option value="0">Select Formulation</option>
                    </select>
                    </li>
                    <li>
                        <label for="drugPatientFormulation">Frequency</label>
                        <select name="patientFrequency" id="patientFrequency"/>
                        <option value="0">Select Frequency</option>
                        <% drugFrequencyList.each { dfl -> %>
                        <option value="${dfl.conceptId}">${dfl.name}</option>
                        <% } %>
                    </select>
                    </li>

                    <li>
                        <label for="patientNoOfDays"># of Days</label>
                        <input name="patientNoOfDays" id="patientNoOfDays" type="text"/>
                    </li>
                    <li>
                        <label for="comment">Comments</label>
                        <textarea name="comment" id="comment" type="text"></textarea>
                    </li>

                    <div id="issueDetails" style="color: red;">
                        This Drug is empty in your store please indent it!
                    </div>

                    <div id="issueDetailsList" data-bind="visible: \$root.listReceiptDrug().length > 0">
                        <form method="post" id="processDrugOrderForm" class="box">
                            <table id="dialog-table">
                                <thead>
                                <tr>
                                    <th>#</th>
                                    <th>EXPIRY</th>
                                    <th title="Date of manufacturing">DM</th>
                                    <th>COMPANY</th>
                                    <th>BATCH#</th>
                                    <th title="Quantity available">AVAILABLE</th>
                                    <th title="Issue quantity">ISSUE</th>
                                </tr>
                                </thead>
                                <tbody data-bind="foreach: listReceiptDrug">
                                <tr>
                                    <td data-bind="text: \$index() + 1"></td>
                                    <td data-bind="text: (item().dateExpiry).substring(0,11)"></td>
                                    <td data-bind="text: item().dateManufacture"></td>
                                    <td data-bind="text: item().companyNameShort"></td>
                                    <td data-bind="text: item().batchNo"></td>
                                    <td data-bind="text: item().currentQuantity"></td>
                                    <td><input class="input-quantity" data-bind="value: quantity"></td>
                                </tr>
                                </tbody>
                            </table>
                            <br/>
                        </form>
                    </div>

                </ul>

                <span class="button confirm right">Confirm</span>
                <span class="button cancel">Cancel</span>
            </div>
        </form>
    </div>
    <!-- PRINT DIV -->
    <div id="printDiv" style="display: none;">
        <div style="margin: 10px auto; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
            <br/>
            <br/>
            <center style="font-size: 2.2em">Drug Slip From ${store.name}</center>
            <br/>
            <br/>
            <span style="float:right;font-size: 1.7em">Date: ${date}</span>
            <br/>
            <br/>

            <table border="1" id="printList">
                <thead>
                <tr role="row">
                    <th style="width: 5%">S.No</th>
                    <th style="width: 5%">Drug Category</th>
                    <th style="width: 5%">Drug Name</th>
                    <th style="width: 5%">Formulation</th>
                    <th style="width: 5%">Quantity</th>
                </tr>
                </thead>

                <tbody>
                </tbody>

            </table>
            <br/><br/><br/><br/><br/><br/>
            <span style="float:left;font-size: 1.5em">Signature of Pharmacist/ Stamp</span>
            <br/><br/><br/><br/><br/><br/>
            <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
        </div>
    </div>
    <!-- END PRINT DIV -->

</div>






