/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACChartOfAccts;

/**
 * The Interface GIACOrderOfPaymentService.
 */
public interface GIACChartOfAcctsService {
	
	/**
	 * Get Account Code Details.
	 * 
	 * @return the GIACChartOfAccts
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getAccountCodeDtls(Map<String, Object> params, Integer pageNo) throws SQLException;
	PaginatedList getAccountCodeDtls2(String keyword, Integer pageNo) throws SQLException;
	List<GIACChartOfAccts> getAllChartOfAccts() throws SQLException;
	List<GIACChartOfAccts> getAccountCodes(Map<String, Object> params) throws SQLException;

	JSONObject showGiacs311(HttpServletRequest request, String userId) throws SQLException, JSONException;
	String checkGiacs311UserFunction(HttpServletRequest request, String userId) throws SQLException;
	String getGlMotherAcct(HttpServletRequest request) throws SQLException;
	String getIncrementedLevel(HttpServletRequest request) throws SQLException;
	JSONObject getChildRecList(HttpServletRequest request, String userId) throws SQLException, JSONException;
	Map<String, Object> getChildChartOfAccts (HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException;
	void valUpdateRec(HttpServletRequest request) throws SQLException;
	void saveGiacs311(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
	void valDelRec(HttpServletRequest request) throws SQLException;
}
