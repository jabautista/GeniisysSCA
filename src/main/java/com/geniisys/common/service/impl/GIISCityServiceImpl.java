package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.common.dao.GIISCityDAO;
import com.geniisys.common.service.GIISCityService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISCityServiceImpl implements GIISCityService{
	private GIISCityDAO giisCityDAO;
	
	/**
	 * @return the giisCityDAO
	 */
	public GIISCityDAO getGiisCityDAO() {
		return giisCityDAO;
	}


	/**
	 * @param giisCityDAO the giisCityDAO to set
	 */
	public void setGiisCityDAO(GIISCityDAO giisCityDAO) {
		this.giisCityDAO = giisCityDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISCityService#getCityDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getCityDtls(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> cityList = this.getGiisCityDAO().getCityDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(cityList)));
		grid.setNoOfPages(cityList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

}
