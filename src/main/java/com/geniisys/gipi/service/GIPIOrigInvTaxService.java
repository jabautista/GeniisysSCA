package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.HashMap;

import org.json.JSONException;

public interface GIPIOrigInvTaxService {
	HashMap<String, Object> getGipiOrigInvTaxList(HashMap<String,Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> getLeadPolicyInvTax(HashMap<String,Object> params) throws SQLException;
}
