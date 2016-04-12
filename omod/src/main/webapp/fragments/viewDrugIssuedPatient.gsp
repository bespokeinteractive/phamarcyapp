<%
    def props = ["id","identifier","name","patient.age","patient.gender","createdOn","action"]
%>
<script>
    var tests;

    jq(function () {
        var dateField = jq("#referred-date-field");
            var date = dateField.val();
            var phrase = jq("#phrase").val();
            jq.getJSON('${ui.actionLink("pharmacyapp", "ViewDrugIssuedPatient", "fetchList")}',
                    {
                        "date": moment(date).format('DD/MM/YYYY'),
                        "phrase": phrase,
                        "currentPage": 1
                    }).success(function (data) {
                        if (data.length === 0) {
                            jq().toastmessage('showNoticeToast', "No match found!");
                        } else {
                            issuedDrugs(data);
                        }
                    });

    });


    function issuedDrugs(tests) {
        var jq = jQuery;
        var dateField = jq("#referred-date-field");
        jq('#issued-drugs-table > tbody > tr').remove();
        var tbody = jq('#issued-drugs-table > tbody');
        var date = dateField.val();
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;
            row += '<td>' + c + '</td>';
            var item = tests[index];

            <% props.each {
              if(it == props.last()){
                  def pageLinkEdit = ui.pageLink("", "");
                      %>
            row += '<td> <a title="Print" onclick="displayPrintArea('+item.id+')"><i class="icon-print small" ></i></a>';
            <% } else {%>
            row += '<td>' + item.${ it } + '</td>';
            <% }
              } %>
            row += '</tr>';
            tbody.append(row);
        }
    }

    function searchData()
    {

    }

    function displayPrintArea(id) {
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewDrugIssuedPatient", "fetchDrugIssuedData")}',
                {
                    "id": id
                }).success(function (data) {
            if (data.length === 0) {
                jq().toastmessage('showNoticeToast', "No match found!");
            } else {

            }
        });

      /*  jq("#dialog-message").append("<p>This is a test Test</p>");
        jq("#dialog-message" ).dialog({
            modal: true,
            buttons: {
                Print: function() {
                    jq( this ).dialog( "close" );
                }
            }
        });*/
    }
</script>

<div>
    <h2 style="display: inline-block;">Issued drugs</h2>

    <div id="issuedDrugs" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="issued-drugs-table_wrapper">
            <table id="issued-drugs-table" class="dataTable"
                   aria-describedby="issued-drugs-table_info">
                <thead>
                <tr role="row">

                    <th class="ui-state-default" role="columnheader" style="width:10px;">
                        <div class="DataTables_sort_wrapper">
                            <span>#</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width:60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Receipt N0</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>ID</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 50px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width:60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Age</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Gender</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Issued Date</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>view/print</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                </tr>
                </thead>

                <tbody role="alert" aria-live="polite" aria-relevant="all">
                <tr align="center">
                    <td colspan="6">No patients found</td>
                </tr>
                </tbody>
            </table>

        </div>
    </div>

    <div id="dialog-message" title="Detail Issue">

    </div>

</div>