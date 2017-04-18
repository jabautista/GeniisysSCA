package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIOrigCommInvoiceDAO;
import com.geniisys.gipi.entity.GIPIOrigCommInvoice;
import com.geniisys.gipi.service.GIPIOrigCommInvoiceService;
import com.seer.framework.util.StringFormatter;

public class GIPIOrigCommInvoiceServiceImpl implements GIPIOrigCommInvoiceService {
	
	private GIPIOrigCommInvoiceDAO gipiOrigCommInvoiceDAO;

	public void setGipiOrigCommInvoiceDAO(GIPIOrigCommInvoiceDAO gipiOrigCommInvoiceDAO) {
		this.gipiOrigCommInvoiceDAO = gipiOrigCommInvoiceDAO;
	}

	public GIPIOrigCommInvoiceDAO getGipiOrigCommInvoiceDAO() {
		return gipiOrigCommInvoiceDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getGipiOrigCommInvoice(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIOrigCommInvoice> list = this.getGipiOrigCommInvoiceDAO().getGipiOrigCommInvoice(params);
		params.put("rows", new JSONArray((List<GIPIOrigCommInvoice>)StringFormatter.escapeHTMLInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getInvoiceCommissions(HashMap<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String, Object>> invCommList = this.getGipiOrigCommInvoiceDAO().getInvoiceCommissions(params);
		//params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(invCommList))); // replaced by: Nica 05.23.2013
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInListOfMap(invCommList)));
		grid.setNoOfPages(invCommList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

}
