package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giex.dao.GIEXItmperilGroupedDAO;
import com.geniisys.giex.entity.GIEXItmperilGrouped; //Added by Jerome Bautista 12.03.2015 SR 21016
import com.geniisys.giex.service.GIEXItmperilGroupedService;

public class GIEXItmperilGroupedServiceImpl implements GIEXItmperilGroupedService{
	
	private GIEXItmperilGroupedDAO giexItmperilGroupedDAO;

	public void setGiexItmperilGroupedDAO(GIEXItmperilGroupedDAO giexItmperilGroupedDAO) {
		this.giexItmperilGroupedDAO = giexItmperilGroupedDAO;
	}

	public GIEXItmperilGroupedDAO getGiexItmperilGroupedDAO() {
		return giexItmperilGroupedDAO;
	}

	@Override
	public Map<String, Object> deletePerilGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilGroupedDAO().deletePerilGrpGIEXS007(params);
	}

	@Override
	public Map<String, Object> createPerilGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilGroupedDAO().createPerilGrpGIEXS007(params);
	}

	@Override
	public void saveGIEXItmperilGrouped(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("addItmperilDtlObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("addItmperilDtlObj")), userId, GIEXItmperilGrouped.class)); //Modified by Jerome Bautista 12.03.2015 SR 21016
		params.put("delItmperilDtlObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItmperilDtlObj")), userId, GIEXItmperilGrouped.class)); //Modified by Jerome Bautista 12.03.2015 SR 21016
		params.put("modItmperilDtlObj", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("modItmperilDtlObj")), userId, GIEXItmperilGrouped.class)); //Added by Jerome Bautista 12.03.2015 SR 21016
		params.put("recomputeTax", request.getParameter("recomputeTax"));
		params.put("taxSw", request.getParameter("taxSw"));
		params.put("policyId", request.getParameter("policyId"));
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo")); //Added by Jerome Bautista 12.03.2015 SR 21016
		this.giexItmperilGroupedDAO.saveGIEXItmperilGrouped(params);
	}

	@Override
	public Map<String, Object> updateWitemGrpGIEXS007(Map<String, Object> params)
			throws SQLException {
		return this.getGiexItmperilGroupedDAO().updateWitemGrpGIEXS007(params);
	}

	@Override
	public void deleteOldPErilGrp(Map<String, Object> params)
			throws SQLException {
		this.getGiexItmperilGroupedDAO().deleteOldPErilGrp(params);
	}

}
