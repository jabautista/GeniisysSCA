package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giex.dao.GIEXNewGroupTaxDAO;
import com.geniisys.giex.entity.GIEXNewGroupTax;
import com.geniisys.giex.service.GIEXNewGroupTaxService;

public class GIEXNewGroupTaxServiceImpl implements GIEXNewGroupTaxService{
	
	private GIEXNewGroupTaxDAO giexNewGroupTaxDAO;

	/**
	 * @return the giexNewGroupTaxDAO
	 */
	public GIEXNewGroupTaxDAO getGiexNewGroupTaxDAO() {
		return giexNewGroupTaxDAO;
	}

	/**
	 * @param giexNewGroupTaxDAO the giexNewGroupTaxDAO to set
	 */
	public void setGiexNewGroupTaxDAO(GIEXNewGroupTaxDAO giexNewGroupTaxDAO) {
		this.giexNewGroupTaxDAO = giexNewGroupTaxDAO;
	}

	@Override
	public void saveGIEXNewGroupTax(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("addNewGroupTaxObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("addNewGroupTaxObj")), userId, GIEXNewGroupTax.class));
		params.put("delNewGroupTaxObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delNewGroupTaxObj")), userId, GIEXNewGroupTax.class));
		
		this.giexNewGroupTaxDAO.saveGIEXNewGroupTax(params);
		
	}

	@Override
	public void deleteModNewGroupTax(Map<String, Object> params)
			throws SQLException {
		this.getGiexNewGroupTaxDAO().deleteModNewGroupTax(params);
	}
	
	@Override
	public String computeNewTaxAmt(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", request.getParameter("policyId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("taxCd", request.getParameter("taxCd"));		
		params.put("taxId", request.getParameter("taxId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.getGiexNewGroupTaxDAO().computeNewTaxAmt(params);
	}

}
