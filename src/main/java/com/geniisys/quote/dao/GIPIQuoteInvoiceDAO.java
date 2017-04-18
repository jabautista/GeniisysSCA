package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuoteInvoice;

public interface GIPIQuoteInvoiceDAO {
	GIPIQuoteInvoice getGipiQuoteInvoiceDtls(Map<String, Object> params) throws SQLException;
	String saveInvoice(Map<String, Object> allParams, Map<String, Object> params) throws SQLException;
	Map<String, Object> checkTaxType(Map<String, Object> params) throws SQLException;
}
