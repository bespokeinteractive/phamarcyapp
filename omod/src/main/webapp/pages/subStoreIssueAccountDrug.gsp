<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module: Issue Account Drug"])
%>


<script>
    jq(function () {
        var accountName;
        var accountObject;
        var selectedDrugId;
        var isAccountCreated = false;
        jq("#issueDrugSelection").hide();
        jq("#issueDetails").hide();
        jq("#addIssueButton").on("click", function (e) {
            addissuedialog.show();
        });
        var addissuedialog = emr.setupConfirmationDialog({
            selector: '#addIssueDialog',
            actions: {
                confirm: function () {


                    jq("#issueDrugSelection").hide();
                    jq("#issueDrugKey").show();
                    addissuedialog.close();
                },
                cancel: function () {


                    jq("#issueDrugSelection").hide();
                    jq("#issueDrugKey").show();
                    addissuedialog.close();
                }
            }
        });

        jq("#issueSearchPhrase").autocomplete({
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
                jq("#issueSearchPhrase").val(ui.item.value.name);
                return false;
            },
            select: function (event, ui) {
                event.preventDefault();
                selectDrug = ui.item.value.name;
                selectedDrugId = ui.item.value.id
                jQuery("#issueSearchPhrase").val(selectDrug);

                //set parent category
                var catId = ui.item.value.category.id;
                jq("#issueDrugCategory").val(catId);

                var drugName = selectDrug;
                var drugFormulationData = "";
                jq('#issueDrugFormulation').empty();

                if (drugName === "") {
                    jq('<option value="">Select Formulation</option>').appendTo("#issueDrugFormulation");
                } else {
                    jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                        drugName: drugName
                    }).success(function (data) {
                        drugFormulationData = drugFormulationData + '<option value="">Select Formulation</option>';
                        for (var key in data) {
                            if (data.hasOwnProperty(key)) {
                                var val = data[key];
                                for (var i in val) {
                                    var name, dozage;
                                    if (val.hasOwnProperty(i)) {
                                        var j = val[i];
                                        if (i == "id") {
                                            drugFormulationData = drugFormulationData + '<option id="' + j + '">';
                                        } else if (i == "name") {
                                            name = j;
                                        }
                                        else {
                                            dozage = j;
                                            drugFormulationData = drugFormulationData + (name + "-" + dozage) + '</option>';
                                        }
                                    }
                                }
                            }

                        }

                        jq(drugFormulationData).appendTo("#issueDrugFormulation");
                    }).error(function (xhr, status, err) {
                        jq('<option value="">Select Formulation</option>').appendTo("#issueDrugFormulation");
                        jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                    });
                }


            }
        });

        jq("#issueDrugCategory").on("change", function (e) {
            var categoryId = jq(this).children(":selected").attr("value");
            var drugNameData = "";
            jq('#issueDrugName').empty();

            if (categoryId === "0") {
                jq('<option value="">Select Drug</option>').appendTo("#issueDrugName");
                jq('#issueDrugName').change();

            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "fetchDrugNames") }', {
                    categoryId: categoryId
                }).success(function (data) {
                    jQuery("#issueDrugKey").hide();
                    jQuery("#issueDrugSelection").show();
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugNameData = drugNameData + '<option id="' + j + '"' + ' value="' + j + '"';
                                    }
                                    else {
                                        drugNameData = drugNameData + 'name="' + j + '">' + j + '</option>';
                                    }
                                }
                            }
                        }
                    }

                    jq(drugNameData).appendTo("#issueDrugName");
                    jq('#issueDrugName').change();
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });

            }

        });

        jq("#issueDrugName").on("change", function (e) {
            var drugName = jq(this).children(":selected").attr("name");
            var drugId = jq(this).children(":selected").attr("id");

            selectedDrugId = drugId;

            var drugFormulationData = "";
            jq('#issueDrugFormulation').empty();

            if (jq(this).children(":selected").attr("value") === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#issueDrugFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugName: drugName
                }).success(function (data) {
                    drugFormulationData = drugFormulationData + '<option value="">Select Formulation</option>';
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                var name, dozage;
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugFormulationData = drugFormulationData + '<option id="' + j + '">';
                                    } else if (i == "name") {
                                        name = j;
                                    }
                                    else {
                                        dozage = j;
                                        drugFormulationData = drugFormulationData + (name + "-" + dozage) + '</option>';
                                    }
                                }
                            }
                        }
                    }
                    jq(drugFormulationData).appendTo("#issueDrugFormulation");
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });
            }

        });

        jq("#issueDrugFormulation").on("change", function (e) {
            var formulationId = jQuery(this).children(":selected").attr("id");
            var drugId = selectedDrugId;
            jQuery.ajax({
                type: "GET"
                , dataType: "json"
                , url: '${ ui.actionLink("pharmacyapp", "issueDrugAccountList", "listReceiptDrug") }'
                , data: ({drugId: drugId, formulationId: formulationId})
                , async: false
                , success: function (response) {
                    issueList.listReceiptDrug.removeAll();
                    jq.map(response, function (val, i) {
                        issueList.addDrugToFormulationList(val, 0);
                    });
                    if (issueList.listReceiptDrug().length === 0) {
                        jq("#issueDetails").show();
                    } else {
                        jq("#issueDetails").hide();
                    }
                },
                error: function (xhr) {
                    alert("An Error occurred");
                }
            })
        });

        function IssueViewModel() {
            var self = this;
//            Non Editable Catalogue - Comes from the server
            self.drugList = ko.observableArray([]);

//            Editable Data
            self.selectedDrugs = ko.observableArray([]);

//            List of Drugs By Formulation
            self.listReceiptDrug = ko.observableArray([]);

//            Observable account object
            self.listAccount = ko.observable();


//            Operations
            self.addDrugToList = function (item, quantity) {
                self.selectedDrugs.push(new DrugIssue(item, quantity));
            };
            self.addDrugToFormulationList = function (item, quantity) {
                self.listReceiptDrug.push(new DrugIssue(item, quantity));
            };

            self.removeDrugFromList = function (drug) {
                self.selectedDrugs.remove(drug);
            };
            self.addDrugItem = function () {
                jq.map(self.listReceiptDrug(), function (val, i) {
                    if (val.quantity() > 0) {
                        self.addDrugToList(val.item(), val.quantity());

                    }
                });
            };

            self.clearList = function () {
                if (self.selectedDrugs().length > 0) {
                    self.selectedDrugs.removeAll();
                    isAccountCreated = false;
                } else {
                    jq().toastmessage('showErrorToast', "No Drugs in Issue List!");
                }
                isAccountCreated = false;

            };

            self.returnToList = function () {
                window.location.href = emr.pageLink("pharmacyapp", "main", {
                    "tabId": "accountdrug"
                });
            };

            self.printList = function () {
                if (isAccountCreated) {
                    printAccountDiv();
                } else {
                    self.createAccount();
                }
            };
            self.processIssueDrugToAccount = function () {
                if (isAccountCreated) {
                    //process drug addition to issue list
                    indentName = JSON.stringify(indentName);

                    var addIssueDrugsData = {
                        'drugOrder': drugOrder,
                        'indentName': indentName,
                        'send': 1,
                        'action': 2,
                        'keepThis': false
                    };
                    jq.getJSON('${ ui.actionLink("pharmacyapp", "subStoreIndentDrug", "saveIndentSlip") }', addIssueDrugsData)
                            .success(function (data) {
                                jq().toastmessage('showNoticeToast', "Save Indent Successful!");
                                window.location.href = emr.pageLink("pharmacyapp", "main", {
                                    "tabId": "manage"
                                });

                            })
                            .error(function (xhr, status, err) {
                                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                            })

                } else {
                    self.createAccount();
                }
            };

            self.createAccount = function () {
                addaccountforissueslipdialog.show();
            }
        }

        function DrugIssue(item, quantity) {
            var self = this;
            self.item = ko.observable(item);
            self.quantity = ko.observable(quantity);
            self.quantity.subscribe(function (newValue) {
                if (newValue > self.item().currentQuantity) {
                    jq().toastmessage('showErrorToast', "Issue quantity is greater that available quantity!");
                    self.quantity(0);
                }
            });
        }

        function printAccountDiv() {
            var printDiv = jQuery("#printDivAccount").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Indent Slip :-Support by KenyaEHRS</title>');
            printWindow.document.write('</head>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        }

        var addaccountforissueslipdialog = emr.setupConfirmationDialog({
            selector: '#addAccountForIssueSlip',
            actions: {
                confirm: function () {
                    if (jq("#accountName").val() == '') {
                        jq().toastmessage('showNoticeToast', "Enter Account Name!");
                    } else {
                        accountName = jq("#accountName").val();
                        var addAccountNameData = {
                            'accountName': accountName
                        };

                        jq.ajax({
                            url:'${ ui.actionLink("pharmacyapp", "issueDrugAccountList", "postAccountName") }',
                            data: addAccountNameData,
                            type: "get",
                            dataType:"json",
                            async: false,
                            success: function (data) {
                                var result = data.message;
                                issueList.listAccount(result);
                                console.log(issueList.listAccount());
                                if (result === "error") {
                                    jq().toastmessage('showErrorToast', "Error Saving Account!");
                                    issueList.listAccount();
                                    isAccountCreated = false;
                                } else {
                                    jq().toastmessage('showNoticeToast', "Save Account Successful!");
                                    issueList.listAccount(result);
                                    accountObject = result;
                                    isAccountCreated = true;
                                }
                            },
                            error: function (xhr, status, err) {
                                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                            }
                        });

                        console.log(accountObject);

                        addaccountforissueslipdialog.close();
                        printAccountDiv();
                    }
                },
                cancel: function () {
                    addaccountforissueslipdialog.close();
                }
            }
        });

        var issueList = new IssueViewModel();
        ko.applyBindings(issueList, jq("#accountDrugIssue")[0]);
    });//end of doc ready
</script>

<div class="clear"></div>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Pharmacy Module
            </li>
        </ul>
    </div>

    <div class="patient-header new-patient-header" id="accountDrugIssue">
        <div class="dashboard clear">
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>Issue Drugs to Account</h3>
                </div>
            </div>

            <div data-bind="visible: listAccount">
                <h3>Account: <span data-bind="text: listAccount"></span></h3>
            </div>
        </div>

        <div>
            <table id="addDrugsAccount" class="dataTable">
                <thead>
                <tr role="row">
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">S.No<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Category<span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Name<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Formulation<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Quantity<span class="DataTables_sort_icon"></span></div>
                    </th>
                    <th class="ui-state-default">

                    </th>
                </tr>
                </thead>

                <tbody data-bind="foreach: selectedDrugs">
                <tr>
                    <td data-bind="text: \$index() + 1"></td>
                    <td data-bind="text: item().drug.category.name"></td>
                    <td data-bind="text: item().drug.name"></td>
                    <td>
                        <span data-bind="text: item().formulation.name"></span>-
                        <span data-bind="text: item().formulation.dozage"></span>
                    </td>
                    <td data-bind="text: quantity"></td>
                    <td>
                        <a class="remover" href="#" data-bind="click: \$root.removeDrugFromList">
                            <i class="icon-remove small" style="color:red"></i>
                        </a>
                    </td>
                </tr>
                </tbody>
            </table>

            <input type="button" value="Clear List" class="button cancel" name="clearAccountList" id="clearAccountList"
                   style="float: right; margin-top:20px;"
                   data-bind="click: \$root.clearList ,visible: \$root.selectedDrugs().length > 0">
            <input type="button" value="Add To Issue Slip" class="button confirm" name="addIssueButton"
                   id="addIssueButton"
                   style="margin-top:20px;">

            <input type="button" value="Back To List" class="button confirm" name="returnToDrugList"
                   id="returnToDrugList" style="margin-top:20px;" data-bind="click: \$root.returnToList">
            <input type="button" value="Print" class="button confirm" name="printIndent"
                   id="printIndent" style="margin-top:20px;"
                   data-bind="click: \$root.printList,visible: \$root.selectedDrugs().length > 0">
            <input type="button" value="Finish" class="button confirm" name="addDrugsSubmitButton"
                   id="addDrugsSubmitButton" style="margin-top:20px;"
                   data-bind="click: \$root.processIssueDrugToAccount,visible: \$root.selectedDrugs().length > 0">
        </div>

        <div id="addIssueDialog" class="dialog" style="display: none; width: 80%">
            <div class="dialog-header">
                <i class="icon-folder-open"></i>

                <h3>Drug Information</h3>
            </div>

            <form id="issueDialogForm">

                <div class="dialog-content">
                    <ul>
                        <li>
                            <label for="issueDrugCategory">Drug Category</label>
                            <select name="issueDrugCategory" id="issueDrugCategory">
                                <option value="0">Select Category</option>
                                <% if (listCategory != null || listCategory != "") { %>
                                <% listCategory.each { drugCategory -> %>
                                <option id="${drugCategory.id}" value="${drugCategory.id}">${drugCategory.name}</option>
                                <% } %>
                                <% } %>
                            </select>
                        </li>
                        <li>
                            <div id="issueDrugKey">
                                <label for="issueSearchPhrase">Drug Name</label>
                                <input id="issueSearchPhrase" name="issueSearchPhrase"/>
                            </div>

                            <div id="issueDrugSelection">
                                <label for="issueDrugName">Drug Name</label>
                                <select name="issueDrugName" id="issueDrugName">
                                    <option value="0">Select Drug</option>
                                </select>
                            </div>
                        </li>
                        <li>
                            <lable for="issueDrugFormulation">Formulation</lable>
                            <select name="issueDrugFormulation" id="issueDrugFormulation">
                                <option value="0">Select Formulation</option>
                            </select>
                        </li>

                        <div id="issueDetails" style="color: red;">
                            This Drug is empty in your store please indent it!
                        </div>

                        <div id="issueDetailsList" data-bind="visible: \$root.listReceiptDrug().length > 0">
                            <form method="post" id="processDrugOrderForm" class="box">
                                <table>
                                    <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>Expiry</th>
                                        <th title="Date of manufacturing">DM</th>
                                        <th>Company</th>
                                        <th>Batch No.</th>
                                        <th title="Quantity available">Available</th>
                                        <th title="Issue quantity">Issue</th>
                                    </tr>
                                    </thead>
                                    <tbody data-bind="foreach: listReceiptDrug">
                                    <tr>
                                        <td data-bind="text: \$index() + 1"></td>
                                        <td data-bind="text: item().dateExpiry"></td>
                                        <td data-bind="text: item().dateManufacture"></td>
                                        <td data-bind="text: item().companyNameShort"></td>
                                        <td data-bind="text: item().batchNo"></td>
                                        <td data-bind="text: item().currentQuantity"></td>
                                        <td><input data-bind="value: quantity"></td>
                                    </tr>
                                    </tbody>
                                </table>
                                <br/>
                            </form>
                        </div>
                        <button class="button confirm right" data-bind="click: \$root.addDrugItem"
                                id="drugIssue">Add Drug</button>
                        <span class="button cancel">Cancel</span>
                    </ul>
                </div>

                <div id="addAccountForIssueSlip" class="dialog">
                    <div class="dialog-header">
                        <i class="icon-folder-open"></i>

                        <h3>Add Account For Slip</h3>
                    </div>

                    <div class="dialog-content">
                        <ul>
                            <li>
                                <form id="createAccountForm">
                                    <lable for="accountName">Name</lable>
                                    <input type="text" name="accountName" id="accountName"/>
                                </form>
                            </li>
                        </ul>

                        <span class="button confirm right">Confirm</span>
                        <span class="button cancel">Cancel</span>
                    </div>
                </div>
            </form>
        </div>

        <!-- PRINT DIV -->
        <div id="printDivAccount" style="display: none;">
            <div style="margin: 10px auto; width: 981px; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">

                <br/>
                <br/>
                <center style="float:center;font-size: 2.2em">Issue Drugs To Account:</center>
                <br/>
                <br/>
                <span style="float:right;font-size: 1.7em">Date: ${date}</span>
                <br/>
                <br/>

                <div>
                    <table id="addDrugsAccountPrint" class="dataTable">
                        <thead>
                        <tr role="row">
                            <th class="ui-state-default">
                                <div class="DataTables_sort_wrapper">S.No<span class="DataTables_sort_icon"></span>
                                </div>
                            </th>

                            <th class="ui-state-default">
                                <div class="DataTables_sort_wrapper">Drug Category<span
                                        class="DataTables_sort_icon"></span>
                                </div>
                            </th>

                            <th class="ui-state-default">
                                <div class="DataTables_sort_wrapper">Drug Name<span class="DataTables_sort_icon"></span>
                                </div>
                            </th>

                            <th class="ui-state-default">
                                <div class="DataTables_sort_wrapper">Formulation<span
                                        class="DataTables_sort_icon"></span></div>
                            </th>

                            <th class="ui-state-default">
                                <div class="DataTables_sort_wrapper">Quantity<span class="DataTables_sort_icon"></span>
                                </div>
                            </th>
                            <th class="ui-state-default">

                            </th>
                        </tr>
                        </thead>

                        <tbody data-bind="foreach: selectedDrugs">
                        <tr>
                            <td data-bind="text: \$index() + 1"></td>
                            <td data-bind="text: item().drug.category.name"></td>
                            <td data-bind="text: item().drug.name"></td>
                            <td>
                                <span data-bind="text: item().formulation.name"></span>-
                                <span data-bind="text: item().formulation.dozage"></span>
                            </td>
                            <td data-bind="text: quantity"></td>
                            <td>
                                <a class="remover" href="#" data-bind="click: \$root.removeDrugFromList">
                                    <i class="icon-remove small" style="color:red"></i>
                                </a>
                            </td>
                        </tr>
                        </tbody>
                    </table>
                </div>
                <br/><br/><br/><br/><br/><br/>
                <span style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
            </div>
        </div>
        <!-- END PRINT DIV -->

    </div>

</div>


