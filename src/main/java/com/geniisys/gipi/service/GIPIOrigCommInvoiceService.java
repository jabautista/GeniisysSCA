package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import org.json.JSONException;

public interface GIPIOrigCommInvoiceService {
	HashMap<String, Object> getGipiOrigCommInvoice(HashMap<String, Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getInvoiceCommissions(HashMap<String,Object> params) throws SQLException;
}
