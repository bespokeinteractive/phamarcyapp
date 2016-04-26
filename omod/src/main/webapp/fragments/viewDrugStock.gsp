
<script>
    function StockTable(tests) {
        var jq = jQuery;
        jq('#stock-list-table > tbody > tr').remove();
        var tbody = jq('#stock-list-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;

            var item = tests[index];

            var pageLinkEdit = emr.pageLink("pharmacyapp", "viewCurrentStockBalanceDetail", {
                drugId: item.drug.id,
                formulationId: item.formulation.id,
            });

            row += '<td>' + c + '</td>'
            row += '<td><a href="'+ pageLinkEdit +'" >' + item.drug.name + '<a/></td>'
            row += '<td>'+ item.drug.category.name +'</td>';
            row += '<td>'+ item.formulation.name+"-"+item.formulation.dozage +'</td>';
            row += '<td>'+ item.currentQuantity +'</td>';
            row += '<td>'+ item.reorderPoint +'</td>';

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
	
    jq(function () {
		getStockList();

        jq('#drugName').on("keyup",function(){
            reloadList();
        });

        jq('#categoryId').on("change", function(){
            reloadList();
        });

          //action when the searchField blur occurs
        jq(".searchFieldChange").on("change", function () {
            reloadList();
        });

        function reloadList() {
            var drugName = jq("#drugName").val();
            var categoryId = jq("#categoryId").val();
            var attribute = jq("#attribute").val();
            getStockList(drugName, categoryId, attribute);
        }
    });//end of doc ready

    function getStockList(drugName, categoryId, attribute) {
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewDrugStock", "list")}',
        {
            drugName: drugName,
            categoryId: categoryId,
            attribute: attribute,
        }).success(function (data) {
            if (data.length === 0 && data != null) {
                jq().toastmessage('showNoticeToast', "No drugs found!");
                jq('#stock-list-table > tbody > tr').remove();
                var tbody = jq('#stock-list-table > tbody');
                var row = '<tr align="center"><td colspan="7">No drugs found</td></tr>';
                tbody.append(row);

            } else {
                StockTable(data);

            }
        }).error(function () {
            jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
            jq('#stock-list-table > tbody > tr').remove();
            var tbody = jq('#stock-list-table > tbody');
            var row = '<tr align="center"><td colspan="7">No drugs found</td></tr>';
            tbody.append(row);

        });
    }
</script>

<style>
    .dashboard {
        border: 1px solid #eee;
        padding: 2px 0 0;
        margin-bottom: 5px;
    }
    .dashboard .info-header i {
        font-size: 2.5em!important;
        margin-right: 0;
        padding-right: 0;
    }
    .info-header div{
        display: inline-block;
        float: right;
        margin-top: 7px;
    }
    .info-header div label{
        color: #f26522;
    }

</style>

<div>
    <div class="dashboard clear">
        <div class="info-section">
            <div class="info-header">
                <i class="icon-list-ul"></i>
                <h3>Drug Stock list</h3>
                <div>
                    <i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
                    <label for="drugName">Drug Name: </label>
                        <input type="text" id="drugName" name="drugName" placeholder="Enter Account Name"  title="Enter Drug Name" style="width: 160px; "/>
                    <label for="categoryId">Category: </label>
                        <select name="categoryId" id="categoryId" class="searchFieldChange" title="Select Category" style="width: 200px;">
                            <option value>Select Category</option>
                            <% listCategory.each { %>
                                <option value="${it.id}" title="${it.name}">
                                    ${it.name}
                                </option>
                            <% } %>
                        </select>
                    <label for="attribute">Attribute: </label>
                        <select name="attribute" id="attribute" class="searchFieldChange" title="Select Attribute">
                            <option value>Select Attribute</option>
                            <% listDrugAttribute.each { %>
                                <option value="${it.name}" title="${it.name}">
                                    ${it.name}
                                </option>
                            <% } %>
                        </select>
                 </div>
            </div>
        </div>
    </div>

    <div id="stock-list" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="stock-list-table_wrapper">
            <table id="stock-list-table" class="dataTable" aria-describedby="stock-list-table_info">
                <thead>
                <th class="ui-state-default" role="columnheader" style="width:10px;">
                    <div class="DataTables_sort_wrapper">
                        <span>#</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:100px;">
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
                        <span>Reorder point
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
</div>