<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
%>

<script>
    jq(function () {
        var cleared = false;
        var drugOrder = [];
        var indentName = [];
        var adddrugdialog = emr.setupConfirmationDialog({
            selector: '#addDrugDialog',
            actions: {
                confirm: function () {
                    if (jq("#drugCategory").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Category!");
                    } else if (jq("#drugName").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Name!");
                    } else if (jq("#drugFormulation").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Formulation!");
                    } else if (isNaN(parseInt(jq("#quantity").val()))) {
                        jq().toastmessage('showNoticeToast', "Enter correct quantity!");
                    } else {
                        if (cleared) {
                            jq('#addDrugsTable > tbody > tr').remove();
                            var tbody = jq('#addDrugsTable > tbody');
                            cleared = false;
                        }
                        var tbody = jq('#addDrugsTable').children('tbody');
                        var table = tbody.length ? tbody : jq('#addDrugsTable');
                        var index = drugOrder.length + 1;
                        table.append('<tr><td>' + index + '</td><td>' + jq("#drugCategory").val() + '</td><td>' + jq("#drugName").val() + '</td><td>' + jq("#drugFormulation option:selected").text() + '</td><td>' + jq("#quantity").val() + '</td></tr>');
                        drugOrder.push(
                                {
                                    drugCategoryId: jq("#drugCategory").children(":selected").attr("id"),
                                    drugId: jq("#drugName").children(":selected").attr("id"),
                                    drugFormulationId: jq("#drugFormulation").children(":selected").attr("id"),
                                    quantity: jq("#quantity").val()
                                }
                        );
                        adddrugdialog.close();
                    }
                },
                cancel: function () {
                    adddrugdialog.close();
                }
            }
        });

        var addnameforindentslipdialog = emr.setupConfirmationDialog({
            selector: '#addNameForIndentSlip',
            actions: {
                confirm: function () {
                    if (jq("#indentName").val() == '') {
                        jq().toastmessage('showNoticeToast', "Enter Indent Name!");
                    } else if (jq("#mainstore").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Main Store!");
                    } else {
                        indentName.push(
                                {
                                    indentName: jq("#indentName").val(),
                                    mainstore: jq("#mainstore").children(":selected").attr("id")
                                }
                        );
                        drugOrder = JSON.stringify(drugOrder);
                        indentName = JSON.stringify(indentName);

                        var addDrugsData = {
                            'drugOrder': drugOrder,
                            'indentName': indentName
                        };
                        jq.getJSON('${ ui.actionLink("pharmacyapp", "subStoreIndentDrug", "saveIndentSlip") }', addDrugsData)
                                .success(function (data) {
                                    jq().toastmessage('showNoticeToast', "Save Indent Successful!");
                                    window.location.href = emr.pageLink("pharmacyapp", "main", {
                                        "tabId": "manage"
                                    });

                                })
                                .error(function (xhr, status, err) {
                                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                                })
                        addnameforindentslipdialog.close();
                    }
                },
                cancel: function () {
                    addnameforindentslipdialog.close();
                }
            }
        });


        jq("#addDrugsButton").on("click", function (e) {
            adddrugdialog.show();
        });
        jq("#clearIndent").on("click", function (e) {
            if (confirm("Are you sure about this?")) {
                drugOrder = [];
                jq('#addDrugsTable > tbody > tr').remove();
                var tbody = jq('#addDrugsTable > tbody');
                var row = '<tr align="center"><td colspan="5">No Drugs Listed</td></tr>';
                tbody.append(row);
                cleared = true;
            } else {
                return false;
            }
        });
        jq("#returnToDrugList").on("click", function (e) {
            window.location.href = emr.pageLink("pharmacyapp", "main", {
                "tabId": "manage"
            });
        });
        jq("#drugCategory").on("change", function (e) {
            var categoryId = jq(this).children(":selected").attr("id");
            var drugNameData = "";
            jq.getJSON('${ ui.actionLink("inventoryapp", "addReceiptsToStore", "fetchDrugNames") }', {
                categoryId: categoryId
            }).success(function (data) {

                for (var key in data) {
                    if (data.hasOwnProperty(key)) {
                        var val = data[key];
                        for (var i in val) {
                            if (val.hasOwnProperty(i)) {
                                var j = val[i];
                                if (i == "id") {
                                    drugNameData = drugNameData + '<option id="' + j + '"';
                                }
                                else {
                                    drugNameData = drugNameData + 'name="' + j + '">' + j + '</option>';
                                }
                            }
                        }
                    }
                }
                jq(drugNameData).appendTo("#drugName");
            }).error(function (xhr, status, err) {
                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
            });
        });

        jq("#drugName").on("change", function (e) {
            var drugName = jq(this).children(":selected").attr("name");
            var drugFormulationData = "";
            jq.getJSON('${ ui.actionLink("inventoryapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                drugName: drugName
            }).success(function (data) {
                for (var key in data) {
                    if (data.hasOwnProperty(key)) {
                        var val = data[key];
                        for (var i in val) {
                            if (val.hasOwnProperty(i)) {
                                var j = val[i];
                                if (i == "id") {
                                    drugFormulationData = drugFormulationData + '<option id="' + j + '">';
                                }
                                else {
                                    drugFormulationData = drugFormulationData + j + '</option>';
                                }
                            }
                        }
                    }
                }
                jq(drugFormulationData).appendTo("#drugFormulation");
            }).error(function (xhr, status, err) {
                jq().toastmessage('showNoticeToast', "AJAX error!" + err);
            });
        });

        jq("#addDrugsSubmitButton").click(function (event) {
            addnameforindentslipdialog.show();

        });

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

    <div class="patient-header new-patient-header">
        <div class="dashboard clear">
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>Indent Slip of Pharmacy</h3>
                </div>
            </div>
        </div>

        <div>
            <table id="addDrugsTable" class="dataTable">
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
                </tr>
                </thead>

                <tbody>
                </tbody>
            </table>

            <input type="button" value="Clear Indent" class="button cancel" name="clearIndent" id="clearIndent"
                   style="float: right; margin-top:20px;">


            <input type="button" value="Add Drug" class="button confirm" name="addDrugsButton" id="addDrugsButton"
                   style="margin-top:20px;">
            <input type="button" value="Save and Send" class="button confirm" name="addDrugsSubmitButton"
                   id="addDrugsSubmitButton" style="margin-top:20px;">
            <input type="button" value="Back To Drug List" class="button confirm" name="returnToDrugList"
                   id="returnToDrugList" style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printIndent"
                   id="printIndent" style="margin-top:20px;">
        </div>

    </div>

    <div id="addDrugDialog" class="dialog">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Drug Information</h3>
        </div>

        <div class="dialog-content">
            <ul>
                <li>
                    <label for="drugCategory">Drug Category</label>
                    <select name="drugCategory" id="drugCategory">
                        <option value="0">Select Category</option>
                        <% if (listCategory != null || listCategory != "") { %>
                        <% listCategory.each { drugCategory -> %>
                        <option id="${drugCategory.id}" value="${drugCategory.id}">${drugCategory.name}</option>
                        <% } %>
                        <% } %>
                    </select>
                </li>
                <li>
                    <label for="drugName">Drug Name</label>
                    <select name="drugName" id="drugName">
                        <option value="0">Select Drug</option>
                    </select>
                </li>
                <li>
                    <lable for="drugFormulation">Formulation</lable>
                    <select name="drugFormulation" id="drugFormulation">
                        <option value="0">Select Formulation</option>
                    </select>
                </li>

                <li>
                    <label for="quantity">Quantity</label>
                    <input name="quantity" id="quantity" type="text">
                </li>

            </ul>

            <span class="button confirm right">Confirm</span>
            <span class="button cancel">Cancel</span>
        </div>
    </div>

    <div id="addNameForIndentSlip" class="dialog">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Add Name For Indent Slip</h3>
        </div>

        <div class="dialog-content">
            <ul>
                <li>
                    <lable for="indentName">Name</lable>
                    <input type="text" name="indentName" id="indentName"/>
                </li>
                <li>
                    <label for="mainstore">Select Main Store Indent</label>
                    <select name="mainstore" id="mainstore">
                        <option value="0">Select Store</option>
                        <% if (store != null || store != "") { %>
                        <% store.parentStores.each { vparent -> %>
                        <option id="${vparent.id}">${vparent.name}</option>
                        <% } %>
                        <% } %>
                    </select>
                </li>
            </ul>

            <span class="button confirm right">Confirm</span>
            <span class="button cancel">Cancel</span>
        </div>
    </div>
</div>