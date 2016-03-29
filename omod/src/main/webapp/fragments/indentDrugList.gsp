<%
    def props = ["name","createdOn","subStoreStatusName","action"]
%>
<script>
    jq(function () {
            var date = jq("#referred-date-field").val();
            jq.getJSON('${ui.actionLink("pharmacyapp", "IndentDrugList", "showList")}',
                    {
                        "date": moment(date).format('DD/MM/YYYY'),
                        "currentPage": 1
                    } ).success(function (data) {
                        if (data.length === 0) {
                            jq().toastmessage('showNoticeToast', "No indent found!");
                        } else {
                            updateQueueTable(data)
                        }
            });



    });

    //update the queue table
    function updateQueueTable(tests) {
        var jq = jQuery;
        jq('#indent-search-result-table > tbody > tr').remove();
        var tbody = jq('#indent-search-result-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];

            <% props.each {
              if(it == props.last()){
                  def pageLinkEdit = ui.pageLink("", "");
                      %>
            row += '<td> <a title="" href="?patientId=' +
                    item.patientIdentifier + '&revisit=true"><i class="icon-folder-open  small" ></i></a>';

            <% } else {%>

            row += '<td>' + item.${ it } + '</td>';
            <% }
              } %>
            row += '</tr>';
            tbody.append(row);
        }
    }
</script>

<div>
    <h2 style="display: inline-block;">Indents</h2>

    <div id="indent-search-result" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="indent-search-result-table_wrapper">
            <table id="indent-search-result-table" class="dataTable" aria-describedby="indent-search-result-table_info">
                <thead>
                <tr role="row">
                    <th class="ui-state-default" role="columnheader" style="width:200px;">
                        <div class="DataTables_sort_wrapper">
                            <span>name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 50px;">
                        <div class="DataTables_sort_wrapper">
                            <span>createdOn</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 50px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Status</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 50px;">
                        <div class="DataTables_sort_wrapper">
                            <span>action</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                </tr>
                </thead>

                <tbody role="alert" aria-live="polite" aria-relevant="all">
                <tr align="center">
                    <td colspan="6">No indent found</td>
                </tr>
                </tbody>
            </table>

        </div>
    </div>

</div>