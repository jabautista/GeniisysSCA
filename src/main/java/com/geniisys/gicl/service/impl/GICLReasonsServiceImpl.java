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
import com.geniisys.gicl.service.GICLReasonsService;
import com.geniisys.gicl.dao.GICLReasonsDAO;
import com.geniisys.gicl.entity.GICLReasons;

public class GICLReasonsServiceImpl implements GICLReasonsService{
	private GICLReasonsDAO giclReasonsDAO;
	
	/**
	 * @return the giclReasonsDAO
	 */
	public GICLReasonsDAO getGiclReasonsDAO() {
		return giclReasonsDAO;
	}

	/**
	 * @param giclReasonsDAO the giclReasonsDAO to set
	 */
	public void setGiclReasonsDAO(GICLReasonsDAO giclReasonsDAO) {
		this.giclReasonsDAO = giclReasonsDAO;
	}
	
	@Override
	public JSONObject showClmStatReasonsMaintenance(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "showClmStatReasonsMaintenance");	
		return this.giclReasonsDAO.showClmStatReasonsMaintenance(request, params); 
	}

	@Override
	public Map<String, Object> validateReasonsInput(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("txtField", request.getParameter("txtField"));	
		params.put("inputString", request.getParameter("inputString"));
		params.put("reasonCd", request.getParameter("reasonCd"));
		params.put("clmStatCd", request.getParameter("clmStatCd"));
		return this.giclReasonsDAO.validateReasonsInput(params);
	}

	@Override
	public Map<String, Object> saveClmStatReasonsMaintenance(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GICLReasons.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GICLReasons.class));
		return this.giclReasonsDAO.saveClmStatReasonsMaintenance(params);
	}

}
