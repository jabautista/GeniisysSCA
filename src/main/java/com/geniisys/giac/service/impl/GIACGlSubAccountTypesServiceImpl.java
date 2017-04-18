package com.geniisys.giac.service.impl;

/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACGlSubAccountTypesDAO;
import com.geniisys.giac.entity.GIACGlSubAccountTypes;
import com.geniisys.giac.entity.GIACGlTransactionTypes;
import com.geniisys.giac.service.GIACGlSubAccountTypesService;
import com.seer.framework.util.StringFormatter;

public class GIACGlSubAccountTypesServiceImpl implements GIACGlSubAccountTypesService {

	private GIACGlSubAccountTypesDAO giacGlSubAccountTypesDAO;

	public GIACGlSubAccountTypesDAO getGiacGlAccountTypesDAO() {
		return giacGlSubAccountTypesDAO;
	}

	public void setGiacGlSubAccountTypesDAO(GIACGlSubAccountTypesDAO giacGlSubAccountTypesDAO) {
		this.giacGlSubAccountTypesDAO = giacGlSubAccountTypesDAO;
	}

	@Override
	public JSONObject showGiacs341(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGlSubAccountTypes");
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("subLedgerDesc", request.getParameter("subLedgerDesc"));
		params.put("glAcctCategory", request.getParameter("glAcctCategory"));
		params.put("glControlAcct", request.getParameter("glControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		params.put("glAcctName", request.getParameter("glAcctName"));
		Map<String, Object> giacGlSubAcctTypes = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacGlSubAcctTypes);
	}

	@Override
	public void valDelGlSubAcctType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		this.giacGlSubAccountTypesDAO.valDelGlSubAcctType(params);
	}

	@Override
	public void valAddGlSubAcctType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		this.giacGlSubAccountTypesDAO.valAddGlSubAcctType(params);
	}
	
	@Override
	public void valUpdGlSubAcctType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("newSubLedgerCd", request.getParameter("newSubLedgerCd"));
		this.giacGlSubAccountTypesDAO.valUpdGlSubAcctType(params);
	}

	@SuppressWarnings("unchecked")
	public JSONArray getAllGlAcctIdGiacs341(HttpServletRequest request) throws SQLException, JSONException {		
		List<Map<String, Object>> list = (List<Map<String, Object>>) StringFormatter.escapeHTMLInList(giacGlSubAccountTypesDAO.getAllGlAcctIdGiacs341());
		JSONArray arr = new JSONArray(list);
		return arr;
	}
	
	@Override
	public void saveGiacs341(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACGlSubAccountTypes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACGlSubAccountTypes.class));
		params.put("origSubLedgerCd", request.getParameter("origSubLedgerCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		params.put("appUser", userId);		
		this.giacGlSubAccountTypesDAO.saveGiacs341(params);
	}
	
	/*giac_gl_transction_types*/
	@Override
	public JSONObject showTransactionTypes(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGlTransactionTypes");
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		params.put("transactionDesc", request.getParameter("transactionDesc"));
		params.put("dspActiveTag", request.getParameter("dspActiveTag"));
		Map<String, Object> giacTransactionTypes = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacTransactionTypes);
	}

	@Override
	public void valDelGlTransactionType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		this.giacGlSubAccountTypesDAO.valDelGlTransactionType(params);
		
	}

	@Override
	public void valAddGlTransactionType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("transactionCd", request.getParameter("transactionCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		this.giacGlSubAccountTypesDAO.valAddGlTransactionType(params);
		
	}

	@Override
	public void valUpdGlTransactionType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("subLedgerCd", request.getParameter("subLedgerCd"));
		params.put("newTransactionCd", request.getParameter("newTransactionCd"));
		this.giacGlSubAccountTypesDAO.valUpdGlTransactionType(params);
		
	}

	@Override
	public void saveGlTransactionType(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACGlTransactionTypes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACGlTransactionTypes.class));
		params.put("origTransactionCd", request.getParameter("origTransactionCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		params.put("appUser", userId);		
		this.giacGlSubAccountTypesDAO.saveGlTransactionType(params);
	}
}
