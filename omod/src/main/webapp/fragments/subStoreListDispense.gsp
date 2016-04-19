<script>
    var toReturn;
    jq(function () {
        var receiptsData = getOrderList();
        jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});


        jq('.dispenseSearch').on('keyup blur change', function () {
            var issueName = jq("#dIssueName").val();
            var fromDate = jq("#dFromDate").val();
            var toDate = jq("#dToDate").val();
            var receiptId = jq("#dReceiptId").val();
            var resutlts = getOrderList(issueName, fromDate, toDate, receiptId);
            list.drugDispenseList(resutlts);
        });
        function IssueDrugViewModel() {
            var self = this;
            // Editable data
            self.drugDispenseList = ko.observableArray([]);
            var mappedDrugItems = jQuery.map(receiptsData, function (item) {
                return item;
            });
            self.drugDispenseList(mappedDrugItems);
            self.viewDetails = function (item) {
                var url = '${ui.pageLink("pharmacyapp","printDrugOrder")}';
//                window.location.replace("detailedDispenseDrug.page?receiptId=" + item.id);
                window.location.href = url + "?issueId=" + item.id;
            };
        }

        var list = new IssueDrugViewModel();
        ko.applyBindings(list, jq("#orderDrugList")[0]);
    }); //end of document ready

    function getOrderList(searchIssueName, fromDate, toDate, receiptId) {
        jQuery.ajax({
            type: "GET",
            url: '${ui.actionLink("pharmacyapp", "subStoreListDispense", "getDispenseList")}',
            dataType: "json",
            global: false,
            async: false,
            data: {
                searchIssueName: searchIssueName,
                fromDate: fromDate,
                toDate: toDate,
                receiptId: receiptId
            },
            success: function (data) {
                toReturn = data;
            }
        });
        return toReturn;
    }
</script>

<div class="dashboard clear">
    <div class="info-section">
        <div class="info-header">
            <i class="icon-calendar"></i>

            <h3>Manage Issue Drug</h3>
        </div>
    </div>
</div>

<form method="get" id="form">
    <table>
        <tr>
            <td><input type="text" name="dIssueName" id="dIssueName" placeholder="Patient Name" class="dispenseSearch"/>
            </td>
            <td><input type="text" id="dFromDate" class="date-pick left dispenseSearch"
                       readonly="readonly" name="dFromDate"
                       title="Double Click to Clear" ondblclick="this.value = '';" placeholder="From Date:"/></td>
            <td><input type="text" id="dToDate" class="date-pick left dispenseSearch"
                       readonly="readonly" name="dToDate"
                       title="Double Click to Clear" ondblclick="this.value = '';" placeholder="To Date:"/></td>
            <td><input type="text" name="dReceiptId" id="dReceiptId" placeholder="Receipt No." class="dispenseSearch"/>
            </td>
        </tr>
    </table>
    <br/>

    <div id="orderDrugList">
        <table width="100%" cellpadding="5" cellspacing="0">
            <thead>
            <tr>
                <th>S.No</th>
                <th>Receipt No.</th>
                <th>Patient ID</th>
                <th>Name</th>
                <th>Issue Date:</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody data-bind="foreach: drugDispenseList">
            <tr>
                <td data-bind="text: \$index() + 1"></td>
                <td data-bind="text: id"></td>
                <td data-bind="text: identifier"></td>
                <td>
                    <span data-bind="text: patient.givenName"></span>&nbsp;
                    <span data-bind="text: patient.familyName"></span>&nbsp;
                    <span data-bind="text: patient.middleName"></span>
                </td>
                <td data-bind="text: createdOn"></td>
                <td>
                    <a class="remover" href="#" data-bind="click: \$root.viewDetails"
                       title="Detail issue drug to this patient">
                        <i class="icon-signin  small">View/Print</i>
                    </a>
                </td>

            </tr>
            </tbody>
        </table>
    </div>
</form>