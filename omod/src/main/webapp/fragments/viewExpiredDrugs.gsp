<script>
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
            var item = tests[index];


            row += '<td>'+ item.drug.name +'</td>';
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
</script>

<div>
    <h2 style="display: inline-block;">Expiry List</h2>

    <div id="expiry-list" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="expiry-list-table_wrapper">
            <table id="expiry-list-table" class="dataTable" aria-describedby="expiry-list-table_info">
                <thead>
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