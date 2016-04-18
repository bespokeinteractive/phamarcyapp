<script>

    jq(function () {
        var date = jq("#referred-date-field").val();
        jq.getJSON('${ui.actionLink("pharmacyapp", "IssueDrugAccountList", "fetchList")}',
            {
                "date": moment(date).format('DD/MM/YYYY'),
                "currentPage": 1
            }).success(function (data) {
                if (data.length === 0 && data != null) {
                    jq().toastmessage('showNoticeToast', "No drug found!");
                } else {
                    QueueTable(data);

                }

            });

    });

    //update the queue table
    function QueueTable(tests) {
    console.log('Function queue table started');
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
        console.log('Function queue table successful');
    }

    function accountDetail(id) {
        window.location.href = emr.pageLink("pharmacyapp", "issueDrugAccountDetail", {
            "issueId": id
        });
    }

    jq(function () {
            jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});
            getAccountList();
            console.log('function get account list called');


            //action when the searchField change occurs
            jq("#fromDate-display").on("change", function () {
                reloadmyList();
                console.log('reloadmylist called due to search change');

            });
            jq('#issueName').on("keyup",function(){
               reloadmyList();
            });
            //action when the searchField blur occurs
            jq(".searchFieldBlur").on("blur", function () {
                reloadmyList();
                console.log('reloadmylist-on search field blur');
            });

            function reloadmyList() {
                console.log('reload started');
                var issueName = jq("#issueName").val();
                var fromDate = moment(jq("#fromDate-field").val()).format('DD/MM/YYYY');
                var toDate = moment(jq("#toDate-field").val()).format('DD/MM/YYYY');
                getAccountList(issueName, fromDate, toDate);
                console.log('reload ended');
            }
        });//end of doc ready

        function getAccountList(issueName, fromDate, toDate) {
            jq.getJSON('${ui.actionLink("pharmacyapp", "issueDrugAccountList", "fetchList")}',
                {
                    issueName: issueName,
                    fromDate: fromDate,
                    toDate: toDate,
                }).success(function (data) {
                    if (data.length === 0 && data != null) {
                        jq().toastmessage('showNoticeToast', "No account found!");
                        jq('#issue-drug-account-list-table > tbody > tr').remove();
                        var tbody = jq('#issue-drug-account-list-table > tbody');
                        var row = '<tr align="center"><td colspan="5">No accounts found</td></tr>';
                        tbody.append(row);
                        console.log('get account list successful');
                    } else {
                        QueueTable(data);
                        console.log('success: account list calls queue table');
                    }
                }).error(function () {
                    jq().toastmessage('showNoticeToast', "An Error Occured while Fetching List");
                    jq('#issue-drug-account-list-table > tbody > tr').remove();
                    var tbody = jq('#issue-drug-account-list-table > tbody');
                    var row = '<tr align="center"><td colspan="5">No Accounts found</td></tr>';
                    tbody.append(row);
                    console.log('get account list error');
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
.add-on{
    color: #f26522;
    font-size: 8px !important;
    left: auto;
    margin-left: -29px;
    margin-top: 4px !important;
    position: absolute;
}
#fromDate,
#toDate{
    float:none;
    margin-bottom: -9px;
        margin-top: 12px;
        padding-right: 0;
}
</style>
<div>
    <div class="dashboard clear">
        <div class="info-section">
		    <div class="info-header">
                <i class="icon-list-ul"></i>
                <h3>Issue Drug list</h3>
                <div style="margin-top: -5px">
                    <i class="icon-filter" style="font-size: 26px!important; color: #5b57a6"></i>
                    <label for="categoryId">Name: </label>
                        <input type="text" id="issueName" name="issueName" placeholder="Enter Account Name"  title="Enter account Name" style="width: 160px; "/>
                    <label for="fromDate-display" style="width: auto; padding-left: 0px;">&nbsp;&nbsp;From&nbsp;</label>
                        ${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'fromDate', id: 'fromDate', label: '', useTime: false, defaultToday: false, class: ['searchFieldChange', 'date-pick', 'searchFieldBlur']])}
                    <label for="toDate" style="width: auto; padding-left: 0px;">&nbsp;&nbsp;To&nbsp;</label>
                        ${ui.includeFragment("uicommons", "field/datetimepicker", [formFieldName: 'toDate',   id: 'toDate',   label: '', useTime: false, defaultToday: false, class: ['searchFieldChange', 'date-pick', 'searchFieldBlur']])}
                 </div>
            </div>
	    </div>
    </div>

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