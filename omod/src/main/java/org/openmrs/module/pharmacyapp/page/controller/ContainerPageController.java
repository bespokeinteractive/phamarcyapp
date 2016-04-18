package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by Dennis Henry on 4/15/2016.
 */
public class ContainerPageController {
    public void get( @RequestParam(value = "rel", required = true) String rel,
                     PageModel model) {
        if (rel.equals("patients-queue")){
            model.addAttribute("fragment", "queue");
            model.addAttribute("title", "Patient Queue");
            model.addAttribute("header", "PATIENT QUEUE LIST");
        }
        else {
            model.addAttribute("fragment", "404");
            model.addAttribute("title", "404");
            model.addAttribute("header", "404");
        }
    }
}
