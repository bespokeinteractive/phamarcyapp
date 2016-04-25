package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.Action;
import org.openmrs.module.hospitalcore.util.ActionValue;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Dennys Henry on 3/14/2016.
 */
public class MainPageController {
    public String get(PageModel model,@RequestParam(value="tabId",required=false)  String tabId) {
        List<Action> listDrugAttribute = ActionValue.getListDrugAttribute();
        model.addAttribute("listDrugAttribute", listDrugAttribute);

        List<InventoryStoreDrugTransactionDetail> listReceiptDrugReturn = null;
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);

        List<InventoryDrugCategory> listCategory = inventoryService.listDrugCategory("", 0, 0);


        List<Role> role = new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());
        InventoryStoreRoleRelation srl = null;
        Role rl = null;
        for (Role r : role) {
            if (inventoryService.getStoreRoleByName(r.toString()) != null) {
                srl = inventoryService.getStoreRoleByName(r.toString());
                rl = r;
            }
        }
        InventoryStore store = null;
        if (srl != null) {
            store = inventoryService.getStoreById(srl.getStoreid());
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            String dateStr = sdf.format(new Date());
            model.addAttribute("currentDate", dateStr);
            model.addAttribute("currentTime", new Date());

            List<Action> listSubStoreStatus = ActionValue.getListIndentSubStore();
            model.addAttribute("listSubStoreStatus", listSubStoreStatus);

            model.addAttribute("tabId", tabId);

            model.put("listCategory", listCategory);
        } else {
            return "redirect: index.htm";
        }
        return null;
    }

}
