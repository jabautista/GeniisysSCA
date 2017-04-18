package com.geniisys.gicl.service.impl;

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
import com.geniisys.gicl.dao.GICLDrvrOccptnDAO;
import com.geniisys.gicl.dao.GICLReasonsDAO;
import com.geniisys.gicl.entity.GICLDrvrOccptn;
import com.geniisys.gicl.entity.GICLReasons;
import com.geniisys.gicl.service.GICLDrvrOccptnService;

public class GICLDrvrOccptnServiceImpl implements GICLDrvrOccptnService{
	private GICLDrvrOccptnDAO giclDrvrOccptnDAO;
	
	/**
	 * @return the giclDrvrOccptnDAO
	 */
	public GICLDrvrOccptnDAO getGiclDrvrOccptnDAO() {
		return giclDrvrOccptnDAO;
	}

	/**
	 * @param giclDrvrOccptnDAO the giclDrvrOccptnDAO to set
	 */
	public void setGiclDrvrOccptnDAO(GICLDrvrOccptnDAO giclDrvrOccptnDAO) {
		this.giclDrvrOccptnDAO = giclDrvrOccptnDAO;
	}
	
	@Override
	public JSONObject showDrvrOccptnMaintenance(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showDrvrOccptnMaintenance");	
		return this.giclDrvrOccptnDAO.showDrvrOccptnMaintenance(request, params); 
	}

	@Override
	public Map<String, Object> validateDrvrOccptnInput(
			HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("inputString", request.getParameter("inputString"));	
		return this.giclDrvrOccptnDAO.validateDrvrOccptnInput(params);
	}

	@Override
	public Map<String, Object> saveDrvrOccptnMaintenance(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GICLDrvrOccptn.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GICLDrvrOccptn.class));
		return this.giclDrvrOccptnDAO.saveDrvrOccptnMaintenance(params);
	}
}
