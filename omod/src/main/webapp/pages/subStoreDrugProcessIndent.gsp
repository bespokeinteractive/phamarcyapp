<%
    ui.decorateWith("appui", "standardEmrPage", [title: "Pharmacy Module - Process Indent"])
%>
<script>
    jq(function () {
        var storeIndent = ${listDrugNeedProcess};
        var pStoreIndent = storeIndent.listDrugNeedProcess;

        function IndentListViewModel() {
            var self = this;
            self.indentItems = ko.observableArray([]);
            var mappedStockItems = jQuery.map(pStoreIndent, function (item) {
                return new IndentItem(item);
            });

            self.viewDetails = function (item) {
                var value = item.initialItem().quantity;
                var mainStoreValue = item.initialItem().mainStoreTransfer;
                var x = item.transferQuantity();

                if (x != null && x != '') {
                    if (parseInt(x) > parseInt(value)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than quantity indent!");
                        item.transferQuantity(1);
                    } else if (parseInt(x) > parseInt(mainStoreValue)) {
                        jq().toastmessage('showNoticeToast', "Transfer quantity more than quantity at hand!");
                        item.transferQuantity(1);
                    }
                }
            }

            self.transferIndent = function () {
                if(jq("#transferIndent").hasClass("disabled")){
                    jq().toastmessage('showNoticeToast', "Transfer Not Allowed due to Insufficient Quantities!");
                }else{
                    jq("#indentsForm").submit();
                }
            }

            self.refuseIndent = function () {
                if (confirm("Are you sure about this?")) {
                    jQuery('#tableIndent').remove();
                    jQuery("#refuse").val("1");
                    jQuery('#indentsForm').submit()
                } else {
                    return false;
                }

            }
            self.returnList = function () {
                window.location.href = emr.pageLink("pharmacyapp", "container",{
                    "rel":"indent-drugs"
                });

            }
            self.indentItems(mappedStockItems);
        }

        function IndentItem(initialItem) {
            var self = this;
            self.initialItem = ko.observable(initialItem);
            self.transferQuantity = ko.observable(1);

            self.compFormulation = ko.computed(function () {
                return initialItem.formulation.name + "-" + initialItem.formulation.dozage;
            });

            self.isDisabled = ko.computed(function(){
                return (self.initialItem().mainStoreTransfer <= 0) ;
            });



        }

        var list = new IndentListViewModel();
        ko.applyBindings(list, jq("#indentlist")[0]);
    });//end of doc ready

</script>


<div class="patient-header new-patient-header">
    <div class="demographics">
        <h1 class="name">
            <span>${indent.name},<em>Drug Name</em></span>
            <span>${indent.store.name}  <em>From Store</em></span>
            <span>${indent.createdOn}  <em>Created On</em></span>
        </h1>
    </div>

    <div class="close"></div>
</div>

<div class="dashboard clear">
    <div class="info-section">
        <div class="info-header">
            <i class="icon-share"></i>

            <h3>Process Indent</h3>
        </div>
    </div>
</div>

<div id="indentlist">
    <div method="post" class="box" id="formMainStoreProcessIndent">

        <table id="tableIndent">
            <thead>
            <th>S. No.</th>
            <th>Drug</th>
            <th>Formulation</th>
            <th>Quantity Indent</th>
            <th>Transfer Quantity</th>
            </thead>
            <tbody data-bind="foreach: indentItems ">
            <td data-bind="text: (\$index() + 1),css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().drug.name,css:{'retired': isDisabled()}"></td>
            <td data-bind="text: compFormulation(),css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().quantity,css:{'retired': isDisabled()}"></td>
            <td data-bind="text: initialItem().mainStoreTransfer,css:{'retired': isDisabled()}"></td>
            </tbody>

        </table>

        <form method="post" id="indentsForm" style="padding-top: 10px">
            <input type="hidden" name="indentId" id="indentId" value="${indent.id}">
            <input type="hidden" id="refuse" name="refuse" value="">
            <textarea name="drugIntents" data-bind="value: ko.toJSON(\$root)" style="display:none;"></textarea>

            <button id="transferIndent" data-bind="click:transferIndent, css: {'disabled':indentItems()[0].isDisabled} " class="confirm"
                    style="float: right; margin-right: 2px;">Accept</button>
            <button id="refuseIndent" data-bind="click: refuseIndent" class="cancel"
                    style="margin-left: 2px">Refuse This Indent</button>
            <button data-bind="click: returnList" class="cancel">Return List</button>
        </form>

    </div>
</div>


