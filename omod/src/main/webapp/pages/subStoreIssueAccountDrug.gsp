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
${listCategory}