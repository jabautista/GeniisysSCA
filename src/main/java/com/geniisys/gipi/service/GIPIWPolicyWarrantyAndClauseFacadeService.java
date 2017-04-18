/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.entity.GIPIPackWarrantyAndClauses;


/**
 * The Interface GIPIWPolicyWarrantyAndClauseFacadeService.
 */
public interface GIPIWPolicyWarrantyAndClauseFacadeService {

	/**
	 * Gets the gIPIW policy warranty and clauses.
	 * 
	 * @param lineCd the line cd
	 * @param parId the par id
	 * @return the gIPIW policy warranty and clauses
	 * @throws SQLException the sQL exception
	 */
	public List<GIPIWPolicyWarrantyAndClause> getGIPIWPolicyWarrantyAndClauses(String lineCd, int parId) throws SQLException;
	
	/**
	 * Save w pol wc.
	 * 
	 * @param parameters the parameters
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveWPolWC(Map<String, Object> parameters) throws Exception;
	
	/**
	 * Delete w pol wc.
	 * 
	 * @param lineCd the line cd
	 * @param parId the par id
	 * @param wcCd the wc cd
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteWPolWC(String lineCd, int parId, String wcCd) throws SQLException;
	
	/**
	 * Delete all w pol wc.
	 * 
	 * @param lineCd the line cd
	 * @param parId the par id
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean deleteAllWPolWC(String lineCd, int parId) throws SQLException;
	public List<GIPIWPolicyWarrantyAndClause> getAllWPolicyWCs(String lineCd, int parId) throws Exception;
	public List<GIPIWPolicyWarrantyAndClause> prepareGIPIWPolWCForInsert(JSONArray setRows) throws SQLException, JSONException;
	public List<GIPIPackWarrantyAndClauses> getPolicyListWC (Integer packParId) throws SQLException;
	public List<Map<String, Object>> prepareDefaultGIPIWPolWC (JSONArray setRows) throws SQLException, JSONException;
	
	public void saveGIPIWPolWC(JSONArray setRows, JSONArray delRows) throws SQLException, JSONException, Exception;
	
	public boolean saveGIPIWPolWCTableGrid(Map<String, Object> parameters) throws Exception; //added by steven 4.30.2012
	
	public String validatePrintSeqNo(Map<String, Object> parameters) throws SQLException; //added by steven 4.30.2012 
	
	public String checkExistingRecord(Map<String, Object> parameters) throws SQLException; //added by steven 6.1.2012 
	
}
