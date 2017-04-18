package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISFireConstructionDAO;
import com.geniisys.common.service.GIISFireConstructionService;
import com.geniisys.fire.entity.GIISFireConstruction;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISFireConstructionServiceImpl implements GIISFireConstructionService{

	private GIISFireConstructionDAO giisFireConstructionDAO;
	
	/**
	 * @return the giisFireConstructionDAO
	 */
	public GIISFireConstructionDAO getGiisFireConstructionDAO() {
		return giisFireConstructionDAO;
	}

	/**
	 * @param giisFireConstructionDAO the giisFireConstructionDAO to set
	 */
	public void setGiisFireConstructionDAO(GIISFireConstructionDAO giisFireConstructionDAO) {
		this.giisFireConstructionDAO = giisFireConstructionDAO;
	}
	
	@Override
	public JSONObject showGiiss098(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss098RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public JSONObject showAllGiiss098(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss098AllRec");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("constructionCd") != null){
			String recId = request.getParameter("constructionCd");
			this.giisFireConstructionDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss098(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISFireConstruction.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISFireConstruction.class));
		params.put("appUser", userId);
		this.giisFireConstructionDAO.saveGiiss098(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("constructionCd") != null){
			String recId = request.getParameter("constructionCd");
			this.giisFireConstructionDAO.valAddRec(recId);
		}
	}
}
