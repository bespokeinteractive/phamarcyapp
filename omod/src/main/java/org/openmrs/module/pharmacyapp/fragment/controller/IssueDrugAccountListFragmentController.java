package org.openmrs.module.pharmacyapp.fragment.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.Role;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugAccount;
import org.openmrs.module.inventory.util.PagingUtil;
import org.openmrs.module.inventory.util.RequestUtil;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by USER on 3/29/2016.
 */
public class IssueDrugAccountListFragmentController {
    public void controller(){

    }

    public List<SimpleObject> fetchList( @RequestParam(value="pageSize",required=false)  Integer pageSize,
                        @RequestParam(value="currentPage",required=false)  Integer currentPage,
                        @RequestParam(value="issueName",required=false)  String issueName,
                        @RequestParam(value="fromDate",required=false)  String fromDate,
                        @RequestParam(value="toDate",required=false)  String toDate,
                        UiUtils uiUtils, HttpServletRequest request
    ) {
        InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);

        List<Role> role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

        InventoryStoreRoleRelation storeRoleRelation=null;
        Role roleUser = null;
        for(Role rolePerson: role){
            if(inventoryService.getStoreRoleByName(rolePerson.toString())!=null){
                storeRoleRelation = inventoryService.getStoreRoleByName(rolePerson.toString());
                roleUser=rolePerson;
            }
        }
        InventoryStore store =null;
        if(storeRoleRelation!=null){
            store = inventoryService.getStoreById(storeRoleRelation.getStoreid());

        }
        int total = inventoryService.countStoreDrugAccount(store.getId(), issueName, fromDate, toDate);
        String temp = "";

        if(issueName != null){
            if(StringUtils.isBlank(temp)){
                temp = "?issueName="+issueName;
            }else{
                temp +="&issueName="+issueName;
            }
        }
        if(!StringUtils.isBlank(fromDate)){
            if(StringUtils.isBlank(temp)){
                temp = "?fromDate="+fromDate;
            }else{
                temp +="&fromDate="+fromDate;
            }
        }
        if(!StringUtils.isBlank(toDate)){
            if(StringUtils.isBlank(temp)){
                temp = "?toDate="+toDate;
            }else{
                temp +="&toDate="+toDate;
            }
        }

        PagingUtil pagingUtil = new PagingUtil( RequestUtil.getCurrentLink(request)+temp , pageSize, currentPage, total );
        List<InventoryStoreDrugAccount> listIssue = inventoryService.listStoreDrugAccount(store.getId(), issueName,fromDate, toDate, pagingUtil.getStartPos(), pagingUtil.getPageSize());

        return SimpleObject.fromCollection(listIssue,uiUtils,"name","createdOn");
    }


}
