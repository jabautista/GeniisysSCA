/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

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

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIPolbasicDAO;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIPolbasicServiceImpl.
 */
public class GIPIPolbasicServiceImpl implements GIPIPolbasicService {
	//Jerome
	/** The gipi polbasic dao. */
	private GIPIPolbasicDAO gipiPolbasicDAO;
	private static Logger log = Logger.getLogger(GIPIPolbasicServiceImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#getRefOpenPolNo(java.util.Map)
	 */
	@Override
	public String getRefOpenPolNo(Map<String, Object> params)
			throws SQLException {
		String refOpenPolNo = this.getGipiPolbasicDAO().getRefOpenPolNo(params);
		return refOpenPolNo;
	}

	/**
	 * Sets the gipi polbasic dao.
	 * 
	 * @param gipiPolbasicDAO the new gipi polbasic dao
	 */
	public void setGipiPolbasicDAO(GIPIPolbasicDAO gipiPolbasicDAO) {
		this.gipiPolbasicDAO = gipiPolbasicDAO;
	}

	/**
	 * Gets the gipi polbasic dao.
	 * 
	 * @return the gipi polbasic dao
	 */
	public GIPIPolbasicDAO getGipiPolbasicDAO() {
		return gipiPolbasicDAO;
	}

	@Override
	public List<GIPIPolbasic> getPolbasicForOpenPolicy(String linecd,
			Integer assdNo, String inceptionDate, String expiryDate)
			throws SQLException {
		return this.getGipiPolbasicDAO().getPolbasicForOpenPolicy(linecd, assdNo, inceptionDate, expiryDate);
	}

	@Override
	public Date extractExpiryDate(int parId) throws SQLException {
		return this.getGipiPolbasicDAO().extractExpiryDate(parId);
	}

	@Override
	public String getBackEndtEffectivityDate(int parId, int itemNo)
			throws SQLException {
		return this.getGipiPolbasicDAO().getBackEndtEffectivityDate(parId, itemNo);
	}

	@Override
	public GIPIPolbasic getPolicyDetails(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().getPolicyDetails(params);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicy(int parId) throws SQLException {		
		List<GIPIPolbasic> endtPolicy = this.getGipiPolbasicDAO().getEndtPolicy(parId);		
		return endtPolicy;
	}

	@Override
	public Integer getExtractId() throws SQLException {
		return this.getGipiPolbasicDAO().getExtractId();
	}

	@Override
	public void populateGixxTables(Map<String, Object> params)
			throws SQLException {
		this.gipiPolbasicDAO.populateGixxTables(params);
	}

	@Override
	public void populatePackGixxTables(Map<String, Object> params)
			throws SQLException {
		this.getGipiPolbasicDAO().populatePackGixxTables(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#getAddressForNewEndtItem(java.util.Map)
	 */
	@Override
	public Map<String, Object> getAddressForNewEndtItem(
			Map<String, Object> params) throws SQLException {
		return this.getGipiPolbasicDAO().getAddressForNewEndtItem(params);
	}

	@Override
	public void updatePrintedCount(Map<String, Object> params) throws SQLException {
		this.getGipiPolbasicDAO().updatePrintedCount(params);
	}

	@Override
	public void populateGixxTableWPolDoc(Map<String, Object> params)
			throws SQLException {
		this.getGipiPolbasicDAO().populateGixxTableWPolDoc(params);
	}
	
	@Override
	public void populatePackGixxTableWPolDoc(Map<String, Object> params)
			throws SQLException {
		this.getGipiPolbasicDAO().populatePackGixxTableWPolDoc(params);
	}

	@Override
	public String checkClaim(Map<String, Object> params) throws SQLException {
		return this.getGipiPolbasicDAO().checkClaim(params);
	}

	@Override
	public Integer getMaxEndtItemNo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().getMaxEndtItemNo(params);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyCA(int parId) throws SQLException {		
		return this.getGipiPolbasicDAO().getEndtPolicyCA(parId);
	}
	
	@Override
	public List<GIPIPolbasic> getEndtPolicyAC(int parId) throws SQLException {		
		return this.getGipiPolbasicDAO().getEndtPolicyAC(parId);
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPolicyForEndt(Map<String, String> params, int pageNo)
			throws SQLException {
		List<GIPIPolbasic> list = this.getGipiPolbasicDAO().getPolicyForEndt(params);
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage(pageNo);
		return result;
	}

	@Override
	public String isPolExist(Map<String, Object> params) throws SQLException {
		return this.getGipiPolbasicDAO().isPolExist(params);
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPolicyListing(Map<String, Object> params)
			throws SQLException {
		//return this.getGipiPolbasicDAO().getPolicyListing(params);
		List<GIPIPolbasic> list = this.getGipiPolbasicDAO().getPolicyListing(params);
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage((Integer) params.get("pageNo"));
		return result;
	}

	@Override
	public String getBillNotPrinted(Integer policyId, String polFlag,
			String lineCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("polFlag", polFlag);
		params.put("lineCd", lineCd);
		return this.getGipiPolbasicDAO().getBillNotPrinted(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#getGipdLineCdLov(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGipdLineCdLov(Integer pageNo, String keyword) throws SQLException {
		List<GIPIPolbasic> gipiPolbasic = this.getGipiPolbasicDAO().getGipdLineCdLov(keyword);
		PaginatedList paginatedList = new PaginatedList(gipiPolbasic, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public PaginatedList getPolicyInformation(Map<String, Object> params) throws SQLException {		
		List<HashMap<String, Object>> list= (List<HashMap<String, Object>>) StringFormatter.escapeHTMLInListOfMap(this.getGipiPolbasicDAO().getPolicyInformation(params));
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage((Integer) params.get("pageNo"));
		return result;
	}

	@SuppressWarnings({"unchecked" })
	@Override
	public HashMap<String, Object> getRelatedPolicies(HashMap<String, Object> params)throws SQLException, JSONException, ParseException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.preparePolInfoFilter((String) params.get("filter")));
		List<GIPIPolbasic> list = this.getGipiPolbasicDAO().getRelatedPolicies(params);
		System.out.println("getRelatedPolicies list size: "+list.size()+" //params: "+params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	private GIPIPolbasic preparePolInfoFilter(String filter) throws JSONException, ParseException{
	
		GIPIPolbasic polInfoFilter = new GIPIPolbasic();
		JSONObject jsonPolInfoFilter = null;
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat sdf2 = new SimpleDateFormat("MM/dd/yyyy");
		if(null == filter){
			jsonPolInfoFilter = new JSONObject();
		}else{
			jsonPolInfoFilter = new JSONObject(filter);
		}
		polInfoFilter.setEndtNo(jsonPolInfoFilter.isNull("endtNo") ? ""	:	jsonPolInfoFilter.getString("endtNo").toUpperCase());
		polInfoFilter.setEffDate(jsonPolInfoFilter.isNull("effDate") ? null : /*sdf.parse(jsonPolInfoFilter.getString("effDate")));*/
				(jsonPolInfoFilter.getString("effDate").contains("-") ? sdf.parse(jsonPolInfoFilter.getString("effDate")) : sdf2.parse(jsonPolInfoFilter.getString("effDate"))));
		polInfoFilter.setIssueDate(jsonPolInfoFilter.isNull("issueDate") ? null	: /*sdf.parse(jsonPolInfoFilter.getString("issueDate")));*/
				(jsonPolInfoFilter.getString("issueDate").contains("-") ? sdf.parse(jsonPolInfoFilter.getString("issueDate")) : sdf2.parse(jsonPolInfoFilter.getString("issueDate"))));
		polInfoFilter.setAcctEntDate(jsonPolInfoFilter.isNull("acctEntDate") ? null	:	/*sdf.parse(jsonPolInfoFilter.getString("acctEntDate")));*/
				(jsonPolInfoFilter.getString("acctEntDate").contains("-") ? sdf.parse(jsonPolInfoFilter.getString("acctEntDate")) : sdf2.parse(jsonPolInfoFilter.getString("acctEntDate"))));
		polInfoFilter.setParNo(jsonPolInfoFilter.isNull("parNo") ? ""	:	jsonPolInfoFilter.getString("parNo").toUpperCase());
		polInfoFilter.setRefPolNo(jsonPolInfoFilter.isNull("refPolNo") ? ""	:	jsonPolInfoFilter.getString("refPolNo").toUpperCase());
		polInfoFilter.setMeanPolFlag(jsonPolInfoFilter.isNull("meanPolFlag") ? ""	:	jsonPolInfoFilter.getString("meanPolFlag").toUpperCase());
		return polInfoFilter;
	}
		
	@Override
	public HashMap<String, Object> getPolicyMainInformation(Integer policyId)throws SQLException {
		
		return getGipiPolbasicDAO().getPolicyMainInformation(policyId);
	}
	
	@Override
	public HashMap<String, Object> getPolicyBasicInformation(Integer policyId)throws SQLException {
		return getGipiPolbasicDAO().getPolicyBasicInformation(policyId);
	}

	@Override
	public HashMap<String, Object> getPolicyBasicInformationSu(Integer policyId)throws SQLException {
		return getGipiPolbasicDAO().getPolicyBasicInformationSu(policyId);
	}

	@Override
	public GIPIPolbasic getBankPaymentDtl(Integer policyId) throws SQLException {
		return getGipiPolbasicDAO().getBankPaymentDtl(policyId);
	}

	@Override
	public GIPIPolbasic getBancassuranceDtl(Integer policyId)throws SQLException {
		return getGipiPolbasicDAO().getBancassuranceDtl(policyId);
	}

	@Override
	public GIPIPolbasic getPlanDtl(Integer policyId) throws SQLException {
		return getGipiPolbasicDAO().getPlanDtl(policyId);
	}

	@Override
	public HashMap<String, Object> getPolicyEndtSeq0(Integer policyId) throws SQLException {
		return getGipiPolbasicDAO().getPolicyEndtSeq0(policyId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyListByAssured(HashMap<String, Object> params) throws SQLException {

		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPolbasic> policyList = this.getGipiPolbasicDAO().getPolicyListByAssured(params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>)StringFormatter.escapeHTMLInList(policyList)));
		grid.setNoOfPages(policyList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;		
	}

	
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyListByObligee(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPolbasic> policyList = this.getGipiPolbasicDAO().getPolicyListByObligee(params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>)StringFormatter.escapeHTMLInList(policyList)));
		grid.setNoOfPages(policyList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyRenewals(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<GIPIPolbasic> renewalsList = this.getGipiPolbasicDAO().getPolicyRenewals(params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>)StringFormatter.escapeHTMLInList(renewalsList)));
		grid.setNoOfPages(renewalsList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	public List<GIPIPolbasic> getEndtCancellationLOV(GIPIPolbasic polbasic, String type) throws SQLException {
		List<GIPIPolbasic> polbasList = new ArrayList<GIPIPolbasic>();
		if ("coi".equals(type)){
			polbasList = this.getGipiPolbasicDAO().getEndtCancellationLOV(polbasic);
		} else if ("endt".equals(type)){
			polbasList = this.getGipiPolbasicDAO().getEndtCancellationLOV2(polbasic);
		}
		return polbasList;
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPolicyListingForCertPrinting(
			Map<String, Object> params) throws SQLException {
		List<GIPIPolbasic> list = this.getGipiPolbasicDAO().getPolicyListingForCertPrinting(params);
		PaginatedList result = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		result.gotoPage((Integer) params.get("pageNo"));
		return result;
	}

	public List<GIPIPolbasic> getEndtPolicyFI(int parId) throws SQLException {		
		return this.getGipiPolbasicDAO().getEndtPolicyFI(parId);
	}

	public List<GIPIPolbasic> getEndtPolicyMC(int parId) throws SQLException {
		return this.getGipiPolbasicDAO().getEndtPolicyMC(parId);
	}

	public List<GIPIPolbasic> getEndtPolicyMN(int parId) throws SQLException {
		return this.getGipiPolbasicDAO().getEndtPolicyMN(parId);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyMH(int parId) throws SQLException {
		return this.getGipiPolbasicDAO().getEndtPolicyMH(parId);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyEN(int parId) throws SQLException {		
		return this.getGipiPolbasicDAO().getEndtPolicyEN(parId);
	}

	@Override
	public List<GIPIPolbasic> getEndtPolicyAV(int parId) throws SQLException {
		return this.getGipiPolbasicDAO().getEndtPolicyAV(parId);
	}
	/**
	 * @author rey
	 * @date 07-19-2011
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyListByEndorsementType(HashMap<String, Object> params) throws SQLException {
		System.out.println("SERVICE ENDORSEMENT...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIPolbasic> policyList = this.getGipiPolbasicDAO().getPolicyListByEndorsementType(params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>)StringFormatter.escapeHTMLInList(policyList)));
		grid.setNoOfPages(policyList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;	
	}

	@Override
	public Map<String, Object> getValidRefPolNo(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().getValidRefPolNo(params);
	}
	/**
	 * @author rey
	 * @date 07-29-2011
	 */
	@Override
	public List<GIPIPolbasic> getBillTaxList(Integer policyId) throws SQLException{
		List<GIPIPolbasic> billPremiunTaxList = gipiPolbasicDAO.getBillTaxListDAO(policyId);
	return billPremiunTaxList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#getPolicyNo(java.lang.Integer)
	 */
	@Override
	public String getPolicyNo(Integer policyId) throws SQLException {
		return this.getGipiPolbasicDAO().getPolicyNo(policyId);
	}
	/**
	 * @author rey
	 * @date 08.04.2011
	 * bill peril list
	 */
	@Override
	public List<GIPIPolbasic> getBillPerilList(HashMap<String, Object> params) throws SQLException{
		List<GIPIPolbasic> billPremiunPerilList = gipiPolbasicDAO.getBillPerilListDAO(params);
	return billPremiunPerilList;
	}
	/**
	 * @author rey
	 * @date 08.05.2011
	 * payment schedule
	 */
	@Override
	public List<GIPIPolbasic> getPaymentSchedule(HashMap<String, Object> params)
			throws SQLException {
		List<GIPIPolbasic> billPaymentSchedule = gipiPolbasicDAO.getPaymentScheduleDAO(params);
		return billPaymentSchedule;
	}
	/**
	 * @author rey
	 * @date 08.05.2011
	 * invoice commission
	 */
	@Override
	public List<GIPIPolbasic> getInvoiceCommission(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> invoiceCommissionList = gipiPolbasicDAO.getInvoiceCommissionDAO(params);
		return invoiceCommissionList;
	}
	/**
	 * @author rey
	 * @date 08.08.2011
	 * commission details
	 */
	@Override
	public List<GIPIPolbasic> getCommissionDetails(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> commissionDetails = gipiPolbasicDAO.getCommissionDetailsDAO(params);
		return commissionDetails;
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * policy discount/surcharge list
	 */
	@Override
	public List<GIPIPolbasic> getPolicyDiscountSurcharge(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> policyDiscountSurcharge = gipiPolbasicDAO.getPolicyDiscountDAO(params);
		return policyDiscountSurcharge;
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * item discount/surcharge list
	 */
	@Override
	public List<GIPIPolbasic> getItemDiscountSurcharge(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> itemDiscountSurcharge = gipiPolbasicDAO.getItemDiscountDAO(params);
		return itemDiscountSurcharge; 
	}
	/**
	 * @author rey
	 * @date 08.09.2011
	 * peril discount/surcharge
	 */
	@Override
	public List<GIPIPolbasic> getPerilDiscountSurcharge(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> perilDiscountSurcharge = gipiPolbasicDAO.getPerilDiscountDAO(params);
		return perilDiscountSurcharge;
	}
	/**
	 * @author rey
	 * @date 08.11.2011
	 * policy by assured in account of
	 */
	@Override
	public List<GIPIPolbasic> getPolicyByAssuredInAcctOf(
			HashMap<String, Object> params) throws SQLException {
		List<GIPIPolbasic> policyByAssuredAcctOf = gipiPolbasicDAO.getPolicyByAssuredInAcctOfDAO(params);
		return policyByAssuredAcctOf;
	}	

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#getPolicyListingForRedistribution(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyListingForRedistribution(
			HashMap<String, Object> params) throws SQLException, JSONException, ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareRedisributionPolInfoFilterToMap((String) params.get("filter"))); //change by steven 11/12/2012 from "prepareRedisributionPolInfoFilter"  to "prepareRedisributionPolInfoFilter"
		List<GIPIPolbasic> list = this.getGipiPolbasicDAO().getPolicyListingForRedistribution(params);
		params.put("rows", new JSONArray((List<GIPIPolbasic>) StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/*added by steven 11/12/2012*/
	private Map<String, Object> prepareRedisributionPolInfoFilterToMap(String filter) throws JSONException {
		Map<String, Object> polInfoFilter = new HashMap<String, Object>();
		JSONObject jsonPolInfoFilter = null;
		
		if (null == filter) {
			jsonPolInfoFilter = new JSONObject();
		} else {
			jsonPolInfoFilter = new JSONObject(filter);
		}
		polInfoFilter.put("lineCd",jsonPolInfoFilter.isNull("lineCd") ? ""				:	jsonPolInfoFilter.getString("lineCd").toUpperCase());
		polInfoFilter.put("sublineCd",jsonPolInfoFilter.isNull("sublineCd") ? ""		:	jsonPolInfoFilter.getString("sublineCd").toUpperCase());
		polInfoFilter.put("issCd",jsonPolInfoFilter.isNull("issCd") ? ""				:	jsonPolInfoFilter.getString("issCd").toUpperCase());
		polInfoFilter.put("issueYy",jsonPolInfoFilter.isNull("issueYy") ? null			:	jsonPolInfoFilter.getInt("issueYy"));
		polInfoFilter.put("polSeqNo",jsonPolInfoFilter.isNull("polSeqNo") ? null		:	jsonPolInfoFilter.getInt("polSeqNo"));
		polInfoFilter.put("renewNo",jsonPolInfoFilter.isNull("renewNo") ? null			:	jsonPolInfoFilter.getInt("renewNo"));
		polInfoFilter.put("endtIssCd",jsonPolInfoFilter.isNull("endtIssCd") ? ""		:	jsonPolInfoFilter.getString("endtIssCd").toUpperCase());
		polInfoFilter.put("endtYy",jsonPolInfoFilter.isNull("endtYy") ? null			:	jsonPolInfoFilter.getInt("endtYy"));
		polInfoFilter.put("endtSeqNo",jsonPolInfoFilter.isNull("endtSeqNo") ? null		:	jsonPolInfoFilter.getInt("endtSeqNo"));
		polInfoFilter.put("assdName",jsonPolInfoFilter.isNull("assdName") ? ""			:	jsonPolInfoFilter.getString("assdName").toUpperCase());
		polInfoFilter.put("effDate",jsonPolInfoFilter.isNull("effDate") ? null			:	jsonPolInfoFilter.getString("effDate"));  
		polInfoFilter.put("expiryDate",jsonPolInfoFilter.isNull("expiryDate") ? null	:	jsonPolInfoFilter.getString("expiryDate")); 
		
		return polInfoFilter;
	}
	
	@SuppressWarnings("unused")
	private GIPIPolbasic prepareRedisributionPolInfoFilter(String filter) throws JSONException, ParseException{
		
		GIPIPolbasic polInfoFilter = new GIPIPolbasic();
		JSONObject jsonPolInfoFilter = null;
		if(null == filter){
			jsonPolInfoFilter = new JSONObject();
		}else{
			jsonPolInfoFilter = new JSONObject(filter);
		}
		polInfoFilter.setLineCd(jsonPolInfoFilter.isNull("lineCd") ? ""				:	jsonPolInfoFilter.getString("lineCd").toUpperCase());
		polInfoFilter.setSublineCd(jsonPolInfoFilter.isNull("sublineCd") ? ""		:	jsonPolInfoFilter.getString("sublineCd").toUpperCase());
		polInfoFilter.setIssCd(jsonPolInfoFilter.isNull("issCd") ? ""				:	jsonPolInfoFilter.getString("issCd").toUpperCase());
		polInfoFilter.setIssueYy(jsonPolInfoFilter.isNull("issueYy") ? null			:	jsonPolInfoFilter.getInt("issueYy"));
		polInfoFilter.setPolSeqNo(jsonPolInfoFilter.isNull("polSeqNo") ? null		:	jsonPolInfoFilter.getInt("polSeqNo"));
		polInfoFilter.setRenewNo(jsonPolInfoFilter.isNull("renewNo") ? null			:	jsonPolInfoFilter.getInt("renewNo"));
		polInfoFilter.setEndtIssCd(jsonPolInfoFilter.isNull("endtIssCd") ? ""		:	jsonPolInfoFilter.getString("endtIssCd").toUpperCase());
		polInfoFilter.setEndtYy(jsonPolInfoFilter.isNull("endtYy") ? null			:	jsonPolInfoFilter.getInt("endtYy"));
		polInfoFilter.setEndtSeqNo(jsonPolInfoFilter.isNull("endtSeqNo") ? null		:	jsonPolInfoFilter.getInt("endtSeqNo"));
		polInfoFilter.setAssdName(jsonPolInfoFilter.isNull("assdName") ? ""			:	jsonPolInfoFilter.getString("assdName").toUpperCase());
		
		return polInfoFilter;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#executeGIUWS012V370PostQuery(java.util.Map)
	 */
	@Override
	public void executeGIUWS012V370PostQuery(Map<String, Object> params)
			throws SQLException {
		this.getGipiPolbasicDAO().executeGIUWS012V370PostQuery(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIPolbasicService#checkReinsurancePaymentForRedistribution(java.lang.Integer, java.lang.String)
	 */
	@Override
	public String checkReinsurancePaymentForRedistribution(Integer policyId,
			String lineCd) throws SQLException {
		return this.getGipiPolbasicDAO().checkReinsurancePaymentForRedistribution(policyId, lineCd);
	}
	/**
	 * @author rey
	 * @date 08.16.2011
	 * bond policy data
	 */
	@Override
	public GIPIPolbasic getBondPolicyData(Integer policyId)
			throws SQLException {
		GIPIPolbasic getBondPolicyData = gipiPolbasicDAO.getBondPolicyDataDAO(policyId);
		return getBondPolicyData;
	}
	/**
	 * @author rey
	 * @date 08.16.2011
	 * co signors list
	 */
	@Override
	public List<GIPIPolbasic> getCoSignors(HashMap<String, Object> params)
			throws SQLException {
		List<GIPIPolbasic> coSignorsList = gipiPolbasicDAO.getCoSignorsDAO(params);
		return coSignorsList;
	}

	@Override
	public Map<String, Object> getPackDetailsHeader(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().getPackDetailsHeader(params);
	}

	@Override
	public Map<String, Object> checkPolicyGICLS026(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().checkPolicyGICLS026(params);
	}

	@Override
	public String getRefPolNo(Map<String, Object> params) throws SQLException {
		return this.getGipiPolbasicDAO().getRefPolNo(params);
	}

	@Override
	public List<GIPIPolbasic> checkPolicyGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.gipiPolbasicDAO.checkPolicyGiexs006(params);
	}

	@Override
	public String getEndtTax2GIPIS091(Integer policyId) throws SQLException {
		return this.getGipiPolbasicDAO().getEndtTax2GIPIS091(policyId);
	}

	@Override
	public Map<String, Object> getPolicyInformation(Integer policyId)
			throws SQLException {		
		return this.getGipiPolbasicDAO().getPolicyInformation(policyId);
	}

	@Override
	public Integer getPolBondSeqNo(HttpServletRequest request)
			throws SQLException, NullPointerException {
		Map<String, Object> params = new HashMap<String, Object>();
		try{
			params.put("lineCd", request.getParameter("lineCd"));
			params.put("sublineCd", request.getParameter("sublineCd"));
			params.put("issCd", request.getParameter("issCd"));
			params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
			params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
			params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
			return this.gipiPolbasicDAO.getPolBondSeqNo(params);			
		} catch (NullPointerException e){
			log.info("ERROR: Null Parameter.");
			System.out.println("=====================");
			System.out.println("issueYy: " + request.getParameter("issueYy"));
			System.out.println("polSeqNo: " + request.getParameter("polSeqNo"));
			System.out.println("renewNo: " + request.getParameter("renewNo"));
			System.out.println("=====================");
			throw e;
		}
	}

	@Override
	public String getPolicyId(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().getPolicyId(params);
	}

	@Override
	public Map<String, Object> checkEndtGiuts008a(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().checkEndtGiuts008a(params);
	}

	@Override
	public Map<String, Object> checkPolicyGuits008a(Map<String, Object> params)
			throws SQLException {
		return this.getGipiPolbasicDAO().checkPolicyGuits008a(params);
	}

	@Override
	public String getRefPolNo2(Map<String, Object> params) throws SQLException {
		return this.getGipiPolbasicDAO().getRefPolNo2(params);
	}

	@Override
	public JSONObject showGIPIS131(HttpServletRequest request, GIISUser USER)throws SQLException, JSONException, ParseException {
		System.out.println("::::::::::::::::showGIPIS131::::::::::::::::::");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIPIS131");
		params.put("userId", USER.getUserId());
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("parStat", request.getParameter("parStat"));
		
		System.out.println(params);
		
		/*if(request.getParameter("clear").equals("1"))
			params.put("ACTION", "clearGipis131TableGrid");*/
			
		Map<String, Object> gipis131TableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIPIS131 = new JSONObject(gipis131TableGrid);
		
		return jsonGIPIS131;
	}

	@Override
	public JSONObject showGipis131ParStatusHistory(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGipis131ParHist");
		params.put("parId", Integer.parseInt(request.getParameter("parId")));
		Map<String, Object> gipis131ParStatTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIPIS131ParStat = new JSONObject(gipis131ParStatTableGrid);
		//request.setAttribute("jsonGIPIS131", jsonGIPIS131);
		return jsonGIPIS131ParStat;
	}

	@Override
	public JSONObject showGIPIS132(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		System.out.println("::::::::::::::::showGIPIS132::::::::::::::::::");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showGIPIS132");
		params.put("userId", USER.getUserId());
		params.put("polFlag", request.getParameter("polFlag"));
		params.put("distFlag", request.getParameter("distFlag"));
		params.put("searchByOpt", request.getParameter("searchByOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("parStat", request.getParameter("parStat"));
		params.put("credBranch", request.getParameter("credBranch"));
			
		Map<String, Object> gipis132TableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGIPIS132 = new JSONObject(gipis132TableGrid);
		
		return jsonGIPIS132;
	}

	@Override
	public Integer getMainPolicyId(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMainPolicyId");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		return gipiPolbasicDAO.getMainPolicyId(params);
	}

	@Override
	public Map<String, Object> gipis100ExtractSummary(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", (request.getParameter("issueYy")== null || request.getParameter("issueYy").equals("")) ? 0 : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", (request.getParameter("polSeqNo")== null || request.getParameter("polSeqNo").equals("")) ? 0 : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", (request.getParameter("renewNo")== null || request.getParameter("renewNo").equals("")) ? 0 : Integer.parseInt(request.getParameter("renewNo")));
		params.put("userId", USER.getUserId());
		return this.getGipiPolbasicDAO().gipis100ExtractSummary(params);
	}

	@Override
	public JSONObject showViewDistributionStatus(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("ACTION", "showViewDistributionStatus");
		params.put("distTag", request.getParameter("distTag"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("dateOpt", request.getParameter("dateOpt"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", USER.getUserId());
		params.put("policyId", request.getParameter("policyId"));
		// added by shan 06.05.2014
		params.put("pSublineCd", request.getParameter("sublineCd"));
		params.put("pIssCd", request.getParameter("issCd"));
		params.put("pIssueYy", request.getParameter("issueYy"));
		params.put("pRenewNo", request.getParameter("renewNo"));
		params.put("pPolSeqNo", request.getParameter("polSeqNo"));
		// added by robert SR 20756 01.27.16
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("distNo", request.getParameter("distNo"));
		params.put("endtIssCd", request.getParameter("endtIssCd"));
		params.put("endtYy", request.getParameter("endtYy"));
		params.put("endtSeqNo", request.getParameter("endtSeqNo"));
		
		Map<String, Object> distributionStatusTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject showViewDistributionStatus = new JSONObject(distributionStatusTableGrid);
		request.setAttribute("showViewDistributionStatus", showViewDistributionStatus);
		request.setAttribute("callingModule", request.getParameter("callingModule"));
		request.setAttribute("policyId", request.getParameter("policyId"));
		request.setAttribute("lineCd", request.getParameter("lineCd")); // added by robert SR 4887 09.18.15
		request.setAttribute("sublineCd", request.getParameter("sublineCd")); // added by robert SR 4887 09.18.15
		request.setAttribute("issCd", request.getParameter("issCd")); // added by robert SR 4887 09.18.15
		request.setAttribute("issueYy", request.getParameter("issueYy")); // added by robert SR 4887 09.18.15
		request.setAttribute("renewNo", request.getParameter("renewNo")); // added by robert SR 4887 09.18.15
		request.setAttribute("polSeqNo", request.getParameter("polSeqNo")); // added by robert SR 4887 09.18.15
		return showViewDistributionStatus;		
	}

	@Override
	public JSONObject viewHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewHistory");
		params.put("parId", request.getParameter("parId"));
		
		Map<String, Object> policyHistoryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject viewHistory = new JSONObject(policyHistoryTableGrid);
		request.setAttribute("viewHistory", viewHistory);
		return viewHistory;
	}

	@Override
	public JSONObject viewDistribution(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewDistribution");
		params.put("parId", request.getParameter("parId"));
		params.put("distNo", request.getParameter("distNo"));
		params.put("distFlag", request.getParameter("distFlag"));
		params.put("policyNo", request.getParameter("policyNo"));
		params.put("policyStatus", request.getParameter("policyStatus"));
		params.put("itemSw", request.getParameter("itemSw")); // added by robert SR 4887 10.05.15
		
		Map<String, Object> policyDistributionTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject viewDistribution = new JSONObject(policyDistributionTableGrid);
		request.setAttribute("viewDistribution", viewDistribution);
		return viewDistribution;
	}

	@Override
	public JSONObject getDistDtl(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("ACTION", "getDistDtl");
		params.put("distNo", request.getParameter("distNo"));
		params.put("distSeqNo", request.getParameter("distSeqNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("postFlag", request.getParameter("postFlag"));
		
		Map<String, Object> policyDistributionDtlTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject getDistDtl = new JSONObject(policyDistributionDtlTableGrid);
		request.setAttribute("getDistDtl", getDistDtl);
		return getDistDtl;
	}
	
	@Override
	public JSONObject getDistDtl2(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();

		params.put("ACTION", "getDistDtl2");
		params.put("distNo", request.getParameter("distNo"));
		params.put("distSeqNo", request.getParameter("distSeqNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("postFlag", request.getParameter("postFlag"));
		params.put("itemNo", request.getParameter("itemNo")); // added by robert SR 4887 10.05.15
		Map<String, Object> policyDistributionDtlTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject getDistDtl = new JSONObject(policyDistributionDtlTableGrid);
		request.setAttribute("getDistDtl", getDistDtl);
		return getDistDtl;
	}
	
	@Override
	public JSONObject viewRIPlacement(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewRIPlacement");
		params.put("distNo", request.getParameter("distNo"));
		params.put("distSeqNo", request.getParameter("distSeqNo"));
		params.put("placementSource", request.getParameter("placementSource"));
		
		Map<String, Object> riPlacementTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject viewRIPlacement = new JSONObject(riPlacementTableGrid);
		request.setAttribute("viewRIPlacement", viewRIPlacement);
		return viewRIPlacement;
	}
	
	@Override
	public JSONObject viewSummarizedDist(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewSummarizedDist");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		Map<String, Object> summarizedDistTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject summarizedDist = new JSONObject(summarizedDistTableGrid);
		request.setAttribute("summarizedDist", summarizedDist);
		return summarizedDist;
	}

	@Override
	public String callExtractDistGipis130(HttpServletRequest request) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("extractDate", df.parse(request.getParameter("extractDate")));
		return this.getGipiPolbasicDAO().callExtractDistGipis130(params);
	}

	@Override
	public String onLoadSummarizedDist(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		return this.getGipiPolbasicDAO().onLoadSummarizedDist(params);
	}

	@Override
	public JSONObject viewSummDistRiPlacement(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewSummDistRiPlacement");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		Map<String, Object> summDistRiPlacementTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject summDistRiPlacement = new JSONObject(summDistRiPlacementTableGrid);
		request.setAttribute("summDistRiPlacement", summDistRiPlacement);
		return summDistRiPlacement;
	}

	@Override
	public JSONObject viewBinder(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewBinder");
		params.put("riCd", request.getParameter("riCd") == "" || request.getParameter("riCd") == null ? "" : Integer.parseInt(request.getParameter("riCd")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		Map<String, Object> binderTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject binder = new JSONObject(binderTableGrid);
		request.setAttribute("binder", binder);
		return binder;
	}
	
	@Override
	public JSONObject viewDistItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewDistItem");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		Map<String, Object> distItemTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject distItem = new JSONObject(distItemTableGrid);
		request.setAttribute("distItem", distItem);
		return distItem;
	}

	@Override
	public JSONObject viewDistPerItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewDistPerItem");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		params.put("itemNo", request.getParameter("itemNo") == "" || request.getParameter("itemNo") == null ? "" : Integer.parseInt(request.getParameter("itemNo")));
		Map<String, Object> distPerItemTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject distPerItem = new JSONObject(distPerItemTableGrid);
		request.setAttribute("distPerItem", distPerItem);
		return distPerItem;
	}
	
	@Override
	public JSONObject viewDistPeril(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewDistPeril");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		Map<String, Object> distPerilTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject distPeril = new JSONObject(distPerilTableGrid);
		request.setAttribute("distPeril", distPeril);
		return distPeril;
	}

	@Override
	public JSONObject viewDistPerPeril(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "viewDistPerPeril");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy") == "" || request.getParameter("issueYy") == null ? "" : Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", request.getParameter("polSeqNo") == "" || request.getParameter("polSeqNo") == null ? "" : Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", request.getParameter("renewNo") == "" || request.getParameter("renewNo") == null ? "" : Integer.parseInt(request.getParameter("renewNo")));
		params.put("perilCd", request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? "" : Integer.parseInt(request.getParameter("perilCd")));
		Map<String, Object> distPerPerilTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject distPerPeril = new JSONObject(distPerPerilTableGrid);
		request.setAttribute("distPerPeril", distPerPeril);
		return distPerPeril;
	}

	@Override
	public String insertSummDist(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", Integer.parseInt(request.getParameter("issueYy")));
		params.put("polSeqNo", Integer.parseInt(request.getParameter("polSeqNo")));
		params.put("renewNo", Integer.parseInt(request.getParameter("renewNo")));
		params.put("distNo", request.getParameter("distNo") == "" || request.getParameter("distNo") == null ? "" : Integer.parseInt(request.getParameter("distNo")));
		params.put("distSeqNo", request.getParameter("distSeqNo") == "" || request.getParameter("distSeqNo") == null ? "" : Integer.parseInt(request.getParameter("distSeqNo")));
		return this.getGipiPolbasicDAO().insertSummDist(params);
	}

	@Override
	public JSONObject showReinstateHistory(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showReinstateHistory");
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		Map<String, Object> giuts028ReinstateHistTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReinstatementHistory = new JSONObject(giuts028ReinstateHistTableGrid);
		return jsonReinstatementHistory;
	}

	@Override
	public JSONObject showViewVesselAccumulation(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis109GiisVessel");
		params.put("refresh", "1".equals(request.getParameter("refresh")) ? "Y" : "N");
		params.put("enterQuery", "Y".equals(request.getParameter("enterQuery")) ? "Y" : "N");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showVesselAccumulationDtl(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis109Exposures");
		params.put("vesselCd", request.getParameter("vesselCd"));
		params.put("vesselName", request.getParameter("vesselName"));
		params.put("busType", request.getParameter("busType"));
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		if(!"1".equals(request.getParameter("refresh"))){
			System.out.println("Extracting Vessel Accumulation...");
			getGipiPolbasicDAO().extractVesselAccum(params);
		};
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}
	
	@Override
	public JSONObject showShareExposures(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis109ShareExposure");
		params.put("rvLowValue", request.getParameter("rvLowValue"));
		params.put("vesselCd", request.getParameter("vesselCd"));
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showTemporaryExposures(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis109TempExposure");
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("vesselCd", request.getParameter("vesselCd"));
		params.put("mode", request.getParameter("mode"));
		params.put("all", request.getParameter("all"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showActualExposures(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis109ActualExposure");
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("shareCd", request.getParameter("shareCd"));
		params.put("vesselCd", request.getParameter("vesselCd"));
		params.put("all", request.getParameter("all"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public String extractRecapsVI(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("rdoGroup1", request.getParameter("rdoGroup1"));
		params.put("rdoGroup2", request.getParameter("rdoGroup2"));
		return this.getGipiPolbasicDAO().extractRecapsVI(params);
	}

	@Override
	public String checkExtractedRecordsBeforePrint(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rdoGroup1", request.getParameter("rdoGroup1"));
		params.put("rdoGroup2", request.getParameter("rdoGroup2"));
		return this.getGipiPolbasicDAO().checkExtractedRecordsBeforePrint(params);
	}
	
	/* benjo 06.01.2015 GENQA AFPGEN_IMPLEM SR 4150 */
	@Override
	public Map<String, Object> checkRecapsVIBeforeExtract(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		return this.getGipiPolbasicDAO().checkRecapsVIBeforeExtract(params);
	}

	@Override
	public JSONObject showPackagePolicyInformation(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showPackagePolicyInformation");
		params.put("packPolId", request.getParameter("packPolId"));
		Map<String, Object> packagePolicyTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonpackagePolicyTable = new JSONObject(packagePolicyTable);
		//request.setAttribute("jsonpackagePolicyTable", jsonpackagePolicyTable);
		return jsonpackagePolicyTable;	
	}

	@Override
	public JSONObject showPackagePolicyItem(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showPackagePolicyItem");
		params.put("packPolId", request.getParameter("packPolId"));
		Map<String, Object> packagePolicyItemTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonpackagePolicyItemTable = new JSONObject(packagePolicyItemTable);
		request.setAttribute("jsonpackagePolicyItemTable", jsonpackagePolicyItemTable);
		return jsonpackagePolicyItemTable;	
	}

	@Override
	public JSONObject showViewIntermediaryCommission(
			HttpServletRequest request, String userId) throws SQLException,
			JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis139IntermediaryComm");
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showIntermediaryCommissionlOverlay(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("lineCd", request.getParameter("lineCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		request.setAttribute("intmNo", request.getParameter("intmNo"));
		request.setAttribute("issCd", request.getParameter("issCd"));
		request.setAttribute("premSeqNo", request.getParameter("premSeqNo"));
		request.setAttribute("policyId", request.getParameter("policyId"));
		request.setAttribute("lineCd", request.getParameter("lineCd"));
		return jsonObj;
	}

	@Override
	public JSONObject getMotorCarInquiryRecords(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		System.out.println("::::::::::showMotorCarPolicyInquiry::::::::::");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMotorCarInquiryRecords");
		params.put("userId", USER.getUserId());
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("credBranch", request.getParameter("credBranch"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		
		request.setAttribute("policyId", request.getParameter("policyId"));
		request.setAttribute("itemNo", request.getParameter("itemNo "));
		
		Map<String, Object> motorCarInquiryTable = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMotorCarInquiryTable = new JSONObject(motorCarInquiryTable);
		
		return jsonMotorCarInquiryTable;
	}

	@Override
	public JSONObject saveGIPIS175(HttpServletRequest request, String userId)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemGrp", request.getParameter("itemGrp"));
		params.put("userId", userId);
		params.put("premSeqNo", request.getParameter("premSeqNo"));
		params.put("acctEntDate", request.getParameter("acctEntDate"));
		params.put("coInsuranceSw", request.getParameter("coInsuranceSw"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		//params.put("riCommRate", request.getParameter("riCommRate"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("riCd", request.getParameter("riCd"));
		params.put("prevRiCommAmt", request.getParameter("prevRiCommAmt"));
		params.put("oldRiCommVat", request.getParameter("oldRiCommVat"));
		
		JSONObject objPerils = new JSONObject(request.getParameter("parameters"));
		JSONArray arr = new JSONArray(objPerils.getString("setRows"));
				
		List<Map<String, Object>> perilList = new ArrayList<Map<String, Object>>();
		
		
		for(int i = 0; i < arr.length(); i++){
			JSONObject rec = arr.getJSONObject(i);
			Map<String, Object> perilMap = new HashMap<String, Object>();
			perilMap.put("policyId", rec.getString("policyId"));
			perilMap.put("sumCommAmt", request.getParameter("sumCommAmt"));
			perilMap.put("riCommRate", rec.getString("riCommRate"));
			perilMap.put("riCommAmt", rec.getString("riCommAmt"));
			perilMap.put("itemNo", rec.getString("itemNo"));
			perilMap.put("perilCd", rec.getString("perilCd"));
			perilMap.put("userId", userId);
			perilMap.put("oldRiCommRate", rec.getString("oldRiCommRate"));
			perilMap.put("oldRiCommAmt", rec.getString("oldRiCommAmt"));
			perilMap.put("riCommRate", rec.getString("riCommRate"));
			perilMap.put("riCommAmt", rec.getString("riCommAmt"));
			perilMap.put("acctEntDate", request.getParameter("acctEntDate"));
			perilMap.put("coInsuranceSw", request.getParameter("coInsuranceSw"));
			perilMap.put("itemGrp", request.getParameter("itemGrp"));
			perilList.add(perilMap);
		}
		
		params.put("perilList", perilList);
		
		gipiPolbasicDAO.saveGIPIS175(params);
		return null;
	}

	@Override
	public JSONObject showViewExposuresPerPAEnrollees(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showViewExposuresPerPAEnrollees");
		params.put("userId", userId);
		params.put("searchBy", request.getParameter("searchBy"));
		params.put("searchDate", request.getParameter("searchDate"));
		params.put("asOfDate", request.getParameter("asOfDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		
		Map<String, Object> exposureList = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonExposureList = new JSONObject(exposureList);
		
		return jsonExposureList;
	}

	@Override
	public JSONObject showViewCasualtyAccumulation(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis111GiisCaLocation");
		params.put("enterQuery", "Y".equals(request.getParameter("enterQuery")) ? "Y" : "N");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showCasualtyAccumulationDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis111GiisCaLocationDtl");
		params.put("locationCd", request.getParameter("locationCd"));
		params.put("busType", request.getParameter("busType"));
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		if(!"1".equals(request.getParameter("refresh"))){
			System.out.println("Extracting Casualty Accumulation...");
			getGipiPolbasicDAO().extractCasualtyAccum(params);
		};
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showGipis111ActualExposures(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis111ActualExposure");
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("locationCd", request.getParameter("locationCd"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showGipis111TemporaryExposures(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis111TemporaryExposure");
		params.put("excludeExpired", request.getParameter("excludeExpired"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("locationCd", request.getParameter("locationCd"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject getUserInformationList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getUserInformationList");
		params.put("appUser", USER.getUserId());
		Map<String, Object> userInFoTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonUserInfo = new JSONObject(userInFoTbg);
		request.setAttribute("jsonUserInfo", jsonUserInfo);
		return jsonUserInfo;
	}

	@Override
	public JSONObject getTranList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTranList");
		params.put("userId", request.getParameter("userId"));
		Map<String, Object> tranListTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTranList = new JSONObject(tranListTbg);
		request.setAttribute("jsonTranList", jsonTranList);
		return jsonTranList;
	}

	@Override
	public JSONObject getTranIssList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTranIssList");
		params.put("userId", request.getParameter("userId"));
		params.put("tranCd", request.getParameter("tranCd"));
		Map<String, Object> tranIssTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTranIss = new JSONObject(tranIssTbg);
		request.setAttribute("jsonTranIss", jsonTranIss);
		return jsonTranIss;
	}

	@Override
	public JSONObject getTranLineList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTranLineList");
		params.put("userId", request.getParameter("userId"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		Map<String, Object> tranIssTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTranLine = new JSONObject(tranIssTbg);
		request.setAttribute("jsonTranLine", jsonTranLine);
		return jsonTranLine;
	}

	@Override
	public JSONObject getModuleList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getModuleList");
		params.put("userId", request.getParameter("userId"));
		params.put("tranCd", request.getParameter("tranCd"));
		Map<String, Object> moduleListTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonModuleList = new JSONObject(moduleListTbg);
		request.setAttribute("jsonModuleList", jsonModuleList);
		return jsonModuleList;
	}

	@Override
	public JSONObject getGrpTranList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGrpTranList");
		params.put("userGrp", request.getParameter("userGrp"));
		Map<String, Object> grpTranTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonTranGrp = new JSONObject(grpTranTbg);
		request.setAttribute("jsonTranGrp", jsonTranGrp);
		return jsonTranGrp;
	}

	@Override
	public JSONObject getGrpTranIssList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGrpTranIssList");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		Map<String, Object> grpTranIssTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGrpTranIss = new JSONObject(grpTranIssTbg);
		request.setAttribute("jsonGrpTranIss", jsonGrpTranIss);
		return jsonGrpTranIss;
	}

	@Override
	public JSONObject getGrpTranLineList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGrpTranLineList");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		Map<String, Object> grpTranLineTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGrpTranLine = new JSONObject(grpTranLineTbg);
		request.setAttribute("jsonGrpTranLine", jsonGrpTranLine);
		return jsonGrpTranLine;
	}

	@Override
	public JSONObject getGrpModuleList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGrpModuleList");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		Map<String, Object> grpModuleTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGrpModule = new JSONObject(grpModuleTbg);
		request.setAttribute("jsonGrpModule", jsonGrpModule);
		return jsonGrpModule;
	}

	@Override
	public JSONObject getHistoryList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getHistoryList");
		params.put("userId", request.getParameter("userId"));
		Map<String, Object> histortyTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonHistory = new JSONObject(histortyTbg);
		request.setAttribute("jsonHistory", jsonHistory);
		return jsonHistory;
	}
	
	@Override
	public JSONObject showViewBlockAccumulation(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110GiisBlock");
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showBlockAccumulationDtl(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110GiisBlockDtl");
		params.put("blockId", request.getParameter("blockId"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("exclude", request.getParameter("exclude"));
		params.put("userId", userId);
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("city", request.getParameter("city"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("busType", request.getParameter("busType"));
		if (!"1".equals(request.getParameter("refresh"))) {
			log.info("Extracting Block Accumulation...");
			log.info("Parameters: " + params);
			getGipiPolbasicDAO().extractBlockAccum(params);
		};
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public String gipis110CheckFiAccess(String userId) throws SQLException {
		return getGipiPolbasicDAO().gipis110CheckFiAccess(userId);
	}

	@Override
	public JSONObject showBlockShareExposures(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110ShareExposure");
		params.put("exclude", request.getParameter("exclude"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("rvLowValue", request.getParameter("rvLowValue"));
		params.put("blockId", request.getParameter("blockId"));
		params.put("districtNo", request.getParameter("districtNo"));
		params.put("blockNo", request.getParameter("blockNo"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("city", request.getParameter("city"));
		params.put("riskCd", request.getParameter("riskCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showGipis110ActualExposures(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110ActualExposure");
		params.put("exclude", request.getParameter("exclude"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("shareType", request.getParameter("shareType"));
		params.put("blockId", request.getParameter("blockId"));
		params.put("userId", userId);
		params.put("mode", request.getParameter("mode"));
		params.put("all", request.getParameter("all"));
		params.put("riskCd", request.getParameter("riskCd")); //nieko 07132016 kb 894, added riskCd parameter
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}

	@Override
	public JSONObject showGipis110TemporaryExposures(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110TemporaryExposure");
		params.put("exclude", request.getParameter("exclude"));
		params.put("excludeNotEff", request.getParameter("excludeNotEff"));
		params.put("shareType", request.getParameter("shareType"));
		params.put("blockId", request.getParameter("blockId"));
		params.put("userId", userId);
		params.put("mode", request.getParameter("mode"));
		params.put("all", request.getParameter("all"));
		params.put("riskCd", request.getParameter("riskCd")); //nieko 07132016 kb 894, added riskCd parameter
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	}
	
	@Override
	public String gipis191ExtractRiskCategory(HttpServletRequest request,
			String userId) throws SQLException {		
		Map <String, Object> params = new HashMap<String, Object>();		
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("basis", request.getParameter("basis"));
		params.put("userId", userId);		
		return gipiPolbasicDAO.gipis191ExtractRiskCategory(params);
	}
	
	public Map<String, Object>getGIPIS191Params(String userId) throws SQLException {
		return gipiPolbasicDAO.getGIPIS191Params(userId);
	}
	
	@Override
	public JSONObject checkViewProdDtls(HttpServletRequest request,
			String userId) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("userId", userId);	
		params.put("message", "");	
		params = this.getGipiPolbasicDAO().checkViewProdDtls(params);		
		JSONObject result = new JSONObject(params);
		return result;
	}
	
	@Override
	public JSONObject extractProduction(HttpServletRequest request,
			String userId) throws SQLException {	
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("credIss", request.getParameter("credIss"));
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		params.put("distFlag", request.getParameter("distFlag"));		
		params.put("regPolicySw", request.getParameter("regPolicySw"));
		params.put("userId", userId);	
		params.put("message", "");	
		params.put("noOfPolicies", "");	
		params.put("totalTsi", "");	
		params.put("totalPrem", "");
		params.put("totalTax", "");	
		params.put("totalCommission", "");					
		params = this.getGipiPolbasicDAO().extractProduction(params);		
		JSONObject result = new JSONObject(params);
		return result;
	}
	
	@Override
	public JSONObject getProductionDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getProductionDetails");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));	
		params.put("intmNo", request.getParameter("intmNo"));	
		params.put("credIss", request.getParameter("credIss"));	
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		params.put("distFlag", request.getParameter("distFlag"));	
		params.put("regPolicySw", request.getParameter("regPolicySw"));	
		params.put("userId", USER.getUserId());	
		Map<String, Object> productionDetailsTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonProductionDetails = new JSONObject(productionDetailsTbg);		
		request.setAttribute("jsonProductionDetails", jsonProductionDetails);
		return jsonProductionDetails;
	}
	
	@Override
	public Map<String, Object> validateGIPIS201Access(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("issCd", request.getParameter("issCd"));	
		params.put("userId", USER.getUserId());
		return this.getGipiPolbasicDAO().validateGIPIS201Access(params);
	}

	@Override
	public JSONObject getProdPolicyDetails(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getProdPolicyDetails");
		params.put("lineCd1", request.getParameter("lineCd1"));
		params.put("sublineCd1", request.getParameter("sublineCd1"));
		params.put("issCd1", request.getParameter("issCd1"));
		params.put("issueYy1", request.getParameter("issueYy1"));	
		params.put("polSeqNo1", request.getParameter("polSeqNo1"));	
		params.put("renewNo1", request.getParameter("renewNo1"));	
		params.put("policyId", request.getParameter("policyId"));	
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("month", request.getParameter("month"));
		params.put("year", request.getParameter("year"));
		params.put("distFlag", request.getParameter("distFlag"));
		params.put("userId", USER.getUserId());	
		Map<String, Object> prodPolicyDetailsTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonProdPolicyDetails = new JSONObject(prodPolicyDetailsTbg);		
		return jsonProdPolicyDetails;
	}

	@Override
	public Map<String, Object> validateGIPIS201DisplayORC(HttpServletRequest request)
			throws SQLException {		
		return this.getGipiPolbasicDAO().validateGIPIS201DisplayORC();
	}

	@Override
	public JSONObject getGIPIS201CommDtls(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getGIPIS201CommDtls");		
		params.put("policyId", request.getParameter("policyId"));	
		params.put("issCd", request.getParameter("issCd"));	
		params.put("lineCd", request.getParameter("lineCd"));	
		params.put("intmNo", request.getParameter("intmNo"));	
		Map<String, Object> commissionDetailsTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonCommDetails = new JSONObject(commissionDetailsTbg);	
		return jsonCommDetails;
	}

	@Override
	public JSONObject getDiscountSurcharge(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getDiscSurcList");		
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("discSw", request.getParameter("discSw"));
		params.put("surcSw", request.getParameter("surcSw"));
		params.put("moduleId", request.getParameter("moduleId"));	
		params.put("userId", USER.getUserId());	
		Map<String, Object> discSurcList = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonDiscSurc = new JSONObject(discSurcList);	
		return jsonDiscSurc;
	}	
	
	public JSONObject getDiscSurcDetails(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		/*String action = request.getParameter("pge");
		action = "get" + action.substring(0, 1).toUpperCase() + action.substring(1);
		params.put("ACTION", action);*/
		params.put("ACTION", "getDiscSurcDetails");
		params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
		params.put("type", request.getParameter("type"));
		Map<String, Object> discSurcDtl = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonDiscSurcDtl = new JSONObject(discSurcDtl);	
		return jsonDiscSurcDtl;
	}

	@Override
	public JSONObject showEndtTypeList(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIS100EndtTypeList");
		params.put("endtCd", request.getParameter("endtCd"));
		
		Map<String, Object> endtTypeListTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(endtTypeListTableGrid);
		return json;
	}	

	@Override
	public JSONObject getEndtPolicyDates(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = this.getGipiPolbasicDAO().getEndtPolicyDates(Integer.parseInt(request.getParameter("parId")));
		JSONObject json = new JSONObject(params);
		return json;
	}
	
	@Override
	public JSONObject getGIPIS156BasicInfo(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("ACTION", "getGIPIS156BasicInfo");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("endtYy", request.getParameter("endtYy"));
		params.put("endtSeqNo", request.getParameter("endtSeqNo"));
		params.put("credBranch", request.getParameter("credBranch"));
		
		Map<String, Object> gipis156BasicInfoMap = gipiPolbasicDAO.getGIPIS156BasicInfo(params);
		JSONObject gipis156BasicInfo = new JSONObject(gipis156BasicInfoMap);
		return gipis156BasicInfo;
	}
	
	/*
	 * Added by: hdrtagudin
	 * Date: 07302015
	 * SR No: 19751
	 */
	public String getIssCdRI() throws SQLException{
		return this.getGipiPolbasicDAO().getIssCdRI();
	}
	
	public JSONObject getInitialAcceptance(Map<String, Object> params) throws SQLException, JSONException{
		Integer policyId = Integer.parseInt(params.get("policyId").toString());		
		Map<String, Object> initialAcceptanceMap = gipiPolbasicDAO.getInitialAcceptance(policyId);
		JSONObject initialAcceptance = new JSONObject(StringFormatter.escapeHTMLInMap(initialAcceptanceMap));
		
		return initialAcceptance;
	}

	/*
	 * nieko 07132016
	 * kb 894
	 */
	public JSONObject showBlockRisk(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGipis110BlockRisk");
		params.put("blockId", request.getParameter("blockId"));
		
		log.info("Parameters: " + params);
		log.info("Getting Block Risk nieko 3...");
		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonObj = new JSONObject(map);
		return jsonObj;
	} 

	public Integer getParId(String policyId) throws SQLException {
		return this.getGipiPolbasicDAO().getParId(policyId);
	}
}
