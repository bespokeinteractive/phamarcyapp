<script>
    jq(function () {
        jq("#drugName, #attribute").on("keyup", function () {
            reloadExpiredDrugs();
        });

        jq("#categoryId").change(function() {
            reloadExpiredDrugs();
        });

        function reloadExpiredDrugs() {
            var categoryId 	= jq("#categoryId").val();
            var drugName 	= jq("#drugName").val();
            var attribute 	= jq("#attribute").val();
			
            getExpiredDrugs(categoryId, drugName, attribute);
        }
		
		reloadExpiredDrugs();
    });

    function getExpiredDrugs(categoryId, drugName, attribute) {
        jq.getJSON('${ui.actionLink("pharmacyapp", "ViewExpiredDrugs", "viewStockBalanceExpired")}',{
			categoryId: categoryId,
			drugName: drugName,
			attribute: attribute
		}).success(function (data) {
			if (data.length === 0 && data != null) {
				jq().toastmessage('showErrorToast', "No drug found!");
				
				jq('#expiry-list-table > tbody > tr').remove();
				var tbody = jq('#expiry-list-table > tbody');
				var row = '<tr align="center"><td></td><td colspan="7">No drugs found</td></tr>';
				tbody.append(row);

			} else {
				ExpiryTable(data);
			}
		}).error(function () {
			jq().toastmessage('showErrorToast', "An Error Occured while Fetching List");
			
			jq('#expiry-list-table > tbody > tr').remove();
			var tbody = jq('#expiry-list-table > tbody');
			var row = '<tr align="center"><td></td><td colspan="7">No drugs found</td></tr>';
			tbody.append(row);
		});
    }

    function ExpiryTable(tests) {
        var jq = jQuery;
        jq('#expiry-list-table > tbody > tr').remove();
        var tbody = jq('#expiry-list-table > tbody');
        for (index in tests) {
            var row = '<tr>';
            var c = parseInt(index) + 1;

            var item = tests[index];

            var pageLinkEdit = emr.pageLink("pharmacyapp", "viewStockBalanceDetail", {
                drugId: item.drug.id,
                formulationId: item.formulation.id,
                expiry: 1
            });

            row += '<td>' + c + '</td>'
            row += '<td><a href="' + pageLinkEdit + '">' + item.drug.name + '</a></td>';
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

    function accountDetail(id) {
        window.location.href = emr.pageLink("pharmacyapp", "issueDrugAccountDetail", {
            "issueId": id
        });
    }
</script>

<div class="clear"></div>
<div id="expired-div">
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
					Expired Drugs
				</li>
			</ul>
		</div>
		
		<div class="patient-header new-patient-header">
			<div class="demographics">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span>VIEW EXPIRED STOCK &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>
			</div>
			
			<div class="show-icon">
				&nbsp;
			</div>
			
			<div class="filter">
				<i class="icon-filter" style="color: rgb(91, 87, 166); float: left; font-size: 52px ! important; padding: 0px 10px 0px 0px;"></i>
				<div class="first-col">
					<label for="drugName">Drug Name</label><br/>
					<input type="text" id="drugName" class="searchFieldChange" name="drugName" placeholder="Enter Drug Name" title="Enter Drug Name" style="width: 160px; " >
				</div>
				
				<div class="first-col">
					<label for="categoryId">From Date</label><br/>
					<select  id="categoryId" class="searchFieldChange" title="Select Category" style="width: 200px;">
						<option value>Select Category</option>
						<% listCategory.each { %>
							<option value="${it.id}" title="${it.name}">${it.name}</option>								
						<% } %>
					</select>
				</div>
				
				<div class="first-col">
					<label for="dReceiptId">Receipt No.</label><br/>
					<input type="text" id="attribute" name="attribute" placeholder="Enter Attribute" title="Enter Attribute" style="width: 160px;">
				</div>				
			</div>
		</div>
		
		
		
	</div>
</div>














    <div id="expiry-list" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="expiry-list-table_wrapper">
            <table id="expiry-list-table" class="dataTable" aria-describedby="expiry-list-table_info">

               
                <label for="attribute"> Attribute:</label>
                

                <thead>
                <tr role="row">

                <th class="ui-state-default" role="columnheader" style="width:10px;">
                    <div class="DataTables_sort_wrapper">
                        <span>#</span>
                        <span class="DataTables_sort_icon"></span>
                    </div>
                </th>

                <th class="ui-state-default" role="columnheader" style="width:10px;">
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
