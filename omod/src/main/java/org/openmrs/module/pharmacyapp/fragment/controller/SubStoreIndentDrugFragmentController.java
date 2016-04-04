package org.openmrs.module.pharmacyapp.fragment.controller;

import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;

import javax.servlet.http.HttpServletRequest;

/**
 * @author Stanslaus Odhiambo
 * Created on 4/4/2016.
 */
public class SubStoreIndentDrugFragmentController {

    public void saveIndentSlip(PageModel pageModel, UiUtils uiUtils,HttpServletRequest request){
        System.out.println(request.getParameter("drugOrder"));

    }

}
