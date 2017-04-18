package com.geniisys.gipi.service;

import java.sql.SQLException;
import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

public interface GIPIBankScheduleService {
	
	/**
	 * Retrieves the list of bank collection of a policy
	 * @param   policyId 
	 * @throws SQLException 
	 * @returns list of bank collection
	 * @throws  SQLException
	 */
	JSONObject getBankCollection(HttpServletRequest request) throws SQLException, JSONException;
	
}
