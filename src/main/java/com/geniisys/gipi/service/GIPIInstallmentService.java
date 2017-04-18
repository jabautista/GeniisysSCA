/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;

/**
 * The Interface GIPIPARListService.
 */
public interface GIPIInstallmentService {
	
	/**
	 * 
	 * @param premSeqno, issCd
	 * @return no. of records
	 * @throws SQLException the sQL exception
	 */
	public Map<String, Object> checkInstNo(Map<String, Object> param) throws SQLException; 
	
	/**
	 * 
	 * @param instNo, premSeqno, issCd
	 * @return date due
	 * @throws SQLException the sQL exception
	 */
	public Integer getDaysOverdue (Map<String, Object> param) throws SQLException;
	
	public PaginatedList getInstNoList(Map<String, Object> params) throws SQLException;
	
	String getUnpaidPremiumDtls(HttpServletRequest request) throws SQLException;
	
	public Integer checkInstNoGIACS007 (Map<String, Object> param) throws SQLException;
	JSONObject getInvoicePaytermsInfo(HttpServletRequest request) throws SQLException, JSONException;
}
