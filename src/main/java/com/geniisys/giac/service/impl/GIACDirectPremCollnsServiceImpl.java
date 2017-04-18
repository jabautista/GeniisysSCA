package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDirectPremCollnsDAO;
import com.geniisys.giac.entity.GIACDirectPremCollns;
import com.geniisys.giac.service.GIACDirectPremCollnsService;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.geniisys.gipi.service.GIPIPolbasicService;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIACDirectPremCollnsServiceImpl implements GIACDirectPremCollnsService{
	
	private GIACDirectPremCollnsDAO giacDirectPremCollnsDAO;
	//private LOVHelper helper;
	private GIPIInstallmentService gipiInstallmentService;
	private GIACModulesService giacModulesService;
	private GIPIPolbasicService gipiPolService;
	
	/**
	 * @return the giacModulesService
	 */
	public GIACModulesService getGiacModulesService() {
		return giacModulesService;
	}

	/**
	 * @param giacModulesService the giacModulesService to set
	 */
	public void setGiacModulesService(GIACModulesService giacModulesService) {
		this.giacModulesService = giacModulesService;
	}

	/**
	 * @return the gipiPolService
	 */
	public GIPIPolbasicService getGipiPolService() {
		return gipiPolService;
	}

	/**
	 * @param gipiPolService the gipiPolService to set
	 */
	public void setGipiPolService(GIPIPolbasicService gipiPolService) {
		this.gipiPolService = gipiPolService;
	}

	private static Logger log = Logger.getLogger(GIACDirectPremCollnsServiceImpl.class);
	
	/**
	 * @return the gipiInstallmentService
	 */
	public GIPIInstallmentService getGipiInstallmentService() {
		return gipiInstallmentService;
	}

	/**
	 * @param gipiInstallmentService the gipiInstallmentService to set
	 */
	public void setGipiInstallmentService(
			GIPIInstallmentService gipiInstallmentService) {
		this.gipiInstallmentService = gipiInstallmentService;
	}

	/**
	 * Validate Bill No
	 */
	@Override
	public Map<String, Object> validateBillNo(Map<String, Object> params) throws SQLException {
		return this.giacDirectPremCollnsDAO.validateBillNo(params);
	}
	
	/**
	 * Validate open policy
	 */
	@Override
	public Map<String, Object> validateOpenPolicy(Map<String, Object> params) throws SQLException {
		return this.giacDirectPremCollnsDAO.validateOpenPolicy(params);
	}
	
	/**
	 * Get invoice listing
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getInvoiceListing(Map<String, Object> params, Integer pageNo) throws SQLException {
		log.info("Retrieving invoice listing...");
		List<Map<String, Object>> invListing = this.giacDirectPremCollnsDAO.getInvoiceListing(params);
		PaginatedList paginatedList = new PaginatedList(invListing , 10);
		paginatedList.gotoPage(pageNo);
		log.info("Invoice list retrieved.");
		return paginatedList;
	}

	/**
	 * @return the giacDirectPremCollnsDAO
	 */
	public GIACDirectPremCollnsDAO getGiacDirectPremCollnsDAO() {
		return giacDirectPremCollnsDAO;
	}

	/**
	 * @param giacDirectPremCollnsDAO the giacDirectPremCollnsDAO to set
	 */
	public void setGiacDirectPremCollnsDAO(
			GIACDirectPremCollnsDAO giacDirectPremCollnsDAO) {
		this.giacDirectPremCollnsDAO = giacDirectPremCollnsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getDefaultTaxValueType(java.util.Map, java.lang.Integer)
	 */
	@Override
	public Map<String, Object> getDefaultTaxValueType(Map<String, Object> params, Integer taxType) throws SQLException {
		return this.giacDirectPremCollnsDAO.getDefaultTaxValueType(params, taxType);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#saveDirectPremCollnsDtls(java.util.Map)
	 */
	@Override
	public String saveDirectPremCollnsDtls(Map<String, Object> allParams) throws SQLException {
		
		try {		
			System.out.println(allParams.get("listToDelete").toString());
			Debug.print("giacDirectPremCollns LIST: " + allParams.get("giacDirectPremCollns"));
			List<GIACDirectPremCollns> giacDirectPremCollns 	= parseGiacDirectPremCollns((JSONArray) allParams.get("giacDirectPremCollns"));
			List<Map<String, Object>> chkAdvPaytParamsList		= JSONUtil.prepareMapListFromJSON((JSONArray) allParams.get("giacDirectPremCollns"));
			List<GIACDirectPremCollns> giacDirectPremCollnsAll 	= parseGiacDirectPremCollns((JSONArray) allParams.get("giacDirectPremCollnsAll"));
			List<GIACDirectPremCollns> listToDelete				= parseListToDelete((JSONArray) allParams.get("listToDelete"));
			List<Map<String, Object>>  taxDefaultParams 		= parseTaxDefaultParams((JSONArray) allParams.get("taxDefaultParams"));
			List<Map<String, Object>>  taxCollnsListToDelete    = parseTaxCollnsListToDelete((JSONArray) allParams.get("listToDelete"));
			
			allParams.put("giacDirectPremCollns", 	giacDirectPremCollns);
			allParams.put("chkAdvPaytParamsList", 	chkAdvPaytParamsList);
			allParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
			allParams.put("listToDelete", 			listToDelete);
			allParams.put("taxDefaultParams", 		taxDefaultParams);
			allParams.put("taxCollnsListToDelete", taxCollnsListToDelete);
			
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return this.giacDirectPremCollnsDAO.saveDirectPremCollnsDtls(allParams);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getDirectPremCollnsDtls(java.lang.Integer)
	 */
	@Override
	public List<Map<String, Object>> getDirectPremCollnsDtls(Integer gaccTranId) throws SQLException {
		return this.giacDirectPremCollnsDAO.getDirectPremCollnsDtls(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#saveDirectPremCollnsAcctDtls(java.util.Map)
	 */
	@Override
	public void saveDirectPremCollnsAcctDtls(Map<String, Object> allParams) throws SQLException {
		List<GIACDirectPremCollns> giacDirectPremCollnsAll 	= parseGiacDirectPremCollns((JSONArray) (allParams.get("giacDirectPremCollnsAll")));

		allParams.put("giacDirectPremCollnsAll", giacDirectPremCollnsAll);
		
		this.giacDirectPremCollnsDAO.saveDirectPremCollnsAcctDtls(allParams);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#validateRecord(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateRecord(Map<String, Object> params)
			throws SQLException {
		
		Map<String, Object> param = new HashMap<String, Object>(params) ;
		Map<String, Object> returnParam = new HashMap<String, Object>();
		
		/*Map<String, Object> checkPremPaytForSpecialDtls = new HashMap<String, Object> (giacDirectPremCollnsDAO.checkPremiumPaytForSpecial(param));
		String checkPremMsgAlert = checkPremPaytForSpecialDtls.get("msgAlert").toString();
		if (checkPremMsgAlert.contains("is not allowed")) {
			returnParam.put("errorEncountered", true);
			returnParam.put("errorMessage",checkPremMsgAlert);
			return returnParam;
		}
		returnParam.put("checkPremPaytForSpecialDtls", checkPremPaytForSpecialDtls);*/ //commented by d.alcantara, 11.14.12, moved to validate prem seq no
		
		param = new HashMap<String, Object>(params);
		
		returnParam.put("hasClaim", gipiPolService.checkClaim(param));
		
		returnParam.put("userCanProcessClaimPayt", giacModulesService.validateUserFunc(param));
		
		Map<String, Object> billNoValidationDtls = new HashMap<String, Object>(giacDirectPremCollnsDAO.validateBillNo(param));
		
		param = new HashMap<String, Object>(params);
		System.out.println("billNoValidationDtls: "+billNoValidationDtls);
		if (!(billNoValidationDtls.get("msgAlert").equals("Ok"))) {
			returnParam.put("errorEncountered", true);
			String msgAlert = (String) billNoValidationDtls.get("msgAlert");
			returnParam.put("errorMessage", msgAlert);
			if(msgAlert.contains("cancelled")) {
				
			} else {
				return returnParam;
			}
		} 
		
		returnParam.put("billNoValidationDtls", billNoValidationDtls);
		Map<String, Object> checkInstNoDtls = new HashMap<String, Object>(this.gipiInstallmentService.checkInstNo(param));
		
		Integer recCount = (Integer) checkInstNoDtls.get("recCount");
		if (recCount==0) {
			returnParam.put("errorEncountered", true);
			returnParam.put("errorMessage", checkInstNoDtls.get("msgAlert"));
			return returnParam;
			
		} else if (recCount==1) {
			returnParam.put("checkInstNoDtls", checkInstNoDtls);
			// check if installment exists...
			param = new HashMap<String, Object>(params);
			
			List<Map<String, Object>> invoiceListing;
			//added condition robert 01.16.2013
			if (param.get("tranType").equals(2)|| param.get("tranType").equals(4)){
				invoiceListing = new ArrayList<Map<String, Object>>(giacDirectPremCollnsDAO.getInvoiceListingForPartial(param));
			}else{
				invoiceListing = new ArrayList<Map<String, Object>>(giacDirectPremCollnsDAO.getInvoiceListing(param));
			}
			System.out.println("invoiceListing: " + invoiceListing.toString());
			Integer numOfRec = invoiceListing.size();	
			
			String checkInvoice = this.getGiacDirectPremCollnsDAO().checkIfInvoiceExists(params);
			System.out.println("checkIfInvoiceExists result: "+checkInvoice);
			
			if(checkInvoice != null) {
				returnParam.put("errorEncountered", true);
				returnParam.put("errorMessage", checkInvoice);
				return returnParam;
			}
			
			String tranType = params.get("tranType").toString();
			if (numOfRec==0) {
				returnParam.put("errorEncountered", true);
				if ("13".contains(tranType)) {
					returnParam.put("errorMessage", "This installment is already settled.");
				} else {
					returnParam.put("errorMessage", "This installment no. does not exist.");
				}
				return returnParam;
			} 
			
			for (int i=0; i<numOfRec; i++) {
				if (invoiceListing.get(i).get("instNo").toString().equals(params.get("instNo").toString())) {
					returnParam.put("collectionAmt", 	invoiceListing.get(i).get("collectionAmt"));
					returnParam.put("premAmt", 		 	invoiceListing.get(i).get("premAmt"));
					returnParam.put("taxAmt", 		 	invoiceListing.get(i).get("taxAmt"));
					returnParam.put("negCollectionAmt", invoiceListing.get(i).get("collectionAmt1"));
					returnParam.put("negPremAmt", 		invoiceListing.get(i).get("premAmt1"));
					returnParam.put("negTaxAmt", 		invoiceListing.get(i).get("taxAmt1"));
					returnParam.put("currRt", 			invoiceListing.get(i).get("currRt"));
					break;
				}
			}
		}
		
		param = new HashMap<String, Object>(params);
		
		/*Map<String, Object> openPolicyDtls = new HashMap<String, Object>(giacDirectPremCollnsDAO.validateOpenPolicy(param));
		String openPolicyMessage = openPolicyDtls.get("msgAlert").toString();
		if (!(openPolicyMessage.equals("Ok"))) {
			returnParam.put("errorEncountered", true);
			returnParam.put("errorMessage", openPolicyMessage);
			return returnParam;
		}
		
		returnParam.put("openPolicyDtls", openPolicyDtls);*/ // moved to validate_prem_seq_no
		param = new HashMap<String, Object>(params);
		
		if (params.get("billPremiumOverdue") == null) {

			returnParam.put("errorEncountered", true);
			returnParam.put("errorMessage", "Parameter BILL_PREMIUM_OVERDUE not found in GIAC_PARAMETERS.");
			
			return returnParam;
		}
		
		returnParam.put("daysOverDue", new Integer(this.gipiInstallmentService.getDaysOverdue(param)));
		
		String checkPreviousInst = this.getGiacDirectPremCollnsDAO().checkPreviousInst(params); //robert
		System.out.println("checkPreviousInst result: "+checkPreviousInst);
		returnParam.put("checkPreviousInst", checkPreviousInst);
		
		param = new HashMap<String, Object>(params);
		 
		return returnParam;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getInvoiceListingTableGrid(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getInvoiceListingTableGrid(HashMap<String, Object> params) throws SQLException, JSONException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		System.out.println(grid.getStartRow() + " start row");
		System.out.println(grid.getEndRow() + " end row");
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareInvoiceListingFilter((String) params.get("filter"), params));
		List<Map<String, Object>> invoiceListingTableGrid = this.giacDirectPremCollnsDAO.getInvoiceListingTableGrid(params);
		System.out.println(invoiceListingTableGrid.size() + " invoiceListing count");
		//params.put("rows", new JSONArray((List<Map<String, Object>>) StringFormatter.replaceQuotesInList(invoiceListingTableGrid)));
		params.put("rows", new JSONArray((List<Map<String, Object>>) StringFormatter.escapeHTMLInListOfMap(invoiceListingTableGrid)));
		grid.setNoOfPagesInMap(invoiceListingTableGrid);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @param params
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareInvoiceListingFilter(String filter, Map<String, Object> params) throws JSONException{
		Map<String, Object> invoiceListing = new HashMap<String, Object>();
		JSONObject jsonInvoiceListingFilter = null;
		
		if(null == filter){
			jsonInvoiceListingFilter = new JSONObject();
		}else{
			jsonInvoiceListingFilter = new JSONObject(filter);
		}
		Integer prem = params.get("premSeqNo") == null ? null :(Integer) params.get("premSeqNo");
		String premSeqNo = params.get("premSeqNo") == null ? null : prem.toString();
		String instNo = params.get("instNo") == null  ?  null : params.get("instNo").toString();
		String assdName = params.get("assdName") == null ? null : params.get("assdName").toString();
		String intmName = params.get("intmName") == null ? null : params.get("intmName").toString();
		String lineCd = params.get("lineCd") == null ? null : params.get("lineCd").toString(); // bonok :: 09.17.2012
		String sublineCd = params.get("sublineCd") == null ? null : params.get("sublineCd").toString();
		String issCd = params.get("issCd") == null ? null : params.get("issCd").toString();
		Integer issueYy = params.get("issueYy") == null ? null :(Integer) params.get("issueYy");
		Integer polSeqNo = params.get("polSeqNo") == null ? null :(Integer) params.get("polSeqNo"); 
		String endtIssCd = params.get("endtIssCd") == null ? null : params.get("endtIssCd").toString();
		Integer endtYy = params.get("endtYy") == null ? null :(Integer) params.get("endtYy");
		Integer endtSeqNo = params.get("endtSeqNo") == null ? null :(Integer) params.get("endtSeqNo"); // bonok :: 09.17.2012
		
		invoiceListing.put("premSeqNo", jsonInvoiceListingFilter.isNull("premSeqNo") ?  premSeqNo : jsonInvoiceListingFilter.getString("premSeqNo").toUpperCase());
		invoiceListing.put("instNo", 	jsonInvoiceListingFilter.isNull("instNo") ? 	instNo : 	jsonInvoiceListingFilter.getInt("instNo"));
		invoiceListing.put("assdName",  jsonInvoiceListingFilter.isNull("assdName") ? assdName: jsonInvoiceListingFilter.getString("assdName"));
		invoiceListing.put("intmName", jsonInvoiceListingFilter.isNull("intmName") ? intmName: jsonInvoiceListingFilter.getString("intmName"));
		invoiceListing.put("lineCd", jsonInvoiceListingFilter.isNull("lineCd") ? lineCd: jsonInvoiceListingFilter.getString("lineCd")); // bonok :: 09.17.2012
		invoiceListing.put("sublineCd", jsonInvoiceListingFilter.isNull("sublineCd") ? sublineCd: jsonInvoiceListingFilter.getString("sublineCd"));
		invoiceListing.put("issCd", jsonInvoiceListingFilter.isNull("issCd") ? issCd: jsonInvoiceListingFilter.getString("issCd"));
		invoiceListing.put("issueYy", jsonInvoiceListingFilter.isNull("issueYy") ?  issueYy : jsonInvoiceListingFilter.getString("issueYy").toUpperCase());
		invoiceListing.put("polSeqNo", jsonInvoiceListingFilter.isNull("polSeqNo") ?  polSeqNo : jsonInvoiceListingFilter.getString("polSeqNo").toUpperCase()); 
		invoiceListing.put("endtIssCd", jsonInvoiceListingFilter.isNull("endtIssCd") ? endtIssCd: jsonInvoiceListingFilter.getString("endtIssCd"));
		invoiceListing.put("endtYy", jsonInvoiceListingFilter.isNull("endtYy") ?  endtYy : jsonInvoiceListingFilter.getString("endtYy").toUpperCase());
		invoiceListing.put("endtSeqNo", jsonInvoiceListingFilter.isNull("endtSeqNo") ?  endtSeqNo : jsonInvoiceListingFilter.getString("endtSeqNo").toUpperCase()); // bonok :: 09.17.2012
		System.out.println("INVOICE LISTING FILTER :: " + invoiceListing);
		return invoiceListing;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getEnteredBillDetails(java.util.Map)
	 */
	@Override
	public Map<String, Object> getEnteredBillDetails(Map<String, Object> param)
			throws SQLException {
		
		return this.giacDirectPremCollnsDAO.getEnteredBillDetails(param);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getInvoiceListing(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getInvoiceListing(Map<String, Object> param)
		throws SQLException {
		
		return this.giacDirectPremCollnsDAO.getInvoiceListing(param);
	}

	/**
	 * 
	 * @param giacDirectPremCollns
	 * @return
	 */
	private List<GIACDirectPremCollns> parseGiacDirectPremCollns(JSONArray giacDirectPremCollns) {
		List<GIACDirectPremCollns> giacDirectPremCollnsListing = new ArrayList<GIACDirectPremCollns>();
		GIACDirectPremCollns coll = null;
		JSONObject objGIACDirectPremCollns = null;
		System.out.println("giacDirectPremCollns length: " + giacDirectPremCollns.length());
		for (int i=0; i<giacDirectPremCollns.length(); i++) {			
			try {
				objGIACDirectPremCollns = giacDirectPremCollns.getJSONObject(i);
				coll = new GIACDirectPremCollns();
				/*coll = new GIACDirectPremCollns(objGIACDirectPremCollns.isNull("gaccTranId") ? null : objGIACDirectPremCollns.getInt("gaccTranId"),
						objGIACDirectPremCollns.isNull("tranType") ? null : objGIACDirectPremCollns.getInt("tranType"),
						objGIACDirectPremCollns.isNull("issCd") ? null : objGIACDirectPremCollns.getString("issCd"),
						objGIACDirectPremCollns.isNull("premSeqNo") ? null : objGIACDirectPremCollns.getInt("premSeqNo"),
						objGIACDirectPremCollns.isNull("instNo") ? null : objGIACDirectPremCollns.getInt("instNo"),
						objGIACDirectPremCollns.isNull("collAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("collAmt")),
						objGIACDirectPremCollns.isNull("premAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("premAmt")),
						objGIACDirectPremCollns.isNull("taxAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("taxAmt")),
						objGIACDirectPremCollns.isNull("orPrintTag") ? null : objGIACDirectPremCollns.getString("orPrintTag"),
						objGIACDirectPremCollns.isNull("particulars") ? null : objGIACDirectPremCollns.getString("particulars"),
						objGIACDirectPremCollns.isNull("currCd") ? null : objGIACDirectPremCollns.getInt("currCd"),
						objGIACDirectPremCollns.isNull("currRt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("currRt")),
						//new BigDecimal(1),
						objGIACDirectPremCollns.isNull("forCurrAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("forCurrAmt")));*/
				
				coll.setGaccTranId(objGIACDirectPremCollns.isNull("gaccTranId") ? null : objGIACDirectPremCollns.getInt("gaccTranId"));
				coll.setTranType(objGIACDirectPremCollns.isNull("tranType") ? null : objGIACDirectPremCollns.getInt("tranType"));
				coll.setIssCd(objGIACDirectPremCollns.isNull("issCd") ? null : objGIACDirectPremCollns.getString("issCd"));
				coll.setPremSeqNo(objGIACDirectPremCollns.isNull("premSeqNo") ? null : objGIACDirectPremCollns.getInt("premSeqNo"));
				coll.setInstNo(objGIACDirectPremCollns.isNull("instNo") ? null : objGIACDirectPremCollns.getInt("instNo"));
				coll.setCollAmt(objGIACDirectPremCollns.isNull("collAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("collAmt")));
				coll.setPremAmt(objGIACDirectPremCollns.isNull("premAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("premAmt")));
				coll.setTaxAmt(objGIACDirectPremCollns.isNull("taxAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("taxAmt")));
				coll.setOrPrintTag(objGIACDirectPremCollns.isNull("orPrintTag") ? null : objGIACDirectPremCollns.getString("orPrintTag"));
				coll.setParticulars(objGIACDirectPremCollns.isNull("particulars") ? null : StringFormatter.unescapeHtmlJava(objGIACDirectPremCollns.getString("particulars"))); //added by robert 10.11.2013
				coll.setCurrCd(objGIACDirectPremCollns.isNull("currCd") ? null : objGIACDirectPremCollns.getInt("currCd"));
				coll.setConvRate(objGIACDirectPremCollns.isNull("currRt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("currRt")));
				coll.setForCurrAmt(objGIACDirectPremCollns.isNull("forCurrAmt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("forCurrAmt")));
				coll.setPremVatable(objGIACDirectPremCollns.isNull("premVatable") ? null : new BigDecimal(objGIACDirectPremCollns.getString("premVatable")));
				coll.setPremVatExempt(objGIACDirectPremCollns.isNull("premVatExempt") ? null : new BigDecimal(objGIACDirectPremCollns.getString("premVatExempt")));
				coll.setPremZeroRated(objGIACDirectPremCollns.isNull("premZeroRated") || objGIACDirectPremCollns.getString("premZeroRated").equals("") ? null : new BigDecimal(objGIACDirectPremCollns.getString("premZeroRated")));
				coll.setRevGaccTranId(objGIACDirectPremCollns.isNull("revGaccTranId") ? null : objGIACDirectPremCollns.getInt("revGaccTranId"));
				coll.setIncTag(objGIACDirectPremCollns.isNull("incTag") ? null : objGIACDirectPremCollns.getString("incTag"));
				giacDirectPremCollnsListing.add(coll);
				coll = null;
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
		return giacDirectPremCollnsListing;
	}
	
	/**
	 * 
	 * @param listToDelete
	 * @return
	 * @throws JSONException
	 */
	private List<GIACDirectPremCollns> parseListToDelete(JSONArray listToDelete) throws JSONException {
		
		List<GIACDirectPremCollns> listToDeleteListing = new ArrayList<GIACDirectPremCollns>();
		
		GIACDirectPremCollns coll = null;
		
		for (int i=0; i<listToDelete.length(); i++) {
			
			coll = new GIACDirectPremCollns();
			coll.setGaccTranId(listToDelete.getJSONObject(i).getInt("gaccTranId"));
			coll.setIssCd(listToDelete.getJSONObject(i).getString("issCd"));
			coll.setPremSeqNo(listToDelete.getJSONObject(i).getInt("premSeqNo"));
			coll.setInstNo(listToDelete.getJSONObject(i).getInt("instNo"));
			coll.setTranType(listToDelete.getJSONObject(i).getInt("tranType"));
		
			listToDeleteListing.add(coll);
		}
		
		return listToDeleteListing;
	}
	
	/**
	 * 
	 * @param taxDefaultParams
	 * @return
	 * @throws JSONException
	 */
	private List<Map<String, Object>> parseTaxDefaultParams(JSONArray taxDefaultParams) throws JSONException {
		
		List<Map<String, Object>> taxDefaultParamsListing = new ArrayList<Map<String, Object>>();
		
		for (int i=0; i<taxDefaultParams.length(); i++) {
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("gaccTranId", taxDefaultParams.getJSONObject(i).getInt("gaccTranId"));
			params.put("revGaccTranId", taxDefaultParams.getJSONObject(i).isNull("revGaccTranId")? null : taxDefaultParams.getJSONObject(i).getInt("revGaccTranId")); // added by: Nica 06.22.2012
			params.put("tranType", taxDefaultParams.getJSONObject(i).getInt("tranType"));
			params.put("issCd", taxDefaultParams.getJSONObject(i).getString("issCd"));
			params.put("instNo", taxDefaultParams.getJSONObject(i).getInt("instNo"));
			params.put("premSeqNo", taxDefaultParams.getJSONObject(i).getInt("premSeqNo"));
			params.put("tranType", taxDefaultParams.getJSONObject(i).getInt("tranType"));
			params.put("fundCd", taxDefaultParams.getJSONObject(i).getString("fundCd"));
			params.put("collnAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("collAmt")));
			//params.put("premAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("premAmt")));
			//params.put("taxAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("taxAmt")));
			params.put("origPremAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("origPremAmt").equals("") ? "0" :taxDefaultParams.getJSONObject(i).getString("origPremAmt")));
			params.put("origTaxAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("origTaxAmt").equals("") ? "0" :taxDefaultParams.getJSONObject(i).getString("origTaxAmt")));

			params.put("paramPremAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("paramPremAmt").equals("") ? "0" :taxDefaultParams.getJSONObject(i).getString("paramPremAmt")));
			params.put("premAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("prevPremAmt").equals("") ? "0" :taxDefaultParams.getJSONObject(i).getString("prevPremAmt")));
			params.put("taxAmt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("prevTaxAmt").equals("") ? "0" :taxDefaultParams.getJSONObject(i).getString("prevTaxAmt")));
			
			//params.put("premVatExempt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("premVatExempt").equals("")  || taxDefaultParams.getJSONObject(i).isNull("premVatExempt")? "0" : taxDefaultParams.getJSONObject(i).getString("premVatExempt")));
			params.put("premVatExempt", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("premVatExempt")));
			params.put("sumTaxTotal", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("sumTaxTotal")));
			params.put("recordStatus", new BigDecimal(taxDefaultParams.getJSONObject(i).getString("recordStatus")));
			taxDefaultParamsListing.add(params);

		}
		return taxDefaultParamsListing;
	}
	
	/**
	 * 
	 * @param listToDelete
	 * @return
	 * @throws JSONException
	 */
	private List<Map<String, Object>> parseTaxCollnsListToDelete(JSONArray listToDelete) throws JSONException {
			
			List<Map<String, Object>> taxCollnsToDeleteListing = new ArrayList<Map<String, Object>>();
			
			Map<String, Object> taxColl = null;
			
			for (int i=0; i<listToDelete.length(); i++) {
				
				taxColl = new HashMap<String, Object>();
				taxColl.put("gaccTranId", listToDelete.getJSONObject(i).getInt("gaccTranId"));
				taxColl.put("b160IssCd", listToDelete.getJSONObject(i).getString("issCd"));
				taxColl.put("b160PremSeqNo",listToDelete.getJSONObject(i).getInt("premSeqNo"));
				taxColl.put("instNo", listToDelete.getJSONObject(i).getInt("instNo"));
				taxColl.put("b160TaxCd",0);
				Debug.print("TAXCOLLECTIONS TO DELETE: " + taxColl);
				taxCollnsToDeleteListing.add(taxColl);
			}
			
			return taxCollnsToDeleteListing;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDirectPremCollnsService#getRelatedDirectPremCollns(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRelatedDirectPremCollns(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACDirectPremCollns> directPremList = this.getGiacDirectPremCollnsDAO().getRelatedDirectPremCollns(params);
		params.put("rows", new JSONArray((List<GIACDirectPremCollns>)StringFormatter.escapeHTMLInList(directPremList)));
		grid.setNoOfPages(directPremList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	@Override
	public List<Map<String, Object>> getPolicyInvoices(
			Map<String, Object> params) throws SQLException {
		return this.getGiacDirectPremCollnsDAO().getPolicyInvoices(params);
	}

	@Override
	public String validateGIACS007PremSeqNo(Map<String, Object> params)
			throws SQLException, JSONException {
		JSONObject resultObj = new JSONObject(this.getGiacDirectPremCollnsDAO().validateGIACS007PremSeqNo(params));
		System.out.println("validateGIACS007PremSeqNo result: "+resultObj);
		return resultObj.toString();
	}

	@Override
	public Map<String, Object> setPremTaxTranType(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDirectPremCollnsDAO().setPremTaxTranType(params);
	}

	@Override
	public String checkIfInvoiceExists(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDirectPremCollnsDAO().checkIfInvoiceExists(params);
	}

	@Override
	public String getIncTagForAdvPremPayts(Map<String, Object> params)
			throws SQLException {
		log.info("GetIncTagForAdvPremPayts: "+params);
		return this.getGiacDirectPremCollnsDAO().getIncTagForAdvPremPayts(params);
	}

	@Override
	public String checkSpecialBill(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDirectPremCollnsDAO().checkSpecialBill(params);
	}

	@Override
	public Map<String, Object>  getDirectPremTotals(Map<String, Object> params) throws SQLException {
		return this.getGiacDirectPremCollnsDAO().getDirectPremTotals(params);
	}

	@Override
	public Integer getNumberOfInst(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDirectPremCollnsDAO().getNumberOfInst(params);
	}

	@Override
	public Map<String, Object> validatePolicy(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueYy", request.getParameter("issueYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("refPolNo", request.getParameter("refPolNo"));
		params.put("checkDue", request.getParameter("checkDue"));
		return this.getGiacDirectPremCollnsDAO().validatePolicy(params);
	}
	
	@Override
	public String checkPreviousInst(Map<String, Object> params)
			throws SQLException {
		return this.getGiacDirectPremCollnsDAO().checkPreviousInst(params);
	}

}
