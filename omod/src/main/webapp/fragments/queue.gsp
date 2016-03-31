<%
    def props = ["fullname", "identifier", "age", "gender","action"]
%>

<script>
    jq(function () {
        var dateField = jq("#referred-date-field");
        jq("#getOrders").on("click", function () {
            var date = dateField.val();
            var phrase = jq("#phrase").val();
            jq.getJSON('${ui.actionLink("pharmacyapp", "Queue", "searchPatient")}',
                    {
                        "date": moment(date).format('DD/MM/YYYY'),
                        "phrase": phrase,
                        "currentPage": 1
                    }).success(function (data) {
                        if (data.length === 0) {
                            jq().toastmessage('showNoticeToast', "No match found!");
                        } else {
                            updatePharmacyTable(data)
                        }
                    });
        });

    });

    //update the queue table
    function updatePharmacyTable(tests) {
        var jq = jQuery;
        var dateField = jq("#referred-date-field");
        jq('#pharmacyPatientSearch > tbody > tr').remove();
        var tbody = jq('#pharmacyPatientSearch > tbody');
        var date = dateField.val();

        for (index in tests) {
            var row = '<tr>';
            var item = tests[index];
            <% props.each {
              if(it == props.last()){
                  def pageLinkEdit = ui.pageLink("", "");
                      %>
            row += '<td> <a title="Patient Revisit" href="?patientId=' +
                    item.patientIdentifier + '&revisit=true"><i class="icon-user-md small" ></i></a>';

            row += '<a title="Prescriptions" href="listOfOrder.page?patientId=' +
                    item.patientId + '&date= '+moment(date).format('DD/MM/YYYY')+'"><i class="icon-stethoscope small" ></i></a>';

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
    <h2 style="display: inline-block;">Patients Queue</h2>

    <a class="button confirm" id="getOrders" style="float: right; margin: 8px 5px 0 0;">
        Get Patients
    </a>

    <div class="formfactor onerow">
        <div class="first-col">
            <label for="referred-date-display">Date</label><br/>
            ${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'referred-date', label: 'Date Ordered', formFieldName: 'referredDate', useTime: false, defaultToday: true])}
        </div>

        <div class="second-col">
            <label for="phrase">Filter Patient in Queue:</label><br/>
            <input id="phrase" type="text" name="phrase" placeholder="Enter Patient Name/ID:">
        </div>
    </div>

    <div id="patient-search-results" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="patient-search-results-table_wrapper">
            <table id="pharmacyPatientSearch" class="dataTable"
                   aria-describedby="patient-search-results-table_info">
                <thead>
                <tr role="row">
                    <th class="ui-state-default" role="columnheader" style="width:200px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Patient ID</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Given name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 50px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Age</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width:60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Gender</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader" style="width: 60px;">
                        <div class="DataTables_sort_wrapper">
                            <span>Actions</span>
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

</div>




