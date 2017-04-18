package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOrigInvTaxDAO;
import com.geniisys.gipi.entity.GIPIOrigInvTax;
import com.geniisys.gipi.service.GIPIOrigInvTaxService;
import com.seer.framework.util.StringFormatter;

public class GIPIOrigInvTaxServiceImpl implements GIPIOrigInvTaxService{
	
	private GIPIOrigInvTaxDAO gipiOrigInvTaxDAO;

	public GIPIOrigInvTaxDAO getGipiOrigInvTaxDAO() {
		return gipiOrigInvTaxDAO;
	}

	public void setGipiOrigInvTaxDAO(GIPIOrigInvTaxDAO gipiOrigInvTaxDAO) {
		this.gipiOrigInvTaxDAO = gipiOrigInvTaxDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiOrigInvTaxList(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIOrigInvTax> list = this.getGipiOrigInvTaxDAO().getGipiInvTax(params);
		params.put("rows", new JSONArray((List<GIPIOrigInvTax>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getLeadPolicyInvTax(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String, Object>> invTaxList	= this.getGipiOrigInvTaxDAO().getLeadPolicyInvTax(params); 
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(invTaxList)));
		grid.setNoOfPages(invTaxList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

}
