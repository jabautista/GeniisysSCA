package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPackageBenefitDAO;
import com.geniisys.common.entity.GIISPackageBenefit;
import com.geniisys.common.entity.GIISPackageBenefitDtl;
import com.geniisys.common.service.GIISPackageBenefitService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISPackageBenefitServiceImpl implements GIISPackageBenefitService{
	
	private GIISPackageBenefitDAO giisPackageBenefitDAO;
	
	/**
	 * @return the giisPackageBenefitDAO
	 */
	public GIISPackageBenefitDAO getGiisPackageBenefitDAO() {
		return giisPackageBenefitDAO;
	}

	/**
	 * @param giisPackageBenefitDAO the giisPackageBenefitDAO to set
	 */
	public void setGiisPackageBenefitDAO(GIISPackageBenefitDAO giisPackageBenefitDAO) {
		this.giisPackageBenefitDAO = giisPackageBenefitDAO;
	}
	
	@Override
	public JSONObject showGiiss120(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss120RecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("packageCd", request.getParameter("packageCd"));
		params.put("packBenCd", request.getParameter("packBenCd"));
		params.put("perilName", request.getParameter("perilName"));
		params.put("premPct", request.getParameter("premPct"));
		params.put("premAmt", request.getParameter("premAmt"));
		params.put("noOfDays", request.getParameter("noOfDays"));
		params.put("benefit", request.getParameter("benefit"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public void saveGiiss120(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGIISPackageBenefit", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISPackageBenefit")), userId, GIISPackageBenefit.class));
		params.put("delGIISPackageBenefit", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISPackageBenefit")), userId, GIISPackageBenefit.class));
		params.put("setGIISPackageBenefitDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISPackageBenefitDtl")), userId, GIISPackageBenefitDtl.class));
		params.put("delGIISPackageBenefitDtl", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISPackageBenefitDtl")), userId, GIISPackageBenefitDtl.class));

		params.put("appUser", userId);
		this.giisPackageBenefitDAO.saveGiiss120(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("recId", request.getParameter("recId"));
		params.put("recId2", request.getParameter("recId2"));
		params.put("mode", request.getParameter("mode"));
		this.giisPackageBenefitDAO.valAddRec(params);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recId", request.getParameter("recId"));
		params.put("mode", request.getParameter("mode"));
		this.giisPackageBenefitDAO.valDeleteRec(params);
	}

	@Override
	public JSONObject showAllGiiss120(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss120AllRecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
}
