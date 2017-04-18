package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLAdvsPlaDAO;
import com.geniisys.gicl.entity.GICLAdvsPla;
import com.geniisys.gicl.service.GICLAdvsPlaService;
import com.seer.framework.util.StringFormatter;

public class GICLAdvsPlaServiceImpl implements GICLAdvsPlaService{

	private GICLAdvsPlaDAO giclAdvsPlaDAO;

	public GICLAdvsPlaDAO getGiclAdvsPlaDAO() {
		return giclAdvsPlaDAO;
	}

	public void setGiclAdvsPlaDAO(GICLAdvsPlaDAO giclAdvsPlaDAO) {
		this.giclAdvsPlaDAO = giclAdvsPlaDAO;
	}

	@Override
	public void getGiclAdvsPlaGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmResHistId", request.getParameter("clmResHistId")); 
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		params.put("shareType", request.getParameter("shareType"));
		params.put("ACTION", "getGiclAdvsPlaGrid");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("plaDetailsTG", grid);
		request.setAttribute("object", grid);
	}

	@Override
	public String cancelPLA(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER); 
		params.put("userId", USER.getUserId()); 
		params.put("claimId", request.getParameter("claimId"));
		params.put("resPlaId", request.getParameter("resPlaId")); 
		return this.giclAdvsPlaDAO.cancelPLA(params);
	}

	@Override
	public String generatePLA(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER); 
		params.put("userId", USER.getUserId()); 
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd")); 
		params.put("clmYy", request.getParameter("clmYy")); 
		params.put("rows", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("rows")))); 
		return this.giclAdvsPlaDAO.generatePLA(params);
	}

	@Override
	public void updatePrintSwPla(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER); 
		params.put("userId", USER.getUserId()); 
		params.put("claimId", request.getParameter("claimId"));
		params.put("riCd", request.getParameter("riCd")); 
		params.put("plaSeqNo", request.getParameter("plaSeqNo")); 
		params.put("lineCd", request.getParameter("lineCd")); 
		params.put("laYy", request.getParameter("laYy")); 
		this.giclAdvsPlaDAO.updatePrintSwPla(params);
	}
	
	@Override
	public void updatePrintSwPla2(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER); 
		params.put("userId", USER.getUserId()); 
		params.put("claimId", request.getParameter("claimId"));
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		params.put("riCd", request.getParameter("riCd")); 
		params.put("plaSeqNo", request.getParameter("plaSeqNo")); 
		params.put("lineCd", request.getParameter("lineCd")); 
		params.put("laYy", request.getParameter("laYy")); 
		this.giclAdvsPlaDAO.updatePrintSwPla2(params);
	}

	@Override
	public String savePreliminaryLossAdv(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("USER", USER);
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId")); 
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GICLAdvsPla.class));
		return StringFormatter.escapeHTML(this.giclAdvsPlaDAO.savePreliminaryLossAdv(params));
	}
	
	@Override
	public HashMap<String, Object> getAllPlaDetails(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmResHistId", request.getParameter("clmResHistId")); 
		params.put("grpSeqNo", request.getParameter("grpSeqNo"));
		params.put("shareType", request.getParameter("shareType"));
		params.put("ACTION", "getGiclAdvsPlaGrid");
		HashMap<String, Object> hashMap = new HashMap<String, Object>();
		hashMap.put("rows", new JSONArray(this.giclAdvsPlaDAO.getAllPlaDetails(params)));		
		return hashMap;
	}
}
