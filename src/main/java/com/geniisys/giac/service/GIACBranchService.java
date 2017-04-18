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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACBranch;

/**
 * The Interface GIACBranchService.
 */
public interface GIACBranchService {
	
	/**
	 * Get Branch Details.
	 * 
	 * @return the GIACBranch
	 * @throws SQLException the sQL exception
	 */
	public GIACBranch getBranchDetails() throws SQLException;
	
	public HashMap<String, Object> getOtherBranchOR(String moduleId, String userId, HashMap<String, Object> params) throws SQLException;
	
	Map<String, Object> getDefBranchBankDtls(Map<String, Object> params)  throws SQLException;
	
	/**
	 * Gets the records of FUND_CD LOV for Close DCB module (Giacs035)
	 * @param pageNo
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	PaginatedList getBranchCdLOV(Integer pageNo, Map<String, Object> params) throws SQLException;

	List<GIACBranch> getBranchesGIACS333(String userId) throws SQLException;	
	
	void getBranchLOV(Map<String, Object> params) throws SQLException, JSONException;
	
	GIACBranch getBranchDetails2(String branchCd) throws SQLException;
	
	public String validateGIACS117BranchCd(Map<String, Object> params) throws SQLException;
	public String validateGIACS170BranchCd(Map<String, Object> params) throws SQLException;
	public String validateGIACS078BranchCd(Map<String, Object> params) throws SQLException;
	
	String validateGIACBranchCd(HttpServletRequest request, String userId) throws SQLException;
	String validateGIACS178BranchCd(HttpServletRequest request, String userId) throws SQLException;
	
	public String validateGIACS273BranchCd(HttpServletRequest request, String userId) throws SQLException;
	JSONObject showGiacs303(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valDeleteBranch(HttpServletRequest request, String userId) throws SQLException;
	void saveGiacs303(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void validateBranchCdInAcctrans(HttpServletRequest request, String userId) throws SQLException;
	JSONObject getBatchBranchList (HttpServletRequest request,  String userId) throws SQLException, ParseException, JSONException;
	JSONObject getGIACS156Branches(HttpServletRequest request, String userId)throws SQLException, JSONException; //pol cruz, 10.14.2013, for giacs156
}
