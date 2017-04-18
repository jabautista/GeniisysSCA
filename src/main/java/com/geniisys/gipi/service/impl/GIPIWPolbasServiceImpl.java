/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.io.UnsupportedEncodingException;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
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
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.gipi.dao.GIPIWPolbasDAO;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIQuotePictures;
import com.geniisys.gipi.entity.GIPIRefNoHist;
import com.geniisys.gipi.entity.GIPIWEndtText;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.geniisys.gipi.entity.GIPIWPicture;
import com.geniisys.gipi.entity.GIPIWPolGenin;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.geniisys.gipi.service.GIPIPARListService;
import com.geniisys.gipi.service.GIPIParMortgageeFacadeService;
import com.geniisys.gipi.service.GIPIWDeductibleFacadeService;
import com.geniisys.gipi.service.GIPIWEndtTextService;
import com.geniisys.gipi.service.GIPIWInvoiceFacadeService;
import com.geniisys.gipi.service.GIPIWItemPerilService;
import com.geniisys.gipi.service.GIPIWItemService;
import com.geniisys.gipi.service.GIPIWOpenPolicyService;
import com.geniisys.gipi.service.GIPIWPolGeninService;
import com.geniisys.gipi.service.GIPIWPolbasService;
import com.geniisys.gipi.service.GIPIWPolnrepFacadeService;
import com.geniisys.gipi.service.GIPIWinvTaxFacadeService;
import com.geniisys.gipi.util.GIPIPARUtil;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIPIWPolbasServiceImpl.
 */
public class GIPIWPolbasServiceImpl implements GIPIWPolbasService {

	private static Logger log = Logger.getLogger(GIPIWPolbasServiceImpl.class);
	
	/** The gipi w polbas dao. */
	private GIPIWPolbasDAO gipiWPolbasDAO;	
	private GIPIPARListService gipiParListService;
	private GIPIWPolGeninService gipiWPolGeninService;
	private GIPIWEndtTextService gipiWEndtTextService;
	private GIPIWOpenPolicyService gipiWOpenPolicyService;
	private GIISAssuredFacadeService giisAssuredService;
	private GIPIWItemService gipiWItemService;
	private GIPIWDeductibleFacadeService gipiWDeductibleService;
	private GIPIParMortgageeFacadeService gipiWMortgageeService;
	private GIPIWItemPerilService gipiWItemPerilService;
	
	/**
	 * Gets the gipi w polbas dao.
	 * 
	 * @return the gipi w polbas dao
	 */
	public GIPIWPolbasDAO getGipiWPolbasDAO() {
		return gipiWPolbasDAO;
	}

	/**
	 * Sets the gipi w polbas dao.
	 * 
	 * @param gipiWPolbasDAO the new gipi w polbas dao
	 */
	public void setGipiWPolbasDAO(GIPIWPolbasDAO gipiWPolbasDAO) {
		this.gipiWPolbasDAO = gipiWPolbasDAO;
	}	
	
	public GIPIPARListService getGipiParListService() {
		return gipiParListService;
	}

	public void setGipiParListService(GIPIPARListService gipiParListService) {
		this.gipiParListService = gipiParListService;
	}

	public GIPIWPolGeninService getGipiWPolGeninService() {
		return gipiWPolGeninService;
	}

	public void setGipiWPolGeninService(GIPIWPolGeninService gipiWPolGeninService) {
		this.gipiWPolGeninService = gipiWPolGeninService;
	}	

	public GIPIWEndtTextService getGipiWEndtTextService() {
		return gipiWEndtTextService;
	}

	public void setGipiWEndtTextService(GIPIWEndtTextService gipiWEndtTextService) {
		this.gipiWEndtTextService = gipiWEndtTextService;
	}	

	public GIPIWOpenPolicyService getGipiWOpenPolicyService() {
		return gipiWOpenPolicyService;
	}

	public void setGipiWOpenPolicyService(
			GIPIWOpenPolicyService gipiWOpenPolicyService) {
		this.gipiWOpenPolicyService = gipiWOpenPolicyService;
	}	

	public GIISAssuredFacadeService getGiisAssuredService() {
		return giisAssuredService;
	}

	public void setGiisAssuredService(GIISAssuredFacadeService giisAssuredService) {
		this.giisAssuredService = giisAssuredService;
	}

	public GIPIWItemService getGipiWItemService() {
		return gipiWItemService;
	}

	public void setGipiWItemService(GIPIWItemService gipiWItemService) {
		this.gipiWItemService = gipiWItemService;
	}

	public GIPIWDeductibleFacadeService getGipiWDeductibleService() {
		return gipiWDeductibleService;
	}

	public void setGipiWDeductibleService(
			GIPIWDeductibleFacadeService gipiWDeductibleService) {
		this.gipiWDeductibleService = gipiWDeductibleService;
	}

	public GIPIParMortgageeFacadeService getGipiWMortgageeService() {
		return gipiWMortgageeService;
	}

	public void setGipiWMortgageeService(
			GIPIParMortgageeFacadeService gipiWMortgageeService) {
		this.gipiWMortgageeService = gipiWMortgageeService;
	}

	public GIPIWItemPerilService getGipiWItemPerilService() {
		return gipiWItemPerilService;
	}

	public void setGipiWItemPerilService(GIPIWItemPerilService gipiWItemPerilService) {
		this.gipiWItemPerilService = gipiWItemPerilService;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#getGipiWPolbas(int)
	 */
	@Override
	public GIPIWPolbas getGipiWPolbas(int parId) throws SQLException {
		//return (GIPIWPolbas) StringFormatter.replaceQuotesInObject(gipiWPolbasDAO.getGipiWPolbas(parId)); commented and replaced by reymon 02192013
		return (GIPIWPolbas) StringFormatter.escapeHTMLInObject(gipiWPolbasDAO.getGipiWPolbas(parId));
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#getGipiWPolbasDefault(int)
	 */
	@Override
	public GIPIWPolbas getGipiWPolbasDefault(int parId) throws SQLException {
		//return (GIPIWPolbas) StringFormatter.replaceQuotesInObject(gipiWPolbasDAO.getGipiWPolbasDefault(parId)); commented and replaced by reymon 02192013
		return (GIPIWPolbas) StringFormatter.escapeHTMLInObject(gipiWPolbasDAO.getGipiWPolbasDefault(parId));
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#saveGipiWPolbas(com.geniisys.gipi.entity.GIPIWPolbas)
	 */
	@Override
	public void saveGipiWPolbas(GIPIWPolbas gipiWPolbas) throws SQLException {
		this.gipiWPolbasDAO.saveGipiWPolbas(gipiWPolbas);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateSubline(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String validateSubline(Integer parId, String lineCd, String sublineCd,
			String paramSublineCd) throws SQLException {
		return gipiWPolbasDAO.validateSubline(parId,lineCd,sublineCd,paramSublineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateAssdName(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void validateAssdName(Integer parId, String lineCd, String issCd)
			throws SQLException {
		this.gipiWPolbasDAO.validateAssdName(parId, lineCd,issCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateBookingDate(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String validateBookingDate(Integer bookingYear,
			String bookingMth, String issueDate, String inceptDate)
			throws SQLException {
		return gipiWPolbasDAO.validateBookingDate(bookingYear, bookingMth, issueDate, inceptDate);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateTakeupTerm(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> validateTakeupTerm(Integer parId, String lineCd,
			String issCd) throws SQLException {
		return gipiWPolbasDAO.validateTakeupTerm(parId, lineCd, issCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateCoInsurance(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String validateCoInsurance(Integer parId, Integer coInsurance)
			throws SQLException {
		return this.gipiWPolbasDAO.validateCoInsurance(parId, coInsurance);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateCoInsurance2(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void validateCoInsurance2(Integer parId, Integer coInsurance)
			throws SQLException {
		this.gipiWPolbasDAO.validateCoInsurance2(parId, coInsurance);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#deleteBill(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void deleteBill(Integer parId, Integer coInsurance)
			throws SQLException {
		this.gipiWPolbasDAO.deleteBill(parId, coInsurance);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#insertParHist(java.lang.Integer, java.lang.String)
	 */
	@Override
	public void insertParHist(Integer parId, String userId) throws SQLException {
		this.gipiWPolbasDAO.insertParHist(parId, userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#postFormsCommitD(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public void postFormsCommitD(Integer parId, Integer assdNo)
			throws SQLException {
		this.gipiWPolbasDAO.postFormsCommitD(parId, assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#updateParStatus(java.lang.Integer)
	 */
	@Override
	public void updateParStatus(Integer parId) throws SQLException {
		this.gipiWPolbasDAO.updateParStatus(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		return this.gipiWPolbasDAO.isExist(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#getGipiWpolbasCommon(int)
	 */
	@Override
	public GIPIWPolbas getGipiWpolbasCommon(int parId) throws SQLException {
		return this.getGipiWPolbasDAO().getGipiWpolbasCommon(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#createWinvoice(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void createWinvoice(Integer parId, String lineCd, String issCd)
			throws SQLException {
		this.gipiWPolbasDAO.createWinvoice(parId,lineCd,issCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateRefPolNo(java.lang.Integer, java.lang.String)
	 */
	@Override
	public String validateRefPolNo(Integer parId, String refPolNo)
			throws SQLException {
		return this.gipiWPolbasDAO.validateRefPolNo(parId, refPolNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#newFormInst(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, String> newFormInst(HttpServletRequest request, Integer parId, String issCd, String lineCd, ApplicationContext APPLICATION_CONTEXT) throws SQLException {
		GIPIWPolbasService gipiWPolbasService = (GIPIWPolbasService) APPLICATION_CONTEXT.getBean("gipiWPolbasService");
		GIISParameterFacadeService giisParametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		GIPIWPolnrepFacadeService gipiWPolnrepService = (GIPIWPolnrepFacadeService) APPLICATION_CONTEXT.getBean("gipiWPolnrepFacadeService");
		GIPIWOpenPolicyService gipiWOpenPolicyService = (GIPIWOpenPolicyService) APPLICATION_CONTEXT.getBean("gipiWOpenPolicyService");
		GIPIWInvoiceFacadeService gipiWInvoiceService = (GIPIWInvoiceFacadeService) APPLICATION_CONTEXT.getBean("gipiWInvoiceFacadeService"); 
		LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
		GIISLineFacadeService giisLineFacadeService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
		GIPIPARListService gipiParService = (GIPIPARListService) APPLICATION_CONTEXT.getBean("gipiPARListService");//+env);
		GIPIWItemPerilService gipiWItemPerilService = (GIPIWItemPerilService) APPLICATION_CONTEXT.getBean("gipiWItemPerilService");
		GIPIWinvTaxFacadeService gipiWinvTaxService = (GIPIWinvTaxFacadeService) APPLICATION_CONTEXT.getBean("gipiWinvTaxFacadeService"); // +env
		GIPIWPolGeninService gipiWPolGeninService = (GIPIWPolGeninService) APPLICATION_CONTEXT.getBean("gipiWPolGeninService");
		GIPIWItemService gipiwItemService = (GIPIWItemService) APPLICATION_CONTEXT.getBean("gipiWItemService");	//added by Gzelle 10032014
		
		GIPIPARList gipiParList = null;
		gipiParList = gipiParService.getGIPIPARDetails(parId);
		request.setAttribute("gipiParList", gipiParList);
		request.setAttribute("jsonGIPIPARList", new JSONObject((GIPIPARList) StringFormatter.replaceQuotesInObject(gipiParList)));
		
		GIPIWPolGenin gipiWPolGenin = null;
		gipiWPolGenin = gipiWPolGeninService.getGipiWPolGenin(parId);
		//request.setAttribute("gipiWPolGenin", gipiWPolGenin);
		request.setAttribute("gipiWPolGenin", gipiWPolGenin==null ? gipiWPolGenin : StringFormatter.escapeHTMLInObject(gipiWPolGenin));
		
		Map<String, String> parsNewFormInst = new HashMap<String, String>();
		parsNewFormInst = this.gipiWPolbasDAO.newFormInst(issCd, lineCd);
		String updCredBranch = (String) parsNewFormInst.get("updCredBranch");
		String reqCredBranch = (String) parsNewFormInst.get("reqCredBranch");
		String updIssueDate = (String) parsNewFormInst.get("updIssueDate");
		String reqRefPolNo = (String) parsNewFormInst.get("reqRefPolNo");
		String defCredBranch = (String) parsNewFormInst.get("defCredBranch");
		String varVdate = (String) parsNewFormInst.get("varVdate");
		String typeCdStatus = (String) parsNewFormInst.get("typeCdStatus");
		String reqRefNo = (String) parsNewFormInst.get("reqRefNo"); //added by Jdiago 09.09.2014
		request.setAttribute("updCredBranch", updCredBranch);
		request.setAttribute("reqCredBranch", reqCredBranch);
		request.setAttribute("updIssueDate", updIssueDate);
		request.setAttribute("reqRefPolNo", reqRefPolNo);
		request.setAttribute("defCredBranch", defCredBranch);
		request.setAttribute("varVdate", varVdate);
		request.setAttribute("typeCdStatus", typeCdStatus);
		request.setAttribute("reqRefNo", reqRefNo); //added by Jdiago 09.09.2014
		request.setAttribute("issCdRi", giisParametersService.getParamValueV2("ISS_CD_RI"));
		request.setAttribute("mnSublineMop", giisParametersService.getParamValueV2("MN_SUBLINE_MOP"));
		request.setAttribute("lcFI", giisParametersService.getParamValueV2("LINE_CODE_FI"));
		request.setAttribute("inspectionStatus", giisParametersService.getParamValueV2("CONVERT_INSPECTION"));
		request.setAttribute("reqSurveySettAgent", giisParametersService.getParamValueV2("REQ_SURVEY_SETT_AGENT"));
		request.setAttribute("overrideTakeupTerm", giisParametersService.getParamValueV2("OVERRIDE_TAKEUP_TERM"));
		Map<String, Object> coIns = new HashMap<String, Object>();
		coIns = gipiWPolbasService.coInsurance(parId);
		request.setAttribute("coInsuranceJSON", new JSONObject(StringFormatter.replaceQuotesInMap(coIns)));
		
		Map parsWItmperl = new HashMap();
		parsWItmperl = gipiWItemPerilService.isExist(parId);
		String isExistWItmperl = (String) parsWItmperl.get("exist");
		request.setAttribute("isExistGipiWItmperl", isExistWItmperl);
		
		Map parsWinvTax = new HashMap();
		parsWinvTax = gipiWinvTaxService.isExist(parId);
		String isExistWinvTax = (String) parsWinvTax.get("exist");
		request.setAttribute("isExistGipiWinvTax", isExistWinvTax);
		request.setAttribute("isExistGipiWItem", gipiWPolbasService.isExistWItem(parId));
		
		Map isExistWPolnrep = new HashMap();
		isExistWPolnrep = gipiWPolnrepService.isExist(parId);
		String existWPolnrep = (String) isExistWPolnrep.get("exist");
		request.setAttribute("isExistGipiWPolnrep", existWPolnrep);
		
		Map isExistWOpenPOlicy = new HashMap();
		isExistWOpenPOlicy = gipiWOpenPolicyService.isExist(parId);
		String existWOpenPolicy= (String) isExistWOpenPOlicy.get("exist");
		request.setAttribute("isExistGipiWOpenPolicy", existWOpenPolicy);
		
		Map parsWinvoice = new HashMap();
		parsWinvoice = gipiWInvoiceService.isExist2(parId);
		String isExistWinvoice = (String) parsWinvoice.get("exist");
		request.setAttribute("isExistGipiWInvoice", isExistWinvoice);
		
		String[] args = {lineCd};
		String ora2010Sw = giisParametersService.getParamValueV2("ORA2010_SW");
		request.setAttribute("ora2010Sw", ora2010Sw);
		if ("Y".equals(ora2010Sw)){
			request.setAttribute("companyListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.COMPANY_LISTING))));
			request.setAttribute("employeeListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.EMPLOYEE_LISTING))));
			request.setAttribute("bancTypeCdListingJSON", new JSONArray((List<GIISBancType>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_TYPE_CD_LISTING))));
			request.setAttribute("bancAreaCdListingJSON", new JSONArray((List<GIISBancArea>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_AREA_CD_LISTING))));
			request.setAttribute("bancBranchCdListingJSON", new JSONArray((List<GIISBancBranch>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_BRANCH_CD_LISTING))));
			request.setAttribute("planCdListingJSON", new JSONArray((List<GIISPlan>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PLAN_CD_LISTING, args))));
		}
		
		String lcMN = giisParametersService.getParamValueV2("LINE_CODE_MN");
		String lcMN2 = giisLineFacadeService.getMenuLineCd(lineCd);
		request.setAttribute("lcMN", lcMN);
		request.setAttribute("lcMN2", lcMN2);		
/*		if (lineCd.equals(lcMN) || "MN".equals(lcMN2)){
			request.setAttribute("surveyAgentListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.SURVEY_AGENT_LISTING))));
			request.setAttribute("settlingAgentListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.SETTLING_AGENT_LISTING))));
		}*/
		
		request.setAttribute("checkItemExist", gipiwItemService.checkItemExist(parId));	//added by Gzelle 10032014

		return parsNewFormInst;
	}

	@Override
	public Map<String, String> newFormInstBond(String issCd, String lineCd) throws SQLException {
		return this.gipiWPolbasDAO.newFormInst(issCd, lineCd);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#getIssueYy(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> getIssueYy(String bookingMth,String bookingYear, String doi,
			String issueDate) throws SQLException {
		return this.gipiWPolbasDAO.getIssueYy(bookingMth, bookingYear, doi, issueDate);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#validateExpiryDate(java.lang.Integer, java.lang.String)
	 */
	@Override
	public Map<String, String> validateExpiryDate(Integer parId, String doe)
			throws SQLException {
		return this.gipiWPolbasDAO.validateExpiryDate(parId, doe);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#postFormsCommitA(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public Map<String, String> postFormsCommitA(Integer parId,
			Integer coInsurance,String dateSw) throws SQLException {
		return this.gipiWPolbasDAO.postFormsCommitA(parId, coInsurance, dateSw);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#updatepolDist(java.lang.String, java.lang.Integer, java.lang.String)
	 */
	@Override
	public void updatepolDist(String effDate, Integer parId, String longTermDist)
			throws SQLException {
		this.gipiWPolbasDAO.updatepolDist(effDate, parId, longTermDist);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#commit()
	 */
	@Override
	public void commit() throws SQLException {
		this.gipiWPolbasDAO.commit();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#preFormsCommitA(java.lang.Integer)
	 */
	@Override
	public Map<String, String> preFormsCommitA(Integer parId)
			throws SQLException {
		return this.gipiWPolbasDAO.preFormsCommitA(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#preFormsCommitB(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> preFormsCommitB(String opLineCd,
			String opSublineCd, String opIssCd, String opIssueYy,
			String opPolSeqNo, String opRenewNo, String effDate, String doe)
			throws SQLException {
		return this.gipiWPolbasDAO.preFormsCommitB(opLineCd, opSublineCd, opIssCd, opIssueYy, opPolSeqNo, opRenewNo, effDate, doe);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#preFormsCommitC(java.lang.Integer)
	 */
	@Override
	public void preFormsCommitC(Integer parId) throws SQLException {
		this.gipiWPolbasDAO.preFormsCommitC(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#preFormsCommitG(java.lang.Integer, java.lang.String, java.lang.Integer)
	 */
	@Override
	public void preFormsCommitG(Integer bookingYear, String bookingMth,
			Integer parId) throws SQLException {
		this.gipiWPolbasDAO.preFormsCommitG(bookingYear, bookingMth, parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#preUpdateB540A(java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, String> preUpdateB540A(String sublineCd, String refPolNo)
			throws SQLException {
		return this.gipiWPolbasDAO.preUpdateB540A(sublineCd, refPolNo);
	}

	@Override
	public Map<String, Object> saveGipiWPolbasForBond(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.saveGipiWPolbasForBond(params);
	}

	@Override
	public Map<String, Object> validateEndtInceptExpiryDate(Map<String, Object> params)
			throws SQLException {		
		return this.gipiWPolbasDAO.validateEndtInceptExpiryDate(params);
	}

	@Override
	public Map<String, Object> validateEndtEffDate(Map<String, Object> params)
			throws SQLException {		
		return this.gipiWPolbasDAO.validateEndtEffDate(params);
	}

	@Override
	public int checkForPendingClaims(Map<String, Object> params)
			throws SQLException {		
		return this.gipiWPolbasDAO.checkForPendingClaims(params);
	}

	@Override
	public BigDecimal checkPolicyPayment(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.checkPolicyPayment(params);
	}

	@Override
	public Map<String, Object> checkEndtForItemAndPeril(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkEndtForItemAndPeril(params);
	}

	@Override
	public Map<String, Object> checkForPolFlagInterruption(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().checkForPolFlagInterruption(params);
	}

	@Override
	public Map<String, Object> executeCheckPolFlagProcedures(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().executeCheckPolFlagProcedures(params);
	}

	@Override
	public Map<String, Object> executeUncheckPolFlagProcedures(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().executeUncheckPolFlagProcedures(params);
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#updateGipiWpolbasGipis060(int, java.lang.String, java.lang.String, java.lang.String, java.util.Date, java.util.Date, java.math.BigDecimal, java.util.Date)
	 */
	@Override
	public String updateGipiWpolbasEndt(int parId, String lineCd, String negateItem,
			String prorateFlag, String compSw, String endtExpiryDate,
			String effDate, BigDecimal shortRtPercent, String expiryDate) throws SQLException {		
		return this.getGipiWPolbasDAO().updateGipiWpolbasEndt(parId, lineCd, negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#checkForProrateFlagInterruption(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkForProrateFlagInterruption(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().checkForProrateFlagInterruption(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#executeCheckProrateFlagProcedures(java.util.Map)
	 */
	@Override
	public Map<String, Object> executeCheckProrateFlagProcedures(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().executeCheckProrateFlagProcedures(params);
	}	

	@Override
	public Map<String, Object> validateEndtExpDate(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().validateEndtExpDate(params);
	}

	@Override
	public Map<String, Object> validateEndtIssueDate(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().validateEndtIssueDate(params);
	}

	@Override
	public Map<String, Object> gipis031NewFormInstance(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().gipis031NewFormInstance(params);
	}

	@Override
	public Map<String, Object> validateBeforeSave(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().validateBeforeSave(params);
	}

	@Override
	public Map<String, Object> saveEndtBasicInfo(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().saveEndtBasicInfo(params);
	}

	@Override
	public String checkOldBondNoExist(Map<String, String> params)
			throws SQLException {
		return this.gipiWPolbasDAO.checkOldBondNoExist(params);
	}

	@Override
	public String validateRenewalDuration(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.validateRenewalDuration(params);
	}

	@Override
	public Map<String, Object> searchForPolicy(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().searchForPolicy(params);
	}

	@Override
	public Map<String, Object> checkClaims(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkClaims(params);
	}

	@Override
	public Map<String, Object> checkEnteredPolicyNo(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkEnteredPolicyNo(params);
	}

	@Override
	public Map<String, Object> checkPolicyForSpoilage(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkPolicyForSpoilage(params);
	}

	@Override
	public String preGetAmounts(Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().preGetAmounts(params);
	}

	@Override
	public Map<String, Object> createNegatedRecordsCoi(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().createNegatedRecordsCoi(params);
	}

	@Override
	public Map<String, Object> createNegatedRecordsEndt(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().createNegatedRecordsEndt(params);
	}

	@Override
	public Map<String, Object> createNegatedRecordsFlat(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().createNegatedRecordsFlat(params);
	}

	@Override
	public String checkPolicyForAffectingEndtToCancel(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkPolicyForAffectingEndtToCancel(params);
	}

	@Override
	public String endtCheckRecordInItemPeril(Integer parId) throws SQLException {		
		return this.getGipiWPolbasDAO().endtCheckRecordInItemPeril(parId);
	}

	@Override
	public String endtCheckRecordInItem(Integer parId) throws SQLException {		
		return this.getGipiWPolbasDAO().endtCheckRecordInItem(parId);
	}

	@Override
	public Map<String, Object> insertGipiWPolbasicDetailsForPAR(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.insertGipiWPolbasicDetailsForPAR(params);
	}

	@Override
	public List<Map<String, Object>> getRecordsForCoiCancellation(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().getRecordsForCoiCancellation(params);
	}

	@Override
	public List<Map<String, Object>> getRecordsForEndtCancellation(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().getRecordsForEndtCancellation(params);
	}

	@Override
	public Map<String, Object> processEndtCancellation(
			Map<String, Object> params) throws SQLException, JSONException {		
		//return this.getGipiWPolbasDAO().processEndtCancellation(params); robert 10.31.2012
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("sublineCd", request.getParameter("sublineCd"));
		param.put("issCd", request.getParameter("issCd"));
		param.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		param.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		param.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		param.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		param.put("packPolFlag", request.getParameter("packPolFlag"));
		param.put("cancelType", request.getParameter("cancelType"));					
		param.put("effDate", request.getParameter("effDate"));
		param.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));		
		param.put("cancellationType", request.getParameter("cancellationType"));		
		param.put("parId", Integer.parseInt(request.getParameter("parId")));	
		return this.getGipiWPolbasDAO().processEndtCancellation(param);
	}

	@Override
	public Map<String, Object> getRecordsForService(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().getRecordsForService(params);
	}

	@Override
	public Map<String, Object> checkPolicyNoForEndt(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiWPolbasDAO().checkPolicyNoForEndt(params);
	}

	@Override
	public String getEndtText(int parId) throws SQLException {		
		return this.getGipiWPolbasDAO().getEndtText(parId);
	}

	@Override
	public Map<String, Object> savePARBasicInfo(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.savePARBasicInfo(params);
	}

	@Override
	public String getPolicyNoForEndt(Integer parId) throws SQLException {
		return this.gipiWPolbasDAO.getPolicyNoForEndt(parId);
	}

	@Override
	public Map<String, Object> updateGipiWPolbasEndt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");		
		
		try {
			params.put("parId", Integer.parseInt(request.getParameter("parId")));
			params.put("negateItem", request.getParameter("negateItem"));
			params.put("prorateFlag", request.getParameter("prorateFlag"));
			params.put("compSw", request.getParameter("compSw"));
			params.put("endtExpDate", "".equals(request.getParameter("endtExpDate")) ? null : sdf.parse(request.getParameter("endtExpDate")));
			params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
			params.put("shortRtPct", new BigDecimal(request.getParameter("shortRtPct").isEmpty() ? "0.00" : request.getParameter("shortRtPct")));
			params.put("expDate", "".equals(request.getParameter("expDate")) ? null : sdf.parse(request.getParameter("expDate")));			
		} catch (ParseException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
		
		return this.getGipiWPolbasDAO().updateGipiWPolbasEndt(params);
	}

	@Override
	public String isExistWItem(Integer parId) throws SQLException {
		return this.gipiWPolbasDAO.iisExistWItem(parId);
	}

	@Override
	public Map<String, Object> getFixedFlag(Map<String, Object> params)	throws SQLException {		
		return this.gipiWPolbasDAO.getFixedFlag(params);
	}
	
	@Override
	public Map<String, Object> getFixedFlagGIPIS017B(Map<String, Object> params) throws SQLException {		
		return this.gipiWPolbasDAO.getFixedFlag(params);
	}

	@Override
	public Map<String, Object> genBankDetails(Map<String, Object> params)
			throws SQLException {
		return this.gipiWPolbasDAO.genBankDetails(params);
	}

	@Override
	public String validateAcctIssCd(String nbtAcctIssCd) throws SQLException {
		return this.gipiWPolbasDAO.validateAcctIssCd(nbtAcctIssCd);
	}

	@Override
	public String validateBranchCd(HashMap<String, String> params) throws SQLException {
		return this.gipiWPolbasDAO.validateBranchCd(params);
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getBankRefNoList(HashMap<String, Object> params,
			Integer pageNo) throws SQLException {
		List<GIPIRefNoHist> list = (List<GIPIRefNoHist>) StringFormatter.replaceQuotesInList(this.gipiWPolbasDAO.getBankRefNoList(params));
		PaginatedList paginatedList = new PaginatedList(list , ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public String validateBankRefNo(HashMap<String, String> params)
			throws SQLException {
		return this.gipiWPolbasDAO.validateBankRefNo(params);
	}

	@Override
	public Map<String, Object> coInsurance(Integer parId) throws SQLException {
		return this.gipiWPolbasDAO.coInsurance(parId);
	}

	@Override
	public void showEditPolicyNo(HttpServletRequest request)
			throws SQLException {
		int parId = Integer.parseInt("".equals(request.getParameter("parId")) || request.getParameter("parId") == null? "0" : request.getParameter("parId"));
		String lineCd = (request.getParameter("lineCd") == null? "":request.getParameter("lineCd"));
		String issCd = (request.getParameter("issCd") == null? "":request.getParameter("issCd"));
		String sublineCd = request.getParameter("sublineCd");
		String polSeqNo = request.getParameter("polSeqNo");
		String issYy = request.getParameter("issueYy");
		String renewNo = request.getParameter("renewNo");
		request.setAttribute("parId", parId);
		request.setAttribute("lineCdPol", lineCd);
		request.setAttribute("issCd", issCd);
		request.setAttribute("sublineCdPol", sublineCd);
		request.setAttribute("polSeqNo", polSeqNo);
		request.setAttribute("issueYy", issYy);
		request.setAttribute("renewNo", renewNo);
	}

	@Override
	public Map<String, Object> getEndtRiskTag(HttpServletRequest request) throws SQLException {
		String lineCd = (request.getParameter("lineCd") == null? "":request.getParameter("lineCd"));
		String issCd = (request.getParameter("issCd") == null? "":request.getParameter("issCd"));
		String sublineCd = request.getParameter("sublineCd");
		String polSeqNo = request.getParameter("polSeqNo");
		String issYy = request.getParameter("issueYy");
		String renewNo = request.getParameter("renewNo");
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", lineCd);
		params.put("sublineCd", sublineCd);
		params.put("issCd", issCd);
		params.put("issueYy", issYy);
		params.put("polSeqNo", polSeqNo);
		params.put("renewNo", renewNo);
		params = this.gipiWPolbasDAO.getEndtRiskTag(params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> searchForEditedPolicy(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", request.getParameter("effDate"));
		params.put("acctOfCd", request.getParameter("acctOfCd"));
		params.put("bondSeqNo", request.getParameter("bondSeqNo") == "" ? null : Integer.parseInt(request.getParameter("bondSeqNo")));
		params = this.gipiWPolbasDAO.searchForEditedPolicy(params);
		List<GIPIWPolbas> pol = (List<GIPIWPolbas>) params.get("gipiWPolbas");
		SimpleDateFormat sdfWithTime = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		params.put("inceptDate", pol.get(0).getInceptDate() != null ? sdfWithTime.format(pol.get(0).getInceptDate()) :"");
		params.put("expiryDate", pol.get(0).getExpiryDate() != null ? sdfWithTime.format(pol.get(0).getExpiryDate()) :"");
		params.put("endtExpiryDate", pol.get(0).getEndtExpiryDate() != null ? sdfWithTime.format(pol.get(0).getEndtExpiryDate()) :"");
		return params;
	}

	public String checkPaidPolicy(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWPolbasDAO().checkPaidPolicy(params);
	}
	
	public Integer checkAvailableEndt(Map<String, Object> params)
		throws SQLException {
		return this.getGipiWPolbasDAO().checkAvailableEndt(params);
	}
	
	public GIPIWPolbas getEndtBancassuranceDtl(Integer parId) throws SQLException {
		return this.getGipiWPolbasDAO().getEndtBancassuranceDtl(parId);
	}
	
	public Map<String, Object> saveGipiWPolbasForEndtBond2(String params, GIISUser user) throws JSONException, SQLException, ParseException{
		Map<String, Object> newParams = new HashMap<String, Object>();
		
		JSONObject polbasObj = new JSONObject(params);
		JSONObject gipiParListObj = new JSONObject(polbasObj.isNull("gipiParList") ? null : polbasObj.getString("gipiParList"));
		JSONObject gipiWPolbasObj = new JSONObject(polbasObj.isNull("gipiWPolbas") ? null : polbasObj.getString("gipiWPolbas"));
		JSONObject gipiWEndtText = new JSONObject(polbasObj.isNull("gipiWEndtTextObj") ? null : polbasObj.getString("gipiWEndtTextObj"));
		JSONObject gipiWPolGenin = new JSONObject(polbasObj.isNull("gipiWGenInfoObj") ? null : polbasObj.getString("gipiWGenInfoObj"));
		JSONArray gipiWPolnrep = new JSONArray(polbasObj.isNull("gipiWPolnrep") ? null : polbasObj.getString("gipiWPolnrep"));
		Debug.print(gipiWPolbasObj);
		GIPIWPolbas polbas = preparePolBas(gipiWPolbasObj, user);
		Integer parId = polbas.getParId();
		
		newParams.put("gipiWPolbas", polbas);
		newParams.put("gipiParList", prepareParList(gipiParListObj, user.getUserId(), parId));
		newParams.put("gipiWEndtText", prepareEndtText(gipiWEndtText, parId, user));
		newParams.put("gipiWPolGenin", preparePolGenin(gipiWPolGenin, parId, user));
		newParams.put("gipiWPolnrep", preparePolnrep(gipiWPolnrep, user));
		newParams.put("variables", polbasObj.getString("variables"));
		
		return this.getGipiWPolbasDAO().saveGipiWPolbasForEndtBond2(newParams);
	}
	
	private GIPIPARList prepareParList(JSONObject parObj, String user, Integer parId) throws JSONException {
		GIPIPARList par = new GIPIPARList();
		
		par.setParId(parId);
		par.setParType(parObj.isNull("parType") ? null : parObj.getString("parType"));
		par.setParStatus(parObj.isNull("parStatus") ? null : parObj.getInt("parStatus"));
		par.setLineCd(parObj.isNull("lineCd") ? null : parObj.getString("lineCd"));
		par.setIssCd(parObj.isNull("issCd") ? null : parObj.getString("issCd"));
		par.setParYy(parObj.isNull("parYy") ? null : parObj.getInt("parYy"));
		par.setParSeqNo(parObj.isNull("parSeqNo") ? null : parObj.getInt("parSeqNo"));
		par.setQuoteSeqNo(parObj.isNull("quoteSeqNo") ? null : parObj.getInt("quoteSeqNo"));
		par.setAssdNo(parObj.isNull("assdNo") ? null : parObj.getInt("assdNo"));
		par.setAddress1(parObj.isNull("address1") ? null : parObj.getString("address1"));
		par.setAddress2(parObj.isNull("address2") ? null : parObj.getString("address2"));
		par.setAddress3(parObj.isNull("address3") ? null : parObj.getString("address3"));
		par.setUserId(user);
		System.out.println("prepare PAR --- "+parId);
		return par;
	}
	
	private List<GIPIWPolnrep> preparePolnrep(JSONArray wpolnrep, GIISUser user) throws JSONException {
		List<GIPIWPolnrep> polnrepList = new ArrayList<GIPIWPolnrep>();
		
		for (int i = 0; i < wpolnrep.length(); i++){
			GIPIWPolnrep polnrep = new GIPIWPolnrep();
			JSONObject polnrepObj = null;
			polnrepObj = wpolnrep.getJSONObject(i);
			polnrep.setParId(polnrepObj.isNull("parId") ? null : polnrepObj.getInt("parId"));
			polnrep.setOldPolicyId(polnrepObj.isNull("oldPolicyId") ? null : polnrepObj.getInt("oldPolicyId"));
			polnrep.setRecFlag(polnrepObj.isNull("recFlag") ? null : polnrepObj.getString("recFlag"));
			polnrep.setRenRepSw(polnrepObj.isNull("renRepSw") ? null : polnrepObj.getString("renRepSw"));
			polnrepList.add(polnrep);
		}
		
		return polnrepList;
	}
	
	private GIPIWEndtText prepareEndtText(JSONObject wendtTextObj, Integer parId, GIISUser user) throws JSONException {
		GIPIWEndtText endtText = new GIPIWEndtText();
		
		endtText.setParId(parId);
		endtText.setUserId(user.getUserId());
		endtText.setEndtCd(wendtTextObj.isNull("endtCd") ? null : wendtTextObj.getString("endtCd"));
		endtText.setEndtText(wendtTextObj.isNull("endtText") ? null : (wendtTextObj.getString("endtText")));
		endtText.setEndtText01(wendtTextObj.isNull("endtText01") ? null : (wendtTextObj.getString("endtText01")));
		endtText.setEndtText02(wendtTextObj.isNull("endtText02") ? null : wendtTextObj.getString("endtText02"));
		endtText.setEndtText03(wendtTextObj.isNull("endtText03") ? null : wendtTextObj.getString("endtText03"));
		endtText.setEndtText04(wendtTextObj.isNull("endtText04") ? null : wendtTextObj.getString("endtText04"));
		endtText.setEndtText05(wendtTextObj.isNull("endtText05") ? null : wendtTextObj.getString("endtText05"));
		endtText.setEndtText06(wendtTextObj.isNull("endtText06") ? null : wendtTextObj.getString("endtText06"));
		endtText.setEndtText07(wendtTextObj.isNull("endtText07") ? null : wendtTextObj.getString("endtText07"));
		endtText.setEndtText08(wendtTextObj.isNull("endtText08") ? null : wendtTextObj.getString("endtText08"));
		endtText.setEndtText09(wendtTextObj.isNull("endtText09") ? null : wendtTextObj.getString("endtText09"));
		endtText.setEndtText10(wendtTextObj.isNull("endtText10") ? null : wendtTextObj.getString("endtText10"));
		endtText.setEndtText11(wendtTextObj.isNull("endtText11") ? null : wendtTextObj.getString("endtText11"));
		endtText.setEndtText12(wendtTextObj.isNull("endtText12") ? null : wendtTextObj.getString("endtText12"));
		endtText.setEndtText13(wendtTextObj.isNull("endtText13") ? null : wendtTextObj.getString("endtText13"));
		endtText.setEndtText14(wendtTextObj.isNull("endtText14") ? null : wendtTextObj.getString("endtText14"));
		endtText.setEndtText15(wendtTextObj.isNull("endtText15") ? null : wendtTextObj.getString("endtText15"));
		endtText.setEndtText16(wendtTextObj.isNull("endtText16") ? null : wendtTextObj.getString("endtText16"));
		endtText.setEndtText17(wendtTextObj.isNull("endtText17") ? null : wendtTextObj.getString("endtText17"));
		System.out.println("Prepared endt text : "+parId+"; "+endtText.getEndtText()+"; "+endtText.getEndtText01());
		return endtText;
	}
	
	private GIPIWPolGenin preparePolGenin(JSONObject wpolGenin, Integer parId, GIISUser user) throws JSONException {
		GIPIWPolGenin polGenin = new GIPIWPolGenin();
		
		polGenin.setParId(parId);
		polGenin.setUserId(user.getUserId());
		polGenin.setGeninInfoCd(wpolGenin.isNull("geninInfoCd") ? null : wpolGenin.getString("geninInfoCd"));
		polGenin.setGenInfo(wpolGenin.isNull("genInfo") ? null : wpolGenin.getString("genInfo"));
		polGenin.setGenInfo01(wpolGenin.isNull("genInfo01") ? null : wpolGenin.getString("genInfo01"));
		polGenin.setGenInfo02(wpolGenin.isNull("genInfo02") ? null : wpolGenin.getString("genInfo02"));
		polGenin.setGenInfo03(wpolGenin.isNull("genInfo03") ? null : wpolGenin.getString("genInfo03"));
		polGenin.setGenInfo04(wpolGenin.isNull("genInfo04") ? null : wpolGenin.getString("genInfo04"));
		polGenin.setGenInfo05(wpolGenin.isNull("genInfo05") ? null : wpolGenin.getString("genInfo05"));
		polGenin.setGenInfo06(wpolGenin.isNull("genInfo06") ? null : wpolGenin.getString("genInfo06"));
		polGenin.setGenInfo07(wpolGenin.isNull("genInfo07") ? null : wpolGenin.getString("genInfo07"));
		polGenin.setGenInfo08(wpolGenin.isNull("genInfo08") ? null : wpolGenin.getString("genInfo08"));
		polGenin.setGenInfo09(wpolGenin.isNull("genInfo09") ? null : wpolGenin.getString("genInfo09"));
		polGenin.setGenInfo10(wpolGenin.isNull("genInfo10") ? null : wpolGenin.getString("genInfo10"));
		polGenin.setGenInfo11(wpolGenin.isNull("genInfo11") ? null : wpolGenin.getString("genInfo11"));
		polGenin.setGenInfo12(wpolGenin.isNull("genInfo12") ? null : wpolGenin.getString("genInfo12"));
		polGenin.setGenInfo13(wpolGenin.isNull("genInfo13") ? null : wpolGenin.getString("genInfo13"));
		polGenin.setGenInfo14(wpolGenin.isNull("genInfo14") ? null : wpolGenin.getString("genInfo14"));
		polGenin.setGenInfo15(wpolGenin.isNull("genInfo15") ? null : wpolGenin.getString("genInfo15"));
		polGenin.setGenInfo16(wpolGenin.isNull("genInfo16") ? null : wpolGenin.getString("genInfo16"));
		polGenin.setGenInfo17(wpolGenin.isNull("genInfo17") ? null : wpolGenin.getString("genInfo17"));
		System.out.println("Prepared Pol Genin : "+polGenin.getGenInfo()+"; "+polGenin.getGenInfo01());
		return polGenin;
		
	}
	
	private GIPIWPolbas preparePolBas(JSONObject wpolbasObj, GIISUser user) throws JSONException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		GIPIWPolbas polbas = new GIPIWPolbas();
		
		polbas.setParId(wpolbasObj.getInt("parId"));
		polbas.setAssdNo(wpolbasObj.getString("assdNo"));
		polbas.setLineCd(wpolbasObj.isNull("lineCd") ? null : wpolbasObj.getString("lineCd"));
		polbas.setSublineCd(wpolbasObj.isNull("sublineCd") ? null : wpolbasObj.getString("sublineCd"));
		polbas.setIssCd(wpolbasObj.isNull("issCd") ? null : wpolbasObj.getString("issCd"));
		polbas.setIssueYy(wpolbasObj.isNull("issueYy") ? Integer.parseInt("0") : wpolbasObj.getInt("issueYy"));
		polbas.setPolSeqNo(wpolbasObj.isNull("polSeqNo") ? Integer.parseInt("0") : wpolbasObj.getInt("polSeqNo"));
		polbas.setRenewNo(wpolbasObj.isNull("renewNo") ? null : wpolbasObj.getString("renewNo"));
		polbas.setEndtIssCd(wpolbasObj.isNull("endtIssCd") ? null : wpolbasObj.getString("endtIssCd"));
		polbas.setEndtYy(wpolbasObj.isNull("endtYy") ? null : wpolbasObj.getString("endtYy"));
		polbas.setInceptDate(wpolbasObj.isNull("inceptDate") ? null : df.parse(wpolbasObj.getString("inceptDate")));
		polbas.setExpiryDate(wpolbasObj.isNull("expiryDate") ? null : df.parse(wpolbasObj.getString("expiryDate")));
		polbas.setEffDate(wpolbasObj.isNull("effDate") ? null : df.parse(wpolbasObj.getString("effDate")));
		polbas.setEndtExpiryDate(wpolbasObj.isNull("endtExpiryDate") ? null : df.parse(wpolbasObj.getString("endtExpiryDate")));
		polbas.setIssueDate(wpolbasObj.isNull("issueDate") ? null : df.parse(wpolbasObj.getString("issueDate")));
		polbas.setRefPolNo(wpolbasObj.isNull("refPolNo") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("refPolNo"))); //unescapeHtmlJava christian 03/12/2013
		polbas.setTypeCd(wpolbasObj.isNull("typeCd") ? null : wpolbasObj.getString("typeCd"));
		polbas.setRegionCd(wpolbasObj.isNull("regionCd") ? null : wpolbasObj.getString("regionCd"));
		polbas.setAddress1(wpolbasObj.isNull("address1") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("address1"))); //unescapeHtmlJava christian 03/12/2013
		polbas.setAddress2(wpolbasObj.isNull("address2") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("address2"))); //unescapeHtmlJava christian 03/12/2013
		polbas.setAddress3(wpolbasObj.isNull("address3") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("address3"))); //unescapeHtmlJava christian 03/12/2013
		polbas.setMortgName(wpolbasObj.isNull("mortgName") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("mortgName"))); //unescapeHtmlJava christian 03/12/2013
		polbas.setIndustryCd(wpolbasObj.isNull("industryCd") ? null : wpolbasObj.getString("industryCd"));
		polbas.setCredBranch(wpolbasObj.isNull("credBranch") ? null : wpolbasObj.getString("credBranch"));
		polbas.setBookingMth(wpolbasObj.isNull("bookingMth") ? null : wpolbasObj.getString("bookingMth"));
		polbas.setBookingYear(wpolbasObj.isNull("bookingYear") ? null : wpolbasObj.getString("bookingYear"));
		polbas.setTakeupTerm(wpolbasObj.isNull("takeupTerm") ? null : wpolbasObj.getString("takeupTerm"));
		polbas.setInceptTag(wpolbasObj.isNull("inceptTag") ? null : wpolbasObj.getString("inceptTag"));
		polbas.setExpiryTag(wpolbasObj.isNull("expiryTag") ? null : wpolbasObj.getString("expiryTag"));
		polbas.setEndtExpiryTag(wpolbasObj.isNull("endtExpiryTag") ? null : wpolbasObj.getString("endtExpiryTag"));
		polbas.setRegPolicySw(wpolbasObj.isNull("regPolicySw") ? "N" : wpolbasObj.getString("regPolicySw"));
		polbas.setForeignAccSw(wpolbasObj.isNull("foreignAccSw") ? "N" : wpolbasObj.getString("foreignAccSw"));
		polbas.setInvoiceSw(wpolbasObj.isNull("invoiceSw") ? "N" : wpolbasObj.getString("invoiceSw"));
		polbas.setAutoRenewFlag(wpolbasObj.isNull("autoRenewFlag") ? "N" : wpolbasObj.getString("autoRenewFlag"));
		polbas.setProvPremTag(wpolbasObj.isNull("provPremTag") ? "N" : wpolbasObj.getString("provPremTag"));
		polbas.setPackPolFlag(wpolbasObj.isNull("packPolFlag") ? "N" : wpolbasObj.getString("packPolFlag"));
		polbas.setCoInsuranceSw(wpolbasObj.isNull("coInsuranceSw") ? "N" : wpolbasObj.getString("coInsuranceSw"));
		polbas.setAnnTsiAmt(wpolbasObj.isNull("annTsiAmt") ? null : new BigDecimal(wpolbasObj.getString("annTsiAmt")));
		polbas.setAnnPremAmt(wpolbasObj.isNull("annPremAmt") ? null : new BigDecimal(wpolbasObj.getString("annPremAmt")));
		polbas.setQuotationPrintedSw("N");
		polbas.setCovernotePrintedSw("N");
		polbas.setSamePolnoSw("N");
		polbas.setPolFlag(wpolbasObj.isNull("polFlag") ? null : wpolbasObj.getString("polFlag"));
		polbas.setEndtSeqNo(wpolbasObj.isNull("endtSeqNo") ? null : wpolbasObj.getString("endtSeqNo"));
		polbas.setUserId(user.getUserId());
		polbas.setBondSeqNo(wpolbasObj.isNull("bondSeqNo") ? null : Integer.parseInt(wpolbasObj.getString("bondSeqNo")));
		polbas.setCancelType(wpolbasObj.getString("cancelType"));
		polbas.setOldAssdNo(wpolbasObj.isNull("oldAssdNo") ? null : wpolbasObj.getInt("oldAssdNo"));				//added by steven 8/31/2012
		polbas.setOldAddress1(wpolbasObj.isNull("oldAddress1") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("oldAddress1")));		//added by steven 8/31/2012 //unescapeHtmlJava christian 03/12/2013
		polbas.setOldAddress2(wpolbasObj.isNull("oldAddress2") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("oldAddress2")));		//added by steven 8/31/2012 //unescapeHtmlJava christian 03/12/2013
		polbas.setOldAddress3(wpolbasObj.isNull("oldAddress3") ? null : StringFormatter.unescapeHtmlJava(wpolbasObj.getString("oldAddress3")));		//added by steven 8/31/2012 //unescapeHtmlJava christian 03/12/2013
		//added by robert GENQA SR 4825 08.03.15
		polbas.setProrateFlag(wpolbasObj.getString("prorateFlag"));
		polbas.setCompSw(((wpolbasObj.getString("prorateFlag").equals("1")) ? wpolbasObj.getString("compSw") : "N"));
		polbas.setShortRtPercent((wpolbasObj.getString("prorateFlag").equals("3")) ? wpolbasObj.getString("shortRtPercent") : "");
		//end robert GENQA SR 4825 08.03.15
		polbas.setBondAutoPrem(wpolbasObj.isNull("bondAutoPrem") ? "N" : wpolbasObj.getString("bondAutoPrem")); //added by robert GENQA SR 4828 08.25.15
		System.out.println("Prepared polbas : "+polbas.getEndtSeqNo());
		return polbas;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIWPolbasService#getWpolbasParIdByPolFlag(java.lang.String, java.lang.Integer)
	 */
	@Override
	public Integer getWpolbasParIdByPolFlag(String polFlag, Integer parId)
			throws SQLException {
		return this.getGipiWPolbasDAO().getWpolbasParIdByPolFlag(polFlag, parId);
	}
	
	public Map<String, Object> validateEffDateB5401(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWPolbasDAO().validateEffDateB5401(params);
	}

	@Override
	public Map<String, Object> getCoverNoteDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWPolbasDAO().getCoverNoteDetails(params);
	}

	@Override
	public void updateCoverNoteDetails(Map<String, Object> params)
			throws SQLException, Exception {
		this.getGipiWPolbasDAO().updateCoverNoteDetails(params);
	}

	@Override
	public GIPIWPolbas updateBookingDates(GIPIWPolbas polbas)
			throws SQLException {
		return this.getGipiWPolbasDAO().updateBookingDates(polbas);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> endtBasicInfoNewFormInstance(
			Map<String, Object> params) throws SQLException, JSONException {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) params.get("lovHelper");
		int parId = (Integer) params.get("parId");
		String lineCd = (String) params.get("lineCd");
		String issCd = (String) params.get("issCd");		
		
		JSONObject objVar = new JSONObject();
		JSONObject objPar = new JSONObject();
		
		GIPIPARList gipiParList = null;
		GIPIWPolbas gipiWPolbas = null;
		GIPIWPolGenin gipiWPolGenin = null;
		GIPIWEndtText gipiWEndtText = null;					
		GIPIWOpenPolicy gipiWOpenPolicy = null;
		
		String[] args = {lineCd};
		String[] args2 = {issCd};
		String[] domainRisk = {"GIPI_POLBASIC.RISK_TAG"};
		String lcEn;
		
		if("Y".equals(request.getParameter("fromPolicyNo"))){
			Map<String, Object> varMap = new HashMap<String, Object>();
			Map<String, Object> policyNoMap = new HashMap<String, Object>();
			
			policyNoMap.put("parId", parId);
			policyNoMap.put("lineCd", request.getParameter("lineCd"));
			policyNoMap.put("sublineCd", request.getParameter("sublineCd"));
			policyNoMap.put("issCd", request.getParameter("issCd"));
			policyNoMap.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
			policyNoMap.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
			policyNoMap.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
			
			policyNoMap = this.getGipiWPolbasDAO().searchForPolicy1(policyNoMap);
			System.out.println("PolicyNoMap : " + policyNoMap.toString());
			if(null != policyNoMap.get("msgAlert")){
				resultMap.put("message", policyNoMap.get("msgAlert") != null ? policyNoMap.get("msgAlert").toString() : "");
				resultMap.put("PAGE", "/pages/genericMessage.jsp");				
			}else{				
				gipiParList = ((List<GIPIPARList>) policyNoMap.get("gipiParlist")).get(0);
				gipiWPolbas = ((List<GIPIWPolbas>) policyNoMap.get("gipiWPolbas")).get(0);
				
				gipiWPolGenin = new GIPIWPolGenin();
				gipiWEndtText = new GIPIWEndtText();
				
				gipiWEndtText.setEndtTax("N");
				
				// load ung mga variables na gagamitin
				
				Map<String, Object> newFormInstance = new HashMap<String, Object>();
				
				newFormInstance.put("parId", parId);				
				newFormInstance = this.gipis031NewFormInstance1(newFormInstance);
				newFormInstance.put("varPolChangedSw", "Y"); // added by: Nica 07.20.2012 - switch to indicate that this is from policy
				
				//added by gab 10.05.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
				String reqRefPolNo = (String) newFormInstance.get("paramRequiredPolNo");
				request.setAttribute("reqRefPolNo", reqRefPolNo);
				String reqRefNo = (String) newFormInstance.get("paramRequiredRefNo");
				request.setAttribute("reqRefNo", reqRefNo);
				
				if(newFormInstance.get("msgAlert") != null){
					resultMap.put("message", newFormInstance.get("msgAlert") != null ? newFormInstance.get("msgAlert").toString() : "");
					resultMap.put("PAGE", "/pages/genericMessage.jsp");
				}else{
					// load ung mga variables na gagamitin
					
					lcEn = newFormInstance.get("varLcEn") != null ? newFormInstance.get("varLcEn").toString() : "";
					System.out.println("NewFormInstance : " + newFormInstance.toString());
					System.out.println(lineCd + " - " + lcEn + " - " + args[0]);
					
					Map<String, Object> listingMap = new HashMap<String, Object>();
					
					listingMap.put("request", request);
					listingMap.put("lovHelper", lovHelper);
					listingMap.put("args", args);
					listingMap.put("args2", args2);
					listingMap.put("domainRisk", domainRisk);
					listingMap.put("lineCd", lineCd);
					listingMap.put("lcEn", lcEn);
					listingMap.put("ora2010Sw", newFormInstance.get("paramOra2010Sw"));
					listingMap.put("isMarineCargo", newFormInstance.get("paramShowMarineDtlBtn"));
					
					loadListingToRequest(listingMap);
					
					GIISAssured assured = this.getGiisAssuredService().getGIISAssuredByAssdNo(gipiParList.getAssdNo().toString());
					//String regionCd = newFormInstance.get("regionCd") != null ? newFormInstance.get("regionCd").toString() : ""; bonok :: 11.15.2012
					String regionCd = newFormInstance.get("paramRegionCd") != null ? newFormInstance.get("paramRegionCd").toString() : ""; // bonok :: 11.15.2012
					String industryCd = newFormInstance.get("paramIndustryCd") != null ? newFormInstance.get("paramIndustryCd").toString() : ""; // bonok :: 15.07.2012
					
					String acctOfCd = gipiWPolbas.getAcctOfCd() == null ? "0" : gipiWPolbas.getAcctOfCd().toString(); 
					GIISAssured acctOf = this.getGiisAssuredService().getGIISAssuredByAssdNo(acctOfCd);
					
					gipiWPolbas.setDspAssdName(assured.getAssdName());
					
					//if(gipiWPolbas.getRegionCd().equals("")){ // only set defaut industryCd when industry cd is null - irwin
					if(gipiWPolbas.getIndustryCd() == null){ // to avoid null pointer exception
						gipiWPolbas.setIndustryCd(industryCd);
					}
					
					//gipiWPolbas.setIndustryCd(industryCd); // bonok :: 11.15.2012
					
					//if(gipiWPolbas.getRegionCd().equals("")){ // only set default region if the region cd is null
					if(gipiWPolbas.getRegionCd() == null){ // to avoid null pointer exception
						gipiWPolbas.setRegionCd(regionCd);
					}
					
					if(acctOf != null){
						gipiWPolbas.setAcctOfName(acctOf.getAssdName());
					}
					
					if(gipiWPolbas.getCredBranch() != null){
						// you cannot compare null to another null. it always result to false
					}else{
						gipiWPolbas.setCredBranch("HO");
					}													
					gipiParList.setParNo(GIPIPARUtil.composeParNo(gipiParList));
					System.out.println("here"+ gipiWPolbas.getRegionCd());
					request.setAttribute("gipiParList", StringFormatter.escapeHTMLInObject2(gipiParList));
					request.setAttribute("gipiWPolbas", StringFormatter.escapeHTMLInObject2(gipiWPolbas));
					request.setAttribute("gipiWEndtText", gipiWEndtText);
					request.setAttribute("gipiWPolGenin", gipiWPolGenin);
					request.setAttribute("gipiParListJSON", new JSONObject((GIPIPARList) StringFormatter.replaceQuotesInObject(gipiParList)));
					request.setAttribute("gipiWPolbasJSON", new JSONObject((GIPIWPolbas) StringFormatter.replaceQuotesInObject(gipiWPolbas)));
					request.setAttribute("gipiWPolGeninJSON", new JSONObject((GIPIWPolGenin) StringFormatter.replaceQuotesInObject(gipiWPolGenin)));
					request.setAttribute("gipiWEndtTextJSON", new JSONObject((GIPIWEndtText) StringFormatter.replaceQuotesInObject(gipiWEndtText)));					
					
					request.setAttribute("policyNo", composePolicyNo(gipiWPolbas));
					request.setAttribute("ora2010Sw", newFormInstance.get("paramOra2010Sw"));
					
					request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParList);					
					resultMap.put("PAGE", "/pages/underwriting/endt/basicInfo1/endtBasicInformationMain.jsp");
				}				
				
				// unahin munang ilagay ung newFormInstance dahil baka ma-overwrite ung open_policy_sw kapag nauna si policyNoMap
				varMap.putAll(newFormInstance);
				varMap.putAll(policyNoMap);
				
				objVar = this.createGIPIS031Variables(varMap);
				objPar = this.createGIPIS031Parameters(varMap);
			}			
		}else{
			Map<String, Object> newFormInstance = new HashMap<String, Object>();
			newFormInstance.put("parId", parId);
			
			newFormInstance = this.gipis031NewFormInstance1(newFormInstance);	
			
			//added by gab 10.05.2016 SR 3147,3027,2645,2681,3148,3206,3264,3010
			String reqRefPolNo = (String) newFormInstance.get("paramRequiredPolNo");
			request.setAttribute("reqRefPolNo", reqRefPolNo);
			String reqRefNo = (String) newFormInstance.get("paramRequiredRefNo");
			request.setAttribute("reqRefNo", reqRefNo);
			
			if(newFormInstance.get("msgAlert") != null){
				throw new SQLException();						
			}else{
				// load ung mga variables na gagamitin				
			}
			
			lcEn = newFormInstance.get("varLcEn") != null ? newFormInstance.get("varLcEn").toString() : "";

			Map<String, Object> listingMap = new HashMap<String, Object>();
			
			listingMap.put("request", request);
			listingMap.put("lovHelper", lovHelper);
			listingMap.put("args", args);
			listingMap.put("args2", args2);
			listingMap.put("domainRisk", domainRisk);
			listingMap.put("lineCd", lineCd);
			listingMap.put("lcEn", lcEn);
			listingMap.put("ora2010Sw", newFormInstance.get("paramOra2010Sw"));
			listingMap.put("isMarineCargo", newFormInstance.get("paramShowMarineDtlBtn"));
		
			loadListingToRequest(listingMap);
			
			gipiParList = this.getGipiParListService().getGIPIPARDetails(parId);
			gipiWPolbas = this.getGipiWPolbas(parId);
			gipiWPolGenin = this.getGipiWPolGeninService().getGipiWPolGenin(parId);
			gipiWEndtText = this.getGipiWEndtTextService().getGIPIWEndttext(parId);
			gipiWOpenPolicy = this.getGipiWOpenPolicyService().getWOpenPolicy(parId);
			
			gipiParList.setParNo(GIPIPARUtil.composeParNo(gipiParList));
			
			String regionCd = newFormInstance.get("paramRegionCd") != null ? newFormInstance.get("paramRegionCd").toString() : ""; // bonok :: 11.15.2012
			//gipiWPolbas.setRegionCd(regionCd); // bonok :: 11.15.2012 -- commented out by christian 01/16/2012
			
			String industryCd = newFormInstance.get("paramIndustryCd") != null ? newFormInstance.get("paramIndustryCd").toString() : ""; // bonok :: 11.15.2012
			//gipiWPolbas.setIndustryCd(industryCd); // bonok :: 11.15.2012 -- commented out by christian 01/16/2012
			
			//only set defaut industryCd and regionCD when values are null
			if(gipiWPolbas.getIndustryCd() == null){ // to avoid null pointer exception
				gipiWPolbas.setIndustryCd(industryCd);
			}
			
			if(gipiWPolbas.getRegionCd() == null){ // to avoid null pointer exception
				gipiWPolbas.setRegionCd(regionCd);
			}
			
			request.setAttribute("gipiParList", gipiParList);
			request.setAttribute("gipiWPolbas", gipiWPolbas);
			request.setAttribute("gipiWPolGenin", gipiWPolGenin);
			request.setAttribute("gipiWEndtText", gipiWEndtText);
			request.setAttribute("gipiWOpenPolicy", gipiWOpenPolicy);
			
			request.setAttribute("gipiParListJSON", new JSONObject((GIPIPARList) StringFormatter.replaceQuotesInObject(gipiParList)));
			request.setAttribute("gipiWPolbasJSON", new JSONObject((GIPIWPolbas) StringFormatter.replaceQuotesInObject(gipiWPolbas)));
			request.setAttribute("gipiWPolGeninJSON", new JSONObject(gipiWPolGenin != null ? (GIPIWPolGenin) StringFormatter.escapeHTMLInObject(gipiWPolGenin) : "{}"));
			request.setAttribute("gipiWEndtTextJSON", new JSONObject(gipiWEndtText != null ? (GIPIWEndtText) StringFormatter.escapeHTMLInObject2(gipiWEndtText) : "{}")); //robert 03.04.2013 sr12368 
			request.setAttribute("gipiWOpenPolicy", new JSONObject(gipiWOpenPolicy != null ? (GIPIWOpenPolicy) StringFormatter.replaceQuotesInObject(gipiWOpenPolicy) : "{}"));
			
			request.setAttribute("policyNo", composePolicyNo(gipiWPolbas));
			request.setAttribute("ora2010Sw", newFormInstance.get("paramOra2010Sw"));
			
			request = GIPIPARUtil.setPARInfoFromSavedPAR(request, gipiParList);
			newFormInstance.put("cancelType", gipiWPolbas.getCancelType()); //Added by Jerome Bautista 10.26.2015 SR 20567
			objVar = this.createGIPIS031Variables(newFormInstance);
			objPar = this.createGIPIS031Parameters(newFormInstance);
			
			resultMap.put("PAGE", "/pages/underwriting/endt/basicInfo1/endtBasicInformationMain.jsp");
		}
		System.out.println("OBJVAR: " + objVar.get("varVOldExpiryDate"));
		request.setAttribute("vars", objVar);
		request.setAttribute("params", objPar);
		
		//request.setAttribute("gipiWItem", new JSONObject(StringFormatter.escapeHTMLInObject2(getGipiWItemService().getGIPIWItem(parId)))); //robert 03.08.2013 sr12368 
		request.setAttribute("gipiWItem", new JSONArray(this.getGipiWItemService().getGIPIWItem(parId)));
		request.setAttribute("gipiWItmperl", new JSONArray(this.getGipiWItemPerilService().getGIPIWItemPerils(parId)));		
		
		return resultMap;
	}
	
	private String composePolicyNo(GIPIWPolbas gipiWPolbas){
		StringBuilder policyNo = new StringBuilder();
		
		policyNo.append(gipiWPolbas.getLineCd());
		policyNo.append("-");
		policyNo.append(gipiWPolbas.getSublineCd());
		policyNo.append("-");
		policyNo.append(gipiWPolbas.getIssCd());
		policyNo.append("-");
		policyNo.append(gipiWPolbas.getIssueYy());
		policyNo.append("-");
		policyNo.append(String.format("%07d",gipiWPolbas.getPolSeqNo()));
		policyNo.append("-");
		policyNo.append(String.format("%02d",Integer.parseInt(gipiWPolbas.getRenewNo())));
		
		return policyNo.toString();
	}
	
	@SuppressWarnings("unchecked")
	private void loadListingToRequest(Map<String, Object> params){
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		LOVHelper lovHelper = (LOVHelper) params.get("lovHelper");
		String[] args = (String[]) params.get("args");
		String[] args2 = (String[]) params.get("args2");
		String[] domainRisk = (String[]) params.get("domainRisk");
		String lineCd = (String) params.get("lineCd");
		String lcEn = (String) params.get("lcEn");
		String ora2010Sw = (String) params.get("ora2010Sw");
		
		List<LOV> sublineList = lovHelper.getList((lineCd).equals(lcEn) ? LOVHelper.SUB_LINE_SPF_LISTING : LOVHelper.SUB_LINE_LISTING, args);
		List<LOV> branchSourceList = lovHelper.getList(LOVHelper.BRANCH_SOURCE_LISTING);
		List<LOV> policyStatusList = lovHelper.getList(LOVHelper.POLICY_STATUS_LISTING);
		List<LOV> policyTypeList = lovHelper.getList(LOVHelper.POLICY_TYPE_LISTING, args);
		List<LOV> placeList = lovHelper.getList(LOVHelper.PLACE_LISTING, args2);
		List<LOV> riskTagList = lovHelper.getList(LOVHelper.RISK_TAG_LISTING,domainRisk);
		List<LOV> industryList = lovHelper.getList(LOVHelper.INDUSTRY_LISTING);
		List<LOV> regionList = lovHelper.getList(LOVHelper.REGION_LISTING);
		List<LOV> takeupTermList = lovHelper.getList(LOVHelper.TAKEUP_TERM_LISTING);
		
		request.setAttribute("sublineListing", sublineList);		
		request.setAttribute("branchSourceListing", branchSourceList);		
		request.setAttribute("policyStatusListing", policyStatusList);		
		request.setAttribute("policyTypeListing", policyTypeList);		
		request.setAttribute("placeListing", placeList);		
		request.setAttribute("riskTagListing", riskTagList);		
		request.setAttribute("industryListing", industryList);		
		request.setAttribute("regionListing", regionList);		
		request.setAttribute("takeupTermListing", takeupTermList);
		
		if("Y".equals(ora2010Sw)){
			request.setAttribute("companyListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.COMPANY_LISTING))));
			request.setAttribute("employeeListingJSON", new JSONArray((List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.EMPLOYEE_LISTING))));
			request.setAttribute("bancTypeCdListingJSON", new JSONArray((List<GIISBancType>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_TYPE_CD_LISTING))));
			request.setAttribute("bancAreaCdListingJSON", new JSONArray((List<GIISBancArea>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_AREA_CD_LISTING))));
			request.setAttribute("bancBranchCdListingJSON", new JSONArray((List<GIISBancBranch>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.BANC_BRANCH_CD_LISTING))));
			request.setAttribute("planCdListingJSON", new JSONArray((List<GIISPlan>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.PLAN_CD_LISTING, args))));
		}
		
        /*if("Y".equals((String) params.get("isMarineCargo"))){
			request.setAttribute("surveyAgentListing", (List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.SURVEY_AGENT_LISTING))); // remove muna natin JSONArray :)
			request.setAttribute("settlingAgentListing", (List<GIISPayees>) StringFormatter.replaceQuotesInList(lovHelper.getList(LOVHelper.SETTLING_AGENT_LISTING))); // remove muna natin JSONArray :)
		}*/ //Dren Niebres 06.07.2016 SR-22243

		Date date = new Date();
		DateFormat format = new SimpleDateFormat("MM-dd-yyyy");
		String[] argsDate = { format.format(date) };
		
		List<LOV> bookingMonths = lovHelper.getList(LOVHelper.BOOKEDMONTH_LISTING, argsDate);
		request.setAttribute("bookingMonthListing", bookingMonths);
		request.setAttribute("objBookingMonthListing", new JSONArray(bookingMonths));
	}
	
	private JSONObject createGIPIS031Variables(Map<String, Object> params) throws JSONException {
		JSONObject objVar = new JSONObject();
		
		objVar.put("varFireWvr", params.get("varFireWvr") != null ? params.get("varFireWvr") : 1);
		objVar.put("varVNewWndt", params.get("varVNewWndt") != null ? params.get("varVNewWndt") : "N");
		objVar.put("varVOldDateEff", params.get("varVOldDateEff") != null ? params.get("varVOldDateEff") : JSONObject.NULL);
		objVar.put("varVOldDateExp", params.get("varVOldDateExp") != null ? params.get("varVOldDateExp") : JSONObject.NULL);
		objVar.put("varVCommitSwitch", params.get("varVCommitSwitch") != null ? params.get("varVCommitSwitch") : JSONObject.NULL);
		objVar.put("varVB490PremAmt", params.get("varVB490PremAmt") != null ? params.get("varVB490PremAmt") : JSONObject.NULL);
		objVar.put("varVB490AnnPremAmt", params.get("varVB490AnnPremAmt") != null ? params.get("varVB490AnnPremAmt") : JSONObject.NULL);
		objVar.put("varVB490TsiAmt", params.get("varVB490TsiAmt") != null ? params.get("varVB490TsiAmt") : JSONObject.NULL);
		objVar.put("varVB490PremRt", params.get("varVB490PremRt") != null ? params.get("varVB490PremRt") : JSONObject.NULL);
		objVar.put("varVExpOldDte", params.get("varVExpOldDte") != null ? params.get("varVExpOldDte") : JSONObject.NULL);
		objVar.put("varVEffOldDte", params.get("varVEffOldDte") != null ? params.get("varVEffOldDte") : JSONObject.NULL);
		objVar.put("varVOldAsr", params.get("varVOldAsr") != null ? params.get("varVOldAsr") : JSONObject.NULL);
		objVar.put("varVPolTmpNo", params.get("varVPolTmpNo") != null ? params.get("varVPolTmpNo") : JSONObject.NULL);
		objVar.put("varVMplSwitch", params.get("varVMplSwitch") != null ? params.get("varVMplSwitch") : JSONObject.NULL);
		objVar.put("varVLineTmpCd", params.get("varVLineTmpCd") != null ? params.get("varVLineTmpCd") : JSONObject.NULL);
		objVar.put("varVSublineTmpCd", params.get("varVSublineTmpCd") != null ? params.get("varVSublineTmpCd") : JSONObject.NULL);
		objVar.put("varVIssTmpCd", params.get("varVIssTmpCd") != null ? params.get("varVIssTmpCd") : JSONObject.NULL);
		objVar.put("varVIssueTmpYy", params.get("varVIssueTmpYy") != null ? params.get("varVIssueTmpYy") : JSONObject.NULL);
		objVar.put("varVRenewNoTmp", params.get("varVRenewNoTmp") != null ? params.get("varVRenewNoTmp") : JSONObject.NULL);
		objVar.put("varVRefSwitch", params.get("varVRefSwitch") != null ? params.get("varVRefSwitch") : JSONObject.NULL);
		objVar.put("varLcMC", params.get("varLcMC") != null ? params.get("varLcMC") : JSONObject.NULL);
		objVar.put("varLcAC", params.get("varLcAC") != null ? params.get("varLcAC") : JSONObject.NULL);
		objVar.put("varLcEN", params.get("varLcEN") != null ? params.get("varLcEN") : JSONObject.NULL);
		objVar.put("varSublineMop", params.get("varSublineMop") != null ? params.get("varSublineMop") : JSONObject.NULL);
		objVar.put("varDummyX", params.get("varDummyX") != null ? params.get("varDummyX") : JSONObject.NULL);
		objVar.put("varButtonHelp", params.get("varButtonHelp") != null ? params.get("varButtonHelp") : "N");
		objVar.put("varAttribute", params.get("varAttribute") != null ? params.get("varAttribute") : "B");
		objVar.put("varPolChangedSw", params.get("varPolChangedSw") != null ? params.get("varPolChangedSw") : "N");
		objVar.put("varProrateSw", params.get("varProrateSw") != null ? params.get("varProrateSw") : "N");
		objVar.put("varShtRtPct", params.get("varShtRtPct") != null ? params.get("varShtRtPct") : "N");
		objVar.put("varOldLineCd", params.get("varOldLineCd") != null ? params.get("varOldLineCd") : JSONObject.NULL);
		objVar.put("varOldSublineCd", params.get("varOldSublineCd") != null ? params.get("varOldSublineCd") : JSONObject.NULL);
		objVar.put("varOldIssCd", params.get("varOldIssCd") != null ? params.get("varOldIssCd") : JSONObject.NULL);
		objVar.put("varOldIssueYy", params.get("varOldIssueYy") != null ? params.get("varOldIssueYy") : JSONObject.NULL);
		objVar.put("varOldPolSeqNo", params.get("varOldPolSeqNo") != null ? params.get("varOldPolSeqNo") : JSONObject.NULL);
		objVar.put("valOldRenewNo", params.get("valOldRenewNo") != null ? params.get("valOldRenewNo") : JSONObject.NULL);
		objVar.put("varOldInceptDate", params.get("varOldInceptDate") != null ? params.get("varOldInceptDate") : JSONObject.NULL);
		objVar.put("varOldExpiryDate", params.get("varOldExpiryDate") != null ? params.get("varOldExpiryDate") : JSONObject.NULL);
		objVar.put("varOldEffDate", params.get("varOldEffDate") != null ? params.get("varOldEffDate") : JSONObject.NULL);
		objVar.put("varOldEndtExpiryDate", params.get("varOldEndtExpiryDate") != null ? params.get("varOldEndtExpiryDate") : JSONObject.NULL);
		objVar.put("varOldProvPremTag", params.get("varOldProvPremTag") != null ? params.get("varOldProvPremTag") : JSONObject.NULL);
		objVar.put("varOldProvPremPct", params.get("varOldProvPremPct") != null ? params.get("varOldProvPremPct") : JSONObject.NULL);
		objVar.put("varOldProrateFlag", params.get("varOldProrateFlag") != null ? params.get("varOldProrateFlag") : JSONObject.NULL);
		objVar.put("varOldShortRtPercent", params.get("varOldShortRtPercent") != null ? params.get("varOldShortRtPercent") : JSONObject.NULL);
		objVar.put("varOldShortRtPercent2", params.get("varOldShortRtPercent2") != null ? params.get("varOldShortRtPercent2") : JSONObject.NULL);
		objVar.put("varAcctOfCd", params.get("varAcctOfCd") != null ? params.get("varAcctOfCd") : JSONObject.NULL);
		objVar.put("varVMaxEffDate", params.get("varVMaxEffDate") != null ? params.get("varVMaxEffDate") : JSONObject.NULL);
		objVar.put("varExpChgSw", params.get("varExpChgSw") != null ? params.get("varExpChgSw") : "N");
		objVar.put("varVAddTime", params.get("varVAddTime") != null ? params.get("varVAddTime") : JSONObject.NULL);
		objVar.put("varEndOfDay", params.get("varEndOfDay") != null ? params.get("varEndOfDay") : JSONObject.NULL);
		objVar.put("varDelBillSw", params.get("varDelBillSw") != null ? params.get("varDelBillSw") : "Y");
		objVar.put("varVExtAssd", params.get("varVExtAssd") != null ? params.get("varVExtAssd") : JSONObject.NULL);
		objVar.put("varVOldAssd", params.get("varVOldAssd") != null ? params.get("varVOldAssd") : JSONObject.NULL);
		objVar.put("varVAdvanceBooking", params.get("varVAdvanceBooking") != null ? params.get("varVAdvanceBooking") : JSONObject.NULL);
		objVar.put("varProrataEffDate", params.get("varProrataEffDate") != null ? params.get("varProrataEffDate") : JSONObject.NULL);
		objVar.put("varVExpiryDate", params.get("varVExpiryDate") != null ? params.get("varVExpiryDate") : JSONObject.NULL);
		objVar.put("varVInceptDate", params.get("varVInceptDate") != null ? params.get("varVInceptDate") : JSONObject.NULL);
		objVar.put("varVDays", params.get("varVDays") != null ? params.get("varVDays") : JSONObject.NULL);
		objVar.put("varVOldRiskTag", params.get("varVOldRiskTag") != null ? params.get("varVOldRiskTag") : JSONObject.NULL);
		objVar.put("varDefCredBranch", params.get("varDefCredBranch") != null ? params.get("varDefCredBranch") : JSONObject.NULL);
		objVar.put("varPrevDeductibleCd", params.get("varPrevDeductibleCd") != null ? params.get("varPrevDeductibleCd") : JSONObject.NULL);
		objVar.put("varSwitchPostRec", params.get("varSwitchPostRec") != null ? params.get("varSwitchPostRec") : "N");
		objVar.put("varVCnclldFlatFlag", params.get("varVCnclldFlatFlag") != null ? params.get("varVCnclldFlatFlag") : "N");
		objVar.put("varVCnclldFlag", params.get("varVCnclldFlag") != null ? params.get("varVCnclldFlag") : "N");
		objVar.put("varVCancellationFlag", params.get("varVCancellationFlag") != null ? params.get("varVCancellationFlag") : "N");
		objVar.put("varVCancellationType", params.get("varVCancellationType") != null ? params.get("varVCancellationType") : JSONObject.NULL);
		objVar.put("varVPremAmt", params.get("varVPremAmt") != null ? params.get("varVPremAmt") : JSONObject.NULL);
		objVar.put("varVTsiAMt", params.get("varVTsiAMt") != null ? params.get("varVTsiAMt") : JSONObject.NULL);
		objVar.put("varVItmPremAmt", params.get("varVItmPremAmt") != null ? params.get("varVItmPremAmt") : JSONObject.NULL);
		objVar.put("varVItmTsiAmt", params.get("varVItmTsiAmt") != null ? params.get("varVItmTsiAmt") : JSONObject.NULL);
		objVar.put("varVBancPayeeClass", params.get("varVBancPayeeClass") != null ? params.get("varVBancPayeeClass") : JSONObject.NULL);
		objVar.put("varVOldExpiryDate", params.get("varVOldExpiryDate") != null ? params.get("varVOldExpiryDate") : JSONObject.NULL); //added by June Mark SR-23166 [12.09.16]
		
		return objVar;
	}
	
	private JSONObject createGIPIS031Parameters(Map<String, Object> params) throws JSONException {
		JSONObject objParam = new JSONObject();
		
		objParam.put("paramInvalidSw", params.get("paramInvalidSw") != null ? params.get("paramInvalidSw") : "N");
		objParam.put("paramPostRecSwitch", params.get("paramPostRecSwitch") != null ? params.get("paramPostRecSwitch") : "N");
		objParam.put("paramInsWinvoice", params.get("paramInsWinvoice") != null ? params.get("paramInsWinvoice") : "N");
		objParam.put("paramModalFlag", params.get("paramModalFlag") != null ? params.get("paramModalFlag") : "N");
		//objParam.put("paramProrateCancelSw", params.get("paramProrateCancelSw") != null ? params.get("paramProrateCancelSw") : "N"); //Commented out and replaced by code below: Jerome Bautista 10.26.2015 SR 20567
		if("2".equals(params.get("cancelType"))){ //Added by Jerome Bautista 10.26.2015 SR 20567
			objParam.put("paramProrateCancelSw", "Y");
		}else{
			objParam.put("paramProrateCancelSw", "N");
		} 
		objParam.put("paramSysdateSw", params.get("paramSysdateSw") != null ? params.get("paramSysdateSw") : "N");
		objParam.put("paramEndtPolId", params.get("paramEndtPolId") != null ? params.get("paramEndtPolId") : JSONObject.NULL);
		objParam.put("paramCancelPolId", params.get("paramCancelPolId") != null ? params.get("paramCancelPolId") : JSONObject.NULL);
		objParam.put("paramFirstEndtSw", params.get("paramFirstEndtSw") != null ? params.get("paramFirstEndtSw") : "N");
		objParam.put("paramBackEndtSw", params.get("paramBackEndtSw") != null ? params.get("paramBackEndtSw") : "N");
		objParam.put("paramVarNDate", params.get("paramVarNDate") != null ? params.get("paramVarNDate") : JSONObject.NULL);
		objParam.put("paramVarIDate", params.get("paramVarIDate") != null ? params.get("paramVarIDate") != null : JSONObject.NULL);
		objParam.put("paramVarVDate", params.get("paramVarVDate") != null ? params.get("paramVarVDate") : JSONObject.NULL);
		objParam.put("paramB560InvokedSw", params.get("paramB560InvokedSw") != null ? params.get("paramB560InvokedSw") : JSONObject.NULL);
		objParam.put("paramConfirmSw", params.get("paramConfirmSw") != null ? params.get("paramConfirmSw") : "N");
		objParam.put("paramAddToGroupSw", params.get("paramAddToGroupSw") != null ? params.get("paramAddToGroupSw") : JSONObject.NULL);
		objParam.put("paramB540Status", params.get("paramB540Status") != null ? params.get("paramB540Status") : JSONObject.NULL);
		objParam.put("paramVEndt", params.get("paramVEndt") != null ? params.get("paramVEndt") : "N");
		objParam.put("paramEndtTaxSw", params.get("paramEndtTaxSw") != null ? params.get("paramEndtTaxSw") : "X");
		objParam.put("paramB530Status", params.get("paramB530Status") != null ? params.get("paramB530Status") : JSONObject.NULL);
		objParam.put("paramB560Status", params.get("paramB560Status") != null ? params.get("paramB560Status") : JSONObject.NULL);
		objParam.put("paramSublineCd", params.get("paramSublineCd") != null ? params.get("paramSublineCd") : JSONObject.NULL);
		objParam.put("paramPrateDaysParm", params.get("paramPrateDaysParm") != null ? params.get("paramPrateDaysParm") : JSONObject.NULL);
		objParam.put("paramOpenPolicySw", params.get("paramOpenPolicySw") != null ? params.get("paramOpenPolicySw") : JSONObject.NULL);
		objParam.put("paramPolFlag", params.get("paramPolFlag") != null ? params.get("paramPolFlag") : "N");
		objParam.put("paramOpSublineCd", params.get("paramOpSublineCd") != null ? params.get("paramOpSublineCd") : JSONObject.NULL);
		objParam.put("paramOpIssCd", params.get("paramOpIssCd") != null ? params.get("paramOpIssCd") : JSONObject.NULL);
		objParam.put("paramOpIssueYy", params.get("paramOpIssueYy") != null ? params.get("paramOpIssueYy") : JSONObject.NULL);
		objParam.put("paramOpPolSeqNo", params.get("paramOpPolSeqNo") != null ? params.get("paramOpPolSeqNo") : JSONObject.NULL);
		objParam.put("paramOpRenewNo", params.get("paramOpRenewNo") != null ? params.get("paramOpRenewNo") : JSONObject.NULL);
		objParam.put("paramDecltnNo", params.get("paramDecltnNo") != null ? params.get("paramDecltnNo") : JSONObject.NULL);
		objParam.put("paramAllowBlockEntrySw", params.get("paramDecltnNo") != null ? params.get("paramDecltnNo") : "Y");
		
		objParam.put("paramCgBackEndt", params.get("paramCgBackEndt") != null ? params.get("paramCgBackEndt") : JSONObject.NULL);
		objParam.put("paramCtrlPromptProv", params.get("paramCtrlPromptProv") != null ? params.get("paramCtrlPromptProv") : JSONObject.NULL);
		
		objParam.put("paramCancellationType", params.get("paramCancellationType") != null ? params.get("paramCancellationType") : JSONObject.NULL);
		objParam.put("paramCancelTag", params.get("paramCancelTag") != null ? params.get("paramCancelTag") : JSONObject.NULL);
		objParam.put("paramCtrlMopSubline", params.get("paramCtrlMopSubline") != null ? params.get("paramCtrlMopSubline") : JSONObject.NULL);
		objParam.put("paramRequiredPolNo", params.get("paramRequiredPolNo") != null ? params.get("paramRequiredPolNo") : JSONObject.NULL);
		objParam.put("paramShowMarineDtlBtn", params.get("paramShowMarineDtlBtn") != null ? params.get("paramShowMarineDtlBtn") : JSONObject.NULL);
		objParam.put("paramShowBancaDtlBtn", params.get("paramShowBancaDtlBtn") != null ? params.get("paramShowBancaDtlBtn") : JSONObject.NULL);
		objParam.put("paramRegionCd", params.get("paramRegionCd") != null ? params.get("paramRegionCd") : JSONObject.NULL);
		objParam.put("paramExistingClaim", params.get("paramExistingClaim") != null ? params.get("paramExistingClaim") : JSONObject.NULL);
		objParam.put("paramPaidAmt", params.get("paramPaidAmt") != null ? params.get("paramPaidAmt") : JSONObject.NULL);
		objParam.put("paramReqSurveySettAgent", params.get("paramReqSurveySettAgent") != null ? params.get("paramReqSurveySettAgent") : JSONObject.NULL);
		objParam.put("paramOra2010Sw", params.get("paramOra2010Sw") != null ? params.get("paramOra2010Sw") : JSONObject.NULL);
		objParam.put("paramInvoiceExist", params.get("paramInvoiceExist") != null ? params.get("paramInvoiceExist") : JSONObject.NULL);
		
		objParam.put("paramDeleteAllTables", JSONObject.NULL);
		objParam.put("paramDeleteBill", JSONObject.NULL);
		objParam.put("paramDeleteOtherInfo", JSONObject.NULL);
		objParam.put("paramDeleteRecords", JSONObject.NULL);
		objParam.put("paramCreateNegatedRecordsProrate", JSONObject.NULL);
		objParam.put("paramInsertParHist", JSONObject.NULL);
		objParam.put("paramCreateWinvoice", JSONObject.NULL);
		objParam.put("paramRevertFlatCancellation", "N");
		
		return objParam;
	}
	
	private Map<String, Object> gipis031NewFormInstance1(Map<String, Object> params) throws SQLException {
		return this.getGipiWPolbasDAO().gipis031NewFormInstance1(params);
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate01(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("varOldDateEff", "".equals(request.getParameter("varOldDateEff")) ? null : sdf.parse(request.getParameter("varOldDateEff")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("inceptDate", "".equals(request.getParameter("inceptDate")) ? null : sdf.parse(request.getParameter("inceptDate")));		
		params.put("expiryDate", "".equals(request.getParameter("expiryDate")) ? null : sdf.parse(request.getParameter("expiryDate")));
		params.put("varExpChgSw", request.getParameter("varExpChgSw"));
		params.put("varMaxEffDate", "".equals(request.getParameter("varMaxEffDate")) ? null : sdf.parse(request.getParameter("varMaxEffDate")));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateEffDate01(params);
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate02(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("varMaxEffDate",	"".equals(request.getParameter("varMaxEffDate")) ? null : sdf.parse(request.getParameter("varMaxEffDate")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("varOldDateEff",	"".equals(request.getParameter("varOldDateEff")) ? null : sdf.parse(request.getParameter("varOldDateEff")));
		params.put("expiryDate", "".equals(request.getParameter("expiryDate")) ? null : sdf.parse(request.getParameter("expiryDate")));
		params.put("parSysdateSw", request.getParameter("parSysdateSw"));
		params.put("varExpiryDate",	"".equals(request.getParameter("varExpiryDate")) ? null : sdf.parse(request.getParameter("varExpiryDate")));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		params.put("parCgBackEndt", request.getParameter("parCgBackEndt"));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateEffDate02(params);
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate03(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("parFirstEndtSw", request.getParameter("parFirstEndtSw"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));		
		params.put("varExpiryDate",	"".equals(request.getParameter("varExpiryDate")) ? null : sdf.parse(request.getParameter("varExpiryDate")));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));		
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateEffDate03(params);
	}

	@Override
	public Map<String, Object> gipis031ValidateEffDate04(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("varEffDateIn", "".equals(request.getParameter("varEffDateIn")) ? null : sdf.parse(request.getParameter("varEffDateIn")));
		params.put("inceptDate", "".equals(request.getParameter("inceptDate")) ? null : sdf.parse(request.getParameter("inceptDate")));
		params.put("varOldDateEff",	"".equals(request.getParameter("varOldDateEff")) ? null : sdf.parse(request.getParameter("varOldDateEff")));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("endtExpiryDate", "".equals(request.getParameter("endtExpiryDate")) ? null : sdf.parse(request.getParameter("endtExpiryDate")));
		params.put("compSw", request.getParameter("compSw"));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));		
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateEffDate04(params);
	}	

	@Override
	public Map<String, Object> gipis031ValidateEndtExpiryDate(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		params.put("expiryDate", "".equals(request.getParameter("expiryDate")) ? null : sdf.parse(request.getParameter("expiryDate")));		
		params.put("varOldDateExp", "".equals(request.getParameter("varOldDateExp")) ? null : sdf.parse(request.getParameter("varOldDateExp")));
		params.put("compSw", request.getParameter("compSw"));
		params.put("endtExpiryDate", "".equals(request.getParameter("endtExpiryDate")) ? null : sdf.parse(request.getParameter("endtExpiryDate")));
		params.put("varAddTime", "".equals(request.getParameter("varAddTime")) ? null : Integer.parseInt(request.getParameter("varAddTime")));				
		params.put("prorateFlag", request.getParameter("prorateFlag")); // irwin 8.22.2012
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateEndtExpiryDate(params);
	}	

	@Override
	public Map<String, Object> gipis031ValidateInceptDate01(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("inceptDate", "".equals(request.getParameter("inceptDate")) ? null : sdf.parse(request.getParameter("inceptDate")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateInceptDate01(params);
	}

	@Override
	public Map<String, Object> gipis031ValidateInceptDate02(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		params.put("expiryDate", "".equals(request.getParameter("expiryDate")) ? null : sdf.parse(request.getParameter("expiryDate")));
		params.put("inceptDate", "".equals(request.getParameter("inceptDate")) ? null : sdf.parse(request.getParameter("inceptDate")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateInceptDate02(params);
	}	

	@Override
	public Map<String, Object> gipis031ValidateExpiryDate01(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("inceptDate", "".equals(request.getParameter("inceptDate")) ? null : sdf.parse(request.getParameter("inceptDate")));
		params.put("prorateFlag", request.getParameter("prorateFlag"));
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		params.put("compSw", request.getParameter("compSw"));
		params.put("expiryDate", "".equals(request.getParameter("expiryDate")) ? null : sdf.parse(request.getParameter("expiryDate")));
		params.put("endtExpiryDate", "".equals(request.getParameter("endtExpiryDate")) ? null : sdf.parse(request.getParameter("endtExpiryDate")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateExpiryDate01(params);
	}	

	@Override
	public Map<String, Object> gipis031ValidateIssueDate01(
			Map<String, Object> params) throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("parVarVDate", Integer.parseInt(request.getParameter("parVarVDate")));		
		params.put("issueDate", "".equals(request.getParameter("issueDate")) ? null : sdf.parse(request.getParameter("issueDate")));		
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031ValidateIssueDate01(params);
	}

	@Override
	public Map<String, Object> gipis031GetBookingDate(Map<String, Object> params)
			throws SQLException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");		
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		params.put("parVarVDate", Integer.parseInt(request.getParameter("parVarVDate")));		
		params.put("issueDate", "".equals(request.getParameter("issueDate")) ? null : sdf.parse(request.getParameter("issueDate")));		
		params.put("effDate", "".equals(request.getParameter("effDate")) ? null : sdf.parse(request.getParameter("effDate")));		
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031GetBookingDate(params);
	}	

	@Override
	public String gipis031CheckNewRenewals(Map<String, Object> params)
			throws SQLException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		
		params.remove("request");
		
		return this.getGipiWPolbasDAO().gipis031CheckNewRenewals(params);
	}	

	@Override
	public Map<String, Object> gipis031EndtCoiCancellationTagged(
			Map<String, Object> params) throws SQLException, JSONException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));		
		param.put("cancelType", request.getParameter("cancelType"));		
		param.put("parId", request.getParameter("parId"));	
		
		return this.getGipiWPolbasDAO().gipis031EndtCoiCancellationTagged(param);
	}

	@Override
	public void saveEndtBasicInfo01(Map<String, Object> params)
			throws SQLException, JSONException, ParseException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> param = new HashMap<String, Object>();		
		
		param.put("gipiParList", new GIPIPARList(new JSONObject(objParams.getString("gipiParList"))));
		param.put("gipiWPolbas", new GIPIWPolbas(new JSONObject(objParams.getString("gipiWPolbas"))));
		param.put("gipiWPolGenin", new GIPIWPolGenin(new JSONObject(objParams.getString("gipiWPolGenin")), params.get("userId").toString()));		
		param.put("gipiWEndtText", new GIPIWEndtText(new JSONObject(objParams.getString("gipiWEndtText")), params.get("userId").toString()));
		param.put("setMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForInsert(new JSONArray(objParams.getString("setMortgagees"))));
		param.put("delMortgagees", this.getGipiWMortgageeService().prepareGIPIWMortgageeForDelete(new JSONArray(objParams.getString("delMortgagees"))));
		param.put("setDeductibles", this.getGipiWDeductibleService().prepareGIPIWDeductibleForInsert(new JSONArray(objParams.getString("setDeductibles"))));
		param.put("delDeductibles", this.getGipiWDeductibleService().prepareGIPIWDeductibleForDelete(new JSONArray(objParams.getString("delDeductibles"))));
		param.put("variables", new JSONObject(objParams.getString("variables")));
		param.put("parameters", new JSONObject(objParams.getString("parameters")));
		param.put("userId", params.get("userId"));
		
		this.getGipiWPolbasDAO().saveEndtBasicInfo01(param);		
	}	
	
	@SuppressWarnings("unused")
	private GIPIWPolbas prepareGIPIWPolbasForInsertUpdate(JSONObject json) throws ParseException, JSONException {
		GIPIWPolbas polbas = new GIPIWPolbas();
		DateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		polbas.setParId(json.isNull("parId") ? null : json.getInt("parId"));
		polbas.setLineCd(json.isNull("lineCd") ? null : json.getString("lineCd"));
		polbas.setIssCd(json.isNull("issCd") ? null : json.getString("issCd"));
		polbas.setForeignAccSw(json.isNull("foreignAccSw") ? null : json.getString("foreignAccSw"));
		polbas.setInvoiceSw(json.isNull("invoiceSw") ? null : json.getString("invoiceSw"));
		polbas.setQuotationPrintedSw(json.isNull("quotationPrintedSw") ? null : json.getString("quotationPrintedSw"));
		polbas.setCovernotePrintedSw(json.isNull("covernotePrintedSw") ? null : json.getString("covernotePrintedSw"));
		polbas.setAutoRenewFlag(json.isNull("autoRenewFlag") ? null : json.getString("autoRenewFlag"));
		polbas.setProvPremTag(json.isNull("provPremTag") ? null : json.getString("provPremTag"));
		polbas.setSamePolnoSw(json.isNull("samePolNoSw") ? null : json.getString("samePolNoSw"));
		polbas.setPackPolFlag(json.isNull("packPolFlag") ? null : json.getString("packPolFlag"));
		polbas.setRegPolicySw(json.isNull("regPolicySw") ? null : json.getString("regPolicySw"));
		polbas.setCoInsuranceSw(json.isNull("coInsuranceSw") ? null : json.getString("coInsuranceSw"));
		polbas.setSublineCd(json.isNull("sublineCd") ? null : json.getString("sublineCd"));
		polbas.setIssueYy(json.isNull("issueYy") ? null : json.getInt("issueYy"));
		polbas.setPolSeqNo(json.isNull("polSeqNo") ? null : json.getInt("polSeqNo"));
		polbas.setEndtIssCd(json.isNull("endtIssCd") ? null : json.getString("endtIssCd"));
		polbas.setEndtYy(json.isNull("endtYy") ? null : json.getString("endtYy"));
		polbas.setEndtSeqNo(json.isNull("endtSeqNo") ? null : json.getString("endtSeqNo"));
		polbas.setRenewNo(json.isNull("renewNo") ? null : json.getString("renewNo"));
		polbas.setManualRenewNo(json.isNull("manualRenewNo") ? null : json.getString("manualRenewNo"));
		//polbas.setEndtType(json.isNull("endtType") ? null : json.getString("endtType"));
		polbas.setInceptDate(json.isNull("inceptDate") ? null : sdf.parse(json.getString("inceptDate")));
		polbas.setExpiryDate(json.isNull("expiryDate") ? null : sdf.parse(json.getString("expiryDate")));
		polbas.setExpiryTag(json.isNull("expiryTag") ? null : json.getString("expiryTag"));
		polbas.setEffDate(json.isNull("effDate") ? null : sdf.parse(json.getString("effDate")));
		polbas.setIssueDate(json.isNull("issueDate") ? null : sdf.parse(json.getString("issueDate")));
		polbas.setPolFlag(json.isNull("polFlag") ? null : json.getString("polFlag"));
		polbas.setAssdNo(json.isNull("assdNo") ? null : json.getString("assdNo"));
		polbas.setDesignation(json.isNull("designation") ? null : json.getString("designation"));
		polbas.setAddress1(json.isNull("address1") ? null : json.getString("address1"));
		polbas.setAddress2(json.isNull("address2") ? null : json.getString("address2"));
		polbas.setAddress3(json.isNull("address3") ? null : json.getString("address3"));
		polbas.setMortgName(json.isNull("mortgName") ? null : json.getString("mortgName"));
		polbas.setTsiAmt(json.isNull("tsiAmt") ? null : new BigDecimal(json.getString("tsiAmt").replaceAll(",", "")));
		polbas.setPremAmt(json.isNull("premAmt") ? null : new BigDecimal(json.getString("premAmt").replaceAll(",", "")));
		polbas.setAnnTsiAmt(json.isNull("annTsiAmt") ? null : new BigDecimal(json.getString("annTsiAmt").replaceAll(",", "")));
		polbas.setAnnPremAmt(json.isNull("annPremAmt") ? null : new BigDecimal(json.getString("annPremAmt").replaceAll(",", "")));
		//polbas.setPoolPolNo(json.isNull("poolPolNo") ? null : json.getString("poolPolNo"));
		polbas.setUserId(json.isNull("userId") ? null : json.getString("userId"));
		//polbas.setOrigPolicyId(json.isNull("origPolicyId") ? null : json.getString("origPolicyId"));
		polbas.setEndtExpiryDate(json.isNull("endtExpiryDate") ? null : sdf.parse(json.getString("endtExpiryDate")));
		//polbas.setNoOfItems(json.isNull("noOfItems") ? null : json.getInt("noOfItems"));
		//polbas.setSublineTypeCd(json.isNull("sublineTypeCd") ? null : json.getString("sublineTypeCd"));
		polbas.setProrateFlag(json.isNull("prorateFlag") ? null : json.getString("prorateFlag"));
		polbas.setShortRtPercent(json.isNull("shortRtPercent") ? null : json.getString("shortRtPercent").replaceAll(",", ""));
		polbas.setTypeCd(json.isNull("typeCd") ? null : json.getString("typeCd"));
		polbas.setAcctOfCd(json.isNull("acctOfCd") ? null : json.getString("acctOfCd"));
		polbas.setProvPremPct(json.isNull("provPremPct") ? null : json.getString("provPremPct"));
		polbas.setDiscountSw(json.isNull("discountSw") ? null : json.getString("discountSw"));
		polbas.setPremWarrTag(json.isNull("premWarrTag") ? null : json.getString("premWarrTag"));
		polbas.setRefPolNo(json.isNull("refPolNo") ? null : json.getString("refPolNo"));
		polbas.setRefOpenPolNo(json.isNull("refOpenPolNo") ? null : json.getString("refOpenPolNo"));
		polbas.setInceptTag(json.isNull("inceptTag") ? null : json.getString("inceptTag"));
		polbas.setFleetPrintTag(json.isNull("fleetPrintTag") ? null : json.getString("fleetPrintTag"));
		polbas.setCompSw(json.isNull("compSw") ? null : json.getString("compSw"));
		polbas.setBookingMth(json.isNull("bookingMth") ? null : json.getString("bookingMth"));
		polbas.setBookingYear(json.isNull("bookingYear") ? null : json.getString("bookingYear"));
		polbas.setWithTariffSw(json.isNull("withTariffSw") ? null : json.getString("withTariffSw"));
		polbas.setEndtExpiryTag(json.isNull("endtExpiryTag") ? null : json.getString("endtExpiryTag"));
		//polbas.setCoverNtPrintedDate(json.isNull("coverNtPrintedDate") ? null : sdf.parse(json.getString("coverNtPrintedDate")));
		//polbas.setCoverNtPrintedCnt(json.isNull("coverNtPrintedCnt") ? null : json.getInt("coverNtPrintedCnt"));
		polbas.setPlaceCd(json.isNull("placeCd") ? null : json.getString("placeCd"));
		polbas.setBackStat(json.isNull("backStat") ? null : json.getString("backStat"));
		polbas.setValidateTag(json.isNull("validateTag") ? null : json.getString("validateTag"));
		polbas.setIndustryCd(json.isNull("industryCd") ? null : json.getString("industryCd"));
		polbas.setRegionCd(json.isNull("regionCd") ? null : json.getString("regionCd"));
		polbas.setAcctOfCdSw(json.isNull("acctOfCdSw") ? null : json.getString("acctOfCdSw"));
		polbas.setSurchargeSw(json.isNull("surchargeSw") ? null : json.getString("surchageSw"));
		polbas.setCredBranch(json.isNull("credBranch") ? null : json.getString("credBranch"));
		polbas.setOldAssdNo(json.isNull("oldAssdNo") ? null : json.getInt("oldAssdNo"));
		//polbas.setCancelDate(json.isNull("cancelDate") ? null : sdf.parse(json.getString("cancelDate")));
		polbas.setLabelTag(json.isNull("labelTag") ? null : json.getString("labelTag"));
		polbas.setOldAddress1(json.isNull("oldAddress1") ? null : json.getString("oldAddress1"));
		polbas.setOldAddress2(json.isNull("oldAddress2") ? null : json.getString("oldAddress2"));
		polbas.setOldAddress3(json.isNull("oldAddress3") ? null : json.getString("oldAddress3"));
		polbas.setRiskTag(json.isNull("riskTag") ? null : json.getString("riskTag"));
		//polbas.setQdFlag(json.isNull("qdFlag") ? null : json.getString("qdFlag"));
		polbas.setSurveyAgentCd(json.isNull("surveyAgentCd") ? null : json.getString("surveyAgentCd"));
		polbas.setSettlingAgentCd(json.isNull("settlingAgentCd") ? null : json.getString("settlingAgentCd"));
		polbas.setPackParId(json.isNull("packParId") ? null : json.getInt("packParId"));
		//polbas.setCovernoteExpiry(json.isNull("covernoteExpiry") ? null : sdf.parse(json.getString("covernoteExpiry")));
		polbas.setPremWarrDays(json.isNull("premWarrDays") ? null : json.getString("premWarrDays"));
		polbas.setTakeupTerm(json.isNull("takeupTerm") ? null : json.getString("takeupTerm"));
		polbas.setCancelType(json.isNull("cancelType") ? null : json.getString("cancelType"));
		//polbas.setCancelledEndtId(json.isNull("cancelEndtId") ? null : json.getInt("cancelEndtId"));
		//polbas.setCnDatePrinted(json.isNull("cnDatePrinted") ? null : sdf.parse(json.getString("cnDatePrinted")));
		//polbas.setCnNoOfDays(json.isNull("cnNoOfDays") ? null : json.getString("cnNoOfDays"));
		polbas.setBancassuranceSw(json.isNull("bancassuranceSw") ? null : json.getString("bancassuranceSw"));
		polbas.setAreaCd(json.isNull("areaCd") ? null : json.getString("areaCd"));
		polbas.setBranchCd(json.isNull("branchCd") ? null : json.getString("branchCd"));
		polbas.setManagerCd(json.isNull("managerCd") ? null : json.getString("managerCd"));
		polbas.setBancTypeCd(json.isNull("bancTypeCd") ? null : json.getString("bancTypeCd"));
		//polbas.setMinPremFlag(json.isNull("minPremFlag") ? null : json.getString("minPremFlag"));
		polbas.setCompanyCd(json.isNull("companyCd") ? null : json.getString("companyCd"));
		polbas.setEmployeeCd(json.isNull("employeeCd") ? null : json.getString("employeeCd"));
		polbas.setPlanSw(json.isNull("planSw") ? null : json.getString("planSw"));
		polbas.setPlanCd(json.isNull("planCd") ? null : json.getInt("planCd"));
		polbas.setPlanChTag(json.isNull("planChTag") ? null : json.getString("planChTag"));
		polbas.setBankRefNo(json.isNull("bankRefNo") ? null : json.getString("bankRefNo"));
		//polbas.setDepFlag(json.isNull("depFlag") ? null : json.getString("depFlag"));
		
		return polbas;
	}

	@Override
	public Map<String, Object> getBookingDateGIPIS002(Map<String, Object> params)
			throws SQLException {
		return this.getGipiWPolbasDAO().getBookingDateGIPIS002(params);
	}
	
	@Override
	public Map<String, Object> processEndtCancellationGipis165(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiWPolbasDAO().processEndtCancellationGipis165(params);
	}
	
	public String checkParPostedBinder(Integer parId) throws SQLException{
		return this.getGipiWPolbasDAO().checkParPostedBinder(parId);
	}

	@Override
	public String validatePolNo(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject json = new JSONObject(request.getParameter("parameters"));
		params.put("parId", json.getString("parId"));
		params.put("lineCd", json.getString("lineCd"));
		params.put("sublineCd", json.getString("sublineCd"));
		params.put("issCd", json.getString("issCd"));
		params.put("issueYy", json.getString("issueYy"));
		params.put("polSeqNo", json.getString("polSeqNo"));
		params.put("renewNo", json.getString("renewNo"));
		return this.gipiWPolbasDAO.validatePolNo(params);
	}
	//added by robert GENQA SR 4828 08.26.15
	@Override
	public String getBondAutoPrem(Integer parId) throws SQLException {
		return this.getGipiWPolbasDAO().getBondAutoPrem(parId);
	}
	//end robert GENQA SR 4828 08.26.15
	
	//jmm SR-22834
	public Map<String, Object> validateAssdNoRiCd(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("parId", request.getParameter("parId"));
		return this.gipiWPolbasDAO.validateAssdNoRiCd(params);
	}
	
	public Map<String, Object> validatePackAssdNoRiCd(HttpServletRequest request) throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("parId", request.getParameter("parId"));
		return this.gipiWPolbasDAO.validatePackAssdNoRiCd(params);
	}
	
	public String copyAttachmentsFromQuoteToPar(Map<String, Object> params) throws SQLException, IOException {
		String message = "";
		String quoteId = params.get("quoteId").toString();
		String lineCd = params.get("lineCd").toString();
		String parId = params.get("parId").toString();
		String parNo = params.get("parNo").toString();
		String mediaPathMK = params.get("mediaPathMK").toString().replaceAll("\\\\", "/");
		String mediaPathUW = params.get("mediaPathUW").toString().replaceAll("\\\\", "/");
		String userId = params.get("userId").toString();
		String fileSrc = "";
		String fileDes = "";
		String fileName = "";
		String realFileName = "";
		
		// get attachment list
		List<GIPIQuotePictures> attachmentList = this.gipiWPolbasDAO.getAttachmentList(params);
		List<GIPIWPicture> newAttachments = new ArrayList<GIPIWPicture>();
		
		for (GIPIQuotePictures attachment : attachmentList) {
			fileName = attachment.getFileName();
			realFileName = fileName.substring(fileName.lastIndexOf("/") + 1);
			fileSrc = fileName;
			fileDes = mediaPathUW + "/" + lineCd + "/" + parNo + "/" + attachment.getItemNo().toString() + "/" + realFileName;
			
			GIPIWPicture newAttachment = new GIPIWPicture();
			
			newAttachment.setParId(Integer.parseInt(parId));
			newAttachment.setItemNo(attachment.getItemNo());
			newAttachment.setFileName(fileDes);
			newAttachment.setFileType(attachment.getFileType());
			newAttachment.setFileExt(attachment.getFileExt());
			newAttachment.setRemarks(attachment.getRemarks());
			newAttachment.setUserId(userId);
			
			newAttachments.add(newAttachment);
			
			try {
				File src = new File(fileSrc);
				File des = new File(fileDes);
				
				System.out.println("Copying " + fileSrc + " to " + fileDes + " ...");
				FileUtils.copyFile(src, des); // copy physical file
			} catch (IOException e) {
				System.out.println("Missing " + fileSrc);
				continue; // if source file not exist, continue to next file
			}
		}
		
		// save attachment to gipi_wpictures
		this.gipiWPolbasDAO.saveAttachments(newAttachments);
		
		message = "SUCCESS";
		return message;
	}
}