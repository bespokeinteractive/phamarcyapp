<%
    def props = ["name", "createdOn", "subStoreStatusName", "action"]
%>
<script>
    jq(function () {
        jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});
        getIndentList();

        //action when the searchField change occurs
        jq(".searchFieldChange").on("change", function () {
            reloadList();

        });

        //action when the searchField blur occurs
        jq(".searchFieldBlur").on("blur", function () {
            reloadList();
        });

        function reloadList() {
            var statusId = jq("#statusId").val();
            var indentName = jq("#indentName").val();
            var fromDate = jq("#fromDate").val();
            var toDate = jq("#toDate").val();
            getIndentList(statusId, indentName, fromDate, toDate);
        }
    });//end of doc ready


    function detailDrugIndentPrint(indentId) {
        window.location.href = emr.pageLink("pharmacyapp", "indentDrugDetail", {
            "indentId": indentId
        });
    }


    function getIndentList(statusId, indentName, fromDate, toDate) {
        jq.getJSON('${ui.actionLink("pharmacyapp", "indentDrugList", "showList")}',
                {
                    statusId: statusId,
                    indentName: indentName,
                    fromDate: fromDate,
                    toDate: toDate,
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No drug found!");
                        jq('#indent-search-result-table > tbody > tr').remove();
                        var tbody = jq('#indent-search-result-table > tbody');
                        var row = '<tr align="center"><td colspan="5">No Drugs found</td></tr>';
                        tbody.append(row);
                    } else {
                        updateQueueTable(data);
                    }
                }).error(function () {
                    jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                    jq('#indent-search-result-table > tbody > tr').remove();
                    var tbody = jq('#indent-search-result-table > tbody');
                    var row = '<tr align="center"><td colspan="5">No Drugs found</td></tr>';
                    tbody.append(row);
                });
    }


    //update the queue table
    function updateQueueTable(tests) {
        var jq = jQuery;
        jq('#indent-search-result-table > tbody > tr').remove();
        var tbody = jq('#indent-search-result-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;
            var item = tests[index];

            row += '<td>' + c + '</td>'
            row += '<td><a  href="#" onclick="detailDrugIndentPrint(' + item.id + ');">' + item.name + ' </a></td>'
            row += '<td>' + item.createdOn + '</td>'
            row += '<td>' + item.subStoreStatusName + '</td>'
            var link = "";
            if (item.subStoreStatus == 1) {
                link += '<a href="#" title="Send Indent" onclick="processSendIndent(' + item.id + ');" >Send Indent</a>';
            } else if (item.subStoreStatus == 3) {
                link += '<a href="#" title="Process Indent" onclick="processDrugIndent(' + item.id + ');" >Process Indent</a>';
            }
            row += '<td><a href="#" >' + link + '<a/></td>'
            row += '</tr>';
            tbody.append(row);
        }
    }

    function processDrugIndent(indentId) {
        window.location.href = emr.pageLink("pharmacyapp", "subStoreDrugProcessIndent", {
            "indentId": indentId
        });
    }
    function processSendIndent(indentId) {
        window.location.href = emr.pageLink("pharmacyapp", "sendDrugIndentToMainStore", {
            "indentId": indentId
        });
    }
    function subStoreIndentDrug() {
        window.location.href = emr.pageLink("pharmacyapp", "subStoreIndentDrug");
    }

</script>

<div>
    <div class="dashboard clear">
        <div class="info-section">
            <div class="info-header">
                <i class="icon-external-link"></i>

                <h3>Indent</h3>
                <input type="button" class="ui-button ui-widget ui-state-default ui-corner-all" value="Add Indent Slip"
                       style="float: right" onclick="subStoreIndentDrug();"/>
            </div>
        </div>
    </div>

    <div id="indent-search-result" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="indent-search-result-table_wrapper">
            <table id="indent-search-result-table" class="dataTable" aria-describedby="indent-search-result-table_info">

                <select name="statusId" id="statusId" class="searchFieldChange" title="Select Status">
                    <option value>Select Status</option>
                    <% listSubStoreStatus.each { %>
                    <option value="${it.id}" title="${it.name}">
                        ${it.name}
                    </option>
                    <% } %>
                </select>
                <label for="indentName">Drug Name</label>
                <input type="text" id="indentName" name="indentName" placeholder="Drug Name" class="searchFieldBlur"
                       title="Enter Drug Name"/>
                <label for="fromDate">From</label>
                <input type="text" id="fromDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly"
                       name="fromDate"
                       title="Double Click to Clear" ondblclick="this.value = '';"/>
                <label for="toDate">To</label>
                <input type="text" id="toDate" class="date-pick searchFieldChange searchFieldBlur" readonly="readonly"
                       name="toDate"
                       title="Double Click to Clear" ondblclick="this.value = '';"/>
                <thead>
                <tr role="row">
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>S.No.</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>
                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Drug Name</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Date Created</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Status</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default" role="columnheader">
                        <div class="DataTables_sort_wrapper">
                            <span>Action</span>
                            <span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                </tr>
                </thead>

                <tbody role="alert" aria-live="polite" aria-relevant="all">
                <tr align="center">
                    <td colspan="5">No indent found</td>
                </tr>
                </tbody>
            </table>

        </div>
    </div>
</div>
