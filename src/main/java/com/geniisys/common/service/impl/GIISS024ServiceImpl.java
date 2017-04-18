package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISS024DAO;
import com.geniisys.common.entity.GIISCity;
import com.geniisys.common.entity.GIISProvince;
import com.geniisys.common.entity.GIISRegion;
import com.geniisys.common.service.GIISS024Service;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISS024ServiceImpl implements GIISS024Service{

	private GIISS024DAO giiss024DAO;

	/**
	 * @return the giiss024DAO
	 */
	public GIISS024DAO getGiiss024DAO() {
		return giiss024DAO;
	}

	/**
	 * @param giiss024DAO the giiss024DAO to set
	 */
	public void setGiiss024DAO(GIISS024DAO giiss024DAO) {
		this.giiss024DAO = giiss024DAO;
	}
	
	@Override
	public JSONObject showGiiss024(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss024RecList");
		params.put("regionCd", request.getParameter("regionCd"));
		params.put("regionDesc", request.getParameter("regionDesc"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("provinceDesc", request.getParameter("provinceDesc"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("city", request.getParameter("city"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public JSONObject showAllGiiss024(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss024AllRec");
		params.put("regionCd", request.getParameter("regionCd"));
		params.put("regionDesc", request.getParameter("regionDesc"));
		params.put("provinceCd", request.getParameter("provinceCd"));
		params.put("provinceDesc", request.getParameter("provinceDesc"));
		params.put("cityCd", request.getParameter("cityCd"));
		params.put("city", request.getParameter("city"));
		params.put("mode", request.getParameter("mode"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recId", request.getParameter("recId"));
		params.put("recId2", request.getParameter("recId2"));
		params.put("mode", request.getParameter("mode"));
		this.giiss024DAO.valDeleteRec(params);
	}

	@Override
	public void saveGiiss024(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setGIISRegion", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISRegion")), userId, GIISRegion.class));
		params.put("delGIISRegion", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISRegion")), userId, GIISRegion.class));
		params.put("setGIISProvince", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISProvince")), userId, GIISProvince.class));
		params.put("delGIISProvince", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISProvince")), userId, GIISProvince.class));
		params.put("setGIISCity", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setGIISCity")), userId, GIISCity.class));
		params.put("delGIISCity", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delGIISCity")), userId, GIISCity.class));
		
		params.put("appUser", userId);
		this.giiss024DAO.saveGiiss024(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("recId", request.getParameter("recId"));
		params.put("recId2", request.getParameter("recId2"));
		params.put("mode", request.getParameter("mode"));
		this.giiss024DAO.valAddRec(params);
	}
}
