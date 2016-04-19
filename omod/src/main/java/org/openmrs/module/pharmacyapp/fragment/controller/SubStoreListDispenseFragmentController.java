package org.openmrs.module.pharmacyapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatient;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.util.PagingUtil;
import org.openmrs.module.inventory.util.RequestUtil;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Stanslaus Odhiambo
 *         Created on 4/19/2016.
 */
public class SubStoreListDispenseFragmentController {
    public void controller() {

    }

    public List<SimpleObject> getDispenseList(
            @RequestParam(value = "pageSize", required = false) Integer pageSize,
            @RequestParam(value = "currentPage", required = false) Integer currentPage,
            @RequestParam(value = "searchIssueName", required = false) String searchIssueName,
            @RequestParam(value = "fromDate", required = false) String fromDate,
            @RequestParam(value = "toDate", required = false) String toDate, UiUtils uiUtils,
            @RequestParam(value = "receiptId", required = false) Integer receiptId, HttpServletRequest request) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        InventoryService inventoryService = Context.getService(InventoryService.class);
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
        int total = inventoryService.countStoreDrugPatient(store.getId(), searchIssueName, fromDate, toDate);
        String temp = "";

        if (searchIssueName != null) {
            if (StringUtils.isBlank(temp)) {
                temp = "?issueName=" + searchIssueName;
            } else {
                temp += "&issueName=" + searchIssueName;
            }
        }
        if (!StringUtils.isBlank(fromDate)) {
            if (StringUtils.isBlank(temp)) {
                temp = "?fromDate=" + fromDate;
            } else {
                temp += "&fromDate=" + fromDate;
            }
        }
        if (!StringUtils.isBlank(toDate)) {
            if (StringUtils.isBlank(temp)) {
                temp = "?toDate=" + toDate;
            } else {
                temp += "&toDate=" + toDate;
            }
        }
        if (receiptId != null) {
            if (StringUtils.isBlank(temp)) {
                temp = "?receiptId=" + receiptId;
            } else {
                temp += "&receiptId=" + receiptId;
            }
        }
        PagingUtil pagingUtil = new PagingUtil(RequestUtil.getCurrentLink(request) + temp, pageSize, currentPage, total);
        if (StringUtils.isBlank(fromDate)) {
            fromDate = sdf.format(new Date());
        }
        List<InventoryStoreDrugPatient> listIssue = inventoryService.listStoreDrugPatient(store.getId(), receiptId, searchIssueName, fromDate, toDate, pagingUtil.getStartPos(), pagingUtil.getPageSize());

        for (InventoryStoreDrugPatient in : listIssue) {
            String created = sdf.format(in.getCreatedOn());
            String changed = sdf.format(new Date());
            int value = changed.compareTo(created);
            in.setValues(value);
            in = inventoryService.saveStoreDrugPatient(in);
        }
        return SimpleObject.fromCollection(listIssue, uiUtils, "id", "identifier", "values", "statuss", "createdOn", "patient.givenName", "patient.familyName",
                "patient.middleName", "patient.age", "patient.gender");

    }
}
