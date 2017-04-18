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
import com.geniisys.giis.dao.GIISSignatoryNamesDAO;
import com.geniisys.giis.entity.GIISSignatoryNames;
import com.geniisys.giis.service.GIISSignatoryNamesService;

public class GIISSignatoryNamesServiceImpl implements GIISSignatoryNamesService{

	private GIISSignatoryNamesDAO giisSignatoryNamesDAO;

	public GIISSignatoryNamesDAO getGiisSignatoryNamesDAO() {
		return giisSignatoryNamesDAO;
	}

	public void setGiisSignatoryNamesDAO(GIISSignatoryNamesDAO giisSignatoryNamesDAO) {
		this.giisSignatoryNamesDAO = giisSignatoryNamesDAO;
	}
		
	public JSONObject showGiiss071(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss071RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("signatoryId") != "" || request.getParameter("signatoryId") != null){
			//Integer signatoryId = Integer.parseInt(request.getParameter("signatoryId"));
			this.giisSignatoryNamesDAO.valDeleteRec(request.getParameter("signatoryId"));
		}
	}

	@Override
	public void saveGiiss071(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSignatoryNames.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSignatoryNames.class));
		params.put("appUser", userId);
		this.giisSignatoryNamesDAO.saveGiiss071(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		//params.put("signatoryId", Integer.parseInt(request.getParameter("signatoryId")));
		params.put("signatory", request.getParameter("signatory"));
		params.put("resCertNo", request.getParameter("resCertNo"));
		this.giisSignatoryNamesDAO.valAddRec(params);
	}
	
	@Override
	public void valUpdateRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("signatoryId", request.getParameter("signatoryId"));
		params.put("signatory", request.getParameter("signatory"));
		params.put("resCertNo", request.getParameter("resCertNo"));
		this.giisSignatoryNamesDAO.valUpdateRec(params);
	}
	
	@Override
	public void updateFilename(Map<String, Object> params)
			throws SQLException {
		String fileName = (String)params.get("filePath") + (String)params.get("fileName");
		params.put("fileName", fileName);
		this.giisSignatoryNamesDAO.updateFilename(params);
	}
	
	public String getFilename(Integer signatoryId) throws SQLException{
		return this.giisSignatoryNamesDAO.getFilename(signatoryId);
	}
}
