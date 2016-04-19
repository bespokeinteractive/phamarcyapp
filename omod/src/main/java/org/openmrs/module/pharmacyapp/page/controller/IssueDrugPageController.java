package org.openmrs.module.pharmacyapp.page.controller;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.openmrs.Concept;
import org.openmrs.Patient;
import org.openmrs.PersonAttribute;
import org.openmrs.PersonAttributeType;
import org.openmrs.Role;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.model.InventoryDrug;
import org.openmrs.module.hospitalcore.model.InventoryDrugCategory;
import org.openmrs.module.hospitalcore.model.InventoryDrugFormulation;
import org.openmrs.module.hospitalcore.model.InventoryStore;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatient;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatientDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugTransactionDetail;
import org.openmrs.module.hospitalcore.model.InventoryStoreRoleRelation;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.model.InventoryStoreDrugIndentDetail;
import org.openmrs.module.pharmacyapp.StoreSingleton;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

public class IssueDrugPageController {
	public void controller(){
		}

	public void get(@RequestParam(value = "categoryId", required = false) Integer categoryId,
            PageModel model) {
InventoryService inventoryService = (InventoryService) Context.getService(InventoryService.class);
List<InventoryDrugCategory> listCategory = inventoryService.findDrugCategory("");
model.addAttribute("listCategory", listCategory);
model.addAttribute("categoryId", categoryId);
if(categoryId != null && categoryId > 0){
    List<InventoryDrug> drugs = inventoryService.findDrug(categoryId, null);
    model.addAttribute("drugs",drugs);

}
// InventoryStore store = inventoryService.getStoreByCollectionRole(new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles()));
List <Role>role=new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles());

InventoryStoreRoleRelation srl=null;
Role rl = null;
for(Role r: role){
    if(inventoryService.getStoreRoleByName(r.toString())!=null){
        srl = inventoryService.getStoreRoleByName(r.toString());
        rl=r;
    }
}
InventoryStore store =null;
if(srl!=null){
    store = inventoryService.getStoreById(srl.getStoreid());

}
model.addAttribute("store",store);
model.addAttribute("date",new Date());
int userId = Context.getAuthenticatedUser().getId();
String fowardParam = "subStoreIndentDrug_"+userId;
List<InventoryStoreDrugIndentDetail> list = (List<InventoryStoreDrugIndentDetail> ) StoreSingleton.getInstance().getHash().get(fowardParam);
model.addAttribute("listIndent", list);

}
}
