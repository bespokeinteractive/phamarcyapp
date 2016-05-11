package org.openmrs.module.pharmacyapp.page.controller;

/**
 * @author Stanslaus Odhiambo
 * Created on 4/1/2016.
 */

import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugIndent;
import org.openmrs.module.hospitalcore.util.ActionValue;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.logging.Logger;

/**
 * Functional Controller for sending a drug back to main store from the pharmacy
 */
public class SendDrugIndentToMainStorePageController {

    private static final Logger logger = Logger.getLogger(SendDrugIndentToMainStorePageController.class.getName());

    public String get(UiUtils ui,
                      @RequestParam(value = "indentId", required = false) Integer indentId,
                      PageModel pageModel,
                      UiSessionContext sessionContext,
                      PageRequest pageRequest) {

        pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL,ui.thisUrl());
        sessionContext.requireAuthentication();

        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        InventoryStoreDrugIndent indent = inventoryService
                .getStoreDrugIndentById(indentId);
        if (indent != null) {
            indent.setSubStoreStatus(ActionValue.INDENT_SUBSTORE[1]);
            indent.setMainStoreStatus(ActionValue.INDENT_MAINSTORE[0]);
            inventoryService.saveStoreDrugIndent(indent);
        }

        return "redirect:" + ui.pageLink("pharmacyapp","main");

    }
}
