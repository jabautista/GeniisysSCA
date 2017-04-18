package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLCatDtlDAO;
import com.geniisys.gicl.entity.GICLCatDtl;
import com.geniisys.gicl.service.GICLCatDtlService;
import com.seer.framework.util.StringFormatter;

public class GICLCatDtlServiceImpl implements GICLCatDtlService{
	
	private GICLCatDtlDAO giclCatDtlDAO;
	
	/**
	 * @return the giclCatDtlDAO
	 */
	public GICLCatDtlDAO getGiclCatDtlDAO() {
		return giclCatDtlDAO;
	}

	/**
	 * @param giclCatDtlDAO the giclCatDtlDAO to set
	 */
	public void setGiclCatDtlDAO(GICLCatDtlDAO giclCatDtlDAO) {
		this.giclCatDtlDAO = giclCatDtlDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLCatDtlService#getCatDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getCatDtls(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<GICLCatDtl> catList = this.getGiclCatDtlDAO().getCatDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(catList)));
		grid.setNoOfPages(catList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

}
