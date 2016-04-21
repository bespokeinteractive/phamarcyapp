<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module: Issue Account Drug"])
%>

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


            <input type="button" value="Add To Issue Slip" class="button confirm" name="addIssueButton" id="addIssueButton"
                   style="margin-top:20px;">

            <input type="button" value="Back To List" class="button confirm" name="returnToDrugList"
                   id="returnToDrugList" style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printIndent"
                   id="printIndent" style="margin-top:20px;">
            <input type="button" value="Finish" class="button confirm" name="addDrugsSubmitButton"
                   id="addDrugsSubmitButton" style="margin-top:20px;">
        </div>

    </div>

</div>