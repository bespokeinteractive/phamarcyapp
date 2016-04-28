<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
%>

<script>
    var drugOrder = [];
	var drugIdnt = 0;
	
    jq(function () {
        var cleared = false;
        jq("#drugSelection").hide();

        var slipName = [];
        var addpatientdrugdialog = emr.setupConfirmationDialog({
            selector: '#addPatientDrugDialog',
            actions: {
                confirm: function () {
                    if (jq("#issueDrugCategory").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Category!");
                    } else if (jq("#drugPatientName").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Name!");
                    } else if (jq("#drugPatientFormulation").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Formulation!");
                    } else if (isNaN(parseInt(jq("#patientQuantity").val()))) {
                        jq().toastmessage('showNoticeToast', "Enter correct patientQuantity!");
                    } else {
                        if (cleared) {
                            jq('#addDrugsTable > tbody > tr').remove();
                            var tbody = jq('#addDrugsTable > tbody');
                            cleared = false;
                        }
                        var tbody = jq('#addDrugsTable').children('tbody');
                        var table = tbody.length ? tbody : jq('#addDrugsTable');
                        var index = drugOrder.length;
						
						var commt = jq('#comment').val().trim();
						
						if (commt == ''){
							commt = 'N/A'
						}						
						
                        table.append('<tr><td>' + (index + 1) + '</td><td>' + jq("#issueDrugCategory :selected").text() + '</td><td>' + jq("#drugPatientName").children(":selected").text() +
                                '</td><td>' + jq("#drugPatientFormulation option:selected").text() + '</td><td>' + jq("#patientQuantity").val() +
								'</td><td>' + commt +
                                '</td><td style="text-align: center">' + '<a class="remover" href="#" onclick="removeListItem(' + index + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
                        drugOrder.push(
                                {
                                    issueDrugCategoryId: jq("#issueDrugCategory").children(":selected").attr("id"),
                                    drugId: jq("#drugPatientName").children(":selected").attr("id"),
                                    drugPatientFormulationId: jq("#drugPatientFormulation").children(":selected").attr("id"),
                                    patientQuantity: jq("#patientQuantity").val(),
                                    issueDrugCategoryName: jq('#issueDrugCategory :selected').text(),
                                    drugPatientName: jq('#drugPatientName :selected').text(),
                                    drugPatientFormulationName: jq('#drugPatientFormulation :selected').text()
                                }
                        );

                        jq("#patientQuantity").val('');
                        jQuery("#drugKey").show();
                        jQuery("#drugSelection").hide();
						
                        addpatientdrugdialog.close();
                    }

                },
                cancel: function () {
                    jq("#patientQuantity").val('');
                    jQuery("#drugKey").show();
                    jQuery("#drugSelection").hide();
					
                    addpatientdrugdialog.close();
                }
            }
        });

        jq("#addPatientDrugsButton").on("click", function (e) {
            jq('#issueDrugCategory option').eq(0).prop('selected', true);
			
			jq("#searchPhrase").val('');
			jq("#comment").val('');
			
			jq("#drugKey").show();
            jq("#drugSelection").hide();
			
            addpatientdrugdialog.show();
        });

        jq("#printSlip").on("click", function (e) {
            if (drugOrder.length === 0) {
                jq().toastmessage('showErrorToast', "Drug List has no Drug!");
            } else {
                jq('#printList > tbody > tr').remove();
                var tbody = jq('#printList > tbody');

                jq.each(drugOrder, function (index, value) {
                    tbody.append('<tr><td>' + (index + 1) + '</td><td>' + value.issueDrugCategoryName + '</td><td>' + value.drugPatientName + '</td><td>' + value.drugPatientFormulationName + '</td><td>' + value.patientQuantity + '</td></tr>');
                });


                var printDiv = jQuery("#printDiv").html();
				
                var printWindow = window.open('', '', 'height=400,width=800');
                printWindow.document.write('<html><head><title>Drug Slip :-Support by KenyaEHRS</title>');
                printWindow.document.write('</head>');
                printWindow.document.write(printDiv);
                printWindow.document.write('</body></html>');
                printWindow.document.close();
                printWindow.print();
            }

        });

        jq("#issueDrugCategory").on("change", function (e) {
            var categoryId = jq(this).children(":selected").attr("value");
            var drugPatientNameData = "";
            jq('#drugPatientName').empty();

            if (categoryId === "0") {
                jq('<option value="">Select Drug</option>').appendTo("#drugPatientName");
                jq('#drugPatientName').change();

            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "fetchDrugNames") }', {
                    categoryId: categoryId
                }).success(function (data) {
                    


                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugPatientNameData = drugPatientNameData + '<option id="' + j + '"' + ' value="' + j + '"';
                                    }
                                    else {
                                        drugPatientNameData = drugPatientNameData + 'name="' + j + '">' + j + '</option>';
                                    }
                                }
                            }
                        }
                    }

                    jq(drugPatientNameData).appendTo("#drugPatientName");
                    jq('#drugPatientName').change();
					
					if (jq('#searchPhrase').val() !== ""){
						jq("select option").filter(function() {
							return jq(this).text() == jq('#searchPhrase').val(); 
						}).prop('selected', true);
						
						if (jq("#drugPatientName").children(":selected").text() != jq('#searchPhrase').val()){
							jq('#searchPhrase').val('');
							
							jq("#drugKey").hide();
							jq("#drugSelection").show();
						}
						
						jq('#drugPatientName').change();						
					}
					else {
						jq("#drugKey").hide();
						jq("#drugSelection").show();
					}
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });

            }

        });

        jq("#drugPatientName").on("change", function (e) {
            var drugPatientName = jq(this).children(":selected").attr("name");
            var drugPatientFormulationData = "";
            jq('#drugPatientFormulation').empty();

            if (jq(this).children(":selected").attr("value") === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#drugPatientFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugName: drugPatientName
                }).success(function (data) {
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                var name, dozage;
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugPatientFormulationData = drugPatientFormulationData + '<option id="' + j + '">';
                                    } else if (i == "name") {
                                        name = j;
                                    }
                                    else {
                                        dozage = j;
                                        drugPatientFormulationData = drugPatientFormulationData + (name + "-" + dozage) + '</option>';
                                    }
                                }
                            }
                        }
                    }
                    jq(drugPatientFormulationData).appendTo("#drugPatientFormulation");
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });
            }

        });

        jq("#searchPhrase").autocomplete({
            minLength: 3,
            source: function (request, response) {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "fetchDrugListByName") }',
                        {
                            searchPhrase: request.term
                        }
                ).success(function (data) {
                            var results = [];
                            for (var i in data) {
                                var result = {label: data[i].name, value: data[i]};
                                results.push(result);
                            }
                            response(results);
                        });
            },
            focus: function (event, ui) {
                jq("#searchPhrase").val(ui.item.value.name);
                return false;
            },
            select: function (event, ui) {
                event.preventDefault();
                jQuery("#searchPhrase").val(ui.item.value.name);

                //set parent category
                var catId = ui.item.value.category.id;
                var drgId = ui.item.value.id;
                console.log(drgId);				
				
                jq("#issueDrugCategory").val(catId).change();
                //set background drug name - frusemide
				jq('#drugPatientName').val(drgId);


            }
        });

        

        jq("#addPatientDrugsSubmitButton").click(function (event) {
            if (drugOrder.length < 1) {
                jq().toastmessage('showNoticeToast', "Drug List has no Drug!");
            } else {
                addnamefordrugslipdialog.show();
            }
        });

    });//end of doc ready

    function removeListItem(counter) {
        if (confirm("Are you sure about this?")) {
            drugOrder = jq.grep(drugOrder, function (item, index) {
                return (counter !== index);
            });
			
            jq('#addDrugsTable > tbody > tr').remove();
            var tbody = jq('#addDrugsTable > tbody');
			
            jq.each(drugOrder, function (counter, item) {
                tbody.append('<tr><td>' + (counter + 1) + '</td><td>' + item.issueDrugCategoryName + '</td><td>' + item.drugPatientName +
                        '</td><td>' + item.drugPatientFormulationName + '</td><td>' + item.patientQuantity +
                        '</td><td>' + '<a class="remover" href="#" onclick="removeListItem(' + counter + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
            });

        } else {
            return false;
        }

    }
    

</script>

<style>
	@media print {
		.donotprint {
			display: none;
		}

		.spacer {
			margin-top: 100px;
			font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
			font-style: normal;
			font-size: 14px;
		}

		.printfont {
			font-family: "Dot Matrix Normal", Arial, Helvetica, sans-serif;
			font-style: normal;
			font-size: 14px;
		}
	}
	.name {
		color: #f26522;
	}
	#breadcrumbs a, #breadcrumbs a:link, #breadcrumbs a:visited {
		text-decoration: none;
	}
	.new-patient-header .demographics .gender-age {
		font-size: 14px;
		margin-left: -55px;
		margin-top: 12px;
	}
	.new-patient-header .demographics .gender-age span {
		border-bottom: 1px none #ddd;
	}
	.new-patient-header .identifiers {
		margin-top: 5px;
	}
	.tag {
		padding: 2px 10px;
	}
	.tad {
		background: #666 none repeat scroll 0 0;
		border-radius: 1px;
		color: white;
		display: inline;
		font-size: 0.8em;
		padding: 2px 10px;
	}
	.status-container {
		padding: 5px 10px 5px 5px;
	}
	.catg{
		color: #363463;
		margin: 35px 10px 0 0;
	}
	.title{
		border: 	1px solid #eee;
		margin: 	3px 0;
		padding:	5px;
	}
	.title i{
		font-size: 1.5em;
		padding: 0;
	}
	.title span{
		font-size: 20px;
	}
	.title em{
		border-bottom: 1px solid #ddd;
		color: #888;
		display: inline-block;
		font-size: 0.5em;
		margin-right: 10px;
		text-transform: lowercase;
		width: 200px;
	}
	
	table {
		font-size: 14px;
	}
	th:first-child{
		width: 5px;
	}
	th:nth-child(4){
		min-width: 40px;
	}
	th:nth-child(5){
		width: 40px;
	}
	th:last-child{
		width: 55px;
	}
	th:nth-child(6){
		min-width: 40px;
	}
	.dialog .dialog-content li {
		margin-bottom: 0px;
	}
	.dialog label{
		display: inline-block;
		width: 115px;
	}
	.dialog select option {
		font-size: 1.0em;
	}
	.dialog select{
		display: inline-block;
		margin: 4px 0 0;
		width: 270px;
	}
	.dialog input {
		display: inline-block;
		width: 248px;
		min-width: 10%;
	}
	.dialog textarea {
		display: inline-block;
		width: 248px;
		min-width: 10%;
		resize: none
	}
	form input:focus, form select:focus, form textarea:focus, form ul.select:focus, .form input:focus, .form select:focus, .form textarea:focus, .form ul.select:focus{
		outline: 2px none #007fff;
	}
</style>

<div class="container">
	<div class="example">
		<ul id="breadcrumbs">
			<li>
				<a href="${ui.pageLink('referenceapplication', 'home')}">
					<i class="icon-home small"></i></a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="${ui.pageLink('pharmacyapp', 'dashboard')}">Pharmacy</a>
			</li>
			
			<li>
				<i class="icon-chevron-right link"></i>
				<a href="${ui.pageLink('pharmacyapp', 'container', [rel:'dispense-drugs'])}">Get Patient</a>
			</li>

			<li>
				<i class="icon-chevron-right link"></i>
				Issue Drug
			</li>
		</ul>
	</div>
	
	<div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span id="surname">${familyName},<em>surname</em></span>
                <span id="othname">${givenName} ${middleName}  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<em>other names</em>
                </span>

                <span class="gender-age">
                    <span>
                        ${gender}
                    </span>
                    <span id="agename">${age} years (${ui.formatDatePretty(birthdate)})</span>

                </span>
            </h1>

            <br/>
			
			<div id="stacont" class="status-container">
                <span class="status active"></span>
                Visit Status
            </div>
			<div class="tag">Outpatient</div>
			<div class="tad" id="lstdate">Last Visit: ${ui.formatDatetimePretty(lastVisit)}</div>
        </div>

        <div class="identifiers">
            <em>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;Patient ID</em>
            <span>${identifier}</span>
            <br>

            <div class="catg">
                <i class="icon-tags small" style="font-size: 16px"></i><small>Category:</small>${category}
            </div>
        </div>

        <div class="close"></div>
    </div>
	
	<div class="title">		
		<i class="icon-quote-left"></i>
		<span>
			DRUGS SLIP
			<em>&nbsp; of pharmacy</em>
		</span>
	</div>	
	
	<table id="addDrugsTable" class="dataTable">
		<thead>
			<tr role="row">
				<th>#</th>
				<th>DRUG CATEGORY</th>
				<th>DRUG NAME</th>
				<th>FORMULATION</th>
				<th>QNTY</th>
				<th>COMMENT</th>
				<th>ACTION</th>
			</tr>
		</thead>

		<tbody>
		</tbody>
	</table>
</div>

<div>

<div class="container">
           
          
        

           

            <input type="button" value="Issue Drug" class="button confirm" name="addPatientDrugsButton" id="addPatientDrugsButton"
                   style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printSlip"
                   id="printSlip" style="margin-top:20px;">

    </div>

    <div id="addPatientDrugDialog" class="dialog">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Drug Information</h3>
        </div>

        <form id="dialogForm">

            <div class="dialog-content">
                <ul>
                    <li>
                        <label for="issueDrugCategory">Drug Category</label>
                        <select name="issueDrugCategory" id="issueDrugCategory">
                            <option value="0">Select Category</option>
                            <% if (listCategory != null || listCategory != "") { %>
                            <% listCategory.each { issueDrugCategory -> %>
                            <option id="${issueDrugCategory.id}" value="${issueDrugCategory.id}">${issueDrugCategory.name}</option>
                            <% } %>
                            <% } %>
                        </select>
                    </li>
                    <li>
                        <div id="drugKey">
                            <label for="searchPhrase">Drug Name</label>
                            <input id="searchPhrase" name="searchPhrase"/>
                        </div>

                        <div id="drugSelection">
                            <label for="drugPatientName">Drug Name</label>
                            <select name="drugPatientName" id="drugPatientName"/>
                                <option value="0">Select Drug</option>
                            </select>
                        </div>
                    </li>
                    <li>
                        <label for="drugPatientFormulation">Formulation</label>
                        <select name="drugPatientFormulation" id="drugPatientFormulation"/>
                            <option value="0">Select Formulation</option>
                        </select>
                    </li>

                    <li>
                        <label for="patientQuantity">Quantity</label>
                        <input name="patientQuantity" id="patientQuantity" type="text"/>
                    </li>
                     <li>
                        <label for="comment">Comments</label>
                        <textarea name="comment" id="comment" type="text"></textarea>
                    </li>

                </ul>

                <span class="button confirm right">Confirm</span>
                <span class="button cancel">Cancel</span>
            </div>
        </form>
    </div>

  


    <!-- PRINT DIV -->
    <div id="printDiv" style="display: none;">
        <div style="margin: 10px auto; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
            <br/>
            <br/>
            <center style="font-size: 2.2em">Drug Slip From ${store.name}</center>
            <br/>
            <br/>
            <span style="float:right;font-size: 1.7em">Date: ${date}</span>
            <br/>
            <br/>
            
            <table border="1" id="printList">
                <thead>
                <tr role="row">
                    <th style="width: 5%">S.No</th>
                    <th style="width: 5%">Drug Category</th>
                    <th style="width: 5%">Drug Name</th>
                    <th style="width: 5%">Formulation</th>
                    <th style="width: 5%">Quantity</th>
                </tr>
                </thead>

                <tbody>
                </tbody>

            </table>
            <br/><br/><br/><br/><br/><br/>
            <span style="float:left;font-size: 1.5em">Signature of Pharmacist/ Stamp</span><span
            <br/><br/><br/><br/><br/><br/>
            <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
        </div>
    </div>
    </div>  
    <!-- END PRINT DIV -->
</div>