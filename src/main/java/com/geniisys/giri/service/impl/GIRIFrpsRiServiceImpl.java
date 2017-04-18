package com.geniisys.giri.service.impl;

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
import com.geniisys.giri.dao.GIRIFrpsRiDAO;
import com.geniisys.giri.entity.GIRIFrpsRi;
import com.geniisys.giri.service.GIRIFrpsRiService;
import com.seer.framework.util.StringFormatter;

public class GIRIFrpsRiServiceImpl implements GIRIFrpsRiService{
	
	private GIRIFrpsRiDAO giriFrpsRiDAO;
	
	public GIRIFrpsRiDAO getGiriFrpsRiDAO(){
		return giriFrpsRiDAO;
	}
	
	public void setGiriFrpsRiDAO(GIRIFrpsRiDAO giriFrpsRiDAO){
		this.giriFrpsRiDAO = giriFrpsRiDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getFrpsRiParams(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 5);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIRIFrpsRi> list = this.getGiriFrpsRiDAO().getGIRIFrpsRiList(params);
		params.put("rows", new JSONArray((List<GIRIFrpsRi>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	@Override
	public Map<String, Object> checkBinderGiuts004(Map<String, Object> params)
			throws SQLException {
		return this.giriFrpsRiDAO.checkBinderGiuts004(params);
	}
	
	@Override
	public Map<String, Object> performReversalGiuts004(Map<String, Object> params)
			throws SQLException {
		return this.giriFrpsRiDAO.performReversalGiuts004(params);
	}
	
	@Override
	public void getGiriFrpsRiGrid3(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiriFrpsRiGrid3");
		params.put("packPolicyId", request.getParameter("packPolicyId"));
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject(params).toString();
		request.setAttribute("packageBinderListTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public String reversePackageBinder(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("packageBinders", request.getParameter("packageBinders"));
		return this.giriFrpsRiDAO.reversePackageBinder(params);
	}

	@Override
	public String generatePackageBinder(HttpServletRequest request,
			GIISUser USER) throws Exception {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("packLineCd", objParams.getString("packLineCd"));
		params.put("packPolicyId", objParams.getString("packPolicyId"));
		return this.giriFrpsRiDAO.generatePackageBinder(params);
	}

	public void groupBinders(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(objParams.getString("rows"))));
		this.giriFrpsRiDAO.groupBinders(params);
	}
	
	public void ungroupBinders(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("masterBndrId",request.getParameter("masterBndrId") == null ? "" : request.getParameter("masterBndrId"));
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		this.giriFrpsRiDAO.ungroupBinders(params);
	}
	
	
	@Override
	public Integer getOutFaculTotAmtGIUTS004(Map<String, Object> params)
			throws SQLException {
		System.out.println("getOutFaculTotAmtGIUTS004 params: " + params);
		return this.giriFrpsRiDAO.getOutFaculTotAmtGIUTS004(params);
	}

	@Override
	public String checkBinderWithClaimsGIUTS004(Map<String, Object> params)
			throws SQLException {
		System.out.println("checkBinderWithClaimsGIUTS004 params: " + params);
		return this.giriFrpsRiDAO.checkBinderWithClaimsGIUTS004(params);
	}

}
