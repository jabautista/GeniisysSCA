package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISEQZoneDAO;
import com.geniisys.common.entity.GIISEQZone;
import com.geniisys.common.service.GIISEQZoneService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISEQZoneServiceImpl implements GIISEQZoneService{
	
	private GIISEQZoneDAO giisEQZoneDAO;
	
	@Override
	public JSONObject showGiiss011(HttpServletRequest request, String userId)	
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss011RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("eqZone") != null){
			String recId = request.getParameter("eqZone");
			this.giisEQZoneDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss011(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEQZone.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEQZone.class));
		params.put("appUser", userId);
		this.giisEQZoneDAO.saveGiiss011(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("eqZone", request.getParameter("eqZone"));
		params.put("eqDesc", request.getParameter("eqDesc"));	
		this.giisEQZoneDAO.valAddRec(params);		
	}
	
	@Override
	public JSONObject showAllGiiss011(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss011AllRec");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	public GIISEQZoneDAO getGiisEQZoneDAO() {
		return giisEQZoneDAO;
	}

	public void setGiisEQZoneDAO(GIISEQZoneDAO giisEQZoneDAO) {
		this.giisEQZoneDAO = giisEQZoneDAO;
	}
}
