package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;

import com.geniisys.common.dao.GIISPayeesDAO;
import com.geniisys.common.entity.GIISPayees;
import com.geniisys.common.service.GIISPayeesService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISPayeesServiceImpl implements GIISPayeesService{
	GIISPayeesDAO giisPayeesDAO;
	
	/**
	 * @return the giisPayeesDAO
	 */
	public GIISPayeesDAO getGiisPayeesDAO() {
		return giisPayeesDAO;
	}


	/**
	 * @param giisPayeesDAO the giisPayeesDAO to set
	 */
	public void setGiisPayeesDAO(GIISPayeesDAO giisPayeesDAO) {
		this.giisPayeesDAO = giisPayeesDAO;
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISPayeesService#getPayeeByAdjusterListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPayeeByAdjusterListing(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> payeeList = this.getGiisPayeesDAO().getPayeeByAdjusterListing(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(payeeList)));
		grid.setNoOfPages(payeeList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISPayeesService#getPayeeByAdjusterListing2(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPayeeByAdjusterListing2(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> payeeList = this.getGiisPayeesDAO().getPayeeByAdjusterListing2(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(payeeList)));
		grid.setNoOfPages(payeeList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}


	@Override
	public List<GIISPayees> getPayeeMortgageeListing(Map<String, Object> params)
			throws SQLException {
		return this.getGiisPayeesDAO().getPayeeMortgageeListing(params);
	}


	@Override
	public String getPayeeClassDesc(String payeeClassCd)
			throws SQLException {
		return this.getGiisPayeesDAO().getPayeeClassDesc(payeeClassCd);
	}
	
	@Override
	public String getPayeeClassSlTypeCd(String payeeClassCd)
			throws SQLException {
		return this.getGiisPayeesDAO().getPayeeClassSlTypeCd(payeeClassCd);
	}


	@Override
	public String getPayeeFullName(Map<String, Object> params)
			throws SQLException {
		return getGiisPayeesDAO().getPayeeFullName(params);
	}
	
}
