package com.geniisys.giac.service.impl;

/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACGlAccountTypesDAO;
import com.geniisys.giac.entity.GIACGlAccountTypes;
import com.geniisys.giac.service.GIACGlAccountTypesService;

public class GIACGlAccountTypesServiceImpl implements GIACGlAccountTypesService {

	private GIACGlAccountTypesDAO giacGlAccountTypesDAO;

	public GIACGlAccountTypesDAO getGiacGlAccountTypesDAO() {
		return giacGlAccountTypesDAO;
	}

	public void setGiacGlAccountTypesDAO(GIACGlAccountTypesDAO giacGlAccountTypesDAO) {
		this.giacGlAccountTypesDAO = giacGlAccountTypesDAO;
	}

	@Override
	public JSONObject showGiacs340(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGlAccountTypes");
		params.put("ledgerCd", request.getParameter("ledgerCd"));
		params.put("ledgerDesc", request.getParameter("ledgerDesc"));
		params.put("dspActiveTag", request.getParameter("dspActiveTag"));
		Map<String, Object> giacGlAcctTypes = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(giacGlAcctTypes);
	}

	@Override
	public void valDelGlAcctType(HttpServletRequest request) throws SQLException {
		if(request.getParameter("ledgerCd") != null){
			this.giacGlAccountTypesDAO.valDelGlAcctType(request.getParameter("ledgerCd"));
		}
	}

	@Override
	public void valAddGlAcctType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("origLedgerCd", request.getParameter("origLedgerCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		this.giacGlAccountTypesDAO.valAddGlAcctType(params);
	}

	@Override
	public void valUpdGlAcctType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("currLedgerCd", request.getParameter("currLedgerCd"));
		this.giacGlAccountTypesDAO.valUpdGlAcctType(params);
	}
	
	@Override
	public void saveGiacs340(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACGlAccountTypes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACGlAccountTypes.class));
		params.put("origLedgerCd", request.getParameter("origLedgerCd"));
		params.put("btnVal", request.getParameter("btnVal"));
		params.put("appUser", userId);		
		this.giacGlAccountTypesDAO.saveGiacs340(params);
	}

}
