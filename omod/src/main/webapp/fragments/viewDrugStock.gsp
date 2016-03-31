
<script>
    jq(function(){
        var date = jq("#referred-date-field").val();
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewDrugStock", "list")}',
                {
                    "date": moment(date).format('DD/MM/YYYY'),
                    "currentPage": 1
                } ).success(function (data) {
                    if (data.length === 0) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        StockTable(data)
                    }

                });
    });

    function StockTable(tests) {
        var jq = jQuery;
        jq('#stock-list-table > tbody > tr').remove();
        var tbody = jq('#stock-list-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;

            var item = tests[index];

            row += '<td>' + c + '</td>'
            row += '<td>'+ item.drug.name +'</td>';
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
</script>

<div>
    <h2 style="display: inline-block;">Drug Stock List</h2>

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