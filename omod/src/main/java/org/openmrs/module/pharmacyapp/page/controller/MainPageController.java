package org.openmrs.module.pharmacyapp.page.controller;

import org.openmrs.ui.framework.page.PageModel;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Created by Dennys Henry on 3/14/2016.
 */
public class MainPageController {
    public void get(PageModel model) {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        String dateStr = sdf.format(new Date());
        model.addAttribute("currentDate", dateStr);
        model.addAttribute("currentTime", new Date());
    }

}
