package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giex.dao.GIEXItmperilDAO;
import com.geniisys.giex.entity.GIEXItmperil;
import com.geniisys.giex.service.GIEXItmperilService;

public class GIEXItmperilServiceImpl implements GIEXItmperilService{
	
	private GIEXItmperilDAO giexItmperilDAO;

	/**
	 * @param giexItmperilDAO the giexItmperilDAO to set
	 */
	public void setGiexItmperilDAO(GIEXItmperilDAO giexItmperilDAO) {
		this.giexItmperilDAO = giexItmperilDAO;
	}

	/**
	 * @return the giexItmperilDAO
	 */
	public GIEXItmperilDAO getGiexItmperilDAO() {
		return giexItmperilDAO;
	}
	
	@Override
	public void deleteItmperilByPolId(Integer policyId) throws SQLException {
		this.getGiexItmperilDAO().deleteItmperilByPolId(policyId);
	}

	@Override
	public Map<String, Object> deletePerilGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilDAO().deletePerilGIEXS007(params);
	}

	@Override
	public Map<String, Object> createPerilGIEXS007(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getGiexItmperilDAO().createPerilGIEXS007(params);
	}

	@Override
	public void saveGIEXItmperil(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("addItmperilDtlObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("addItmperilDtlObj")), userId, GIEXItmperil.class));
		params.put("delItmperilDtlObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItmperilDtlObj")), userId, GIEXItmperil.class));
		params.put("recomputeTax", request.getParameter("recomputeTax"));
		params.put("taxSw", request.getParameter("taxSw"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("summarySw", request.getParameter("summarySw")); //joanne 07.01.14
		
		this.giexItmperilDAO.saveGIEXItmperil(params);
		
	}

	@Override
	public Map<String, Object> computeTsiGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilDAO().computeTsiGIEXS007(params);
	}
	
	@Override
	public Map<String, Object> computePremiumGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilDAO().computePremiumGIEXS007(params);
	}
	
	@Override
	public Map<String, Object> updateWitemGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilDAO().updateWitemGIEXS007(params);
	}

	@Override
	public void deleteOldPEril(Map<String, Object> params) throws SQLException {
		this.getGiexItmperilDAO().deleteOldPEril(params);
	}

	@Override
	public String computeDeductibleAmt(HttpServletRequest request, GIISUser USER)
			throws SQLException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("dedRt", request.getParameter("dedRt"));
		params.put("dedPolicyId", request.getParameter("dedPolicyId"));
		params.put("dedDeductibleCd", request.getParameter("dedDeductibleCd")); //joanne 06.06.14
		return this.giexItmperilDAO.computeDeductibleAmt(params);
	}
	
	@Override
	public Map<String, Object> validateItemperil(Map<String, Object> params) //joanne 12-02-13
			throws SQLException {
		return this.getGiexItmperilDAO().validateItemperil(params);
	}

	@Override
	public Map<String, Object> deleteItemperil(Map<String, Object> params) //joanne 12-05-13
			throws SQLException {
		return this.getGiexItmperilDAO().deleteItemperil(params);
	}


}
