package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOrigInvPerlDAO;
import com.geniisys.gipi.entity.GIPIOrigInvPerl;
import com.geniisys.gipi.service.GIPIOrigInvPerlService;
import com.seer.framework.util.StringFormatter;

public class GIPIOrigInvPerlServiceImpl implements GIPIOrigInvPerlService {
	
	private GIPIOrigInvPerlDAO gipiOrigInvPerlDAO;

	public void setGipiOrigInvPerlDAO(GIPIOrigInvPerlDAO gipiOrigInvPerlDAO) {
		this.gipiOrigInvPerlDAO = gipiOrigInvPerlDAO;
	}

	public GIPIOrigInvPerlDAO getGipiOrigInvPerlDAO() {
		return gipiOrigInvPerlDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiOrigInvPerl(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIOrigInvPerl> list = this.getGipiOrigInvPerlDAO().getGipiInvPerl(params);
		params.put("rows", new JSONArray((List<GIPIOrigInvPerl>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getInvPerils(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String , Object>> invPerilsList = this.getGipiOrigInvPerlDAO().getInvPerils(params);
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(invPerilsList)));
		grid.setNoOfPages(invPerilsList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	
}
