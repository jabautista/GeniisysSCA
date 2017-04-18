package com.geniisys.giex.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giex.dao.GIEXBusinessConservationDAO;
import com.geniisys.giex.entity.GIEXExpiry;
import com.geniisys.giex.service.GIEXBusinessConservationService;
import com.seer.framework.util.StringFormatter;

public class GIEXBusinessConservationServiceImpl implements GIEXBusinessConservationService{
	private GIEXBusinessConservationDAO giexBusinessConservationDAO;

	public void setGiexBusinessConservationDAO(GIEXBusinessConservationDAO giexBusinessConservationDAO) {
		this.giexBusinessConservationDAO = giexBusinessConservationDAO;
	}

	public GIEXBusinessConservationDAO getGiexBusinessConservationDAO() {
		return giexBusinessConservationDAO;
	}

	public Map<String, Object> extractPolicies(Map<String, Object> params)
			throws SQLException {
		return this.getGiexBusinessConservationDAO().extractPolicies(params);
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getBusConDetails(
			HashMap<String, Object> params) throws SQLException, JSONException,
			ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareBusConDetailFilter((String)params.get("filter")));
		List<GIEXExpiry> list = this.getGiexBusinessConservationDAO().getBusConDetails(params);
		params.put("rows", new JSONArray((List<GIEXExpiry>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getBusConPackDetails(
			HashMap<String, Object> params) throws SQLException, JSONException,
			ParseException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareBusConDetailFilter((String)params.get("filter")));
		List<GIEXExpiry> list = this.getGiexBusinessConservationDAO().getBusConPackDetails(params);
		params.put("rows", new JSONArray((List<GIEXExpiry>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}
	
	private Map<String, Object> prepareBusConDetailFilter(String filter) throws JSONException, ParseException{
		Map<String, Object> expiryFilter = new HashMap<String, Object>();
		JSONObject jsonExpiryListFilter = null;
		
		if(null == filter){
			System.out.println("Filter is null");
			jsonExpiryListFilter = new JSONObject();
		}else{
			jsonExpiryListFilter = new JSONObject(filter);
		}
		expiryFilter.put("lineCd", jsonExpiryListFilter.isNull("lineCd") ? "%%" : "%"+jsonExpiryListFilter.getString("lineCd").toUpperCase()+"%");
		expiryFilter.put("issCd", jsonExpiryListFilter.isNull("issCd") ? "%%" : "%"+jsonExpiryListFilter.getString("issCd").toUpperCase()+"%");
		expiryFilter.put("policyNo", jsonExpiryListFilter.isNull("policyNo")? "%%" : "%"+jsonExpiryListFilter.getString("policyNo").toUpperCase()+"%");
		expiryFilter.put("renewalId", jsonExpiryListFilter.isNull("renewalId") ? "%%" : "%"+jsonExpiryListFilter.getString("renewalId").toUpperCase()+"%");
		expiryFilter.put("assdName", jsonExpiryListFilter.isNull("assdName") ? "%%" : "%"+jsonExpiryListFilter.getString("assdName").toUpperCase()+"%");
		expiryFilter.put("intmNo", jsonExpiryListFilter.isNull("intmNo") ? "%%" : "%"+jsonExpiryListFilter.getString("intmNo").toUpperCase()+"%");

		return expiryFilter;
	}
}
