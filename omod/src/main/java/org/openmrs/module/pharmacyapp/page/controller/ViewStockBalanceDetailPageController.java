package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Set;

/**
 * Created by qqnarf on 4/6/16.
 */
public class ViewStockBalanceDetailPageController {
    public void get( @RequestParam(value = "drugId", required = false) Integer drugId,
                     @RequestParam(value = "formulationId", required = false) Integer formulationId,
                     @RequestParam(value = "expiry", required = false) Integer expiry,
                     PageModel pageModel){

        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);

        pageModel.addAttribute("drugId",drugId );
        pageModel.addAttribute("formulationId",formulationId );
        pageModel.addAttribute("expiry",expiry );

        InventoryDrug drug = inventoryService.getDrugById(drugId);
        InventoryDrugFormulation formulation = inventoryService.getDrugFormulationById(formulationId);

        pageModel.addAttribute("formulation",formulation);
        pageModel.addAttribute("drug",drug);

    }

}
