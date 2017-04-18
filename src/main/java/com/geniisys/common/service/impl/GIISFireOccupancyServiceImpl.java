package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISFireOccupancyDAO;
import com.geniisys.common.service.GIISFireOccupancyService;
import com.geniisys.fire.entity.GIISFireOccupancy;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISFireOccupancyServiceImpl implements GIISFireOccupancyService{
	
	private GIISFireOccupancyDAO giisFireOccupancyDAO;
	
	@Override
	public JSONObject showGiiss097(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss097RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("occupancyCd") != null){
			String recId = request.getParameter("occupancyCd");
			this.giisFireOccupancyDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss097(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISFireOccupancy.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISFireOccupancy.class));
		params.put("appUser", userId);
		this.giisFireOccupancyDAO.saveGiiss097(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("occupancyCd", request.getParameter("occupancyCd"));
		params.put("occupancyDesc", request.getParameter("occupancyDesc"));	
		this.giisFireOccupancyDAO.valAddRec(params);
	}
	
	@Override
	public JSONObject showAllGiiss097(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss097AllRec");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	public GIISFireOccupancyDAO getGiisFireOccupancyDAO() {
		return giisFireOccupancyDAO;
	}

	public void setGiisFireOccupancyDAO(GIISFireOccupancyDAO giisFireOccupancyDAO) {
		this.giisFireOccupancyDAO = giisFireOccupancyDAO;
	}
}
