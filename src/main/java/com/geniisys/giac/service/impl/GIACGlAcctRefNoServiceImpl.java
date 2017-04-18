/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACGlAcctRefNoDAO;
import com.geniisys.giac.service.GIACGlAcctRefNoService;
import com.seer.framework.util.StringFormatter;

public class GIACGlAcctRefNoServiceImpl implements GIACGlAcctRefNoService {

	private GIACGlAcctRefNoDAO giacGlAcctRefNoDAO;

	public GIACGlAcctRefNoDAO getGiacGlAcctRefNoDAO() {
		return giacGlAcctRefNoDAO;
	}

	public void setGiacGlAcctRefNoDAO(GIACGlAcctRefNoDAO giacGlAcctRefNoDAO) {
		this.giacGlAcctRefNoDAO = giacGlAcctRefNoDAO;
	}

	@Override
	public JSONObject showGlAcctRefNo(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGlAccountTypes");
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("ledgerDesc", request.getParameter("ledgerDesc"));
		params.put("dspActiveTag", request.getParameter("dspActiveTag"));
		Map<String, Object> giacGlAcctTypes = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacGlAcctTypes);
	}
	
	@Override
	public JSONObject showKnockOffAccount(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getKnockOffAccts");
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("slCd", request.getParameter("slCd"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		params.put("acctRefNo", request.getParameter("acctRefNo"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("tranDesc", request.getParameter("tranDesc"));
		params.put("particulars", request.getParameter("particulars"));
		params.put("refNo", request.getParameter("refNo"));
		params.put("outstandingBal", request.getParameter("outstandingBal"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		
		String addedAcctRefNo = request.getParameter("addedAcctRefNo");
		System.out.println("addedAcctRefNo: "+addedAcctRefNo);
		if (!addedAcctRefNo.equals(null)) {
			Integer length = addedAcctRefNo.length();
			
			if(length <= 4000){
				params.put("addedAcctRefNo1", addedAcctRefNo.substring(0, addedAcctRefNo.length()));
				System.out.println("addedAcctRefNo: "+addedAcctRefNo.substring(0, addedAcctRefNo.length()));
			}else if(length <= 8000){
				params.put("addedAcctRefNo1", addedAcctRefNo.substring(0, 4000));
				params.put("addedAcctRefNo2", addedAcctRefNo.substring(4001,addedAcctRefNo.length()));
				System.out.println("addedAcctRefNo1: "+addedAcctRefNo.substring(0, 4000));
				System.out.println("addedAcctRefNo2: "+addedAcctRefNo.substring(4001,addedAcctRefNo.length()));
			}else if(length <= 12000){
				params.put("addedAcctRefNo1", addedAcctRefNo.substring(0, 4000));
				params.put("addedAcctRefNo2", addedAcctRefNo.substring(4001,8000));
				params.put("addedAcctRefNo3", addedAcctRefNo.substring(8001,addedAcctRefNo.length()));
				System.out.println("addedAcctRefNo1: "+addedAcctRefNo.substring(0, 4000));
				System.out.println("addedAcctRefNo2: "+addedAcctRefNo.substring(4001,8000));
				System.out.println("addedAcctRefNo3: "+addedAcctRefNo.substring(8001,addedAcctRefNo.length()));
			}
		}
		
		Map<String, Object> knockOffAccts = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(knockOffAccts);
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONArray valGlAcctIdGiacs030(HttpServletRequest request) throws SQLException, JSONException {
		Integer glAcctId = request.getParameter("glAcctId").equals(null) || request.getParameter("glAcctId") == "" ? null : Integer.parseInt(request.getParameter("glAcctId"));
		List<Map<String, Object>> list = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(giacGlAcctRefNoDAO.valGlAcctIdGiacs030(glAcctId));
		JSONArray arr = new JSONArray(list);
		return arr;
	}

	@Override
	public String getOutstandingBal(HttpServletRequest request) throws SQLException {
		Map<String, Object>	params = new HashMap<String, Object>();
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("slCd", request.getParameter("slCd"));
		params.put("acctRefNo", request.getParameter("acctRefNo"));
		return giacGlAcctRefNoDAO.getOutstandingBal(params);
	}

	@Override
	public void valAddGlAcctRefNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		params.put("slCd", request.getParameter("slCd"));
		params.put("acctSeqNo", request.getParameter("acctSeqNo"));
		params.put("acctTranType", request.getParameter("acctTranType"));
		this.giacGlAcctRefNoDAO.valAddGlAcctRefNo(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public JSONArray valRemainingBalGiacs30(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("glAcctId", request.getParameter("glAcctId"));
		params.put("slCd", request.getParameter("slCd"));
		params.put("acctTranType", request.getParameter("acctTranType"));
		params.put("acctRefNo", request.getParameter("acctRefNo"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		params.put("acctSeqNo", request.getParameter("acctSeqNo"));
		List<Map<String, Object>> list = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(giacGlAcctRefNoDAO.valRemainingBalGiacs30(params));
		JSONArray arr = new JSONArray(list);
		return arr;
	}
}
