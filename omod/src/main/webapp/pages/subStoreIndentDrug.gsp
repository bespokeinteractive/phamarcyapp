<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
%>

<script>
    jq(function () {
        var drugOrder = [];
        var adddrugdialog = emr.setupConfirmationDialog({
            selector: '#addDrugDialog',
            actions: {
                confirm: function () {
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
                },
                cancel: function () {
                    adddrugdialog.close();
                }
            }
        });

        jq("#addDrugsButton").on("click", function (e) {
            adddrugdialog.show();
        });
        jq("#drugCategory").on("change",function(e){
            var categoryId = jq(this).children(":selected").attr("id");
            var drugNameData ="";
            jq.getJSON('${ ui.actionLink("inventoryapp", "AddReceiptsToStore", "fetchDrugNames") }',{
                categoryId:categoryId
            })
                    .success(function(data) {

                        for (var key in data) {
                            if (data.hasOwnProperty(key)) {
                                var val = data[key];
                                for (var i in val) {
                                    if (val.hasOwnProperty(i)) {
                                        var j = val[i];
                                        if(i=="id")
                                        {
                                            drugNameData=drugNameData + '<option id="'+j+'"';
                                        }
                                        else{
                                            drugNameData=drugNameData+ 'name="' +j+ '">' + j+'</option>';
                                        }
                                    }
                                }
                            }
                        }
                        jq(drugNameData).appendTo("#drugName");
                    })
                    .error(function(xhr, status, err) {
                        alert('AJAX error ' + err);
                    });
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

            <input type="button" value="Add" class="button confirm" name="addDrugsButton" id="addDrugsButton"
                   style="margin-top:20px;">
            <input type="button" value="Submit" class="button confirm" name="addDrugsSubmitButton"
                   id="addDrugsSubmitButton" style="margin-top:20px;">
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
                    <lable for="drugCategory">Drug Category</lable>
                    <select name="drugCategory" id="drugCategory">
                        <option>Select Category</option>
                        <% if (listCategory != null || listCategory != "") { %>
                        <% listCategory.each { drugCategory -> %>
                        <option id="${drugCategory.id}">${drugCategory.name}</option>
                        <% } %>
                        <% } %>
                    </select>
                </li>
                <li>
                    <label for="drugName">Drug Name</label>
                    <select name="drugName" id="drugName">
                        <option>Select Drug</option>
                    </select>
                </li>
                <li>
                    <lable for="drugFormulation">Formulation</lable>
                    <select name="drugFormulation" id="drugFormulation">
                        <option>Select Formulation</option>
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
</div>