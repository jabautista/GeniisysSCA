package com.geniisys.quote.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.quote.dao.GIPIQuoteInvoiceDAO;
import com.geniisys.quote.entity.GIPIQuoteInvoice;
import com.geniisys.quote.entity.GIPIQuoteInvtax;
import com.geniisys.quote.service.GIPIQuoteInvoiceService;

public class GIPIQuoteInvoiceServiceImpl implements GIPIQuoteInvoiceService{
	private GIPIQuoteInvoiceDAO gipiQuoteInvoiceDAO2;

	public GIPIQuoteInvoiceDAO getGipiQuoteInvoiceDAO2() {
		return gipiQuoteInvoiceDAO2;
	}

	public void setGipiQuoteInvoiceDAO2(GIPIQuoteInvoiceDAO gipiQuoteInvoiceDAO2) {
		this.gipiQuoteInvoiceDAO2 = gipiQuoteInvoiceDAO2;
	}

	@Override
	public GIPIQuoteInvoice getGipiQuoteInvoiceDtls(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteInvoiceDAO2().getGipiQuoteInvoiceDtls(params);
	}

	@Override
	public String saveInvoice(String parameters, Map<String, Object> params)
			throws JSONException, SQLException {
		JSONObject objParameters = new JSONObject(parameters);
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), (String)params.get("userId"), GIPIQuoteInvtax.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), (String)params.get("userId"), GIPIQuoteInvtax.class));
		System.out.println(allParams);
		return this.getGipiQuoteInvoiceDAO2().saveInvoice(allParams, params);
	}

	@Override
	public Map<String, Object> checkTaxType(Map<String, Object> params)
			throws SQLException {
		return this.getGipiQuoteInvoiceDAO2().checkTaxType(params);
	}
	
}
