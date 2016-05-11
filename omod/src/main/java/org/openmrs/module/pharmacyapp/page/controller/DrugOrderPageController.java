package org.openmrs.module.pharmacyapp.page.controller;

import org.apache.commons.lang.StringUtils;
import org.json.JSONArray;
import org.json.JSONObject;
import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.appui.UiSessionContext;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.InventoryCommonService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ActionValue;
import org.openmrs.module.inventory.InventoryService;
import org.openmrs.module.inventory.util.DateUtils;
import org.openmrs.module.referenceapplication.ReferenceApplicationWebConstants;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.openmrs.ui.framework.page.PageRequest;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by Francis Githae on 3/31/16.
 */
public class DrugOrderPageController {
    public void get(
            PageModel model,
            UiSessionContext sessionContext,
            PageRequest pageRequest,
            @RequestParam("patientId") Integer patientId,
            @RequestParam("encounterId") Integer encounterId,
            @RequestParam(value = "date", required = false) String dateStr,
            @RequestParam(value = "patientType", required = false) String patientType,
            UiUtils uiUtils) {

        pageRequest.getSession().setAttribute(ReferenceApplicationWebConstants.SESSION_ATTRIBUTE_REDIRECT_URL,uiUtils.thisUrl());
        sessionContext.requireAuthentication();

        InventoryService inventoryService = Context
                .getService(InventoryService.class);

        List<OpdDrugOrder> drugOrderList = inventoryService.listOfDrugOrder(
                patientId, encounterId);
        List<SimpleObject> simpleObjects = SimpleObject.fromCollection(drugOrderList, uiUtils, "inventoryDrug.name",
                "inventoryDrugFormulation.name", "inventoryDrugFormulation.dozage", "frequency.name", "noOfDays", "comments",
                "inventoryDrug.id", "inventoryDrugFormulation.id");


        model.addAttribute("drugOrderListJson", SimpleObject.create("simpleObjects", simpleObjects).toJson());
        model.addAttribute("drugOrderList", drugOrderList);
        model.addAttribute("patientId", patientId);
        model.addAttribute("encounterId", encounterId);

        HospitalCoreService hospitalCoreService = Context.getService(HospitalCoreService.class);
        PatientSearch patientSearch = hospitalCoreService.getPatientByPatientId(patientId);

        Patient patient = Context.getPatientService().getPatient(patientId);

        model.addAttribute("patientCategory", patient.getAttribute(14));
        model.addAttribute("previousVisit",hospitalCoreService.getLastVisitTime(patient));
        model.addAttribute("patientSearch", patientSearch);
        model.addAttribute("patientType", patientType);
        model.addAttribute("date", dateStr);
        model.addAttribute("doctor", drugOrderList.get(0).getCreator().getGivenName());

        InventoryStoreDrugPatient inventoryStoreDrugPatient = new InventoryStoreDrugPatient();

        model.addAttribute("pharmacist", Context.getAuthenticatedUser().getGivenName());
        model.addAttribute("userLocation", Context.getAdministrationService().getGlobalProperty("hospital.location_user"));
    }

    public String post(HttpServletRequest request, UiUtils uiUtils) throws Exception {
        String order = request.getParameter("order");
        String patientType = request.getParameter("patientType");
        String paymentMode = request.getParameter("paymentMode");
        int encounterId = Integer.parseInt(request.getParameter("encounterId"));
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        BigDecimal waiverAmount = null;
        if(StringUtils.isNotEmpty(request.getParameter("waiverAmount"))){
            waiverAmount = new BigDecimal(request.getParameter("waiverAmount"));
        }

        String comment = request.getParameter("comment");


        JSONArray orders = new JSONArray(order);

        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(patientId);
        InventoryService inventoryService = Context.getService(InventoryService.class);
        //InventoryStore store =  inventoryService.getStoreByCollectionRole(new ArrayList<Role>(Context.getAuthenticatedUser().getAllRoles()));
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
        Date date = new Date();
        Integer formulationId;
        String frequencyName;
        String comments;
        Integer quantity;
        Integer noOfDays;
        Integer avlId;

        InventoryStoreDrugPatient inventoryStoreDrugPatient = new InventoryStoreDrugPatient();
        inventoryStoreDrugPatient.setStore(store);
        inventoryStoreDrugPatient.setPatient(patient);
        if (patient.getMiddleName() != null) {
            inventoryStoreDrugPatient.setName(patient.getGivenName() + " " + patient.getFamilyName() + " " + patient.getMiddleName().replace(",", " "));
        } else {
            inventoryStoreDrugPatient.setName(patient.getGivenName() + " " + patient.getFamilyName());
        }
        inventoryStoreDrugPatient.setIdentifier(patient.getPatientIdentifier().getIdentifier());
        inventoryStoreDrugPatient.setCreatedBy(Context.getAuthenticatedUser().getGivenName());
        inventoryStoreDrugPatient.setCreatedOn(date);
        inventoryStoreDrugPatient = inventoryService.saveStoreDrugPatient(inventoryStoreDrugPatient);

        InventoryStoreDrugTransaction transaction = new InventoryStoreDrugTransaction();
        transaction.setDescription("ISSUE DRUG TO PATIENT " + DateUtils.getDDMMYYYY());
        transaction.setStore(store);
        transaction.setTypeTransaction(ActionValue.TRANSACTION[1]);
        transaction.setCreatedOn(date);
        //transaction.setPaymentMode(paymentMode);
        transaction.setPaymentCategory(patient.getAttribute(14).getValue());
        transaction.setCreatedBy(Context.getAuthenticatedUser().getGivenName());

        transaction = inventoryService.saveStoreDrugTransaction(transaction);

        List<EncounterType> types = new ArrayList<EncounterType>();
        EncounterType eType = new EncounterType(10);
        types.add(eType);
        HospitalCoreService hcs = Context.getService(HospitalCoreService.class);
        Encounter lastVisitEncounter = hcs.getLastVisitEncounter(patient, types);

        for (int i = 0; i < orders.length(); i++) {
            JSONObject incomingItem = orders.getJSONObject(i);
            String price = incomingItem.getString("price");
            noOfDays = Integer.parseInt(incomingItem.getString("noOfDays"));
            int listOfDrugQuantity = Integer.parseInt(incomingItem.getString("listOfDrugQuantity"));
            String drugName = incomingItem.getString("drugName");
            frequencyName = incomingItem.getString("frequencyName");
            String formulation = incomingItem.getString("formulation");
            quantity = Integer.parseInt(incomingItem.getString("quantity"));
            formulationId = Integer.parseInt(incomingItem.getString("formulationId"));
            comments = incomingItem.getString("comments");

            InventoryCommonService inventoryCommonService = Context.getService(InventoryCommonService.class);
            Concept fCon = Context.getConceptService().getConcept(frequencyName);
            if (quantity != 0) {
                InventoryDrugFormulation inventoryDrugFormulation = inventoryCommonService.getDrugFormulationById(formulationId);
                InventoryStoreDrugPatientDetail pDetail = new InventoryStoreDrugPatientDetail();
                InventoryStoreDrugTransactionDetail inventoryStoreDrugTransactionDetail = inventoryService.getStoreDrugTransactionDetailById(listOfDrugQuantity);
                Integer totalQuantity = inventoryService.sumCurrentQuantityDrugOfStore(store.getId(), inventoryStoreDrugTransactionDetail.getDrug().getId(), inventoryDrugFormulation.getId());
                int t = totalQuantity;
                InventoryStoreDrugTransactionDetail drugTransactionDetail = inventoryService.getStoreDrugTransactionDetailById(inventoryStoreDrugTransactionDetail.getId());
                inventoryStoreDrugTransactionDetail.setCurrentQuantity(drugTransactionDetail.getCurrentQuantity());
                inventoryService.saveStoreDrugTransactionDetail(inventoryStoreDrugTransactionDetail);
                //save transactiondetail first
                InventoryStoreDrugTransactionDetail transDetail = new InventoryStoreDrugTransactionDetail();
                transDetail.setTransaction(transaction);
                transDetail.setCurrentQuantity(0);
                transDetail.setIssueQuantity(quantity);
                transDetail.setOpeningBalance(totalQuantity);
                transDetail.setClosingBalance(t);
                transDetail.setQuantity(0);
                transDetail.setVAT(inventoryStoreDrugTransactionDetail.getVAT());
                transDetail.setCostToPatient(inventoryStoreDrugTransactionDetail.getCostToPatient());
                transDetail.setUnitPrice(inventoryStoreDrugTransactionDetail.getUnitPrice());
                transDetail.setDrug(inventoryStoreDrugTransactionDetail.getDrug());
                transDetail.setReorderPoint(inventoryStoreDrugTransactionDetail.getDrug().getReorderQty());
                transDetail.setAttribute(inventoryStoreDrugTransactionDetail.getDrug().getAttributeName());
                transDetail.setFormulation(inventoryDrugFormulation);
                transDetail.setBatchNo(inventoryStoreDrugTransactionDetail.getBatchNo());
                transDetail.setCompanyName(inventoryStoreDrugTransactionDetail.getCompanyName());
                transDetail.setDateManufacture(inventoryStoreDrugTransactionDetail.getDateManufacture());
                transDetail.setDateExpiry(inventoryStoreDrugTransactionDetail.getDateExpiry());
                transDetail.setReceiptDate(inventoryStoreDrugTransactionDetail.getReceiptDate());
                transDetail.setCreatedOn(date);
                transDetail.setPatientType(patientType);
                transDetail.setEncounter(Context.getEncounterService().getEncounter(encounterId));

                transDetail.setFrequency(fCon);
                transDetail.setNoOfDays(noOfDays);
                transDetail.setComments(comments);
                transDetail.setFlag(0);
                BigDecimal moneyUnitPrice = inventoryStoreDrugTransactionDetail.getCostToPatient().multiply(new BigDecimal(quantity));
                // moneyUnitPrice = moneyUnitPrice.add(moneyUnitPrice.multiply(inventoryStoreDrugTransactionDetail.getVAT().divide(new BigDecimal(100))));
                transDetail.setTotalPrice(moneyUnitPrice);
                transDetail.setParent(inventoryStoreDrugTransactionDetail);
                transDetail = inventoryService.saveStoreDrugTransactionDetail(transDetail);

                pDetail.setQuantity(quantity);

                pDetail.setStoreDrugPatient(inventoryStoreDrugPatient);
                pDetail.setTransactionDetail(transDetail);
                //save issue to patient detail
                inventoryService.saveStoreDrugPatientDetail(pDetail);


                BillingService billingService = Context.getService(BillingService.class);
                IndoorPatientServiceBill bill = new IndoorPatientServiceBill();
                /*added waiver amount */
                if (waiverAmount != null) {
                    bill.setWaiverAmount(waiverAmount);
                } else {
                    BigDecimal wavAmt = new BigDecimal(0);
                    bill.setWaiverAmount(wavAmt);
                }
                bill.setComment(comment);
                bill.setPaymentMode(paymentMode);
                bill.setActualAmount(moneyUnitPrice);
                bill.setAmount(moneyUnitPrice);

                bill.setEncounter(lastVisitEncounter);
                bill.setCreatedDate(new Date());
                bill.setPatient(patient);
                bill.setCreator(Context.getAuthenticatedUser());


                IndoorPatientServiceBillItem item = new IndoorPatientServiceBillItem();

                item.setUnitPrice(pDetail.getTransactionDetail().getCostToPatient());
                item.setAmount(moneyUnitPrice);
                item.setQuantity(pDetail.getQuantity());
                item.setName(pDetail.getTransactionDetail().getDrug().getName());
                item.setCreatedDate(new Date());
                item.setIndoorPatientServiceBill(bill);
                item.setActualAmount(moneyUnitPrice);
                item.setOrderType("DRUG");
                bill.addBillItem(item);
                bill = billingService.saveIndoorPatientServiceBill(bill);

                OpdDrugOrder opdDrugOrder = inventoryService.getOpdDrugOrder(patientId, encounterId,
                        inventoryStoreDrugTransactionDetail.getDrug().getId(), formulationId);


                PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);
                opdDrugOrder.setOrderStatus(1);
                patientDashboardService.saveOrUpdateOpdDrugOrder(opdDrugOrder);
            }
        }
        return "redirect:" + uiUtils.pageLink("pharmacyapp", "dashboard");
    }
}
