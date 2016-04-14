package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.InventoryStoreDrugPatient;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

/**
 * Created by qqnarf on 3/31/16.
 */
public class DrugOrderPageController {
    public void get(
            PageModel model,
            @RequestParam("patientId") Integer patientId,
            @RequestParam("encounterId") Integer encounterId,
            @RequestParam(value = "date", required = false) String dateStr,
            @RequestParam(value = "patientType", required = false) String patientType,
            UiUtils uiUtils) {
        InventoryService inventoryService = Context
                .getService(InventoryService.class);

        List<OpdDrugOrder> drugOrderList = inventoryService.listOfDrugOrder(
                patientId, encounterId);
        List<SimpleObject> simpleObjects = SimpleObject.fromCollection(drugOrderList, uiUtils, "inventoryDrug.name",
                "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage", "frequency.name", "noOfDays", "comments", "inventoryDrug.id", "inventoryDrugFormulation.id");


        model.addAttribute("drugOrderListJson", SimpleObject.create("simpleObjects", simpleObjects).toJson());
        model.addAttribute("drugOrderList", drugOrderList);
        model.addAttribute("patientId", patientId);
        model.addAttribute("encounterId", encounterId);
        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
        PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patientId);
        model.addAttribute("patientSearch", patientSearch);
        model.addAttribute("patientType", patientType);
        model.addAttribute("date", dateStr);
        model.addAttribute("doctor", drugOrderList.get(0).getCreator().getGivenName());
        InventoryStoreDrugPatient inventoryStoreDrugPatient = new InventoryStoreDrugPatient();
        model.addAttribute("pharmacist", Context.getAuthenticatedUser().getGivenName());
        model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
    }

    public String post(HttpServletRequest request, @RequestParam("patientId") Integer patientId,
                       @RequestParam("encounterId") Integer encounterId, @RequestParam(value = "paymentMode", required = false) String paymentMode,
                       @RequestParam(value = "patientType", required = false) String patientType,
                       @RequestParam(value = "avaiableId", required = false) String[] avaiableId) {
        System.out.println(request.getParameter("order"));

        return null;

    }
}
