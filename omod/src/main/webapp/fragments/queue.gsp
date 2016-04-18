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

            row += '<td> <a title="Prescriptions" href="listOfOrder.page?patientId=' +
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

<div class="clear"></div>
<div id="queue-div">
	<div class="container">
		<div class="example">
			<ul id="breadcrumbs">
				<li>
					<a href="${ui.pageLink('referenceapplication', 'home')}">
						<i class="icon-home small"></i></a>
				</li>
				
				<li>
					<a href="${ui.pageLink('pharmacyapp', 'dashboard')}">
						<i class="icon-chevron-right link"></i>Inventory
					</a>
				</li>

				<li>
					<i class="icon-chevron-right link"></i>
					Queue
				</li>
			</ul>
		</div>
		
		<div class="patient-header new-patient-header">
			<div class="demographics">
				<h1 class="name" style="border-bottom: 1px solid #ddd;">
					<span>PATIENTS QUEUE LIST &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span>
				</h1>
			</div>
			
			<div class="show-icon">
				&nbsp;
			</div>
			
			<div class="filter">
				<i class="icon-filter" style="color: rgb(91, 87, 166); float: left; font-size: 52px ! important; padding: 0px 10px 0px 0px;"></i>
				<div class="first-col">
					<label for="referred-date-display">Date</label><br/>
					${ui.includeFragment("uicommons", "field/datetimepicker", [id: 'referred-date', label: 'Date Ordered', formFieldName: 'referredDate', useTime: false, defaultToday: true])}
				</div>
				
				<div class="second-col">
					<label for="phrase">Filter Patient in Queue:</label><br/>
					<input id="phrase" type="text" name="phrase" placeholder="Enter Patient Name/ID:">
				</div>
				
				<a class="button confirm" id="getOrders" style="float: right; margin: 15px 5px 0 0;">
					Get Patients
				</a>
			</div>
		</div>
	</div>
	
	
	<table id="pharmacyPatientSearch">
		<thead>
			<tr role="row">
				<th>IDENTIFIER</th>
				<th>NAMES</th>
				<th>AGE</th>
				<th>GENDER</th>
				<th>ACTIONS</th>
			</tr>
		</thead>

		<tbody role="alert" aria-live="polite" aria-relevant="all">
		<tr align="center">
			<td colspan="6">No patients found</td>
		</tr>
		</tbody>
	</table>

</div>

<div>
    

    <div id="patient-search-results" style="display: block; margin-top:3px;">
        <div role="grid" class="dataTables_wrapper" id="patient-search-results-table_wrapper">
            

        </div>
    </div>

</div>




