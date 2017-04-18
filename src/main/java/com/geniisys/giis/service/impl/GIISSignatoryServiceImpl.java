package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.giis.dao.GIISSignatoryDAO;
import com.geniisys.giis.entity.GIISSignatory;
import com.geniisys.giis.service.GIISSignatoryService;

public class GIISSignatoryServiceImpl implements GIISSignatoryService{

	private GIISSignatoryDAO giisSignatoryDAO;
	
	
	public GIISSignatoryDAO getGIISignatoryDAO() {
		return giisSignatoryDAO;
	}

	public void setGIISSignatoryDAO(GIISSignatoryDAO giisSignatoryDAO) {
		this.giisSignatoryDAO = giisSignatoryDAO;
	}

	@Override
	public String validateSignatoryReport(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("reportId", request.getParameter("reportId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params = this.giisSignatoryDAO.validateSignatoryReport(params);
		return new JSONObject(params).toString();
	}

	@Override
	public void saveGIISSignatory(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setSignatory", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSignatory.class));
		params.put("delSignatory", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSignatory.class));
		params.put("userId", userId); //marco - 05.23.2013
		this.giisSignatoryDAO.saveGIISSignatory(params);
	}

	@Override
	public void updateFilename(Map<String, Object> params)
			throws SQLException {
		String fileName = (String)params.get("filePath") + (String)params.get("fileName");
		params.put("fileName", fileName);
		this.getGIISignatoryDAO().updateFilename(params);
	}

	@Override
	public String getGIISS116UsedSignatories(HttpServletRequest request) throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("reportId", request.getParameter("reportId"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		return giisSignatoryDAO.getGIISS116UsedSignatories(params);
	}

}
