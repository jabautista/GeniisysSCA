package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.dao.GIACOthFundOffCollnsDAO;
import com.geniisys.giac.entity.GIACOthFundOffCollns;
import com.geniisys.giac.service.GIACOthFundOffCollnsService;
import com.seer.framework.util.Debug;

public class GIACOthFundOffCollnsServiceImpl implements GIACOthFundOffCollnsService {
	
	private GIACOthFundOffCollnsDAO giacOthFundOffCollnsDAO;
	
	public void setGiacOthFundOffCollnsDAO(GIACOthFundOffCollnsDAO giacOthFundOffCollnsDAO) {
		this.giacOthFundOffCollnsDAO = giacOthFundOffCollnsDAO;
	}


	public GIACOthFundOffCollnsDAO getGiacOthFundOffCollnsDAO() {
		return giacOthFundOffCollnsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#getGIACOthFundOffCollns(java.lang.Integer)
	 */
	@Override
	public List<com.geniisys.giac.entity.GIACOthFundOffCollns> getGIACOthFundOffCollns(
			Integer gaccTranId) throws SQLException {
		return this.giacOthFundOffCollnsDAO.getGIACOthFundOffCollns(gaccTranId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#getTransactionNoListing(java.lang.String, java.lang.Integer)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getTransactionNoListing(String keyword, Integer pageNo)
			throws SQLException {
		List<Map<String, Object>> transNoList = this.getGiacOthFundOffCollnsDAO().getTransactionNoListing(keyword);
		PaginatedList paginatedList = new PaginatedList(transNoList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo - 1);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#checkOldItemNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkOldItemNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOthFundOffCollnsDAO().checkOldItem(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#getDefaultAmount(java.util.Map)
	 */
	@Override
	public Map<String, Object> getDefaultAmount(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOthFundOffCollnsDAO().getDefaultAmount(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#chkGiacOthFundOffCol(java.util.Map)
	 */
	@Override
	public Map<String, Object> chkGiacOthFundOffCol(Map<String, Object> params)
			throws SQLException {
		return this.getGiacOthFundOffCollnsDAO().chkGiacOthFundOffCol(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACOthFundOffCollnsService#saveGIACOthFundOffCollns(org.json.JSONArray, org.json.JSONArray, java.util.Map)
	 */
	@Override
	public String saveGIACOthFundOffCollns(JSONArray setRows,
			JSONArray delRows, Map<String, Object> params) throws SQLException,
			JSONException {
		
		List<GIACOthFundOffCollns> setGOFC = this.prepareGIACOthFundOffCollnsForInsert(setRows);
		List<GIACOthFundOffCollns> delGOFC = this.prepareGIACOthFundOffCollnsForDelete(delRows);
		
		return this.getGiacOthFundOffCollnsDAO().saveGIACOthFundOffCollns(setGOFC, delGOFC, params);
	}
	
	/**
	 * 
	 * @param setRows
	 * @return
	 * @throws JSONException
	 */
	private List<GIACOthFundOffCollns> prepareGIACOthFundOffCollnsForInsert (JSONArray setRows) throws
															JSONException{
		
		List<GIACOthFundOffCollns> othFundOffCollnsList = new ArrayList<GIACOthFundOffCollns>();
		GIACOthFundOffCollns othFundOffCollns;
		
		for(int index=0; index<setRows.length(); index++){
			othFundOffCollns = new GIACOthFundOffCollns();
			
			othFundOffCollns.setGaccTranId(setRows.getJSONObject(index).isNull("gaccTranId") ? null : setRows.getJSONObject(index).getInt("gaccTranId"));
			othFundOffCollns.setGibrGfunFundCd(setRows.getJSONObject(index).isNull("gibrGfunFundCd") ? null : setRows.getJSONObject(index).getString("gibrGfunFundCd"));
			othFundOffCollns.setGibrBranchCd(setRows.getJSONObject(index).isNull("gibrBranchCd")? null : setRows.getJSONObject(index).getString("gibrBranchCd"));
			othFundOffCollns.setItemNo(setRows.getJSONObject(index).isNull("itemNo")? null : Integer.parseInt(setRows.getJSONObject(index).getString("itemNo")));
			othFundOffCollns.setTransactionType(setRows.getJSONObject(index).isNull("transactionType")? null : setRows.getJSONObject(index).getInt("transactionType"));
			othFundOffCollns.setCollectionAmt(setRows.getJSONObject(index).isNull("collectionAmt")? null : 
											(setRows.getJSONObject(index).getString("collectionAmt").isEmpty()? null : new BigDecimal(setRows.getJSONObject(index).getString("collectionAmt")) ));
			othFundOffCollns.setGofcGaccTranId(setRows.getJSONObject(index).isNull("gofcGaccTranId")? null : setRows.getJSONObject(index).getInt("gofcGaccTranId"));
			othFundOffCollns.setGofcGibrGfunFundCd(setRows.getJSONObject(index).isNull("gofcGibrGfunFundCd")? null : setRows.getJSONObject(index).getString("gofcGibrGfunFundCd"));
			othFundOffCollns.setGofcGibrBranchCd(setRows.getJSONObject(index).isNull("gofcGibrBranchCd")? null : setRows.getJSONObject(index).getString("gofcGibrBranchCd"));
			othFundOffCollns.setGofcItemNo(setRows.getJSONObject(index).isNull("gofcItemNo")? null : (setRows.getJSONObject(index).getString("gofcItemNo").isEmpty()? null :Integer.parseInt(setRows.getJSONObject(index).getString("gofcItemNo"))));
			othFundOffCollns.setOrPrintTag(setRows.getJSONObject(index).isNull("orPrintTag")? null : setRows.getJSONObject(index).getString("orPrintTag"));
			othFundOffCollns.setParticulars(setRows.getJSONObject(index).isNull("particulars")? null : setRows.getJSONObject(index).getString("particulars"));
			
			othFundOffCollnsList.add(othFundOffCollns);
		}
		Debug.print("Insert: " + othFundOffCollnsList);
		return othFundOffCollnsList;
	}
	
	/**
	 * 
	 * @param delRows
	 * @return
	 * @throws JSONException
	 */
	private List<GIACOthFundOffCollns> prepareGIACOthFundOffCollnsForDelete (JSONArray delRows) throws
	JSONException{
		
		List<GIACOthFundOffCollns> othFundOffCollnsList = new ArrayList<GIACOthFundOffCollns>();
		GIACOthFundOffCollns othFundOffCollns;
		
		for(int index=0; index<delRows.length(); index++){
			othFundOffCollns = new GIACOthFundOffCollns();
			
			othFundOffCollns.setGaccTranId(delRows.getJSONObject(index).isNull("gaccTranId") ? null : delRows.getJSONObject(index).getInt("gaccTranId"));
			othFundOffCollns.setGibrGfunFundCd(delRows.getJSONObject(index).isNull("gibrGfunFundCd") ? null : delRows.getJSONObject(index).getString("gibrGfunFundCd"));
			othFundOffCollns.setGibrBranchCd(delRows.getJSONObject(index).isNull("gibrBranchCd")? null : delRows.getJSONObject(index).getString("gibrBranchCd"));
			othFundOffCollns.setItemNo(delRows.getJSONObject(index).isNull("itemNo")? null : Integer.parseInt(delRows.getJSONObject(index).getString("itemNo")));
			
			othFundOffCollnsList.add(othFundOffCollns);
		}
		Debug.print("Delete: " + othFundOffCollnsList);
		return othFundOffCollnsList;
		
	}


	@Override
	public List<Integer> getItemNoList(int tranId) throws SQLException {
		return this.giacOthFundOffCollnsDAO.getItemNoList(tranId);
	}

}
