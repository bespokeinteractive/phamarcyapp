package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

/**
 * @author Stanslaus Odhiambo
 *         Created on 4/20/2016.
 */
public class SubStoreIssueAccountDrugPageController {
    public void get(@RequestParam(value = "categoryId", required = false) Integer categoryId,
                    PageModel model,UiUtils uiUtils) {
        InventoryService inventoryService = Context.getService(InventoryService.class);

        List<InventoryDrugCategory> listCategory = inventoryService.findDrugCategory("");
        model.addAttribute("listCategory", listCategory);

        model.addAttribute("categoryId", categoryId);
        if (categoryId != null && categoryId > 0) {
            List<InventoryDrug> drugs = inventoryService.findDrug(categoryId, null);
            List<SimpleObject> simpleDrugs = SimpleObject.fromCollection(drugs, uiUtils, "id");
            model.addAttribute("drugs", SimpleObject.create("drugs",simpleDrugs).toJson());
        }
        model.addAttribute("date", new Date());
    }
}
