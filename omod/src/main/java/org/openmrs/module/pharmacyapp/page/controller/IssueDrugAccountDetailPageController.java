package org.openmrs.module.pharmacyapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugAccountDetail;

import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


/**
 * Created by USER on 4/6/2016.
 */
public class IssueDrugAccountDetailPageController {

    public void get (
            @RequestParam(value = "issueId", required = false) Integer issueId,
            PageModel model) {
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        List<InventoryStoreDrugAccountDetail> listDrugIssue = inventoryService
                .listStoreDrugAccountDetail(issueId);
        model.addAttribute("listDrugIssue", listDrugIssue);
        if (CollectionUtils.isNotEmpty(listDrugIssue)) {
            model.addAttribute("issueDrugAccount", listDrugIssue.get(0)
                    .getDrugAccount());
            model.addAttribute("date", listDrugIssue.get(0).getDrugAccount()
                    .getCreatedOn());
        }

    }
}
