package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIItemVesDAO;
import com.geniisys.gipi.entity.GIPIItemVes;
import com.geniisys.gipi.service.GIPIItemVesService;
import com.seer.framework.util.StringFormatter;

public class GIPIItemVesServiceImpl implements GIPIItemVesService{
	
	private GIPIItemVesDAO gipiItemVesDAO;

	public GIPIItemVesDAO getGipiItemVesDAO() {
		return gipiItemVesDAO;
	}

	public void setGipiItemVesDAO(GIPIItemVesDAO gipiItemVesDAO) {
		this.gipiItemVesDAO = gipiItemVesDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getMarineHulls(HashMap<String, Object> params)throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),ApplicationWideParameters.PAGE_SIZE);//
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIItemVes> marineHullList = this.getGipiItemVesDAO().getMarineHulls(params);
		params.put("rows", new JSONArray((List<GIPIItemVes>)StringFormatter.escapeHTMLInList(marineHullList)));
		grid.setNoOfPages(marineHullList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	@Override
	public GIPIItemVes getItemVesInfo(HashMap<String, Object> params) throws SQLException {
		return getGipiItemVesDAO().getItemVesInfo(params);
	}
	
}
