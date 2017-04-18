package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOrigCommInvPerilDAO;
import com.geniisys.gipi.entity.GIPIOrigCommInvPeril;
import com.geniisys.gipi.service.GIPIOrigCommInvPerilService;
import com.seer.framework.util.StringFormatter;

public class GIPIOrigCommInvPerilServiceImpl implements GIPIOrigCommInvPerilService {
	
	private GIPIOrigCommInvPerilDAO gipiOrigCommInvPerilDAO;

	public GIPIOrigCommInvPerilDAO getGipiOrigCommInvPerilDAO() {
		return gipiOrigCommInvPerilDAO;
	}

	public void setGipiOrigCommInvPerilDAO(
			GIPIOrigCommInvPerilDAO gipiOrigCommInvPerilDAO) {
		this.gipiOrigCommInvPerilDAO = gipiOrigCommInvPerilDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiOrigCommInvPeril(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIOrigCommInvPeril> list = this.getGipiOrigCommInvPerilDAO().getGipiOrigCommInvPeril(params);
		params.put("rows", new JSONArray((List<GIPIOrigCommInvPeril>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getCommInvPerils(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String,Object>> commInvPerilList = this.getGipiOrigCommInvPerilDAO().getCommInvPerils(params);
		//params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(commInvPerilList)));
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInListOfMap(commInvPerilList)));
		grid.setNoOfPages(commInvPerilList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
}
