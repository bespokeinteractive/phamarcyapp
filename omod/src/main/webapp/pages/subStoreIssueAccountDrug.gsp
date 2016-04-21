<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module: Issue Account Drug"])
%>


<script>
    jq(function () {
        jq("#issueDrugSelection").hide();
        jq("#addIssueButton").on("click", function (e) {
            addissuedialog.show();
        });
        var addissuedialog = emr.setupConfirmationDialog({
            selector: '#addIssueDialog',
            actions: {
                confirm: function () {

                    addissuedialog.close();
                },
                cancel: function () {
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

        function IssueViewModel() {
            var self = this;
//            Non Editable Catalogue - Comes from the server
            self.drugList = ko.observableArray([]);

//            Editable Data
            self.selectedDrugs = ko.observableArray([]);

//            Operations
            self.addDrugToList = function (item) {
                self.selectedDrugs.push(new DrugIssue(item));
            }

            self.removeDrugFromList = function (drug) {
                self.selectedDrugs.remove(drug);
            }
        }

        function DrugIssue(item) {
            var self = this;
            self.item = ko.observable(item);
        }

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

                <tbody>
                </tbody>
            </table>

            <input type="button" value="Clear Iist" class="button cancel" name="clearAccountList" id="clearAccountList"
                   style="float: right; margin-top:20px;">
            <input type="button" value="Add To Issue Slip" class="button confirm" name="addIssueButton"
                   id="addIssueButton"
                   style="margin-top:20px;">

            <input type="button" value="Back To List" class="button confirm" name="returnToDrugList"
                   id="returnToDrugList" style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printIndent"
                   id="printIndent" style="margin-top:20px;">
            <input type="button" value="Finish" class="button confirm" name="addDrugsSubmitButton"
                   id="addDrugsSubmitButton" style="margin-top:20px;">
        </div>

        <div id="addIssueDialog" class="dialog" style="display: none;">
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
                                <input id="issueSearchPhrase" name="issueSearchPhrase"
                                       onblur="loadDrugFormulations();"/>
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
                    </ul>
                    <span class="button confirm right">Confirm</span>
                    <span class="button cancel">Cancel</span>
                </div>
            </form>
        </div>

    </div>

</div>
