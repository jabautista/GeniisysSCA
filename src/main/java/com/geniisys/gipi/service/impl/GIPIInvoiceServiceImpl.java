package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIInvoiceDAO;
import com.geniisys.gipi.entity.GIPIInvoice;
import com.geniisys.gipi.service.GIPIInvoiceService;
import com.seer.framework.util.StringFormatter;

public class GIPIInvoiceServiceImpl implements GIPIInvoiceService{
	
	private GIPIInvoiceDAO	gipiInvoiceDAO;

	public GIPIInvoiceDAO getGipiInvoiceDAO() {
		return gipiInvoiceDAO;
	}

	public void setGipiInvoiceDAO(GIPIInvoiceDAO gipiInvoiceDAO) {
		this.gipiInvoiceDAO = gipiInvoiceDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getPolicyInvoice(HashMap<String,Object> params) throws SQLException {
		
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"),5);//
		params.put("from", null);
		params.put("to", null);
		List<HashMap<String, Object>> invoiceList = this.getGipiInvoiceDAO().getPolicyInvoice(params);
		//params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInList(invoiceList))); // replaced by: Nica 04.24.2013
		params.put("rows", new JSONArray((List<HashMap<String, Object>>)StringFormatter.escapeHTMLInListOfMap((invoiceList))));
		grid.setNoOfPages(invoiceList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIInvoiceService#getMultiBookingDateByPolicy(java.lang.Integer, java.lang.Integer)
	 */
	@Override
	public String getMultiBookingDateByPolicy(Integer policyId, Integer distNo)
			throws SQLException {
		return this.getGipiInvoiceDAO().getMultiBookingDateByPolicy(policyId, distNo);
	}

	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> populateBasicDetails(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), 10);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIPIInvoice> list = this.getGipiInvoiceDAO().populateBasicDetails(params);
		params.put("rows", new JSONArray((List<GIPIInvoice>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		return params;
	}

	@Override
	public JSONObject showInvoiceInformation(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getInvoiceInformationList");
		params.put("userId", userId);
		Map<String, Object> invoiceList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(invoiceList);
		return json;
	}

	@Override
	public JSONObject getInvoiceTaxDetails(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getInvoiceTaxDetails");
		params.put("issCd", request.getParameter("issCd"));
		params.put("premSeqNo", (request.getParameter("premSeqNo") != null && !request.getParameter("premSeqNo").equals("")) ? Integer.parseInt(request.getParameter("premSeqNo")) : null);
		params.put("itemGrp", (request.getParameter("itemGrp") != null && !request.getParameter("itemGrp").equals("")) ? Integer.parseInt(request.getParameter("itemGrp")) : null);
		System.out.println("params..... " + params);
		Map<String, Object> invoiceTaxList = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(invoiceTaxList);
		return json;
	}
	
}
