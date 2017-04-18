package com.geniisys.gipi.controllers;

import java.io.IOException;
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
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISBancArea;
import com.geniisys.common.entity.GIISBancBranch;
import com.geniisys.common.entity.GIISBancType;
import com.geniisys.common.entity.GIISPayees;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.service.GIPIBondSeqHistService;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolnrepFacadeService;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.service.GIUWPolDistService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIParBondInformationController extends BaseController {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIParBondInformationController.class);
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		try {
			/*default attributes*/
			log.info("Initializing: "+ this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			/*end of default attributes*/
			
			int parId = Integer.parseInt("".equals(request.getParameter("parId")) ? "0" : request.getParameter("parId"));
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
				if("showBondBasicInfo".equals(ACTION)){
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper"); // +env
					GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					GIPIWPolnrepFacadeService gipiWPolnrepService = (GIPIWPolnrepFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolnrepFacadeService");
					GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService"); // +env
					GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
					
					log.info("Getting bond basic information...");
					GIPIPARList gipiParList = null;
					GIPIWPolbas gipiWPolbas = null;
					
					Map parsNewFormInst = new HashMap();
					parsNewFormInst = gipiWPolbasService.newFormInstBond(issCd, lineCd);
					String updCredBranch = (String) parsNewFormInst.get("updCredBranch");
					String updIssueDate = (String) parsNewFormInst.get("updIssueDate");
					String varVdate = (String) parsNewFormInst.get("varVdate");
					String reqCredBranch = (String) parsNewFormInst.get("reqCredBranch");

					request.setAttribute("reqCredBranch", reqCredBranch);
					request.setAttribute("updCredBranch", updCredBranch);
					request.setAttribute("updIssueDate", updIssueDate);
					request.setAttribute("varVdate", varVdate);					
					String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
					request.setAttribute("ora2010Sw", ora2010Sw);
					request.setAttribute("overrideTakeupTerm", giisParametersService.getParamValueV2("OVERRIDE_TAKEUP_TERM"));
					request.setAttribute("reqRefPolNo", (String) parsNewFormInst.get("reqRefPolNo"));
					request.setAttribute("reqRefNo", (String) parsNewFormInst.get("reqRefNo")); //added by gab 10.07.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
					request.setAttribute("updateBooking", giisParametersService.getParamValueV2("UPDATE_BOOKING")); // added by: Nica 05.10.2012
					request.setAttribute("allowIssueExpiredBond", giisParametersService.getParamValueV2("ALLOW_ISSUE_EXPIRED_BOND")); // added by: Nica 09.28.2012
					
					String[] args = {lineCd};
					String[] args2 = {issCd};
					
					if ("Y".equals(ora2010Sw)){
						request.setAttribute("companyListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.COMPANY_LISTING))));
						request.setAttribute("employeeListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.EMPLOYEE_LISTING))));
						request.setAttribute("bancTypeCdListingJSON", new JSONArray((List<GIISBancType>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_TYPE_CD_LISTING))));
						request.setAttribute("bancAreaCdListingJSON", new JSONArray((List<GIISBancArea>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_AREA_CD_LISTING))));
						request.setAttribute("bancBranchCdListingJSON", new JSONArray((List<GIISBancBranch>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_BRANCH_CD_LISTING))));
					}
					
					
					List<LOV> sublineList = lovHelper.getList(LOVHelper.SUB_LINE_LISTING, args);
					request.setAttribute("sublineListing", sublineList);
					
					List<LOV> policyStatusList = lovHelper.getList(LOVHelper.POLICY_STATUS_LISTING);
					request.setAttribute("policyStatusListing", policyStatusList);
					
					//Date date = new Date();
					//DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
					//String[] argsDate = {format.format(date)};
					/*List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
					request.setAttribute("bookingMonthListing", bookingMonths);*/
					// comment for the advance booking conflict Rey Jadlocon 11-07-2011
					
					List<LOV> takeupTermList = lovHelper.getList(LOVHelper.TAKEUP_TERM_LISTING);
					request.setAttribute("takeupTermListing", takeupTermList);
					
					List<LOV> placeList = lovHelper.getList(LOVHelper.PLACE_LISTING, args2);
					request.setAttribute("placeListing", placeList);
					
					
					List<LOV> mortgageeList = lovHelper.getList(LOVHelper.MORTGAGEE_LISTING, args2);				
					request.setAttribute("mortgageeListing", mortgageeList);
					request.setAttribute("mortgageeListingJSON", new JSONArray((List<LOV>) StringFormatter.replaceQuotesInList(mortgageeList)));
					
					List<LOV> industryList = lovHelper.getList(LOVHelper.INDUSTRY_LISTING);
					request.setAttribute("industryListing", industryList);
					
					List<LOV> regionList = lovHelper.getList(LOVHelper.REGION_LISTING);
					request.setAttribute("regionListing", regionList);
					
					if(issCd.equals("RI")){ //added by christian 03/20/2013
						List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
						request.setAttribute("branchSourceListing", branchSourceList);
					}else{ //list of issCd excluding RI
						String[] args3 = {"Y"};
						List<LOV> branchSourceList = lovHelper.getList(LOVHelper.GET_ISS_CD_BY_CRED_TAG_EXC_RI, args3);
						request.setAttribute("branchSourceListing", branchSourceList);
					}
										
					gipiParList = gipiParService.getGIPIPARDetails(parId);
					request.setAttribute("gipiParList", gipiParList);
					
					log.info("Getting gipi_wpolbas...");
					Map parsWPolbas = new HashMap();
					DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
					Date date = null;
					//String[] argsDate = {format.format(date)};
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
					String showBondSeqNo = giisParametersService.getParamValueV2("SHOW_BOND_SEQ_NO");
					request.setAttribute("showBondSeqNo", showBondSeqNo);
					
					//Rey Jadlocon 11-07-2011 for the advance booking 
					// Start 
					String bookingAdv = giisParametersService.getParamValueV2("ALLOW_BOOKING_IN_ADVANCE");
					request.setAttribute("bookingAdv", bookingAdv);
					//Map parsWPolbas = new HashMap();
					//String isExistWPolbas = (String) parsWPolbas.get("exist");
					//request.setAttribute("isExistGipiWPolbas", isExistWPolbas);
					
					request.setAttribute("dispDefaultCredBranch", giisParametersService.getParamValueV2("DISPLAY_DEF_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					request.setAttribute("defaultCredBranch", giisParametersService.getParamValueV2("DEFAULT_CRED_BRANCH")); // added by: Kris 07.04.2013 for UW-SPECS-2013-091
					
					if ("Y".equals(bookingAdv)){
						//String[] argsDate = { format.format(date) };
						List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING3);
						request.setAttribute("bookingMonthListing", bookingMonths);
						//List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
						//request.setAttribute("bookingMonthListing", bookingMonths);
					}else{
						
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
					//End 
					
					log.info("Getting gipi_wpolnrep...");
					List<GIPIWPolnrep> wpolnreps = gipiWPolnrepService.getWPolnrep(parId);
					request.setAttribute("gipiWPolnrep", wpolnreps);
					
					Map parsWinvoice = new HashMap();
					parsWinvoice = gipiWInvoiceService.isExist(parId);
					String isExistWinvoice = (String) parsWinvoice.get("exist");
					request.setAttribute("isExistGipiWInvoice", isExistWinvoice);
					
					message = "SUCCESS";
					PAGE = "/pages/underwriting/bondBasicInformationMain.jsp";
					
				} else if("saveBondBasicInfo".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					GIUWPolDistService distService = (GIUWPolDistService) APPLICATION_CONTEXT.getBean("giuwPolDistService");
					log.info("Saving bond basic information...");
					GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
					GIPIWPolnrep gipiWPolnrep = new GIPIWPolnrep();
					gipiWPolbas = prepareGipiWPolbas(request, response, USER);
					
					String polFlag = request.getParameter("policyStatus");
					if (polFlag.equals("2") || polFlag.equals("3")) {
						gipiWPolnrep = prepareGipiWPolnrep(request, response, USER);
					}
					
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("gipiWPolbas",gipiWPolbas);
					params.put("gipiWPolnrep", gipiWPolnrep);
					params.put("polFlag", polFlag);
					params.put("deleteWPolnrep", request.getParameter("deleteWPolnrep"));
					params.put("deleteBillSw", request.getParameter("deleteBillSw"));
					params.put("deleteSw", request.getParameter("deleteSw"));
					params.put("mortgCd", request.getParameter("mortgCd"));
					params.put("validateAssdName", request.getParameter("validateAssdName"));
					params.put("validatedBookingDate", request.getParameter("validatedBookingDate"));
					params.put("assdName", request.getParameter("assuredName"));
					params.put("ora2010Sw", request.getParameter("ora2010Sw"));
					params.put("deleteWorkingDistSw", request.getParameter("deleteWorkingDistSw"));
					params.put("userId", USER.getUserId());
					params.put("deleteCommInvoice", request.getParameter("deleteCommInvoice"));
					
					if ("Y".equals(params.get("ora2010Sw"))){
						params.put("generateBankDtls", (request.getParameter("generateBankDtls") == null ? "N" :"Y"));
						if ("".equals(gipiWPolbas.getBankRefNo())){
							if ("Y".equals(params.get("generateBankDtls"))){
								params.put("selNbtAcctIssCd", (request.getParameter("selNbtAcctIssCd") == null ? "" :request.getParameter("selNbtAcctIssCd")));
								params.put("selNbtBranchCd", (request.getParameter("selNbtBranchCd") == null ? "" :request.getParameter("selNbtBranchCd")));
							}
						}	
					}
					List<GIUWPolDist> polDistList = distService.getGIUWPolDist(gipiWPolbas.getParId() , null);
					params.put("giuwPolDistList", polDistList);
							
					Map<String, Object> paramsResult = new HashMap<String, Object>();
					paramsResult = gipiWPolbasService.saveGipiWPolbasForBond(params);
					message = (new JSONObject(StringFormatter.replaceQuotesInMap(paramsResult))).toString();
					
					
					
					PAGE = "/pages/genericMessage.jsp";
				} else if("checkOldBondNoExist".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					Map<String, String> params = new HashMap();
					params.put("parId", String.valueOf(parId));
					params.put("assdNo", request.getParameter("assuredNo"));
					params.put("lineCd", lineCd);
					params.put("sublineCd", request.getParameter("wpolnrepSublineCd"));
					params.put("nbtPolicyId3", request.getParameter("wpolnrepIssCd").toUpperCase());
					params.put("nbtPolicyId4", request.getParameter("wpolnrepIssueYy"));
					params.put("nbtPolicyId5", request.getParameter("wpolnrepPolSeqNo"));
					params.put("nbtRenewNo", request.getParameter("wpolnrepRenewNo"));
					params.put("polFlag", request.getParameter("polFlag"));
					
					message = gipiWPolbasService.checkOldBondNoExist(params);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("validateRenewalDuration".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
					Map<String, Object> params = new HashMap();
					params.put("lineCd", lineCd);
					params.put("sublineCd", request.getParameter("wpolnrepSublineCd"));
					params.put("nbtPolicyId3", request.getParameter("wpolnrepIssCd").toUpperCase());
					params.put("nbtPolicyId4", request.getParameter("wpolnrepIssueYy"));
					params.put("nbtPolicyId5", request.getParameter("wpolnrepPolSeqNo"));
					params.put("nbtRenewNo", request.getParameter("wpolnrepRenewNo"));
					params.put("doi", sdf.parse(request.getParameter("doi")));
					
					message = gipiWPolbasService.validateRenewalDuration(params);
					PAGE = "/pages/genericMessage.jsp";
				}else if ("validateBookingDate".equals(ACTION)){
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					Integer bookingYear = request.getParameter("bookingYear")==null ? null :Integer.parseInt(request.getParameter("bookingYear"));
					String bookingMth = request.getParameter("bookingMth");
					String issueDate = request.getParameter("issueDate");
					String inceptDate = request.getParameter("doi");
					System.out.println("validateBookingDate: "+bookingYear+", "+bookingMth+", "+issueDate+", "+inceptDate);
					message = gipiWPolbasService.validateBookingDate(bookingYear, bookingMth, issueDate, inceptDate);
					PAGE = "/pages/genericMessage.jsp";
				} else if ("getBondSeqNoList".equals(ACTION)){
					List<Integer> bondSeqNoList = this.getBondSeqNoList(request, (GIPIBondSeqHistService) APPLICATION_CONTEXT.getBean("gipiBondSeqHistService"));
					message = new JSONArray(bondSeqNoList).toString();
					PAGE = "/pages/genericMessage.jsp";
				} else if ("updBondSeqHist".equals(ACTION)){
					this.updBondSeqHist(request, (GIPIBondSeqHistService) APPLICATION_CONTEXT.getBean("gipiBondSeqHistService"));
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				} else if ("validateBondSeq".equals(ACTION)){
					GIPIBondSeqHistService bondSequenceService = (GIPIBondSeqHistService) APPLICATION_CONTEXT.getBean("gipiBondSeqHistService");
					Map<String, Object> param = new HashMap<String, Object>();
					param.put("lineCd", request.getParameter("lineCd"));
					param.put("sublineCd", request.getParameter("sublineCd"));
					param.put("seqNo", Integer.parseInt(request.getParameter("seqNo")));
					param.put("parId", Integer.parseInt(request.getParameter("parId")));
					log.info("Validating bond sequence: " + param);
					if (bondSequenceService.isValidBondSeq(param)){
						message = "VALID";
					} else {
						message = "INVALID";
					}
					PAGE = "/pages/genericMessage.jsp";
				}else if("getProdTakeUp".equals(ACTION)){	// shan 10.14.2014
					GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
					message = giacParamService.getParamValueN("PROD_TAKE_UP").toString();
					PAGE = "/pages/genericMessage.jsp";
				}else if("checkParPostedBinder".equals(ACTION)){ // shan 10.14.2014
					GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
					message = gipiWPolbasService.checkParPostedBinder(parId);
					PAGE = "/pages/genericMessage.jsp";
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
	
	private GIPIWPolnrep prepareGipiWPolnrep(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER){
		GIPIWPolnrep gipiWPolnrep = new GIPIWPolnrep();
		
		Integer oldPolicyId = request.getParameter("oldPolicyId")  == null || request.getParameter("oldPolicyId").equals("") ? null :Integer.parseInt(request.getParameter("oldPolicyId"));
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		
		gipiWPolnrep.setParId(parId);
		gipiWPolnrep.setUserId(USER.getUserId());
		gipiWPolnrep.setOldPolicyId(oldPolicyId);
		
		return gipiWPolnrep;
	}
	
	private GIPIWPolbas prepareGipiWPolbas(HttpServletRequest request, 
			HttpServletResponse response, GIISUser USER) throws ParseException {
		log.info("Preparing GipiWPolbas start...");
		GIPIWPolbas gipiWPolbas = new GIPIWPolbas();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		int parId = Integer.parseInt((request.getParameter("parId") == null) || (request.getParameter("parId") == "") ? "0" : request.getParameter("parId"));
		gipiWPolbas.setParId(parId);
		gipiWPolbas.setUserId(USER.getUserId());
		gipiWPolbas.setLineCd(request.getParameter("lineCd"));
		gipiWPolbas.setInvoiceSw(((request.getParameter("invoiceSw")== null) || (request.getParameter("invoiceSw") == "") ? "N" : request.getParameter("invoiceSw")));
		gipiWPolbas.setSublineCd(request.getParameter("sublineCd"));
		gipiWPolbas.setPolFlag(request.getParameter("policyStatus"));
		gipiWPolbas.setManualRenewNo(request.getParameter("manualRenewNo"));
		//gipiWPolbas.setTypeCd(request.getParameter("typeOfPolicy"));
		gipiWPolbas.setAddress1(request.getParameter("address1"));
		gipiWPolbas.setAddress2(request.getParameter("address2"));
		gipiWPolbas.setAddress3(request.getParameter("address3"));
		gipiWPolbas.setDesignation(request.getParameter("designation"));
		gipiWPolbas.setIssCd(request.getParameter("issCd"));
		//gipiWPolbas.setCredBranch(request.getParameter("creditingBranch") == null || request.getParameter("creditingBranch") == "" ? request.getParameter("credBranch") :request.getParameter("creditingBranch")); //christian 03/08/2013
		gipiWPolbas.setCredBranch(request.getParameter("creditingBranch")); //added by steven 11.25.2014 - remove the code above
		gipiWPolbas.setAssdNo(request.getParameter("assuredNo"));
		//gipiWPolbas.setAcctOfCd(request.getParameter("acctOfCd"));
		gipiWPolbas.setPlaceCd(request.getParameter("issuePlace"));
		//gipiWPolbas.setRiskTag(request.getParameter("riskTag"));
		gipiWPolbas.setRefPolNo(request.getParameter("referencePolicyNo"));
		gipiWPolbas.setIndustryCd(request.getParameter("industry"));
		gipiWPolbas.setRegionCd(request.getParameter("region"));
		gipiWPolbas.setQuotationPrintedSw(((request.getParameter("quotationPrintedSw") == null) || (request.getParameter("quotationPrintedSw") == "") ? "N" : request.getParameter("quotationPrintedSw")));
		gipiWPolbas.setCovernotePrintedSw(((request.getParameter("covernotePrintedSw") == null) || (request.getParameter("covernotePrintedSw") == "") ? "N" : request.getParameter("covernotePrintedSw")));
		gipiWPolbas.setPackPolFlag(((request.getParameter("packPolFlag") == null) || (request.getParameter("packPolFlag") == "") ? "N" : request.getParameter("packPolFlag")));
		gipiWPolbas.setAutoRenewFlag(((request.getParameter("autoRenewFlag") == null) || (request.getParameter("autoRenewFlag") == "") ? "N" : request.getParameter("autoRenewFlag")));
		gipiWPolbas.setForeignAccSw(((request.getParameter("foreignAccSw") == null) || (request.getParameter("foreignAccSw") == "") ? "N" : request.getParameter("foreignAccSw")));
		gipiWPolbas.setRegPolicySw(((request.getParameter("regPolicySw") == null) || (request.getParameter("regPolicySw") == "") ? "N" : request.getParameter("regPolicySw")));
		//gipiWPolbas.setPremWarrTag(((request.getParameter("premWarrTag") == null) || (request.getParameter("premWarrTag") == "") ? "N" : request.getParameter("premWarrTag")));
		//gipiWPolbas.setPremWarrDays(request.getParameter("premWarrDays"));
		//gipiWPolbas.setFleetPrintTag(((request.getParameter("fleetTag") == null) || (request.getParameter("fleetTag") == "") ? "N" : request.getParameter("fleetTag")));
		//gipiWPolbas.setWithTariffSw(((request.getParameter("wTariff") == null) || (request.getParameter("wTariff") == "") ? "N" : request.getParameter("wTariff")));
		gipiWPolbas.setProvPremTag(((request.getParameter("provPremTag") == null) || (request.getParameter("provPremTag") == "") ? "N" : request.getParameter("provPremTag")));
		//gipiWPolbas.setProvPremPct(((request.getParameter("provisionalPremium") == null) || (request.getParameter("provisionalPremium") == "") ? "" : request.getParameter("provPremRatePercent")));
		gipiWPolbas.setInceptTag(((request.getParameter("inceptTag") == null) || (request.getParameter("inceptTag") == "") ? "N" : request.getParameter("inceptTag")));
		gipiWPolbas.setExpiryTag(((request.getParameter("expiryTag") == null) || (request.getParameter("expiryTag") == "") ? "N" : request.getParameter("expiryTag")));
		//added by robert GENQA SR 4825 08.03.15
		gipiWPolbas.setProrateFlag(request.getParameter("prorateFlag") != null && !request.getParameter("prorateFlag").isEmpty() ? request.getParameter("prorateFlag") : "2");
		gipiWPolbas.setCompSw(((gipiWPolbas.getProrateFlag().equals("1")) ? request.getParameter("compSw") : "N"));
		gipiWPolbas.setShortRtPercent((gipiWPolbas.getProrateFlag().equals("3")) ? request.getParameter("shortRatePercent") : "");
		// end robert GENQA SR 4825 08.03.15
		gipiWPolbas.setBookingYear(request.getParameter("bookingYear"));
		gipiWPolbas.setBookingMth(request.getParameter("bookingMth"));
		gipiWPolbas.setCoInsuranceSw(request.getParameter("coInsuranceSw"));
		gipiWPolbas.setTakeupTerm(request.getParameter("takeupTermType"));
		gipiWPolbas.setRenewNo(request.getParameter("renewNo"));
		gipiWPolbas.setIssueYy(Integer.parseInt(request.getParameter("issueYy")));
		gipiWPolbas.setSamePolnoSw(((request.getParameter("samePolnoSw") == null) || (request.getParameter("samePolnoSw") == "") ? "N" : request.getParameter("samePolnoSw")));
		gipiWPolbas.setEndtYy(request.getParameter("endtYy"));
		gipiWPolbas.setEndtSeqNo(request.getParameter("endtSeqNo"));
		gipiWPolbas.setUpdateIssueDate(request.getParameter("updateIssueDate"));
		gipiWPolbas.setMortgName(request.getParameter("mortG"));
		gipiWPolbas.setValidateTag(request.getParameter("validateTag"));
		gipiWPolbas.setDspAssdName(request.getParameter("assuredName")); // Rey 11-07-2011 for the assuredName
		gipiWPolbas.setBondAutoPrem(request.getParameter("bondAutoPrem") == null ? "N" : request.getParameter("bondAutoPrem")); //added by robert GENQA SR 4828 08.27.15
		gipiWPolbas.setIssueDate(sdf.parse(request.getParameter("issueDate")));
		gipiWPolbas.setInceptDate(sdf.parse(request.getParameter("doi")));
		gipiWPolbas.setExpiryDate(sdf.parse(request.getParameter("doe")));
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
		}
		if (!(request.getParameter("selBondSeqNo") == null)){
			gipiWPolbas.setBondSeqNo(Integer.parseInt(request.getParameter("selBondSeqNo")));
		}
		log.info("Preparing GipiWPolbas end...");
		return gipiWPolbas;
	}
	
	private List<Integer> getBondSeqNoList(HttpServletRequest request, GIPIBondSeqHistService bondSequenceService) throws SQLException{
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("sublineCd", request.getParameter("sublineCd"));
		param.put("parId", Integer.parseInt(request.getParameter("parId")));
		return bondSequenceService.getBondSeqNoList(param);
	}
	
	/**
	 * @param request
	 * @param bondSequenceService
	 * @throws SQLException
	 * Updates the record with the specified seqNo, lineCd, and sublineCd with the supplied parId.
	 * If oldSeqNo is supplied, updates its record and clears its parId. 
	 */
	private void updBondSeqHist(HttpServletRequest request, GIPIBondSeqHistService bondSequenceService) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		if (!request.getParameter("seqNo").isEmpty()){
			param.put("sublineCd", request.getParameter("sublineCd"));
			param.put("parId", Integer.parseInt(request.getParameter("parId")));
			param.put("seqNo", Integer.parseInt(request.getParameter("seqNo")));
			log.info("updating gipi_bond_seq_hist: " + param);
			bondSequenceService.updBondSeqHist(param);
		}
		
		if (!request.getParameter("oldSeqNo").isEmpty()){
			param.put("sublineCd", request.getParameter("oldSublineCd"));
			param.put("parId", null);
			param.put("seqNo", Integer.parseInt(request.getParameter("oldSeqNo")));
			log.info("updating gipi_bond_seq_hist: " + param);
			bondSequenceService.updBondSeqHist(param);
		}
	}
	
}
