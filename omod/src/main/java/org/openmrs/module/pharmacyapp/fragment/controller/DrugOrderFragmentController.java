package org.openmrs.module.pharmacyapp.fragment.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugAccountDetail;
import org.openmrs.module.pharmacyapp.StoreSingleton;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Stanslaus Odhiambo
 *         Created on 4/8/2016.
 */
public class DrugOrderFragmentController {

    public List<SimpleObject> listReceiptDrugAvailable(
            @RequestParam(value = "drugId", required = false) Integer drugId,
            @RequestParam(value = "formulationId", required = false) Integer formulationId,
            @RequestParam(value = "frequencyName", required = false) String frequencyName,
            @RequestParam(value = "days", required = false) Integer days,
            @RequestParam(value = "comments", required = false) String comments,
            UiUtils uiUtils) {
        List<InventoryStoreDrugTransactionDetail> listReceiptDrugReturn = null;
        InventoryService inventoryService = (InventoryService) Context
                .getService(InventoryService.class);
        InventoryDrug drug = inventoryService.getDrugById(drugId);
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

        }
        if (store != null && drug != null && formulationId != null) {
            List<InventoryStoreDrugTransactionDetail> listReceiptDrug = inventoryService
                    .listStoreDrugTransactionDetail(store.getId(),
                            drug.getId(), formulationId, true);
            // check that drug is issued before
            int userId = Context.getAuthenticatedUser().getId();

            String fowardParam = "issueDrugAccountDetail_" + userId;
            String fowardParamDrug = "issueDrugDetail_" + userId;
            List<InventoryStoreDrugPatientDetail> listDrug = (List<InventoryStoreDrugPatientDetail>) StoreSingleton
                    .getInstance().getHash().get(fowardParamDrug);
            List<InventoryStoreDrugAccountDetail> listDrugAccount = (List<InventoryStoreDrugAccountDetail>) StoreSingleton
                    .getInstance().getHash().get(fowardParam);
            listReceiptDrugReturn = new ArrayList<InventoryStoreDrugTransactionDetail>();
            boolean check = false;
            if (CollectionUtils.isNotEmpty(listDrug)) {
                if (CollectionUtils.isNotEmpty(listReceiptDrug)) {
                    for (InventoryStoreDrugTransactionDetail drugDetail : listReceiptDrug) {
                        for (InventoryStoreDrugPatientDetail drugPatient : listDrug) {
                            if (drugDetail.getId().equals(
                                    drugPatient.getTransactionDetail().getId())) {
                                drugDetail.setCurrentQuantity(drugDetail
                                        .getCurrentQuantity()
                                        - drugPatient.getQuantity());
                            }

                        }
                        if (drugDetail.getCurrentQuantity() > 0) {
                            listReceiptDrugReturn.add(drugDetail);
                            check = true;
                        }
                    }
                }
            }

            if (CollectionUtils.isNotEmpty(listDrugAccount)) {
                if (CollectionUtils.isNotEmpty(listReceiptDrug)) {
                    for (InventoryStoreDrugTransactionDetail drugDetail : listReceiptDrug) {
                        for (InventoryStoreDrugAccountDetail drugAccount : listDrugAccount) {
                            if (drugDetail.getId().equals(
                                    drugAccount.getTransactionDetail().getId())) {
                                drugDetail.setCurrentQuantity(drugDetail
                                        .getCurrentQuantity()
                                        - drugAccount.getQuantity());
                            }
                        }
                        if (drugDetail.getCurrentQuantity() > 0 && !check) {
                            listReceiptDrugReturn.add(drugDetail);
                        }
                    }
                }
            }
            if (CollectionUtils.isEmpty(listReceiptDrugReturn)
                    && CollectionUtils.isNotEmpty(listReceiptDrug)) {
                listReceiptDrugReturn.addAll(listReceiptDrug);
            }

//            model.addAttribute("listReceiptDrug", listReceiptDrugReturn);

            // ghanshyam,4-july-2013, issue no # 1984, User can issue drugs only
            // from the first indent
            String listOfDrugQuantity = "";
            for (InventoryStoreDrugTransactionDetail lrdr : listReceiptDrugReturn) {
                listOfDrugQuantity = listOfDrugQuantity
                        + lrdr.getId().toString() + ".";
            }

//            model.addAttribute("listOfDrugQuantity", listOfDrugQuantity);
        }

        return SimpleObject.fromCollection(listReceiptDrugReturn, uiUtils, "dateExpiry","dateManufacture","companyNameShort","batchNo","currentQuantity");
    }
}
