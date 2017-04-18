/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service.impl
	File Name: GICLEvalLoaServiceImpl.java
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
import com.geniisys.gicl.dao.GICLEvalLoaDAO;
import com.geniisys.gicl.service.GICLEvalLoaService;
import com.seer.framework.util.StringFormatter;

public class GICLEvalLoaServiceImpl implements GICLEvalLoaService{
	
	private GICLEvalLoaDAO giclEvalLoaDAO;
	
	@Override
	public Map<String, Object> getMcEvalLoaTGLst(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
	
		params.put("ACTION", "getMcEvalLoaTGLst");
		params.put("userId", USER.getUserId());
		params.put("evalId", request.getParameter("evalId"));
		params.put("pageSize", 5);
		
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("mcEvalLoaTG", grid);
		request.setAttribute("object", grid);
		return params;
	}

	@Override
	public Map<String, Object> getMcEvalLoaDtlTGList(
			HttpServletRequest request, GIISUser USER) throws SQLException,
			JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMcEvalLoaDtlTGList");
		params.put("userId", USER.getUserId());
		params.put("evalId", request.getParameter("evalId"));
		params.put("payeeTypeCd", request.getParameter("payeeTypeCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("pageSize", 5);
		params.put("totalPartAmt", getGiclEvalLoaDAO().getTotalPartAmt(params));
		
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		
		request.setAttribute("mcEvalLoaDtlTg", grid);
		request.setAttribute("object", grid);
		return params;
	}
	
	@Override
	public void generateLoa(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONArray jsonLoaList = new JSONArray(request.getParameter("loaList"));
		List<Map<String, Object>> loaList = JSONUtil.prepareMapListFromJSON(jsonLoaList);
		getGiclEvalLoaDAO().generateLoa(loaList, USER.getUserId());
	}

	/**
	 * @param giclEvalLoaDAO the giclEvalLoaDAO to set
	 */
	public void setGiclEvalLoaDAO(GICLEvalLoaDAO giclEvalLoaDAO) {
		this.giclEvalLoaDAO = giclEvalLoaDAO;
	}

	/**
	 * @return the giclEvalLoaDAO
	 */
	public GICLEvalLoaDAO getGiclEvalLoaDAO() {
		return giclEvalLoaDAO;
	}

	@Override
	public String generateLoaFromLossExp(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException, Exception {
		JSONArray jsonLoaList = new JSONArray(request.getParameter("loaList"));
		List<Map<String, Object>> loaList = JSONUtil.prepareMapListFromJSON(jsonLoaList);
		return this.getGiclEvalLoaDAO().generateLoaFromLossExp(loaList, USER.getUserId());
	}
}
