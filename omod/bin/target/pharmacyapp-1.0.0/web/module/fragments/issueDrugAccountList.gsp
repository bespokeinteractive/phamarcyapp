<script>
    jq(function () {
        var date = jq("#referred-date-field").val();
        jq.getJSON('${ui.actionLink("pharmacyapp", "IssueDrugAccountList", "fetchList")}',
                {
                    "date": moment(date).format('DD/MM/YYYY'),
                    "currentPage": 1
                }).success(function (data) {
                    if (data.length === 0) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                    } else {
                        QueueTable(data)
                    }

                });

    });

    //update the queue table
    function QueueTable(tests) {
        var jq = jQuery;
        jq('#issue-drug-account-list-table > tbody > tr').remove();
        var tbody = jq('#issue-drug-account-list-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var v = parseInt(index) + 1;

            var item = tests[index];
            row += '<td>' + v + '</td>'
            row += '<td><a href="#" onclick= accountDetail(' + item.id + ');"' +
                    'accountDetail(id);' +
                    '">' + item.name + '  <a/></td>'
            row += '<td>' + item.createdOn + '</td>'

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


<div>
    <h2 style="display: inline-block;">Issue Drug List</h2>

    <div id="issue-drug-account-list" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="issue-drug-account-list-table_wrapper">
            <table id="issue-drug-account-list-table" class="dataTable"
                   aria-describedby="issue-drug-account-list-table_info">
                <thead>
                <th class="ui-state-default" role="columnheader" style="width:10px;">
                    <div class="DataTables_sort_wrapper">
                        <span>#</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>


                <th class="ui-state-default" role="columnheader" style="width:100px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Account</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width: 50px;">
                    <div class="DataTables_sort_wrapper">
                        <span>Issue Date
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