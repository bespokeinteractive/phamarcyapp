<% ui.includeJavascript("billingui", "moment.js") %>

<script>
    var toReturn;
    jq(function () {
        var receiptsData = getOrderList();
        jQuery('.date-pick').datepicker({minDate: '-100y', dateFormat: 'dd/mm/yy'});

		jq('#toDate, #fromDate').change(function(){
			var issueName	= jq("#dIssueName").val();			
            var fromDate 	= moment(jq("#fromDate-field").val()).format('DD/MM/YYYY');
            var toDate 		= moment(jq("#toDate-field").val()).format('DD/MM/YYYY');			
            var receiptId 	= jq("#dReceiptId").val();
            var results 	= getOrderList(issueName, fromDate, toDate, receiptId);
            list.drugDispenseList(results);
		});
		
        jq('.dispenseSearch').on('keydown', function () {
            var issueName	= jq("#dIssueName").val();			
            var fromDate 	= moment(jq("#fromDate-field").val()).format('DD/MM/YYYY');
            var toDate 		= moment(jq("#toDate-field").val()).format('DD/MM/YYYY');			
            var receiptId 	= jq("#dReceiptId").val();
            var results 	= getOrderList(issueName, fromDate, toDate, receiptId);
            list.drugDispenseList(results);
        });
		
        function IssueDrugViewModel() {
            var self = this;
            // Editable data
            self.drugDispenseList = ko.observableArray([]);
            var mappedDrugItems = jQuery.map(receiptsData, function (item) {
                if((item.values===0)&&(item.statuss===1)){
                    return item;
                }else if((item.values!==0)&&(item.statuss===1)){
                    return item;
                }else{
//                    do nothing, the item has not been processed from the cashier side
                }

            });
            
            self.drugDispenseList(mappedDrugItems);
            self.viewDetails = function (item) {
                var url = '${ui.pageLink("pharmacyapp","printDrugOrder")}';
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

<div class="clear"></div>
<div id="dispense-div">
	<div class="container">
		<div class="example">
			<ul id="breadcrumbs">
				<li>
					<a href="${ui.pageLink('referenceapplication', 'home')}">
						<i class="icon-home small"></i></a>
				</li>
				
				<li>
					<a href="${ui.pageLink('pharmacyapp', 'dashboard')}">
						<i class="icon-chevron-right link"></i>Pharmacy
					</a>
				</li>

				<li>
					<i class="icon-chevron-right link"></i>
					Dispense
				</li>
			</ul>
		</div>
		
		<div class="patient-header new-patient-header">
			<div class="demographics">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span>DRUGS DISPENSE LIST &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>
			</div>
			
			<div class="show-icon">
				&nbsp;
			</div>
			
			<div class="filter">
				<i class="icon-filter" style="color: rgb(91, 87, 166); float: left; font-size: 52px ! important; padding: 0px 10px 0px 0px;"></i>
				<div class="first-col">
					<label for="dIssueName">Patient Name</label><br/>
					<input type="text" name="dIssueName" id="dIssueName" placeholder="Patient Name" class="dispenseSearch"/>
				</div>
				
				<div class="first-col">
					<label for="fromDate-display">From Date</label><br/>
					${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'fromDate', label: 'Date', formFieldName: 'fromDate', useTime: false, defaultToday: true])}
				</div>
				
				<div class="first-col">
					<label for="toDate-display">To Date</label><br/>
					${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'toDate',   label: 'Date', formFieldName: 'toDate',   useTime: false, defaultToday: true])}
				</div>
				
				<div class="first-col">
					<label for="dReceiptId">Receipt No.</label><br/>
					<input type="text" name="dReceiptId" id="dReceiptId" placeholder="Receipt No." class="dispenseSearch"/>
				</div>				
			</div>
		</div>
	</div>
</div>

<form method="get" id="form">
    <div id="orderDrugList">
        <table width="100%" cellpadding="5" cellspacing="0">
            <thead>
				<tr>
					<th>#</th>
					<th>RECEIPT#</th>
					<th>IDENTIFIER</th>
					<th>NAME</th>
					<th>DATE</th>
					<th>ACTION</th>
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
                <td data-bind="text: (createdOn.toString().substring(0, 11))"></td>
                <td>
                    <a class="remover" href="#" data-bind="click: \$root.viewDetails"
                       title="Detail issue drug to this patient">
                        <i class="icon-check small"> </i>VIEW / PRINT
                    </a>
                </td>

            </tr>
            </tbody>
        </table>
    </div>
</form>

<div class="footer">&nbsp;</div>