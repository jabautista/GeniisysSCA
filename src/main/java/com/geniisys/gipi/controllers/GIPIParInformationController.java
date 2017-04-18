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
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIParInformationController.
 */
public class GIPIParInformationController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIParInformationController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({ "unchecked", "deprecation" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		
		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
			
			int parId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null? "0" : request.getParameter("parId"));
			String lineCd = (request.getParameter("lineCd") == null? "":request.getParameter("lineCd"));
			String issCd = (request.getParameter("issCd") == null? "":request.getParameter("issCd"));
			
			System.out.println("parId:"+parId);
			System.out.println("lineCd:"+lineCd);
			System.out.println("issCd:"+issCd);
			System.out.println("action:"+ACTION);
			if (parId == 0) {
				message = "PAR No. is empty";
				PAGE = "/pages/genericMessage.jsp";
			} else {
				if("showBasicInfo".equals(ACTION)){
					log.info("Getting basic information...");
					GIPIWPolbas gipiWPolbas = null;
					
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
					GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					
					String[] args = {lineCd};
					String[] args2 = {issCd};
					String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
					String msgAlert = "";
					String[] issArgs = {"Y"};
					
					String lcEn = giisParametersService.getParamValueV2("LINE_CODE_EN");
					loadListingToRequest(request, lovHelper, args, args2,
							domainRisk, lineCd, lcEn, issArgs);
					
					Map parsWPolbas = new HashMap();
					parsWPolbas = gipiWPolbasService.isExist(parId);
					String isExistWPolbas = (String) parsWPolbas.get("exist");
					request.setAttribute("isExistGipiWPolbas", isExistWPolbas);
					
					if (isExistWPolbas.equals("1")) {
						log.info("Getting gipi_wpolbas...");
						gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);
						if ("".equals(gipiWPolbas.getTakeupTerm()) || gipiWPolbas.getTakeupTerm() == null){
							gipiWPolbas.setTakeupTerm(giisParametersService.getParamValueV2("TAKEUP_TERM"));
						}
						request.setAttribute("gipiWPolbas", gipiWPolbas);
						//request.setAttribute("gipiWPolbasJSON", new JSONObject(StringFormatter.escapeHTMLInObject(gipiWPolbas))); commented and replaced by reymon 02192013
						request.setAttribute("gipiWPolbasJSON", new JSONObject(gipiWPolbas));
					} else {
						log.info("Getting gipi_wpolbas default value...");
						gipiWPolbas = gipiWPolbasService.getGipiWPolbasDefault(parId);
						request.setAttribute("gipiWPolbas", gipiWPolbas);
						//request.setAttribute("gipiWPolbasJSON", new JSONObject(StringFormatter.escapeHTMLInObject(gipiWPolbas))); commented and replaced by reymon 02192013
						request.setAttribute("gipiWPolbasJSON", new JSONObject(gipiWPolbas));
					}					
					
					msgAlert = gipiWPolbas.getMsgAlert();
					
					Map parsNewFormInst = new HashMap();
					parsNewFormInst = gipiWPolbasService.newFormInst(request, parId, issCd, lineCd, APPLICATION_CONTEXT);
					msgAlert =	msgAlert != null ? msgAlert :(String) parsNewFormInst.get("msgAlert");
					String varVdate = (String) parsNewFormInst.get("varVdate");
					
					if (msgAlert != null){
						message = msgAlert;
					} else {
						message = "SUCCESS";
					}
					
					request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.10.2012
					String bookingAdv = giisParametersService.getParamValueV2("ALLOW_BOOKING_IN_ADVANCE");
					request.setAttribute("bookingAdv", bookingAdv);
					if ("Y".equals(bookingAdv)){
						List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING3);
						request.setAttribute("bookingMonthListing", bookingMonths);
					}else{
						DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
						Date date = null;
						if (isExistWPolbas.equals("1") && message.equals("SUCCESS")) {
							if ("1".equals(varVdate)){
								date = gipiWPolbas.getIssueDate();
							}else if ("2".equals(varVdate)){
								date = gipiWPolbas.getInceptDate();
							}else if ("3".equals(varVdate)){
								if (gipiWPolbas.getIssueDate().after(gipiWPolbas.getInceptDate())){
									date = gipiWPolbas.getIssueDate();
								}else{
									date = gipiWPolbas.getInceptDate();
								}
							}else if ("4".equals(varVdate)){
								if (gipiWPolbas.getIssueDate().after(gipiWPolbas.getInceptDate())){
									date = gipiWPolbas.getInceptDate();
								}else{
									date = gipiWPolbas.getIssueDate();
								}
							}
							String[] argsDate = { format.format(date) };
							List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
							request.setAttribute("bookingMonthListing", bookingMonths);
						}else{
							request.setAttribute("bookingMonthListing", "");
						}
					}
					
					request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					//request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("allowExpiredPolicyIssuance", giisParametersService.getParamValueV2("ALLOW_EXPIRED_POLICY_ISSUANCE")); // added by: Kenneth L. 03.26.2014
					request.setAttribute("copyRefpolFrmOpenPol", giisParametersService.getParamValueV2("COPY_REFPOL_FRM_OPEN_POL")); // added by robert SR 21901 03.28.16
					request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParService.getGIPIPARDetails(parId));
					//added by Gzelle 10032014 - for policy deductible, to retrieve amount for %ofTSI
					String[] perilArgs = {Integer.toString(parId), lineCd}; 
					LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
					List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);
					request.setAttribute("dedPerilsList", perilsList);
					PAGE = "/pages/underwriting/basicInformationMain.jsp";
				} else if("showEndtBasicInfo".equals(ACTION)){				
					log.info("Getting endt basic info...");
					
					GIPIPARList gipiParList = null;
					GIPIWPolbas gipiWPolbas = null;
					GIPIWPolGenin gipiWPolGenin = null;
					GIPIWEndtText gipiWEndtText = null;					
					GIPIWOpenPolicy gipiWOpenPolicy = null;		
					
					String policyNo = new String("");
					
					/* default is "N" */
					request.setAttribute("reqCredBranch", "N");
					request.setAttribute("reqRefPolNo", "N");					
					if("Y".equals(request.getParameter("fromPolicyNo"))){
						Map<String, Object> params = new HashMap<String, Object>();
						
						params = loadPolicyNoToMap(request);
						params.put("parId", parId);
						params = gipiWPolbasService.searchForPolicy(params);
						
						if(null != params.get("msgAlert")){
							message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
							request.setAttribute("message", message);
							PAGE = "/pages/genericMessage.jsp";
						}else{
							LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
							GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
							GIISAssuredFacadeService giisAssuredService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
							
							for(GIPIWPolGenin wPolGenin : (List<GIPIWPolGenin>) params.get("gipiWPolGenin")){								
								gipiWPolGenin = wPolGenin;
							}					
							
							for(GIPIWEndtText wEndtText : (List<GIPIWEndtText>) params.get("gipiWEndtText")){								
								gipiWEndtText = wEndtText;
							}
							
							for(GIPIPARList parList : (List<GIPIPARList>) params.get("gipiParlist")){								
								gipiParList = parList;
							}
							
							for(GIPIWPolbas wPolbas : (List<GIPIWPolbas>) params.get("gipiWPolbas")){								
								gipiWPolbas = wPolbas;
							}
							
							params.remove("gipiParlist");
							params.remove("gipiWPolbas");
							params.remove("gipiWPolGenin");
							params.remove("gipiWEndtText");
							
							loadNewFormInstanceVariablesToRequest(request, params);
							
							Map<String, Object> newFormInstance = new HashMap<String, Object>();
							newFormInstance.put("parId", parId);
							
							newFormInstance = gipiWPolbasService.gipis031NewFormInstance(newFormInstance);					
							
							if(newFormInstance.get("msgAlert") != null){
								message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
								request.setAttribute("message", message);
								PAGE = "/pages/genericMessage.jsp";
							}else{
								loadNewFormInstanceVariablesToRequest(request, newFormInstance);
								
								String[] args = {lineCd};
								String[] args2 = {issCd};
								String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
								String lcEn = newFormInstance.get("varLcEn") != null ? newFormInstance.get("varLcEn").toString() : "";
								String[] issArgs = {"Y"};
								
								loadListingToRequest(request, lovHelper, args, args2,
										domainRisk, lineCd, lcEn, issArgs);
								
								GIISAssured assured = giisAssuredService.getGIISAssuredByAssdNo(gipiParList.getAssdNo().toString());
								String regionCd = newFormInstance.get("regionCd") != null ? newFormInstance.get("regionCd").toString() : "";
										
								gipiWPolbas.setDspAssdName(assured.getAssdName());
								gipiWPolbas.setRegionCd(regionCd);
								if(gipiWPolbas.getCredBranch() != null){
									// you cannot compare null to another null. it always result to false
								}else{
									gipiWPolbas.setCredBranch("HO");
								}							
								
								gipiParList.setParNo(gipiParService.getParNo(parId));								
								
								request.setAttribute("gipiParList", gipiParList);
								request.setAttribute("gipiWPolbas", gipiWPolbas);
								request.setAttribute("gipiWEndtText", StringFormatter.escapeHTMLInObject(gipiWEndtText));
								request.setAttribute("gipiWPolGenin", StringFormatter.escapeHTMLInObject(gipiWPolGenin));
								request.setAttribute("gipiWPolGeninJSON", new JSONObject((GIPIWPolGenin) StringFormatter.escapeHTMLInObject(gipiWPolGenin)));
								request.setAttribute("gipiWEndtTextJSON", new JSONObject((GIPIWEndtText) StringFormatter.escapeHTMLInObject(gipiWEndtText)));
								
								// set policy no (emman 07.03.11)
								policyNo = gipiWPolbas.getLineCd() + "-" + gipiWPolbas.getSublineCd() + "-" + gipiWPolbas.getIssCd()
											+ "-" + gipiWPolbas.getIssueYy() + "-" + String.format("%07d",gipiWPolbas.getPolSeqNo()) + "-" + String.format("%02d",Integer.parseInt(gipiWPolbas.getRenewNo()));
								request.setAttribute("policyNo", policyNo);
								
								request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParList);									
								String[] perilArgs = {Integer.toString(parId), lineCd}; 				//start - Gzelle 08172015 SR4851
								LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
								List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);
								request.setAttribute("dedPerilsList", perilsList);						//end - Gzelle 08172015 SR4851
								PAGE = "/pages/underwriting/endt/basicInfo/endtBasicInformationMain.jsp";
							}
						}					
					}else{
						LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env					
						//GIPIWPolGeninService gipiWPolGeninService = (GIPIWPolGeninService) APPLICATION_CONTEXT.getBean("gipiWPolGeninService");					
						//GIPIWEndtTextService gipiWEndtTextService = (GIPIWEndtTextService) APPLICATION_CONTEXT.getBean("gipiWEndtTextService"); // +env					
						//GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);					
						//GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
						//GIPIWinvTaxFacadeService gipiWinvTaxService = (GIPIWinvTaxFacadeService) APPLICATION_CONTEXT.getBean("gipiWinvTaxFacadeService"); // +env
						//GIPIWOpenPolicyService gipiWOpenPolicyService = (GIPIWOpenPolicyService) APPLICATION_CONTEXT.getBean("gipiWOpenPolicyService");					
						//GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
						System.out.println("Par Id: " + parId);
						Map<String, Object> newFormInstance = new HashMap<String, Object>();
						newFormInstance.put("parId", parId);
						
						newFormInstance = gipiWPolbasService.gipis031NewFormInstance(newFormInstance);					
						
						if(newFormInstance.get("msgAlert") != null){
							throw new SQLException();						
						}else{
							loadNewFormInstanceVariablesToRequest(request, newFormInstance);				
						}
						
						String[] args = {lineCd};
						String[] args2 = {issCd};
						String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
						String lcEn = newFormInstance.get("varLcEn") != null ? newFormInstance.get("varLcEn").toString() : "";
						String[] issArgs = {"Y"};
						
						loadListingToRequest(request, lovHelper, args, args2,
								domainRisk, lineCd, lcEn, issArgs);						
						
						String msgAlert = "";											
						
						/*Map isExistWOpenPOlicy = new HashMap();
						isExistWOpenPOlicy = gipiWOpenPolicyService.isExist(parId);
						String existWOpenPolicy= (String) isExistWOpenPOlicy.get("exist");
						request.setAttribute("isExistGipiWOpenPolicy", existWOpenPolicy);*/					
						
						Map parsWPolbas = new HashMap();
						parsWPolbas = gipiWPolbasService.isExist(parId);
						String isExistWPolbas = (String) parsWPolbas.get("exist");
						request.setAttribute("isExistGipiWPolbas", isExistWPolbas);					
						
						if (isExistWPolbas.equals("1")) {
							log.info("Getting gipi_wpolbas...");
							gipiWPolbas = gipiWPolbasService.getGipiWPolbas(parId);							
							request.setAttribute("gipiWPolbas", gipiWPolbas);
						} else {
							log.info("Getting gipi_wpolbas default value...");
							gipiWPolbas = gipiWPolbasService.getGipiWPolbasDefault(parId);
							request.setAttribute("gipiWPolbas", gipiWPolbas);
						}						
						
						//gipiWPolGenin = gipiWPolGeninService.getGipiWPolGenin(parId);
						//request.setAttribute("gipiWPolGenin", gipiWPolGenin);				
						
						msgAlert = gipiWPolbas.getMsgAlert();						
														
						Map<String, Object> params = new HashMap<String, Object>();
						params.put("parId", parId);
						params = gipiWPolbasService.getRecordsForService(params);						
						
						for(GIPIWPolGenin wPolGenin : (List<GIPIWPolGenin>) params.get("gipiWPolGenin")){							
							gipiWPolGenin = wPolGenin;
						}
						
						for(GIPIWEndtText wEndtText : (List<GIPIWEndtText>) params.get("gipiWEndtText")){							
							gipiWEndtText = wEndtText;
						}
						
						for(GIPIWOpenPolicy wOpenPolicy : (List<GIPIWOpenPolicy>) params.get("gipiWOpenPolicy")){							
							gipiWOpenPolicy = wOpenPolicy;
						}
						/*
						for(GIPIItem wItem : (List<GIPIItem>) params.get("gipiWItem")){							
							gipiWItem = wItem;
						}
						
						for(GIPIWItemPeril wItmPerl : (List<GIPIWItemPeril>) params.get("gipiWItmPerl")){
							gipiWItmPerl = wItmPerl;
						}
						*/
						for(GIPIPARList parList : (List<GIPIPARList>) params.get("gipiParList")){							
							gipiParList = parList;
						}						
						
						request.setAttribute("gipiWEndtText", StringFormatter.escapeHTMLInObject(gipiWEndtText));
						request.setAttribute("gipiWPolGenin", StringFormatter.escapeHTMLInObject(gipiWPolGenin));
						request.setAttribute("gipiWPolGeninJSON", new JSONObject((GIPIWPolGenin) StringFormatter.replaceQuotesInObject(gipiWPolGenin)));
						request.setAttribute("gipiWEndtTextJSON", new JSONObject((GIPIWEndtText) StringFormatter.replaceQuotesInObject(gipiWEndtText)));
						request.setAttribute("gipiWOpenPolicy", gipiWOpenPolicy);
						//request.setAttribute("gipiWItems", (List<GIPIItem>) params.get("gipiWItem"));
						//request.setAttribute("gipiWItmPerls", (List<GIPIWItemPeril>) params.get("gipiWItmPerl"));
						
						gipiParList.setParNo(composeParNo(gipiParList.getLineCd(), gipiParList.getIssCd(),
								gipiParList.getParYy(), gipiParList.getParSeqNo(), gipiParList.getQuoteSeqNo()));
						
						request.setAttribute("gipiParList", gipiParList);
						request.setAttribute("issCdRi", (String) params.get("issCdRi"));
						//request.setAttribute("endtText", gipiWPolbasService.getEndtText(parId));
						
						if (msgAlert != null){
							message = msgAlert;
						} else {
							message = "SUCCESS";
						}				
						
						// set policy no (emman 07.03.11)
						policyNo = gipiWPolbas.getLineCd() + "-" + gipiWPolbas.getSublineCd() + "-" + gipiWPolbas.getIssCd()
									+ "-" + gipiWPolbas.getIssueYy() + "-" + String.format("%07d",gipiWPolbas.getPolSeqNo()) + "-" + String.format("%02d",Integer.parseInt(gipiWPolbas.getRenewNo()));
						request.setAttribute("policyNo", policyNo);
						
						request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParList /*gipiParService.getGIPIPARDetails(parId)*/);									
						String[] perilArgs = {Integer.toString(parId), lineCd}; 				//start - Gzelle 08182015 SR4851
						LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
						List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);
						request.setAttribute("dedPerilsList", perilsList);						//end - Gzelle 08182015 SR4851						
						PAGE = "/pages/underwriting/endt/basicInfo/endtBasicInformationMain.jsp";
					}
					
					// mark jm 05.18.2011
					GIPIWItemService itemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");
					GIPIWItemPerilService perilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
					
					request.setAttribute("gipiWItem", new JSONArray(itemService.getGIPIWItem(parId)));
					request.setAttribute("gipiWItmperl", new JSONArray(perilService.getGIPIWItemPerils(parId)));
				} else if("saveBasicInfo".equals(ACTION)) {
					log.info("Saving basic information...");
					GIPIParMortgageeFacadeService gipiWMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
					GIPIWDeductibleFacadeService gipiWDeductibleService = (GIPIWDeductibleFacadeService) APPLICATION_CONTEXT.getBean("gipiWDeductibleFacadeService");
					GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
					GIPIWPolGenin gipiWPolGenin = new GIPIWPolGenin();
					
					gipiWPolbas = prepareGipiWPolbas(request, response, USER);
					//log.info("saveBasicInfo test param : "+gipiWPolbas.getQuotationPrintedSw()+" / "+gipiWPolbas.getParId());
					gipiWPolGenin = prepareGipiWPolGenin(request, response, USER);
					Map<String, Object> gipiWPolnrepMap = prepareGIPIWPolnrepMap(request, response); // andrew - 09.16.2010 - added for saving of policy renewal/replacement details
					//Map<String, Object> gipiWDeductibleMap = prepareGIPIWDeductibleMap(request, response, USER); // andrew - 09.17.2010 - added for saving of deductibles details

					JSONObject param = new JSONObject(request.getParameter("parameters"));
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("gipiWpolbas", gipiWPolbas);
					params.put("gipiWPolGenin", gipiWPolGenin);
					params.put("gipiWPolnrepMap", gipiWPolnrepMap); // andrew - 09.16.2010 - added for saving of policy renewal/replacement details
					//params.put("gipiWDeductibleMap", gipiWDeductibleMap); // andrew - 09.17.2010 - added for saving of deductible details
					params.put("openPolicySw", request.getParameter("isOpenPolicy"));
					params.put("validatedBookingDate", request.getParameter("validatedBookingDate"));
					params.put("deleteWPolnrep", request.getParameter("deleteWPolnrep"));
					params.put("paramAssuredNo", request.getParameter("paramAssuredNo"));
					params.put("deleteCoIns", request.getParameter("deleteCoIns"));
					params.put("deleteBillSw", request.getParameter("deleteBillSw"));
					params.put("deleteAllTables", request.getParameter("deleteAllTables"));
					params.put("deleteCommInvoice", request.getParameter("deleteCommInvoice"));
					params.put("validatedIssuePlace", request.getParameter("validatedIssuePlace"));
					params.put("deleteSw", request.getParameter("deleteSw"));
					params.put("dateSw", request.getParameter("dateSw"));
					params.put("precommitDelTab", request.getParameter("precommitDelTab"));
					params.put("mortgageeInsList", gipiWMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(param.getString("setMortgagees"))));
					params.put("mortgageeDelList", gipiWMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(param.getString("delMortgagees"))));
					params.put("setDeductibles", gipiWDeductibleService.prepareGIPIWDeductibleForInsert(new JSONArray(param.getString("setDeductibles"))));
					params.put("delDeductibles", gipiWDeductibleService.prepareGIPIWDeductibleForDelete(new JSONArray(param.getString("delDeductibles"))));
					
					if ("Y".equals(params.get("openPolicySw"))){
						params.put("openPolicyChanged", request.getParameter("openPolicyChanged"));
						DateFormat df = new SimpleDateFormat("MM-dd-yyyy");  //replace by steven from: MM-dd-yyyy hh:mm:ss to: MM-dd-yyyy
						Map<String, Object> opParams = new HashMap<String, Object>();
						opParams.put("parId", parId);
						opParams.put("lineCd", lineCd);
						opParams.put("opSublineCd", request.getParameter("opSublineCd"));
						opParams.put("opIssCd", request.getParameter("opIssCd"));
						opParams.put("opIssueYy", Integer.parseInt(request.getParameter("opIssYear")));
						opParams.put("opPolSeqno", Integer.parseInt(request.getParameter("opPolSeqNo")));
						opParams.put("opRenewNo", Integer.parseInt(request.getParameter("opRenewNo")));
						opParams.put("decltnNo", request.getParameter("declaration"));
						opParams.put("effDate", request.getParameter("globalEffDate") == "" ? null : df.parse(request.getParameter("globalEffDate")));
						params.put("opParams", opParams);
					}
					
					Map<String, Object> paramsResult = new HashMap<String, Object>();
					paramsResult = gipiWPolbasService.savePARBasicInfo(params);
					message = (new JSONObject(StringFormatter.replaceQuotesInMap(paramsResult))).toString();
					
					PAGE = "/pages/genericMessage.jsp";
				} else if ("whenValidateSubline".equals(ACTION)) {
					log.info("Validating subline basic information...");
					String sublineCd = request.getParameter("sublineCd");
					String paramSublineCd = request.getParameter("paramSublineCd");
					message = gipiWPolbasService.validateSubline(parId, lineCd, sublineCd, paramSublineCd);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("whenValidateCoInsurance".equals(ACTION)) {
					log.info("Validating Co Insurance...");
					int coIns = Integer.parseInt(request.getParameter("coIns"));
					message = gipiWPolbasService.validateCoInsurance(parId, coIns);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("coInsurance".equals(ACTION)) {
					log.info("Checking Co Insurance...");
					Map<String, Object> paramsResult = new HashMap<String, Object>();
					paramsResult = gipiWPolbasService.coInsurance(parId);
					message = (new JSONObject(StringFormatter.replaceQuotesInMap(paramsResult))).toString();
					PAGE = "/pages/genericMessage.jsp";	
				} else if ("whenValidateRefPolNo".equals(ACTION)){
					log.info("Validating Reference Policy No...");
					message = gipiWPolbasService.validateRefPolNo(parId, request.getParameter("refPolNo"));
					PAGE = "/pages/genericMessage.jsp";
				} else if ("getIssueYy".equals(ACTION)){
					Map parsIssueYy = new HashMap();
					parsIssueYy = gipiWPolbasService.getIssueYy(request.getParameter("bookingMth"), request.getParameter("bookingYear"), request.getParameter("doi"), request.getParameter("issueDate"));
					log.info("issue Yy parameters --> "+parsIssueYy);
					String issueYy = (String) parsIssueYy.get("issueYy");
					String msg = (String) parsIssueYy.get("msgAlert");
					if (msg.equals("Y")){
						message = msg;
					} else {
						message = issueYy;
					}
					
					PAGE = "/pages/genericMessage.jsp";					
				} else if("validateEndtInceptExpiryDate".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();					
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");																			
					
					params = loadPolicyNoToMap(request);
					params.put("parId", parId);
					params.put("inceptDate", sdf.parse(request.getParameter("inceptDate")));
					params.put("effDate", sdf.parse(request.getParameter("effDate")));
					params.put("expiryDate", sdf.parse(request.getParameter("expiryDate")));
					params.put("fieldName", request.getParameter("fieldName"));					
					System.out.println("inceptDate: "+ sdf.parse(request.getParameter("inceptDate")));
					System.out.println("effDate: "+ sdf.parse(request.getParameter("effDate")));
					System.out.println("expiryDate: "+ sdf.parse(request.getParameter("expiryDate")));
					System.out.println("fieldName: "+ request.getParameter("fieldName"));
					
					//message = generateResponse(gipiWPolbasService.validateEndtInceptExpiryDate(params));					
					//params = null;
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.validateEndtInceptExpiryDate(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("validateEndtEffDate".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");					
					
					String oldDateEff = request.getParameter("varOldDateEff");
					String maxEffDate = request.getParameter("varMaxEffDate");
					@SuppressWarnings("unused")
					String expiryDate = request.getParameter("varExpiryDate");
					
					params = loadPolicyNoToMap(request);
					
					params.put("varOldDateEff", oldDateEff != null && !(oldDateEff.isEmpty()) ? sdf.parse(oldDateEff) : null);
					params.put("parId", parId);
					params.put("prorateFlag", request.getParameter("prorateFlag"));
					params.put("endtExpiryDate", sdf.parse(request.getParameter("endtExpiryDate")));
					params.put("compSw", request.getParameter("compSw"));
					params.put("polFlag", request.getParameter("polFlag"));
					params.put("expChgSw", request.getParameter("expChgSw"));					
					params.put("varMaxEffDate", maxEffDate != null && !(maxEffDate.isEmpty()) ? sdf.parse(maxEffDate) : null);
					params.put("parFirstEndtSw", request.getParameter("parFirstEndtSw"));
					//params.put("varExpiryDate", expiryDate != null && !(expiryDate.isEmpty()) ? sdf.parse(expiryDate) : null);
					params.put("parVarVdate", Integer.parseInt(request.getParameter("parVarVdate")));					
					params.put("issueDate", sdf.parse(request.getParameter("issueDate")));
					params.put("effDate", request.getParameter("effDate"));
					params.put("inceptDate", request.getParameter("inceptDate"));
					params.put("expiryDate", request.getParameter("expiryDate"));
					params.put("endtYY", request.getParameter("endtYY"));
					params.put("sysdateSw", request.getParameter("sysdateSw"));
					params.put("cgBackEndt", request.getParameter("cgBackEndtSw"));
					params.put("parBackEndtSw", request.getParameter("parBackEndtSw"));
					
					//params = gipiWPolbasService.validateEndtEffDate(params);					
					
					/*message = generateResponse(gipiWPolbasService.validateEndtEffDate(params));										
					
					oldDateEff = null;
					maxEffDate = null;
					expiryDate = null;
					params = null;*/
					
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.validateEndtEffDate(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkForPendingClaims".equals(ACTION)){										
					Map<String, Object> params = new HashMap<String, Object>();	
					
					params = loadPolicyNoToMap(request);					
					
					message = gipiWPolbasService.checkForPendingClaims(params) > 0 ? "Y" : "N";
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkPolicyPayment".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					
					message = gipiWPolbasService.checkPolicyPayment(params).toString();				
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkEndtForItemAndPeril".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();					
					//StringBuilder sb = new StringBuilder();
					
					params.put("parId", parId);					
					
					params = gipiWPolbasService.checkEndtForItemAndPeril(params);
					
					//sb.append("itemCount=" + params.get("itemCount").toString());
					//sb.append("&perilCount=" + params.get("perilCount").toString());
					
					//message = sb.toString();
					//params = null;
					//sb = null;
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
					request.setAttribute("message", message);					
					PAGE = "/pages/genericMessage.jsp";
				} else if("preGetAmounts".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					
					params = loadPolicyNoToMap(request);
					params.put("parId", parId);
					params.put("effDate", sdf.parse(request.getParameter("effDate")));
					
					message = gipiWPolbasService.preGetAmounts(params);
					params = null;
					request.setAttribute("message", message);					
					PAGE = "/pages/genericMessage.jsp";					
				} else if("checkForPolProrateFlagInterruption".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> validationResult = new HashMap<String, Object>();
					//StringBuilder result = new StringBuilder();
					
					int recordStatus = Integer.parseInt(request.getParameter("recordStatus"));
					
					params.put("parId", parId);					
					params.put("inceptDate",  request.getParameter("inceptDate"));
					params.put("effDate", request.getParameter("effDate"));
					params.put("recordStatus", recordStatus > 0 ? "CHANGED" : "NO_CHANGES");
					
					if("PolFlag".equals(request.getParameter("columnName"))){
						validationResult = gipiWPolbasService.checkForPolFlagInterruption(params);
					} else{
						validationResult = gipiWPolbasService.checkForProrateFlagInterruption(params);
					}
					
					/*if(validationResult.get("msgAlert") != null){						
						result.append("msgAlert=" + validationResult.get("msgAlert").toString());
						result.append("&transactionComplete=" + validationResult.get("compTrans").toString());
					}
										
					message = result.toString();
					params = null;
					validationResult = null;*/
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(validationResult)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("executeCheckPolFlagProcedures".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> validationResult = new HashMap<String, Object>();					
					//StringBuilder result = new StringBuilder();					
					
					params.put("parId", parId);
					params.put("coInsuranceSw", request.getParameter("b540CoInsuranceSw"));
					params.put("effDate", request.getParameter("endtEffDate"));
					
					validationResult = gipiWPolbasService.executeCheckPolFlagProcedures(params);					
											
					/*result.append("msgAlert=" + ((validationResult.get("msgAlert") != null) ? 
						validationResult.get("msgAlert").toString() : ""));
					result.append("&effDate=" + ((validationResult.get("effDate") != null) ? 
						validationResult.get("effDate").toString() : ""));
					result.append("&parStatus=" + ((validationResult.get("parStatus") != null) ? 
						validationResult.get("parStatus").toString() : ""));
					result.append("&tsiAmt=" + ((validationResult.get("tsiAmt") != null) ? 
						validationResult.get("tsiAmt").toString() : ""));
					result.append("&premAmt=" + ((validationResult.get("premAmt") != null) ? 
						validationResult.get("premAmt").toString() : ""));
					result.append("&annTsiAmt=" + ((validationResult.get("annTsiAmt") != null) ? 
						validationResult.get("annTsiAmt").toString() : ""));
					result.append("&annPremAmt=" + ((validationResult.get("annPremAmt") != null) ? 
						validationResult.get("annPremAmt").toString() : ""));
					result.append("&varExpiryDate=" + ((validationResult.get("vExpiryDate") != null) ? 
						validationResult.get("vExpiryDate").toString() : ""));
					result.append("&inceptDate=" + ((validationResult.get("inceptDate") != null) ? 
						validationResult.get("inceptDate").toString() : ""));
					result.append("&expiryDate=" + ((validationResult.get("expiryDate") != null) ? 
						validationResult.get("expiryDate").toString() : ""));
					result.append("&endtExpiryDate=" + ((validationResult.get("endtExpiryDate") != null) ? 
						validationResult.get("endtExpiryDate").toString() : ""));
					result.append("&prorateSw=" + ((validationResult.get("prorateSw") != null) ? 
						validationResult.get("prorateSw").toString() : ""));
					result.append("&prorateFlag=" + ((validationResult.get("prorateFlag") != null) ? 
						validationResult.get("prorateFlag").toString() : ""));
					result.append("&compSw=" + ((validationResult.get("compSw") != null) ? 
						validationResult.get("compSw").toString() : ""));
					result.append("&polFlag=" + ((validationResult.get("polFlag") != null) ? 
						validationResult.get("polFlag").toString() : ""));
					result.append("&coiCancellation=" + ((validationResult.get("coiCancellation") != null) ? 
						validationResult.get("coiCancellation").toString() : ""));
					result.append("&endtCancellation=" + ((validationResult.get("endtCancellation") != null) ? 
						validationResult.get("endtCancellation").toString() : ""));
					result.append("&varCnclldFlatFlag=" + ((validationResult.get("vCnclldFlatFlag") != null) ? 
						validationResult.get("vCnclldFlatFlag").toString() : ""));
					
					message = result.toString();
					params = null;
					validationResult = null;
					result = null;*/
					
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(validationResult)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("executeUncheckPolFlagProcedures".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> validationResult = new HashMap<String, Object>();					
					//StringBuilder result = new StringBuilder();					
					
					params.put("parId", parId);
					params.put("coInsuranceSw", request.getParameter("b540CoInsuranceSw"));
					params.put("effDate", request.getParameter("endtEffDate"));
					
					validationResult = gipiWPolbasService.executeCheckPolFlagProcedures(params);
					
					/*result.append("msgAlert=" + ((validationResult.get("msgAlert") != null) ? 
						validationResult.get("msgAlert").toString() : ""));
					result.append("&effDate=" + ((validationResult.get("effDate") != null) ? 
						validationResult.get("effDate").toString() : ""));
					result.append("&parStatus=" + ((validationResult.get("parStatus") != null) ?
						validationResult.get("parStatus").toString() : ""));
					result.append("&annTsiAmt=" + ((validationResult.get("annTsiAmt") != null) ? 
						validationResult.get("annTsiAmt").toString() : ""));
					result.append("&annPremAmt=" + ((validationResult.get("annPremAmt") != null) ? 
						validationResult.get("annPremAmt").toString() : ""));
					result.append("&prorateSw=" + ((validationResult.get("prorateSw") != null) ? 
						validationResult.get("prorateSw").toString() : ""));
					result.append("&prorateFlag=" + ((validationResult.get("prorateFlag") != null) ? 
						validationResult.get("prorateFlag").toString() : ""));
					result.append("&polFlag=" + ((validationResult.get("polFlag") != null) ? 
						validationResult.get("polFlag").toString() : ""));
					result.append("&varCnclldFlatFlag=" + ((validationResult.get("vCnclldFlatFlag") != null) ? 
						validationResult.get("vCnclldFlatFlag").toString() : ""));
					
					message = result.toString();
					params = null;
					validationResult = null;
					result = null;*/
					
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(validationResult)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("executeCheckProrateFlagProcedures".equals(ACTION)){					
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> validationResult = new HashMap<String, Object>();					
					//StringBuilder result = new StringBuilder();					
					
					params.put("parId", parId);
					params.put("coInsuranceSw", request.getParameter("b540CoInsuranceSw"));
					params.put("effDate", request.getParameter("endtEffDate"));
					
					validationResult = gipiWPolbasService.executeCheckProrateFlagProcedures(params);
					
					/*result.append("msgAlert=" + ((validationResult.get("msgAlert") != null) ? 
						validationResult.get("msgAlert").toString() : ""));
					result.append("&effDate=" + ((validationResult.get("effDate") != null) ? 
						validationResult.get("effDate").toString() : ""));					
					result.append("&annTsiAmt=" + ((validationResult.get("annTsiAmt") != null) ? 
						validationResult.get("annTsiAmt").toString() : ""));
					result.append("&annPremAmt=" + ((validationResult.get("annPremAmt") != null) ? 
						validationResult.get("annPremAmt").toString() : ""));					
					result.append("&prorateSw=" + ((validationResult.get("prorateSw") != null) ? 
						validationResult.get("prorateSw").toString() : ""));
					result.append("&prorateFlag=" + ((validationResult.get("prorateFlag") != null) ? 
						validationResult.get("prorateFlag").toString() : ""));
					result.append("&compSw=" + ((validationResult.get("compSw") != null) ? 
						validationResult.get("compSw").toString() : ""));
					result.append("&polFlag=" + ((validationResult.get("polFlag") != null) ? 
						validationResult.get("polFlag").toString() : ""));
					result.append("&coiCancellation=" + ((validationResult.get("coiCancellation") != null) ? 
						validationResult.get("coiCancellation").toString() : ""));
					result.append("&endtCancellation=" + ((validationResult.get("endtCancellation") != null) ? 
						validationResult.get("endtCancellation").toString() : ""));
					result.append("&varCnclldFlag=" + ((validationResult.get("vCnclldFlag") != null) ? 
						validationResult.get("vCnclldFlag").toString() : ""));
					
					message = result.toString();
					params = null;
					validationResult = null;
					result = null;*/
					
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(validationResult)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("validateEndtExpiryDate".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();										
					
					int recordStatus = Integer.parseInt(request.getParameter("recordStatus"));
					
					params.put("recordStatus", recordStatus > 0 ? "CHANGED" : "NO_CHANGES");
					params.put("lineCd", lineCd);
					params.put("sublineCd", request.getParameter("sublineCd"));
					params.put("expiryDate", request.getParameter("expiryDate"));
					params.put("effDate", request.getParameter("effDate"));
					params.put("endtExpiryDate", request.getParameter("endtExpiryDate"));
					params.put("varOldDateExp", request.getParameter("varOldDateExp"));
					params.put("compSw", request.getParameter("compSw"));
					params.put("varAddTime", Integer.parseInt(request.getParameter("varAddTime")));										
					System.out.println("varOldDateExp: "+ request.getParameter("varOldDateExp"));
					System.out.println("varAddTime: "+ Integer.parseInt(request.getParameter("varAddTime")));
					System.out.println("Exp: " + request.getParameter("expiryDate") + " Endt Exp: " + request.getParameter("endtExpiryDate"));
					
					//message = generateResponse(gipiWPolbasService.validateEndtExpDate(params));
					//params = null;
					
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.validateEndtExpDate(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("validateEndtIssueDate".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("parId", parId);
					params.put("parVarVdate", request.getParameter("parVarVdate"));
					params.put("issueDate", request.getParameter("issueDate"));
					params.put("effDate", request.getParameter("effDate"));
					
					message = generateResponse(gipiWPolbasService.validateEndtIssueDate(params));
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("validateBeforeSave".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> validationResult = new HashMap<String, Object>();
					//StringBuilder result = new StringBuilder();
					
					params.put("parId", parId);
					params.put("lineCd", lineCd);					
					params.put("issCd", issCd);
					params.put("polFlag", request.getParameter("polFlag"));
					params.put("nbtPolFlag", request.getParameter("checkPolFlag"));
					params.put("prorateSw", request.getParameter("checkProrateSw"));
					params.put("parBackEndtSw", request.getParameter("parBackEndtSw"));
					params.put("parInsWinvoice", request.getParameter("parInsWinvoice"));
					params.put("surveyAgentCd", request.getParameter("b540SurveyAgentCd"));
					params.put("settlingAgentCd", request.getParameter("b540SettlingAgentCd"));
					params.put("parConfirmSw", request.getParameter("parConfirmSw"));
					params.put("varCommitSwitch", request.getParameter("varCommitSwitch"));
					params.put("varPolChangedSw", request.getParameter("varPolChangedSw"));
					params.put("inceptDate", request.getParameter("doi"));
					params.put("varOldInceptDate", request.getParameter("varOldInceptDate"));
					params.put("expiryDate", request.getParameter("doe"));
					params.put("varOldExpiryDate", request.getParameter("varOldExpiryDate"));
					params.put("effDate", request.getParameter("endtEffDate"));
					params.put("varOldEffDate", request.getParameter("varOldEffDate"));
					params.put("endtExpiryDate", request.getParameter("endtExpDate"));
					params.put("varOldEndtExpiryDate", request.getParameter("varOldEndtExpiryDate"));
					params.put("varOldProvPremTag", request.getParameter("varOldProvPremTag"));
					params.put("provPremTag", request.getParameter("b540ProvPremTag"));
					params.put("provPremPct", new BigDecimal(request.getParameter("b540ProvPremPct").isEmpty() ? "0.00" : request.getParameter("b540ProvPremPct")));
					params.put("varOldProvPremPct", new BigDecimal(request.getParameter("varOldProvPremPct").isEmpty() ? "0.00" : request.getParameter("varOldProvPremPct")));
					params.put("varProrateSw", request.getParameter("varProrateSw"));
					params.put("prorateFlag", request.getParameter("b540ProrateFlag"));
					params.put("varOldProrateFlag", request.getParameter("varOldProrateFlag"));
					params.put("nbtShortRtPercent", new BigDecimal(request.getParameter("shortRatePercent").isEmpty() ? "0.00" : request.getParameter("shortRatePercent")));
					params.put("varOldShortRtPercent", new BigDecimal(request.getParameter("varOldShortRtPercent").isEmpty() ? "0.00" : request.getParameter("varOldShortRtPercent")));
					params.put("bookingYear", request.getParameter("bookingYY"));
					params.put("bookingMonth", request.getParameter("bookingMth"));
					params.put("parProrateCancelSw", request.getParameter("parProrateCancelSw"));				
					
					validationResult = gipiWPolbasService.validateBeforeSave(params);
					
					/*result.append("msgAlert=" + validationResult.get("msgAlert"));
					result.append("&msgType=" + validationResult.get("msgType"));
					result.append("&showPopup=" + validationResult.get("showPopup"));
					
					message = result.toString();				
					params = null;
					validationResult = null;*/
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(validationResult)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("saveEndtBasicInfo".equals(ACTION)){
					log.info("Saving endorsement basic information...");
					
					GIPIParMortgageeFacadeService gipiWMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
					
					JSONObject param = new JSONObject(request.getParameter("parameters"));
					
					Map<String, Object> params = new HashMap<String, Object>();
					Map<String, Object> resultMap = new HashMap<String, Object>();
					
					// endt basic info
					GIPIPARList gipiParList = new GIPIPARList();
					GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
					GIPIWPolGenin gipiWPolGenin = new GIPIWPolGenin();
					GIPIWEndtText gipiWEndtText = new GIPIWEndtText();
					
					// mortgagee					
					
					
					// deductibles
					String[] insDedItemNos = request.getParameterValues("insDedItemNo1");
					String[] delDedItemNos = request.getParameterValues("delDedItemNo1");
					System.out.println(request.getParameter("basicInfoParams"));
					JSONObject basicObj = new JSONObject(request.getParameter("basicInfoParams"));
					//gipiParList = prepareGIPIParList(request, response, USER);
					gipiParList = prepareGIPIParList(basicObj, USER);
					//gipiWPolbas = prepareEndtGipiWPolbas(request, response, USER);
					gipiWPolbas = prepareEndtGipiWPolbas(basicObj, parId, USER);
					//gipiWPolGenin = prepareGipiWPolGenin(request, response, USER);
					gipiWPolGenin = prepareGipiWPolGenin(basicObj, request, USER);
					gipiWEndtText = prepareGIPIWEndtText(request, response, USER);					
										
					Map<String, Object> vars = new HashMap<String, Object>();
					Map<String, Object> pars = new HashMap<String, Object>();
					Map<String, Object> others = new HashMap<String, Object>();
					
					String element = "";
					/*for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();){
						element = (String)e.nextElement();
						System.out.println("enumerate::: "+element);
						if("var".equals(element.substring(0, 3))){
							vars.put(element, request.getParameter(element));							
						}else if("par".equals(element.substring(0, 3))){
							pars.put(element, request.getParameter(element));							
						}else{
							System.out.println("element::: "+element+"=> "+request.getParameter(element));
							others.put(element, request.getParameter(element));
						}
						//System.out.println(element + "=" + request.getParameter(element));						
					}*/
					others.put("urlParNbtPolFlag", request.getParameter("urlParNbtPolFlag"));
					others.put("urlParProrateSw", request.getParameter("urlParProrateSw"));
					others.put("urlParEndtCancellation", request.getParameter("urlParEndtCancellation"));
					others.put("urlParCoiCancellation", request.getParameter("urlParCoiCancellation"));
					others.put("creditingBranch", request.getParameter("creditingBranch"));
					
					Map<String, Object> basicInfoMap = new HashMap<String, Object>();
					basicInfoMap = JSONUtil.prepareMapFromJSON(basicObj);
					Iterator<String> b = basicInfoMap.keySet().iterator();
					while (b.hasNext()) {
						String key = b.next().toString();
						//System.out.println("enumerate::: "+key);
						if ("var".equals(key.substring(0, 3))) {
							vars.put(key, basicInfoMap.get(key));
						} else if ("par".equals(key.substring(0, 3))) {
							pars.put(key, basicInfoMap.get(key));
						} else {
							others.put(key, basicInfoMap.get(key));
						}
					}
					
					System.out.println("others::: "+others);
					params.put("gipiParList", gipiParList);
					params.put("gipiWPolbas", gipiWPolbas);
					params.put("gipiWPolGenin", gipiWPolGenin);
					params.put("gipiWEndtText", gipiWEndtText);					
					params.put("vars", vars);
					params.put("pars", pars);
					params.put("others", others);
					params.put("mortgageeInsList", gipiWMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(param.getString("setMortgagees"))));
					params.put("mortgageeDelList", gipiWMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(param.getString("delMortgagees"))));
					/*
					if(insMortgItemNos != null){
						Map<String, Object> insMortgMap = new HashMap<String, Object>();
						String[] insMortgCds	= request.getParameterValues("insMortgAmounts");
						String[] insMortgAmts	= request.getParameterValues("insMortgCds");
						
						insMortgMap.put("parId", parId);
						insMortgMap.put("issCd", issCd);
						insMortgMap.put("userId", USER.getUserId());
						insMortgMap.put("insMortgItemNos", insMortgItemNos);
						insMortgMap.put("insMortgCds", insMortgCds);
						insMortgMap.put("insMortgAmts", insMortgAmts);
						
						params.put("insMortgagee", insMortgMap);
						
						insMortgMap = null;
					}
					
					if(delMortgItemNos != null){
						Map<String, Object> delMortgMap = new HashMap<String, Object>();						
						String[] delMortgCds	= request.getParameterValues("delMortgCds");
						
						delMortgMap.put("parId", parId);
						delMortgMap.put("issCd", issCd);
						delMortgMap.put("userId", USER.getUserId());
						delMortgMap.put("delMortgItemNos", delMortgItemNos);
						delMortgMap.put("delMortgCds", delMortgCds);
						
						params.put("delMortgagee", delMortgMap);
						
						delMortgMap = null;
					}
					*/
					if(insDedItemNos != null){
						Map<String, Object> insDeductMap = new HashMap<String, Object>();
						String[] perilCds 		 = request.getParameterValues("insDedPerilCd1");
						String[] deductibleCds 	 = request.getParameterValues("insDedDeductibleCd1");
						String[] deductibleAmts  = request.getParameterValues("insDedAmount1");
						String[] deductibleRts 	 = request.getParameterValues("insDedRate1");
						String[] deductibleTexts = request.getParameterValues("insDedText1");
						String[] aggregateSws 	 = request.getParameterValues("insDedAggregateSw1");
						String[] ceilingSws 	 = request.getParameterValues("insDedCeilingSw1");
						
						insDeductMap.put("parId", parId);
						insDeductMap.put("userId", USER.getUserId());
						insDeductMap.put("dedLineCd", lineCd);
						insDeductMap.put("dedSublineCd", gipiWPolbas.getSublineCd());
						insDeductMap.put("insDedItemNos", insDedItemNos);
						insDeductMap.put("insDedPerilCds", perilCds);
						insDeductMap.put("insDedDedCds", deductibleCds);
						insDeductMap.put("insDedDedAmts", deductibleAmts);
						insDeductMap.put("insDedDedRts", deductibleRts);
						insDeductMap.put("insDedDedTexts", deductibleTexts);
						insDeductMap.put("insDedAggSws", aggregateSws);
						insDeductMap.put("insDedCeilSws", ceilingSws);
						
						params.put("insDeductibles", insDeductMap);
						
						insDeductMap = null;
					}
					
					if(delDedItemNos != null){
						Map<String, Object> delDeductMap = new HashMap<String, Object>();
						String[] perilCds 		 = request.getParameterValues("delDedPerilCd1");
						String[] deductibleCds 	 = request.getParameterValues("delDedDeductibleCd1");
						
						delDeductMap.put("parId", parId);
						delDeductMap.put("delDedItemNos", delDedItemNos);
						delDeductMap.put("delDedPerilCds", perilCds);
						delDeductMap.put("delDedDedCds", deductibleCds);
						
						params.put("delDeductibles", delDeductMap);
						
						delDeductMap = null;
					}
					
					resultMap = gipiWPolbasService.saveEndtBasicInfo(params);					
					
					message = (String) resultMap.get("message");
					
					params = null;
					resultMap = null;
					
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkEnteredPolicyNo".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);					
					params = gipiWPolbasService.checkEnteredPolicyNo(params);
					
					message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";					
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkPolicyForSpoilage".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					params = gipiWPolbasService.checkPolicyForSpoilage(params);
					
					message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkClaims".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					params = gipiWPolbasService.checkClaims(params);
					
					message = params.get("msgAlert") != null ? params.get("msgAlert").toString() : "";
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";					
				} else if("searchForPolicy".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);					
					params = gipiWPolbasService.searchForPolicy(params);					
					
					for(GIPIWPolGenin gipiWPolGenin : (List<GIPIWPolGenin>) params.get("gipiWPolGenin")){
						System.out.println("PolGenin: " + gipiWPolGenin.getGenInfo01());
					}					
					
					for(GIPIWEndtText gipiWEndtText : (List<GIPIWEndtText>) params.get("gipiWEndtText")){
						System.out.println("Text 1: " + gipiWEndtText.getEndtTax());
					}
					
					for(GIPIPARList gipiParList : (List<GIPIPARList>) params.get("gipiParlist")){
						System.out.println("Address: " + gipiParList.getAddress1());
					}
					
					for(GIPIWPolbas gipiWPolbas : (List<GIPIWPolbas>) params.get("gipiWPolbas")){
						System.out.println("Issue Date: " + gipiWPolbas.getIssueDate());
					}					
					
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("createNegatedRecords".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					//StringBuilder sb = new StringBuilder();					
					
					params = loadPolicyNoToMap(request);
					params.put("parId", parId);
					params.put("coInsuranceSw", request.getParameter("coInsuranceSw"));
					params.put("packPolFlag", request.getParameter("packPolFlag"));										
					
					params.put("gipiWPolbas", prepareEndtGipiWPolbas(request, response, USER));
					
					
					if("flat".equals(request.getParameter("cancellationType"))){
						params = gipiWPolbasService.createNegatedRecordsFlat(params);						
					}else if("coi".equals(request.getParameter("cancellationType"))){
						params = gipiWPolbasService.createNegatedRecordsCoi(params);												
					}else if("endt".equals(request.getParameter("cancellationType"))){
						params = gipiWPolbasService.createNegatedRecordsEndt(params);						
					}				
					
					//request.setAttribute("items", (List<Map<String, Object>>) params.get("gipiWItem"));
					//request.setAttribute("perils", (List<Map<String, Object>>) params.get("gipiWItmPerl"));					
					/*
					sb.append("&gipiWItem=" 		+ ((((List<Map<String, Object>>) params.get("gipiWItem")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWItmPerl=" 		+ ((((List<Map<String, Object>>) params.get("gipiWItmPerl")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWFireItm=" 		+ ((((List<Map<String, Object>>) params.get("gipiWFireItm")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWVehicle=" 		+ ((((List<Map<String, Object>>) params.get("gipiWVehicle")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWAccidentItem=" + ((((List<Map<String, Object>>) params.get("gipiWAccidentItem")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWAviationItem=" + ((((List<Map<String, Object>>) params.get("gipiWAviationItem")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWCargo=" 		+ ((((List<Map<String, Object>>) params.get("gipiWCargo")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWCasualtyItem=" + ((((List<Map<String, Object>>) params.get("gipiWCasualtyItem")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWEnggBasic=" 	+ ((((List<Map<String, Object>>) params.get("gipiWEnggBasic")).size() > 0) ? "Y" : "N"));
					sb.append("&gipiWItemVes=" 		+ ((((List<Map<String, Object>>) params.get("gipiWItemVes")).size() > 0) ? "Y" : "N"));
					
					//	Remove the map that contains the record
					// 	in able to process the response
					//
					params.remove("gipiWItem");
					params.remove("gipiWItmPerl");
					params.remove("gipiWFireItm");
					params.remove("gipiWVehicle");
					params.remove("gipiWAccidentItem");
					params.remove("gipiWAviationItem");
					params.remove("gipiWCargo");
					params.remove("gipiWCasualtyItem");
					params.remove("gipiWEnggBasic");
					params.remove("gipiWItemVes");
					
					message = generateResponse(params) + sb.toString();					
					params = null;
					sb = null;*/
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";					
				} else if("checkPolicyForAffectingEndtToCancel".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);					
					message = gipiWPolbasService.checkPolicyForAffectingEndtToCancel(params);					
					
					params = null;
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkRecordForItemPeril".equals(ACTION)){
					message = gipiWPolbasService.endtCheckRecordInItemPeril(parId);					
					
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkRecordForItem".equals(ACTION)){					
					message = gipiWPolbasService.endtCheckRecordInItem(parId);					
					
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("showRecordsForCancellation".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					PAGE = "/pages/underwriting/endt/basicInfo/subPages/recordsForCancellation.jsp";
					if("endt".equals(request.getParameter("flag"))){
						request.setAttribute("recordMaps", gipiWPolbasService.getRecordsForEndtCancellation(params));
					} else if("coi".equals(request.getParameter("flag"))){						
						request.setAttribute("recordMaps", gipiWPolbasService.getRecordsForCoiCancellation(params));
					} else if("pack".equals(request.getParameter("flag"))) {
						// added by emman, for pack endt (03.09.2011)
						GIPIPackWPolBasService gipiPackWPolBasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService");
						request.setAttribute("recordMaps", gipiPackWPolBasService.getRecordsForPackEndtCancellation(params));
						PAGE = "/pages/underwriting/endt/basicInfo/subPages/recordsForCancellationPack.jsp";
					}
					
					params = null;
					//PAGE = "/pages/underwriting/endt/basicInfo/subPages/recordsForCancellation.jsp"; -- irwin
				} else if("processEndtCancellation".equals(ACTION)){
					//commented out by robert 10.31.2012
					/*Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					params.put("parId", parId);
					params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
					params.put("packPolFlag", request.getParameter("packPolFlag"));
					params.put("cancelType", request.getParameter("cancelType"));					
					params.put("effDate", request.getParameter("effDate"));
					
					//params = gipiWPolbasService.processEndtCancellation(params);
					//message = generateResponse(gipiWPolbasService.processEndtCancellation(params));
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.processEndtCancellation(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";*/
					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);								
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.processEndtCancellation(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if("processEndtCancellationGipis165".equals(ACTION)){
					String bondBasicObj = request.getParameter("bondBasicObj"); //robert 11.22.2013
					gipiWPolbasService.saveGipiWPolbasForEndtBond2(bondBasicObj, USER); //robert 11.22.2013
					
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					params.put("parId", parId);
					params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
					params.put("packPolFlag", request.getParameter("packPolFlag"));
					params.put("cancelType", request.getParameter("cancelType"));
					params.put("coiCancellation", request.getParameter("coiCancellation"));
					params.put("effDate", request.getParameter("effDate"));
					
					log.info("Process Endt Cancellation Params: "+params);
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.processEndtCancellationGipis165(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("showBackwardEndt".equals(ACTION)){
					PAGE = "/pages/underwriting/endt/basicInfo/subPages/backwardEndt.jsp";
				} else if("checkPolicyNoForEndt".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params = loadPolicyNoToMap(request);
					//message = generateResponse(gipiWPolbasService.checkPolicyNoForEndt(params));
					//params = null;
					message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.checkPolicyNoForEndt(params))).toString();
					request.setAttribute("message", message);
					PAGE = "/pages/genericMessage.jsp";
				} else if("showPolicyNo".equals(ACTION)){
					String sublineCd = request.getParameter("sublineCd");
					String polSeqNo = request.getParameter("polSeqNo");
					String issYy = request.getParameter("issueYy");
					String renewNo = request.getParameter("renewNo");
					String globalAssdNo = request.getParameter("globalAssdNo");//jmm
					String globalAssdName = request.getParameter("globalAssdName");
					System.out.println("global "+globalAssdNo);
					System.out.println("globalName "+globalAssdName);
					request.setAttribute("globalAssdName", globalAssdName);
					request.setAttribute("globalAssdNo", globalAssdNo);
					request.setAttribute("parId", parId);
					request.setAttribute("lineCdPol", lineCd);
					request.setAttribute("issCd", issCd);
					request.setAttribute("sublineCdPol", sublineCd);
					request.setAttribute("polSeqNo", polSeqNo);
					request.setAttribute("issueYy", issYy);
					request.setAttribute("renewNo", renewNo);
					request.setAttribute("oldPolicyNo", request.getParameter("oldPolicyNo")); // added by: Nica 05.04.2013
					System.out.println("attrib: " + lineCd + "+" + issCd + "+" + sublineCd);
					PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndt.jsp";					
				} else if("updateGipiWPolbasEndt".equals(ACTION)){					
					request.setAttribute("object", new JSONObject(gipiWPolbasService.updateGipiWPolbasEndt(request)));
					PAGE = "/pages/genericObject.jsp";
				} else if("genBankDetails".equals(ACTION)){
					log.info("Generating bank details...");
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parId", parId);
					params.put("acctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
					params.put("branchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
					params = gipiWPolbasService.genBankDetails(params);
					request.setAttribute("object", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					PAGE = "/pages/genericObject.jsp";
				} else if("validateAcctIssCd".equals(ACTION)){
					log.info("Validating issue code in bank details...");
					message = gipiWPolbasService.validateAcctIssCd((request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
					PAGE = "/pages/genericMessage.jsp";
				} else if("validateBranchCd".equals(ACTION)){
					log.info("Validating branch code in bank details...");
					HashMap<String, String> params = new HashMap<String, String>();
					params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
					params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
					message = gipiWPolbasService.validateBranchCd(params);
					PAGE = "/pages/genericMessage.jsp";
				} else if("openSearchBankRefNo".equals(ACTION)){
					PAGE = "/pages/pop-ups/searchBankRefNo.jsp";
				} else if("searchBankRefNoModal".equals(ACTION)){
					log.info("Getting Bank ref no. Listing records.");
					String keyword = request.getParameter("keyword");
					if(null==keyword){
						keyword = "";
					}
					
					Integer pageNo = 0;
					if(null!=request.getParameter("pageNo")){
						if(!"undefined".equals(request.getParameter("pageNo"))){
							pageNo = new Integer(request.getParameter("pageNo"))-1;
						}
					}
					
					HashMap<String, Object> params =  new HashMap<String, Object>();
					params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
					params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
					params.put("keyword", keyword);
					params.put("isPack", (request.getParameter("isPack") == null ? "N" : request.getParameter("isPack")));
					
					log.info("Parameters: "+params);
					
					PaginatedList searchResult = null;
					searchResult = gipiWPolbasService.getBankRefNoList(params,pageNo);
					request.setAttribute("keyword", keyword);
					request.setAttribute("pageNo", searchResult.getPageIndex()+1);
					request.setAttribute("noOfPages", searchResult.getNoOfPages());
					
					JSONArray searchResultJSON = new JSONArray(searchResult);
					request.setAttribute("searchResultJSON", searchResultJSON);
					
					PAGE = "/pages/pop-ups/searchBankRefNoAjaxResult.jsp";
				} else if("validateBankRefNo".equals(ACTION)){
					log.info("Validating bank reference no. in bank details...");
					HashMap<String, String> params = new HashMap<String, String>();
					params.put("nbtAcctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
					params.put("nbtBranchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
					params.put("dspRefNo", (request.getParameter("dspRefNo") == null ? "" :request.getParameter("dspRefNo")));
					params.put("dspModNo", (request.getParameter("dspModNo") == null ? "" :request.getParameter("dspModNo")));
					params.put("bankRefNo", (request.getParameter("bankRefNo") == null ? "" :request.getParameter("bankRefNo")));
					message = gipiWPolbasService.validateBankRefNo(params);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("getBookingListing".equals(ACTION)){
					log.info("Getting booking month listing...");
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String date = request.getParameter("date");
					String[] argsDate = {date};
					List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
					message = new JSONArray(bookingMonths).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if("showEditPolicyNo".equals(ACTION)){
					gipiWPolbasService.showEditPolicyNo(request);
					PAGE = "/pages/underwriting/endt/basicInfo/subPages/editPolicyNoForEndt.jsp";
				} else if("getEndtRiskTag".equals(ACTION)){
					message = new JSONObject((Map<String,Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.getEndtRiskTag(request))).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if("searchForEditedPolicy".equals(ACTION)){
					message = new JSONObject((Map<String,Object>) StringFormatter.replaceQuotesInMap(gipiWPolbasService.searchForEditedPolicy(request))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("updateCoverNoteDetails".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					Integer noOfDays = Integer.parseInt(request.getParameter("noOfDays")== ""? "0" : request.getParameter("noOfDays"));
					String updCNDetailsSw = request.getParameter("updCNDetailsSw");
					params.put("parId", parId);
					params.put("noOfDays", noOfDays);
					params.put("updCNDetailsSw", updCNDetailsSw);
					params.put("userId", USER.getUserId());
					gipiWPolbasService.updateCoverNoteDetails(params);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if("showRoadMap".equals(ACTION)){
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
					GIPIPARList parlist = gipiParService.getGIPIPARDetails(parId);
					GIPIWPolbas wpolbas = new GIPIWPolbas();
					
					if(parlist.getParStatus() > 2){
						wpolbas = gipiWPolbasService.getGipiWPolbas(parId);
					}
					
					request.setAttribute("jsonPAR", new JSONObject(StringFormatter.escapeHTMLInObject(parlist)));
					request.setAttribute("jsonWPolbas", new JSONObject(StringFormatter.escapeHTMLInObject(wpolbas)));
					request.setAttribute("parNo", parlist.getParNo());
					request.setAttribute("userId", USER.getUserId());
					PAGE = "/pages/underwriting/roadMap/roadMap.jsp";
				}else if("showEndtBasicInfo01".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.10.2012
					request.setAttribute("updIssueDate", giisParametersService.getParamValueV2("UPDATE_ISSUE_DATE")); // added by: Nica 05.14.2012
					request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("reqCredBranch", giisParametersService.getParamValueV2("MANDATORY_CRED_BRANCH")); // added by apollo 07.24.2015 SR#2749
					
					params.put("request", request);
					params.put("lovHelper", (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"));
					params.put("parId", parId);
					params.put("lineCd", lineCd);
					params.put("issCd", issCd);
					
					params = gipiWPolbasService.endtBasicInfoNewFormInstance(params);
					String[] perilArgs = {Integer.toString(parId), lineCd}; 				//start - Gzelle 08172015 SR4851
					LOVHelper perilLovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
					List<LOV> perilsList = perilLovHelper.getList(LOVHelper.WPERIL_LISTING, perilArgs);
					request.setAttribute("dedPerilsList", perilsList);						//end - Gzelle 08172015 SR4851
					
					request.setAttribute("confirmResult", request.getParameter("confirmResult")); // jmm SR-22834
					request.setAttribute("newAssdName", request.getParameter("globalAssdName"));
					request.setAttribute("newAssdNo", request.getParameter("globalAssdNo"));
					request.setAttribute("address1", request.getParameter("address1"));
					request.setAttribute("address2", request.getParameter("address2"));
					request.setAttribute("address3", request.getParameter("address3")); // end SR-22834
					message = params.get("message") != null ? params.get("message").toString() : "SUCCESS";
				    PAGE = params.get("PAGE").toString();
				}else if("validateEffDate01".equals(ACTION) || "validateEffDate02".equals(ACTION) || "validateEffDate03".equals(ACTION) || "validateEffDate04".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					if("validateEffDate01".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateEffDate01(params);
					}else if("validateEffDate02".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateEffDate02(params);
					}else if("validateEffDate03".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateEffDate03(params);
					}else if("validateEffDate04".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateEffDate04(params);
					}
					
					message = (new JSONObject(params)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("validateEndtExpiryDate01".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					message = (new JSONObject(gipiWPolbasService.gipis031ValidateEndtExpiryDate(params))).toString();
					PAGE = "/pages/genericMessage.jsp";	
				}else if("validateInceptDate01".equals(ACTION) || "validateInceptDate02".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					if("validateInceptDate01".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateInceptDate01(params);
					}else if("validateInceptDate02".equals(ACTION)){						
						params = gipiWPolbasService.gipis031ValidateInceptDate02(params);
					}
					
					message = (new JSONObject(params)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("validateExpiryDate01".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					message = (new JSONObject(gipiWPolbasService.gipis031ValidateExpiryDate01(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("validateIssueDate01".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					message = (new JSONObject(gipiWPolbasService.gipis031ValidateIssueDate01(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("getBookingDate".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					message = (new JSONObject(gipiWPolbasService.gipis031GetBookingDate(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("checkNewRenewals".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					
					message = (new JSONObject(gipiWPolbasService.gipis031CheckNewRenewals(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("endtCoiCancellationTagged".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);								
					params = gipiWPolbasService.gipis031EndtCoiCancellationTagged(params);					
					params.remove("gipiWPolbas");
					
					message = (new JSONObject(params)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("saveEndtBasic01".equals(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					
					params.put("request", request);
					params.put("userId", USER.getUserId());
					gipiWPolbasService.saveEndtBasicInfo01(params);					
					
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}else if("getBookingDateGIPIS002".equals(ACTION)) {
					System.out.println("SADF@#$R QDAD");
					DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("parVarIDate", "".equals(request.getParameter("varIDate")) ? null : sdf.parse(request.getParameter("varIDate")));
					System.out.println("params: "+params);
					message = (new JSONObject(gipiWPolbasService.getBookingDateGIPIS002(params))).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("validatePolNo".equals(ACTION)) {
					message = gipiWPolbasService.validatePolNo(request);
					PAGE = "/pages/genericMessage.jsp";
				}else if("validateAssdNoRiCd".equals(ACTION)){
					request.setAttribute("object", new JSONObject(gipiWPolbasService.validateAssdNoRiCd(request)));
					PAGE = "/pages/genericObject.jsp";
				}else if("validatePackAssdNoRiCd".equals(ACTION)){
					request.setAttribute("object", new JSONObject(gipiWPolbasService.validatePackAssdNoRiCd(request)));
					PAGE = "/pages/genericObject.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}	
		
	}
	
	private String composeParNo(String lineCd, String issCd, Integer parYy, Integer parSeqNo, Integer quoteSeqNo){
		StringBuilder parNo = new StringBuilder();
		
		parNo.append(lineCd);
		parNo.append(" - ");
		parNo.append(issCd);
		parNo.append(" - ");
		parNo.append(String.format("%02d", parYy));
		parNo.append(" - ");
		parNo.append(String.format("%06d", parSeqNo));
		parNo.append(" - ");
		parNo.append(quoteSeqNo);
		
		return parNo.toString();		
	}
	
	private void loadListingToRequest(HttpServletRequest request,
			LOVHelper lovHelper, String[] args, String[] args2,
			String[] domainRisk, String lineCd, String lcEn, String[]issArgs) {

		List<LOV> sublineList = lovHelper.getList((lineCd).equals(lcEn) ? LOVHelper.SUB_LINE_SPF_LISTING : LOVHelper.SUB_LINE_LISTING, args);
		request.setAttribute("sublineListing", sublineList);

		List<LOV> branchSourceList2 = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
		request.setAttribute("branchSourceListing2", branchSourceList2);
		
		List<LOV> branchSourceList = lovHelper.getList(LOVHelper.ISSUE_SOURCE_BY_CRED_BR_TAG, issArgs);
		request.setAttribute("branchSourceListing", branchSourceList);
		
		List<LOV> policyStatusList = lovHelper.getList(LOVHelper.POLICY_STATUS_LISTING);
		request.setAttribute("policyStatusListing", policyStatusList);

		List<LOV> policyTypeList = lovHelper.getList(LOVHelper.POLICY_TYPE_LISTING, args);
		request.setAttribute("policyTypeListing", policyTypeList);

		List<LOV> placeList = lovHelper.getList(LOVHelper.PLACE_LISTING, args2);
		request.setAttribute("placeListing", placeList);

		List<LOV> riskTagList = lovHelper.getList(LOVHelper.RISK_TAG_LISTING,domainRisk);
		request.setAttribute("riskTagListing", riskTagList);

		List<LOV> industryList = lovHelper.getList(LOVHelper.INDUSTRY_LISTING);
		request.setAttribute("industryListing", industryList);

		List<LOV> regionList = lovHelper.getList(LOVHelper.REGION_LISTING);
		request.setAttribute("regionListing", regionList);

		List<LOV> takeupTermList = lovHelper.getList(LOVHelper.TAKEUP_TERM_LISTING);
		request.setAttribute("takeupTermListing", takeupTermList);

		Date date = new Date();
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		String[] argsDate = { format.format(date) };
		System.out.println("BOOKING PARAMS:"+argsDate[0]);
		List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
		request.setAttribute("bookingMonthListing", bookingMonths);
	}
	
	@SuppressWarnings("unchecked")
	private void loadNewFormInstanceVariablesToRequest(HttpServletRequest request, Map<String, Object> newFormInstance){
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		Set mapSet = newFormInstance.entrySet();
		Iterator mapIterator = mapSet.iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();
			
			if(!("parId".equals(entry.getKey()))){
				request.setAttribute(entry.getKey().toString(), entry.getValue());
			}
			//System.out.println(entry.getKey() + "=" + entry.getValue());
		}
		
		Date date = new Date();
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		String[] argsDate = { format.format(date) };
		
		List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
		request.setAttribute("objBookingMonthListing", new JSONArray(bookingMonths));
	}
	
	private Map<String, Object> loadPolicyNoToMap(HttpServletRequest request){
		Map<String, Object> policyNoMap = new HashMap<String, Object>();
		
		policyNoMap.put("lineCd", request.getParameter("lineCd"));
		policyNoMap.put("sublineCd", request.getParameter("sublineCd"));
		policyNoMap.put("issCd", request.getParameter("issCd"));
		policyNoMap.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		policyNoMap.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		policyNoMap.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		return policyNoMap;
	}
	
	@SuppressWarnings("unchecked")
	private String generateResponse(Map<String, Object> param){
		StringBuilder validationResult = new StringBuilder();
		
		Set mapSet = param.entrySet();
		Iterator mapIterator = mapSet.iterator();
		
		while(mapIterator.hasNext()){
			Map.Entry<String, Object> entry = (Map.Entry<String, Object>) mapIterator.next();
			
			if(validationResult.length() < 1){
				validationResult.append(entry.getKey() + "=" + (entry.getValue() != null /*&& !(entry.getValue().toString().isEmpty())*/ ? entry.getValue(): ""));
			}else{
				validationResult.append("&" + entry.getKey() + "=" + (entry.getValue() != null /*&& !(entry.getValue().toString().isEmpty())*/ ? entry.getValue(): ""));
			}
			//System.out.println(entry.getKey() + "=" + entry.getValue());
			//System.out.println(validationResult.toString());
		}		
		
		return validationResult.toString();		
	}

	/**
	 * Prepare gipi w pol genin.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param USER the uSER
	 * @return the gIPIW pol genin
	 * @throws JSONException 
	 */
	private GIPIWPolGenin prepareGipiWPolGenin(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws JSONException{
		log.info("Preparing GipiWPolGenin...");
		GIPIWPolGenin gipiWPolGenin = new GIPIWPolGenin();
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));		
		
		gipiWPolGenin.setParId(parId);
		if("P".equals(request.getParameter("parType"))){
			int initLength = request.getParameter("initialInformation").length();
			int genLength = request.getParameter("generalInformation").length();
			gipiWPolGenin.setDspInitialInfo(request.getParameter("initialInformation"));
			gipiWPolGenin.setDspGenInfo(request.getParameter("generalInformation"));
			gipiWPolGenin.setGeninInfoCd(request.getParameter("geninInfoCd"));
			
			if (!request.getParameter("initialInformation").equals("")) {
				if ((initLength >= 1) && (initLength > 2000)) {
					gipiWPolGenin.setInitialInfo01(request.getParameter("initialInformation").substring(0, 2000));
				} else if ((initLength >= 1) && (initLength <= 2000)) {
					gipiWPolGenin.setInitialInfo01(request.getParameter("initialInformation").substring(0));
				}
				if ((initLength >= 2001) && (initLength > 4000)) {
					gipiWPolGenin.setInitialInfo02(request.getParameter("initialInformation").substring(2000, 4000));
				} else if ((initLength >= 2001) && (initLength <= 4000)) {
					gipiWPolGenin.setInitialInfo02(request.getParameter("initialInformation").substring(2000));
				}
				if ((initLength >= 4001) && (initLength > 6000)) {
					gipiWPolGenin.setInitialInfo03(request.getParameter("initialInformation").substring(4000, 6000));
				} else if ((initLength >= 4001) && (initLength <= 6000)) {
					gipiWPolGenin.setInitialInfo03(request.getParameter("initialInformation").substring(4000));
				}
				if ((initLength >= 6001) && (initLength > 8000)) {
					gipiWPolGenin.setInitialInfo04(request.getParameter("initialInformation").substring(6000, 8000));
				} else if ((initLength >= 6001) && (initLength <= 8000)) {
					gipiWPolGenin.setInitialInfo04(request.getParameter("initialInformation").substring(6000));
				}
				if ((initLength >= 8001) && (initLength > 10000)) {
					gipiWPolGenin.setInitialInfo05(request.getParameter("initialInformation").substring(8000, 10000));
				} else if ((initLength >= 8001) && (initLength <= 10000)) {
					gipiWPolGenin.setInitialInfo05(request.getParameter("initialInformation").substring(8000));
				}
				if ((initLength >= 10001) && (initLength > 12000)) {
					gipiWPolGenin.setInitialInfo06(request.getParameter("initialInformation").substring(10000, 12000));
				} else if ((initLength >= 10001) && (initLength <= 12000)) {
					gipiWPolGenin.setInitialInfo06(request.getParameter("initialInformation").substring(10000));
				}
				if ((initLength >= 12001) && (initLength > 14000)) {
					gipiWPolGenin.setInitialInfo07(request.getParameter("initialInformation").substring(12000, 14000));
				} else if ((initLength >= 12001) && (initLength <= 14000)) {
					gipiWPolGenin.setInitialInfo07(request.getParameter("initialInformation").substring(12000));
				}
				if ((initLength >= 14001) && (initLength > 16000)) {
					gipiWPolGenin.setInitialInfo08(request.getParameter("initialInformation").substring(14000, 16000));
				} else if ((initLength >= 14001) && (initLength <= 16000)) {
					gipiWPolGenin.setInitialInfo08(request.getParameter("initialInformation").substring(14000));
				}
				if ((initLength >= 16001) && (initLength > 18000)) {
					gipiWPolGenin.setInitialInfo09(request.getParameter("initialInformation").substring(16000, 18000));
				} else if ((initLength >= 16001) && (initLength <= 18000)) {
					gipiWPolGenin.setInitialInfo09(request.getParameter("initialInformation").substring(16000));
				}
				if ((initLength >= 18001) && (initLength > 20000)) {
					gipiWPolGenin.setInitialInfo10(request.getParameter("initialInformation").substring(18000, 20000));
				} else if ((initLength >= 18001) && (initLength <= 20000)) {
					gipiWPolGenin.setInitialInfo10(request.getParameter("initialInformation").substring(18000));
				}
				if ((initLength >= 20001) && (initLength > 22000)) {
					gipiWPolGenin.setInitialInfo11(request.getParameter("initialInformation").substring(20000, 22000));
				} else if ((initLength >= 20001) && (initLength <= 22000)) {
					gipiWPolGenin.setInitialInfo11(request.getParameter("initialInformation").substring(20000));
				}
				if ((initLength >= 22001) && (initLength > 24000)) {
					gipiWPolGenin.setInitialInfo12(request.getParameter("initialInformation").substring(22000, 24000));	
				} else if ((initLength >= 22001) && (initLength <= 24000)) {
					gipiWPolGenin.setInitialInfo12(request.getParameter("initialInformation").substring(22000));
				}
				if ((initLength >= 24001) && (initLength > 26000)) {
					gipiWPolGenin.setInitialInfo13(request.getParameter("initialInformation").substring(24000, 26000));
				} else if ((initLength >= 24001) && (initLength <= 26000)) {
					gipiWPolGenin.setInitialInfo13(request.getParameter("initialInformation").substring(24000));
				}
				if ((initLength >= 26001) && (initLength > 28000)) {
					gipiWPolGenin.setInitialInfo14(request.getParameter("initialInformation").substring(26000, 28000));
				} else if ((initLength >= 26001) && (initLength <= 28000)) {
					gipiWPolGenin.setInitialInfo14(request.getParameter("initialInformation").substring(26000));
				}
				if ((initLength >= 28001) && (initLength > 30000)) {
					gipiWPolGenin.setInitialInfo15(request.getParameter("initialInformation").substring(28000, 30000));
				} else if ((initLength >= 28001) && (initLength <= 30000)) {
					gipiWPolGenin.setInitialInfo15(request.getParameter("initialInformation").substring(28000));
				} 
				if ((initLength >= 30001) && (initLength > 32000)) {
					gipiWPolGenin.setInitialInfo16(request.getParameter("initialInformation").substring(30000, 32000));
				} else if ((initLength >= 30001) && (initLength <= 32000)) {
					gipiWPolGenin.setInitialInfo16(request.getParameter("initialInformation").substring(30000));
				}
				if ((initLength >= 32001) && (initLength >= 34000)) {
					gipiWPolGenin.setInitialInfo17(request.getParameter("initialInformation").substring(32000, 34000));
				} else if ((initLength >= 32001) && (initLength < 34000)) {
					gipiWPolGenin.setInitialInfo17(request.getParameter("initialInformation").substring(32000));
				}
			}
			
			if (!request.getParameter("generalInformation").equals("")) {
				if ((genLength >= 1) && (genLength > 2000)) {
					gipiWPolGenin.setGenInfo01(request.getParameter("generalInformation").substring(0, 2000));
				} else if ((genLength >= 1) && (genLength <= 2000)) {
					gipiWPolGenin.setGenInfo01(request.getParameter("generalInformation").substring(0));
				}
				if ((genLength >= 2001) && (genLength > 4000)) {
					gipiWPolGenin.setGenInfo02(request.getParameter("generalInformation").substring(2000, 4000));
				} else if ((genLength >= 2001) && (genLength <= 4000)) {
					gipiWPolGenin.setGenInfo02(request.getParameter("generalInformation").substring(2000));
				}
				if ((genLength >= 4001) && (genLength > 6000)) {
					gipiWPolGenin.setGenInfo03(request.getParameter("generalInformation").substring(4000, 6000));
				} else if ((genLength >= 4001) && (genLength <= 6000)) {
					gipiWPolGenin.setGenInfo03(request.getParameter("generalInformation").substring(4000));
				}
				if ((genLength >= 6001) && (genLength > 8000)) {
					gipiWPolGenin.setGenInfo04(request.getParameter("generalInformation").substring(6000, 8000));
				} else if ((genLength >= 6001) && (genLength <= 8000)) {
					gipiWPolGenin.setGenInfo04(request.getParameter("generalInformation").substring(6000));
				}
				if ((genLength >= 8001) && (genLength > 10000)) {
					gipiWPolGenin.setGenInfo05(request.getParameter("generalInformation").substring(8000, 10000));
				} else if ((genLength >= 8001) && (genLength <= 10000)) {
					gipiWPolGenin.setGenInfo05(request.getParameter("generalInformation").substring(8000));
				}
				if ((genLength >= 10001) && (genLength > 12000)) {
					gipiWPolGenin.setGenInfo06(request.getParameter("generalInformation").substring(10000, 12000));
				} else if ((genLength >= 10001) && (genLength <= 12000)) {
					gipiWPolGenin.setGenInfo06(request.getParameter("generalInformation").substring(10000));
				}
				if ((genLength >= 12001) && (genLength > 14000)) {
					gipiWPolGenin.setGenInfo07(request.getParameter("generalInformation").substring(12000, 14000));	
				} else if ((genLength >= 12001) && (genLength <= 14000)) {
					gipiWPolGenin.setGenInfo07(request.getParameter("generalInformation").substring(12000));
				}
				if ((genLength >= 14001) && (genLength > 16000)) {
					gipiWPolGenin.setGenInfo08(request.getParameter("generalInformation").substring(14000, 16000));
				} else if ((genLength >= 14001) && (genLength <= 16000)) {
					gipiWPolGenin.setGenInfo08(request.getParameter("generalInformation").substring(14000));
				}
				if ((genLength >= 16001) && (genLength > 18000)) {
					gipiWPolGenin.setGenInfo09(request.getParameter("generalInformation").substring(16000, 18000));
				} else if ((genLength >= 16001) && (genLength <= 18000)) {
					gipiWPolGenin.setGenInfo09(request.getParameter("generalInformation").substring(16000));
				}
				if ((genLength >= 18001) && (genLength > 20000)) {
					gipiWPolGenin.setGenInfo10(request.getParameter("generalInformation").substring(18000, 20000));
				} else if ((genLength >= 18001) && (genLength <= 20000)) {
					gipiWPolGenin.setGenInfo10(request.getParameter("generalInformation").substring(18000));
				}
				if ((genLength >= 20001) && (genLength > 22000)) {
					gipiWPolGenin.setGenInfo11(request.getParameter("generalInformation").substring(20000, 22000));
				} else if ((genLength >= 20001) && (genLength <= 22000)) {
					gipiWPolGenin.setGenInfo11(request.getParameter("generalInformation").substring(20000));
				}
				if ((genLength >= 22001) && (genLength > 24000)) {
					gipiWPolGenin.setGenInfo12(request.getParameter("generalInformation").substring(22000, 24000));
				} else if ((genLength >= 22001) && (genLength <= 24000)) {
					gipiWPolGenin.setGenInfo12(request.getParameter("generalInformation").substring(22000));
				}
				if ((genLength >= 24001) && (genLength > 26000)) {
					gipiWPolGenin.setGenInfo13(request.getParameter("generalInformation").substring(24000, 26000));
				} else if ((genLength >= 24001) && (genLength <= 26000)) {
					gipiWPolGenin.setGenInfo13(request.getParameter("generalInformation").substring(24000));
				}
				if ((genLength >= 26001) && (genLength > 28000)) {
					gipiWPolGenin.setGenInfo14(request.getParameter("generalInformation").substring(26000, 28000));
				} else if ((genLength >= 26001) && (genLength <= 28000)) {
					gipiWPolGenin.setGenInfo14(request.getParameter("generalInformation").substring(26000));
				}
				if ((genLength >= 28001) && (genLength > 30000)) {
					gipiWPolGenin.setGenInfo15(request.getParameter("generalInformation").substring(28000, 30000));
				} else if ((genLength >= 28001) && (genLength <= 30000)) {
					gipiWPolGenin.setGenInfo15(request.getParameter("generalInformation").substring(28000));
				}
				if ((genLength >= 30001) && (genLength > 32000)) {
					gipiWPolGenin.setGenInfo16(request.getParameter("generalInformation").substring(30000, 32000));
				} else if ((genLength >= 30001) && (genLength <= 32000)) {
					gipiWPolGenin.setGenInfo16(request.getParameter("generalInformation").substring(30000));
				}
				if ((genLength >= 32001) && (genLength >= 34000)) {
					gipiWPolGenin.setGenInfo17(request.getParameter("generalInformation").substring(32000, 34000));
				} else if ((genLength >= 32001) && (genLength < 34000)) {
					gipiWPolGenin.setGenInfo17(request.getParameter("generalInformation").substring(32000));
				}
			}			
		}else{
			/*gipiWPolGenin.setGenInfo(request.getParameter("generalInformation"));
			gipiWPolGenin.setGenInfo01(request.getParameter("b550GenInfo01"));
			gipiWPolGenin.setGenInfo02(request.getParameter("b550GenInfo02"));
			gipiWPolGenin.setGenInfo03(request.getParameter("b550GenInfo03"));
			gipiWPolGenin.setGenInfo04(request.getParameter("b550GenInfo04"));
			gipiWPolGenin.setGenInfo05(request.getParameter("b550GenInfo05"));
			gipiWPolGenin.setGenInfo06(request.getParameter("b550GenInfo06"));
			gipiWPolGenin.setGenInfo07(request.getParameter("b550GenInfo07"));
			gipiWPolGenin.setGenInfo08(request.getParameter("b550GenInfo08"));
			gipiWPolGenin.setGenInfo09(request.getParameter("b550GenInfo09"));
			gipiWPolGenin.setGenInfo10(request.getParameter("b550GenInfo10"));
			gipiWPolGenin.setGenInfo11(request.getParameter("b550GenInfo11"));
			gipiWPolGenin.setGenInfo12(request.getParameter("b550GenInfo12"));
			gipiWPolGenin.setGenInfo13(request.getParameter("b550GenInfo13"));
			gipiWPolGenin.setGenInfo14(request.getParameter("b550GenInfo14"));
			gipiWPolGenin.setGenInfo15(request.getParameter("b550GenInfo15"));
			gipiWPolGenin.setGenInfo16(request.getParameter("b550GenInfo16"));
			gipiWPolGenin.setGenInfo17(request.getParameter("b550GenInfo17"));	*/
			System.out.println(request.getParameter("hidObjGIPIS031"));
			JSONObject objParams = new JSONObject(request.getParameter("hidObjGIPIS031"));
			gipiWPolGenin = (GIPIWPolGenin) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("gipiWPolGenin")), USER.getUserId(), GIPIWPolGenin.class);
		}
		
		gipiWPolGenin.setUserId(USER.getUserId());
		return gipiWPolGenin;
	}
	
	private GIPIWEndtText prepareGIPIWEndtText (HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws JSONException{
		System.out.println("Preparing GIPIWEndtText ...");
		GIPIWEndtText gipiWEndtText = new GIPIWEndtText();
		//int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		
		/*gipiWEndtText.setParId(parId);
		gipiWEndtText.setEndtTax(request.getParameter("b360EndtTax"));
		gipiWEndtText.setEndtText(request.getParameter("b360EndtText"));
		gipiWEndtText.setEndtText01(request.getParameter("b360EndtText01"));
		gipiWEndtText.setEndtText02(request.getParameter("b360EndtText02"));
		gipiWEndtText.setEndtText03(request.getParameter("b360EndtText03"));
		gipiWEndtText.setEndtText04(request.getParameter("b360EndtText04"));
		gipiWEndtText.setEndtText05(request.getParameter("b360EndtText05"));
		gipiWEndtText.setEndtText06(request.getParameter("b360EndtText06"));
		gipiWEndtText.setEndtText07(request.getParameter("b360EndtText07"));
		gipiWEndtText.setEndtText08(request.getParameter("b360EndtText08"));
		gipiWEndtText.setEndtText09(request.getParameter("b360EndtText09"));
		gipiWEndtText.setEndtText10(request.getParameter("b360EndtText10"));
		gipiWEndtText.setEndtText11(request.getParameter("b360EndtText11"));
		gipiWEndtText.setEndtText12(request.getParameter("b360EndtText12"));
		gipiWEndtText.setEndtText13(request.getParameter("b360EndtText13"));
		gipiWEndtText.setEndtText14(request.getParameter("b360EndtText14"));
		gipiWEndtText.setEndtText15(request.getParameter("b360EndtText15"));
		gipiWEndtText.setEndtText16(request.getParameter("b360EndtText16"));
		gipiWEndtText.setEndtText17(request.getParameter("b360EndtText17"));		
		gipiWEndtText.setUserId(USER.getUserId());*/
		
		JSONObject objParams = new JSONObject(request.getParameter("hidObjGIPIS031"));
		gipiWEndtText = (GIPIWEndtText) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("gipiWEndtText")), USER.getUserId(), GIPIWEndtText.class);
		System.out.println("Prepared GIPIWEndtText: "+objParams.toString());
		return gipiWEndtText;
	}
	/**
	 * Prepare gipi w polbas.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param USER the uSER
	 * @return the gIPIW polbas
	 * @throws ParseException  
	 */
	private GIPIWPolbas prepareGipiWPolbas(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws ParseException {
		log.info("Preparing GipiWPolbas...");
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		
		String parType = request.getParameter("parType");		
		String invoiceSw = ("P").equals(parType) ? 
				request.getParameter("invoiceSwB540")== null | request.getParameter("invoiceSwB540") == "" ? "N" : request.getParameter("invoiceSwB540") : 
				request.getParameter("b540InvoiceSw")== null | request.getParameter("b540InvoiceSw") == "" ? "N" : request.getParameter("b540InvoiceSw");
		String polFlag =  request.getParameter(("P").equals(parType) ? "policyStatus" : "b540PolFlag");
		String designation = request.getParameter(("P").equals(parType) ? "designationB540" : "b540Designation");
		String issCd = request.getParameter(("P").equals(parType) ? 
				request.getParameter("issCdB540") == "" ? "issCd" : "issCdB540" : 
				request.getParameter("b540IssCd") == "" ? "issCd" : "b540IssCd");		
		String quotationPrintedSw = ("P").equals(parType) ? 
				request.getParameter("quotationPrinted") == null | request.getParameter("quotationPrinted") == "" ? "N" : request.getParameter("quotationPrinted") : 
					request.getParameter("b540QuotationPrintedSw") == null | request.getParameter("b540QuotationPrintedSw") == "" ? "N" : request.getParameter("b540QuotationPrintedSw");
		String covernotePrintedSw = ("P").equals(parType) ? 
				request.getParameter("covernotePrinted") == null | request.getParameter("covernotePrinted") == "" ? "N" : request.getParameter("covernotePrinted") : 
				request.getParameter("b540CovernotePrintedSw") == null | request.getParameter("b540CovernotePrintedSw") == "" ? "N" : request.getParameter("b540CovernotePrintedSw");
		String packPolFlag = ("P").equals(parType) ? 
				request.getParameter("packagePolicy") == null | request.getParameter("packagePolicy") == "" ? "N" : request.getParameter("packagePolicy") : 
				request.getParameter("b540PackPolFlag") == null | request.getParameter("b540PackPolFlag") == "" ? "N" : request.getParameter("b540PackPolFlag");
		String autoRenewFlag = ("P").equals(parType) ? 
				request.getParameter("autoRenewal") == null | request.getParameter("autoRenewal") == "" ? "N" : request.getParameter("autoRenewal") : 
				request.getParameter("b540AutoRenewFlag") == null | request.getParameter("b540AutoRenewFlag") == "" ? "N" : request.getParameter("b540AutoRenewFlag");
		String foreignAccSw = ("P").equals(parType) ? 
				request.getParameter("foreignAccount") == null | request.getParameter("foreignAccount") == "" ? "N" : request.getParameter("foreignAccount") : 
				request.getParameter("b540ForeignAccSw") == null | request.getParameter("b540ForeignAccSw") == "" ? "N" : request.getParameter("b540ForeignAccSw");
		String premWarrDays = ("P").equals(parType) ? request.getParameter("premWarrDays") : request.getParameter("b540PremWarrDays");
		String provPremTag = ("P").equals(parType) ? 
				request.getParameter("provisionalPremium") == null | request.getParameter("provisionalPremium") == "" ? "N" : request.getParameter("provisionalPremium") : 
				request.getParameter("b540ProvPremTag") == null | request.getParameter("b540ProvPremTag") == "" ? "N" : request.getParameter("b540ProvPremTag");
		String provPremPct = ("P").equals(parType) ? 
				request.getParameter("provisionalPremium") == null | request.getParameter("provisionalPremium") == "" ? "" : request.getParameter("provPremRatePercent") : 
				request.getParameter("b540ProvPremTag") == null | request.getParameter("b540ProvPremTag") == "" ? "" : request.getParameter("b540ProvPremPct");
		String compSw = ("P").equals(parType) ? 
				((request.getParameter("prorateFlag").equals("1")) ? request.getParameter("compSw") : "N") :
				request.getParameter("b540CompSw");
		String shortRtPercent = ("P").equals(parType) ? 
				((request.getParameter("prorateFlag").equals("3")) ? request.getParameter("shortRatePercent") : "") :
				request.getParameter("b540ShortRtPercent");
		String takeupTermType = ("P").equals(parType) ?  request.getParameter("takeupTermType") : request.getParameter("b540TakeupTerm");
		String samePolNoSw = ("P").equals(parType) ? request.getParameter("samePolnoSw") == null | request.getParameter("samePolnoSw") == "" ? "N" : request.getParameter("samePolnoSw") : request.getParameter("b540SamePolNoSw");
		System.out.println("Check same pol No: "+samePolNoSw);
		int issueYY = Integer.parseInt(request.getParameter(("P").equals(parType) ? "issueYy" : "b540IssueYY"));
		String endtYY = ("P").equals(parType) ? request.getParameter("endtYy") : request.getParameter("b540EndtYy");
		String endtSeqNo = ("P").equals(parType) ? request.getParameter("endtSeqNo") : request.getParameter("b540EndtSeqNo");
		String issueDate = ("P").equals(parType) ? request.getParameter("issueDate") : request.getParameter("b540IssueDate");
		String inceptDate = ("P").equals(parType) ? request.getParameter("doi") : request.getParameter("b540InceptDate");
		String expiryDate = ("P").equals(parType) ? request.getParameter("doe") : request.getParameter("b540ExpiryDate");
		String effDate = ("P").equals(parType) ? null : request.getParameter("b540EffDate");
		String endtExpDate = ("P").equals(parType) ? null : request.getParameter("b540EndtExpiryDate");		
		String surchargeSw = ("P").equals(parType) ? request.getParameter("surchargeSw")== null || request.getParameter("surchargeSw") == "" ? "N" : request.getParameter("surchargeSw") : "";
		String discountSw = ("P").equals(parType) ? request.getParameter("discountSw")== null || request.getParameter("discountSw") == "" ? "N" : request.getParameter("discountSw") : "";
				
		gipiWPolbas.setSurchargeSw(surchargeSw);
		gipiWPolbas.setDiscountSw(discountSw);
		gipiWPolbas.setParId(parId);
		gipiWPolbas.setUserId(USER.getUserId());
		gipiWPolbas.setLineCd(request.getParameter("lineCd"));
		gipiWPolbas.setInvoiceSw(invoiceSw);
		gipiWPolbas.setSublineCd(request.getParameter("sublineCd"));
		gipiWPolbas.setPolFlag(polFlag);
		gipiWPolbas.setManualRenewNo(request.getParameter("manualRenewNo") != null ? request.getParameter("manualRenewNo") : "0");
		gipiWPolbas.setTypeCd(request.getParameter("typeOfPolicy"));
		gipiWPolbas.setAddress1(request.getParameter("address1"));
		gipiWPolbas.setAddress2(request.getParameter("address2"));
		gipiWPolbas.setAddress3(request.getParameter("address3"));
		gipiWPolbas.setDesignation(designation);
		gipiWPolbas.setIssCd(issCd);
		gipiWPolbas.setCredBranch(request.getParameter("creditingBranch"));
		gipiWPolbas.setAssdNo(request.getParameter("assuredNo"));
		gipiWPolbas.setAcctOfCd(request.getParameter("acctOfCd"));
		gipiWPolbas.setPlaceCd(request.getParameter("issuePlace"));
		gipiWPolbas.setRiskTag(request.getParameter("riskTag"));
		gipiWPolbas.setRefPolNo(request.getParameter("referencePolicyNo"));
		if (("P").equals(parType)){
			if (request.getParameter("ora2010Sw").equals("Y")){
				gipiWPolbas.setCompanyCd(request.getParameter("companyCd"));
				gipiWPolbas.setEmployeeCd(request.getParameter("employeeCd"));
				gipiWPolbas.setBankRefNo(request.getParameter("bankRefNo"));
				gipiWPolbas.setBancassuranceSw(request.getParameter("bancaTag") == null ? "N" :"Y");
				if ("Y".equals(gipiWPolbas.getBancassuranceSw())){
					gipiWPolbas.setBancTypeCd(request.getParameter("selBancTypeCd"));
					gipiWPolbas.setAreaCd(request.getParameter("selAreaCd"));
					gipiWPolbas.setBranchCd(request.getParameter("selBranchCd"));
					gipiWPolbas.setManagerCd(request.getParameter("managerCd"));
				}
				gipiWPolbas.setPlanSw(request.getParameter("packPLanTag") == null ? "N" :"Y");
				if ("Y".equals(gipiWPolbas.getPlanSw())){
					gipiWPolbas.setPlanCd(request.getParameter("selPlanCd") == null ? null :Integer.parseInt(request.getParameter("selPlanCd")));
				}
			}
			if(request.getParameter("mnSublineMop").equals(request.getParameter("sublineCd"))){
				gipiWPolbas.setRefOpenPolNo(request.getParameter("referencePolicyNo"));
			}else if ("Y".equals(request.getParameter("isOpenPolicy"))){//added by steven 9/21/2012
				gipiWPolbas.setRefOpenPolNo(request.getParameter("refOpenPolicyNo"));
			}
			if (request.getParameter("lcMN").equals(request.getParameter("lineCd")) || request.getParameter("lcMN2").equals("MN")){
				gipiWPolbas.setSurveyAgentCd(request.getParameter("surveyAgentCd"));
				gipiWPolbas.setSettlingAgentCd(request.getParameter("settlingAgentCd"));
			}
		}
		gipiWPolbas.setIndustryCd(request.getParameter("industry"));
		gipiWPolbas.setRegionCd(request.getParameter("region"));
		gipiWPolbas.setQuotationPrintedSw(quotationPrintedSw);
		gipiWPolbas.setCovernotePrintedSw(covernotePrintedSw);
		gipiWPolbas.setPackPolFlag(packPolFlag);
		gipiWPolbas.setAutoRenewFlag(autoRenewFlag);
		gipiWPolbas.setForeignAccSw(foreignAccSw);
		gipiWPolbas.setRegPolicySw(((request.getParameter("regularPolicy") == null) || (request.getParameter("regularPolicy") == "") ? "N" : request.getParameter("regularPolicy")));
		gipiWPolbas.setPremWarrTag(((request.getParameter("premWarrTag") == null) || (request.getParameter("premWarrTag") == "") ? "N" : request.getParameter("premWarrTag")));
		gipiWPolbas.setPremWarrDays(premWarrDays);
		gipiWPolbas.setFleetPrintTag(((request.getParameter("fleetTag") == null) || (request.getParameter("fleetTag") == "") ? "N" : request.getParameter("fleetTag")));
		gipiWPolbas.setWithTariffSw(((request.getParameter("wTariff") == null) || (request.getParameter("wTariff") == "") ? "N" : request.getParameter("wTariff")));
		gipiWPolbas.setProvPremTag(provPremTag);
		gipiWPolbas.setProvPremPct(provPremPct);
		gipiWPolbas.setInceptTag(((request.getParameter("inceptTag") == null) || (request.getParameter("inceptTag") == "") ? "N" : request.getParameter("inceptTag")));
		gipiWPolbas.setExpiryTag(((request.getParameter("expiryTag") == null) || (request.getParameter("expiryTag") == "") ? "N" : request.getParameter("expiryTag")));
		gipiWPolbas.setEndtExpiryTag(((request.getParameter("endtExpiryTag") == null) || (request.getParameter("endtExpiryTag") == "") ? "N" : request.getParameter("endtExpiryTag")));
		gipiWPolbas.setProrateFlag(request.getParameter("prorateFlag"));
		gipiWPolbas.setCompSw(compSw);
		gipiWPolbas.setShortRtPercent(shortRtPercent);
		gipiWPolbas.setBookingYear(request.getParameter("bookingYear"));
		gipiWPolbas.setBookingMth(request.getParameter("bookingMth"));
		gipiWPolbas.setCoInsuranceSw(request.getParameter("coIns"));
		gipiWPolbas.setTakeupTerm(takeupTermType);
		gipiWPolbas.setRenewNo(request.getParameter("renewNo"));
		System.out.println("********************************************8");
		System.out.println(issueYY);
		gipiWPolbas.setIssueYy(issueYY);
		gipiWPolbas.setSamePolnoSw(samePolNoSw);
		gipiWPolbas.setEndtYy(endtYY);
		gipiWPolbas.setEndtSeqNo(endtSeqNo);
		gipiWPolbas.setUpdateIssueDate(request.getParameter("updateIssueDate"));

		gipiWPolbas.setIssueDate("E".equals(parType) ?  sdfWithTime.parse(issueDate) : sdf.parse(issueDate));
		gipiWPolbas.setInceptDate("E".equals(parType) ? sdfWithTime.parse(inceptDate) : sdf.parse(inceptDate));
		gipiWPolbas.setExpiryDate("E".equals(parType) ? sdfWithTime.parse(expiryDate) : sdf.parse(expiryDate));
		
		gipiWPolbas.setEffDate(effDate != null ? sdfWithTime.parse(effDate) : null);
		gipiWPolbas.setEndtExpiryDate(endtExpDate != null ? sdfWithTime.parse(endtExpDate) : null);
		gipiWPolbas.setLabelTag("P".equals(parType) ? (request.getParameter("labelTag") == null || request.getParameter("labelTag") == "" ? "" :request.getParameter("labelTag")) :"");
		
		if("E".equals(parType)){
			String tsiAmt = request.getParameter("b540TsiAmt").isEmpty() ? "0.00" : request.getParameter("b540TsiAmt");
			String premAmt = request.getParameter("b540PremAmt").isEmpty() ? "0.00" : request.getParameter("b540PremAmt");
			
			gipiWPolbas.setPolSeqNo(Integer.parseInt(request.getParameter("b540PolSeqNo")));
			gipiWPolbas.setEndtIssCd(request.getParameter("b540EndtIssCd"));
			gipiWPolbas.setAcctOfCdSw(request.getParameter("b540AcctOfCdSw"));
			gipiWPolbas.setOldAssdNo(Integer.parseInt(request.getParameter("b540OldAssdNo")));
			gipiWPolbas.setOldAddress1(request.getParameter("b540OldAddress1"));
			gipiWPolbas.setOldAddress2(request.getParameter("b540OldAddress2"));
			gipiWPolbas.setOldAddress3(request.getParameter("b540OldAddress3"));
			gipiWPolbas.setTsiAmt(new BigDecimal(tsiAmt));
			gipiWPolbas.setPremAmt(new BigDecimal(premAmt));
			gipiWPolbas.setAnnTsiAmt(new BigDecimal(request.getParameter("b540AnnTsiAmt")));
			gipiWPolbas.setAnnPremAmt(new BigDecimal(request.getParameter("b540AnnPremAmt")));
		}
		
		return gipiWPolbas;
	}	
	
	
	/**
	 * Prepare gipi w polbas.
	 * 
	 * @param request the request
	 * @param response the response
	 * @param USER the uSER
	 * @return the gIPIW polbas
	 * @throws ParseException  
	 */
	private GIPIWPolbas prepareEndtGipiWPolbas(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws ParseException {		
		log.info("Preparing GipiWPolbas...");
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
		@SuppressWarnings("unused")
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		
		@SuppressWarnings("unused")
		String parType = request.getParameter("parType");		
		String invoiceSw = request.getParameter("b540InvoiceSw")== null | request.getParameter("b540InvoiceSw") == "" ? "N" : request.getParameter("b540InvoiceSw");
		String polFlag =  request.getParameter("b540PolFlag");
		String designation = request.getParameter("b540Designation");
		String issCd = 	request.getParameter(request.getParameter("b540IssCd") == "" ? "issCd" : "b540IssCd");		
		String quotationPrintedSw = request.getParameter("b540QuotationPrintedSw") == null | request.getParameter("b540QuotationPrintedSw") == "" ? "N" : request.getParameter("b540QuotationPrintedSw");
		String covernotePrintedSw = request.getParameter("b540CovernotePrintedSw") == null | request.getParameter("b540CovernotePrintedSw") == "" ? "N" : request.getParameter("b540CovernotePrintedSw");
		String packPolFlag = request.getParameter("b540PackPolFlag") == null | request.getParameter("b540PackPolFlag") == "" ? "N" : request.getParameter("b540PackPolFlag");
		String autoRenewFlag = request.getParameter("b540AutoRenewFlag") == null | request.getParameter("b540AutoRenewFlag") == "" ? "N" : request.getParameter("b540AutoRenewFlag");
		String foreignAccSw = request.getParameter("b540ForeignAccSw") == null | request.getParameter("b540ForeignAccSw") == "" ? "N" : request.getParameter("b540ForeignAccSw");
		String premWarrDays = request.getParameter("b540PremWarrDays");
		String provPremTag = request.getParameter("b540ProvPremTag") == null | request.getParameter("b540ProvPremTag") == "" ? "N" : request.getParameter("b540ProvPremTag");
		String provPremPct = request.getParameter("b540ProvPremTag") == null | request.getParameter("b540ProvPremTag") == "" ? "" : request.getParameter("b540ProvPremPct");
		String compSw = request.getParameter("b540CompSw");
		String shortRtPercent = request.getParameter("b540ShortRtPercent");
		String takeupTermType = request.getParameter("b540TakeupTerm");
		String samePolNoSw = request.getParameter("b540SamePolNoSw");
		Integer issueYY = request.getParameter("b540IssueYY") == null | request.getParameter("b540IssueYY") == "" ? null : Integer.parseInt(request.getParameter("b540IssueYY"));
		String endtYY = request.getParameter("b540EndtYy");
		String endtSeqNo = request.getParameter("b540EndtSeqNo");
		String issueDate = request.getParameter("b540IssueDate");
		String inceptDate = request.getParameter("b540InceptDate");
		String expiryDate = request.getParameter("b540ExpiryDate");
		String effDate = request.getParameter("b540EffDate");
		String endtExpDate = request.getParameter("b540EndtExpiryDate");		
		//String surchargeSw = ("P").equals(parType) ? request.getParameter("surchargeSw")== null || request.getParameter("surchargeSw") == "" ? "N" : request.getParameter("surchargeSw") : "";
		//String discountSw = ("P").equals(parType) ? request.getParameter("discountSw")== null || request.getParameter("discountSw") == "" ? "N" : request.getParameter("discountSw") : "";
				
		//gipiWPolbas.setSurchargeSw(surchargeSw);
		//gipiWPolbas.setDiscountSw(discountSw);
		gipiWPolbas.setParId(parId);
		gipiWPolbas.setUserId(USER.getUserId());
		gipiWPolbas.setLineCd(request.getParameter("lineCd"));
		gipiWPolbas.setInvoiceSw(invoiceSw);
		gipiWPolbas.setSublineCd(request.getParameter("sublineCd"));
		gipiWPolbas.setPolFlag(polFlag);
		gipiWPolbas.setManualRenewNo(request.getParameter("manualRenewNo") != null ? request.getParameter("manualRenewNo") : "0");
		gipiWPolbas.setTypeCd(request.getParameter("typeOfPolicy"));
		gipiWPolbas.setAddress1(request.getParameter("address1"));
		gipiWPolbas.setAddress2(request.getParameter("address2"));
		gipiWPolbas.setAddress3(request.getParameter("address3"));
		gipiWPolbas.setDesignation(designation);
		gipiWPolbas.setIssCd(issCd);
		gipiWPolbas.setCredBranch(request.getParameter("creditingBranch"));
		gipiWPolbas.setAssdNo(request.getParameter("assuredNo"));
		gipiWPolbas.setAcctOfCd(request.getParameter("acctOfCd"));
		gipiWPolbas.setPlaceCd(request.getParameter("issuePlace"));
		gipiWPolbas.setRiskTag(request.getParameter("riskTag"));
		gipiWPolbas.setRefPolNo(request.getParameter("referencePolicyNo"));
		
		gipiWPolbas.setIndustryCd(request.getParameter("industry"));
		gipiWPolbas.setRegionCd(request.getParameter("region"));
		gipiWPolbas.setQuotationPrintedSw(quotationPrintedSw);
		gipiWPolbas.setCovernotePrintedSw(covernotePrintedSw);
		gipiWPolbas.setPackPolFlag(packPolFlag);
		gipiWPolbas.setAutoRenewFlag(autoRenewFlag);
		gipiWPolbas.setForeignAccSw(foreignAccSw);
		gipiWPolbas.setRegPolicySw(((request.getParameter("regularPolicy") == null) || (request.getParameter("regularPolicy") == "") ? "N" : request.getParameter("regularPolicy")));
		gipiWPolbas.setPremWarrTag(((request.getParameter("premWarrTag") == null) || (request.getParameter("premWarrTag") == "") ? "N" : request.getParameter("premWarrTag")));
		gipiWPolbas.setPremWarrDays(premWarrDays);
		gipiWPolbas.setFleetPrintTag(((request.getParameter("fleetTag") == null) || (request.getParameter("fleetTag") == "") ? "N" : request.getParameter("fleetTag")));
		gipiWPolbas.setWithTariffSw(((request.getParameter("wTariff") == null) || (request.getParameter("wTariff") == "") ? "N" : request.getParameter("wTariff")));
		gipiWPolbas.setProvPremTag(provPremTag);
		gipiWPolbas.setProvPremPct(provPremPct);
		gipiWPolbas.setInceptTag(((request.getParameter("inceptTag") == null) || (request.getParameter("inceptTag") == "") ? "N" : request.getParameter("inceptTag")));
		gipiWPolbas.setExpiryTag(((request.getParameter("expiryTag") == null) || (request.getParameter("expiryTag") == "") ? "N" : request.getParameter("expiryTag")));
		gipiWPolbas.setEndtExpiryTag(((request.getParameter("endtExpiryTag") == null) || (request.getParameter("endtExpiryTag") == "") ? "N" : request.getParameter("endtExpiryTag")));
		gipiWPolbas.setProrateFlag(request.getParameter("prorateFlag"));
		gipiWPolbas.setCompSw(compSw);
		gipiWPolbas.setShortRtPercent(shortRtPercent);
		gipiWPolbas.setBookingYear(request.getParameter("bookingYear"));
		gipiWPolbas.setBookingMth(request.getParameter("bookingMth"));
		gipiWPolbas.setCoInsuranceSw(request.getParameter("coIns"));
		gipiWPolbas.setTakeupTerm(takeupTermType);
		gipiWPolbas.setRenewNo(request.getParameter("renewNo"));
		gipiWPolbas.setIssueYy(issueYY);
		gipiWPolbas.setSamePolnoSw(samePolNoSw);
		gipiWPolbas.setEndtYy(endtYY);
		gipiWPolbas.setEndtSeqNo(endtSeqNo);
		gipiWPolbas.setUpdateIssueDate(request.getParameter("updateIssueDate"));

		gipiWPolbas.setIssueDate(sdfWithTime.parse(issueDate));
		gipiWPolbas.setInceptDate(sdfWithTime.parse(inceptDate));
		gipiWPolbas.setExpiryDate(sdfWithTime.parse(expiryDate));
		System.out.println("ISSUE DATE : " + gipiWPolbas.getIssueDate());
		System.out.println("INCEPT DATE : " + gipiWPolbas.getInceptDate());
		System.out.println("EXPIRY DATE : " + gipiWPolbas.getExpiryDate());
		gipiWPolbas.setEffDate(effDate == null || "".equals(effDate) ? null :sdfWithTime.parse(effDate));
		gipiWPolbas.setEndtExpiryDate(endtExpDate != null ? sdfWithTime.parse(endtExpDate) : null);
		
		String tsiAmt = request.getParameter("b540TsiAmt").isEmpty() ? "0.00" : request.getParameter("b540TsiAmt");
		String premAmt = request.getParameter("b540PremAmt").isEmpty() ? "0.00" : request.getParameter("b540PremAmt");
		
		gipiWPolbas.setPolSeqNo(Integer.parseInt(request.getParameter("b540PolSeqNo")));
		gipiWPolbas.setEndtIssCd(request.getParameter("b540EndtIssCd"));
		gipiWPolbas.setAcctOfCdSw(request.getParameter("b540AcctOfCdSw"));
		gipiWPolbas.setOldAssdNo(Integer.parseInt(request.getParameter("b540OldAssdNo")));
		gipiWPolbas.setOldAddress1(request.getParameter("b540OldAddress1"));
		gipiWPolbas.setOldAddress2(request.getParameter("b540OldAddress2"));
		gipiWPolbas.setOldAddress3(request.getParameter("b540OldAddress3"));
		gipiWPolbas.setTsiAmt(new BigDecimal(tsiAmt));
		gipiWPolbas.setPremAmt(new BigDecimal(premAmt));
		gipiWPolbas.setAnnTsiAmt(new BigDecimal(request.getParameter("b540AnnTsiAmt")));
		gipiWPolbas.setAnnPremAmt(new BigDecimal(request.getParameter("b540AnnPremAmt")));
		
		return gipiWPolbas;
	}
	
	private GIPIPARList prepareGIPIParList(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws ParseException{
		GIPIPARList gipiParList = new GIPIPARList();
		System.out.println("prepareGIPIParList: "+request.getParameter("b240ParId"));
		gipiParList.setParId(Integer.parseInt(request.getParameter("b240ParId")));
		gipiParList.setParType(request.getParameter("b240ParType"));
		gipiParList.setParStatus(Integer.parseInt(request.getParameter("b240ParStatus")));
		gipiParList.setLineCd(request.getParameter("b240LineCd"));
		gipiParList.setIssCd(request.getParameter("b240IssCd"));
		gipiParList.setParYy(Integer.parseInt(request.getParameter("b240ParYy")));
		gipiParList.setParSeqNo(Integer.parseInt(request.getParameter("b240ParSeqNo")));
		gipiParList.setQuoteSeqNo(Integer.parseInt(request.getParameter("b240QuoteSeqNo")));
		gipiParList.setAssdNo(Integer.parseInt(request.getParameter("assuredNo")));
		gipiParList.setAddress1(request.getParameter("b240Address1"));
		gipiParList.setAddress2(request.getParameter("b240Address2"));
		gipiParList.setAddress3(request.getParameter("b240Address3"));
		gipiParList.setUserId(USER.getUserId());
		return gipiParList;
	}
	
	// andrew - 09.16.2010 - added for saving of policy renewal/replacement details
	private Map<String, Object> prepareGIPIWPolnrepMap(HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> gipiWPolnrepMap = new HashMap<String, Object>();
		String[] delOldPolicyIds 	= request.getParameterValues("delOldPolicyId");
		String[] insOldPolicyIds 	= request.getParameterValues("oldPolicyId");// replaced param value to get the correct policy and disregard deleted policy by CarloR 08.10.2016 SR 5283
		
		gipiWPolnrepMap.put("insOldPolicyIds", insOldPolicyIds);
		gipiWPolnrepMap.put("delOldPolicyIds", delOldPolicyIds);
		//gipiWPolnrepMap.put("parId", Integer.parseInt((request.getParameter("globalParId") == null) ? "0" : request.getParameter("globalParId")));
		//gipiWPolnrepMap.put("polFlag", request.getParameter("polFlag") == null ? "" : request.getParameter("polFlag"));
		//gipiWPolnrepMap.put("userId", USER.getUserId());
		
		return gipiWPolnrepMap;
	}
	
	// andrew - 09.17.2010 - added for saving of policy deductibles details
	private Map<String, Object> prepareGIPIWDeductibleMap(HttpServletRequest request, HttpServletResponse response, GIISUser USER) {
		Map<String, Object> insParams = new HashMap<String, Object>();		
		
		String[] insItemNos 		 = request.getParameterValues("insDedItemNo1");
		String[] insPerilCds 		 = request.getParameterValues("insDedPerilCd1");
		String[] insDeductibleCds 	 = request.getParameterValues("insDedDeductibleCd1");
		String[] insDeductibleAmts   = request.getParameterValues("insDedAmount1");
		String[] insDeductibleRts 	 = request.getParameterValues("insDedRate1");
		String[] insDeductibleTexts  = request.getParameterValues("insDedText1");
		String[] insAggregateSws 	 = request.getParameterValues("insDedAggregateSw1");
		String[] insCeilingSws 	 	 = request.getParameterValues("insDedCeilingSw1");
		
		insParams.put("itemNos", insItemNos);
		insParams.put("perilCds", insPerilCds);
		insParams.put("deductibleCds", insDeductibleCds);
		insParams.put("deductibleAmounts", insDeductibleAmts);
		insParams.put("deductibleRates", insDeductibleRts);
		insParams.put("deductibleTexts", insDeductibleTexts);
		insParams.put("aggregateSws", insAggregateSws);
		insParams.put("ceilingSws", insCeilingSws);
		insParams.put("userId", USER.getUserId());
		
		Map<String, Object> delParams = new HashMap<String, Object>();
		String[] delItemNos 		 = request.getParameterValues("delDedItemNo1");
		String[] delPerilCds 		 = request.getParameterValues("delDedPerilCd1");
		String[] delDeductibleCds 	 = request.getParameterValues("delDedDeductibleCd1");

		delParams.put("itemNos", delItemNos);
		delParams.put("perilCds", delPerilCds);
		delParams.put("deductibleCds", delDeductibleCds);	
		
		Map<String, Object> deductibleParams = new HashMap<String, Object>();
		deductibleParams.put("insParams", insParams);
		deductibleParams.put("delParams", delParams);
		
		return deductibleParams;
	}
	
	private GIPIPARList prepareGIPIParList(JSONObject obj, GIISUser USER) throws ParseException, JSONException{
		GIPIPARList par = new GIPIPARList();
		
		par.setParId(obj.isNull("b240ParId") ? null : obj.getInt("b240ParId"));
		par.setParType(obj.isNull("b240ParType") ? null : obj.getString("b240ParType"));
		par.setParStatus(obj.isNull("b240ParStatus") ? null : obj.getInt("b240ParStatus"));
		par.setLineCd(obj.isNull("b240LineCd") ? null : obj.getString("b240LineCd"));
		par.setIssCd(obj.isNull("b240IssCd") ? null : obj.getString("b240IssCd"));
		par.setParYy(obj.isNull("b240ParYy") ? null : obj.getInt("b240ParYy"));
		par.setParSeqNo(obj.isNull("b240ParSeqNo") ? null : obj.getInt("b240ParSeqNo"));
		par.setQuoteSeqNo(obj.isNull("b240QuoteSeqNo") ? null : obj.getInt("b240QuoteSeqNo"));
		par.setAssdNo(obj.isNull("assuredNo") ? null : obj.getInt("assuredNo"));
		par.setAddress1(obj.isNull("b240Address1") ? null : obj.getString("b240Address1"));
		par.setAddress2(obj.isNull("b240Address2") ? null : obj.getString("b240Address2"));
		par.setAddress3(obj.isNull("b240Address3") ? null : obj.getString("b240Address3"));
		par.setUserId(USER.getUserId());

		return par;
	}
	
	private GIPIWPolbas prepareEndtGipiWPolbas(JSONObject obj, Integer parId, GIISUser USER) throws ParseException, JSONException {		
		log.info("Preparing GipiWPolbas...");
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		
		String parType = obj.getString("parType");	
		String invoiceSw = obj.isNull("b540InvoiceSw") ? "N" : (obj.getString("b540InvoiceSw").equals("") ? "N" : obj.getString("b540InvoiceSw"));
		String polFlag = obj.getString("b540PolFlag");
		String designation = obj.getString("b540Designation");
		String issCd = (obj.isNull("b540IssCd") | obj.getString("b540IssCd").equals("")) ? obj.getString("issCd") : obj.getString("b540IssCd");
		
		String quotationPrintedSw = obj.isNull("b540QuotationPrintedSw") | obj.getString("b540QuotationPrintedSw").equals("") ? "N" : obj.getString("b540QuotationPrintedSw");
		String covernotePrintedSw = obj.isNull("b540CovernotePrintedSw") | obj.getString("b540CovernotePrintedSw").equals("") ? "N" : obj.getString("b540CovernotePrintedSw");
		String packPolFlag = obj.isNull("b540PackPolFlag") | obj.getString("b540PackPolFlag").equals("") ? "N" : obj.getString("b540PackPolFlag");
		String autoRenewFlag = obj.isNull("b540AutoRenewFlag") | obj.getString("b540AutoRenewFlag").equals("") ? "N" : obj.getString("b540AutoRenewFlag");
		String foreignAccSw = obj.isNull("b540ForeignAccSw") | obj.getString("b540ForeignAccSw").equals("") ? "N" : obj.getString("b540ForeignAccSw");
		String premWarrDays = obj.getString("b540PremWarrDays");
		String provPremTag = obj.isNull("b540ProvPremTag") | obj.getString("b540ProvPremTag").equals("") ? "N" : obj.getString("b540ProvPremTag");
		String provPremPct = obj.isNull("b540ProvPremTag") | obj.getString("b540ProvPremTag").equals("") ? "N" : obj.getString("b540ProvPremPct");
		
		String compSw = obj.getString("b540CompSw");
		String shortRtPercent = obj.getString("b540ShortRtPercent");
		String takeupTermType = obj.getString("b540TakeupTerm");
		String samePolNoSw = obj.getString("b540SamePolNoSw");
		Integer issueYY = obj.isNull("b540IssueYY") ? null : (obj.getString("b540IssueYY").equals("") ? null : obj.getInt("b540IssueYY"));
		String endtYY = obj.getString("b540EndtYy");
		String endtSeqNo = obj.getString("b540EndtSeqNo");
		String issueDate = obj.getString("b540IssueDate");
		String inceptDate = obj.getString("b540InceptDate");
		String expiryDate = obj.getString("b540ExpiryDate");
		String effDate = obj.getString("b540EffDate");
		String endtExpDate = obj.getString("b540EndtExpiryDate");
		
		//gipiWPolbas.setSurchargeSw(surchargeSw);
		//gipiWPolbas.setDiscountSw(discountSw);
		gipiWPolbas.setParId(parId);
		gipiWPolbas.setUserId(USER.getUserId());
		gipiWPolbas.setLineCd(obj.getString("lineCd"));
		gipiWPolbas.setInvoiceSw(invoiceSw);
		gipiWPolbas.setSublineCd(obj.isNull("sublineCd") ? obj.getString("b540SublineCd") : obj.getString("sublineCd"));
		gipiWPolbas.setPolFlag(polFlag);
		gipiWPolbas.setManualRenewNo(obj.isNull("manualRenewNo") ? obj.getString("manualRenewNo") : "0");
		gipiWPolbas.setTypeCd(obj.isNull("typeOfPolicy") ? null : obj.getString("typeOfPolicy"));
		gipiWPolbas.setAddress1(obj.isNull("address1") ? null : obj.getString("address1"));
		gipiWPolbas.setAddress2(obj.isNull("address2") ? null : obj.getString("address2"));
		gipiWPolbas.setAddress3(obj.isNull("address3") ? null : obj.getString("address3"));
		gipiWPolbas.setDesignation(designation);
		gipiWPolbas.setIssCd(issCd);
		gipiWPolbas.setCredBranch(obj.isNull("creditingBranch") ? null : obj.getString("creditingBranch"));
		gipiWPolbas.setAssdNo(obj.getString("assuredNo"));
		gipiWPolbas.setAcctOfCd(obj.getString("acctOfCd"));
		gipiWPolbas.setPlaceCd(obj.getString("issuePlace"));
		gipiWPolbas.setRiskTag(obj.getString("riskTag"));
		gipiWPolbas.setRefPolNo(obj.getString("referencePolicyNo"));
		
		gipiWPolbas.setIndustryCd(obj.getString("industry"));
		gipiWPolbas.setRegionCd(obj.getString("region"));
		gipiWPolbas.setQuotationPrintedSw(quotationPrintedSw);
		gipiWPolbas.setCovernotePrintedSw(covernotePrintedSw);
		gipiWPolbas.setPackPolFlag(packPolFlag);
		gipiWPolbas.setAutoRenewFlag(autoRenewFlag);
		gipiWPolbas.setForeignAccSw(foreignAccSw);
		gipiWPolbas.setRegPolicySw(((obj.isNull("regularPolicy") || (obj.getString("regularPolicy").equals("")) ? "N" : obj.getString("regularPolicy"))));
		gipiWPolbas.setPremWarrTag((obj.isNull("premWarrTag") || obj.getString("premWarrTag").equals("")) ? "N" : obj.getString("premWarrTag"));
		gipiWPolbas.setPremWarrDays(premWarrDays);
		gipiWPolbas.setFleetPrintTag(((obj.isNull("fleetTag")) || (obj.getString("fleetTag").equals("")) ? "N" : obj.getString("fleetTag")));
		gipiWPolbas.setWithTariffSw(((obj.isNull("wTariff") || obj.getString("wTariff").equals("")) ? "N" : obj.getString("wTariff")));
		gipiWPolbas.setProvPremTag(provPremTag);
		gipiWPolbas.setProvPremPct(provPremPct);
		gipiWPolbas.setInceptTag((obj.isNull("inceptTag") || obj.getString("inceptTag").equals("")) ? "N" : obj.getString("inceptTag"));
		gipiWPolbas.setExpiryTag((obj.isNull("expiryTag") || obj.getString("expiryTag").equals("")) ? "N" : obj.getString("expiryTag"));
		//gipiWPolbas.setEndtExpiryTag((obj.isNull("endtExpiryTag") || obj.getString("endtExpiryTag").equals("")) ? "N" : obj.getString("endtExpiryTag"));
		gipiWPolbas.setEndtExpiryTag((obj.isNull("endtExpDateTag") || obj.getString("endtExpDateTag").equals("")) ? "N" : obj.getString("endtExpDateTag"));
		gipiWPolbas.setProrateFlag(obj.getString("prorateFlag"));
		gipiWPolbas.setCompSw(compSw);
		gipiWPolbas.setShortRtPercent(shortRtPercent);
		gipiWPolbas.setBookingYear(obj.getString("bookingYear"));
		gipiWPolbas.setBookingMth(obj.getString("bookingMth"));
		gipiWPolbas.setCoInsuranceSw(obj.getString("coIns"));
		gipiWPolbas.setTakeupTerm(takeupTermType);
		gipiWPolbas.setRenewNo(obj.getString("renewNo"));
		gipiWPolbas.setIssueYy(issueYY);
		gipiWPolbas.setSamePolnoSw(samePolNoSw);
		gipiWPolbas.setEndtYy(endtYY);
		gipiWPolbas.setEndtSeqNo(endtSeqNo);
		gipiWPolbas.setUpdateIssueDate(obj.getString("updateIssueDate"));

		gipiWPolbas.setIssueDate(sdfWithTime.parse(issueDate));
		gipiWPolbas.setInceptDate(sdfWithTime.parse(inceptDate));
		gipiWPolbas.setExpiryDate(sdfWithTime.parse(expiryDate));
			
		gipiWPolbas.setEffDate(effDate == null || "".equals(effDate) ? null :sdfWithTime.parse(effDate));
		gipiWPolbas.setEndtExpiryDate(endtExpDate != null ? sdfWithTime.parse(endtExpDate) : null);
		
		String tsiAmt = obj.isNull("b540TsiAmt") ? "0.00" : (obj.getString("b540TsiAmt").equals("") ? "0.00" : obj.getString("b540TsiAmt"));
		String premAmt = obj.isNull("b540PremAmt") ? "0.00" : (obj.getString("b540PremAmt").equals("") ? "0.00" : obj.getString("b540PremAmt"));
		
		gipiWPolbas.setPolSeqNo(obj.isNull("b540PolSeqNo") ? 0 : obj.getInt("b540PolSeqNo"));
		gipiWPolbas.setEndtIssCd(obj.getString("b540EndtIssCd"));
		gipiWPolbas.setAcctOfCdSw(obj.getString("b540AcctOfCdSw"));
		gipiWPolbas.setOldAssdNo(obj.isNull("b540OldAssdNo") ? null : obj.getInt("b540OldAssdNo"));
		gipiWPolbas.setOldAddress1(obj.getString("b540OldAddress1"));
		gipiWPolbas.setOldAddress2(obj.getString("b540OldAddress2"));
		gipiWPolbas.setOldAddress3(obj.getString("b540OldAddress3"));
		gipiWPolbas.setTsiAmt(new BigDecimal(tsiAmt));
		gipiWPolbas.setPremAmt(new BigDecimal(premAmt));
		gipiWPolbas.setAnnTsiAmt(new BigDecimal(obj.getString("b540AnnTsiAmt")));
		gipiWPolbas.setAnnPremAmt(new BigDecimal(obj.getString("b540AnnPremAmt")));
		
		return gipiWPolbas;
	}
	
	private GIPIWPolGenin prepareGipiWPolGenin(JSONObject obj, HttpServletRequest request, GIISUser USER) throws JSONException{
		GIPIWPolGenin gipiWPolGenin = new GIPIWPolGenin();
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));		
		log.info("Preparing GipiWPolGenin..."+parId);
		gipiWPolGenin.setParId(parId);
		if("P".equals(obj.getString("parType"))){
			int initLength = obj.getString("initialInformation").length();
			int genLength = obj.getString("generalInformation").length();
			gipiWPolGenin.setDspInitialInfo(obj.getString("initialInformation"));
			gipiWPolGenin.setDspGenInfo(obj.getString("generalInformation"));
			gipiWPolGenin.setGeninInfoCd(obj.getString("geninInfoCd"));
			
			if (!obj.getString("initialInformation").equals("")) {
				if ((initLength >= 1) && (initLength > 2000)) {
					gipiWPolGenin.setInitialInfo01(obj.getString("initialInformation").substring(0, 2000));
				} else if ((initLength >= 1) && (initLength <= 2000)) {
					gipiWPolGenin.setInitialInfo01(obj.getString("initialInformation").substring(0));
				}
				if ((initLength >= 2001) && (initLength > 4000)) {
					gipiWPolGenin.setInitialInfo02(obj.getString("initialInformation").substring(2000, 4000));
				} else if ((initLength >= 2001) && (initLength <= 4000)) {
					gipiWPolGenin.setInitialInfo02(obj.getString("initialInformation").substring(2000));
				}
				if ((initLength >= 4001) && (initLength > 6000)) {
					gipiWPolGenin.setInitialInfo03(obj.getString("initialInformation").substring(4000, 6000));
				} else if ((initLength >= 4001) && (initLength <= 6000)) {
					gipiWPolGenin.setInitialInfo03(obj.getString("initialInformation").substring(4000));
				}
				if ((initLength >= 6001) && (initLength > 8000)) {
					gipiWPolGenin.setInitialInfo04(obj.getString("initialInformation").substring(6000, 8000));
				} else if ((initLength >= 6001) && (initLength <= 8000)) {
					gipiWPolGenin.setInitialInfo04(obj.getString("initialInformation").substring(6000));
				}
				if ((initLength >= 8001) && (initLength > 10000)) {
					gipiWPolGenin.setInitialInfo05(obj.getString("initialInformation").substring(8000, 10000));
				} else if ((initLength >= 8001) && (initLength <= 10000)) {
					gipiWPolGenin.setInitialInfo05(obj.getString("initialInformation").substring(8000));
				}
				if ((initLength >= 10001) && (initLength > 12000)) {
					gipiWPolGenin.setInitialInfo06(obj.getString("initialInformation").substring(10000, 12000));
				} else if ((initLength >= 10001) && (initLength <= 12000)) {
					gipiWPolGenin.setInitialInfo06(obj.getString("initialInformation").substring(10000));
				}
				if ((initLength >= 12001) && (initLength > 14000)) {
					gipiWPolGenin.setInitialInfo07(obj.getString("initialInformation").substring(12000, 14000));
				} else if ((initLength >= 12001) && (initLength <= 14000)) {
					gipiWPolGenin.setInitialInfo07(obj.getString("initialInformation").substring(12000));
				}
				if ((initLength >= 14001) && (initLength > 16000)) {
					gipiWPolGenin.setInitialInfo08(obj.getString("initialInformation").substring(14000, 16000));
				} else if ((initLength >= 14001) && (initLength <= 16000)) {
					gipiWPolGenin.setInitialInfo08(obj.getString("initialInformation").substring(14000));
				}
				if ((initLength >= 16001) && (initLength > 18000)) {
					gipiWPolGenin.setInitialInfo09(obj.getString("initialInformation").substring(16000, 18000));
				} else if ((initLength >= 16001) && (initLength <= 18000)) {
					gipiWPolGenin.setInitialInfo09(obj.getString("initialInformation").substring(16000));
				}
				if ((initLength >= 18001) && (initLength > 20000)) {
					gipiWPolGenin.setInitialInfo10(obj.getString("initialInformation").substring(18000, 20000));
				} else if ((initLength >= 18001) && (initLength <= 20000)) {
					gipiWPolGenin.setInitialInfo10(obj.getString("initialInformation").substring(18000));
				}
				if ((initLength >= 20001) && (initLength > 22000)) {
					gipiWPolGenin.setInitialInfo11(obj.getString("initialInformation").substring(20000, 22000));
				} else if ((initLength >= 20001) && (initLength <= 22000)) {
					gipiWPolGenin.setInitialInfo11(obj.getString("initialInformation").substring(20000));
				}
				if ((initLength >= 22001) && (initLength > 24000)) {
					gipiWPolGenin.setInitialInfo12(obj.getString("initialInformation").substring(22000, 24000));	
				} else if ((initLength >= 22001) && (initLength <= 24000)) {
					gipiWPolGenin.setInitialInfo12(obj.getString("initialInformation").substring(22000));
				}
				if ((initLength >= 24001) && (initLength > 26000)) {
					gipiWPolGenin.setInitialInfo13(obj.getString("initialInformation").substring(24000, 26000));
				} else if ((initLength >= 24001) && (initLength <= 26000)) {
					gipiWPolGenin.setInitialInfo13(obj.getString("initialInformation").substring(24000));
				}
				if ((initLength >= 26001) && (initLength > 28000)) {
					gipiWPolGenin.setInitialInfo14(obj.getString("initialInformation").substring(26000, 28000));
				} else if ((initLength >= 26001) && (initLength <= 28000)) {
					gipiWPolGenin.setInitialInfo14(obj.getString("initialInformation").substring(26000));
				}
				if ((initLength >= 28001) && (initLength > 30000)) {
					gipiWPolGenin.setInitialInfo15(obj.getString("initialInformation").substring(28000, 30000));
				} else if ((initLength >= 28001) && (initLength <= 30000)) {
					gipiWPolGenin.setInitialInfo15(obj.getString("initialInformation").substring(28000));
				} 
				if ((initLength >= 30001) && (initLength > 32000)) {
					gipiWPolGenin.setInitialInfo16(obj.getString("initialInformation").substring(30000, 32000));
				} else if ((initLength >= 30001) && (initLength <= 32000)) {
					gipiWPolGenin.setInitialInfo16(obj.getString("initialInformation").substring(30000));
				}
				if ((initLength >= 32001) && (initLength >= 34000)) {
					gipiWPolGenin.setInitialInfo17(obj.getString("initialInformation").substring(32000, 34000));
				} else if ((initLength >= 32001) && (initLength < 34000)) {
					gipiWPolGenin.setInitialInfo17(obj.getString("initialInformation").substring(32000));
				}
			}
			
			if (!obj.getString("generalInformation").equals("")) {
				if ((genLength >= 1) && (genLength > 2000)) {
					gipiWPolGenin.setGenInfo01(obj.getString("generalInformation").substring(0, 2000));
				} else if ((genLength >= 1) && (genLength <= 2000)) {
					gipiWPolGenin.setGenInfo01(obj.getString("generalInformation").substring(0));
				}
				if ((genLength >= 2001) && (genLength > 4000)) {
					gipiWPolGenin.setGenInfo02(obj.getString("generalInformation").substring(2000, 4000));
				} else if ((genLength >= 2001) && (genLength <= 4000)) {
					gipiWPolGenin.setGenInfo02(obj.getString("generalInformation").substring(2000));
				}
				if ((genLength >= 4001) && (genLength > 6000)) {
					gipiWPolGenin.setGenInfo03(obj.getString("generalInformation").substring(4000, 6000));
				} else if ((genLength >= 4001) && (genLength <= 6000)) {
					gipiWPolGenin.setGenInfo03(obj.getString("generalInformation").substring(4000));
				}
				if ((genLength >= 6001) && (genLength > 8000)) {
					gipiWPolGenin.setGenInfo04(obj.getString("generalInformation").substring(6000, 8000));
				} else if ((genLength >= 6001) && (genLength <= 8000)) {
					gipiWPolGenin.setGenInfo04(obj.getString("generalInformation").substring(6000));
				}
				if ((genLength >= 8001) && (genLength > 10000)) {
					gipiWPolGenin.setGenInfo05(obj.getString("generalInformation").substring(8000, 10000));
				} else if ((genLength >= 8001) && (genLength <= 10000)) {
					gipiWPolGenin.setGenInfo05(obj.getString("generalInformation").substring(8000));
				}
				if ((genLength >= 10001) && (genLength > 12000)) {
					gipiWPolGenin.setGenInfo06(obj.getString("generalInformation").substring(10000, 12000));
				} else if ((genLength >= 10001) && (genLength <= 12000)) {
					gipiWPolGenin.setGenInfo06(obj.getString("generalInformation").substring(10000));
				}
				if ((genLength >= 12001) && (genLength > 14000)) {
					gipiWPolGenin.setGenInfo07(obj.getString("generalInformation").substring(12000, 14000));	
				} else if ((genLength >= 12001) && (genLength <= 14000)) {
					gipiWPolGenin.setGenInfo07(obj.getString("generalInformation").substring(12000));
				}
				if ((genLength >= 14001) && (genLength > 16000)) {
					gipiWPolGenin.setGenInfo08(obj.getString("generalInformation").substring(14000, 16000));
				} else if ((genLength >= 14001) && (genLength <= 16000)) {
					gipiWPolGenin.setGenInfo08(obj.getString("generalInformation").substring(14000));
				}
				if ((genLength >= 16001) && (genLength > 18000)) {
					gipiWPolGenin.setGenInfo09(obj.getString("generalInformation").substring(16000, 18000));
				} else if ((genLength >= 16001) && (genLength <= 18000)) {
					gipiWPolGenin.setGenInfo09(obj.getString("generalInformation").substring(16000));
				}
				if ((genLength >= 18001) && (genLength > 20000)) {
					gipiWPolGenin.setGenInfo10(obj.getString("generalInformation").substring(18000, 20000));
				} else if ((genLength >= 18001) && (genLength <= 20000)) {
					gipiWPolGenin.setGenInfo10(obj.getString("generalInformation").substring(18000));
				}
				if ((genLength >= 20001) && (genLength > 22000)) {
					gipiWPolGenin.setGenInfo11(obj.getString("generalInformation").substring(20000, 22000));
				} else if ((genLength >= 20001) && (genLength <= 22000)) {
					gipiWPolGenin.setGenInfo11(obj.getString("generalInformation").substring(20000));
				}
				if ((genLength >= 22001) && (genLength > 24000)) {
					gipiWPolGenin.setGenInfo12(obj.getString("generalInformation").substring(22000, 24000));
				} else if ((genLength >= 22001) && (genLength <= 24000)) {
					gipiWPolGenin.setGenInfo12(obj.getString("generalInformation").substring(22000));
				}
				if ((genLength >= 24001) && (genLength > 26000)) {
					gipiWPolGenin.setGenInfo13(obj.getString("generalInformation").substring(24000, 26000));
				} else if ((genLength >= 24001) && (genLength <= 26000)) {
					gipiWPolGenin.setGenInfo13(obj.getString("generalInformation").substring(24000));
				}
				if ((genLength >= 26001) && (genLength > 28000)) {
					gipiWPolGenin.setGenInfo14(obj.getString("generalInformation").substring(26000, 28000));
				} else if ((genLength >= 26001) && (genLength <= 28000)) {
					gipiWPolGenin.setGenInfo14(obj.getString("generalInformation").substring(26000));
				}
				if ((genLength >= 28001) && (genLength > 30000)) {
					gipiWPolGenin.setGenInfo15(obj.getString("generalInformation").substring(28000, 30000));
				} else if ((genLength >= 28001) && (genLength <= 30000)) {
					gipiWPolGenin.setGenInfo15(obj.getString("generalInformation").substring(28000));
				}
				if ((genLength >= 30001) && (genLength > 32000)) {
					gipiWPolGenin.setGenInfo16(obj.getString("generalInformation").substring(30000, 32000));
				} else if ((genLength >= 30001) && (genLength <= 32000)) {
					gipiWPolGenin.setGenInfo16(obj.getString("generalInformation").substring(30000));
				}
				if ((genLength >= 32001) && (genLength >= 34000)) {
					gipiWPolGenin.setGenInfo17(obj.getString("generalInformation").substring(32000, 34000));
				} else if ((genLength >= 32001) && (genLength < 34000)) {
					gipiWPolGenin.setGenInfo17(obj.getString("generalInformation").substring(32000));
				}
			}			
		}else{
			System.out.println(request.getParameter("hidObjGIPIS031"));
			JSONObject objParams = new JSONObject(request.getParameter("hidObjGIPIS031"));
			gipiWPolGenin = (GIPIWPolGenin) JSONUtil.prepareObjectFromJSON(new JSONObject(objParams.getString("gipiWPolGenin")), USER.getUserId(), GIPIWPolGenin.class);
		}
		
		gipiWPolGenin.setUserId(USER.getUserId());
		return gipiWPolGenin;
	}
}

