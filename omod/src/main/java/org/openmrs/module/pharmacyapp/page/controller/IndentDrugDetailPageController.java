package org.openmrs.module.pharmacyapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugIndent;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugIndentDetail;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * @author Stanslaus Odhiambo
 *         Created on 4/6/2016.
 */
public class IndentDrugDetailPageController {
    public void get(@RequestParam(value = "indentId", required = false) Integer indentId,
                    PageModel pageModel) {
        pageModel.addAttribute("listTransactionDetail", "");
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        InventoryStoreDrugIndent indent = inventoryService
                .getStoreDrugIndentById(indentId);
        List<InventoryStoreDrugIndentDetail> listIndentDetail = inventoryService
                .listStoreDrugIndentDetail(indentId);
        pageModel.addAttribute("listIndentDetail", listIndentDetail);
        if (indent != null && indent.getTransaction() != null) {
            List<InventoryStoreDrugTransactionDetail> listTransactionDetail = inventoryService
                    .listTransactionDetail(indent.getTransaction().getId());
            pageModel.addAttribute("listTransactionDetail", listTransactionDetail);
        }
        pageModel.addAttribute("store",
                !CollectionUtils.isEmpty(listIndentDetail) ? listIndentDetail
                        .get(0).getIndent().getStore() : null);
        pageModel.addAttribute("date",
                !CollectionUtils.isEmpty(listIndentDetail) ? listIndentDetail
                        .get(0).getIndent().getCreatedOn() : null);

    }

}
