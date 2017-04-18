/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISIntermediaryDAO;
import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISIntermediaryService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISIntermediaryServiceImpl.
 */
public class GIISIntermediaryServiceImpl implements GIISIntermediaryService {

	/** The log. */
	private Logger log = Logger.getLogger(GIISIntermediaryServiceImpl.class);
		
	/** The giis intermediary dao. */
	private GIISIntermediaryDAO giisIntermediaryDAO;
	
	/**
	 * Sets the giis intermediary dao.
	 * 
	 * @param giisIntermediaryDAO the new giis intermediary dao
	 */
	public void setGiisIntermediaryDAO(GIISIntermediaryDAO giisIntermediaryDAO) {
		this.giisIntermediaryDAO = giisIntermediaryDAO;
	}

	/**
	 * Gets the giis intermediary dao.
	 * 
	 * @return the giis intermediary dao
	 */
	public GIISIntermediaryDAO getGiisIntermediaryDAO() {
		return giisIntermediaryDAO;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getIntermediaryList(int)
	 */
	@Override
	public List<GIISIntermediary> getIntermediaryList(int intmNo)
			throws SQLException {
		log.info("Retrieving GIIS Intermediaries...");
		List<GIISIntermediary> giisIntermediaries = this.getGiisIntermediaryDAO().getIntermediaryList(intmNo);
		log.info(giisIntermediaries.size() + " GIIS Intermediaries retrived.");
		
		return giisIntermediaries;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getParentIntermediaryName(int)
	 */
	@Override
	public String getParentIntermediaryName(int parentIntmNo)
			throws SQLException {
		log.info("Retrieving Parent Intermediary Name...");
		String parentIntmName = this.getGiisIntermediaryDAO().getParentIntermediaryName(parentIntmNo);
		log.info("Parent Intermediary Name retrieved.");
		
		return parentIntmName;
	}

	@Override
	public BigDecimal getDefaultTaxRate(int intmNo) throws SQLException {
		log.info("Retrieving default tax rate...");
		BigDecimal taxRate = this.getGiisIntermediaryDAO().getDefaultTaxRate(intmNo);
		log.info("Default tax rate retrieved.");
		
		return taxRate;
	}

	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPayorLOV(Integer pageNo, String keyword) throws SQLException {
		log.info("Retrieving payor lov list...");
		List<GIISIntermediary> payorLOV= this.getGiisIntermediaryDAO().getPayorLOV(keyword);
		PaginatedList paginatedList = new PaginatedList(payorLOV, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		log.info("Payor lov list retrieved.");
		return paginatedList;
	}
	
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getPayorLOV2(HttpServletRequest request, Integer pageNo) throws SQLException {
		log.info("Retrieving payor lov list...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("keyword", request.getParameter("keyword") == null ? "" : request.getParameter("keyword"));
		params.put("riCommTag", request.getParameter("riCommTag") == null ? "" : request.getParameter("riCommTag"));
		
		List<GIISIntermediary> payorLOV= this.getGiisIntermediaryDAO().getPayorLOV2(params);
		PaginatedList paginatedList = new PaginatedList(payorLOV, ApplicationWideParameters.PAGE_SIZE);		
		paginatedList.gotoPage(pageNo);
		log.info("Payor lov list retrieved.");
		return paginatedList;
	}

	@Override
	public List<GIISIntermediary> getAllGIISIntermediary() throws SQLException {
		log.info("Retrieving intermediary lov list...");
		List<GIISIntermediary> intmList = this.getGiisIntermediaryDAO().getAllGIISIntermediary();		
		log.info("Intermediary lov list retrieved.");
		return intmList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getGIPICommInvoiceIntmList(java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public List<GIISIntermediary> getGIPICommInvoiceIntmList(String tranType,
			String issCd, String premSeqNo, String intmName) throws SQLException {
		return this.getGiisIntermediaryDAO().getGIPICommInvoiceIntmList(tranType, issCd, premSeqNo, intmName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getIntermediaryList2(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getIntermediaryList2(Integer pageNo, String keyword) throws SQLException {
		List<GIISIntermediary> giisIntermediary = this.getGiisIntermediaryDAO().getIntermediaryList2(keyword);
		PaginatedList paginatedList = new PaginatedList(giisIntermediary, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getBancaIntermediaryList(java.lang.Integer, java.lang.String, java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getBancaIntermediaryList(Integer pageNo,
			String keyword, String bancTypeCd, String intmType)
			throws SQLException {
		List<GIISIntermediary> giisIntermediary = this.getGiisIntermediaryDAO().getBancaIntermediaryList(keyword, bancTypeCd, intmType);
		PaginatedList paginatedList = new PaginatedList(giisIntermediary, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISIntermediaryService#getGipis085IntmLOVListing(java.lang.Integer, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGipis085IntmLOVListing(Integer pageNo,
			Map<String, Object> params) throws SQLException {
		List<GIISIntermediary> giisIntermediary = this.getGiisIntermediaryDAO().getGipis085IntmLOVListing(params);
		PaginatedList paginatedList = new PaginatedList(giisIntermediary, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public void getPremWarrLetter(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("assdName", request.getParameter("assdName"));
		params.put("reportId", request.getParameter("reportId"));
		params = this.giisIntermediaryDAO.getPremWarrLetter(params);
		request.setAttribute("premWarrLetter", new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString());
	}
	
	@Override
	public Map<String, Object> validateIntmNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiisIntermediaryDAO().validateIntmNo(params);
	}

	@Override
	public Map<String, Object> validateIntmType(Map<String, Object> params)
			throws SQLException {
		return this.getGiisIntermediaryDAO().validateIntmType(params);
	}

	@Override
	public List<GIISIntermediary> validateIntmNoGiexs006(Integer intmNo)
			throws SQLException {
		return this.getGiisIntermediaryDAO().validateIntmNoGiexs006(intmNo);
	}

	@Override
	public String getParentIntmNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParentIntmNo");
		params.put("intmNo", request.getParameter("intmNo").equals("")?null : Integer.parseInt(request.getParameter("intmNo")));
		return this.giisIntermediaryDAO.getParentIntmNo(params);
	}

	@Override
	public String extractIntmProdColln(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap <String, Object>();
		params.put("branchParam", request.getParameter("branchParam"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("paramDate", request.getParameter("paramDate"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		
		System.out.println("parameters : " + params);
		giisIntermediaryDAO.extractIntmProdColln(params);
		
		return params.get("count").toString();
	}

	@Override
	public String extractWeb(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap <String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("dateParam", request.getParameter("dateParam"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("issParam", request.getParameter("issParam"));
		params.put("userId", userId);
		
		System.out.println("parameters : " + params);
		giisIntermediaryDAO.extractWeb(params);
		
		return params.get("count").toString();
	}
	
	// shan 11.7.2013
	public JSONObject showGiiss203(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss203RecList");	
		params.put("setWhere", request.getParameter("setWhere"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		JSONObject json = new JSONObject(this.giisIntermediaryDAO.valDeleteRec(params));
		
		return json.toString();
	}

	@Override
	public void saveGiiss203(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISIntermediary.class));
		//params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISIntermediary.class));
		params.put("appUser", userId);
		this.giisIntermediaryDAO.saveGiiss203(params);
	}

	/*@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("intmNo") != null){
			Integer intmNo = Integer.parseInt(request.getParameter("intmNo"));
			this.giisIntermediaryDAO.valAddRec(intmNo);
		}
	}*/
	
	public GIISIntermediary getGiiss076Record(Integer intmNo) throws SQLException{
		return this.giisIntermediaryDAO.getGiiss076Record(intmNo);
	}
	
	public String getRequireWtax() throws SQLException{
		return this.giisIntermediaryDAO.getRequireWtax();
	}
	
	public String getParentTinGiiss076(Integer parentIntmNo) throws SQLException{
		return this.giisIntermediaryDAO.getParentTinGiiis076(parentIntmNo);
	}
	
	public String getGiacParamValueN(String paramName) throws SQLException{
		return this.giisIntermediaryDAO.getGiacParamValueN(paramName);
	}
	
	public Integer valIntmNameGiiss076(String intmName) throws SQLException{
		return this.giisIntermediaryDAO.valIntmNameGiiis076(intmName);
	}
	
	public void valDeleteRecGiiss076(Integer intmNo) throws SQLException{
		this.giisIntermediaryDAO.valDeleteRecGiiis076(intmNo);
	}
	
	@Override
	public String saveGiiss076(HttpServletRequest request, String userId)throws SQLException, JSONException, ParseException {
		GIISIntermediary intm = new GIISIntermediary();
		//JSONObject addtlInfo = new JSONObject(request.getParameter("addtlInfo"));
		JSONObject variables = new JSONObject(request.getParameter("variables"));
		String recordStatus = request.getParameter("recordStatus");
		Integer intmNo = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		if ("-1".equals(recordStatus)){	//deleted
			intmNo = Integer.parseInt(request.getParameter("hidIntmNo"));
		}else {	
			if ("0".equals(recordStatus)){	// new record
				intmNo = this.giisIntermediaryDAO.getIntermediaryNoSequence();
				//intm.setvWtaxRate(variables.getString("vWtaxRate").equals("") ? new BigDecimal("") : new BigDecimal(variables.getString("vWtaxRate")));
			}else{
				intmNo = Integer.parseInt(request.getParameter("intmNo"));
			}
			
			intm.setvWtaxRate(variables.getString("vWtaxRate"));	
			intm.setActiveTag(request.getParameter("activeTag"));
			intm.setBillAddr1(StringFormatter.unescapeHTML2(request.getParameter("billAddr1")));
			intm.setBillAddr2(StringFormatter.unescapeHTML2(request.getParameter("billAddr2")));
			intm.setBillAddr3(StringFormatter.unescapeHTML2(request.getParameter("billAddr3")));
			intm.setBirthdate(request.getParameter("birthdate").equals("") ? null : df.parse(request.getParameter("birthdate")));
			intm.setCaDate(request.getParameter("caDate").equals("") ? null : df.parse(request.getParameter("caDate")));
			intm.setCaNo(StringFormatter.unescapeHTML2(request.getParameter("caNo")));
			intm.setCoIntmType(StringFormatter.unescapeHTML2(request.getParameter("coIntmType")));
			intm.setCoIntmTypeName(StringFormatter.unescapeHTML2(request.getParameter("coIntmTypeName")));
			intm.setContactPerson(StringFormatter.unescapeHTML2(request.getParameter("contactPerson")));
			intm.setCorpTag(request.getParameter("corpTag"));
			intm.setDesignation(StringFormatter.unescapeHTML2(request.getParameter("designation")));
			intm.setInputVatRate(new BigDecimal(request.getParameter("inputVatRate")));
			intm.setIntmName(StringFormatter.unescapeHTML2(request.getParameter("intmName")));
			intm.setIntmType(StringFormatter.unescapeHTML2(request.getParameter("intmType")));
			intm.setIntmTypeDesc(StringFormatter.unescapeHTML2(request.getParameter("intmTypeDesc")));
			intm.setIssCd(StringFormatter.unescapeHTML2(request.getParameter("issCd")));
			intm.setIssName(StringFormatter.unescapeHTML2(request.getParameter("issName")));
			intm.setLfTag(request.getParameter("lfTag"));
			intm.setLicTag(request.getParameter("licTag"));
			intm.setMailAddr1(StringFormatter.unescapeHTML2(request.getParameter("mailAddr1")));
			intm.setMailAddr2(StringFormatter.unescapeHTML2(request.getParameter("mailAddr2")));
			intm.setMailAddr3(StringFormatter.unescapeHTML2(request.getParameter("mailAddr3")));
			intm.setMasterIntmNo(request.getParameter("masterIntmNo") == "" ? null : Integer.parseInt(request.getParameter("masterIntmNo")));
			intm.setOldIntmNo(request.getParameter("oldIntmNo") == "" ?  null : Integer.parseInt(request.getParameter("oldIntmNo")));
			intm.setParentDesignation(StringFormatter.unescapeHTML2(request.getParameter("parentDesignation")));
			intm.setParentIntmName(StringFormatter.unescapeHTML2(request.getParameter("parentIntmName")));
			intm.setParentIntmNo(request.getParameter("parentIntmNo") == "" ? null : Integer.parseInt(request.getParameter("parentIntmNo")));
			intm.setPaytTerms(StringFormatter.unescapeHTML2(request.getParameter("paytTerms")));
			intm.setPaytTermsDesc(StringFormatter.unescapeHTML2(request.getParameter("paytTermsDesc")));
			intm.setPhoneNo(request.getParameter("phoneNo"));
			intm.setPrntIntmTinSw(request.getParameter("prntIntmTinSw"));			
			intm.setRefIntmCd(request.getParameter("refIntmCd"));
			intm.setRemarks(StringFormatter.unescapeHTML2(request.getParameter("remarks")));
			intm.setSpecialRate(request.getParameter("specialRate"));
			intm.setTin(StringFormatter.unescapeHTML2(request.getParameter("tin")));
			intm.setWhtaxCode(request.getParameter("whtaxCode") == "" ? null : Integer.parseInt(request.getParameter("whtaxCode")));
			intm.setWhtaxDesc(StringFormatter.unescapeHTML2(request.getParameter("whtaxDesc")));
			intm.setWhtaxId(request.getParameter("whtaxId") == "" ? null : Integer.parseInt(request.getParameter("whtaxId")));
			intm.setWtaxRate(new BigDecimal(request.getParameter("wtaxRate")));
			intm.setNickname(StringFormatter.unescapeHTML2(request.getParameter("hidNickname")));
			intm.setEmailAdd(StringFormatter.unescapeHTML2(request.getParameter("hidEmailAdd")));
			intm.setFaxNo(StringFormatter.unescapeHTML2(request.getParameter("hidFaxNo")));
			intm.setCpNo(StringFormatter.unescapeHTML2(request.getParameter("hidCpNo")));
			intm.setSunNo(StringFormatter.unescapeHTML2(request.getParameter("hidSunNo")));
			intm.setGlobeNo(StringFormatter.unescapeHTML2(request.getParameter("hidGlobeNo")));
			intm.setSmartNo(StringFormatter.unescapeHTML2(request.getParameter("hidSmartNo")));
			intm.setHomeAdd(StringFormatter.unescapeHTML2(request.getParameter("hidHomeAdd")));
		}
		
		intm.setIntmNo(intmNo);
		intm.setChgItem(variables.getString("chgItem").equals("") ? "" : variables.getString("chgItem"));
		intm.setvIntmType(variables.getString("vIntmType").equals("") ? "" : variables.getString("vIntmType"));
		intm.setUserId(userId);
		intm.setRecordStatus(recordStatus);
		
		System.out.println("============= INTM: " + intm);
		System.out.println("chg_item: " + intm.getChgItem() );
		System.out.println("v_intm_type: " + intm.getvIntmType());
		
		this.giisIntermediaryDAO.saveGiiss076(intm);
		
		// after saving record
		
		if ("-1".equals(recordStatus)){	//deleted
			intmNo = null;
			recordStatus = "0";	
		}else if("0".equals(recordStatus)){
			recordStatus = null;
		}
		
		JSONObject json = new JSONObject();
		json.append("intmNo", intmNo);
		json.append("recordStatus", recordStatus);
		
		return json.toString();
	}
	
	public Integer copyIntermediaryGiiss076(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", Integer.parseInt(request.getParameter("intmNo")));
		
		params = this.giisIntermediaryDAO.copyIntermediaryGiiss076(params);
		
		return Integer.parseInt(params.get("newIntmNo").toString());
	}
	
	public String checkMobilePrefixGiiss076(HttpServletRequest request) throws SQLException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("param", request.getParameter("param"));
		params.put("prefix", request.getParameter("prefix"));
		
		return this.giisIntermediaryDAO.checkMobilePrefixGiiss076(params);
	}

	@Override
	public String valCommRate(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("intmNo", request.getParameter("intmNo"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("commRate", request.getParameter("commRate"));
		return this.giisIntermediaryDAO.valCommRate(params);
	}
}
