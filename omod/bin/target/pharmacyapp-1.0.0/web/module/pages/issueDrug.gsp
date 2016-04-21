<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module"])
%>

<script>
    var drugOrder = [];
    jq(function () {
        var cleared = false;
        jq("#drugSelection").hide();

        var slipName = [];
        var adddrugdialog = emr.setupConfirmationDialog({
            selector: '#addDrugDialog',
            actions: {
                confirm: function () {
                    if (jq("#drugCategory").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Category!");
                    } else if (jq("#drugName").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Drug Name!");
                    } else if (jq("#drugFormulation").val() == 0) {
                        jq().toastmessage('showNoticeToast', "Select a Formulation!");
                    } else if (isNaN(parseInt(jq("#quantity").val()))) {
                        jq().toastmessage('showNoticeToast', "Enter correct quantity!");
                    } else {
                        if (cleared) {
                            jq('#addDrugsTable > tbody > tr').remove();
                            var tbody = jq('#addDrugsTable > tbody');
                            cleared = false;
                        }
                        var tbody = jq('#addDrugsTable').children('tbody');
                        var table = tbody.length ? tbody : jq('#addDrugsTable');
                        var index = drugOrder.length;
                        table.append('<tr><td>' + (index + 1) + '</td><td>' + jq("#drugCategory :selected").text() + '</td><td>' + jq("#drugName").val() +
                                '</td><td>' + jq("#drugFormulation option:selected").text() + '</td><td>' + jq("#quantity").val() +
                                '</td><td>' + '<a class="remover" href="#" onclick="removeListItem(' + index + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
                        drugOrder.push(
                                {
                                    drugCategoryId: jq("#drugCategory").children(":selected").attr("id"),
                                    drugId: jq("#drugName").children(":selected").attr("id"),
                                    drugFormulationId: jq("#drugFormulation").children(":selected").attr("id"),
                                    quantity: jq("#quantity").val(),
                                    drugCategoryName: jq('#drugCategory :selected').text(),
                                    drugName: jq('#drugName :selected').text(),
                                    drugFormulationName: jq('#drugFormulation :selected').text()
                                }
                        );

                        jq("#quantity").val('');
                        jQuery("#drugKey").show();
                        jQuery("#drugSelection").hide();
                        adddrugdialog.close();
                    }

                },
                cancel: function () {
                    jq("#quantity").val('');
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
                        jq().toastmessage('showNoticeToast', "Enter slip Name!");
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


        jq("#addDrugsButton").on("click", function (e) {
            jq('#drugCategory option').eq(0).prop('selected', true).change();
            adddrugdialog.show();
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
                    tbody.append('<tr><td>' + (index + 1) + '</td><td>' + value.drugCategoryName + '</td><td>' + value.drugName + '</td><td>' + value.drugFormulationName + '</td><td>' + value.quantity + '</td></tr>');
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

        jq("#drugCategory").on("change", function (e) {
            var categoryId = jq(this).children(":selected").attr("value");
            var drugNameData = "";
            jq('#drugName').empty();

            if (categoryId === "0") {
                jq('<option value="">Select Drug</option>').appendTo("#drugName");
                jq('#drugName').change();

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
                                        drugNameData = drugNameData + '<option id="' + j + '"' + ' value="' + j + '"';
                                    }
                                    else {
                                        drugNameData = drugNameData + 'name="' + j + '">' + j + '</option>';
                                    }
                                }
                            }
                        }
                    }

                    jq(drugNameData).appendTo("#drugName");
                    jq('#drugName').change();
                }).error(function (xhr, status, err) {
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });

            }

        });

        jq("#drugName").on("change", function (e) {
            var drugName = jq(this).children(":selected").attr("name");
            var drugFormulationData = "";
            jq('#drugFormulation').empty();

            if (jq(this).children(":selected").attr("value") === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#drugFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugName: drugName
                }).success(function (data) {
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                var name, dozage;
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugFormulationData = drugFormulationData + '<option id="' + j + '">';
                                    } else if (i == "name") {
                                        name = j;
                                    }
                                    else {
                                        dozage = j;
                                        drugFormulationData = drugFormulationData + (name + "-" + dozage) + '</option>';
                                    }
                                }
                            }
                        }
                    }
                    jq(drugFormulationData).appendTo("#drugFormulation");
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
                jq("#drugCategory").val(catId);
                jq("#drugCategory").change();
                //set background drug name - frusemide


            }
        });

        jq("#searchPhrase").on("change", function (e) {
            var drugName = jq(this).val();
            var drugFormulationData = "";
            jq('#drugFormulation').empty();

            if (drugName === "") {
                jq('<option value="">Select Formulation</option>').appendTo("#drugFormulation");
            } else {
                jq.getJSON('${ ui.actionLink("pharmacyapp", "addReceiptsToStore", "getFormulationByDrugName") }', {
                    drugName: drugName
                }).success(function (data) {
                    for (var key in data) {
                        if (data.hasOwnProperty(key)) {
                            var val = data[key];
                            for (var i in val) {
                                var name, dozage;
                                if (val.hasOwnProperty(i)) {
                                    var j = val[i];
                                    if (i == "id") {
                                        drugFormulationData = drugFormulationData + '<option id="' + j + '">';
                                    } else if (i == "name") {
                                        name = j;
                                    }
                                    else {
                                        dozage = j;
                                        drugFormulationData = drugFormulationData + (name + "-" + dozage) + '</option>';
                                    }
                                }
                            }
                        }
                    }
                    jq(drugFormulationData).appendTo("#drugFormulation");
                }).error(function (xhr, status, err) {
                    jq('<option value="">Select Formulation</option>').appendTo("#drugFormulation");
                    jq().toastmessage('showNoticeToast', "AJAX error!" + err);
                });
            }

        });

        jq("#addDrugsSubmitButton").click(function (event) {
            if (drugOrder.length < 1) {
                jq().toastmessage('showNoticeToast', "Indent List has no Drug!");
            } else {
                addnameforindentslipdialog.show();
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
                tbody.append('<tr><td>' + (counter + 1) + '</td><td>' + item.drugCategoryName + '</td><td>' + item.drugName +
                        '</td><td>' + item.drugFormulationName + '</td><td>' + item.quantity +
                        '</td><td>' + '<a class="remover" href="#" onclick="removeListItem(' + counter + ');"><i class="icon-remove small" style="color:red"></i></a>' + '</td></tr>');
            });

        } else {
            return false;
        }

    }

    function loadDrugFormulations() {

    }

</script>

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
            <div class="info-section">
                <div class="info-header">
                    <i class="icon-calendar"></i>

                    <h3>Drug Slip of Pharmacy</h3>
                </div>
            </div>
        </div>

        <div>
            <table id="addDrugsTable" class="dataTable">
                <thead>
                <tr role="row">
                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">S.No<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Category<span class="DataTables_sort_icon"></span>
                        </div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Drug Name<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Formulation<span class="DataTables_sort_icon"></span></div>
                    </th>

                    <th class="ui-state-default">
                        <div class="DataTables_sort_wrapper">Quantity<span class="DataTables_sort_icon"></span></div>
                    </th>
                    <th class="ui-state-default">

                    </th>
                </tr>
                </thead>

                <tbody>
                </tbody>
            </table>

           

            <input type="button" value="Add Drug" class="button confirm" name="addDrugsButton" id="addDrugsButton"
                   style="margin-top:20px;">
            <input type="button" value="Back To Drug List" class="button confirm" name="returnToDrugList"
                   id="returnToDrugList" style="margin-top:20px;">
            <input type="button" value="Print" class="button confirm" name="printSlip"
                   id="printSlip" style="margin-top:20px;">
        </div>

    </div>

    <div id="addDrugDialog" class="dialog">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Drug Information</h3>
        </div>

        <form id="dialogForm">

            <div class="dialog-content">
                <ul>
                    <li>
                        <label for="drugCategory">Drug Category</label>
                        <select name="drugCategory" id="drugCategory">
                            <option value="0">Select Category</option>
                            <% if (listCategory != null || listCategory != "") { %>
                            <% listCategory.each { drugCategory -> %>
                            <option id="${drugCategory.id}" value="${drugCategory.id}">${drugCategory.name}</option>
                            <% } %>
                            <% } %>
                        </select>
                    </li>
                    <li>
                        <div id="drugKey">
                            <label for="searchPhrase">Drug Name</label>
                            <input id="searchPhrase" name="searchPhrase" onblur="loadDrugFormulations();"/>
                        </div>

                        <div id="drugSelection">
                            <label for="drugName">Drug Name</label>
                            <select name="drugName" id="drugName">
                                <option value="0">Select Drug</option>
                            </select>
                        </div>
                    </li>
                    <li>
                        <lable for="drugFormulation">Formulation</lable>
                        <select name="drugFormulation" id="drugFormulation">
                            <option value="0">Select Formulation</option>
                        </select>
                    </li>

                    <li>
                        <label for="quantity">Quantity</label>
                        <input name="quantity" id="quantity" type="text">
                    </li>

                </ul>

                <span class="button confirm right">Confirm</span>
                <span class="button cancel">Cancel</span>
            </div>
        </form>
    </div>

    <div id="addNameForDrugSlip" class="dialog">
        <div class="dialog-header">
            <i class="icon-folder-open"></i>

            <h3>Add Name For Drug Slip</h3>
        </div>

        <div class="dialog-content">
            <ul>
                <li>
                    <lable for="slipName">Name</lable>
                    <input type="text" name="slipName" id="slipName"/>
                </li>
                <li>
                    <label for="mainstore">Select Main Store Indent</label>
                    <select name="mainstore" id="mainstore">
                        <option value="0">Select Store</option>
                        <% if (store != null || store != "") { %>
                        <% store.parentStores.each { vparent -> %>
                        <option id="${vparent.id}">${vparent.name}</option>
                        <% } %>
                        <% } %>
                    </select>
                </li>
            </ul>

            <span class="button confirm right">Confirm</span>
            <span class="button cancel">Cancel</span>
        </div>
    </div>


    <!-- PRINT DIV -->
    <div id="printDiv" style="display: none;">
        <div style="margin: 10px auto; font-size: 1.0em;font-family:'Dot Matrix Normal',Arial,Helvetica,sans-serif;">
            <br/>
            <br/>
            <center style="font-size: 2.2em">Indent From ${store.name}</center>
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
            <span style="float:left;font-size: 1.5em">Signature of sub-store/ Stamp</span><span
                style="float:right;font-size: 1.5em">Signature of inventory clerk/ Stamp</span>
            <br/><br/><br/><br/><br/><br/>
            <span style="margin-left: 13em;font-size: 1.5em">Signature of Medical Superintendent/ Stamp</span>
        </div>
    </div>
    <!-- END PRINT DIV -->
</div>