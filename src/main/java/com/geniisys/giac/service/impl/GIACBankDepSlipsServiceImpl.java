package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACBankDepSlipsDAO;
import com.geniisys.giac.entity.GIACBankDepSlips;
import com.geniisys.giac.entity.GIACCashDepDtl;
import com.geniisys.giac.service.GIACBankDepSlipsService;
import com.seer.framework.util.StringFormatter;

public class GIACBankDepSlipsServiceImpl implements GIACBankDepSlipsService {

	/** The DAO */
	private GIACBankDepSlipsDAO giacBankDepSlipsDAO;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACBankDepSlipsServiceImpl.class);

	public void setGiacBankDepSlipsDAO(GIACBankDepSlipsDAO giacBankDepSlipsDAO) {
		this.giacBankDepSlipsDAO = giacBankDepSlipsDAO;
	}

	public GIACBankDepSlipsDAO getGiacBankDepSlipsDAO() {
		return giacBankDepSlipsDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBankDepSlipsService#saveGbdsBlock(java.lang.String, java.lang.String)
	 */
	@Override
	public String saveGbdsBlock(String parameters, String userId)
			throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", prepareGIACBankDepSlipsJSON(new JSONArray(objParameters.getString("setRows")), userId));
		allParams.put("delRows", prepareGIACBankDepSlipsJSON(new JSONArray(objParameters.getString("delRows")), userId));
		
		/*allParams.put("setGcddRows", prepareGcddJSONForSave(new JSONArray(objParameters.getString("setGcddRows")), userId));
		allParams.put("delGcddRows", prepareGcddJSONForSave(new JSONArray(objParameters.getString("delGcddRows")), userId));*/
		
		allParams.put("setGcddRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setGcddRows")), userId, GIACCashDepDtl.class));
		allParams.put("delGcddRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delGcddRows")), userId, GIACCashDepDtl.class));
		return this.getGiacBankDepSlipsDAO().saveGbdsBlock(allParams);
	}
	
	private List<GIACBankDepSlips> prepareGIACBankDepSlipsJSON(JSONArray rows, String userId)
			throws JSONException, ParseException {
		GIACBankDepSlips gbds = null;
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		List<GIACBankDepSlips> list = new ArrayList<GIACBankDepSlips>();
		for (int i = 0; i < rows.length(); i++) {
			gbds = new GIACBankDepSlips();
			gbds.setDepId(rows.getJSONObject(i).isNull("depId") || rows.getJSONObject(i).get("depId").equals("") ? 0 : rows.getJSONObject(i).getInt("depId"));
			gbds.setDepNo(rows.getJSONObject(i).isNull("depNo") || rows.getJSONObject(i).get("depNo").equals("") ? null : rows.getJSONObject(i).getInt("depNo"));
			gbds.setGaccTranId(rows.getJSONObject(i).isNull("gaccTranId") || rows.getJSONObject(i).get("gaccTranId").equals("") ? null : rows.getJSONObject(i).getInt("gaccTranId"));
			gbds.setItemNo(rows.getJSONObject(i).isNull("itemNo") || rows.getJSONObject(i).get("itemNo").equals("") ? null : rows.getJSONObject(i).getInt("itemNo"));
			gbds.setFundCd(rows.getJSONObject(i).isNull("fundCd") || rows.getJSONObject(i).get("fundCd").equals("") ? null : rows.getJSONObject(i).getString("fundCd"));
			gbds.setBranchCd(rows.getJSONObject(i).isNull("branchCd") || rows.getJSONObject(i).get("branchCd").equals("") ? null : rows.getJSONObject(i).getString("branchCd"));
			gbds.setDcbNo(rows.getJSONObject(i).isNull("dcbNo") || rows.getJSONObject(i).get("dcbNo").equals("") ? null : rows.getJSONObject(i).getInt("dcbNo"));
			gbds.setDcbYear(rows.getJSONObject(i).isNull("dcbYear") || rows.getJSONObject(i).get("dcbYear").equals("") ? null : rows.getJSONObject(i).getInt("dcbYear"));
			gbds.setCheckClass(rows.getJSONObject(i).isNull("checkClass") || rows.getJSONObject(i).get("checkClass").equals("") ? null : rows.getJSONObject(i).getString("checkClass"));
			gbds.setValidationDt(rows.getJSONObject(i).isNull("validationDt") || rows.getJSONObject(i).get("validationDt").equals("") ? null : df.parse(rows.getJSONObject(i).getString("validationDt")));
			gbds.setAmount(rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
			gbds.setForeignCurrAmt(rows.getJSONObject(i).isNull("foreignCurrAmt") || rows.getJSONObject(i).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignCurrAmt")));
			gbds.setCurrencyRt(rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
			gbds.setCurrencyCd(rows.getJSONObject(i).isNull("currencyCd") || rows.getJSONObject(i).get("currencyCd").equals("") ? null : rows.getJSONObject(i).getInt("currencyCd"));
			System.out.println("TEST prepareGIACBankDepSlipsJSON -- "+gbds.getDepId()+" / "+gbds.getGaccTranId()+" / "+gbds.getAmount());
			list.add(gbds);
		}
		
		return list;
	}
	
	private Map<String, Object> prepareGcddJSONForSave(JSONArray rows, String userId) throws JSONException {
		Map<String, Object> gcdd = new HashMap<String, Object>();
		for(int i=0; i<rows.length(); i++) {
			gcdd.put("gaccTranId", rows.getJSONObject(i).isNull("gaccTranId") ? null : rows.getJSONObject(i).getInt("gaccTranId"));
			gcdd.put("branchCd", rows.getJSONObject(i).isNull("branchCd") ? null : rows.getJSONObject(i).getString("branchCd"));
			gcdd.put("fundCd", rows.getJSONObject(i).isNull("fundCd") ? null : rows.getJSONObject(i).getString("fundCd"));
			gcdd.put("dcbYear", rows.getJSONObject(i).isNull("dcbYear") ? null : rows.getJSONObject(i).getInt("dcbYear"));
			gcdd.put("dcbNo", rows.getJSONObject(i).isNull("dcbNo") ? null : rows.getJSONObject(i).getInt("dcbNo"));
			gcdd.put("itemNo", rows.getJSONObject(i).isNull("itemNo") ? null : rows.getJSONObject(i).getInt("itemNo"));
			gcdd.put("amount", rows.getJSONObject(i).isNull("amount") ? null : rows.getJSONObject(i).getString("amount"));
			gcdd.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") ? null : rows.getJSONObject(i).getString("currencyRt"));
			gcdd.put("foreignCurrAmt", rows.getJSONObject(i).isNull("") ? null : rows.getJSONObject(i).getString(""));
			gcdd.put("shortOver", rows.getJSONObject(i).isNull("shortOver") ? null : rows.getJSONObject(i).getString("shortOver"));
			gcdd.put("netDeposit", rows.getJSONObject(i).isNull("netDeposit") ? null : rows.getJSONObject(i).getString("netDeposit"));
			gcdd.put("currencyCd", rows.getJSONObject(i).isNull("currencyCd") ? null : rows.getJSONObject(i).getString("currencyCd"));
			gcdd.put("remarks", rows.getJSONObject(i).isNull("remarks") ? null : rows.getJSONObject(i).getString("remarks"));
		}
		return gcdd;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGbdsListTableGridMap(java.util.Map, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGbdsListTableGridMap(
			Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException {
		JSONObject objParameters;
		List<Map<String, Object>> gbdsList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		System.out.println("emman param - " + strParameters);
		
		if (strParameters != null) {
			if (!strParameters.isEmpty()) {
				objParameters = new JSONObject(strParameters);
				gbdsList = this.prepareGbdsJSON(new JSONArray(objParameters.getString("gbdsRows")), params);
			}
		}
		
		if (gbdsList != null) {
			System.out.println("emman size - " + gbdsList.size());
			if (gbdsList.size() == 0) {
				gbdsList = this.getGiacBankDepSlipsDAO().getGbdsListTableGrid(params);
			}
		} else {
			gbdsList = this.getGiacBankDepSlipsDAO().getGbdsListTableGrid(params);
		}
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gbdsList)));
		grid.setNoOfPages(gbdsList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGcddListTableGridMap(java.util.Map, java.lang.String)
	 */
	
/* commented out by Halley 12.17.13
 * @SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGcddListTableGridMap(
			Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException {
		JSONObject objParameters;
		List<Map<String, Object>> gcddList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		if (strParameters != null) {
			if (!strParameters.isEmpty()) {
				objParameters = new JSONObject(strParameters);
				gcddList = this.prepareGcddJSON(new JSONArray(objParameters.getString("gcddRows")), params);
			}
		}
		
		if (gcddList != null) {
			if (gcddList.size() == 0) {
				gcddList = this.getGiacBankDepSlipsDAO().getGcddListTableGrid(params);
			}
		} else {
			gcddList = this.getGiacBankDepSlipsDAO().getGcddListTableGrid(params);
		}
		
		// add new default record for GCDD if gcdd list has no records
		if (gcddList != null) {
			if (gcddList.size() == 0) {
				gcddList = this.prepareGcddJSON(null, params);
			}
		} else {
			gcddList = this.prepareGcddJSON(null, params);
		}
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gcddList)));
		grid.setNoOfPages(gcddList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}*/ 
	
	//added by Halley 12.17.13
	@SuppressWarnings("unchecked")
	public Map<String, Object> getGcddListTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {

		List<Map<String, Object>> gcddList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		gcddList = this.getGiacBankDepSlipsDAO().getGcddListTableGrid(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gcddList)));
		grid.setNoOfPages(gcddList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}//end 

	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGbdsdListTableGridMapByGaccTranId(java.util.Map, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGbdsdListTableGridMapByGaccTranId(
			Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException {
		JSONObject objParameters;
		List<Map<String, Object>> gbdsdList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		if (strParameters != null) {
			if (!strParameters.isEmpty()) {
				objParameters = new JSONObject(strParameters);
				gbdsdList = this.prepareGbdsdJSON(new JSONArray(objParameters.getString("gbdsdRows")), params);
			}
		}
		
		if (gbdsdList != null) {
			if (gbdsdList.size() == 0) {
				gbdsdList = this.getGiacBankDepSlipsDAO().getGbdsdListTableGridByGaccTranId(params);
			}
		} else {
			gbdsdList = this.getGiacBankDepSlipsDAO().getGbdsdListTableGridByGaccTranId(params);
		}
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gbdsdList)));
		grid.setNoOfPages(gbdsdList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGbdsdListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGbdsdListTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> gbdsdList = this.getGiacBankDepSlipsDAO().getGbdsdListTableGrid(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gbdsdList)));
		grid.setNoOfPages(gbdsdList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGbdsdErrorListTableGridMap(java.util.Map, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGbdsdErrorListTableGridMap(
			Map<String, Object> params, String strParameters) throws SQLException, JSONException, ParseException {
		JSONObject objParameters;
		List<Map<String, Object>> gbdsdErrorList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		BigDecimal locErrorAmt = null;
		BigDecimal amount = (params.get("amount") == null) ? new BigDecimal(0) : (BigDecimal)params.get("amount");
		
		if (params.get("recordStatus") != null) {
			if ("QUERY".equals(params.get("recordStatus"))) {
				 locErrorAmt = this.getGiacBankDepSlipsDAO().getLocErrorAmt(params);
			}
		}
		
		if (strParameters != null) {
			if (!strParameters.isEmpty()) {
				objParameters = new JSONObject(strParameters);
				gbdsdErrorList = this.prepareErrorList(new JSONArray(objParameters.getString("errorRows")), params, amount, locErrorAmt);
			}
		}
		
		if (gbdsdErrorList != null) {
			if (gbdsdErrorList.size() == 0) {
				gbdsdErrorList = this.prepareErrorList(null, params, amount, locErrorAmt);
			}
		} else {
			gbdsdErrorList = this.prepareErrorList(null, params, amount, locErrorAmt);
		}
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gbdsdErrorList)));
		grid.setNoOfPages(gbdsdErrorList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}


	
	
	private List<Map<String, Object>> prepareGbdsJSON(JSONArray rows, Map<String, Object> params)
	throws JSONException, ParseException {
		Integer gaccTranId;
		Integer itemNo;
		Integer pItemNo = (params.get("itemNo") == null) ? null : new Integer(params.get("itemNo").toString());
		Map<String, Object> gbds =null;
		List<Map<String, Object>> gbdsList = new ArrayList<Map<String,Object>>();
		
		for (int i = 0; i < rows.length(); i++) {
			gaccTranId = rows.getJSONObject(i).isNull("gaccTranId") || rows.getJSONObject(i).get("gaccTranId").equals("") ? null : rows.getJSONObject(i).getInt("gaccTranId");
			itemNo = rows.getJSONObject(i).isNull("itemNo") || rows.getJSONObject(i).get("itemNo").equals("") ? null : rows.getJSONObject(i).getInt("itemNo");
			
			if (itemNo != null && pItemNo != null) {
				if (itemNo.equals(pItemNo)) {
					gbds = new HashMap<String, Object>();
					
					gbds.put("depId", rows.getJSONObject(i).isNull("depId") || rows.getJSONObject(i).get("depId").equals("") ? null : rows.getJSONObject(i).getInt("depId"));
					gbds.put("depNo", rows.getJSONObject(i).isNull("depNo") || rows.getJSONObject(i).get("depNo").equals("") ? null : rows.getJSONObject(i).getInt("depNo"));
					gbds.put("gaccTranId", gaccTranId);
					gbds.put("itemNo", itemNo);
					gbds.put("fundCd", rows.getJSONObject(i).isNull("fundCd") || rows.getJSONObject(i).get("fundCd").equals("") ? null : rows.getJSONObject(i).getString("fundCd"));
					gbds.put("branchCd", rows.getJSONObject(i).isNull("branchCd") || rows.getJSONObject(i).get("branchCd").equals("") ? null : rows.getJSONObject(i).getString("branchCd"));
					gbds.put("dcbNo", rows.getJSONObject(i).isNull("dcbNo") || rows.getJSONObject(i).get("dcbNo").equals("") ? null : rows.getJSONObject(i).getInt("dcbNo"));
					gbds.put("dcbYear", rows.getJSONObject(i).isNull("dcbYear") || rows.getJSONObject(i).get("dcbYear").equals("") ? null : rows.getJSONObject(i).getInt("dcbYear"));						
					gbds.put("checkClass", rows.getJSONObject(i).isNull("checkClass") || rows.getJSONObject(i).get("checkClass").equals("") ? null : rows.getJSONObject(i).getString("checkClass"));
					gbds.put("validationDt", rows.getJSONObject(i).isNull("validationDt") || rows.getJSONObject(i).get("validationDt").equals("") ? null : rows.getJSONObject(i).getString("validationDt"));
					gbds.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
					gbds.put("foreignCurrAmt", rows.getJSONObject(i).isNull("foreignCurrAmt") || rows.getJSONObject(i).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignCurrAmt")));
					gbds.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
					gbds.put("currencyCd", rows.getJSONObject(i).isNull("currencyCd") || rows.getJSONObject(i).get("currencyCd").equals("") ? null : rows.getJSONObject(i).getInt("currencyCd"));
					gbds.put("currencyShortName", rows.getJSONObject(i).isNull("currencyShortName") || rows.getJSONObject(i).get("currencyShortName").equals("") ? null : rows.getJSONObject(i).getString("currencyShortName"));
					
					gbdsList.add(gbds);
				}
			}
		}
		
		return gbdsList;
	}
	
	/*
	 * Prepares List of Map from GCDD block JSON object
	 * If first parameter is null, return a list with one record only with blank attributes
	 */
	private List<Map<String, Object>> prepareGcddJSON(JSONArray rows, Map<String, Object> params)
		throws JSONException, ParseException {
		Integer gaccTranId;
		Integer itemNo;
		Integer pGaccTranId = (params.get("gaccTranId") == null) ? null : new Integer(params.get("gaccTranId").toString());;
		Integer pItemNo = (params.get("itemNo") == null) ? null : new Integer(params.get("itemNo").toString());;
		Map<String, Object> gcdd = null;
		List<Map<String, Object>> gcddList = new ArrayList<Map<String,Object>>();
		
		if (rows == null) {
			gcdd = new HashMap<String, Object>();
			
			gcdd.put("gaccTranId", pGaccTranId);
			gcdd.put("fundCd", null);
			gcdd.put("branchCd", null);
			gcdd.put("dcbYear", null);
			gcdd.put("dcbNo", null);
			gcdd.put("itemNo", pItemNo);
			gcdd.put("currencyCd", null);
			gcdd.put("currencyShortName", null);
			gcdd.put("amount", null);
			gcdd.put("foreignCurrAmt", null);
			gcdd.put("currencyRt", null);
			gcdd.put("netDeposit", null);
			gcdd.put("shortOver", null);
			gcdd.put("remarks", null);
			gcdd.put("bookTag", null);
			
			gcddList.add(gcdd);
		} else {
			for (int i = 0; i < rows.length(); i++) {
				gaccTranId = rows.getJSONObject(i).isNull("gaccTranId") || rows.getJSONObject(i).get("gaccTranId").equals("") ? null : rows.getJSONObject(i).getInt("gaccTranId");
				itemNo = rows.getJSONObject(i).isNull("itemNo") || rows.getJSONObject(i).get("itemNo").equals("") ? null : rows.getJSONObject(i).getInt("itemNo");
				
				if (gaccTranId != null && itemNo != null && pGaccTranId != null && pItemNo != null) {
					if (gaccTranId.equals(pGaccTranId) && itemNo.equals(pItemNo)) {
						gcdd = new HashMap<String, Object>();
						
						gcdd.put("gaccTranId", gaccTranId);
						gcdd.put("fundCd", rows.getJSONObject(i).isNull("fundCd") || rows.getJSONObject(i).get("fundCd").equals("") ? null : rows.getJSONObject(i).getString("fundCd"));
						gcdd.put("branchCd", rows.getJSONObject(i).isNull("branchCd") || rows.getJSONObject(i).get("branchCd").equals("") ? null : rows.getJSONObject(i).getString("branchCd"));
						gcdd.put("dcbYear", rows.getJSONObject(i).isNull("dcbYear") || rows.getJSONObject(i).get("dcbYear").equals("") ? null : rows.getJSONObject(i).getInt("dcbYear"));
						gcdd.put("dcbNo", rows.getJSONObject(i).isNull("dcbNo") || rows.getJSONObject(i).get("dcbNo").equals("") ? null : rows.getJSONObject(i).getInt("dcbNo"));
						gcdd.put("itemNo", itemNo);
						gcdd.put("currencyCd", rows.getJSONObject(i).isNull("currencyCd") || rows.getJSONObject(i).get("currencyCd").equals("") ? null : rows.getJSONObject(i).getInt("currencyCd"));
						gcdd.put("currencyShortName", rows.getJSONObject(i).isNull("currencyShortName") || rows.getJSONObject(i).get("currencyShortName").equals("") ? null : rows.getJSONObject(i).getString("currencyShortName"));
						gcdd.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
						gcdd.put("foreignCurrAmt", rows.getJSONObject(i).isNull("foreignCurrAmt") || rows.getJSONObject(i).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignCurrAmt")));
						gcdd.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
						gcdd.put("netDeposit", rows.getJSONObject(i).isNull("netDeposit") || rows.getJSONObject(i).get("netDeposit").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("netDeposit")));
						gcdd.put("shortOver", rows.getJSONObject(i).isNull("shortOver") || rows.getJSONObject(i).get("shortOver").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("shortOver")));
						gcdd.put("remarks", rows.getJSONObject(i).isNull("remarks") || rows.getJSONObject(i).get("remarks").equals("") ? null : rows.getJSONObject(i).getString("remarks"));
						gcdd.put("bookTag", rows.getJSONObject(i).isNull("remarks") || rows.getJSONObject(i).get("bookTag").equals("") ? null : rows.getJSONObject(i).getString("bookTag"));
						
						gcddList.add(gcdd);
					}
				}
			}
		}
		
		return gcddList;
	}
	
	
	private List<Map<String, Object>> prepareGbdsdJSON(JSONArray rows, Map<String, Object> params)
		throws JSONException, ParseException {
		Map<String, Object> gbdsd =null;
		List<Map<String, Object>> gbdsdList = new ArrayList<Map<String,Object>>();
		
		for (int i = 0; i < rows.length(); i++) {
			gbdsd = new HashMap<String, Object>();
					
			gbdsd.put("depId", rows.getJSONObject(i).isNull("depId") || rows.getJSONObject(i).get("depId").equals("") ? null : rows.getJSONObject(i).getInt("depId"));
			gbdsd.put("depNo", rows.getJSONObject(i).isNull("depNo") || rows.getJSONObject(i).get("depNo").equals("") ? null : rows.getJSONObject(i).getInt("depNo"));
			gbdsd.put("currencyCd", rows.getJSONObject(i).isNull("currencyCd") || rows.getJSONObject(i).get("currencyCd").equals("") ? null : rows.getJSONObject(i).getInt("currencyCd"));
			gbdsd.put("bankCd", rows.getJSONObject(i).isNull("bankCd") || rows.getJSONObject(i).get("bankCd").equals("") ? null : rows.getJSONObject(i).getString("bankCd"));
			gbdsd.put("orPref", rows.getJSONObject(i).isNull("orPref") || rows.getJSONObject(i).get("orPref").equals("") ? null : rows.getJSONObject(i).getString("orPref"));
			gbdsd.put("checkNo", rows.getJSONObject(i).isNull("checkNo") || rows.getJSONObject(i).get("checkNo").equals("") ? null : rows.getJSONObject(i).getString("checkNo"));
			gbdsd.put("dspCheckNo", rows.getJSONObject(i).isNull("dspCheckNo") || rows.getJSONObject(i).get("dspCheckNo").equals("") ? null : rows.getJSONObject(i).getString("dspCheckNo"));
			gbdsd.put("payor", rows.getJSONObject(i).isNull("payor") || rows.getJSONObject(i).get("payor").equals("") ? null : rows.getJSONObject(i).getString("payor"));
			gbdsd.put("orNo", rows.getJSONObject(i).isNull("orNo") || rows.getJSONObject(i).get("orNo").equals("") ? null : rows.getJSONObject(i).getInt("orNo"));
			gbdsd.put("dspOrPrefSuf", rows.getJSONObject(i).isNull("dspOrPrefSuf") || rows.getJSONObject(i).get("dspOrPrefSuf").equals("") ? null : rows.getJSONObject(i).getString("dspOrPrefSuf"));
			gbdsd.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
			gbdsd.put("currencyShortName", rows.getJSONObject(i).isNull("currencyShortName") || rows.getJSONObject(i).get("currencyShortName").equals("") ? null : rows.getJSONObject(i).getString("currencyShortName"));
			gbdsd.put("foreignCurrAmt", rows.getJSONObject(i).isNull("foreignCurrAmt") || rows.getJSONObject(i).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignCurrAmt")));
			gbdsd.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
			gbdsd.put("bounceTag", rows.getJSONObject(i).isNull("bounceTag") || rows.getJSONObject(i).get("bounceTag").equals("") ? null : rows.getJSONObject(i).getString("bounceTag"));
			gbdsd.put("otcTag", rows.getJSONObject(i).isNull("otcTag") || rows.getJSONObject(i).get("otcTag").equals("") ? null : rows.getJSONObject(i).getString("otcTag"));
			gbdsd.put("localSur", rows.getJSONObject(i).isNull("localSur") || rows.getJSONObject(i).get("localSur").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("localSur")));
			gbdsd.put("foreignSur", rows.getJSONObject(i).isNull("foreignSur") || rows.getJSONObject(i).get("foreignSur").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignSur")));
			gbdsd.put("netCollnAmt", rows.getJSONObject(i).isNull("netCollnAmt") || rows.getJSONObject(i).get("netCollnAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("netCollnAmt")));
			gbdsd.put("errorTag", rows.getJSONObject(i).isNull("errorTag") || rows.getJSONObject(i).get("errorTag").equals("") ? null : rows.getJSONObject(i).getString("errorTag"));
			gbdsd.put("bookTag", rows.getJSONObject(i).isNull("bookTag") || rows.getJSONObject(i).get("bookTag").equals("") ? null : rows.getJSONObject(i).getString("bookTag"));
			gbdsd.put("depositedAmt", rows.getJSONObject(i).isNull("depositedAmt") || rows.getJSONObject(i).get("depositedAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("depositedAmt")));
			gbdsd.put("locErrorAmt", rows.getJSONObject(i).isNull("locErrorAmt") || rows.getJSONObject(i).get("locErrorAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("locErrorAmt")));
			
			gbdsdList.add(gbdsd);
		}
		
		return gbdsdList;
	}
	
	/*
	 * Prepares ERROR block list. if 'rows' parameter is null, it creates a new array list.
	 * Otherwise, use the existing array list.
	 */
	private List<Map<String, Object>> prepareErrorList(JSONArray rows, Map<String, Object> params, 
			BigDecimal amount, BigDecimal locErrorAmt)
		throws JSONException, ParseException{
		List<Map<String, Object>> gbdsdErrorList = null;
		Map<String, Object> error = null;
		log.info("Preparing error list.. ");
		if (rows != null) {
			for (int i = 0; i < rows.length(); i++) {
				error = new HashMap<String, Object>();
				gbdsdErrorList = new ArrayList<Map<String, Object>>();
				
				error.put("checkNo", rows.getJSONObject(i).isNull("checkNo") || rows.getJSONObject(i).get("checkNo").equals("") ? null : rows.getJSONObject(i).getString("checkNo"));
				error.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
				error.put("currencyShortName", rows.getJSONObject(i).isNull("currencyShortName") || rows.getJSONObject(i).get("currencyShortName").equals("") ? null : rows.getJSONObject(i).getString("currencyShortName"));
				error.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
				error.put("error", rows.getJSONObject(i).isNull("error") || rows.getJSONObject(i).get("error").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("error")));
				error.put("dspNetDeposit", rows.getJSONObject(i).isNull("dspNetDeposit") || rows.getJSONObject(i).get("dspNetDeposit").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("dspNetDeposit")));
				error.put("bookTag", rows.getJSONObject(i).isNull("bookTag") || rows.getJSONObject(i).get("bookTag").equals("") ? "Y" : rows.getJSONObject(i).getString("bookTag"));
				error.put("remarks", rows.getJSONObject(i).isNull("remarks") || rows.getJSONObject(i).get("remarks").equals("") ? null : rows.getJSONObject(i).getString("remarks"));
				error.put("rownum_", 1);
				error.put("count_", 1);
				
				gbdsdErrorList.add(error);
			}
		} else {
			error = new HashMap<String, Object>();
			gbdsdErrorList = new ArrayList<Map<String, Object>>();
			
			error.put("checkNo", params.get("dspCheckNo"));
			error.put("amount", params.get("amount"));
			error.put("currencyShortName", params.get("currencyShortName"));
			error.put("currencyRt", params.get("currencyRt"));
			error.put("error", locErrorAmt);
			error.put("dspNetDeposit", ((locErrorAmt == null) ? null : amount.subtract(locErrorAmt)));
			error.put("bookTag", (params.get("bookTag") == null) ? "Y" : (params.get("bookTag").toString().isEmpty() ? "Y" : params.get("bookTag").toString()));
			error.put("remarks", params.get("remarks"));
			error.put("rownum_", 1);
			error.put("count_", 1);
			
			gbdsdErrorList.add(error);
		}
		
		return gbdsdErrorList;
	}

	@Override
	public JSONObject getGiacBankDepSlips(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGbdsTableGrid");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		
		Map<String, Object> gbds2TableGridParams = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(gbds2TableGridParams);
	}

	@Override
	public JSONObject getGiacCashDepDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGcddTableGrid");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		
		Map<String, Object> gcddTableGridParams = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(gcddTableGridParams);
	}

}
