package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACAcctEntriesDAO;
import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.entity.GIACGlAcctRefNo;	//Gzelle 11102015 KB#132 AP/AR ENH
import com.geniisys.giac.service.GIACAcctEntriesService;
import com.seer.framework.util.StringFormatter;

import common.Logger;

public class GIACAcctEntriesServiceImpl implements GIACAcctEntriesService{
	
	private GIACAcctEntriesDAO giacAcctEntriesDAO;
	private static Logger log = Logger.getLogger(GIACAcctEntriesServiceImpl.class);
	
	public void setGiacAcctEntriesDAO(GIACAcctEntriesDAO giacAcctEntriesDAO) {
		this.giacAcctEntriesDAO = giacAcctEntriesDAO;
	}

	public GIACAcctEntriesDAO getGiacAcctEntriesDAO() {
		return giacAcctEntriesDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#getAcctEntries(int)
	 */
	@Override
	public List<GIACAcctEntries> getAcctEntries(Map<String, Object> params) throws SQLException {
		return this.giacAcctEntriesDAO.getAcctEntries(params);
	}
	
	/* public List<GIACAcctEntries> getAcctEntries(int gaccTranId) throws SQLException {
		return this.giacAcctEntriesDAO.getAcctEntries(gaccTranId);
	}*/

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#getGlAcctListing(java.lang.String, int, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGlAcctListing(String acctObj, int pageNo, String keyword)
			throws SQLException, JSONException {
		JSONObject gl = new JSONObject(acctObj);
		Map<String, Object> params = this.prepareGLAccountMap(gl);
		//if(acctObj.equals("") || acctObj.equals(null)) {
		//}
		params.put("keyword", keyword);
		System.out.println("getGLAcctListing(service) - "+keyword);
		List<GIACChartOfAccts> list = this.getGiacAcctEntriesDAO().getGlAcctsListing(params);
		PaginatedList pagedList = new PaginatedList(list, ApplicationWideParameters.PAGE_SIZE);
		pagedList.gotoPage(pageNo-1);
		return pagedList;
	}
	
	private Map<String, Object> prepareGLAccountMap(JSONObject gl) throws JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctCategory", gl.isNull("glAcctCategory") ? null : gl.getInt("glAcctCategory"));
		params.put("glControlAcct", gl.isNull("glControlAcct") ? null : gl.getInt("glControlAcct"));
		params.put("glSubAcct1", gl.isNull("glSubAcct1") ? null : gl.getInt("glSubAcct1"));
		params.put("glSubAcct2", gl.isNull("glSubAcct2") ? null : gl.getInt("glSubAcct2"));
		params.put("glSubAcct3", gl.isNull("glSubAcct3") ? null : gl.getInt("glSubAcct3"));
		params.put("glSubAcct4", gl.isNull("glSubAcct4") ? null : gl.getInt("glSubAcct4"));
		params.put("glSubAcct5", gl.isNull("glSubAcct5") ? null : gl.getInt("glSubAcct5"));
		params.put("glSubAcct6", gl.isNull("glSubAcct6") ? null : gl.getInt("glSubAcct6"));
		params.put("glSubAcct7", gl.isNull("glSubAcct7") ? null : gl.getInt("glSubAcct7"));
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#saveGIACAcctEntries(java.lang.String, int, java.lang.String)
	 */
	@Override
	public void saveGIACAcctEntries(String param, int gaccTranId, String userId) throws SQLException,
			JSONException {
		Map<String, Object> acctEntryParams = new HashMap<String, Object>();
		JSONObject objParams = new JSONObject(param);
		acctEntryParams.put("addAcctEntries", this.prepareAcctEntryForInsert(new JSONArray(objParams.getString("addedEntries")), gaccTranId, userId));
		acctEntryParams.put("delAcctEntries", this.prepareAcctEntryForDelete(new JSONArray(objParams.getString("delEntries"))));
		acctEntryParams.put("addGlAcctRefNo", this.prepareGlAcctRefNoForInsert(new JSONArray(objParams.getString("addedEntries"))));	//Gzelle 11102015 KB#132 AP/AR ENH
		acctEntryParams.put("delGlAcctRefNo", this.prepareGlAcctRefNoForDelete(new JSONArray(objParams.getString("delEntries"))));		//Gzelle 12162015 KB#132 AP/AR ENH
		this.getGiacAcctEntriesDAO().saveAcctEntries(acctEntryParams);
	}
	
	/**
	 * 
	 * @param rows
	 * @param tranId
	 * @param userId
	 * @return
	 * @throws JSONException
	 * @throws SQLException
	 */
	public List<GIACAcctEntries> prepareAcctEntryForInsert(JSONArray rows, int tranId, String userId) throws JSONException, SQLException {
		GIACAcctEntries entry = null;
		JSONObject json = null;
		List<GIACAcctEntries> items = new ArrayList<GIACAcctEntries>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			entry = new GIACAcctEntries();
			
			entry.setGaccTranId(json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
			entry.setGaccGfunFundCd(json.isNull("gaccGfunFundCd") ? null : json.getString("gaccGfunFundCd"));
			entry.setGaccGibrBranchCd(json.isNull("gaccGibrBranchCd") ? null : json.getString("gaccGibrBranchCd"));
			entry.setAcctEntryId(json.isNull("acctEntryId") ? null : json.getString("acctEntryId"));
			//entry.setAcctEntryId(json.isNull("acctEntryId") ? null : Integer.toString(lastAcctEntry + i));
			entry.setGlAcctId(json.isNull("glAcctId") ? null : json.getString("glAcctId"));
			entry.setGlAcctCategory(json.isNull("glAcctCategory") ? null : json.getString("glAcctCategory"));
			entry.setGlControlAcct(json.isNull("glControlAcct") ? null : json.getString("glControlAcct"));
			entry.setGlSubAcct1(json.isNull("glSubAcct1") ? null : json.getString("glSubAcct1"));
			entry.setGlSubAcct2(json.isNull("glSubAcct2") ? null : json.getString("glSubAcct2"));
			entry.setGlSubAcct3(json.isNull("glSubAcct3") ? null : json.getString("glSubAcct3"));
			entry.setGlSubAcct4(json.isNull("glSubAcct4") ? null : json.getString("glSubAcct4"));
			entry.setGlSubAcct5(json.isNull("glSubAcct5") ? null : json.getString("glSubAcct5"));
			entry.setGlSubAcct6(json.isNull("glSubAcct6") ? null : json.getString("glSubAcct6"));
			entry.setGlSubAcct7(json.isNull("glSubAcct7") ? null : json.getString("glSubAcct7"));
			entry.setSlCd(json.isNull("slCd") ? null : json.getString("slCd"));
			entry.setDebitAmt(json.isNull("debitAmt") ? null : new BigDecimal(json.getString("debitAmt")));
			entry.setCreditAmt(json.isNull("creditAmt") ? null : new BigDecimal(json.getString("creditAmt")));
			entry.setGenerationType(json.isNull("generationType") ? null : json.getString("generationType"));
			entry.setSlTypeCd(json.isNull("slTypeCd") ? null : json.getString("slTypeCd"));
			entry.setSlSourceCd(json.isNull("slSourceCd") ? null : json.getString("slSourceCd"));
			entry.setRemarks(json.isNull("remarks") ? null : json.getString("remarks"));
			entry.setCpiRecNo(json.isNull("cpiRecNo") ? null : json.getString("cpiRecNo"));
			entry.setCpiBranchCd(json.isNull("cpiBranchCd") ? null : json.getString("cpiBranchCd"));
			entry.setSapText(json.isNull("sapText") ? null : json.getString("sapText"));
			entry.setUserId(userId);
			/*start Gzelle 11102015 KB#132 AP/AR ENH*/
			entry.setAcctRefNo(json.isNull("acctRefNo") ? null : json.getString("acctRefNo"));
			entry.setAcctTranType(json.isNull("acctTranType") ? null : json.getString("acctTranType"));
			/*end Gzelle 11102015 KB#132 AP/AR ENH*/
			items.add(entry);
		}
		return items;
	}
	
	/* start - AP/AR Enhancement - Gzelle 11/10/2015 */
	public List<GIACGlAcctRefNo> prepareGlAcctRefNoForInsert(JSONArray rows) throws JSONException, SQLException {
		GIACGlAcctRefNo acctRefNo = null;
		JSONObject json = null;
		List<GIACGlAcctRefNo> items = new ArrayList<GIACGlAcctRefNo>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			if (json.getString("dspIsExisting").equals("Y") && !json.isNull("ledgerCd")) {
				acctRefNo = new GIACGlAcctRefNo();
				acctRefNo.setGaccTranId(json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
				acctRefNo.setGlAcctId(json.isNull("glAcctId") ? null : json.getInt("glAcctId"));
				acctRefNo.setLedgerCd(json.isNull("ledgerCd") ? null : json.getString("ledgerCd"));
				acctRefNo.setSubLedgerCd(json.isNull("subLedgerCd") ? null : json.getString("subLedgerCd"));
				acctRefNo.setTransactionCd(json.isNull("transactionCd") ? null : json.getString("transactionCd"));
				acctRefNo.setSlCd(json.isNull("slCd") ? null : json.getString("slCd"));
				acctRefNo.setAcctSeqNo(json.isNull("acctSeqNo") ? null : json.getString("acctSeqNo"));
				acctRefNo.setAcctTranType(json.isNull("acctTranType") ? null : json.getString("acctTranType"));
				items.add(acctRefNo);
			}
		}
		return items;
	}

	public List<GIACGlAcctRefNo> prepareGlAcctRefNoForDelete(JSONArray rows) throws JSONException {
		GIACGlAcctRefNo acctRefNo = null;
		JSONObject json = null;
		List<GIACGlAcctRefNo> delItem = new ArrayList<GIACGlAcctRefNo>();
		
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
				acctRefNo = new GIACGlAcctRefNo();
				acctRefNo.setGaccTranId(json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
				acctRefNo.setGlAcctId(json.isNull("glAcctId") ? null : json.getInt("glAcctId"));
				acctRefNo.setLedgerCd(json.isNull("ledgerCd") ? null : json.getString("ledgerCd"));
				acctRefNo.setSubLedgerCd(json.isNull("subLedgerCd") ? null : json.getString("subLedgerCd"));
				acctRefNo.setTransactionCd(json.isNull("transactionCd") ? null : json.getString("transactionCd"));
				acctRefNo.setSlCd(json.isNull("slCd") ? null : json.getString("slCd"));
				acctRefNo.setAcctSeqNo(json.isNull("acctSeqNo") ? null : json.getString("acctSeqNo"));
				acctRefNo.setAcctTranType(json.isNull("acctTranType") ? null : json.getString("acctTranType"));
				delItem.add(acctRefNo);
		}
		return delItem;
	}
	/* end - AP/AR Enhancement - Gzelle 11/10/2015 */
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#deleteGIACAcctEntries(java.lang.String)
	 */
	@Override
	public void deleteGIACAcctEntries(String param) throws SQLException,
			JSONException {
		Map<String, Object> acctEntryParams = new HashMap<String, Object>();
		JSONObject objParams = new JSONObject(param);
		log.info("Deleting GIAC Accounting Entries...");
		acctEntryParams.put("delAcctEntries", this.prepareAcctEntryForDelete(new JSONArray(objParams.getString("delEntries"))));
		this.getGiacAcctEntriesDAO().delAcctEntries(acctEntryParams);
		log.info("GIAC Accounting Entries Deleted...");
	}
	
	/**
	 * 
	 * @param rows
	 * @return
	 * @throws JSONException
	 */
	public List<Map<String, Object>> prepareAcctEntryForDelete(JSONArray rows) throws JSONException {
		List<Map<String, Object>> delItems = new ArrayList<Map<String,Object>>();
		Map<String, Object> delItem = null;
		JSONObject json = null;
		for(int i=0; i<rows.length(); i++) {
			json = rows.getJSONObject(i);
			int tranId = json.isNull("gaccTranId") ? 0 : json.getInt("gaccTranId");
			//if(tranId > 0 && tranId < 1000000) { //marco - 10.13.2014 - @FGIC - comment out
				delItem = new HashMap<String, Object>();
				delItem.put("gaccTranId", json.isNull("gaccTranId") ? null : json.getInt("gaccTranId"));
				delItem.put("acctEntryId", json.isNull("acctEntryId") ? null : json.getString("acctEntryId"));
				
				delItems.add(delItem);
			//}
		}
		return delItems;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#closeTransaction(java.util.Map)
	 */
	@Override
	public Map<String, Object> closeTransaction(Map<String, Object> params) throws SQLException {
		params = this.getGiacAcctEntriesDAO().closeTransaction(params);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACAcctEntriesService#checkManualAcctEntry(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkManualAcctEntry(Map<String, Object> params)  throws SQLException{
		params = this.getGiacAcctEntriesDAO().checkManualAcctEntry(params);
		return params;
	}

	@Override
	public Map<String, Object> getGIACS086AcctEntriesTableGrid(
			HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS086AcctEntriesTableGrid");
		params.put("userId", userId);
		params.put("tranId", request.getParameter("tranId"));
		params.put("pageSize", 5);
		System.out.println("tranId: "+request.getParameter("tranId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("acctEntriesTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public GIACChartOfAccts retrieveGLAccount(
			String strParam) throws SQLException, JSONException {
		JSONObject gl = new JSONObject(strParam);
		Map<String, Object> params = this.prepareGLAccountMap(gl);
		List<GIACChartOfAccts> coaList = this.getGiacAcctEntriesDAO().getGlAcctsListing(params);
		GIACChartOfAccts coa = coaList.size() > 0 ? (GIACChartOfAccts) StringFormatter.escapeHTMLInObject(coaList.get(0)) : null;
		//GIACChartOfAccts coa = (GIACChartOfAccts) StringFormatter.escapeHTMLInObject(coaList.get(0));
		return coa;
	}

	@Override
	public String checkGIACS060GLTrans(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("category", request.getParameter("category"));
		params.put("control", request.getParameter("control"));
		params.put("tranClass", request.getParameter("tranClass"));
		params.put("tranPost", request.getParameter("tranPost"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("sub1", request.getParameter("sub1"));
		params.put("sub2", request.getParameter("sub2"));
		params.put("sub3", request.getParameter("sub3"));
		params.put("sub4", request.getParameter("sub4"));
		params.put("sub5", request.getParameter("sub5"));
		params.put("sub6", request.getParameter("sub6"));
		params.put("sub7", request.getParameter("sub7"));
		params.put("slCd", request.getParameter("slCd"));
		
		if(!request.getParameter("branchAll").equals("Y"))
			params.put("branchCd", request.getParameter("branchCd"));
		
		//added by john 10.16.2014
		if(request.getParameter("includeSubAccts").equals("Y")){
			if((request.getParameter("control")).equals("00")){
				params.put("control", null);
			}
			if((request.getParameter("sub1")).equals("00")){
				params.put("sub1", null);
			}
			if((request.getParameter("sub2")).equals("00")){
				params.put("sub2", null);
			}
			if((request.getParameter("sub3")).equals("00")){
				params.put("sub3", null);
			}
			if((request.getParameter("sub4")).equals("00")){
				params.put("sub4", null);
			}
			if((request.getParameter("sub5")).equals("00")){
				params.put("sub5", null);
			}
			if((request.getParameter("sub6")).equals("00")){
				params.put("sub6", null);
			}
			if((request.getParameter("sub7")).equals("00")){
				params.put("sub7", null);
			}
		}
		
		return giacAcctEntriesDAO.checkGIACS060GLTrans(params);
	}
}