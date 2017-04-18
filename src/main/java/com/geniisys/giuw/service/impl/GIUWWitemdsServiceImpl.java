package com.geniisys.giuw.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giuw.dao.GIUWWitemdsDAO;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.geniisys.giuw.service.GIUWWitemdsService;
import com.seer.framework.util.StringFormatter;

public class GIUWWitemdsServiceImpl implements GIUWWitemdsService{
	
	private GIUWWitemdsDAO giuwWitemdsDAO;

	public void setGiuwWitemdsDAO(GIUWWitemdsDAO giuwWitemdsDAO) {
		this.giuwWitemdsDAO = giuwWitemdsDAO;
	}

	public GIUWWitemdsDAO getGiuwWitemdsDAO() {
		return giuwWitemdsDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGiuwWitemdsForDistrFinal(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIUWWitemds> list = this.getGiuwWitemdsDAO().getGiuwWitemdsForDistrFinal(params);
		params.put("rows", new JSONArray((List<GIUWWitemds>)StringFormatter.escapeHTMLInList(list)));  
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	// added by jhing 12.05.2014
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>>  getGiuwWitemdsOthPgeDistGrps( 
			HashMap<String, Object> params) throws SQLException {
		List<Map<String, Object>> list = this.getGiuwWitemdsDAO().getGiuwWitemdsOthPgeDistGrps(params);
		return list;
	}	
}
