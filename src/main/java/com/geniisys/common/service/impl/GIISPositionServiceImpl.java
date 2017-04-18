package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPositionDAO;
import com.geniisys.common.entity.GIISPosition;
import com.geniisys.common.service.GIISPositionService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISPositionServiceImpl implements GIISPositionService {
	
	private GIISPositionDAO giisPositionDAO;

	@Override
	public JSONObject showGiiss023(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss023RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public String valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("positionCd") != null){
			String positionCd = request.getParameter("positionCd");
			return this.giisPositionDAO.valDeleteRec(positionCd);
		} else {
			return null;
		}
		
	}

	@Override
	public void saveGiiss023(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPosition.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPosition.class));
		params.put("appUser", userId);
		this.giisPositionDAO.saveGiiss023(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("positionCd", request.getParameter("positionCd"));
		params.put("position", request.getParameter("position"));
		this.giisPositionDAO.valAddRec(params);
	}
	
	public JSONObject showGiiss023AllRec(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss023AllRecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	public GIISPositionDAO getGiisPositionDAO() {
		return giisPositionDAO;
	}

	public void setGiisPositionDAO(GIISPositionDAO giisPositionDAO) {
		this.giisPositionDAO = giisPositionDAO;
	}
}
