package com.geniisys.giri.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giri.dao.GIRIEndttextDAO;
import com.geniisys.giri.entity.GIRIEndttext;
import com.geniisys.giri.service.GIRIEndttextService;
import com.seer.framework.util.StringFormatter;

public class GIRIEndttextServiceImpl implements GIRIEndttextService{
	
	private GIRIEndttextDAO giriEndttextDAO;

	public GIRIEndttextDAO getGiriEndttextDAO() {
		return giriEndttextDAO;
	}

	public void setGiriEndttextDAO(GIRIEndttextDAO giriEndttextDAO) {
		this.giriEndttextDAO = giriEndttextDAO;
	}

	@Override
	public Map<String, Object> getRiDtlsGIUTS024(Map<String, Object> params)
			throws SQLException {
		return this.getGiriEndttextDAO().getRiDtlsGIUTS024(params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getRiDtlsList(HashMap<String, Object> params)
			throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIRIEndttext> list = this.getGiriEndttextDAO().getRiDtlsList(params);
		params.put("rows", new JSONArray((List<GIRIEndttext>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public void updateCreateEndtTextBinder(Map<String, Object> params)
			throws Exception {
		this.getGiriEndttextDAO().updateCreateEndtTextBinder(params);
	}

	@Override
	public void deleteRiDtlsGIUTS024(Map<String, Object> params)
			throws SQLException {
		this.getGiriEndttextDAO().deleteRiDtlsGIUTS024(params);
	}

	@Override
	public void saveEndtTextBinder(HttpServletRequest request, String userId)
			throws SQLException, JSONException, ParseException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("setItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("setItemRows")), userId, GIRIEndttext.class));
		params.put("delItemRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(paramsObj.getString("delItemRows")), userId, GIRIEndttext.class));
		this.getGiriEndttextDAO().saveEndtTextBinder(params);
	}

}
