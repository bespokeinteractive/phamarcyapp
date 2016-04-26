package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by Dennis Henry on 4/15/2016.
 */
public class ContainerPageController {
    public void get( @RequestParam(value = "rel", required = true) String rel,
                     @RequestParam(value = "date", required = false) String date,
                     PageModel model) {

        model.addAttribute("date", date);

        if (rel.equals("patients-queue")){
            model.addAttribute("fragment", "queue");
            model.addAttribute("title", "Patient Queue");
            model.addAttribute("header", "PATIENT QUEUE LIST");
        }
        else if (rel.equals("dispense-drugs")){
            model.addAttribute("fragment", "subStoreListDispense");
            model.addAttribute("title", "Dispense Drugs");
            model.addAttribute("header", "DISPENSE DRUGS TO PATIENT");
        }
        else if (rel.equals("issue-to-patient")){
            model.addAttribute("fragment", "issuePatientDrug");
            model.addAttribute("title", "Issue Drugs to Patient");
            model.addAttribute("header", "DISPENSE DRUGS TO PATIENT");
        }
        else {
            model.addAttribute("fragment", "404");
            model.addAttribute("title", "404");
            model.addAttribute("header", "404");
        }
    }
}
