package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
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
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDCBBankDepDAO;
import com.geniisys.giac.entity.GIACDCBBankDep;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACDCBBankDepService;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIACDCBBankDepServiceImpl implements GIACDCBBankDepService {
	
	/** The DAO */
	private GIACDCBBankDepDAO giacDCBBankDepDAO;
	
	private GIACAccTransService giacAccTransService;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACDCBBankDepServiceImpl.class);

	public void setGiacDCBBankDepDAO(GIACDCBBankDepDAO giacDCBBankDepDAO) {
		this.giacDCBBankDepDAO = giacDCBBankDepDAO;
	}

	public GIACDCBBankDepDAO getGiacDCBBankDepDAO() {
		return giacDCBBankDepDAO;
	}

	public GIACAccTransService getGiacAccTransService() {
		return giacAccTransService;
	}

	public void setGiacAccTransService(GIACAccTransService giacAccTransService) {
		this.giacAccTransService = giacAccTransService;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDCBBankDepService#getGdbdSumListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGdbdSumListTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {
		log.info("getGdbdSumListTableGridMap");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 50 ); //ApplicationWideParameters.PAGE_SIZE // dren 08.03.2015 : SR 0017729 - List all Entries
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> gdbdList = this.getGiacDCBBankDepDAO().getGdbdListTableGrid(params);

		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.escapeHTMLInListOfMap(gdbdList)));
		grid.setNoOfPages(gdbdList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACDCBBankDepService#populateGDBD(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> populateGDBD(Map<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 50 ); //ApplicationWideParameters.PAGE_SIZE // dren 08.03.2015 : SR 0017729 - List all Entries
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> gdbdList = this.getGiacDCBBankDepDAO().populateGDBD(params);

		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gdbdList)));
		grid.setNoOfPages(gdbdList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public Map<String, Object> saveDCBForClosing(String param, String userId)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Debug.print("saveDCBForClosing Service Impl - " + objParams);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("isNew", objParams.isNull("isNew") ? "N" : objParams.getString("isNew"));
		if(objParams.getString("dcbFlagC").equals("Y")){
			System.out.println("DCB FLAG C VALUE IS C");
			params.put("setAccTrans", this.prepareAccTransForDCBClosingC(new JSONObject(objParams.getString("accTransRows")), userId));
		} else {
			System.out.println("DCB FLAG C VALUE IS T");
			params.put("setAccTrans", this.prepareAccTransForDCBClosing(new JSONObject(objParams.getString("accTransRows")), userId));
		}
		params.put("setGDBDRows", this.prepareBankDepForInsert(new JSONArray(objParams.getString("setGdbdRows")), userId));
		params.put("delGDBDRows", this.prepareBankDepForDelete(new JSONArray(objParams.getString("delGdbdRows")), userId));

		params.put("gaccBranchCd", objParams.getString("gaccBranchCd")); /// dren 08.03.2015 : SR 0017729 - Adding Acct Entries - Start
		params.put("gaccFundCd", objParams.getString("gaccFundCd"));
		params.put("moduleName", objParams.getString("moduleName")); // dren 08.03.2015 : SR 0017729 - Adding Acct Entries - End
		params.put("userId", userId); // dren 08.03.2015 : SR 0017729 - Adding Acct Entries - End			
		return this.giacDCBBankDepDAO.saveDCBForClosing(params);
	}
	
	private List<GIACDCBBankDep> prepareBankDepForInsert(JSONArray setRows, String userId) 
		throws JSONException, ParseException {
		List<GIACDCBBankDep> bankDepList = new ArrayList<GIACDCBBankDep>();
		GIACDCBBankDep bankDep = null;
		JSONObject dcbObj = null;
		SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy"); // dren 08.26.2015 : SR 0017729 - Fix format of DCB Date.
		
		for(int i = 0; i<setRows.length(); i++) {
			bankDep = new GIACDCBBankDep();
			dcbObj = setRows.getJSONObject(i);
			
			bankDep.setGaccTranId(dcbObj.isNull("gaccTranId") || dcbObj.get("gaccTranId").equals("") ? 0 : dcbObj.getInt("gaccTranId")); // dren 08.03.2015 : SR 0017729 - To Enable saving for new DCB
			bankDep.setFundCd(dcbObj.isNull("fundCd") ? null : dcbObj.getString("fundCd"));
			bankDep.setBranchCd(dcbObj.isNull("branchCd") ? null : dcbObj.getString("branchCd"));
			bankDep.setDcbYear(dcbObj.isNull("dcbYear") ? null : dcbObj.getInt("dcbYear"));
			bankDep.setDcbNo(dcbObj.isNull("dcbNo") ? null : dcbObj.getInt("dcbNo"));
			bankDep.setDcbDate(dcbObj.isNull("dcbDate") ? null : df.parse(dcbObj.getString("dcbDate")));
			bankDep.setItemNo(dcbObj.isNull("itemNo") ? null : dcbObj.getInt("itemNo"));
			bankDep.setBankCd(dcbObj.isNull("bankCd") ? null : dcbObj.getString("bankCd"));
			bankDep.setBankAcctCd(dcbObj.isNull("bankAcctCd") ? null : dcbObj.getString("bankAcctCd"));
			bankDep.setPayMode(dcbObj.isNull("payMode") ? null : dcbObj.getString("payMode"));
			bankDep.setAmount(dcbObj.isNull("amount") ? null : new BigDecimal(dcbObj.getString("amount")));
			bankDep.setForeignCurrAmt(dcbObj.isNull("foreignCurrAmt") ? null : new BigDecimal(dcbObj.getString("foreignCurrAmt")));
			bankDep.setCurrencyRt(dcbObj.isNull("currencyRt") ? null : new BigDecimal(dcbObj.getString("currencyRt")));
			bankDep.setCurrencyCd(dcbObj.isNull("currencyCd") ? null : dcbObj.getInt("currencyCd"));
			bankDep.setOldDepAmt(dcbObj.isNull("oldDepAmt") ? null : new BigDecimal(dcbObj.getString("oldDepAmt")));
			bankDep.setAdjAmt(dcbObj.isNull("adjAmt") ? null : new BigDecimal(dcbObj.getString("adjAmt")));
			bankDep.setRemarks(dcbObj.isNull("remarks") ? null : dcbObj.getString("remarks"));
			bankDep.setUserId(userId);
			
			bankDepList.add(bankDep);
			bankDep = null;
			
		}
		
		return bankDepList;
	}
	
	private List<GIACDCBBankDep> prepareBankDepForDelete(JSONArray setRows, String userId) 
		throws JSONException {
		List<GIACDCBBankDep> delObjMap = new ArrayList<GIACDCBBankDep>();
		GIACDCBBankDep bankDep = null;
		JSONObject dcbObj = null;
		Integer tranId = 0;
		for(int i=0; i<setRows.length(); i++) {
			bankDep = new GIACDCBBankDep();
			dcbObj = setRows.getJSONObject(i);
			tranId = dcbObj.isNull("gaccTranId") ? 0 : dcbObj.getInt("gaccTranId");
			if(tranId > 0) {
				bankDep.setGaccTranId(dcbObj.isNull("gaccTranId") ? 0 : dcbObj.getInt("gaccTranId"));
				bankDep.setFundCd(dcbObj.isNull("fundCd") ? null : dcbObj.getString("fundCd"));
				bankDep.setBranchCd(dcbObj.isNull("branchCd") ? null : dcbObj.getString("branchCd"));
				bankDep.setDcbYear(dcbObj.isNull("dcbYear") ? null : dcbObj.getInt("dcbYear"));
				bankDep.setDcbNo(dcbObj.isNull("dcbNo") ? null : dcbObj.getInt("dcbNo"));
				bankDep.setItemNo(dcbObj.isNull("itemNo") ? null : dcbObj.getInt("itemNo"));
				bankDep.setUserId(userId);
				
				delObjMap.add(bankDep);
			}
			bankDep = null;
		}
		return delObjMap;
	}
	
	private Map<String, Object> prepareAccTransForDCBClosing(JSONObject setObj, String userId) throws JSONException, ParseException {
		Map<String, Object> atObj = new HashMap<String, Object>();
		
		atObj.put("gaccTranId", setObj.isNull("tranId") ? 0 : setObj.getInt("tranId"));
		atObj.put("fundCd", setObj.isNull("fundCd") ? null : setObj.getString("fundCd"));
		atObj.put("branchCd", setObj.isNull("branchCd") ? null : setObj.getString("branchCd"));
		atObj.put("tranYear", setObj.isNull("tranYear") ? null : setObj.getInt("tranYear"));
		atObj.put("tranMonth", setObj.isNull("tranMonth") ? null : setObj.getInt("tranMonth"));
		atObj.put("tranClassNo", setObj.isNull("tranClassNo") ? null : setObj.getInt("tranClassNo"));
		atObj.put("particulars", setObj.isNull("particulars") ? null : setObj.getString("particulars"));
		atObj.put("tranFlag", setObj.isNull("tranFlag") ? null : setObj.getString("tranFlag"));
		atObj.put("tranClass", setObj.isNull("tranClass") ? null : setObj.getString("tranClass"));
		atObj.put("userId", userId);
		atObj.put("tranDate", setObj.isNull("tranDate") ? null : setObj.getString("tranDate"));
		atObj.put("dcbFlag", "T");
		Debug.print("prepareAccTransForDCBClosing - "+atObj);
		return atObj;
	}
	
	private Map<String, Object> prepareAccTransForDCBClosingC(JSONObject setObj, String userId) throws JSONException, ParseException {
		Map<String, Object> atObj = new HashMap<String, Object>();
		
		atObj.put("gaccTranId", setObj.isNull("tranId") ? 0 : setObj.getInt("tranId"));
		atObj.put("fundCd", setObj.isNull("fundCd") ? null : setObj.getString("fundCd"));
		atObj.put("branchCd", setObj.isNull("branchCd") ? null : setObj.getString("branchCd"));
		atObj.put("tranYear", setObj.isNull("tranYear") ? null : setObj.getInt("tranYear"));
		atObj.put("tranMonth", setObj.isNull("tranMonth") ? null : setObj.getInt("tranMonth"));
		atObj.put("tranClassNo", setObj.isNull("tranClassNo") ? null : setObj.getInt("tranClassNo"));
		atObj.put("particulars", setObj.isNull("particulars") ? null : setObj.getString("particulars"));
		atObj.put("tranFlag", "C");
		atObj.put("tranClass", setObj.isNull("tranClass") ? null : setObj.getString("tranClass"));
		atObj.put("userId", userId);
		atObj.put("tranDate", setObj.isNull("tranDate") ? null : setObj.getString("tranDate"));
		atObj.put("dcbFlag", "C");
		Debug.print("prepareAccTransForDCBClosingDCBClose - "+atObj);
		return atObj;
	}
	@Override
	public void refreshDCB(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		params.put("dcbYear", request.getParameter("dcbYear"));
		params.put("dcbDate", request.getParameter("dcbDate"));
		params.put("userId", userId);
		params.put("moduleName", request.getParameter("moduleName")); // dren 08.03.2015 : SR 0017729 - Additional parameter for Refresh DCB
		this.getGiacDCBBankDepDAO().refreshDCB(params);
	}	
}
