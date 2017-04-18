/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.giac.entity.GIACPdcPremColln;

/**
 * The Interface GIACPdcPremCollnService.
 */
public interface GIACPdcPremCollnService {
	
	/**
	 * Gets dated check details.
	 * 
	 * @param gaccTranId
	 * @return List<GIACPdcPremColln>
	 * @throws SQLException the sQL exception
	 */
	List<GIACPdcPremColln> getDatedChkDtls(Integer gaccTranId) throws SQLException;

	HashMap<String, Object> getPostDatedCheckDtls(HashMap<String, Object> params) throws SQLException, JSONException;
	
	HashMap<String, Object> validatePremSeqNo(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getPdcPremCollnDtls(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> fetchPremCollnUpdateValues(Map<String, Object> params) throws SQLException;
	
	String getParticulars(Map<String, Object> params) throws SQLException;
	
	String getParticulars2(Map<String, Object> params) throws SQLException;
	JSONObject getPremCollnUpdateValues(HttpServletRequest request) throws SQLException;
	
	/* benjo 11.08.2016 SR-5802 */
	String getRefPolNo(HttpServletRequest request) throws SQLException; 
	String validatePolicy(HttpServletRequest request) throws SQLException;
	List<Map<String, Object>> getPolicyInvoices(HttpServletRequest request) throws SQLException;
	Map<String, Object> getPackInvoices(HttpServletRequest request) throws SQLException, JSONException;
	/* end SR-5802 */
}
