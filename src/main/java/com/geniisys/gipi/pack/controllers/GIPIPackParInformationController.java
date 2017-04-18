package com.geniisys.gipi.pack.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISBancArea;
import com.geniisys.common.entity.GIISBancBranch;
import com.geniisys.common.entity.GIISBancType;
import com.geniisys.common.entity.GIISPayees;
import com.geniisys.common.entity.GIISPlan;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACOrderOfPaymentService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.geniisys.gipi.pack.entity.GIPIPackPARList;
import com.geniisys.gipi.pack.entity.GIPIPackWEndtText;
import com.geniisys.gipi.pack.entity.GIPIPackWPolBas;
import com.geniisys.gipi.pack.entity.GIPIPackWPolGenin;
import com.geniisys.gipi.pack.entity.GIPIWPackLineSubline;
import com.geniisys.gipi.pack.service.GIPIPackPARListService;
import com.geniisys.gipi.pack.service.GIPIPackWPolBasService;
import com.geniisys.gipi.pack.service.GIPIPackWPolGeninService;
import com.geniisys.gipi.pack.service.GIPIPackWPolnrepService;
import com.geniisys.gipi.pack.service.GIPIWPackLineSublineService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIPackParInformationController extends BaseController {

	private static final long serialVersionUID = -7023435761282820313L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIPackParInformationController.class);

	@SuppressWarnings("unchecked")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			log.info("Initializing: " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIPackWPolBasService gipiPackWPolBasService = (GIPIPackWPolBasService) APPLICATION_CONTEXT.getBean("gipiPackWPolBasService");
			
			PAGE = "/pages/genericMessage.jsp";
		
			if("showPackParBasicInfo".equals(ACTION)){
				request.setAttribute("confirmResult", request.getParameter("confirmResult"));
				request.setAttribute("newAssdNo", request.getParameter("globalAssdNo"));
				GIPIPackWPolBas gipiPackWPolBas = null;
				GIPIPackPARList gipiPackParList = null;
				GIPIPackWPolGenin gipiPackWPolGenin = null;
				
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIPIPackPARListService gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
				GIPIPackWPolGeninService gipiPackWPolGeninService = (GIPIPackWPolGeninService) APPLICATION_CONTEXT.getBean("gipiPackWPolGeninService");
				GIPIPackWPolnrepService gipiPackWPolnrepService = (GIPIPackWPolnrepService) APPLICATION_CONTEXT.getBean("gipiPackWPolnrepService");
				
				Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? request.getParameter("parId") : request.getParameter("packParId"));
				//Integer packParId = Integer.parseInt(request.getParameter("packParId"));
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				System.out.println("Line Cd: " + lineCd + " Issue Code: " + issCd + " Pack Par ID: " + packParId);
				
				String[] args = {lineCd};
				String[] args2 = {issCd};
				String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
				String msgAlert = "";
				
				gipiPackParList = gipiPackParService.getGIPIPackParDetails(packParId);
				request.setAttribute("gipiParList", gipiPackParList);
				StringFormatter.replaceQuotesInObject(gipiPackParList);
				request.setAttribute("jsonGIPIPARList", new JSONObject(gipiPackParList));
				
				String lcEn = giisParametersService.getParamValueV2("LINE_CODE_EN");
				request.setAttribute("issCdRi", giisParametersService.getParamValueV2("ISS_CD_RI"));
				request.setAttribute("mnSublineMop", giisParametersService.getParamValueV2("MN_SUBLINE_MOP"));
				request.setAttribute("lcMN", giisParametersService.getParamValueV2("LINE_CODE_MN"));		
				request.setAttribute("reqSurveySettAgent", giisParametersService.getParamValueV2("REQ_SURVEY_SETT_AGENT"));
				String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
				request.setAttribute("ora2010Sw", ora2010Sw);
				String incrRepl = giisParametersService.getParamValueV2("INCREMENT_REPLACEMENT");
				request.setAttribute("incrRepl", incrRepl);
				request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.10.2012
				
				loadListingToRequest(request, lovHelper, args, args2,
						domainRisk, lineCd, lcEn, "P");
				
				// added by: nica 09.07.2011 to display branch source with cred_branch_tag = "Y" only
				String[] issArgs = {"Y"};
				List<LOV> branchSourceList = lovHelper.getList(LOVHelper.ISSUE_SOURCE_BY_CRED_BR_TAG, issArgs);
				request.setAttribute("branchSourceListing", branchSourceList);
				
				List<LOV> branchSourceList2 = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
				request.setAttribute("branchSourceListing2", branchSourceList2);
				
				if ("Y".equals(ora2010Sw)){
					request.setAttribute("companyListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.COMPANY_LISTING))));
					request.setAttribute("employeeListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.EMPLOYEE_LISTING))));
					request.setAttribute("bancTypeCdListingJSON", new JSONArray((List<GIISBancType>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_TYPE_CD_LISTING))));
					request.setAttribute("bancAreaCdListingJSON", new JSONArray((List<GIISBancArea>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_AREA_CD_LISTING))));
					request.setAttribute("bancBranchCdListingJSON", new JSONArray((List<GIISBancBranch>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_BRANCH_CD_LISTING))));
					request.setAttribute("planCdListingJSON", new JSONArray((List<GIISPlan>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PLAN_CD_LISTING, args))));
				}
				
				String bookingAdv = giisParametersService.getParamValueV2("ALLOW_BOOKING_IN_ADVANCE");
				request.setAttribute("bookingAdv", bookingAdv);
				if ("Y".equals(bookingAdv)){
					List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING3);
					request.setAttribute("bookingMonthListing", bookingMonths);
				}
				
				Map<String, Object> existingTables = new HashMap<String, Object>();
				existingTables = gipiPackWPolBasService.checkPackParExistingTables(packParId);
				String isExistGipiWItem = (String) existingTables.get("gipiWItemExist");
				String isExistWItmPerl = (String) existingTables.get("gipiWItmPerlExist");
				String isExistWinvoice = (String) existingTables.get("gipiWInvoiceExist");
				String isExistWinvTax = (String) existingTables.get("gipiWInvTaxExist");
				
				request.setAttribute("isExistGipiWItem", isExistGipiWItem);
				request.setAttribute("isExistGipiWItmperl", isExistWItmPerl);
				request.setAttribute("isExistGipiWInvoice", isExistWinvoice);
				request.setAttribute("isExistGipiWinvTax", isExistWinvTax);
				
				Map gipiPackWPolnrepMap = new HashMap();
				gipiPackWPolnrepMap = gipiPackWPolnrepService.isGipiPackWPolnrepExist(packParId);
				String isGipiPackWPolnrepExist = (String) gipiPackWPolnrepMap.get("exist");
				request.setAttribute("isExistGipiWPolnrep", isGipiPackWPolnrepExist);
				
				Map gipiPackWpolbasMap = new HashMap();
				gipiPackWpolbasMap = gipiPackWPolBasService.isPackWPolbasExist(packParId);
				String isPackWPolbasExist = (String) gipiPackWpolbasMap.get("exist");
				request.setAttribute("isExistGipiWPolbas", isPackWPolbasExist);
				
				if(isPackWPolbasExist.equals("1")){
					log.info("Getting gipi_pack_wpolbas details for packParId: " + packParId);
					gipiPackWPolBas = gipiPackWPolBasService.getGIPIPackWPolBas(packParId);
					request.setAttribute("gipiWPolbas", gipiPackWPolBas);
				}else{
					log.info("Getting default value for gipi_pack_wpolbas...");
					gipiPackWPolBas = gipiPackWPolBasService.getGipiPackWPolbasDefaultValues(packParId);
					request.setAttribute("gipiWPolbas", gipiPackWPolBas);
				}
				System.out.println("gipiWPolbas IssCd: " + gipiPackWPolBas.getIssCd() + " CredBranch: " + gipiPackWPolBas.getCredBranch());
				gipiPackWPolGenin = gipiPackWPolGeninService.getGipiPackWPolGenin(packParId);
				//request.setAttribute("gipiWPolGenin", StringFormatter.escapeHTMLInList(gipiPackWPolGenin));
				request.setAttribute("gipiWPolGenin", gipiPackWPolGenin == null ? gipiPackWPolGenin : StringFormatter.escapeHTMLInObject(gipiPackWPolGenin)); // robert 06.18.2012 
				
				request.setAttribute("isPack", "Y");
				
				Map parsNewFormInst = new HashMap();
				parsNewFormInst = gipiPackWPolBasService.newFormInst(lineCd, issCd);
				String typeCdStatus = (String) parsNewFormInst.get("typeCdStatus");
				String updCredBranch = (String) parsNewFormInst.get("updCredBranch");
				msgAlert =	(String) parsNewFormInst.get("msgAlert");
				String reqCredBranch = (String) parsNewFormInst.get("reqCredBranch");
				String updIssueDate = (String) parsNewFormInst.get("updIssueDate");
				String reqRefPolNo = (String) parsNewFormInst.get("reqRefPolNo");
				String defCredBranch = (String) parsNewFormInst.get("defCredBranch");
				String varVdate = (String) parsNewFormInst.get("varVdate");
				request.setAttribute("typeCdStatus", typeCdStatus);
				request.setAttribute("updCredBranch", updCredBranch);
				request.setAttribute("reqCredBranch", reqCredBranch);
				request.setAttribute("updIssueDate", updIssueDate);
				request.setAttribute("reqRefPolNo", reqRefPolNo);
				request.setAttribute("defCredBranch", defCredBranch);
				request.setAttribute("varVdate", varVdate);
				request.setAttribute("reqRefNo", giisParametersService.getParamValueV2("REQUIRE_REF_NO")); //added by gab 11.15.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
				request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
				
				// bonok :: 1.5.2017 :: UCPB SR 23641
				request.setAttribute("newAssdNo", request.getParameter("globalAssdNo"));
				request.setAttribute("confirmResult", request.getParameter("confirmResult"));
				request.setAttribute("newAssdName", request.getParameter("globalAssdName"));
				request.setAttribute("newAddress1", request.getParameter("globalAddress1"));
				request.setAttribute("newAddress2", request.getParameter("globalAddress2"));
				request.setAttribute("newAddress3", request.getParameter("globalAddress3"));
				
				request = this.setPackParInfo(request, gipiPackParList);
				
				if (msgAlert != null){
					message = msgAlert;
				} else {
					message = "SUCCESS";
				}
				PAGE = "/pages/underwriting/packPar/packBasicInfo/packBasicInformationMain.jsp"; 
			} else if("showEndtPackParBasicInfo".equals(ACTION)){
				// services
				GIISParameterFacadeService giisParameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				// temporary service, while DAO for CGRefCodes pkg is not yet created
				GIACOrderOfPaymentService giacOrderOfPaymentService = (GIACOrderOfPaymentService) APPLICATION_CONTEXT.getBean("giacOrderOfPaymentService");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				// entities
				GIPIPackPARList gipiPackParList = null;
				GIPIPackWPolBas gipiPackWPolBas = null;
				GIPIPackWPolGenin gipiPackWPolGenin = null;
				GIPIPackWEndtText gipiPackWEndtText = null;
				GIPIWOpenPolicy gipiWOpenPolicy = null;
				
				// pack par id, policy no
				String reqParId = request.getParameter("packParId") == null ? request.getParameter("parId") : request.getParameter("packParId");
				String policyNo = new String("");
				
				// variables
				Integer packParId = Integer.parseInt(reqParId);
				String lineCd = (request.getParameter("lineCd") == null? "":request.getParameter("lineCd"));
				String issCd = (request.getParameter("issCd") == null? "":request.getParameter("issCd"));
				
				// others
				Map<String, Object> getAcctOfCdParamMap = new HashMap<String, Object>();
				
				log.info("Pack Par Id: " + packParId);
				log.info("Line Cd: " + lineCd);
				log.info("Iss Cd: " + issCd);
				
				request.setAttribute("parType", "E"); //temp, habang may error sa parType global attribute
				
				/* default is "N" */
				request.setAttribute("reqCredBranch", "N");
				//request.setAttribute("reqRefPolNo", "N");
				request.setAttribute("reqRefPolNo", giisParametersService.getParamValueV2("REQUIRE_REF_POL_NO")); //added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				request.setAttribute("reqRefNo", giisParametersService.getParamValueV2("REQUIRE_REF_NO")); //added by gab 11.17.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.10.2012
				request.setAttribute("updIssueDate", giisParametersService.getParamValueV2("UPDATE_ISSUE_DATE")); // added by: Nica 05.14.2012
				request.setAttribute("varVdate", giacParamService.getParamValueN("PROD_TAKE_UP"));
				request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
				request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
				request.setAttribute("reqCredBranch", giisParametersService.getParamValueV2("MANDATORY_CRED_BRANCH")); // added by apollo 07.24.2015 SR#2749
				
				log.info("Paramater fromPolicyNo: " + request.getParameter("fromPolicyNo"));
				if("Y".equals(request.getParameter("fromPolicyNo"))){
					Map<String, Object> searchForPolicyParams = new HashMap<String, Object>();
					System.out.println("1: " + searchForPolicyParams.get("gipiPackWPolbas"));
					searchForPolicyParams = loadPolicyNoToMap(request);
					System.out.println("2: " + searchForPolicyParams.get("gipiPackWPolbas"));
					searchForPolicyParams.put("parId", packParId);
					searchForPolicyParams.put("paramModalFlag", null);
					
					log.info("par id: " + searchForPolicyParams.get("parId") + ", " + searchForPolicyParams.get("parId").getClass());
					log.info("line cd: " + searchForPolicyParams.get("lineCd") + ", " + searchForPolicyParams.get("lineCd").getClass());
					log.info("subline cd: " + searchForPolicyParams.get("sublineCd") + ", " + searchForPolicyParams.get("sublineCd").getClass());
					log.info("iss cd: " + searchForPolicyParams.get("issCd") + ", " + searchForPolicyParams.get("issCd").getClass());
					log.info("issue yy: " + searchForPolicyParams.get("issueYy") + ", " + searchForPolicyParams.get("issueYy").getClass());
					log.info("pol seq no: " + searchForPolicyParams.get("polSeqNo") + ", " + searchForPolicyParams.get("polSeqNo").getClass());
					log.info("renew no: " + searchForPolicyParams.get("renewNo") + ", " + searchForPolicyParams.get("renewNo").getClass());
					
					System.out.println("3: " + searchForPolicyParams.get("gipiPackWPolbas"));
					gipiPackWPolBasService.searchForPolicy(searchForPolicyParams);
					System.out.println("4: " + searchForPolicyParams.get("gipiPackWPolbas"));
					
					log.info("From Policy No:");
					log.info("Par Id: " + searchForPolicyParams.get("parId"));
					log.info("Msg ALert: " + searchForPolicyParams.get("msgAlert"));
					 // jmm SR-22834
					request.setAttribute("newAssdNo", request.getParameter("globalAssdNo"));
					request.setAttribute("confirmResult", request.getParameter("confirmResult"));
					request.setAttribute("newAssdName", request.getParameter("globalAssdName"));
					request.setAttribute("newAddress1", request.getParameter("globalAddress1"));
					request.setAttribute("newAddress2", request.getParameter("globalAddress2"));
					request.setAttribute("newAddress3", request.getParameter("globalAddress3"));
					//request.setAttribute("globalRiCd", request.getParameter("globalRiCd"));
					//end
					if (null != searchForPolicyParams.get("msgAlert")) {
						message = searchForPolicyParams.get("msgAlert") != null ? searchForPolicyParams.get("msgAlert").toString() : "";
						request.setAttribute("message", message);
						PAGE = "/pages/genericMessage.jsp";
					} else {
						LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
						GIISAssuredFacadeService giisAssuredService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");
						
						for (GIPIPackPARList packParList : (List<GIPIPackPARList>) searchForPolicyParams.get("gipiPackParlist")) {
							gipiPackParList = packParList;
						}
						
						for (GIPIPackWPolBas packWPolBas : (List<GIPIPackWPolBas>) searchForPolicyParams.get("gipiPackWPolbas")) {
							gipiPackWPolBas = packWPolBas;
						}
						
						for (GIPIPackWEndtText packWEndtText : (List<GIPIPackWEndtText>) searchForPolicyParams.get("gipiPackWEndtText")) {
							gipiPackWEndtText = packWEndtText;
						}
						
						for (GIPIPackWPolGenin packWPolGenin : (List<GIPIPackWPolGenin>) searchForPolicyParams.get("gipiPackWPolGenin")) {
							gipiPackWPolGenin = packWPolGenin;
						}
						
						searchForPolicyParams.remove("gipiPackParlist");
						searchForPolicyParams.remove("gipiPackWPolbas");
						searchForPolicyParams.remove("gipiPackWEndtText");
						searchForPolicyParams.remove("gipiPackWPolGenin");
						
						loadNewFormInstanceVariablesToRequest(request, searchForPolicyParams);
						
						Map<String, Object> newFormInstanceParams = new HashMap<String, Object>();
						newFormInstanceParams.put("parId", packParId);
						newFormInstanceParams.put("b240LineCd", (gipiPackParList == null) ? null : gipiPackParList.getLineCd());
						newFormInstanceParams.put("b540SublineCd", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getSublineCd());
						newFormInstanceParams.put("b540IssCd", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getIssCd());
						newFormInstanceParams.put("b540IssueYy", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getIssueYy());
						newFormInstanceParams.put("b540PolSeqNo", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getPolSeqNo());
						newFormInstanceParams.put("b540RenewNo", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getRenewNo());
						
						gipiPackWPolBasService.executeGipis031ANewFormInstance(newFormInstanceParams);
						
						//added by: Nica 11.10.2011
						Map gipiPackWpolbasMap = new HashMap();
						gipiPackWpolbasMap = gipiPackWPolBasService.isPackWPolbasExist(packParId);
						String isPackWPolbasExist = (String) gipiPackWpolbasMap.get("exist");
						request.setAttribute("isExistGipiWPolbas", isPackWPolbasExist);
						
						if (newFormInstanceParams.get("message") != null) {
							message = searchForPolicyParams.get("msgAlert") != null ? searchForPolicyParams.get("msgAlert").toString() : "";
							request.setAttribute("message", message);
							PAGE = "/pages/genericMessage.jsp";
						} else {
							loadNewFormInstanceVariablesToRequest(request, newFormInstanceParams);
							
							String[] args = {lineCd};
							String[] args2 = {issCd};
							String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
							String lcEn = newFormInstanceParams.get("varLcEn") != null ? newFormInstanceParams.get("varLcEn").toString() : "";
							
							loadListingToRequest(request, lovHelper, args, args2, domainRisk, lineCd, lcEn, "E");
							
							GIISAssured giisAssured = giisAssuredService.getGIISAssuredByAssdNo(gipiPackParList.getAssdNo().toString());
							//String regionCd = newFormInstanceParams.get("regionCd") != null ? newFormInstanceParams.get("regionCd").toString() : ""; //commented out by reymon 04192013
							
							gipiPackWPolBas.setDspAssdName(giisAssured.getAssdName());
							if (gipiPackWPolBas.getAcctOfCd() != null){
								GIISAssured giisAssured2 = giisAssuredService.getGIISAssuredByAssdNo(gipiPackWPolBas.getAcctOfCd().toString());//added by reymon 04192013
								gipiPackWPolBas.setAcctOfName(giisAssured2.getAssdName());////added by reymon 04192013
							}
							//gipiPackWPolBas.setRegionCd(regionCd); //commented out by reymon 04192013
							if(gipiPackWPolBas.getCredBranch() != null){
								// you cannot compare null to another null. it always result to false
							}else{
								gipiPackWPolBas.setCredBranch("HO");
							}
							
							request.setAttribute("gipiParList", gipiPackParList);
							request.setAttribute("gipiWPolbas", StringFormatter.escapeHTMLInObject(gipiPackWPolBas)); // escapeHTMLInObject added by: Nica 12.14.2012
							request.setAttribute("gipiWEndtText", StringFormatter.escapeHTMLInObject(gipiPackWEndtText));
							request.setAttribute("gipiWPolGenin", StringFormatter.escapeHTMLInObject(gipiPackWPolGenin));
							// set Policy No
							policyNo = gipiPackWPolBas.getLineCd() + "-" + gipiPackWPolBas.getSublineCd() + "-" + gipiPackWPolBas.getIssCd()
										+ "-" + gipiPackWPolBas.getIssueYy() + "-" + String.format("%07d", gipiPackWPolBas.getPolSeqNo()) + "-" + String.format("%02d", gipiPackWPolBas.getRenewNo());
							request.setAttribute("policyNo", policyNo);
							
							request.setAttribute("isPack", "Y");
							
							request = GIPIPARUtil.setPackPARInfoFromSavedPAR(request, gipiPackParList);
							PAGE = "/pages/underwriting/endt/basicInfo/packEndtBasicInformationMain.jsp";
						}
					}
				} else {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					Map<String, Object> newFormInstanceParams = new HashMap<String, Object>();
					Map<String, Object> params = new HashMap<String, Object>();
					GIISAssuredFacadeService giisAssuredService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService");//added by reymon 04192013
					
					params.put("parId", packParId);
					gipiPackWPolBasService.getEndtPackBasicInfoRecs(params);
					
					for (GIPIPackPARList packParList : (List<GIPIPackPARList>) params.get("gipiPackParlist")) {
						gipiPackParList = packParList;
					}
					
					for (GIPIPackWPolBas packWPolBas : (List<GIPIPackWPolBas>) params.get("gipiPackWPolbas")) {
						gipiPackWPolBas = packWPolBas;						
					}
					
					for (GIPIPackWEndtText packWEndtText : (List<GIPIPackWEndtText>) params.get("gipiPackWEndtText")) {
						gipiPackWEndtText = packWEndtText;
					}
					
					for (GIPIPackWPolGenin packWPolGenin : (List<GIPIPackWPolGenin>) params.get("gipiPackWPolGenin")) {
						gipiPackWPolGenin = packWPolGenin;
					}
					
					for (GIPIWOpenPolicy wOpenPolicy : (List<GIPIWOpenPolicy>) params.get("gipiWOpenPolicy")) {
						gipiWOpenPolicy = wOpenPolicy;
					}
					
					newFormInstanceParams.put("parId", packParId);
					newFormInstanceParams.put("b240LineCd", (gipiPackParList == null) ? null : gipiPackParList.getLineCd());
					newFormInstanceParams.put("b540SublineCd", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getSublineCd());
					newFormInstanceParams.put("b540IssCd", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getIssCd());
					newFormInstanceParams.put("b540IssueYy", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getIssueYy());
					newFormInstanceParams.put("b540PolSeqNo", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getPolSeqNo());
					newFormInstanceParams.put("b540RenewNo", (gipiPackWPolBas == null) ? null : gipiPackWPolBas.getRenewNo());
					
					gipiPackWPolBasService.executeGipis031ANewFormInstance(newFormInstanceParams);
					
					if (newFormInstanceParams.get("message") != null) {
						throw new SQLException();
					} else {
						loadNewFormInstanceVariablesToRequest(request, newFormInstanceParams);
					}
					
					String[] args = {lineCd};
					String[] args2 = {issCd};
					String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
					String lcEn = newFormInstanceParams.get("varLcEn") != null ? newFormInstanceParams.get("varLcEn").toString() : "";
					
					loadListingToRequest(request, lovHelper, args, args2,
							domainRisk, lineCd, lcEn, "E");
					
					if (gipiPackWPolBas.getAcctOfCd() != null){
						GIISAssured giisAssured = giisAssuredService.getGIISAssuredByAssdNo(gipiPackWPolBas.getAcctOfCd().toString());//added by reymon 04192013
						gipiPackWPolBas.setAcctOfName(giisAssured.getAssdName());////added by reymon 04192013
					}
					
					request.setAttribute("gipiParList", gipiPackParList);
					request.setAttribute("gipiWPolbas", StringFormatter.escapeHTMLInObject(gipiPackWPolBas)); // escapeHTMLInObject added by: Nica 12.14.2012
					request.setAttribute("gipiWEndtText", StringFormatter.escapeHTMLInObject(gipiPackWEndtText));
					request.setAttribute("gipiWPolGenin", StringFormatter.escapeHTMLInObject(gipiPackWPolGenin));
					request.setAttribute("gipiWOpenPolicy", gipiWOpenPolicy);
					request.setAttribute("isExistGipiWPolbas", (gipiPackWPolBas == null) ? "0" : "1");
					request.setAttribute("issCdRi", giisParameterService.getParamValueV("ISS_CD_RI"));
					
					// set policy no
					if (gipiPackWPolBas != null) {
						policyNo = gipiPackWPolBas.getLineCd() + " - " + gipiPackWPolBas.getSublineCd() + " - " + gipiPackWPolBas.getIssCd()
									+ "-" + gipiPackWPolBas.getIssueYy() + " - " + String.format("%07d",gipiPackWPolBas.getPolSeqNo()) + " - " + String.format("%02d",gipiPackWPolBas.getRenewNo());
					}
					request.setAttribute("policyNo", policyNo);
					
					request.setAttribute("isPack", "Y");
				}
				
				// set the values first, since page is reused only
				// POST-QUERY triggers and other functionalities
				
				// GIPI_PACK_PARLIST
				if (gipiPackParList != null) {
					gipiPackParList.setParId(gipiPackParList.getPackParId());
				}
				
				// GIPI_PACK_WPOLBAS
				if (gipiPackWPolBas != null) {
					gipiPackWPolBas.setParId(gipiPackWPolBas.getPackParId());
					
					/*//commented out by reymon 04192013
					if (gipiPackWPolBas.getRiskTag() != null) {
						gipiPackWPolBas.setRiskTag(giacOrderOfPaymentService.getRVMeaning("GIPI_POLBASIC.RISK_TAG", gipiPackWPolBas.getRiskTag()));
					}
					*/
					
					if (gipiPackWPolBas.getAddress1() == null && gipiPackWPolBas.getAddress2() == null 
							&& gipiPackWPolBas.getAddress3() == null && gipiPackParList != null) {
						gipiPackWPolBas.setAddress1(gipiPackParList.getAddress1());
						gipiPackWPolBas.setAddress2(gipiPackParList.getAddress2());
						gipiPackWPolBas.setAddress3(gipiPackParList.getAddress3());
					}
					
					getAcctOfCdParamMap.put("lineCd", gipiPackWPolBas.getLineCd());
					getAcctOfCdParamMap.put("sublineCd", gipiPackWPolBas.getSublineCd());
					getAcctOfCdParamMap.put("issCd", gipiPackWPolBas.getIssCd());
					getAcctOfCdParamMap.put("issueYy", gipiPackWPolBas.getIssueYy());
					getAcctOfCdParamMap.put("polSeqNo", gipiPackWPolBas.getPolSeqNo());
					getAcctOfCdParamMap.put("renewNo", gipiPackWPolBas.getRenewNo());
					getAcctOfCdParamMap.put("b540EffDate", gipiPackWPolBas.getEffDate());
					getAcctOfCdParamMap.put("b540AcctOfCd", gipiPackWPolBas.getAcctOfCd());
					getAcctOfCdParamMap.put("b540LabelTag", gipiPackWPolBas.getLabelTag());
					getAcctOfCdParamMap.put("paramModalFlag", null);
					
					//gipiPackWPolBasService.executeGipis031AGetAcctOfCd(getAcctOfCdParamMap); //commented out by reymon 04192013
					
					//gipiPackWPolBas.setAcctOfCd((String)getAcctOfCdParamMap.get("b540AcctOfCd")); //commented out by reymon 04192013
					//gipiPackWPolBas.setLabelTag((String)getAcctOfCdParamMap.get("b540LabelTag")); //commented out by reymon 04192013
					
					request.setAttribute("globalSublineCd", gipiPackWPolBas.getSublineCd());
					request.setAttribute("globalParId", gipiPackWPolBas.getPackParId());
				}
				
				message = "SUCCESS";
				PAGE = "/pages/underwriting/endt/basicInfo/packEndtBasicInformationMain.jsp";
			} else if("showPackPolicyNo".equals(ACTION)){
				Integer packParId = request.getParameter("packParId") != null ? Integer.parseInt(request.getParameter("packParId")) : (request.getParameter("parId") == null ? 0 : Integer.parseInt(request.getParameter("parId")));
				String lineCd = request.getParameter("lineCd");
				String issCd = request.getParameter("issCd");
				System.out.println("Line Cd: " + lineCd + " Issue Code: " + issCd);
				
				String sublineCd = request.getParameter("sublineCd");
				String polSeqNo = request.getParameter("polSeqNo");
				String issYy = request.getParameter("issueYy");
				String renewNo = request.getParameter("renewNo");
				request.setAttribute("parId", packParId);
				request.setAttribute("lineCdPol", lineCd);
				request.setAttribute("issCd", issCd);
				request.setAttribute("sublineCdPol", sublineCd);
				request.setAttribute("polSeqNo", polSeqNo);
				request.setAttribute("issueYy", issYy);
				request.setAttribute("renewNo", renewNo);
				request.setAttribute("isPack", "Y"); // tag to check if endt par is pack
				System.out.println("attrib: " + lineCd + "+" + issCd + "+" + sublineCd);
				
				//andrew 09.08.2011 - delete line/subline records by packParId
				GIPIWPackLineSublineService gipiwPackLineSublineService = (GIPIWPackLineSublineService) APPLICATION_CONTEXT.getBean("gipiwPackLineSublineService");
				gipiwPackLineSublineService.delGIPIWPackLineSublineByPackParId(packParId);
				
				PAGE = "/pages/underwriting/endt/basicInfo/subPages/policyNoForEndt.jsp";					
			} else if("checkPolicyNoForPackEndt".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				
				params = loadPolicyNoToMap(request);
				
				//message = generateResponse(gipiPackWPolBasService.checkPolicyNoForPackEndt(params));
				//params = null;
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiPackWPolBasService.checkPolicyNoForPackEndt(params))).toString();
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveEndtPackBasicInfo".equals(ACTION)) {
				log.info("Saving Endt Pack Basic Information...");
				Integer packParId = 0; //Integer.parseInt(request.getParameter("packParId"));
				String lineCd = request.getParameter("lineCd");
				
				GIPIParMortgageeFacadeService gipiWMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				GIPIPARListService gipiParlistService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");
				
				JSONObject param = new JSONObject(request.getParameter("parameters"));
				
				Map<String, Object> params = new HashMap<String, Object>();
				Map<String, Object> resultMap = new HashMap<String, Object>();
				
				// endt basic info
				GIPIPackPARList gipiPackParList = new GIPIPackPARList();
				GIPIPackWPolBas gipiPackWPolbas = new GIPIPackWPolBas();
				GIPIPackWPolGenin gipiPackWPolGenin = new GIPIPackWPolGenin();
				GIPIPackWEndtText gipiPackWEndtText = new GIPIPackWEndtText();
				List<GIPIPARList> parList = new ArrayList<GIPIPARList>();
				
				// deductibles
				String[] insDedItemNos = request.getParameterValues("insDedItemNo1");
				String[] delDedItemNos = request.getParameterValues("delDedItemNo1");
				
				gipiPackParList = prepareGIPIPackParList(request, response, USER);
				gipiPackWPolbas = prepareGIPIPackWPolbas(request, response, USER);
				gipiPackWPolGenin = prepareGIPIPackWPolGenin(request, response, USER);
				gipiPackWEndtText = prepareGIPIPackWEndtText(request, response, USER);
				
				Map<String, Object> vars = new HashMap<String, Object>();
				Map<String, Object> pars = new HashMap<String, Object>();
				Map<String, Object> others = new HashMap<String, Object>();
				
				packParId = gipiPackWPolbas.getParId();
				
				parList = gipiParlistService.getParListGIPIS031A(packParId);
				
				String element = "";
				for(Enumeration<String> e = request.getParameterNames(); e.hasMoreElements();){
					element = (String)e.nextElement();
					if("var".equals(element.substring(0, 3))){
						vars.put(element, request.getParameter(element));							
					}else if("par".equals(element.substring(0, 3))){
						pars.put(element, request.getParameter(element));							
					}else{
						others.put(element, request.getParameter(element));
					}
					//System.out.println(element + "=" + request.getParameter(element));						
				}
				params.put("renewExist", request.getParameter("renewExist"));   //nante
				params.put("gipiPackParList", gipiPackParList);
				params.put("gipiPackWPolbas", gipiPackWPolbas);
				params.put("gipiPackWPolGenin", gipiPackWPolGenin);
				params.put("gipiPackWEndtText", gipiPackWEndtText);			
				params.put("gipiParList", parList);
				params.put("vars", vars);
				params.put("pars", pars);
				params.put("others", others);
				params.put("mortgageeInsList", gipiWMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(param.getString("setMortgagees"))));
				params.put("mortgageeDelList", gipiWMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(param.getString("delMortgagees"))));
				params.put("packLineSublines", JSONUtil.prepareObjectListFromJSON(new JSONArray(param.getString("packLineSublines")), USER.getUserId(), GIPIWPackLineSubline.class)); // added by andrew - 09.15.2011
				
				if(insDedItemNos != null){
					Map<String, Object> insDeductMap = new HashMap<String, Object>();
					String[] perilCds 		 = request.getParameterValues("insDedPerilCd1");
					String[] deductibleCds 	 = request.getParameterValues("insDedDeductibleCd1");
					String[] deductibleAmts  = request.getParameterValues("insDedAmount1");
					String[] deductibleRts 	 = request.getParameterValues("insDedRate1");
					String[] deductibleTexts = request.getParameterValues("insDedText1");
					String[] aggregateSws 	 = request.getParameterValues("insDedAggregateSw1");
					String[] ceilingSws 	 = request.getParameterValues("insDedCeilingSw1");
					
					insDeductMap.put("parId", packParId);
					insDeductMap.put("userId", USER.getUserId());
					insDeductMap.put("dedLineCd", lineCd);
					insDeductMap.put("dedSublineCd", gipiPackWPolbas.getSublineCd());
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
					
					delDeductMap.put("parId", packParId);
					delDeductMap.put("delDedItemNos", delDedItemNos);
					delDeductMap.put("delDedPerilCds", perilCds);
					delDeductMap.put("delDedDedCds", deductibleCds);
					
					params.put("delDeductibles", delDeductMap);
					
					delDeductMap = null;
				}
				
				resultMap = gipiPackWPolBasService.saveEndtBasicInfo(params);
				
				message = (String) resultMap.get("message");
				
				params = null;
				resultMap = null;
				
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("savePackPARBasicInfo".equals(ACTION)){
				GIPIParMortgageeFacadeService gipiWMortgageeService = (GIPIParMortgageeFacadeService) APPLICATION_CONTEXT.getBean("gipiParMortgageeFacadeService");
				
				log.info("Saving Basic Information for Package PAR...");
				GIPIPackWPolBas gipiPackWPolBas = new GIPIPackWPolBas();
				GIPIPackWPolGenin gipiPackWPolGenin = new GIPIPackWPolGenin();
				
				gipiPackWPolBas = prepareGIPIPackWPolbas(request, response, USER);
				gipiPackWPolGenin = prepareGIPIPackWPolGenin(request, response, USER);
				Map<String, Object> gipiPackWPolnrepMap = prepareGIPIPackWPolnrepMap(request, response);
				
				JSONObject param = new JSONObject(request.getParameter("parameters"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gipiPackWPolbas", gipiPackWPolBas);
				params.put("gipiPackWPolGenin", gipiPackWPolGenin);
				params.put("gipiPackWPolnrepMap", gipiPackWPolnrepMap);
				params.put("deleteWPolnrep", request.getParameter("deleteWPolnrep"));
				params.put("deleteCoIns", request.getParameter("deleteCoIns"));
				params.put("deleteBillSw", request.getParameter("deleteBillSw"));
				params.put("deleteAllTables", request.getParameter("deleteAllTables"));
				params.put("validatedIssuePlace", request.getParameter("validatedIssuePlace"));
				params.put("deleteSw", request.getParameter("deleteSw"));
				params.put("deleteSwForAssdNo", request.getParameter("deleteSwForAssdNo"));
				params.put("mortgageeInsList", gipiWMortgageeService.prepareGIPIWMortgageeForInsert(new JSONArray(param.getString("setMortgagees"))));
				params.put("mortgageeDelList", gipiWMortgageeService.prepareGIPIWMortgageeForDelete(new JSONArray(param.getString("delMortgagees"))));
				
				Map<String, Object> paramsResult = new HashMap<String, Object>();
				paramsResult = gipiPackWPolBasService.savePackPARBasicInfo(params);
				message = (new JSONObject(StringFormatter.replaceQuotesInMap(paramsResult))).toString();
				
				PAGE = "/pages/genericMessage.jsp";
			}else if("generateBankRefNo".equals(ACTION)){
				log.info("Generating Bank Reference No...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("packParId", request.getParameter("parId").equals("") ? null :Integer.parseInt(request.getParameter("parId")));
				params.put("acctIssCd", (request.getParameter("nbtAcctIssCd") == null ? "" :request.getParameter("nbtAcctIssCd")));
				params.put("branchCd", (request.getParameter("nbtBranchCd") == null ? "" :request.getParameter("nbtBranchCd")));
				params = gipiPackWPolBasService.generateBankRefNoForPack(params); 
					
				request.setAttribute("object", new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(params)));
				PAGE = "/pages/genericObject.jsp";
				
			}else if("checkPolicyForAffectingEndtToCancel".equals(ACTION)){
			
				Map<String, Object> params = new HashMap<String, Object>();
				
				params = loadPolicyNoToMap(request);					
				message = gipiPackWPolBasService.checkPolicyForAffectingEndtToCancel(params);					
				
				params = null;
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfExistingInGipiWitmperl".equals(ACTION)) {
				Integer parId = request.getParameter("parId") == null ? 0 : new Integer((request.getParameter("parId").isEmpty()) ? "0" : request.getParameter("parId"));
				
				message = gipiPackWPolBasService.checkIfExistingInGipiWitmperl(parId);
				
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkIfExistingInGipiWitem".equals(ACTION)) {
				Integer parId = request.getParameter("parId") == null ? 0 : new Integer((request.getParameter("parId").isEmpty()) ? "0" : request.getParameter("parId"));
				
				message = gipiPackWPolBasService.checkIfExistingInGipiWitem(parId);
				
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkPackEndtForItemAndPeril".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();					
				StringBuilder sb = new StringBuilder();
				Integer parId = request.getParameter("parId") == null ? 0 : new Integer((request.getParameter("parId").isEmpty()) ? "0" : request.getParameter("parId"));
				
				params.put("parId", parId);					
				
				params = gipiPackWPolBasService.checkPackEndtForItemAndPeril(params);
				
				sb.append("itemCount=" + params.get("itemCount").toString());
				sb.append("&perilCount=" + params.get("perilCount").toString());
				
				message = sb.toString();
				params = null;
				sb = null;
				request.setAttribute("message", message);					
				PAGE = "/pages/genericMessage.jsp";
			} else if("preGetAmountsForPackEndt".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
				Integer parId = request.getParameter("parId") == null ? 0 : new Integer((request.getParameter("parId").isEmpty()) ? "0" : request.getParameter("parId"));
				
				params = loadPolicyNoToMap(request);
				params.put("parId", parId);
				params.put("effDate", sdf.parse(request.getParameter("effDate")));
				
				message = gipiPackWPolBasService.preGetAmountsForPackEndt(params);
				params = null;
				request.setAttribute("message", message);					
				PAGE = "/pages/genericMessage.jsp";					
			} else if("createNegatedRecordsFlat".equals(ACTION)){
				
				Map<String, Object> params = new HashMap<String, Object>();
				StringBuilder sb = new StringBuilder();	
								
				Integer parId = request.getParameter("parId") == null ? 0 : new Integer((request.getParameter("parId").isEmpty()) ? "0" : request.getParameter("parId"));
				
				params = loadPolicyNoToMap(request);
				params.put("parId", parId);
				params.put("coInsuranceSw", request.getParameter("coInsuranceSw"));
				params.put("packPolFlag", request.getParameter("packPolFlag"));										
				
				params = gipiPackWPolBasService.createNegatedRecordsFlat(params);			

				System.out.println("PARAMS:::"+ params.toString());
				//request.setAttribute("items", (List<Map<String, Object>>) params.get("gipiWItem"));
				//request.setAttribute("perils", (List<Map<String, Object>>) params.get("gipiWItmPerl"));					
				
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
				
				/*	Remove the map that contains the record
				 * 	in able to process the response
				 */
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
				sb = null;
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";					
			}else if("validatePackRefPolNo".equals(ACTION)){
				log.info("Validating Reference Policy No...");
				Integer packParId = Integer.parseInt(request.getParameter("packParId") == null ? "0" : request.getParameter("packParId"));
				String refPolNo = request.getParameter("refPolNo") == null ? "" : request.getParameter("refPolNo");
				message = gipiPackWPolBasService.validatePackRefPolNo(packParId, refPolNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePackEndtEffDate".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");					
				
				String oldDateEff = request.getParameter("varOldDateEff");
				String maxEffDate = request.getParameter("varMaxEffDate");
				@SuppressWarnings("unused")
				String expiryDate = request.getParameter("varExpiryDate");
				
				int packParId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null? "0" : request.getParameter("parId"));
				
				params = loadPolicyNoToMap(request);
				
				params.put("varOldDateEff", oldDateEff != null && !(oldDateEff.isEmpty()) ? sdf.parse(oldDateEff) : null);
				params.put("parId", packParId);
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
				
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiPackWPolBasService.validatePackEndtEffDate(params))).toString();
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPackRoadMap".equals(ACTION)){
				GIPIPackPARListService gipiPackParService = (GIPIPackPARListService) APPLICATION_CONTEXT.getBean("gipiPackPARListService");
				GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				
				String paramBBI = giisParametersService.getParamValueV2("BANKERS BLANKET INSURANCE");
				Integer packParId = Integer.parseInt("".equals(request.getParameter("packParId")) || request.getParameter("packParId") == null? "0" : request.getParameter("packParId"));
				GIPIPackPARList packPar = gipiPackParService.getGIPIPackParDetails(packParId);
				GIPIPackWPolBas packWPolbas = gipiPackWPolBasService.getGIPIPackWPolBas(packParId);
				request.setAttribute("jsonPAR", new JSONObject(StringFormatter.escapeHTMLInObject(packPar)));
				request.setAttribute("jsonWPolbas", new JSONObject(StringFormatter.escapeHTMLInObject(packWPolbas)));
				request.setAttribute("parNo", packPar.getParNo());
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("paramBBI", paramBBI);
				PAGE = "/pages/underwriting/roadMap/packRoadMap.jsp";
			}else if("processPackEndtCancellation".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				int parId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null? "0" : request.getParameter("parId"));
				params = loadPolicyNoToMap(request);
				params.put("parId", parId);
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params.put("packPolFlag", request.getParameter("packPolFlag"));
				params.put("cancelType", request.getParameter("cancelType"));					
				params.put("effDate", request.getParameter("effDate"));
				
				message = new JSONObject((Map<String, Object>) StringFormatter.replaceQuotesInMap(gipiPackWPolBasService.processPackEndtCancellation(params))).toString();
				request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("searchForEditedPackPolicy".equals(ACTION)){
				message = new JSONObject((Map<String,Object>) StringFormatter.replaceQuotesInMap(gipiPackWPolBasService.searchForEditedPackPolicy(request))).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch(SQLException e){
			message = "SQL Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch(Exception e){
			message = "Unhandled Exception occured...<br />"+e.getCause();
			PAGE = "/pages/genericMessage.jsp";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}
	
	private void loadListingToRequest(HttpServletRequest request,
			LOVHelper lovHelper, String[] args, String[] args2,
			String[] domainRisk, String lineCd, String lcEn,
			String parType) {

		List<LOV> sublineList = lovHelper.getList((lineCd).equals(lcEn) ? LOVHelper.SUB_LINE_SPF_LISTING : LOVHelper.SUB_LINE_LISTING, args);
		request.setAttribute("sublineListing", sublineList);

		List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
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

		request.setAttribute("surveyAgentListing", lovHelper.getList(LOVHelper.SURVEY_AGENT_LISTING));
		request.setAttribute("settlingAgentListing", lovHelper.getList(LOVHelper.SETTLING_AGENT_LISTING));
		
		Date date = new Date();
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		String[] argsDate = { format.format(date) };
		List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
		request.setAttribute("bookingMonthListing", bookingMonths);
		
	}
	
	private HttpServletRequest setPackParInfo(final HttpServletRequest request, GIPIPackPARList gipiPackPar){
		HttpServletRequest req = request;
		req.setAttribute("packParId", gipiPackPar.getPackParId());
		req.setAttribute("assdNo", gipiPackPar.getAssdNo());
		req.setAttribute("lineCd", gipiPackPar.getAssdNo());
		req.setAttribute("issCd", gipiPackPar.getIssCd());
		req.setAttribute("parYy", gipiPackPar.getParYy());
		req.setAttribute("quoteSeqNo", gipiPackPar.getQuoteSeqNo());
		req.setAttribute("parType", gipiPackPar.getParType());
		req.setAttribute("assignSw", gipiPackPar.getAssignSw());
		req.setAttribute("parStatus", gipiPackPar.getParStatus());
		req.setAttribute("remarks", gipiPackPar.getRemarks());
		req.setAttribute("underwriter", gipiPackPar.getUnderwriter());
		req.setAttribute("quoteId", gipiPackPar.getQuoteId());
		req.setAttribute("parSeqNo", gipiPackPar.getParSeqNo());
		req.setAttribute("assdName", gipiPackPar.getAssdName());
		return req;
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
	private void loadNewFormInstanceVariablesToRequest(HttpServletRequest request, Map<String, Object> newFormInstance){
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
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
	
	private GIPIPackPARList prepareGIPIPackParList(HttpServletRequest request,
					HttpServletResponse response, GIISUser USER) throws ParseException {
		GIPIPackPARList gipiPackParList = new GIPIPackPARList();
		gipiPackParList.setParId(Integer.parseInt(request.getParameter("b240ParId")));
		gipiPackParList.setParType(request.getParameter("b240ParType"));
		gipiPackParList.setParStatus(Integer.parseInt(request.getParameter("b240ParStatus")));
		gipiPackParList.setLineCd(request.getParameter("b240LineCd"));
		gipiPackParList.setIssCd(request.getParameter("b240IssCd"));
		gipiPackParList.setParYy(Integer.parseInt(request.getParameter("b240ParYy")));
		gipiPackParList.setParSeqNo(Integer.parseInt(request.getParameter("b240ParSeqNo")));
		gipiPackParList.setQuoteSeqNo(Integer.parseInt(request.getParameter("b240QuoteSeqNo")));
		gipiPackParList.setAssdNo(Integer.parseInt(request.getParameter("assuredNo")));
		gipiPackParList.setAddress1(request.getParameter("b240Address1"));
		gipiPackParList.setAddress2(request.getParameter("b240Address2"));
		gipiPackParList.setAddress3(request.getParameter("b240Address3"));
		gipiPackParList.setUserId(USER.getUserId());
		return gipiPackParList;
	}
	
	private GIPIPackWPolBas prepareGIPIPackWPolbas(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER) throws ParseException {
		log.info("Preparing GipiPackWPolbas...");
		GIPIPackWPolBas gipiPackWPolbas = new GIPIPackWPolBas();
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
				request.getParameter("quotationPrinted") == null | request.getParameter("quotationPrinted") == "" ? "N" : "quotationPrinted" : 
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
		/*String shortRtPercent = ("P").equals(parType) ? 
				((request.getParameter("prorateFlag").equals("3")) ? request.getParameter("shortRatePercent") : "") :
				request.getParameter("b540ShortRtPercent");*/

		//String shortRtPercent = request.getParameter("prorateFlag").equals("3") ? request.getParameter("shortRatePercent") : ""); //Comment out by PJD 09/06/2013
		String shortRtPercent = request.getParameter("prorateFlag") != null ? (request.getParameter("prorateFlag").equals("3") ? request.getParameter("shortRatePercent") : "") : "";
		String takeupTermType = ("P").equals(parType) ?  request.getParameter("takeupTermType") : request.getParameter("b540TakeupTerm");
		String samePolNoSw = ("P").equals(parType) ? request.getParameter("samePolnoSw") : request.getParameter("b540SamePolNoSw");
		int issueYY = Integer.parseInt(request.getParameter(("P").equals(parType) ? "issueYy" : "b540IssueYY"));
		String endtYY = ("P").equals(parType) ? request.getParameter("endtYy") : request.getParameter("b540EndtYy");
		String endtSeqNo = ("P").equals(parType) ? request.getParameter("endtSeqNo") : request.getParameter("b540EndtSeqNo");
		/*String issueDate = ("P").equals(parType) ? request.getParameter("issueDate") : request.getParameter("b540IssueDate");
		String inceptDate = ("P").equals(parType) ? request.getParameter("doi") : request.getParameter("b540InceptDate");
		String expiryDate = ("P").equals(parType) ? request.getParameter("doe") : request.getParameter("b540ExpiryDate");*/
		String issueDate = request.getParameter("issueDate");
		String inceptDate = request.getParameter("doi");
		String expiryDate = request.getParameter("doe");
		String effDate = ("P").equals(parType) ? null : request.getParameter("b540EffDate");
		String endtExpDate = ("P").equals(parType) ? null : request.getParameter("b540EndtExpiryDate");		
		Debug.print("issue date: "+issueDate);
		// check if dates are null
		if (issueDate == null) {
			issueDate = new String("");
		}
		if (inceptDate == null) {
			inceptDate = new String("");
		}
		if (expiryDate == null) {
			expiryDate = new String("");
		}
		if (effDate == null) {
			effDate = new String("");
		}
		if (endtExpDate == null) {
			endtExpDate = new String("");
		}
		
		gipiPackWPolbas.setParId(parId);
		gipiPackWPolbas.setUserId(USER.getUserId());
		gipiPackWPolbas.setLineCd(request.getParameter("lineCd"));
		gipiPackWPolbas.setInvoiceSw(invoiceSw);
		gipiPackWPolbas.setSublineCd(request.getParameter("sublineCd"));
		gipiPackWPolbas.setPolFlag(polFlag);
		gipiPackWPolbas.setManualRenewNo(request.getParameter("manualRenewNo") != null ? request.getParameter("manualRenewNo") : "0");
		gipiPackWPolbas.setTypeCd(request.getParameter("typeOfPolicy"));
		gipiPackWPolbas.setAddress1(request.getParameter("address1"));
		gipiPackWPolbas.setAddress2(request.getParameter("address2"));
		gipiPackWPolbas.setAddress3(request.getParameter("address3"));
		gipiPackWPolbas.setDesignation(designation);
		gipiPackWPolbas.setIssCd(issCd);
		gipiPackWPolbas.setCredBranch(request.getParameter("creditingBranch"));
		gipiPackWPolbas.setAssdNo(request.getParameter("assuredNo") == null ? null : ("".equals(request.getParameter("assuredNo")) ? null : Integer.parseInt(request.getParameter("assuredNo"))));
		gipiPackWPolbas.setAcctOfCd(request.getParameter("acctOfCd"));
		gipiPackWPolbas.setPlaceCd(request.getParameter("issuePlace"));
		gipiPackWPolbas.setRiskTag(request.getParameter("riskTag"));
		gipiPackWPolbas.setRefPolNo(request.getParameter("referencePolicyNo"));
		if (("P").equals(parType)){
			if (request.getParameter("ora2010Sw").equals("Y")){
				gipiPackWPolbas.setCompanyCd(request.getParameter("companyCd") == null ? null : ("".equals(request.getParameter("companyCd")) ? null : Integer.parseInt(request.getParameter("companyCd"))));
				gipiPackWPolbas.setEmployeeCd(request.getParameter("employeeCd"));
				gipiPackWPolbas.setBankRefNo(request.getParameter("bankRefNo"));
				gipiPackWPolbas.setBancassuranceSw(request.getParameter("bancaTag") == null ? "N" :"Y");
				if ("Y".equals(gipiPackWPolbas.getBancassuranceSw())){
					gipiPackWPolbas.setBancTypeCd(request.getParameter("selBancTypeCd"));
					gipiPackWPolbas.setAreaCd(request.getParameter("selAreaCd"));
					gipiPackWPolbas.setBranchCd(request.getParameter("selBranchCd"));
					gipiPackWPolbas.setManagerCd(request.getParameter("managerCd"));
				}
				gipiPackWPolbas.setPlanSw(request.getParameter("packPLanTag") == null ? "N" :"Y");
				if ("Y".equals(gipiPackWPolbas.getPlanSw())){
					gipiPackWPolbas.setPlanCd(request.getParameter("selPlanCd") == null ? null :Integer.parseInt(request.getParameter("selPlanCd")));
				}
			}
			
			/*if(request.getParameter("mnSublineMop").equals(request.getParameter("sublineCd"))){
				gipiPackWPolbas.setRefOpenPolNo(request.getParameter("referencePolicyNo"));
			}
			if (request.getParameter("lcMN").equals(request.getParameter("lineCd")) || request.getParameter("lcMN2").equals("MN")){
				gipiPackWPolbas.setSurveyAgentCd(request.getParameter("surveyAgentCd"));
				gipiPackWPolbas.setSettlingAgentCd(request.getParameter("settlingAgentCd"));
			} commented by: nica 03.03.2011 - not being used/needed in package par*/
		}
		gipiPackWPolbas.setIndustryCd(request.getParameter("industry"));
		gipiPackWPolbas.setRegionCd(request.getParameter("region"));
		gipiPackWPolbas.setQuotationPrintedSw(quotationPrintedSw);
		gipiPackWPolbas.setCovernotePrintedSw(covernotePrintedSw);
		gipiPackWPolbas.setPackPolFlag(packPolFlag);
		gipiPackWPolbas.setAutoRenewFlag(autoRenewFlag);
		gipiPackWPolbas.setForeignAccSw(foreignAccSw);
		gipiPackWPolbas.setRegPolicySw(((request.getParameter("regularPolicy") == null) || (request.getParameter("regularPolicy") == "") ? "N" : request.getParameter("regularPolicy")));
		gipiPackWPolbas.setPremWarrTag(((request.getParameter("premWarrTag") == null) || (request.getParameter("premWarrTag") == "") ? "N" : request.getParameter("premWarrTag")));
		gipiPackWPolbas.setPremWarrDays(premWarrDays);
		gipiPackWPolbas.setFleetPrintTag(((request.getParameter("fleetTag") == null) || (request.getParameter("fleetTag") == "") ? "N" : request.getParameter("fleetTag")));
		gipiPackWPolbas.setWithTariffSw(((request.getParameter("wTariff") == null) || (request.getParameter("wTariff") == "") ? "N" : request.getParameter("wTariff")));
		gipiPackWPolbas.setProvPremTag(provPremTag);
		gipiPackWPolbas.setProvPremPct(provPremPct == null ? null : ("".equals(provPremPct) ? null : new BigDecimal(provPremPct)));
		gipiPackWPolbas.setInceptTag(((request.getParameter("inceptTag") == null) || (request.getParameter("inceptTag") == "") ? "N" : request.getParameter("inceptTag")));
		gipiPackWPolbas.setExpiryTag(((request.getParameter("expiryTag") == null) || (request.getParameter("expiryTag") == "") ? "N" : request.getParameter("expiryTag")));
		gipiPackWPolbas.setEndtExpiryTag(((request.getParameter("endtExpiryTag") == null) || (request.getParameter("endtExpiryTag") == "") ? "N" : request.getParameter("endtExpiryTag")));
		gipiPackWPolbas.setProrateFlag(request.getParameter("prorateFlag"));
		gipiPackWPolbas.setCompSw(compSw);
		gipiPackWPolbas.setShortRtPercent(shortRtPercent == null ? null : ("".equals(shortRtPercent) ? null : new BigDecimal(shortRtPercent)));
		gipiPackWPolbas.setBookingYear(request.getParameter("bookingYear") == null ? null : ("".equals(request.getParameter("bookingYear")) ? null : Integer.parseInt(request.getParameter("bookingYear"))));
		gipiPackWPolbas.setBookingMth(request.getParameter("bookingMth"));
		gipiPackWPolbas.setCoInsuranceSw(request.getParameter("coIns"));
		gipiPackWPolbas.setTakeupTerm(takeupTermType);
		gipiPackWPolbas.setRenewNo(request.getParameter("renewNo") == null ? null : ("".equals(request.getParameter("renewNo")) ? null : Integer.parseInt(request.getParameter("renewNo"))));
		gipiPackWPolbas.setIssueYy(issueYY);
		gipiPackWPolbas.setSamePolnoSw(samePolNoSw);
		gipiPackWPolbas.setEndtYy(endtYY == null ? null : ("".equals(endtYY) ? null : Integer.parseInt(endtYY)));
		gipiPackWPolbas.setEndtSeqNo(endtSeqNo);
		gipiPackWPolbas.setUpdateIssueDate(request.getParameter("updateIssueDate"));

		gipiPackWPolbas.setIssueDate(issueDate.isEmpty() ? null : (sdf.parse(issueDate)));
		gipiPackWPolbas.setInceptDate(inceptDate.isEmpty() ? null : (sdf.parse(inceptDate)));
		gipiPackWPolbas.setExpiryDate(expiryDate.isEmpty() ? null : ( sdf.parse(expiryDate)));
			
		gipiPackWPolbas.setEffDate(!effDate.isEmpty() ? sdfWithTime.parse(effDate) : null);
		gipiPackWPolbas.setEndtExpiryDate(!endtExpDate.isEmpty() ? sdfWithTime.parse(endtExpDate) : null);
		//gipiPackWPolbas.setLabelTag("P".equals(parType) ? (request.getParameter("labelTag") == null || request.getParameter("labelTag") == "" ? "" :request.getParameter("labelTag")) :"");
		gipiPackWPolbas.setLabelTag(request.getParameter("labelTag") == null || request.getParameter("labelTag") == "" ? "" :request.getParameter("labelTag")); // bonok :: 05.19.2014 :: to also set label_tag value for endt  
		
		if("E".equals(parType)){
			String tsiAmt = request.getParameter("b540TsiAmt").isEmpty() ? null : request.getParameter("b540TsiAmt");
			String premAmt = request.getParameter("b540PremAmt").isEmpty() ? null : request.getParameter("b540PremAmt");
			String annTsiAmt = request.getParameter("b540AnnTsiAmt").isEmpty() ? null : request.getParameter("b540AnnTsiAmt");
			String annPremAmt = request.getParameter("b540AnnPremAmt").isEmpty() ? null : request.getParameter("b540AnnPremAmt");
			
			gipiPackWPolbas.setPolSeqNo(Integer.parseInt(request.getParameter("b540PolSeqNo")));
			gipiPackWPolbas.setEndtIssCd(request.getParameter("b540EndtIssCd"));
			gipiPackWPolbas.setAcctOfCdSw(request.getParameter("b540AcctOfCdSw"));
			gipiPackWPolbas.setOldAssdNo(Integer.parseInt(request.getParameter("b540OldAssdNo")));
			gipiPackWPolbas.setOldAddress1(request.getParameter("b540OldAddress1"));
			gipiPackWPolbas.setOldAddress2(request.getParameter("b540OldAddress2"));
			gipiPackWPolbas.setOldAddress3(request.getParameter("b540OldAddress3"));
			// andrew - 11.25.2011 - modified code below.. added condition for null values
			if(tsiAmt != null) gipiPackWPolbas.setTsiAmt(new BigDecimal(tsiAmt));
			if(premAmt != null) gipiPackWPolbas.setPremAmt(new BigDecimal(premAmt));
			if(annTsiAmt != null) gipiPackWPolbas.setAnnTsiAmt(new BigDecimal(annTsiAmt));
			if(annPremAmt != null) gipiPackWPolbas.setAnnPremAmt(new BigDecimal(annPremAmt));
		}
		
		return gipiPackWPolbas;
	}
	
	private GIPIPackWPolGenin prepareGIPIPackWPolGenin(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER){
		log.info("Preparing GipiPackWPolGenin...");
		GIPIPackWPolGenin gipiPackWPolGenin = new GIPIPackWPolGenin();
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));		
		
		gipiPackWPolGenin.setParId(parId);
		if("P".equals(request.getParameter("parType"))){
			int initLength = request.getParameter("initialInformation").length();
			int genLength = request.getParameter("generalInformation").length();
			gipiPackWPolGenin.setDspInitialInfo(request.getParameter("initialInformation"));
			gipiPackWPolGenin.setDspGenInfo(request.getParameter("generalInformation"));
			gipiPackWPolGenin.setAgreedTag(request.getParameter("agreedTag"));
			
			if (!request.getParameter("initialInformation").equals("")) {
				if ((initLength >= 1) && (initLength > 2000)) {
					gipiPackWPolGenin.setInitialInfo01(request.getParameter("initialInformation").substring(0, 2000));
				} else if ((initLength >= 1) && (initLength <= 2000)) {
					gipiPackWPolGenin.setInitialInfo01(request.getParameter("initialInformation").substring(0));
				}
				if ((initLength >= 2001) && (initLength > 4000)) {
					gipiPackWPolGenin.setInitialInfo02(request.getParameter("initialInformation").substring(2000, 4000));
				} else if ((initLength >= 2001) && (initLength <= 4000)) {
					gipiPackWPolGenin.setInitialInfo02(request.getParameter("initialInformation").substring(2000));
				}
				if ((initLength >= 4001) && (initLength > 6000)) {
					gipiPackWPolGenin.setInitialInfo03(request.getParameter("initialInformation").substring(4000, 6000));
				} else if ((initLength >= 4001) && (initLength <= 6000)) {
					gipiPackWPolGenin.setInitialInfo03(request.getParameter("initialInformation").substring(4000));
				}
				if ((initLength >= 6001) && (initLength > 8000)) {
					gipiPackWPolGenin.setInitialInfo04(request.getParameter("initialInformation").substring(6000, 8000));
				} else if ((initLength >= 6001) && (initLength <= 8000)) {
					gipiPackWPolGenin.setInitialInfo04(request.getParameter("initialInformation").substring(6000));
				}
				if ((initLength >= 8001) && (initLength > 10000)) {
					gipiPackWPolGenin.setInitialInfo05(request.getParameter("initialInformation").substring(8000, 10000));
				} else if ((initLength >= 8001) && (initLength <= 10000)) {
					gipiPackWPolGenin.setInitialInfo05(request.getParameter("initialInformation").substring(8000));
				}
				if ((initLength >= 10001) && (initLength > 12000)) {
					gipiPackWPolGenin.setInitialInfo06(request.getParameter("initialInformation").substring(10000, 12000));
				} else if ((initLength >= 10001) && (initLength <= 12000)) {
					gipiPackWPolGenin.setInitialInfo06(request.getParameter("initialInformation").substring(10000));
				}
				if ((initLength >= 12001) && (initLength > 14000)) {
					gipiPackWPolGenin.setInitialInfo07(request.getParameter("initialInformation").substring(12000, 14000));
				} else if ((initLength >= 12001) && (initLength <= 14000)) {
					gipiPackWPolGenin.setInitialInfo07(request.getParameter("initialInformation").substring(12000));
				}
				if ((initLength >= 14001) && (initLength > 16000)) {
					gipiPackWPolGenin.setInitialInfo08(request.getParameter("initialInformation").substring(14000, 16000));
				} else if ((initLength >= 14001) && (initLength <= 16000)) {
					gipiPackWPolGenin.setInitialInfo08(request.getParameter("initialInformation").substring(14000));
				}
				if ((initLength >= 16001) && (initLength > 18000)) {
					gipiPackWPolGenin.setInitialInfo09(request.getParameter("initialInformation").substring(16000, 18000));
				} else if ((initLength >= 16001) && (initLength <= 18000)) {
					gipiPackWPolGenin.setInitialInfo09(request.getParameter("initialInformation").substring(16000));
				}
				if ((initLength >= 18001) && (initLength > 20000)) {
					gipiPackWPolGenin.setInitialInfo10(request.getParameter("initialInformation").substring(18000, 20000));
				} else if ((initLength >= 18001) && (initLength <= 20000)) {
					gipiPackWPolGenin.setInitialInfo10(request.getParameter("initialInformation").substring(18000));
				}
				if ((initLength >= 20001) && (initLength > 22000)) {
					gipiPackWPolGenin.setInitialInfo11(request.getParameter("initialInformation").substring(20000, 22000));
				} else if ((initLength >= 20001) && (initLength <= 22000)) {
					gipiPackWPolGenin.setInitialInfo11(request.getParameter("initialInformation").substring(20000));
				}
				if ((initLength >= 22001) && (initLength > 24000)) {
					gipiPackWPolGenin.setInitialInfo12(request.getParameter("initialInformation").substring(22000, 24000));	
				} else if ((initLength >= 22001) && (initLength <= 24000)) {
					gipiPackWPolGenin.setInitialInfo12(request.getParameter("initialInformation").substring(22000));
				}
				if ((initLength >= 24001) && (initLength > 26000)) {
					gipiPackWPolGenin.setInitialInfo13(request.getParameter("initialInformation").substring(24000, 26000));
				} else if ((initLength >= 24001) && (initLength <= 26000)) {
					gipiPackWPolGenin.setInitialInfo13(request.getParameter("initialInformation").substring(24000));
				}
				if ((initLength >= 26001) && (initLength > 28000)) {
					gipiPackWPolGenin.setInitialInfo14(request.getParameter("initialInformation").substring(26000, 28000));
				} else if ((initLength >= 26001) && (initLength <= 28000)) {
					gipiPackWPolGenin.setInitialInfo14(request.getParameter("initialInformation").substring(26000));
				}
				if ((initLength >= 28001) && (initLength > 30000)) {
					gipiPackWPolGenin.setInitialInfo15(request.getParameter("initialInformation").substring(28000, 30000));
				} else if ((initLength >= 28001) && (initLength <= 30000)) {
					gipiPackWPolGenin.setInitialInfo15(request.getParameter("initialInformation").substring(28000));
				} 
				if ((initLength >= 30001) && (initLength > 32000)) {
					gipiPackWPolGenin.setInitialInfo16(request.getParameter("initialInformation").substring(30000, 32000));
				} else if ((initLength >= 30001) && (initLength <= 32000)) {
					gipiPackWPolGenin.setInitialInfo16(request.getParameter("initialInformation").substring(30000));
				}
				if ((initLength >= 32001) && (initLength >= 34000)) {
					gipiPackWPolGenin.setInitialInfo17(request.getParameter("initialInformation").substring(32000, 34000));
				} else if ((initLength >= 32001) && (initLength < 34000)) {
					gipiPackWPolGenin.setInitialInfo17(request.getParameter("initialInformation").substring(32000));
				}
			}
			
			if (!request.getParameter("generalInformation").equals("")) {
				if ((genLength >= 1) && (genLength > 2000)) {
					gipiPackWPolGenin.setGenInfo01(request.getParameter("generalInformation").substring(0, 2000));
				} else if ((genLength >= 1) && (genLength <= 2000)) {
					gipiPackWPolGenin.setGenInfo01(request.getParameter("generalInformation").substring(0));
				}
				if ((genLength >= 2001) && (genLength > 4000)) {
					gipiPackWPolGenin.setGenInfo02(request.getParameter("generalInformation").substring(2000, 4000));
				} else if ((genLength >= 2001) && (genLength <= 4000)) {
					gipiPackWPolGenin.setGenInfo02(request.getParameter("generalInformation").substring(2000));
				}
				if ((genLength >= 4001) && (genLength > 6000)) {
					gipiPackWPolGenin.setGenInfo03(request.getParameter("generalInformation").substring(4000, 6000));
				} else if ((genLength >= 4001) && (genLength <= 6000)) {
					gipiPackWPolGenin.setGenInfo03(request.getParameter("generalInformation").substring(4000));
				}
				if ((genLength >= 6001) && (genLength > 8000)) {
					gipiPackWPolGenin.setGenInfo04(request.getParameter("generalInformation").substring(6000, 8000));
				} else if ((genLength >= 6001) && (genLength <= 8000)) {
					gipiPackWPolGenin.setGenInfo04(request.getParameter("generalInformation").substring(6000));
				}
				if ((genLength >= 8001) && (genLength > 10000)) {
					gipiPackWPolGenin.setGenInfo05(request.getParameter("generalInformation").substring(8000, 10000));
				} else if ((genLength >= 8001) && (genLength <= 10000)) {
					gipiPackWPolGenin.setGenInfo05(request.getParameter("generalInformation").substring(8000));
				}
				if ((genLength >= 10001) && (genLength > 12000)) {
					gipiPackWPolGenin.setGenInfo06(request.getParameter("generalInformation").substring(10000, 12000));
				} else if ((genLength >= 10001) && (genLength <= 12000)) {
					gipiPackWPolGenin.setGenInfo06(request.getParameter("generalInformation").substring(10000));
				}
				if ((genLength >= 12001) && (genLength > 14000)) {
					gipiPackWPolGenin.setGenInfo07(request.getParameter("generalInformation").substring(12000, 14000));	
				} else if ((genLength >= 12001) && (genLength <= 14000)) {
					gipiPackWPolGenin.setGenInfo07(request.getParameter("generalInformation").substring(12000));
				}
				if ((genLength >= 14001) && (genLength > 16000)) {
					gipiPackWPolGenin.setGenInfo08(request.getParameter("generalInformation").substring(14000, 16000));
				} else if ((genLength >= 14001) && (genLength <= 16000)) {
					gipiPackWPolGenin.setGenInfo08(request.getParameter("generalInformation").substring(14000));
				}
				if ((genLength >= 16001) && (genLength > 18000)) {
					gipiPackWPolGenin.setGenInfo09(request.getParameter("generalInformation").substring(16000, 18000));
				} else if ((genLength >= 16001) && (genLength <= 18000)) {
					gipiPackWPolGenin.setGenInfo09(request.getParameter("generalInformation").substring(16000));
				}
				if ((genLength >= 18001) && (genLength > 20000)) {
					gipiPackWPolGenin.setGenInfo10(request.getParameter("generalInformation").substring(18000, 20000));
				} else if ((genLength >= 18001) && (genLength <= 20000)) {
					gipiPackWPolGenin.setGenInfo10(request.getParameter("generalInformation").substring(18000));
				}
				if ((genLength >= 20001) && (genLength > 22000)) {
					gipiPackWPolGenin.setGenInfo11(request.getParameter("generalInformation").substring(20000, 22000));
				} else if ((genLength >= 20001) && (genLength <= 22000)) {
					gipiPackWPolGenin.setGenInfo11(request.getParameter("generalInformation").substring(20000));
				}
				if ((genLength >= 22001) && (genLength > 24000)) {
					gipiPackWPolGenin.setGenInfo12(request.getParameter("generalInformation").substring(22000, 24000));
				} else if ((genLength >= 22001) && (genLength <= 24000)) {
					gipiPackWPolGenin.setGenInfo12(request.getParameter("generalInformation").substring(22000));
				}
				if ((genLength >= 24001) && (genLength > 26000)) {
					gipiPackWPolGenin.setGenInfo13(request.getParameter("generalInformation").substring(24000, 26000));
				} else if ((genLength >= 24001) && (genLength <= 26000)) {
					gipiPackWPolGenin.setGenInfo13(request.getParameter("generalInformation").substring(24000));
				}
				if ((genLength >= 26001) && (genLength > 28000)) {
					gipiPackWPolGenin.setGenInfo14(request.getParameter("generalInformation").substring(26000, 28000));
				} else if ((genLength >= 26001) && (genLength <= 28000)) {
					gipiPackWPolGenin.setGenInfo14(request.getParameter("generalInformation").substring(26000));
				}
				if ((genLength >= 28001) && (genLength > 30000)) {
					gipiPackWPolGenin.setGenInfo15(request.getParameter("generalInformation").substring(28000, 30000));
				} else if ((genLength >= 28001) && (genLength <= 30000)) {
					gipiPackWPolGenin.setGenInfo15(request.getParameter("generalInformation").substring(28000));
				}
				if ((genLength >= 30001) && (genLength > 32000)) {
					gipiPackWPolGenin.setGenInfo16(request.getParameter("generalInformation").substring(30000, 32000));
				} else if ((genLength >= 30001) && (genLength <= 32000)) {
					gipiPackWPolGenin.setGenInfo16(request.getParameter("generalInformation").substring(30000));
				}
				if ((genLength >= 32001) && (genLength >= 34000)) {
					gipiPackWPolGenin.setGenInfo17(request.getParameter("generalInformation").substring(32000, 34000));
				} else if ((genLength >= 32001) && (genLength < 34000)) {
					gipiPackWPolGenin.setGenInfo17(request.getParameter("generalInformation").substring(32000));
				}
			}			
		}else{
			gipiPackWPolGenin.setGenInfo(request.getParameter("generalInformation"));
			gipiPackWPolGenin.setGenInfo01(request.getParameter("b550GenInfo01"));
			gipiPackWPolGenin.setGenInfo02(request.getParameter("b550GenInfo02"));
			gipiPackWPolGenin.setGenInfo03(request.getParameter("b550GenInfo03"));
			gipiPackWPolGenin.setGenInfo04(request.getParameter("b550GenInfo04"));
			gipiPackWPolGenin.setGenInfo05(request.getParameter("b550GenInfo05"));
			gipiPackWPolGenin.setGenInfo06(request.getParameter("b550GenInfo06"));
			gipiPackWPolGenin.setGenInfo07(request.getParameter("b550GenInfo07"));
			gipiPackWPolGenin.setGenInfo08(request.getParameter("b550GenInfo08"));
			gipiPackWPolGenin.setGenInfo09(request.getParameter("b550GenInfo09"));
			gipiPackWPolGenin.setGenInfo10(request.getParameter("b550GenInfo10"));
			gipiPackWPolGenin.setGenInfo11(request.getParameter("b550GenInfo11"));
			gipiPackWPolGenin.setGenInfo12(request.getParameter("b550GenInfo12"));
			gipiPackWPolGenin.setGenInfo13(request.getParameter("b550GenInfo13"));
			gipiPackWPolGenin.setGenInfo14(request.getParameter("b550GenInfo14"));
			gipiPackWPolGenin.setGenInfo15(request.getParameter("b550GenInfo15"));
			gipiPackWPolGenin.setGenInfo16(request.getParameter("b550GenInfo16"));
			gipiPackWPolGenin.setGenInfo17(request.getParameter("b550GenInfo17"));			
		}
		
		gipiPackWPolGenin.setUserId(USER.getUserId());
		return gipiPackWPolGenin;
	}
	
	private GIPIPackWEndtText prepareGIPIPackWEndtText(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER){
		log.info("Preparing GIPIWEndtText ...");
		GIPIPackWEndtText gipiPackWEndtText = new GIPIPackWEndtText();
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		
		gipiPackWEndtText.setPackParId(parId);
		gipiPackWEndtText.setEndtTax(request.getParameter("b360EndtTax"));
		System.out.println("Prepared b360EndtTax: "+request.getParameter("b360EndtTax")+" / "+parId);
		gipiPackWEndtText.setEndtText(request.getParameter("endtInformation"));
		gipiPackWEndtText.setEndtText01(request.getParameter("b360EndtText01"));
		gipiPackWEndtText.setEndtText02(request.getParameter("b360EndtText02"));
		gipiPackWEndtText.setEndtText03(request.getParameter("b360EndtText03"));
		gipiPackWEndtText.setEndtText04(request.getParameter("b360EndtText04"));
		gipiPackWEndtText.setEndtText05(request.getParameter("b360EndtText05"));
		gipiPackWEndtText.setEndtText06(request.getParameter("b360EndtText06"));
		gipiPackWEndtText.setEndtText07(request.getParameter("b360EndtText07"));
		gipiPackWEndtText.setEndtText08(request.getParameter("b360EndtText08"));
		gipiPackWEndtText.setEndtText09(request.getParameter("b360EndtText09"));
		gipiPackWEndtText.setEndtText10(request.getParameter("b360EndtText10"));
		gipiPackWEndtText.setEndtText11(request.getParameter("b360EndtText11"));
		gipiPackWEndtText.setEndtText12(request.getParameter("b360EndtText12"));
		gipiPackWEndtText.setEndtText13(request.getParameter("b360EndtText13"));
		gipiPackWEndtText.setEndtText14(request.getParameter("b360EndtText14"));
		gipiPackWEndtText.setEndtText15(request.getParameter("b360EndtText15"));
		gipiPackWEndtText.setEndtText16(request.getParameter("b360EndtText16"));
		gipiPackWEndtText.setEndtText17(request.getParameter("b360EndtText17"));		
		gipiPackWEndtText.setUserId(USER.getUserId());
		
		return gipiPackWEndtText;
	}
	
	private Map<String, Object> prepareGIPIPackWPolnrepMap (HttpServletRequest request, HttpServletResponse response){
		Map<String, Object> gipiPackWPolnrepMap = new HashMap<String, Object>();
		String[] delOldPolicyIds 	= request.getParameterValues("delOldPolicyId");
		String[] insOldPolicyIds 	= request.getParameterValues("insOldPolicyId");
		
		gipiPackWPolnrepMap.put("insOldPolicyIds", insOldPolicyIds);
		gipiPackWPolnrepMap.put("delOldPolicyIds", delOldPolicyIds);
		
		return gipiPackWPolnrepMap;
	}
}
