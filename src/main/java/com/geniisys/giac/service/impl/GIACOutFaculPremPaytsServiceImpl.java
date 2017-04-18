package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACOutFaculPremPaytsDAO;
import com.geniisys.giac.entity.GIACOutFaculPremPaymt;
import com.geniisys.giac.service.GIACOutFaculPremPaytsService;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

public class GIACOutFaculPremPaytsServiceImpl implements GIACOutFaculPremPaytsService{
	
	private GIACOutFaculPremPaytsDAO giacOutFaculPremPaytDAO;
	private static Logger log = Logger.getLogger(GIACOutFaculPremPaytsServiceImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getBinderList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBinderList(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		log.info("Preparing GIACOutPremPayts Table Grid...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		Debug.print("PARAMS IMPL: " + params);
		List<Map<String, Object>> list = this.giacOutFaculPremPaytDAO.getBinderList(params);
		System.out.println("Size of LIST: " + list.size());
		params.put("rows", new JSONArray((List<GIACOutFaculPremPaymt>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println(grid.getNoOfPages());
		System.out.println(grid.getNoOfRows());
		log.info("GIACOutPremPayts Table Grid preparation done.");
		return params;
	}
	
	/**
	 * @return the giacOutFaculPremPaytDAO
	 */
	public GIACOutFaculPremPaytsDAO getGiacOutFaculPremPaytDAO() {
		return giacOutFaculPremPaytDAO;
	}
	
	/**
	 * @param giacOutFaculPremPaytDAO the giacOutFaculPremPaytDAO to set
	 */
	public void setGiacOutFaculPremPaytDAO(
			GIACOutFaculPremPaytsDAO giacOutFaculPremPaytDAO) {
		this.giacOutFaculPremPaytDAO = giacOutFaculPremPaytDAO;
	}
	
	/**
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getBinderList2(Map<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareOutFaculPremPatsFilter((String) params.get("filter"), params));
		List<Map<String, Object>> binderDtls = this.giacOutFaculPremPaytDAO.getBinderList2(params);
		params.put("rows", new JSONArray((List<Map<String, Object>>) StringFormatter.replaceQuotesInList(binderDtls)));
		System.out.println("SIZE DAO: " + binderDtls.size());
		grid.setNoOfPagesInMap(binderDtls);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println(grid.getNoOfPages());
		System.out.println(grid.getNoOfRows());
		return params;
	}
	
	/**
	 * 
	 * @param filter
	 * @param params
	 * @return
	 * @throws JSONException
	 */
	private Map<String, Object> prepareOutFaculPremPatsFilter(String filter, Map<String, Object> params) throws JSONException{
		Map<String, Object> outFaculPremPayts = new HashMap<String, Object>();
		JSONObject jsonOutFaculPremPaytsFilter = null;
		
		if(null == filter){
			jsonOutFaculPremPaytsFilter = new JSONObject();
		}else{
			jsonOutFaculPremPaytsFilter = new JSONObject(filter);
		}
		String lineCd = params.get("lineCd").toString() == null ? "" : params.get("lineCd").toString();
		System.out.println("binderYY: " + params.get("binderYY") + " binderSeqNo: " + params.get("binderSeqNo"));
		String binderYY = params.get("binderYY") == null  ?  null : params.get("binderYY").toString();
		String binderSeqNo = params.get("binderSeqNo") == null  ?  null : params.get("binderSeqNo").toString();
		
		outFaculPremPayts.put("lineCd", jsonOutFaculPremPaytsFilter.isNull("lineCd") ?  lineCd : jsonOutFaculPremPaytsFilter.getString("lineCd").toUpperCase());
		outFaculPremPayts.put("binderYY", jsonOutFaculPremPaytsFilter.isNull("binderYY") ? binderYY : jsonOutFaculPremPaytsFilter.getInt("binderYY"));
		outFaculPremPayts.put("binderSeqNo", jsonOutFaculPremPaytsFilter.isNull("binderSeqNo") ? binderSeqNo : jsonOutFaculPremPaytsFilter.getInt("binderSeqNo"));
		
		return outFaculPremPayts;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#validateBinderNo(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> validateBinderNo(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.validateBinderNo(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getBreakdownAmts(java.util.Map)
	 */
	@Override
	public Map<String, Object> getBreakdownAmts(Map<String, Object> params)	throws SQLException {
		return this.giacOutFaculPremPaytDAO.getBreakdownAmts(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getAllOutFaculPremPayts(java.util.Map)
	 */
	@Override
	public List<Map<String, Object>> getAllOutFaculPremPayts(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.getAllOutFaculPremPayts(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#saveOutFaculPremPayts(java.util.Map)
	 */
	@Override
	public void saveOutFaculPremPayts(Map<String, Object> allParams)	throws SQLException, JSONException, ParseException{
		JSONObject objParameters = new JSONObject(allParams.get("jsonParameters").toString());
		Map<String, Object> postFormsCommitParams = new HashMap<String, Object>();
		postFormsCommitParams.put("userId", allParams.get("userId").toString());
		postFormsCommitParams.put("appUser", allParams.get("userId").toString());
		postFormsCommitParams.put("gaccTranId", Integer.parseInt(allParams.get("gaccTranId").toString()));
		postFormsCommitParams.put("moduleName", allParams.get("moduleName").toString());
		postFormsCommitParams.put("fundCd", allParams.get("fundCd").toString());
		postFormsCommitParams.put("branchCd", allParams.get("branchCd").toString());
		postFormsCommitParams.put("orFlag", allParams.get("orFlag").toString());
		postFormsCommitParams.put("tranSource", allParams.get("tranSource").toString());
		
		Map<String, Object> allParameters = new HashMap<String, Object>();
		allParameters.put("addModifiedOutFaculPremPayts", this.prepareAddedModifiedOutFaculPremPayts(new JSONArray(objParameters.getString("setOutFaculPremPayt")), allParams.get("userId").toString()));
		allParameters.put("deletedOutFaculPremPayts", this.prepareDeletedOutFaculPremPayts(new JSONArray(objParameters.getString("delOutFaculPremPayt")), Integer.parseInt(allParams.get("gaccTranId").toString())));
		allParameters.put("postFormsCommitParams", postFormsCommitParams);
		
		this.giacOutFaculPremPaytDAO.saveOutFaculPremPayts(allParameters);
	}
	
	/**
	 * 
	 * @param setRows
	 * @param userId
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 * @throws SQLException
	 */
	public List<GIACOutFaculPremPaymt> prepareAddedModifiedOutFaculPremPayts(JSONArray setRows, String userId) throws JSONException, ParseException, SQLException {
		GIACOutFaculPremPaymt outFaculPremPayts = null;
		JSONObject json = null;
		List<GIACOutFaculPremPaymt> setOutFaculPremPayts = new ArrayList<GIACOutFaculPremPaymt>();
		
		for(int index=0; index<setRows.length(); index++){
			json = setRows.getJSONObject(index);
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("riCd", json.getInt("riCd"));
			params.put("lineCd", json.getString("lineCd"));
			params.put("binderYY", json.getString("binderYY"));
			params.put("binderSeqNo", json.getString("binderSeqNo"));
			params.put("disbursementAmt", json.getString("disbursementAmt"));
			
			Map<String, Object> breakdownDtls = this.getBreakdownAmts(params);
			Debug.print("GET BREAKDOWN PARAMS" + breakdownDtls);
			
			outFaculPremPayts = new GIACOutFaculPremPaymt();
			outFaculPremPayts.setGaccTranId(json.getInt("gaccTranId"));
			outFaculPremPayts.setBinderId(json.getInt("binderId"));
			outFaculPremPayts.setRiCd(json.getInt("riCd"));
			outFaculPremPayts.setTranType(json.getInt("tranType"));
			outFaculPremPayts.setDisbursementAmt(new BigDecimal(json.getString("disbursementAmt")));
			outFaculPremPayts.setPremAmt(new BigDecimal(breakdownDtls.get("premAmt").toString()));
			outFaculPremPayts.setPremVat(new BigDecimal(breakdownDtls.get("premVat").toString()));
			outFaculPremPayts.setCommAmt(new BigDecimal(breakdownDtls.get("commAmt").toString()));
			outFaculPremPayts.setCommVat(new BigDecimal(breakdownDtls.get("commVat").toString()));
			outFaculPremPayts.setWholdingTax(new BigDecimal(breakdownDtls.get("wholdingTax").toString()));
			outFaculPremPayts.setCurrencyCd(json.getInt("currencyCd"));
			outFaculPremPayts.setConvertRate(new BigDecimal(json.getString("currencyRt")));
			outFaculPremPayts.setForeignCurrAmt(new BigDecimal(json.getString("foreignCurrAmt")));
			outFaculPremPayts.setUserId(userId);
			outFaculPremPayts.setOrPrintTag(json.getString("orPrintTag").equals(null) ? "N" : json.getString("orPrintTag"));
			outFaculPremPayts.setCmTag(json.getString("cmTag").equals(null) ? "N" : json.getString("cmTag"));
			outFaculPremPayts.setRemarks(json.getString("remarks").equals("null") ? null : json.getString("remarks"));
			outFaculPremPayts.setPaytGaccTranId(json.getString("paytGaccTranId").equals(null) || json.getString("paytGaccTranId").equals("") ? null : json.getInt("paytGaccTranId"));	// SR-19631 : shan 08.17.2015
			setOutFaculPremPayts.add(outFaculPremPayts);
			
		}
		return setOutFaculPremPayts;
	}
	
	/**
	 * 
	 * @param delRows
	 * @param gaccTranId
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<Map<String, Object>> prepareDeletedOutFaculPremPayts(JSONArray delRows, Integer gaccTranId) throws JSONException, ParseException{
		List<Map<String, Object>> delItems = new ArrayList<Map<String, Object>>();
		Map<String, Object> delItem = null;
		
		for(int index=0; index<delRows.length(); index++){
			delItem = new HashMap<String, Object>();
			delItem.put("tranType", delRows.getJSONObject(index).getInt("tranType"));	// SR-19631 : shan 08.18.2015
			delItem.put("paytGaccTranId", delRows.getJSONObject(index).get("paytGaccTranId").equals(null) || delRows.getJSONObject(index).get("paytGaccTranId").equals("")? null : delRows.getJSONObject(index).getInt("paytGaccTranId"));	// SR-19631 : shan 08.18.2015
			delItem.put("recordNo", delRows.getJSONObject(index).getInt("recordNo"));	// SR-19631 : shan 08.18.2015
			delItem.put("binderId", delRows.getJSONObject(index).getInt("binderId"));
			delItem.put("riCd", delRows.getJSONObject(index).getInt("riCd"));
			delItem.put("gaccTranId", gaccTranId);
			
			delItems.add(delItem);
		}
		
		return delItems;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getDisbursementAmt(java.util.Map)
	 */
	@Override
	public BigDecimal getDisbursementAmt(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.getDisbursementAmt(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getOverrideDisbursementAmt(java.util.Map)
	 */
	@Override
	public Map<String, Object> getOverrideDisbursementAmt(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.getOverrideDisbursementAmt(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getRevertDisbursementAmt(java.util.Map)
	 */
	@Override
	public Map<String, Object> getRevertDisbursementAmt(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.getRevertDisbursementAmt(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#getFaculIssCdPremSeqNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> getFaculIssCdPremSeqNo(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.getFaculIssCdPremSeqNo(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOutFaculPremPaytsService#postFormsCommitOutFacul(java.util.Map)
	 */
	@Override
	public Map<String, Object> postFormsCommitOutFacul(Map<String, Object> params) throws SQLException {
		return this.giacOutFaculPremPaytDAO.postFormsCommitOutFacul(params);
	}

	@Override
	public Map<String, Object> getOverrideDetails(Map<String, Object> params) throws SQLException {  //added by steven 5.29.2012
		return this.giacOutFaculPremPaytDAO.getOverrideDetails(params);
	}
	
	public Map<String, Object> validateBinderNo2(Map<String, Object> params) throws SQLException{
		return this.giacOutFaculPremPaytDAO.validateBinderNo2(params);
	}
}
