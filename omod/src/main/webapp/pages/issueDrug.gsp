<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
%>

<script>
    var drugOrder = [];
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
                        table.append('<tr><td>' + (index + 1) + '</td><td>' + jq("#issueDrugCategory :selected").text() + '</td><td>' + jq("#drugPatientName").val() +
                                '</td><td>' + jq("#drugPatientFormulation option:selected").text() + '</td><td>' + jq("#patientQuantity").val() +
                                '</td><td>' + '<a class="remover" href="#" onclick="removeListItem(' + index + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
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
                        adddrugdialog.close();
                    }

                },
                cancel: function () {
                    jq("#patientQuantity").val('');
                    jQuery("#drugKey").show();
                    jQuery("#drugSelection").hide();
                    adddrugdialog.close();
                }
            }
        });


        var addnameforDrugslipdialog = emr.setupConfirmationDialog({
            selector: '#addNameForDrugSlip',
            actions: {
                confirm: function () {
                    if (jq("#slipName").val() == '') {
                        jq().toastmessage('showNoticeToast', "Enter drug slip Name!");
                    } else if (jq("#mainstore").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Main Store!");
                    } else {
                        indentName.push(
                                {
                                    indentName: jq("#indentName").val(),
                                    mainstore: jq("#mainstore").children(":selected").attr("id")
                                }
                        );
                        drugOrder = JSON.stringify(drugOrder);
                        indentName = JSON.stringify(indentName);

                        var addDrugsData = {
                            'drugOrder': drugOrder,
                            'indentName': indentName,
                            'send': 1,
                            'action': 2,
                            'keepThis': false
                        };
                        jq.getJSON('${ ui.actionLink("pharmacyapp", "issueDrug", "saveDrugSlip") }', addDrugsData)
                                .success(function (data) {
                                    jq().toastmessage('showNoticeToast', "Save Drug Slip Successful!");
                                    window.location.href = emr.pageLink("pharmacyapp", "main", {
                                        "tabId": "manage"
                                    });

                                })
                                .error(function (xhr, status, err) {
                                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                                })
                        addnamefordrugslipdialog.close();
                        jq("#dialogForm").reset();
                    }
                },
                cancel: function () {
//                    jq("#dialogForm").reset();
                    addnamefordrugslipdialog.close();
                }
            }
        });


        jq("#addPatientDrugsButton").on("click", function (e) {
            jq('#issueDrugCategory option').eq(0).prop('selected', true).change();
            addpatientdrugdialog.show();
        });
        jq("#clearSlip").on("click", function (e) {
            if (drugOrder.length === 0) {
                jq().toastmessage('showNoticeToast', "Drug List has no Drug!");
            } else {
                if (confirm("Are you sure about this?")) {
                    drugOrder = [];
                    jq('#addDrugsTable > tbody > tr').remove();
                    var tbody = jq('#addDrugsTable > tbody');
                    var row = '<tr align="center"><td colspan="5">No Drugs Listed</td></tr>';
                    tbody.append(row);
                    cleared = true;
                } else {
                    return false;
                }
            }

        });
        jq("#returnToDrugList").on("click", function (e) {
            window.location.href = emr.pageLink("pharmacyapp", "main", {
                "tabId": "manage"
            });
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
                    jQuery("#drugKey").hide();
                    jQuery("#drugSelection").show();


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
                jq("#issueDrugCategory").val(catId);
                jq("#issueDrugCategory").change();
                //set background drug name - frusemide


            }
        });

        jq("#searchPhrase").on("change", function (e) {
            var drugPatientName = jq(this).val();
            var drugPatientFormulationData = "";
            jq('#drugPatientFormulation').empty();

            if (drugPatientName === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#drugPatientFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugPatientFormulation: drugPatientFormulation
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
                    jq('<option value="">Select Formulation</option>').appendTo("#drugPatientFormulation");
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });
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
//            drugOrder.splice(index, 1);
            drugOrder = jq.grep(drugOrder, function (item, index) {
                return (counter !== index);
            });
            jq('#addDrugsTable > tbody > tr').remove();
            var tbody = jq('#addDrugsTable > tbody');
//            var table = tbody.length ? tbody : jq('#addDrugsTable');
            jq.each(drugOrder, function (counter, item) {
                tbody.append('<tr><td>' + (counter + 1) + '</td><td>' + item.issueDrugCategoryName + '</td><td>' + item.drugPatientName +
                        '</td><td>' + item.drugPatientFormulationName + '</td><td>' + item.patientQuantity +
                        '</td><td>' + '<a class="remover" href="#" onclick="removeListItem(' + counter + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
            });

        } else {
            return false;
        }

    }

    function loadDrugFormulations() {

    }
    

</script>

<div id="printDiv">
<div class="clear"></div>

<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="${ui.pageLink('referenceapplication', 'home')}">
                    <i class="icon-home small"></i></a>
            </li>

            <li>
                <i class="icon-chevron-right link"></i>
                Pharmacy Module
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="dashboard clear">
        <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>Patient Information</h3>
                </div>
        <div>
        <table id="patientTable" class="dataTable">
                <thead>
                <tr role="row">
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Patient Identifier<span class="DataTables_sort_icon"></span></div>
                    </th>
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Patient Name<span class="DataTables_sort_icon"></span></div>
                    </th>
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Age<span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Gender<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Category<span class="DataTables_sort_icon"></span></div>
                    </th>
                    
                </tr>
                </thead>

                <tbody>
                    <tr>
                        <td>${patientIdentifier}</td>
                        <td>${names}</td>
                        <td>${age}</td>
                        <td>${gender}</td>
                        <td>${category}</td>
                    </tr>
                </tbody>
            </table>
            </div>
        
        </div>
        </div>

            <div class="info-section">
                <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>Drug Slip of Pharmacy</h3>
                </div>
          
        
        <div>
            <table id="addDrugsTable" class="dataTable">
                <thead>
                <tr role="row">
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Issue S.No<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Issue Drug Category<span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Issue Drug Name<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Issue Formulation<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Issue Quantity<span class="DataTables_sort_icon"></span></div>
                    </th>
                    <th class="ui-state-default">

                    </th>
                </tr>
                </thead>

                <tbody>
                </tbody>
            </table>

           

            <input type="button" value="Issue Drug" class="button confirm" name="addPatientDrugsButton" id="addPatientDrugsButton"
                   style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printSlip"
                   id="printSlip" style="margin-top:20px;">
        </div>

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
                        <label for="issueDrugCategory"> Issue Drug Category</label>
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
                            <label for="searchPhrase"> Issue Drug Name</label>
                            <input id="searchPhrase" name="searchPhrase" onblur="loadDrugFormulations();"/>
                        </div>

                        <div id="drugSelection">
                            <label for="drugPatientName">Issue Drug Name</label>
                            <select name="drugPatientName" id="drugPatientName">
                                <option value="0">Select Drug</option>
                            </select>
                        </div>
                    </li>
                    <li>
                        <lable for="drugPatientFormulation"> Issue Formulation</lable>
                        <select name="drugPatientFormulation" id="drugPatientFormulation">
                            <option value="0">Select Formulation</option>
                        </select>
                    </li>

                    <li>
                        <label for="patientQuantity">Issue Quantity</label>
                        <input name="patientQuantity" id="patientQuantity" type="text">
                    </li>
                     <li>
                        <label for="comment">Issue Comment</label>
                        <input name="comment" id="comment" type="text">
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