/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACAccTransDAO;
import com.geniisys.giac.entity.GIACAccTrans;
import com.geniisys.giac.service.GIACAccTransService;
import com.seer.framework.util.StringFormatter;

public class GIACAccTransServiceImpl implements GIACAccTransService {

	private GIACAccTransDAO giacAccTransDAO;

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getValidationDetail(java.lang.Integer)
	 */
	@Override
	public GIACAccTrans getValidationDetail(Integer tranId) throws SQLException {
		return giacAccTransDAO.getValidationDetail(tranId);
	}

	/**
	 * @return the giacAcctTransDAO
	 */
	public GIACAccTransDAO getGiacAccTransDAO() {
		return giacAccTransDAO;
	}

	/**
	 * @param giacAcctTransDAO
	 *            the giacAccTransDAO to set
	 */
	public void setGiacAccTransDAO(GIACAccTransDAO giacAccTransDAO) {
		this.giacAccTransDAO = giacAccTransDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getTranFlag(java.lang.Integer)
	 */
	@Override
	public String getTranFlag(Integer tranId) throws SQLException {
		return this.giacAccTransDAO.getTranFlag(tranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getDCBListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDCBListTableGridMap(Map<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareDCBListDetailFilter((String) params.get("filter")));
		List<Map<String, Object>> dcbList = this.getGiacAccTransDAO().getDCBListTableGrid(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(dcbList)));
		grid.setNoOfPages(dcbList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareDCBListDetailFilter(String filter) throws JSONException {
		Map<String, Object> dcbList = new HashMap<String, Object>();
		JSONObject jsonDCBListFilter = null;
		
		if (null == filter) {
			jsonDCBListFilter = new JSONObject();
		} else {
			jsonDCBListFilter = new JSONObject(filter);
		}
		
		dcbList.put("branchName", jsonDCBListFilter.isNull("dspBranchName") ? "" : jsonDCBListFilter.getString("dspBranchName").toUpperCase());
		dcbList.put("tranDate", jsonDCBListFilter.isNull("tranDate") ? "" : jsonDCBListFilter.getString("tranDate"));
		dcbList.put("dcbNo", jsonDCBListFilter.isNull("dcbNo") ? "" : jsonDCBListFilter.getString("dcbNo"));
		
		return dcbList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGiacAcctransDtl(java.lang.Integer)
	 */
	@Override
	public GIACAccTrans getGiacAcctransDtl(Integer gaccTranId)
			throws SQLException {
		return this.getGiacAccTransDAO().getGiacAcctransDtl(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGicdSumListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGicdSumListTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 50 ); //ApplicationWideParameters.PAGE_SIZE // dren 08.03.2015 : SR 0017729 - List all Entries
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> gicdSumList = this.getGiacAccTransDAO().getGicdSumListTableGrid(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(gicdSumList)));
		grid.setNoOfPages(gicdSumList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getOtcListTableGridMap(java.util.Map, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getOtcListTableGridMap(Map<String, Object> params, String strParameters)
			throws SQLException, JSONException, ParseException {
		JSONObject objParameters;
		List<Map<String, Object>> otcSurList = null;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		if (strParameters != null) {
			if (!strParameters.isEmpty()) {
				objParameters = new JSONObject(strParameters);
				otcSurList = this.prepareOtcJSON(new JSONArray(objParameters.getString("otcRows")), params);
			}
		}
		
		if (otcSurList != null) {
			if (otcSurList.size() == 0) {
				otcSurList= this.getGiacAccTransDAO().getOtcSurchargeForTableGrid(params);
				
				if (otcSurList == null) {
					Map<String, Object> otc = new HashMap<String, Object>();
					otcSurList = new ArrayList<Map<String, Object>>();
					otc.put("localSur", null);
					otc.put("foreignSur", null);
					otc.put("netCollnAmt", null);
					otcSurList.add(otc);
				}
				
				for (Map<String, Object> otc: otcSurList) {
					otc.put("checkNo", params.get("dspCheckNo"));
					otc.put("amount", params.get("amount"));
					otc.put("foreignCurrAmt", params.get("foreignCurrAmt"));
					otc.put("currencyShortName", params.get("currencyShortName"));
					otc.put("currencyRt", params.get("currencyRt"));
				}
			}
		} else {
			otcSurList= this.getGiacAccTransDAO().getOtcSurchargeForTableGrid(params);
			
			if (otcSurList == null) {
				Map<String, Object> otc = new HashMap<String, Object>();
				otcSurList = new ArrayList<Map<String, Object>>();
				otc.put("localSur", null);
				otc.put("foreignSur", null);
				otc.put("netCollnAmt", null);
				otcSurList.add(otc);
			}
			
			for (Map<String, Object> otc: otcSurList) {
				otc.put("checkNo", params.get("dspCheckNo"));
				otc.put("amount", params.get("amount"));
				otc.put("foreignCurrAmt", params.get("foreignCurrAmt"));
				otc.put("currencyShortName", params.get("currencyShortName"));
				otc.put("currencyRt", params.get("currencyRt"));
			}
		}
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(otcSurList)));
		grid.setNoOfPages(otcSurList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getLocmListTableGridMap(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getLocmListTableGridMap(
			Map<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<Map<String, Object>> locm = this.getGiacAccTransDAO().getLocmForTableGrid(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(locm)));
		grid.setNoOfPages(locm);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#validateGiacs035DCBNo1(java.util.Map)
	 */
	@Override
	public void validateGiacs035DCBNo1(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().validateGiacs035DCBNo1(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#validateGiacs035DCBNo2(java.util.Map)
	 */
	@Override
	public void validateGiacs035DCBNo2(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().validateGiacs035DCBNo2(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getTranFlagMean(java.lang.String)
	 */
	@Override
	public String getTranFlagMean(String tranFlag) throws SQLException {
		return this.getGiacAccTransDAO().getTranFlagMean(tranFlag);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#checkBankInOR(java.util.Map)
	 */
	@Override
	public String checkBankInOR(Map<String, Object> params) throws SQLException {
		return this.getGiacAccTransDAO().checkBankInOR(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getDCBPayModeList(java.lang.Integer, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getDCBPayModeList(Integer pageNo,
			Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> dcbPayModeList = this.getGiacAccTransDAO().getDCBPayModeList(params);
		PaginatedList paginatedList = new PaginatedList(dcbPayModeList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#executeGdbdAmtPreTextItem(java.util.Map)
	 */
	@Override
	public BigDecimal executeGdbdAmtPreTextItem(Map<String, Object> params)
			throws SQLException {
		return this.getGiacAccTransDAO().executeGdbdAmtPreTextItem(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGdbdAmtWhenValidate(java.util.Map)
	 */
	@Override
	public BigDecimal getGdbdAmtWhenValidate(Map<String, Object> params)
			throws SQLException {
		return this.getGiacAccTransDAO().getGdbdAmtWhenValidate(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getCurrSnameGicdSumRec(java.util.Map)
	 */
	@Override
	public BigDecimal getCurrSnameGicdSumRec(Map<String, Object> params)
			throws SQLException {
		return this.getGiacAccTransDAO().getCurrSnameGicdSumRec(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getTotFcAmtForGicdSumRec(java.util.Map)
	 */
	@Override
	public void getTotFcAmtForGicdSumRec(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().getTotFcAmtForGicdSumRec(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGcddCollectionAndDeposit(java.util.Map)
	 */
	@Override
	public void getGcddCollectionAndDeposit(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().getGcddCollectionAndDeposit(params);
	}
	

	
	private List<Map<String, Object>> prepareOtcJSON(JSONArray rows, Map<String, Object> params)
	throws JSONException, ParseException {
	Map<String, Object> otc =null;
	List<Map<String, Object>> otcList = new ArrayList<Map<String,Object>>();
	
	for (int i = 0; i < rows.length(); i++) {
		otc = new HashMap<String, Object>();
				
		otc.put("depId", rows.getJSONObject(i).isNull("depId") || rows.getJSONObject(i).get("depId").equals("") ? null : rows.getJSONObject(i).getInt("depId"));
		otc.put("orPref", rows.getJSONObject(i).isNull("orPref") || rows.getJSONObject(i).get("orPref").equals("") ? null : rows.getJSONObject(i).getString("orPref"));
		otc.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
		
		otc.put("localSur", rows.getJSONObject(i).isNull("localSur") || rows.getJSONObject(i).get("localSur").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("localSur")));
		otc.put("foreignSur", rows.getJSONObject(i).isNull("foreignSur") || rows.getJSONObject(i).get("foreignSur").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignSur")));
		otc.put("netCollnAmt", rows.getJSONObject(i).isNull("netCollnAmt") || rows.getJSONObject(i).get("netCollnAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("netCollnAmt")));
		otc.put("checkNo", rows.getJSONObject(i).isNull("checkNo") || rows.getJSONObject(i).get("checkNo").equals("") ? null : rows.getJSONObject(i).getString("checkNo"));
		otc.put("amount", rows.getJSONObject(i).isNull("amount") || rows.getJSONObject(i).get("amount").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("amount")));
		otc.put("foreignCurrAmt", rows.getJSONObject(i).isNull("foreignCurrAmt") || rows.getJSONObject(i).get("foreignCurrAmt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("foreignCurrAmt")));
		otc.put("currencyShortName", rows.getJSONObject(i).isNull("currencyShortName") || rows.getJSONObject(i).get("currencyShortName").equals("") ? null : rows.getJSONObject(i).getString("currencyShortName"));
		otc.put("currencyRt", rows.getJSONObject(i).isNull("currencyRt") || rows.getJSONObject(i).get("currencyRt").equals("") ? null :new BigDecimal(rows.getJSONObject(i).getString("currencyRt")));
		
		otcList.add(otc);
	}
	
	return otcList;
}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getCheckClassList()
	 */
	@Override
	public List<CGRefCodes> getCheckClassList() throws SQLException {
		return this.getGiacAccTransDAO().getCheckClassList();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#updateGbdsdInOtc(java.lang.Integer)
	 */
	@Override
	public void updateGbdsdInOtc(Integer depId) throws SQLException {
		this.getGiacAccTransDAO().updateGbdsdInOtc(depId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#getGbdsdLOV(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getGbdsdLOV(Map<String, Object> params)
			throws SQLException {
		return this.getGiacAccTransDAO().getGbdsdLOV(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#executeGiacs035BankDepReturnBtn(java.util.Map)
	 */
	@Override
	public void executeGiacs035BankDepReturnBtn(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().executeGiacs035BankDepReturnBtn(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#checkDCBForClosing(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkDCBForClosing(Map<String, Object> params)
			throws SQLException {
		return this.getGiacAccTransDAO().checkDCBForClosing(params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAccTransService#closeDCB(java.lang.String, java.lang.String)
	 */
	@Override
	public String closeDCB(String param, String userId)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		
		JSONObject closeParam = new JSONObject(objParams.getString("closeParams"));
		Map<String, Object> closingMap= new HashMap<String, Object>();
		closingMap.put("moduleName", "GIACS035");
		closingMap.put("tranId", closeParam.isNull("tranId") ? null : closeParam.getInt("tranId"));
		closingMap.put("dcbNo", closeParam.isNull("dcbNo") ? null : closeParam.getInt("dcbNo"));
		closingMap.put("fundCd", closeParam.isNull("fundCd") ? null : closeParam.getString("fundCd"));
		closingMap.put("branchCd", closeParam.isNull("branchCd") ? null : closeParam.getString("branchCd"));
		closingMap.put("itemNo", 1);
		closingMap.put("pdcExists", closeParam.isNull("pdcExists") ? null : closeParam.getString("pdcExists"));
		closingMap.put("bankInOR", closeParam.isNull("bankInOR") ? null : closeParam.getString("bankInOR"));
		closingMap.put("userId", userId);
		
		params.put("updateEntries", objParams.isNull("updateEntries") ? "N" : objParams.getString("updateEntries"));
		params.put("balParam", closingMap);
		params.put("accTrans", this.prepareAccTransForCloseDCB(new JSONObject(objParams.getString("accTranParams")), userId));
		return this.getGiacAccTransDAO().closeDCB(params);
	}
	
	private Map<String, Object> prepareAccTransForCloseDCB(JSONObject setObj, String userId) throws JSONException {
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
		atObj.put("dcbFlag", "C");
		return atObj;
	}

	@Override
	public void updateAccTransFlag(Map<String, Object> params)
			throws SQLException {
		this.getGiacAccTransDAO().updateAccTransFlag(params);
	}

	@Override
	public void updateDCBCancel(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("dcbYear", request.getParameter("dcbYear"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		this.getGiacAccTransDAO().updateDCBCancel(params);
	}

	public Map<String, Object> getRecAcctEntTranDtl(Integer acctTranId)
			throws SQLException {
		List<Map<String, Object>> listofAcct = this.getGiacAccTransDAO().getRecAcctEntTranDtl(acctTranId);
		System.out.println("listofAcct" + listofAcct);
		if(listofAcct.size() > 0) 
			return listofAcct.get(0);
		else
			return null;
	}
	
	@Override
	public String checkDCBFlag (String param) throws SQLException, JSONException {  //Deo [03.03.2017]: SR-5939
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		JSONObject dcbParam = new JSONObject(objParams.getString("closeParams"));
		params.put("fundCd", dcbParam.getString("fundCd"));
		params.put("branchCd", dcbParam.getString("branchCd"));
		params.put("tranYear", dcbParam.getInt("tranYear"));
		params.put("dcbNo", dcbParam.getInt("dcbNo"));
		params.put("type", "C");
		return this.getGiacAccTransDAO().checkDCBFlag(params);
	}
}
