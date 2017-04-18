/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLEvalCslServiceImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 2, 2012
	Description: 
*/


package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLEvalCslDAO;
import com.geniisys.gicl.service.GICLEvalCslService;
import com.seer.framework.util.StringFormatter;

public class GICLEvalCslServiceImpl implements GICLEvalCslService{
	private GICLEvalCslDAO giclEvalCslDAO;

	public Map<String, Object> getMcEvalCslTGList(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMcEvalCslTGList");
		params.put("userId", USER.getUserId());
		params.put("evalId", request.getParameter("evalId"));
		params.put("pageSize", 5);
		
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("mcEvalCslTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public Map<String, Object> getMcEvalCslDtlTGList(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMcEvalCslDtlTGList");
		params.put("userId", USER.getUserId());
		params.put("evalId", request.getParameter("evalId"));
		params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("pageSize", 5);
		params.put("totalPartAmt", getGiclEvalCslDAO().getTotalPartAmtCsl(params));
		
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("mcEvalCslDtlTg", grid);
		request.setAttribute("object", grid);
		return params;
	}

	/**
	 * @param giclEvalCslDAO the giclEvalCslDAO to set
	 */
	public void setGiclEvalCslDAO(GICLEvalCslDAO giclEvalCslDAO) {
		this.giclEvalCslDAO = giclEvalCslDAO;
	}

	/**
	 * @return the giclEvalCslDAO
	 */
	public GICLEvalCslDAO getGiclEvalCslDAO() {
		return giclEvalCslDAO;
	}

	@Override
	public void generateCsl(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONArray jsonLoaList = new JSONArray(request.getParameter("cslList"));
		List<Map<String, Object>> cslList = JSONUtil.prepareMapListFromJSON(jsonLoaList);
		getGiclEvalCslDAO().generateCsl(cslList, USER.getUserId());
	}

	@Override
	public String generateCslFromLossExp(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, Exception {
		JSONArray jsonCslList = new JSONArray(request.getParameter("cslList"));
		List<Map<String, Object>> cslList = JSONUtil.prepareMapListFromJSON(jsonCslList);
		return this.getGiclEvalCslDAO().generateCslFromLossEx(cslList, USER.getUserId());
	}
}
