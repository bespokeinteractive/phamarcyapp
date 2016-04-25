<script>
    jq(function () {
        //action when the searchField change occurs
        jq(".searchFieldChange").on("change", function () {
            reloadExpiredDrugs();
        });

        //action when the searchField blur occurs
        jq(".searchFieldBlur").on("blur", function () {
            reloadExpiredDrugs();
        });

        function reloadExpiredDrugs() {
            var categoryId = jq("#categoryId1").val();
            var drugName = jq("#drugName1").val();
            var attribute = jq("#attribute1").val();
            getExpiredDrugs(categoryId, drugName, attribute);
        }
    });

    function getExpiredDrugs(categoryId, drugName, attribute) {
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewExpiredDrugs", "viewStockBalanceExpired")}',
                {
                    categoryId: categoryId,
                    drugName: drugName,
                    attribute: attribute
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                        jq('#expiry-list-table > tbody > tr').remove();
                        var tbody = jq('#expiry-list-table > tbody');
                        var row = '<tr align="center"><td colspan="5">No drugs found</td></tr>';
                        tbody.append(row);

                    } else {
                        ExpiryTable(data);

                    }
                }).error(function () {
                    jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                    jq('#expiry-list-table > tbody > tr').remove();
                    var tbody = jq('#expiry-list-table > tbody');
                    var row = '<tr align="center"><td colspan="5">No drugs found</td></tr>';
                    tbody.append(row);

                });
    }

    jq(function(){
        var date = jq("#referred-date-field").val();
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewExpiredDrugs", "viewStockBalanceExpired")}',
                {
                    "date": moment(date).format('DD/MM/YYYY'),
                    "currentPage": 1
                } ).success(function (data) {
                    if (data.length === 0) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        ExpiryTable(data)
                    }

                });
    });

    function ExpiryTable(tests) {
        var jq = jQuery;
        jq('#expiry-list-table > tbody > tr').remove();
        var tbody = jq('#expiry-list-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;

            var item = tests[index];

            var pageLinkEdit = emr.pageLink("pharmacyapp", "viewStockBalanceDetail", {
                drugId: item.drug.id,
                formulationId: item.formulation.id,
                expiry: 1
            });

            row += '<td>' + c + '</td>'
            row += '<td><a href="' + pageLinkEdit + '">' + item.drug.name + '</a></td>';
            row += '<td>'+ item.drug.category.name +'</td>';
            row += '<td>'+ item.formulation.name+"-"+item.formulation.dozage +'</td>';
            row += '<td>'+ item.currentQuantity +'</td>';

            if (item.drug.attribute === 1){
                row += '<td>A</td>';
            }
            else {
                row += '<td>B</td>';
            }



            row += '</tr>';
            tbody.append(row);
        }
    }

    function accountDetail(id) {
        window.location.href = emr.pageLink("pharmacyapp", "issueDrugAccountDetail", {
            "issueId": id
        });
    }
</script>

    <div id="expiry-list" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="expiry-list-table_wrapper">
            <table id="expiry-list-table" class="dataTable" aria-describedby="expiry-list-table_info">

                <select  id="categoryId1" class="searchFieldChange" title="Select Category" style="width: 200px;">
                    <option value>Select Category</option>
                    <% listCategory.each { %>
                    <option value="${it.id}" title="${it.name}">
                        ${it.name}
                    </option>
                    <% } %>
                </select>
                <label for="drugName1"> Name:</label>
                <input type="text" id="drugName1" class="searchFieldChange" name="drugName" placeholder="Enter Drug Name" title="Enter Drug Name" style="width: 160px; " >
                <label for="attribute1"> Attribute:</label>
                <input type="text" id="attribute1" class="searchFieldBlur" name="attribute" placeholder="Enter Attribute" title="Enter Attribute" style="width: 160px;">

                <thead>
                <tr role="row">

                <th class="ui-state-default" role="columnheader" style="width:10px;">
                    <div class="DataTables_sort_wrapper">
                        <span>#</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:10px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Drug Name</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 50px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Category
                        </span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 50px;">
                    <div class="DataTables_sort_wrapper">
                        <span>formulation
                        </span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 50px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Current Quantity
                        </span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 50px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Attribute
                        </span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                </tr>
                </thead>

                <tbody role="alert" aria-live="polite" aria-relevant="all">
                <tr align="center">
                    <td colspan="6">No drug found</td>
                </tr>
                </tbody>
            </table>

        </div>
    </div>
