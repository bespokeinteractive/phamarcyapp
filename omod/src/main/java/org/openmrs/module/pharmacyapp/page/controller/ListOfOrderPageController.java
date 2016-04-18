package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.Patient;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.model.OpdDrugOrder;
import org.openmrs.module.hospitalcore.model.PatientSearch;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Created by qqnarf on 3/29/16.
 */
public class ListOfOrderPageController {
    public void get(PageModel pageModel,
                    @RequestParam("patientId") Integer patientId,
                    @RequestParam(value = "date", required = false) String dateStr) {
        InventoryService inventoryService = Context
                .getService(InventoryService.class);
        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(patientId);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        Date date = null;
        try {
            date = sdf.parse(dateStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        List<OpdDrugOrder> listOfOrders = inventoryService.listOfOrder(patientId,date);
        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
        PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patientId);
        Patient p = new Patient(patientId);

        String patientType = hospitalCoreService.getPatientType(p);

        pageModel.addAttribute("patientType", patientType);
        pageModel.addAttribute("patientSearch", patientSearch);
        pageModel.addAttribute("listOfOrders", listOfOrders);
        pageModel.addAttribute("previousVisit",hospitalCoreService.getLastVisitTime(p));
        pageModel.addAttribute("patientCategory", patient.getAttribute(14));
        //model.addAttribute("serviceOrderSize", serviceOrderList.size());
        pageModel.addAttribute("patientId", patientId);
        pageModel.addAttribute("date", dateStr);

    }
}
