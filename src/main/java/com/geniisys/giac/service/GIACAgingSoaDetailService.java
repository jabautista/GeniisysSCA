/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACAgingSoaDetail;

/**
 * The Interface GIACBranchService.
 */
public interface GIACAgingSoaDetailService {

	/**
	 * Get InstNo details.
	 * @return 
	 * 
	 * @return the InstNo details
	 * @throws SQLException the sQL exception
	 */
	public List<GIACAgingSoaDetail> getInstnoDetails(String issCd, Integer premSeqNo) throws SQLException;
	
	/**
	 * Get policy details.
	 * @return 
	 * 
	 * @return the policy details
	 * @throws SQLException the sQL exception
	 */
	public List<Map<String, Object>> getPolicyDetails(Map<String, Object> params) throws SQLException;
	
	/**
	 * Gets GIAC_AGING_SOA_DETAILS records
	 * @param keyword
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getAgingSoaDetails(String keyword, String issCd) throws SQLException;
	JSONObject getBillInfo(HttpServletRequest request) throws SQLException;
	JSONObject getInstInfo(HttpServletRequest request) throws SQLException;
	Map<String, Object> getPolicyDtlsGIACS007(Map<String, Object> params) throws SQLException;
	
	JSONObject getInvoiceSoaDetails(HttpServletRequest request) throws SQLException;
}
