/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISAssuredIndividualInformation;
import com.geniisys.common.entity.GIISGroup;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIISAssuredController.
 */
public class GIISAssuredController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6053256358005122209L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISAssuredController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException { //, String env
		log.info("");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			
			/* definition of services needed */
			GIISAssuredFacadeService giisAssuredService = (GIISAssuredFacadeService) APPLICATION_CONTEXT.getBean("giisAssuredFacadeService"); // +env
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); // +env
			GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService"); 
			
			if("maintainAssured".equalsIgnoreCase(ACTION)) {
				request.setAttribute("industryList", lovHelper.getList(LOVHelper.INDUSTRY_LISTING));
				request.setAttribute("controlTypeList", lovHelper.getList(LOVHelper.CONTROL_TYPE_LISTING));
				String[] domainDesignation = {"GIIS_ASSURED.DESIGNATION"};
				request.setAttribute("designations", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainDesignation));
				String[] domainSuffices = {"GIIS_ASSURED.SUFFIX"};
				request.setAttribute("suffices", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSuffices));
				String[] domainCNT = {"GIIS_ASSURED.CONTACT_NO_TYPE"};
				request.setAttribute("contactNoTypes", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCNT));
				request.setAttribute("assuredList", StringFormatter.replaceQuotesInObject(giisAssuredService.getAssuredLovList()));
				String defaultReason = giisParametersService.getParamValueV2("DEFAULT_REASON");
				request.setAttribute("defaultReason", defaultReason);
				request.setAttribute("mgrSw", USER.getMgrSw());
				request.setAttribute("nameOrder", giisParametersService.getParamValueN("ASSURED_NAME_ORDER"));
				request.setAttribute("requireDfltIntmPerAssd", giisParametersService.getParamValueV2("REQUIRE_DEFAULT_INTM_PER_ASSURED")); //benjo 09.07.2016 SR-5604
				request.setAttribute("requireAssdBirthmonth", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHMONTH"));
				request.setAttribute("requireAssdBirthdate", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHDATE"));
				request.setAttribute("requireAssdBirthyear", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHYEAR"));
				request.setAttribute("requireAssdEmail", giisParametersService.getParamValueV2("REQUIRE_ASSD_EMAIL"));
				request.setAttribute("requireAssdContactno", giisParametersService.getParamValueV2("REQUIRE_ASSD_CONTACTNO"));
				request.setAttribute("requireAssdFieldsOptional", giisParametersService.getParamValueV2("ALLOW_ASSD_FIELDS_OPTIONAL"));
				request.setAttribute("defaultAssdControlType", giisParametersService.getParamValueV2("DEFAULT_ASSD_CONTROL_TYPE"));
				Calendar cal=Calendar.getInstance();
				request.setAttribute("systemYear", cal.get(Calendar.YEAR));
								
				if (!"".equals(request.getParameter("assuredNo"))) {
					Integer assdNo = Integer.parseInt(request.getParameter("assuredNo"));
					request.setAttribute("assured", StringFormatter.replaceQuotesInObject(giisAssuredService.getGiisAssuredDetails(assdNo)));
					request.setAttribute("vLine", giisAssuredService.getPostQueryGiiss006b(assdNo));
				}
				
				if (!"".equals(request.getParameter("divToShow"))) {
					request.setAttribute("divToShow", request.getParameter("divToShow"));
				}
				
				PAGE = "/pages/common/assured/assuredMaintenance.jsp";
			}else  if("maintainAssured2".equalsIgnoreCase(ACTION)) { /*added by MarkS SR5677 12.9.2016 created because in original it gets the list of assured but was not used in the function that called it*/
				request.setAttribute("industryList", lovHelper.getList(LOVHelper.INDUSTRY_LISTING));
				request.setAttribute("controlTypeList", lovHelper.getList(LOVHelper.CONTROL_TYPE_LISTING));
				String[] domainDesignation = {"GIIS_ASSURED.DESIGNATION"};
				request.setAttribute("designations", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainDesignation));
				String[] domainSuffices = {"GIIS_ASSURED.SUFFIX"};
				request.setAttribute("suffices", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainSuffices));
				String[] domainCNT = {"GIIS_ASSURED.CONTACT_NO_TYPE"};
				request.setAttribute("contactNoTypes", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, domainCNT));
				/*request.setAttribute("assuredList", StringFormatter.replaceQuotesInObject(giisAssuredService.getAssuredLovList())); *//*commented by MarkS SR5677 12.9.2016 optimization*/
				String defaultReason = giisParametersService.getParamValueV2("DEFAULT_REASON");
				request.setAttribute("defaultReason", defaultReason);
				request.setAttribute("mgrSw", USER.getMgrSw());
				request.setAttribute("nameOrder", giisParametersService.getParamValueN("ASSURED_NAME_ORDER"));
				request.setAttribute("requireDfltIntmPerAssd", giisParametersService.getParamValueV2("REQUIRE_DEFAULT_INTM_PER_ASSURED")); //benjo 09.07.2016 SR-5604
				request.setAttribute("requireAssdBirthmonth", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHMONTH"));
				request.setAttribute("requireAssdBirthdate", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHDATE"));
				request.setAttribute("requireAssdBirthyear", giisParametersService.getParamValueV2("REQUIRE_ASSD_BIRTHYEAR"));
				request.setAttribute("requireAssdEmail", giisParametersService.getParamValueV2("REQUIRE_ASSD_EMAIL"));
				request.setAttribute("requireAssdContactno", giisParametersService.getParamValueV2("REQUIRE_ASSD_CONTACTNO"));
				request.setAttribute("requireAssdFieldsOptional", giisParametersService.getParamValueV2("ALLOW_ASSD_FIELDS_OPTIONAL"));
				request.setAttribute("defaultAssdControlType", giisParametersService.getParamValueV2("DEFAULT_ASSD_CONTROL_TYPE"));
				Calendar cal=Calendar.getInstance();
				request.setAttribute("systemYear", cal.get(Calendar.YEAR));
								
				if (!"".equals(request.getParameter("assuredNo"))) {
					Integer assdNo = Integer.parseInt(request.getParameter("assuredNo"));
					request.setAttribute("assured", StringFormatter.replaceQuotesInObject(giisAssuredService.getGiisAssuredDetails(assdNo)));
					request.setAttribute("vLine", giisAssuredService.getPostQueryGiiss006b(assdNo));
				}
				
				if (!"".equals(request.getParameter("divToShow"))) {
					request.setAttribute("divToShow", request.getParameter("divToShow"));
				}
				
				PAGE = "/pages/common/assured/assuredMaintenance.jsp";
			}
			else if ("saveAssured".equals(ACTION))	{
				GIISAssured assured = new GIISAssured();
				assured.setAssdNo(Integer.parseInt(request.getParameter("generatedAssuredNo").equals("") ? "0" : request.getParameter("generatedAssuredNo")));
				//assured.setAssdName("".equals(request.getParameter("corporateName")) ? request.getParameter("lastName")+", " + request.getParameter("firstName")+" "+request.getParameter("suffix")+" "+request.getParameter("middleInitial")+"." : ("".equals(request.getParameter("lastName")) ? "" : request.getParameter("lastName")+", ") + request.getParameter("firstName")+" "+request.getParameter("corporateName"));
				//assured.setAssdName(request.getParameter("assuredName").trim());
				assured.setAssdName(request.getParameter("assuredNameMaint").trim());
				assured.setGovtTag(2);
				assured.setTransactionDate(new Date());
				assured.setDesignation(request.getParameter("designation"));
				assured.setGsisNo(request.getParameter("gsisNo"));
				assured.setAssuredTIN(request.getParameter("tinNo"));
				assured.setMailAddress1(request.getParameter("mailAddress1"));
				assured.setMailAddress2(request.getParameter("mailAddress2"));
				assured.setMailAddress3(request.getParameter("mailAddress3"));
				assured.setBillingAddress1("".equals(request.getParameter("billAddress1")) ? request.getParameter("mailAddress1") : request.getParameter("billAddress1"));
				assured.setBillingAddress2("".equals(request.getParameter("billAddress2")) ? request.getParameter("mailAddress2") : request.getParameter("billAddress2"));
				assured.setBillingAddress3("".equals(request.getParameter("billAddress3")) ? request.getParameter("mailAddress3") : request.getParameter("billAddress3"));
				assured.setContactPersons(request.getParameter("contactPerson"));
				assured.setPhoneNo(request.getParameter("phoneNo"));
				assured.setIndustryCd(Integer.parseInt(request.getParameter("industry").equals("") ? "0" : request.getParameter("industry")));
				assured.setGovtType(2);
				assured.setReferenceNo(request.getParameter("referenceCode"));
				assured.setCorporateTag(request.getParameter("corporateTag"));
				assured.setFirstName(request.getParameter("firstName").trim());
				assured.setLastName(request.getParameter("lastName").trim());
				assured.setMiddleInitial(request.getParameter("middleInitial").trim());
				assured.setSuffix(request.getParameter("suffix"));
				assured.setUserId(USER.getUserId());
				assured.setRemarks(request.getParameter("remarks"));
				assured.setParentAssuredNo(request.getParameter("parentAssdNo").equals("") || request.getParameter("parentAssdNo") == null ? null : Integer.parseInt(request.getParameter("parentAssdNo")));
				assured.setParentAssuredName(request.getParameter("parentAssdName"));
				if("C".equals(request.getParameter("corporateTag"))) {
					assured.setAssuredName2(request.getParameter("assuredName2Corp").trim());
				} else {
					assured.setAssuredName2(request.getParameter("assuredName2").trim());
				}
				assured.setAssuredTIN(request.getParameter("tinNo"));
				assured.setCpNo(request.getParameter("cpNo"));
				assured.setSunNo(request.getParameter("sunNo"));
				assured.setGlobeNo(request.getParameter("globeNo"));
				assured.setSmartNo(request.getParameter("smartNo"));
				assured.setControlTypeCd(Integer.parseInt(request.getParameter("controlType").equals("") ? "0" : request.getParameter("controlType")));
				assured.setZipCode(request.getParameter("zipCode"));
				assured.setVatTag(request.getParameter("vatType"));
				assured.setActiveTag(request.getParameter("activeTag"));
				assured.setNoTINReason(request.getParameter("noTINReason"));
				assured.setLastUpdate(new Date());
				assured.setAppUser(USER.getUserId());
				
				//enhancement
				assured.setEmailAddress(request.getParameter("emailAddress"));
				assured.setBirthDate(request.getParameter("birthDate").equals("") ? null : Integer.parseInt(request.getParameter("birthDate")));
				assured.setBirthMonth(request.getParameter("birthmonth"));
				assured.setBirthYear(request.getParameter("birthYear").equals("") ? null : Integer.parseInt(request.getParameter("birthYear")));
				
				System.out.println("User : " + assured.getUserId());
				System.out.println("App User : " + assured.getAppUser());
				System.out.println("assd name 2 : " + assured.getAssuredName2());
				Integer assuredNo = giisAssuredService.saveAssured(assured);
				request.setAttribute("assuredNo", assuredNo);
				request.setAttribute("assdName", giisAssuredService.getGIISAssuredByAssdNo(assuredNo.toString()).getAssdName());
				message = "SUCCESS";
				PAGE = "/pages/common/subPages/assured/assuredMessage.jsp";
			} else if ("showAssuredListing".equals(ACTION)) {
				request.setAttribute("userId", USER.getUserId()); // ++rmanalad 4.12.2011
				PAGE = "/pages/common/assured/assuredListing.jsp";
				
			} else if ("openSearchAccountOf".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/searchAccountOf.jsp";
				
			} else if ("openSearchClientModal".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/searchAssured.jsp";
				
			} else if ("openSearchAssured".equals(ACTION)) {
				
				PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAssured.jsp";
				
			} else if("getAssuredListing".equalsIgnoreCase(ACTION)){
				
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
				
				if (null != request.getParameter("isFromAssuredListingMenu")) {
					JSONArrayList searchResult;
					searchResult = giisAssuredService.getAssuredList(pageNo, keyword);
					JSONObject obj = new JSONObject (StringFormatter.replaceQuotesInObject(searchResult));
										
					message = obj.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					PaginatedList searchResult = null;
					searchResult = giisAssuredService.getAssuredListing(pageNo, keyword);					
					request.setAttribute("pageNo", pageNo+1);
					//request.setAttribute("searchResult", StringFormatter.replaceQuotesInList(searchResult));
					request.setAttribute("searchResult",StringFormatter.replaceQuotesInList(StringFormatter.escapeHTMLInList(searchResult)));  // J. Diago 10.18.2013
					request.setAttribute("noOfPages", searchResult.getNoOfPages());
					if (request.getParameter("directory") == null) {
						PAGE = "/pages/pop-ups/searchAssuredAjaxResult.jsp";
					} else {
						if ("accounting".equals(request.getParameter("directory"))) {
							PAGE = "/pages/accounting/officialReceipt/pop-ups/searchAssuredAjaxResult.jsp";
						} else {
							PAGE = "/pages/pop-ups/searchAssuredAjaxResult.jsp";
						}
					}
				}
			 } else if("getAssuredTableGrid".equalsIgnoreCase(ACTION)){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("ACTION", ACTION);
					params.put("moduleId", request.getParameter("moduleId") == null ? "GIISS006" : request.getParameter("moduleId"));
					params.put("appUser", USER.getUserId());
					if("1".equals(request.getParameter("ajax"))){
						//request.setAttribute("assuredListingTableGrid", json);
						PAGE = "/pages/common/assured/assuredListingTableGrid.jsp";
					}else{
						Map<String, Object> assuredListTableGrid = TableGridUtil.getTableGrid(request, params);
						JSONObject json = new JSONObject(assuredListTableGrid);
						message = json.toString();
						PAGE = "/pages/genericMessage.jsp";
					}
				} else if("getAcctOfListing".equalsIgnoreCase(ACTION)){
				String keyword = request.getParameter("keyword");
				int assdNo = 0;
				// grace 10.26.10 initialized assdNo variable first before getting the parameter value
				// to prevent number conversion error when the assd is still null when searching for in account of value
				if (""!=request.getParameter("assdNo")) {
					assdNo = Integer.parseInt(request.getParameter("assdNo"));
				}
				if(null==keyword){
					keyword = "";
				}

				PaginatedList searchResult = null;
				Integer pageNo = 0;
				if(null!=request.getParameter("pageNo")){
					if(!"undefined".equals(request.getParameter("pageNo"))){
						pageNo = new Integer(request.getParameter("pageNo"))-1;
					}
				}
				System.out.println("Assd No.: "+assdNo);
				System.out.println("Keyword: "+keyword);
				System.out.println("Page No.: "+pageNo+1);
				//try {
					searchResult = giisAssuredService.getAcctOfList(pageNo, assdNo, keyword);
					request.setAttribute("assdNo", assdNo);
					request.setAttribute("keyword", keyword);
					request.setAttribute("searchResult",StringFormatter.replaceQuotesInList(StringFormatter.escapeHTMLInList(searchResult))); //Gzelle 10.1.2013 escapeHTML
					request.setAttribute("pageNo", searchResult.getPageIndex()+1);
					request.setAttribute("noOfPages", searchResult.getNoOfPages());
				//} catch (Exception e) {
				//	e.printStackTrace();
				//	log.debug(Arrays.toString(e.getStackTrace()));
				//}
				PAGE = "/pages/pop-ups/searchAcctOfAjaxResult.jsp";
			} else if("showGiiss006IntmDetails".equals(ACTION)) {
				JSONObject json = giisAssuredService.getAssuredIntmList(request);
				if(request.getParameter("refresh") == null){
					request.setAttribute("intmAssdNo", request.getParameter("assdNo"));
					request.setAttribute("jsonIntmList", json);
					PAGE = "/pages/common/assured/subpages/intmDetails.jsp";					
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			} else if ("showDefaultIntermediaryPage".equals(ACTION)) {
				//String[] moduleId = {request.getParameter("moduleId")}; // replaced by: nica 02.17.2011
				String[] params = {request.getParameter("moduleId"), USER.getUserId()};
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				//request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, moduleId));
				request.setAttribute("lineListing", lovHelper.getList(LOVHelper.LINE_LISTING, params));
				//request.setAttribute("intermediaries", lovHelper.getList(LOVHelper.INTM_LISTING)); //benjo 09.07.2016 SR-5604
				request.setAttribute("assdIntms", giisAssuredService.getGIISAssuredIntm(Integer.parseInt(request.getParameter("assdNo"))));
				PAGE = "/pages/common/subPages/assured/pop-ups/defaultIntermediary.jsp";
			} else if ("saveDI".equals(ACTION)) {
				String[] lineCds = request.getParameterValues("lineCds");
				int assdNo = Integer.parseInt(request.getParameter("assdNo"));
				String[] intmNos = request.getParameterValues("intmNo");
				String userId = USER.getUserId(); //marco - 11.29.2012
				
				// delete insert assured intermediary
				giisAssuredService.deleteGIISAssdIntm(assdNo);
				if(lineCds != null){
					for (int i=0; i<lineCds.length; i++) {
						giisAssuredService.saveGIISAssuredIntm(assdNo, lineCds[i], Integer.parseInt(intmNos[i].equals("") ? null : intmNos[i]), userId);
					}
				}
				
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("showIndividualInformationPage".equals(ACTION)) {
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				String[] sex = {"SEX"};
				request.setAttribute("sexes", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, sex));
				
				String[] cs = {"CIVIL STATUS"};
				request.setAttribute("civilStatuses", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, cs));
				
				String[] ho = {"HOME OWNERSHIP"};
				request.setAttribute("hos", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, ho));
				
				String[] nob = {"NATURE OF BUSINESS"};
				request.setAttribute("nobs", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, nob));
				
				String[] ea = {"EDUCATIONAL ATTAINMENT"};
				request.setAttribute("eas", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, ea));
				
				String[] e = {"EMPLOYMENT"};
				request.setAttribute("employments", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, e));
				
				String[] gai = {"GROSS ANNUAL INCOME"};
				request.setAttribute("gais", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, gai));
				
				request.setAttribute("assuredName", request.getParameter("assuredName"));
				request.setAttribute("assdIndInfo", StringFormatter.escapeHTMLInObject(giisAssuredService.getGIISAssuredIndividualInfo(Integer.parseInt(request.getParameter("assdNo"))))); //added stringformatter by reymon 02152013
				
				PAGE = "/pages/common/subPages/assured/pop-ups/individualInformation.jsp";
			} else if ("saveI".equals(ACTION)) {
				//modified by reymon 02152013
				//added StringFormatter.unescapeHTML
				DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
				GIISAssuredIndividualInformation i = new GIISAssuredIndividualInformation();
				Date birthdate = request.getParameter("birthdate").equals("") ? null : df.parse(request.getParameter("birthdate"));
				i.setAssdNo(Integer.parseInt(request.getParameter("assdNo")));
				i.setBirthdate(birthdate);
				i.setSex(request.getParameter("sex"));
				i.setStatus(StringFormatter.unescapeHTML(request.getParameter("civilStatus")));
				i.setSpouseName(StringFormatter.unescapeHTML(request.getParameter("spouseName")));
				i.setCitizenship(StringFormatter.unescapeHTML(request.getParameter("citizenship")));
				i.setEmailAddress(StringFormatter.unescapeHTML(request.getParameter("emailAddress")));
				i.setHomeOwnership(StringFormatter.unescapeHTML(request.getParameter("homeOwnership")));
				i.setYearsOfStay(Integer.parseInt(request.getParameter("yearsOfStay").equals("") ? "0" : request.getParameter("yearsOfStay")));
				i.setMortName(StringFormatter.unescapeHTML(request.getParameter("mortName")));
				// to prevent null pointer exception when the field is disabled in the jsp
				if(request.getParameter("homeOwnership").equals("M") || request.getParameter("homeOwnership").equals("R")){
					i.setRentAmt(new BigDecimal(request.getParameter("rentAmt").equals("") ? "0" : request.getParameter("rentAmt").replaceAll(",", "")));
				}else{
					i.setRentAmt(null);
				}
				i.setEducationalAttainment(StringFormatter.unescapeHTML(request.getParameter("educationalAttainment")));
				i.setNoOfCars(Integer.parseInt(request.getParameter("noOfCars").equals("") ? "0" : request.getParameter("noOfCars")));
				i.setEmployment(StringFormatter.unescapeHTML(request.getParameter("employment")));
				i.setNatureOfBusiness(StringFormatter.unescapeHTML(request.getParameter("natureOfBusiness")));
				i.setOthNature(StringFormatter.unescapeHTML(request.getParameter("othNature")));
				i.setCompanyName(StringFormatter.unescapeHTML(request.getParameter("companyName")));
				i.setCompanyAddress(StringFormatter.unescapeHTML(request.getParameter("companyAddress")));
				i.setPosition(StringFormatter.unescapeHTML(request.getParameter("position")));
				i.setGrossAnnualIncome(new BigDecimal(request.getParameter("grossAnnualIncome").equals("") ? "0" : request.getParameter("grossAnnualIncome")));
				i.setAppUser(USER.getUserId()); //added by robert 05/09/2013 SR 13023
				giisAssuredService.saveGIISAssuredIndInfo(i);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGroupInformationPage".equals(ACTION)) {
				String[] assdNo = {request.getParameter("assdNo")};
				request.setAttribute("groups", lovHelper.getList(LOVHelper.GROUP_LISTING, assdNo));
				request.setAttribute("assdNo", request.getParameter("assdNo"));
				List<GIISGroup> groupList = giisAssuredService.getGIISAssuredGroup(Integer.parseInt(request.getParameter("assdNo")));				
				request.setAttribute("assdGroups", StringFormatter.escapeHTMLInList2(groupList));
				PAGE = "/pages/common/subPages/assured/pop-ups/groupInformation.jsp";
			} else if ("saveG".equals(ACTION)) {
				int assdNo = Integer.parseInt(request.getParameter("assdNo"));
				String[] groupCds = request.getParameterValues("groupCds");
				String[] remarks = request.getParameterValues("remarks");
				String userId = USER.getUserId();

				// delete insert assured group
				giisAssuredService.deleteGIISAssdGroup(assdNo);
				/*if(groupCds != null){ // Patrick 02.21.2012
					if (groupCds.length > 0) {
						for (String groupCd: groupCds) {
						giisAssuredService.saveGIISAssuredGroup(assdNo, Integer.parseInt(groupCd));
						}
					}
				}*/
				if(groupCds != null){
					for(int i=0;i<groupCds.length;i++){
						giisAssuredService.saveGIISAssuredGroup(assdNo, Integer.parseInt(groupCds[i]), remarks[i], userId);
					}
				}
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS";
			} else if ("checkAssuredDependencies".equals(ACTION)) {
				message = giisAssuredService.checkAssuredDependencies(Integer.parseInt(request.getParameter("assdNo")));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteAssured".equals(ACTION)) {
				giisAssuredService.deleteAssured(Integer.parseInt(request.getParameter("assdNo")));
			} else if("deleteGiisAssured".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("appUser", USER.getUserId());
				giisAssuredService.deleteGiisAssured(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkExistingAssured".equals(ACTION)){
				List<GIISAssured> giisAssuredListing = new ArrayList<GIISAssured>();
				String assdName = request.getParameter("assuredName");
				System.out.println("Assured name : " + assdName);
				
				giisAssuredListing = giisAssuredService.getExistingAssured(assdName);
				
				System.out.println("Dummy : " + giisAssuredListing.size());
				
				request.setAttribute("object", new JSONArray ((List<?>) StringFormatter.replaceQuotesInList(giisAssuredListing)));
				
				PAGE = "/pages/genericObject.jsp";
			} else if ("showSameAssuredName".equals(ACTION)){
				message = "Assured is already existing.  Do you want to create a new record?";	
				request.setAttribute("firstRecord", giisAssuredService.getFirstRecord());
				PAGE = "/pages/common/assured/sameAssuredListing.jsp";
			} else if ("showSameIndiAssuredName".equals(ACTION)){
				message = "Assured with the same first name and last name already exists. Do you want to continue?";
				request.setAttribute("firstRecord", giisAssuredService.getFirstRecord());
				PAGE = "/pages/common/assured/sameAssuredListing.jsp";
			} else if ("getLinesOfPolForAssd".equals(ACTION)){
				GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				List<GIISLine> giisLines = giisLineService.getPolLinesForAssd(Integer.parseInt(request.getParameter("assdNo")));
				
				request.setAttribute("object", new JSONArray(giisLines));
				System.out.println("---------here--------------------");
				PAGE = "/pages/genericObject.jsp";
				
			} else if ("checkAssdMobileNo".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				String cellNo = request.getParameter("cellNo") == null ? "" : request.getParameter("cellNo");
				params.put("cellNo", cellNo);
				params.put("msg", "");
				params.put("network", "");
				params = giisAssuredService.checkAssdMobileNo(params);
				String msg = (String) (params.get("msg") == null ? "" : params.get("msg"));
				String network = (String) (params.get("network") == null ? "" : params.get("network"));
				message= network + "," + msg;
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkRefCd".equals(ACTION)) {
				String msg = giisAssuredService.checkRefCd(request.getParameter("refCd"));
				message= msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkRefCd2".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("refCd", request.getParameter("refCd"));
				params.put("assdNo", request.getParameter("assdNo"));
				String msg = giisAssuredService.checkRefCd2(params);
				message= msg;
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkAssuredExistGiiss006b".equals(ACTION)) {
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				message = giisAssuredService.checkAssuredExistGiiss006b(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkAssuredExistGiiss006b2".equals(ACTION)) {
				Map<String, Object>params = FormInputUtil.getFormInputs(request);
				System.out.println(params);
				message = giisAssuredService.checkAssuredExistGiiss006b2(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGiiss006bExistingAssdTg".equals(ACTION)) {
				
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params.put("ACTION", ACTION);
				params = TableGridUtil.getTableGrid(request, params);
				
				//JSONObject jsonExistingAssured = new JSONObject(params);
				String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
				if("1".equals(request.getParameter("refresh"))){
					message = grid;
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonExistingAssured", grid);
					PAGE = "/pages/common/assured/subpages/existingAssuredTG.jsp";
				}
			} else if("valDeleteGroupInfo".equals(ACTION)){
				giisAssuredService.valDeleteGroupInfo(request);
				message = "SUCCESS";
			}else if("checkDfltIntm".equals(ACTION)){ //benjo 09.07.2016 SR-5604
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", request.getParameter("assdNo"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				message = giisAssuredService.checkDfltIntm(params);
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
		} catch (NullPointerException e) {
			//log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			//log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}