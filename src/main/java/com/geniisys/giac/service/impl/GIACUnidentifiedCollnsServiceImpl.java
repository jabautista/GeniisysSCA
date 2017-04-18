package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACUnidentifiedCollnsDAO;
import com.geniisys.giac.entity.GIACUnidentifiedCollns;
import com.geniisys.giac.service.GIACUnidentifiedCollnsService;

public class GIACUnidentifiedCollnsServiceImpl implements GIACUnidentifiedCollnsService{

	private GIACUnidentifiedCollnsDAO giacUnidentifiedCollnsDAO;
	
	private Logger log = Logger.getLogger(GIACLossRiCollnsServiceImpl.class);
		
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACUnidentifiedCollnsService#getOldItemList(java.util.Map, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getOldItemList(Map<String, Object> params, Integer pageNo) throws SQLException {
		List<Map<String, Object>> itemNoList = this.giacUnidentifiedCollnsDAO.getOldItemList(params);
		PaginatedList paginatedList = new PaginatedList(itemNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/**
	 * @return the giacUnidentifiedCollnsDAO
	 */
	public GIACUnidentifiedCollnsDAO getGiacUnidentifiedCollnsDAO() {
		return giacUnidentifiedCollnsDAO;
	}

	/**
	 * @param giacUnidentifiedCollnsDAO the giacUnidentifiedCollnsDAO to set
	 */
	public void setGiacUnidentifiedCollnsDAO(
			GIACUnidentifiedCollnsDAO giacUnidentifiedCollnsDAO) {
		this.giacUnidentifiedCollnsDAO = giacUnidentifiedCollnsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACUnidentifiedCollnsService#getUnidentifiedCollnsListing(java.util.Map)
	 */
	@Override
	public List<GIACUnidentifiedCollns> getUnidentifiedCollnsListing(Map<String, Object> params) throws SQLException {
		return this.giacUnidentifiedCollnsDAO.getUnidentifiedCollnsListing(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACUnidentifiedCollnsService#saveUnidentifiedCollnsDtls(org.json.JSONArray, org.json.JSONArray, java.util.Map)
	 */
	/*public String saveUnidentifiedCollnsDtls(JSONArray setRows, 
			JSONArray delRows, Map<String, Object> params) throws SQLException, JSONException, ParseException {
		
		List<GIACUnidentifiedCollns> setUC = this.prepareAddModifiedCollns(setRows);
		List<GIACUnidentifiedCollns> delUC = this.prepareDeletedCollns(delRows);

		return this.getGiacUnidentifiedCollnsDAO().saveUnidentifiedCollnsDtls(setUC, delUC, params);
	}*/
	
	/**
	 * 
	 * @param delRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	@SuppressWarnings("null")
	public List<GIACUnidentifiedCollns> prepareDeletedCollns(JSONArray delRows) throws JSONException, ParseException{
		
		GIACUnidentifiedCollns delItem = null;
		JSONObject json = null;
		List<GIACUnidentifiedCollns> delItems = new ArrayList<GIACUnidentifiedCollns>();

		for(int index=0; index<delRows.length(); index++) {
			delItem = new GIACUnidentifiedCollns();	
			delItem.setGaccTranId(json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
			delItem.setItemNo(json.isNull("itemNo") ? null : json.getInt("itemNo"));
			System.out.println("prepare delitem: " + delItem);
			delItems.add(delItem);
		}	
		return delItems;
	}
	
	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 * @throws ParseException
	 */
	public List<GIACUnidentifiedCollns> prepareAddModifiedCollns(JSONArray setRows) throws JSONException, ParseException{
		GIACUnidentifiedCollns unidentifiedCollns = null;
		JSONObject json = null;
		List<GIACUnidentifiedCollns> setUnidentifiedCollns = new ArrayList<GIACUnidentifiedCollns>();
		for(int index=0; index<setRows.length(); index++) {
			json =  setRows.getJSONObject(index);
			System.out.println(" Category: " + json.getString("glAcctCategory"));
			unidentifiedCollns = new GIACUnidentifiedCollns();						
			unidentifiedCollns.setGaccTranId(json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
			unidentifiedCollns.setItemNo(json.isNull("itemNo") ? null : json.getInt("itemNo"));
			unidentifiedCollns.setTranType(json.isNull("tranType") ? null : json.getInt("tranType"));
			unidentifiedCollns.setCollAmt(json.isNull("collAmt") ? null : new BigDecimal(json.getString("collAmt")));
			unidentifiedCollns.setGlAcctId(json.isNull("glAcctId") ? null : json.getString("glAcctId").isEmpty() ? null : Integer.parseInt((json.getString("glAcctId"))));
			unidentifiedCollns.setGlAcctCategory(json.isNull("glAcctCategory") ? null : json.getString("glAcctCategory").isEmpty() ? null : Integer.parseInt((json.getString("glAcctCategory"))));
			unidentifiedCollns.setGlCtrlAcct(json.isNull("glCtrlAcct") ? null : json.getString("glCtrlAcct").isEmpty() ? null : Integer.parseInt((json.getString("glCtrlAcct"))));
			unidentifiedCollns.setGlSubAcct1(json.isNull("glSubAcct1") ? null : json.getString("glSubAcct1").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct1"))));
			unidentifiedCollns.setGlSubAcct2(json.isNull("glSubAcct2") ? null : json.getString("glSubAcct2").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct2"))));
			unidentifiedCollns.setGlSubAcct3(json.isNull("glSubAcct3") ? null : json.getString("glSubAcct3").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct3"))));
			unidentifiedCollns.setGlSubAcct4(json.isNull("glSubAcct4") ? null : json.getString("glSubAcct4").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct4"))));
			unidentifiedCollns.setGlSubAcct5(json.isNull("glSubAcct5") ? null : json.getString("glSubAcct5").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct5"))));
			unidentifiedCollns.setGlSubAcct6(json.isNull("glSubAcct6") ? null : json.getString("glSubAcct6").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct6"))));
			unidentifiedCollns.setGlSubAcct7(json.isNull("glSubAcct7") ? null : json.getString("glSubAcct7").isEmpty() ? null : Integer.parseInt((json.getString("glSubAcct7"))));
			unidentifiedCollns.setOrPrintTag(json.isNull("orPrintTag") ? null : json.getString("orPrintTag"));
			unidentifiedCollns.setSlCd(json.isNull("slCd") ? null : json.getString("glCtrlAcct").isEmpty() ? null : Integer.parseInt((json.getString("glCtrlAcct"))));
			unidentifiedCollns.setGuncTranId(json.isNull("guncTranId") ? null : json.getString("guncTranId").isEmpty() ? null : Integer.parseInt((json.getString("guncTranId"))));
			unidentifiedCollns.setGuncItemNo(json.isNull("guncItemNo") ? null : json.getString("guncItemNo").isEmpty() ? null : Integer.parseInt((json.getString("guncItemNo"))));
			unidentifiedCollns.setParticulars(json.isNull("particulars") ? null : json.getString("particulars"));
			System.out.println("prepare setitem: " + unidentifiedCollns);
			setUnidentifiedCollns.add(unidentifiedCollns);
		}	
		return setUnidentifiedCollns;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACUnidentifiedCollnsService#searchOldItemList(java.util.Map, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList searchOldItemList(Map<String, Object> params, Integer pageNo) throws SQLException {
		List<Map<String, Object>> itemNoList = this.giacUnidentifiedCollnsDAO.searchOldItemList(params);
		PaginatedList paginatedList = new PaginatedList(itemNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	@Override
	public boolean saveUnidentifiedCollnsDtls(Map<String, Object> parameters)throws Exception{
		log.info("Saving GIACLossRiCollns...");
		this.getGiacUnidentifiedCollnsDAO().saveUnidentifiedCollnsDtls(parameters);
		log.info("GIACLossRiCollns Saved.");
		return true;
	}
	
	public String validateItemNo(Map<String, Object> parameters) throws SQLException{
		return this.getGiacUnidentifiedCollnsDAO().validateItemNo(parameters);
	}

	public String validateOldTranNo(Map<String, Object> params) throws SQLException {
		return this.getGiacUnidentifiedCollnsDAO().validateOldTranNo(params);
	}

	public String validateOldItemNo(Map<String, Object> params)	throws SQLException {
		return this.getGiacUnidentifiedCollnsDAO().validateOldItemNo(params);
	}
	
	public void validateDelRec(Map<String, Object> params) throws Exception{
		this.giacUnidentifiedCollnsDAO.validateDelRec(params);
	}

}
