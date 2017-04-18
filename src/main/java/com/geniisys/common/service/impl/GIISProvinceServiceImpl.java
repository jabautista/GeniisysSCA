package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.common.dao.GIISProvinceDAO;
import com.geniisys.common.service.GIISProvinceService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISProvinceServiceImpl implements GIISProvinceService{
	private GIISProvinceDAO giisProvinceDAO;
	
	
	/**
	 * @return the giisProvinceDAO
	 */
	public GIISProvinceDAO getGiisProvinceDAO() {
		return giisProvinceDAO;
	}


	/**
	 * @param giisProvinceDAO the giisProvinceDAO to set
	 */
	public void setGiisProvinceDAO(GIISProvinceDAO giisProvinceDAO) {
		this.giisProvinceDAO = giisProvinceDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISProvinceService#getProvinceDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getProvinceDtls(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> provList = this.getGiisProvinceDAO().getProvinceDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(provList)));
		grid.setNoOfPages(provList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

}
