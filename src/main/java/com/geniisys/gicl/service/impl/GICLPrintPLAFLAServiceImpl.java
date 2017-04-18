package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLPrintPLAFLADAO;
import com.geniisys.gicl.entity.GICLAdvsFla;
import com.geniisys.gicl.entity.GICLAdvsPla;
import com.geniisys.gicl.service.GICLPrintPLAFLAService;

public class GICLPrintPLAFLAServiceImpl implements GICLPrintPLAFLAService {
	
	private GICLPrintPLAFLADAO giclPrintPLAFLADAO;
	
	public GICLPrintPLAFLADAO getGiclPrintPLAFLADAO() {
		return giclPrintPLAFLADAO;
	}

	public void setGiclPrintPLAFLADAO(GICLPrintPLAFLADAO giclPrintPLAFLADAO) {
		this.giclPrintPLAFLADAO = giclPrintPLAFLADAO;
	}


	@Override
	public Map<String, Object> queryCountLossAdvice(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("allUserSw", request.getParameter("allUserSw"));
		params.put("validTag", request.getParameter("validTag"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("currentView", request.getParameter("currentView"));
		params.put("userId", userId);
		return this.getGiclPrintPLAFLADAO().queryCountLossAdvice(params);
	}

	@Override
	public String tagPlaAsPrinted(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		String message = "";
		Map<String, Object> allParams = new HashMap<String, Object>();
		
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GICLAdvsPla.class));
		message = this.getGiclPrintPLAFLADAO().tagPlaAsPrinted(allParams);
		
		return message;
	}

	@Override
	public String tagFlaAsPrinted(HttpServletRequest request, String userId) throws SQLException, JSONException, Exception {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		String message = "";
		Map<String, Object> allParams = new HashMap<String, Object>();
		
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GICLAdvsFla.class));
		message = this.getGiclPrintPLAFLADAO().tagFlaAsPrinted(allParams);
		
		return message;
	}

}
