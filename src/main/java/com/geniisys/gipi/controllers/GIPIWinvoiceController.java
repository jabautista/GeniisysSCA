/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISTaxCharges;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.common.service.GIISTaxChargesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWInstallment;
import com.geniisys.gipi.entity.GIPIWInvoice;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWEndtTextService;
import com.geniisys.gipi.service.GIPIWInstallmentFacadeService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWPolBasicService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWinvTaxFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWinvoiceController.
 */
public class GIPIWinvoiceController extends BaseController{

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6053256358005122209L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWinvoiceController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
			GIACParameterFacadeService giacParameterFacadeService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
			GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService"); // +env
			GIPIWinvTaxFacadeService gipiWinvTaxService = (GIPIWinvTaxFacadeService) APPLICATION_CONTEXT.getBean("gipiWinvTaxFacadeService"); // +env
			GIPIWInstallmentFacadeService gipiWinstallmentService = (GIPIWInstallmentFacadeService) APPLICATION_CONTEXT.getBean("gipiWInstallmentFacadeService");
			GIISTaxChargesService giisTaxChargesService = (GIISTaxChargesService) APPLICATION_CONTEXT.getBean("giisTaxChargesService");		//Gzelle 10272014
			GIPIWEndtTextService gipiWEndtTextService = (GIPIWEndtTextService) APPLICATION_CONTEXT.getBean(GIPIWEndtTextService.class);		//Gzelle 10272014
			
			
			Map<String, Object> parInfo = GIPIPARUtil.getPARInfo(request);
			request = GIPIPARUtil.setPARInfo(request, parInfo);	
			
			int itemGrp = Integer.parseInt((request.getParameter("itemGrp") == null || request.getParameter("itemGrp") == "") ? "1" : request.getParameter("itemGrp")); //edited by steven 07.22.2014 
			Integer parId = Integer.parseInt((request.getParameter("parId") == null || request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
			Integer packParId = Integer.parseInt((request.getParameter("packParId") == null || request.getParameter("packParId") == "") ? "0" : request.getParameter("packParId"));
			String lineCd = (String) (request.getParameter("lineCd")== null ? "" : request.getParameter("lineCd"));
			String issCd = (String) (request.getParameter("issCd") == null? "" : request.getParameter("issCd"));
			System.out.println("SHOWBILLPREMIUM: parID: " + parId + " packParId: " + packParId + " lineCd: " + lineCd + " issCd: " + issCd);
			int assdNo = Integer.parseInt((request.getParameter("globalAssdNo") == null ? "0" : request.getParameter("globalAssdNo")));
			String assdName = (String) (request.getParameter("globalAssdName")== null? "" : request.getParameter("globalAssdName"));
			String parNo = (String)request.getParameter("globalParNo");
			String dueDate = request.getParameter("dueDate");
			Integer version = 1;

			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
		
			System.out.println("invoice"+parId+lineCd+issCd);
			GIPIPARList gipiParList = new GIPIPARList();
			gipiParList.setParId(parId);
			gipiParList.setLineCd(lineCd);
			gipiParList.setIssCd(issCd);
			gipiParList.setAssdNo(assdNo);
			gipiParList.setAssdName(assdName);
			gipiParList.setParNo(parNo);
		
			if("showBillPremiumsPage".equals(ACTION)){		
				GIPIWPolbasService gipiWPolbasService =(GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				GIISParameterFacadeService giisParameterFacadeService=(GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIWPolBasicService gipiWPolBasicService=(GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				
				Integer initialParSelected = Integer.parseInt((request.getParameter("initialParSelected") == "") ? "0" : request.getParameter("initialParSelected"));
				System.out.println("initialParSelected: " + initialParSelected);				
				
				String isPack = packParId == 0 ? "N" : "Y";
				System.out.println("ISPACK: " + isPack);
				request.setAttribute("isPack", isPack);
				
				if("Y".equals(isPack)){
					List<GIPIPARList> gipiPolParList = (List<GIPIPARList>) StringFormatter.escapeHTMLInList(gipiParListService.getPackItemParList(packParId, null)) ;
					request.setAttribute("parPolicyList", new JSONArray(gipiPolParList));
					
					if (initialParSelected == 0){
						parId = gipiPolParList.get(0).getParId();
						lineCd = gipiPolParList.get(0).getLineCd();
						System.out.println("NEW PAR ID!!!!" + parId);
					}else {					
						parId = initialParSelected;
					}
				} else{
					request.setAttribute("parPolicyList", new JSONArray());
				}
				
				Date date = new Date();
				DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
				String[] args={format.format(date)};
				
				request=this.getWinvoice(request, gipiWInvoiceService, parId, itemGrp);
				request=this.getDistinctWinvoice(request, gipiWInvoiceService, parId);	
				
				GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
				request.setAttribute("credGIPIWPolbas", gipiWPolbas);
				request.setAttribute("acctOfName", gipiWPolbas.getAcctOfName());
				
    		    List<LOV> paytTerms = lovHelper.getList(LOVHelper.PAYTERM_LISTING);
				List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, args);
				
				String defPayTerm = giisParameterFacadeService.getParamValueV2("CASH ON DELIVERY");
				request.setAttribute("defPayTerm", defPayTerm);
	
				List<GIPIWInstallment> gipiWInstallment = gipiWinstallmentService.getAllGIPIWInstallment(parId);
				System.out.println("size gipiWInstallment: " + gipiWInstallment.size());
				request.setAttribute("recCount", gipiWInstallment.size());
				StringFormatter.replaceQuotesInList(gipiWInstallment);
				request.setAttribute("gipiWInstallmentJSON", new JSONArray(gipiWInstallment));
				
				request.setAttribute("evalParamValue" , giacParameterFacadeService.getParamValueN("EVAT").toString());
				request.setAttribute("paytTerms", paytTerms);
				request.setAttribute("bookingMonth",bookingMonths);
				request.setAttribute("parDetails", gipiParList);
				request.setAttribute("otherChargesTaxCd", giisParameterFacadeService.getParamValueN("OTHER_CHARGES_CODE"));
				request.setAttribute("allowBookingInAdvance", giisParameterFacadeService.getParamValueV2("ALLOW_BOOKING_IN_ADVANCE")); // andrew - 09.08.2011
				
				request.setAttribute("parId", initialParSelected == 0 ? parId : initialParSelected);
				request.setAttribute("lineCd", lineCd); // andrew - 10.05.2011
				request.setAttribute("issCd", issCd);
				System.out.println("SETATTRIBUTE VALUE: " + (initialParSelected == 0 ? parId : initialParSelected));
				if(issCd.equals("RI")){					
					request.setAttribute("inputVatRate", this.getWInvoiceInputVatRate(request, gipiWInvoiceService, parId));
				}
				
				String takeupTerm = gipiWPolBasicService.getTakeupTerm(parId);
				request.setAttribute("takeupTerm", takeupTerm);
				request.setAttribute("evat", giacParameterFacadeService.getParamValueN2("EVAT"));
				request.setAttribute("updateBooking", giisParameterFacadeService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.25.2012
				
				System.out.println(parId);
				//added by christian 09.21.2012
				gipiParList = gipiParListService.getGIPIPARDetails(parId);
				request.setAttribute("parType", gipiParList.getParType());
				System.out.println("parType: " + gipiParList.getParType());
				
				request.setAttribute("allowTaxGreaterThanPremium", giisParameterFacadeService.getParamValueV2("ALLOW_TAX_GREATER_THAN_PREMIUM"));
				request.setAttribute("allowExpiredPolIssuance", giisParameterFacadeService.getParamValueV2("ALLOW_EXPIRED_POLICY_ISSUANCE")); //added by robert SR 19785 07.20.15
				request.setAttribute("allowUpdateTaxEndtCancellation",giisParameterFacadeService.getParamValueV2("ALLOW_UPDATE_TAX_ENDT_CANCELLATION")); // Gzelle 07272015 SR4819
				
				 // apollo cruz sr#19975
				GIISIntermediaryService giisIntermediaryService =(GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");				
				request.setAttribute("prodTakeUp", giisIntermediaryService.getGiacParamValueN("PROD_TAKE_UP"));
				
				PAGE ="/pages/underwriting/billPremiums.jsp";
				
			} else if("showCreditCardInfo".equals(ACTION)){
				GIPIWPolbasService gipiWPolbasService =(GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
				
				GIPIWPolbas gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
				request.setAttribute("gipiWPolbas", gipiWPolbas);
				
				PAGE="/pages/underwriting/pop-ups/creditCardInfo.jsp";
				
			} else if("doPaytermComputation2".equals(ACTION)){
				int takeupSeqNo = Integer.parseInt(request.getParameter("takeupSeqNo"));
				String paytTerms =  request.getParameter("paytTerms");
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("takeupSeqNo", takeupSeqNo);
				params.put("paytTerms", paytTerms);
				params.put("itemGrp", itemGrp);
				params.put("parId", parId.toString());
				params.put("version", version.toString());
				params.put("lineCd", lineCd);
				params.put("dueDate", dueDate.toString());
				params.put("taxAmt", request.getParameter("taxAmt") == "" ? null : new BigDecimal(request.getParameter("taxAmt")));
				params.put("otherCharges", request.getParameter("otherCharges") == "" ? null : new BigDecimal(request.getParameter("otherCharges")));
				params.put("parameters", request.getParameter("parameters"));
				Debug.print("PAYMENT COMPUTE PARAMS: " + params);
				
				Map<String, Object> installmentMap = gipiWinstallmentService.doPaytermComputation(params);
				List<GIPIWInstallment> gipiWInstallment = (List<GIPIWInstallment>)installmentMap.get("gipiWInstallmentCur");
				System.out.println("size: " + gipiWInstallment.size());
				StringFormatter.replaceQuotesInList(gipiWInstallment);
				request.setAttribute("gipiWInstallmentJSON", new JSONArray(gipiWInstallment));
				
				PAGE="/pages/underwriting/pop-ups/installment.jsp";
				
			} else if("showItemGrpSummary".equals(ACTION)){
				PAGE="/pages/underwriting/pop-ups/itemGroupSummary.jsp";
			
			} else if("checkPolicyCurrency".equals(ACTION)){	
		    	System.out.println("checking policy currency. . .");
		    	String currencyDesc = request.getParameter("currencyDesc");
		    	message = this.checkPolicyCurrency(request, gipiWInvoiceService, parId, currencyDesc);
		    	PAGE= "/pages/genericMessage.jsp";
		    	
		   } else if("saveWInvoice".equals(ACTION) ){
			    Map<String, Object> params = new HashMap<String, Object>();
			    params.put("itemGrp", itemGrp);
			    params.put("parId", parId);
			    params.put("takeUpSeqNo", request.getParameter("takeupSeqNo"));
			    params.put("packParId", request.getParameter("packParId") == "" ? null : Integer.parseInt(request.getParameter("packParId")));
			    params.put("globalPackParId", request.getParameter("globalPackParId") == "" ? null : Integer.parseInt(request.getParameter("globalPackParId")));
			    params.put("riCommVat", new BigDecimal(request.getParameter("riCommVat")));
				params.put("version", version.toString());
				params.put("lineCd", lineCd);
				params.put("dueDate", dueDate.toString());
				params.put("insured", request.getParameter("insured")); // irwin 10.23.2012
				params.put("bookingMm", request.getParameter("bookingMm")); //belle 09012012
			    params.put("bookingYy", Integer.parseInt(request.getParameter("bookingYy")));
			   
			    Debug.print("BILL PREMIUMS PARAMS: " + params);
			   	Debug.print("All params: " + request.getParameter("billPremiumsParams"));
			   	gipiWInvoiceService.saveWInvoice(request.getParameter("billPremiumsParams"), params);
			   	
			   	message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
				
			}else if ("enterBondBill".equals(ACTION)){ //Added new Action by TONIO Nov 9, 2010
				GIISParameterFacadeService giisParameterFacadeService=(GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIWPolBasicService gipiWPolBasicService=(GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
				GIISAssuredFacadeService giisAssuredFacadeService=(GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				
				request.setAttribute("issCdRI", giisParameterFacadeService.getParamValueV("ISS_CD_RI").getParamValueV());
				
				Map<String, Object> parInformation = new HashMap<String, Object>();
				parInformation.put("parId", parId);
				parInformation.put("parNo", request.getParameter("parNo"));
				parInformation.put("assdName", request.getParameter("assdName"));
				parInformation.put("issCd", request.getParameter("issCd"));
				parInformation.put("issueDate", request.getParameter("issueDate"));
				
				String[] dateParams ={request.getParameter("inceptDate"), request.getParameter("issueDate")};
				
				request.setAttribute("bondHeaderDtls", parInformation);
				
				log.info("Par ID: " + parId);
				log.info("Par No: " + request.getParameter("parNo"));
				log.info("Assd Name: " + request.getParameter("assdName"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("issCd", issCd);
				
				Map<String, Object> invoiceInfo = (Map<String, Object>) gipiWInvoiceService.getWinvoiceBondDtls(params);
				log.info("Invoice info : "+invoiceInfo);
				request.setAttribute("invoiceInfo", invoiceInfo);
				
				//Populates GIPIWInvoice Dtls
				List<GIPIWInvoice> gipiWInvoice =  gipiWInvoiceService.getGIPIWInvoice(parId, itemGrp);
				StringFormatter.escapeHTMLInList(gipiWInvoice);
				Debug.print("Take up list: " + gipiWInvoice);
				request.setAttribute("gipiWInvoiceJSON", new JSONArray(gipiWInvoice));				
				Debug.print("JSON array TakeUp Dtls: " + new JSONArray(gipiWInvoice));
				
				//Populates Pay term LOV
				List<LOV> payTerms = lovHelper.getList(LOVHelper.PAYTERM_LISTING);
				StringFormatter.escapeHTMLInList(payTerms);
				request.setAttribute("payTermsJSON", new JSONArray(payTerms));
				Debug.print("Pay Terms: " + new JSONArray(payTerms));
				
				//Populates bookingDate LOV
				List<LOV> bookingDate = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING2, dateParams);
				StringFormatter.escapeHTMLInList(bookingDate);
				request.setAttribute("bookingDateJSON", new JSONArray(bookingDate));
				Debug.print("Booking Date: " + new JSONArray(bookingDate));
				
				//added by marj: Populates GIPIPAR Dtls and GIISAssured Dtls for VAT_TAG
				gipiParList = gipiParListService.getGIPIPARDetails(parId);
				GIISAssured giisAssured =  giisAssuredFacadeService.getGiisAssuredDetails(gipiParList.getAssdNo());
				String vatTag = giisAssured.getVatTag();
				request.setAttribute("vatTag", vatTag);
				
				/*String filter = " ";
				f(vatTag.equals("1")){
					filter = "EXPANDED VAT";
				}*/ //belle 11.07.2012 handled in query
				
				//Populates Tax Description LOV
				//edited by marj: Added param4 for vat exempted
				//edited by belle: replaced param4 with vatTag 11.07.2012
				String[] arguments={lineCd, issCd, parId.toString(), vatTag}; //filter
				List<LOV> taxCharges = lovHelper.getList(LOVHelper.BOND_TAX_CHARGES, arguments);
				StringFormatter.escapeHTMLInList(taxCharges);
				request.setAttribute("bondTaxChargesListingJSON",  new JSONArray(taxCharges));
				Debug.print("JSON array Tax Code Dtls: " + new JSONArray(taxCharges));
				
				//Get takeup term
				String takeupTerm = gipiWPolBasicService.getTakeupTerm(parId);
				request.setAttribute("takeupTerm", takeupTerm);
				
				//added by marj: Get param_value of COMPUTE_OLD_DOC_STAMPS
				String docStampsParam = giisParameterFacadeService.getParamValueV2("COMPUTE_OLD_DOC_STAMPS");
				request.setAttribute("docStampsParam", docStampsParam);
				
				request.setAttribute("docStampsParamValue" , giacParameterFacadeService.getParamValueN("DOC_STAMPS").toString()); // added by jhing 11.09.2014 
				request.setAttribute("evatParamValue" , giacParameterFacadeService.getParamValueN("EVAT").toString());
				
				request.setAttribute("updateBooking", giisParameterFacadeService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.25.2012
				
				if(issCd.equals("RI")){	//by bonok :: 08.28.2012			
					request.setAttribute("inputVatRate", this.getWInvoiceInputVatRate(request, gipiWInvoiceService, parId));
				}
				//added by Gzelle 10272014 based on UW-SPECS-2014-093 - GIPIS026 GIPIS017B BILL PREMIUMS
				request.setAttribute("allowTaxGreaterThanPremium", giisParameterFacadeService.getParamValueV2("ALLOW_TAX_GREATER_THAN_PREMIUM"));
				List<GIISTaxCharges> giisTaxCharges = giisTaxChargesService.getGiisTaxCharges(request);
				request.setAttribute("giisTaxCharges", new JSONArray((giisTaxCharges)));
				GIPIWEndtText endtText = gipiWEndtTextService.getGIPIWEndttext(parId);
				if (endtText != null){
					request.setAttribute("CheckUpdateTaxEndtCancellation",gipiWEndtTextService.CheckUpdateTaxEndtCancellation()); 
					request.setAttribute("endtTax" , (endtText.getEndtTax() == null ? "" : endtText.getEndtTax()));
				}else{
					request.setAttribute("endtTax" , "");
				}
				PAGE = "/pages/underwriting/enterBondBill.jsp";
			}else if ("saveBondBillDtls".equals(ACTION)){

				Map<String, Object> createWIvoiceparams = new HashMap<String, Object>();
				createWIvoiceparams.put("parId", Integer.parseInt(request.getParameter("parId")));
				createWIvoiceparams.put("lineCd", request.getParameter("lineCd"));
				createWIvoiceparams.put("issCd", request.getParameter("issCd"));
				createWIvoiceparams.put("itemGrp", 1);
				createWIvoiceparams.put("bondTsiAmt", new BigDecimal(request.getParameter("bondTsiAmt")));
				createWIvoiceparams.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				//createWIvoiceparams.put("riCommRt", request.getParameter("riCommRt").equals("")? null : new BigDecimal(request.getParameter("riCommRt")));
				createWIvoiceparams.put("riCommRt", request.getParameter("riCommRt").equals("")? null : request.getParameter("riCommRt")); //belle 11.07.2012							
				createWIvoiceparams.put("bondRate", request.getParameter("bondRate").equals("") ? null : new BigDecimal(request.getParameter("bondRate")));
				createWIvoiceparams.put("riCommAmt", new BigDecimal(request.getParameter("riCommAmt")));
				createWIvoiceparams.put("newInvoiceMarker", request.getParameter("newInvoiceMarker"));
				createWIvoiceparams.put("payTerm", request.getParameter("payTerm"));
				createWIvoiceparams.put("taxAmt", new BigDecimal(request.getParameter("taxAmt")));
				createWIvoiceparams.put("parType", request.getParameter("parType"));
				createWIvoiceparams.put("annTsiAmt", "E".equals(request.getParameter("parType")) ? 
						(request.getParameter("annTsiAmt").equals("")? null : new BigDecimal(request.getParameter("annTsiAmt"))) : 0);
				createWIvoiceparams.put("annPremAmt", "E".equals(request.getParameter("parType")) ? 
						(request.getParameter("annPremAmt").equals("")? null : new BigDecimal(request.getParameter("annPremAmt"))) : 0);
				createWIvoiceparams.put("bookingMm", request.getParameter("bookingMm")); //belle 09012012
				createWIvoiceparams.put("bookingYy", request.getParameter("bookingYy") == null ? "" : Integer.parseInt(request.getParameter("bookingYy"))); 
				createWIvoiceparams.put("updateBondAutoPrem", request.getParameter("updateBondAutoPrem") == null ? "N" : request.getParameter("updateBondAutoPrem")); //added by robert SR 4828 08.26.15
				System.out.println("bert:::::"+request.getParameter("parameters").toString());
				System.out.println("bert:::::"+createWIvoiceparams.toString());
				gipiWInvoiceService.saveBondBillDtls(request.getParameter("parameters"), createWIvoiceparams);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getFixedFlagGIPIS017B".equals(ACTION)){
					GIPIWPolbasService gipiWPolBasicService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env

					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", Integer.parseInt(request.getParameter("parId")));
					params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
					params.put("bondRate", new BigDecimal(request.getParameter("bondRate")));
					params.put("bondAmt", new BigDecimal(request.getParameter("bondAmt")));
					
					gipiWPolBasicService.getFixedFlagGIPIS017B(params);
					Debug.print("Out params: " + params);
					
					StringBuilder sb = new StringBuilder();
					
					sb.append("premAmt=" + params.get("premAmt").toString());
					sb.append("&bondRate=" + params.get("bondRate").toString());
					sb.append("&bondAmt=" + params.get("bondAmt").toString());
					sb.append("&message=" + (params.get("message") == null ? "" : params.get("message").toString()));
					
					message = sb.toString();
					PAGE = "/pages/genericMessage.jsp";
			}else if ("getFixedFlag".equals(ACTION)){
				GIPIWPolbasService gipiWPolBasicService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); // +env

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				//params.put("bondRate", new BigDecimal(request.getParameter("bondRate")));
				params.put("bondRate", request.getParameter("bondRate").equals("") ? null : new BigDecimal(request.getParameter("bondRate")));
				params.put("bondAmt", new BigDecimal(request.getParameter("bondAmt")));
				params.put("issCd", request.getParameter("issCd"));
				params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
				params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				
				gipiWPolBasicService.getFixedFlag(params);
				Debug.print("Out params: " + params);
				
				StringBuilder sb = new StringBuilder();
				
				sb.append("premAmt=" + params.get("premAmt").toString());
				sb.append("&bondRate=" + params.get("bondRate").toString());
				sb.append("&bondAmt=" + params.get("bondAmt").toString());
				sb.append("&message=" + (params.get("message") == null ? "" : params.get("message").toString()));
				sb.append("&annPremAmt=" + params.get("annPremAmt").toString()); //added by robert GENQA SR 4825 08.19.15
				
				message = sb.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getTempTakeupList".equals(ACTION)){
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("itemGrp", 1);
				params.put("bondTsiAmt", new BigDecimal(request.getParameter("bondTsiAmt")));
				params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				//params.put("riCommRt", request.getParameter("riCommRt").equals("") ? null: new BigDecimal(request.getParameter("riCommRt")));
				params.put("riCommRt", request.getParameter("riCommRt").equals("") ? null: request.getParameter("riCommRt")); //belle 11.07.2012
				params.put("bondRate", request.getParameter("bondRate").equals("") ? null : new BigDecimal(request.getParameter("bondRate")));
				params.put("riCommAmt", new BigDecimal(request.getParameter("riCommAmt")));
				Debug.print("Params from JSP: " + params);
				
				gipiWInvoiceService.getTempTakeupListDtls(params);
				Debug.print("OUT Params: " + params);
				
				List<Map<String, Object>> tempTakeupList = (List<Map<String, Object>>) params.get("gipiWInvoiceTakeupCur");
				JSONArray takeupListJSON = new JSONArray(tempTakeupList);
				
				message = takeupListJSON.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateTaxEntry".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("itemGrp", Integer.parseInt(request.getParameter("itemGrp")));
				params.put("takeupSeqNo", Integer.parseInt(request.getParameter("takeupSeqNo")));
				params.put("taxAmt", new BigDecimal(request.getParameter("taxAmt")));
				params.put("origTaxAmt", new BigDecimal(request.getParameter("origTaxAmt")));
				params.put("premAmt", new BigDecimal(request.getParameter("premAmt")));
				params.put("taxCd", Integer.parseInt(request.getParameter("taxCd")));
				params.put("taxId", Integer.parseInt(request.getParameter("taxId")));
				params.put("message", "SUCCESS");
				Debug.print("Before validateTaxEntry params: " + params);
				Map<String, Object> resultParam = gipiWInvoiceService.validateTaxEntry(params);;
				Debug.print("After validateTaxEntry params: " + resultParam);
				message = params.get("message").toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateBondsTaxEntry".equals(ACTION)){ // added by jhing 12.09.2014
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", Integer.parseInt(request.getParameter("parId")));
				params.put("itemGrp", Integer.parseInt(request.getParameter("itemGrp")));
				params.put("takeupSeqNo", Integer.parseInt(request.getParameter("takeupSeqNo")));
				params.put("taxAmt", new BigDecimal(request.getParameter("taxAmt")));
				params.put("origTaxAmt", new BigDecimal(request.getParameter("origTaxAmt")));
				params.put("taxCd", Integer.parseInt(request.getParameter("taxCd")));
				params.put("taxId", Integer.parseInt(request.getParameter("taxId")));
				params.put("message", "SUCCESS");
				Debug.print("Before validateBondsTaxEntry params: " + params);
				Map<String, Object> resultParam = gipiWInvoiceService.validateBondsTaxEntry(params);;
				Debug.print("After validateBondsTaxEntry params: " + resultParam);
				message = params.get("message").toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("endtEnterBondBill".equals(ACTION)) {
				GIISParameterFacadeService giisParameterFacadeService=(GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIWPolBasicService gipiWPolBasicService=(GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
				GIISAssuredFacadeService giisAssuredFacadeService=(GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
				GIPIPARListService gipiParListService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				GIPIWPolbasService gipiWPolBasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService"); //added by robert SR 4828 08.26.15
				
				//String issCdRI = giisParameterFacadeService.getParamValueV("ISS_CD_RI").getParamValueV();
				request.setAttribute("issCdRI", giisParameterFacadeService.getParamValueV("ISS_CD_RI").getParamValueV());
				
				Map<String, Object> parInformation = new HashMap<String, Object>();
				parInformation.put("parId", parId);
				parInformation.put("parNo", request.getParameter("parNo"));
				parInformation.put("assdName", request.getParameter("assdName"));
				parInformation.put("issCd", request.getParameter("issCd"));
				
				String[] dateParams ={request.getParameter("inceptDate"), request.getParameter("issueDate")};
				
				request.setAttribute("bondHeaderDtls", parInformation);
				
				log.info("Par ID: " + parId);
				log.info("Par No: " + request.getParameter("parNo"));
				log.info("Assd Name: " + request.getParameter("assdName"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", parId);
				params.put("issCd", issCd);
				
				Map<String, Object> invoiceInfo = (Map<String, Object>) gipiWInvoiceService.getWinvoiceBondDtls(params);
				request.setAttribute("invoiceInfo", invoiceInfo);
				Debug.print("invoiceInfo: " + invoiceInfo);
				
				Map<String, Object> annualParams = new HashMap<String, Object>();
				annualParams.put("parId", parId);
				annualParams.put("lineCd", request.getParameter("lineCd"));
				annualParams.put("sublineCd", request.getParameter("sublineCd"));
				annualParams.put("issCd", request.getParameter("issCd"));
				annualParams.put("issueYY", Integer.parseInt(request.getParameter("issueYY")));
				annualParams.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
				annualParams.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
				annualParams.put("annTsi", 0);
				annualParams.put("annPremAmt", 0);
				Debug.print("ANNUAL PARAMS: " + annualParams);
				
				Map<String, Object> annualValues = gipiWInvoiceService.getAnnualAmt(annualParams);
				request.setAttribute("annualValues", annualParams);
				Debug.print("annualValues: " + annualParams);
				
				//Populates GIPIWInvoice Dtls
				List<GIPIWInvoice> gipiWInvoice =  gipiWInvoiceService.getGIPIWInvoice(parId, itemGrp);
				StringFormatter.replaceQuotesInList(gipiWInvoice);
				Debug.print("Take up list: " + gipiWInvoice);
				request.setAttribute("gipiWInvoiceJSON", new JSONArray(gipiWInvoice));				
				Debug.print("JSON array TakeUp Dtls: " + new JSONArray(gipiWInvoice));
				
				//Populates Pay term LOV
				List<LOV> payTerms = lovHelper.getList(LOVHelper.PAYTERM_LISTING);
				StringFormatter.replaceQuotesInList(payTerms);
				request.setAttribute("payTermsJSON", new JSONArray(payTerms));
				Debug.print("Pay Terms: " + new JSONArray(payTerms));
				
				//Populates bookingDate LOV
				List<LOV> bookingDate = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING2, dateParams);
				StringFormatter.replaceQuotesInList(bookingDate);
				request.setAttribute("bookingDateJSON", new JSONArray(bookingDate));
				Debug.print("Booking Date: " + new JSONArray(bookingDate));
				
				//added by marj: Populates GIPIPAR Dtls and GIISAssured Dtls for VAT_TAG
				gipiParList = gipiParListService.getGIPIPARDetails(parId);
				GIISAssured giisAssured =  giisAssuredFacadeService.getGiisAssuredDetails(gipiParList.getAssdNo());
				String vatTag = giisAssured.getVatTag();
				request.setAttribute("vatTag", vatTag);
			
				/*String filter = " ";
				f(vatTag.equals("1")){
					filter = "EXPANDED VAT";
				}*/ //belle 11.07.2012 handled in query

				//Populates Tax Description LOV
				//edited by marj: Added param4 for vat exempted
				//edited by belle: replaced param4 with vatTag 11.07.2012
				String[] arguments={lineCd, issCd, parId.toString(), vatTag}; //filter
				List<LOV> taxCharges = lovHelper.getList(LOVHelper.BOND_TAX_CHARGES, arguments);
				StringFormatter.replaceQuotesInList(taxCharges);
				request.setAttribute("bondTaxChargesListingJSON",  new JSONArray(taxCharges));
				Debug.print("JSON array Tax Code Dtls: " + new JSONArray(taxCharges));
				
				//Get takeup term
				String takeupTerm = gipiWPolBasicService.getTakeupTerm(parId);
				request.setAttribute("takeupTerm", takeupTerm);
				String bondAutoPrem = gipiWPolBasService.getBondAutoPrem(parId); //added by robert GENQA SR 4828 08.26.15
				request.setAttribute("bondAutoPrem", bondAutoPrem); //added by robert GENQA SR 4828 08.26.15
				request.setAttribute("updateBooking", giisParameterFacadeService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.25.2012
				
				request.setAttribute("evatParamValue" , giacParameterFacadeService.getParamValueN("EVAT").toString());
				
				GIISIntermediaryService giisIntermediaryService =(GIISIntermediaryService) APPLICATION_CONTEXT.getBean("giisIntermediaryService");
				request.setAttribute("prodTakeUp", giisIntermediaryService.getGiacParamValueN("PROD_TAKE_UP"));
				request.setAttribute("issueDate", request.getParameter("issueDate"));
				
				PAGE = "/pages/underwriting/endt/bonds/endtEnterBondBill.jsp";
			}else if ("validateBookingDate2".equals(ACTION)){
				GIPIWPolBasicService gipiWPolBasicService=(GIPIWPolBasicService) APPLICATION_CONTEXT.getBean("gipiWPolBasicService");
				
				String bookingMMPolbas = request.getParameter("bookingMMPolbas");
				String bookingYYPolbas = request.getParameter("bookingYYPolbas");
				String inceptDate = request.getParameter("inceptDate");
				String bookingMM = request.getParameter("bookingMM");
				String bookingYY= request.getParameter("bookingYY");
				String bondDueDate = request.getParameter("dueDate");
				Integer bondParId = Integer.parseInt(request.getParameter("parId"));
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				params.put("bookingMMPolbas",bookingMMPolbas);
				params.put("bookingYYPolbas",bookingYYPolbas);
				params.put("inceptDate",inceptDate);
				params.put("bookingMM",bookingMM);
				params.put("bookingYY",bookingYY);
				params.put("dueDate",bondDueDate);
				params.put("parId",bondParId);
				params.put("takeupSeqNo", request.getParameter("takeupSeqNo")); // added by Irwin, 5.28.2012
				System.out.println("params:::::::: " +params.toString());
				gipiWPolBasicService.validateBookingDate2(params); //belle 07.23.2012 
				PAGE = "/pages/underwriting/enterBondBill.jsp"; 

			}else if("validateBookingDate3".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("effDate", request.getParameter("effDate"));
				params.put("expDate", request.getParameter("expDate"));
				params.put("selBookingDate", request.getParameter("selBookingDate"));
				params.put("oldBookingDate", request.getParameter("oldBookingDate"));
				params.put("nxtBookingDate", request.getParameter("nxtBookingDate"));
				params.put("prevBookingDate", request.getParameter("prevBookingDate"));
				
				gipiWInvoiceService.gipis026ValidateBookingDate(params);
				PAGE = "/pages/underwriting/billPremiums.jsp";
				
			}else if("validateBondDueDate".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("selDueDate", request.getParameter("selDueDate"));
				params.put("effDate", request.getParameter("effDate"));
				params.put("issueDate", request.getParameter("issueDate"));
				params.put("expiryDate", request.getParameter("expiryDate"));
				params.put("nxtDueDate", request.getParameter("nxtDueDate")); 
				params.put("prevDueDate", request.getParameter("prevDueDate"));
				params.put("changeDueDate", Integer.parseInt( request.getParameter("changeDueDate")));
				log.info("validateBondDueDate - "+params);
				
				message = gipiWInvoiceService.validateBondDueDate(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("deleteWDistTables".equals(ACTION)){
				gipiWInvoiceService.deleteWDistTables(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkForPostedBinders".equals(ACTION)){
				message = gipiWInvoiceService.checkForPostedBinders(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRangeAmount".equals(ACTION)){ //added by steven 07.22.2014
				message = gipiWInvoiceService.getRangeAmount(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getRateAmount".equals(ACTION)){ //added by steven 08.15.2014
				message = gipiWInvoiceService.getRateAmount(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDocStampsTaxAmt".equals(ACTION)){ //added by jhing 11.07.2014
				message = gipiWInvoiceService.getDocStampsTaxAmt(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getFixedAmountTax".equals(ACTION)){ //added by jhing 11.08.2014
				message = gipiWInvoiceService.getFixedAmountTax(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBondsRangeAmount".equals(ACTION)){ //added by steven 07.22.2014
				message = gipiWInvoiceService.getRangeAmount(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBondsRateAmount".equals(ACTION)){ //added by steven 08.15.2014
				message = gipiWInvoiceService.getRateAmount(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBondsDocStampsTaxAmt".equals(ACTION)){ //added by jhing 11.07.2014
				message = gipiWInvoiceService.getDocStampsTaxAmt(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBondsFixedAmountTax".equals(ACTION)){ //added by jhing 11.08.2014
				message = gipiWInvoiceService.getFixedAmountTax(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getBondsCompTaxAmt".equals(ACTION)){ //added by jhing 11.08.2014
				message = gipiWInvoiceService.getCompTaxAmt(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("recreateInvoice".equals(ACTION)){ //added by Daniel Marasigan SR 2169
				message = gipiWInvoiceService.recreateInvoice(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	/**
	 * Gets the winvoice.
	 * 
	 * @param request the request
	 * @param gipiWInvoiceService the gipi w invoice service
	 * @param parId the par id
	 * @param itemGrp the item grp
	 * @return the winvoice
	 * @throws SQLException the sQL exception
	 * @throws ParseException 
	 * @throws JSONException 
	 */
	@SuppressWarnings("unchecked")
	private HttpServletRequest getWinvoice(HttpServletRequest request, 
			GIPIWInvoiceFacadeService gipiWInvoiceService, int parId, int itemGrp)	throws SQLException, ParseException, JSONException {
		System.out.println("itemGrp list: " + itemGrp);
		//List<GIPIWInvoice> gipiWInvoice = gipiWInvoiceService.getGIPIWInvoice(parId, itemGrp);
		List<GIPIWInvoice> gipiWInvoice = (List<GIPIWInvoice>) StringFormatter.escapeHTMLInList(gipiWInvoiceService.getGIPIWInvoice3(parId));
		//request.setAttribute("gipiWInvoice", new JSONArray(gipiWInvoice));
		if (gipiWInvoice.size() > 0){
			request.setAttribute("inceptDate", gipiWInvoice.get(0).getInceptDate());
			request.setAttribute("expiryDate", gipiWInvoice.get(0).getWpolbasExpiryDate());
			request.setAttribute("effDate", gipiWInvoice.get(0).getEffDate());
			request.setAttribute("endtExpiryDate", gipiWInvoice.get(0).getEndtExpiryDate());
		}
		//System.out.println("RiCommVat : " + gipiWInvoice.get(0).getRiCommVat());
//		StringFormatter.replaceQuotesInList(gipiWInvoice);
		System.out.println("SIZE GIPIWINVOICE: " + gipiWInvoice.size());		
		request.setAttribute("gipiWInvoiceJSON", new JSONArray(gipiWInvoice));
		
		return request;
	}
	
	/**
	 * Gets the distinct winvoice.
	 * 
	 * @param request the request
	 * @param gipiWInvoiceService the gipi w invoice service
	 * @param parId the par id
	 * @return the distinct winvoice
	 * @throws SQLException the sQL exception
	 */
	private HttpServletRequest getDistinctWinvoice(HttpServletRequest request, 
			GIPIWInvoiceFacadeService gipiWInvoiceService, int parId)	throws SQLException {
		List<GIPIWInvoice> itemGrpGipiWinvoice = gipiWInvoiceService.getItemGrpWinvoice(parId);	
		request.setAttribute("itemGrpGipiWinvoice", itemGrpGipiWinvoice);	
		return request;
	}

	@SuppressWarnings("unchecked")
	private String checkPolicyCurrency(HttpServletRequest request,
			GIPIWInvoiceFacadeService gipiWInvoiceService, int parId, String currencyDesc) throws SQLException{
		
		Map<String, String> checkPolCurr = new HashMap();
		checkPolCurr = gipiWInvoiceService.checkPolicyCurrency(currencyDesc, parId);
	   
	    String currSw = (String) checkPolCurr.get("switch");
		return currSw;
	}
	
	private BigDecimal getWInvoiceInputVatRate(HttpServletRequest request,
			GIPIWInvoiceFacadeService gipiWInvoiceService, int parId) throws SQLException{
		//Map<String, String> getWInvInputVatRate = gipiWInvoiceService.getWInvoiceInputVatRate(parId);
		
		//Integer inputVatRate = (Integer) Integer.parseInt(getWInvInputVatRate.get("inputVatRate"));
		BigDecimal inputVatRate = gipiWInvoiceService.getWInvoiceInputVatRate2(parId);
	    return inputVatRate;
	
	}
	
	
}
