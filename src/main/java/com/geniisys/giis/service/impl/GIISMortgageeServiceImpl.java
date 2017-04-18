package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISMortgageeDAO;
import com.geniisys.giis.entity.GIISMortgagee;
import com.geniisys.giis.service.GIISMortgageeService;
import com.seer.framework.util.StringFormatter;

public class GIISMortgageeServiceImpl implements GIISMortgageeService {
	
	private GIISMortgageeDAO giisMortgageeDAO;
	
	public GIISMortgageeDAO getGiisMortgageeDAO(){
		return giisMortgageeDAO;
	}
	
	public void setGiisMortgageeDAO(GIISMortgageeDAO giisMortgageeDAO) {
		this.giisMortgageeDAO = giisMortgageeDAO;
	}
	

	@Override
	public JSONObject showMortgageeMaintenance(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS105MortgageeList");
		params.put("issCd", request.getParameter("issCd"));
		Map<String, Object> mortgageeListing = TableGridUtil.getTableGrid(request,params);
		JSONObject json = new JSONObject(mortgageeListing);
		request.setAttribute("mortgageeListing", json);
		return json;
	}

	@Override
	public String validateAddMortgageeCd(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("mortgCd", request.getParameter("mortgCd"));
		return this.getGiisMortgageeDAO().validateAddMortgageeCd(params);
	}

	@Override
	public String validateAddMortgageeName(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("mortgName", request.getParameter("mortgName"));
		return this.getGiisMortgageeDAO().validateAddMortgageeName(params);
	}

	@Override
	public String validateDeleteMortgagee(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", request.getParameter("issCd"));
		params.put("mortgCd", StringFormatter.unescapeHtmlJava(request.getParameter("mortgCd"))); //added unescapeHTML by robert 01.03.14
		return this.getGiisMortgageeDAO().validateDeleteMortgagee(params);
	}

	@Override
	public String saveMortgagee(HttpServletRequest request, String userId) throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISMortgagee.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISMortgagee.class));
		return this.getGiisMortgageeDAO().saveMortgagee(allParams);
	}
}
