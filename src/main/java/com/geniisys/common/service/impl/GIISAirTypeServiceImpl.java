package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISAirTypeDAO;
import com.geniisys.common.entity.GIISAirType;
import com.geniisys.common.service.GIISAirTypeService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISAirTypeServiceImpl implements GIISAirTypeService {
	
	private GIISAirTypeDAO giisAirTypeDAO;

	@Override
	public JSONObject showGiiss048(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss048RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("airTypeCd") != null){
			String airTypeCd = request.getParameter("airTypeCd");
			return this.giisAirTypeDAO.valDeleteRec(airTypeCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiiss048(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISAirType.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISAirType.class));
		params.put("appUser", userId);
		this.giisAirTypeDAO.saveGiiss048(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("airTypeCd") != null){
			String recId = request.getParameter("airTypeCd");
			this.giisAirTypeDAO.valAddRec(recId);
		}
	}

	public GIISAirTypeDAO getGiisAirTypeDAO() {
		return giisAirTypeDAO;
	}

	public void setGiisAirTypeDAO(GIISAirTypeDAO giisAirTypeDAO) {
		this.giisAirTypeDAO = giisAirTypeDAO;
	}
}
