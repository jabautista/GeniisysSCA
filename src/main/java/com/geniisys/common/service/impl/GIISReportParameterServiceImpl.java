package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISReportParameterDAO;
import com.geniisys.common.entity.GIISReportParameter;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportParameterService;
import com.geniisys.framework.util.JSONUtil;

public class GIISReportParameterServiceImpl implements GIISReportParameterService{
	
	private GIISReportParameterDAO	giisReportParameterDAO;

	public GIISReportParameterDAO getGiisReportParameterDAO() {
		return giisReportParameterDAO;
	}

	/**
	 * Sets the giisObligeeDAO
	 * @param giisObligeeDAO
	 */
	public void setGiisReportParameterDAO(GIISReportParameterDAO giisReportParameterDAO) {
		this.giisReportParameterDAO = giisReportParameterDAO;
	}	

	@Override
	public Map<String, Object> saveReportParameter(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		System.out.println(objParameters.getString("setRows"));
		System.out.println("fons"+objParameters.getString("delRows"));
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISReportParameter.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISReportParameter.class));
		return this.giisReportParameterDAO.saveReportParameter(params);
	}
}
