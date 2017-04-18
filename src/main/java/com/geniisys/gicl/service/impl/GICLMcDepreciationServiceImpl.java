package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLMcDepreciationDAO;
import com.geniisys.gicl.entity.GICLMcDepreciation;
import com.geniisys.gicl.service.GICLMcDepreciationService;

public class GICLMcDepreciationServiceImpl implements GICLMcDepreciationService{
	
	private GICLMcDepreciationDAO giclMcDepreciationDAO;
	
	/**
	 * @return the giclMcDepreciationDAO
	 */
	public GICLMcDepreciationDAO getGiclMcDepreciationDAO() {
		return giclMcDepreciationDAO;
	}

	/**
	 * @param giclMcDepreciationDAO the giclMcDepreciationDAO to set
	 */
	public void setGiclMcDepreciationDAO(GICLMcDepreciationDAO giclMcDepreciationDAO) {
		this.giclMcDepreciationDAO = giclMcDepreciationDAO;
	}

	@Override
	public JSONObject showGicls059(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls059RecList");
		params.put("sublineCd", request.getParameter("sublineCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void saveGicls059(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLMcDepreciation.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLMcDepreciation.class));
		params.put("appUser", userId);
		this.giclMcDepreciationDAO.saveGicls059(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("specialPartCd", request.getParameter("specialPartCd"));
		params.put("mcYearFr", request.getParameter("mcYearFr"));
		this.giclMcDepreciationDAO.valAddRec(params);
	}
}
