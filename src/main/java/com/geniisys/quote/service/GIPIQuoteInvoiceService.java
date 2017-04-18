package com.geniisys.quote.service;

import java.sql.SQLException;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.quote.entity.GIPIQuoteInvoice;

public interface GIPIQuoteInvoiceService {
	GIPIQuoteInvoice getGipiQuoteInvoiceDtls(Map<String, Object> params) throws SQLException;
	String saveInvoice(String parameters, Map<String, Object> params) throws JSONException, SQLException;
	Map<String, Object> checkTaxType(Map<String, Object> params) throws SQLException;
}