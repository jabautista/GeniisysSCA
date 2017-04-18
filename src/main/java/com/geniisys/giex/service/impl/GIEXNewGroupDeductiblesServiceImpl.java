package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giex.dao.GIEXNewGroupDeductiblesDAO;
import com.geniisys.giex.entity.GIEXNewGroupDeductibles;
import com.geniisys.giex.service.GIEXNewGroupDeductiblesService;

public class GIEXNewGroupDeductiblesServiceImpl implements GIEXNewGroupDeductiblesService{
	
	private GIEXNewGroupDeductiblesDAO giexNewGroupDeductiblesDAO;

	public GIEXNewGroupDeductiblesDAO getGiexNewGroupDeductiblesDAO() {
		return giexNewGroupDeductiblesDAO;
	}

	public void setGiexNewGroupDeductiblesDAO(GIEXNewGroupDeductiblesDAO giexNewGroupDeductiblesDAO) {
		this.giexNewGroupDeductiblesDAO = giexNewGroupDeductiblesDAO;
	}

	@Override
	public void saveGIEXNewGroupDeductibles(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("addNewGroupDedObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("addNewGroupDedObj")), userId, GIEXNewGroupDeductibles.class));
		params.put("delNewGroupDedObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delNewGroupDedObj")), userId, GIEXNewGroupDeductibles.class));
		
		this.giexNewGroupDeductiblesDAO.saveGIEXNewGroupDeductibles(params);
	}

	@Override
	public void deleteModNewGroupDeductibles(Map<String, Object> params)
			throws SQLException {
		this.getGiexNewGroupDeductiblesDAO().deleteModNewGroupDeductibles(params);
	}

	@Override
	public Integer validateIfDeductibleExists(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("dedDeductibleCd", request.getParameter("dedDeductibleCd"));
		
		return this.getGiexNewGroupDeductiblesDAO().validateIfDeductibleExists(params);
	} 

	@Override
	public String countTsiDed (String policyId) throws SQLException {
		return this.getGiexNewGroupDeductiblesDAO().countTsiDed(policyId);
	}

	@Override
	public String getDeductibleCurrency(String policyId) throws SQLException {
		return this.getGiexNewGroupDeductiblesDAO().getDeductibleCurrency(policyId);
	}
}
