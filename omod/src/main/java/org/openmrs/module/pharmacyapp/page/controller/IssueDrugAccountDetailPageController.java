package org.openmrs.module.pharmacyapp.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugAccountDetail;

import org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;


/**
 * Created by USER on 4/6/2016.
 */
public class IssueDrugAccountDetailPageController {

    public void get (
            @RequestParam(value = "issueId", required = false) Integer issueId,
            UiSessionContext sessionContext,
            PageRequest pageRequest,
            UiUtils ui,
            PageModel model) {

        pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL,ui.thisUrl());
        sessionContext.requireAuthentication();

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
