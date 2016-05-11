package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by Dennys Henry on 4/8/2016.
 */
public class ViewCurrentStockBalanceDetailPageController {

    public void get (
            @RequestParam(value = "drugId", required = false) Integer drugId,
            @RequestParam(value = "formulationId", required = false) Integer formulationId,
            @RequestParam(value = "expiry", required = false) Integer expiry,
            PageModel model) {

        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
        InventoryDrug drug = inventoryService.getDrugById(drugId);
        InventoryDrugFormulation formulation = inventoryService.getDrugFormulationById(formulationId);

        List<Role> role = new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation storeRoleRelation = null;
        Role roleUser = null;
        for (Role rolePerson : role) {
            if (inventoryService.getStoreRoleByName(rolePerson.toString()) != null) {
                storeRoleRelation = inventoryService.getStoreRoleByName(rolePerson.toString());
                roleUser = rolePerson;
            }
        }
        InventoryStore store = null;
        if (storeRoleRelation != null) {
            store = inventoryService.getStoreById(storeRoleRelation.getStoreid());

        }
        List<InventoryStoreDrugTransactionDetail> listViewStockBalance = inventoryService
                .listStoreDrugTransactionDetail(store.getId(), drugId,
                        formulationId, expiry);
        model.addAttribute("listViewStockBalance", listViewStockBalance);
        model.addAttribute("formulation",formulation);
        model.addAttribute("drug",drug);
    }
}

