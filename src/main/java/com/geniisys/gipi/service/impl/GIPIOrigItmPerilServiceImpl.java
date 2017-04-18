package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOrigItmPerilDAO;
import com.geniisys.gipi.entity.GIPIOrigItmPeril;
import com.geniisys.gipi.service.GIPIOrigItmPerilService;
import com.seer.framework.util.StringFormatter;

public class GIPIOrigItmPerilServiceImpl implements GIPIOrigItmPerilService{
	
	private GIPIOrigItmPerilDAO gipiOrigItmPerilDAO;
	
	private static Logger log = Logger.getLogger(GIPIOrigItmPerilServiceImpl.class);
	
	/**
	 * 
	 * @return
	 */
	public GIPIOrigItmPerilDAO getGipiOrigItmPerilDAO(){
		return gipiOrigItmPerilDAO;
	}
	
	/**
	 * 
	 * @param gipiOrigItmPerilDAO
	 */
	public void setGipiOrigItmPerilDAO(GIPIOrigItmPerilDAO gipiOrigItmPerilDAO){
		this.gipiOrigItmPerilDAO = gipiOrigItmPerilDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIOrigItmPerilService#getGipiOrigItmPerilList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiOrigItmPerilList(
			HashMap<String, Object> params) throws SQLException, JSONException {
		log.info("getGipiOrigItmPerilList");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIOrigItmPeril> list = this.getGipiOrigItmPerilDAO().getGipiOrigItmPerils(params);
		params.put("rows", new JSONArray((List<GIPIOrigItmPeril>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getOrigItmPerils(HashMap<String, Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String, Object>> origItmPerilList = this.getGipiOrigItmPerilDAO().getOrigItmPerils(params);
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(origItmPerilList)));
		grid.setNoOfPages(origItmPerilList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
		
	}

	
}
