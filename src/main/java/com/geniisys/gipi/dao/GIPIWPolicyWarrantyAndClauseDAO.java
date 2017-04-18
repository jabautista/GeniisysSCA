/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.entity.GIPIPackWarrantyAndClauses;


/**
 * The Interface GIPIWPolicyWarrantyAndClauseDAO.
 */
public interface GIPIWPolicyWarrantyAndClauseDAO {

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
	 * @param wc the wc
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveWPolWC(GIPIWPolicyWarrantyAndClause wc) throws SQLException;
	
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
	
	/**
	 * Save w pol wc.
	 * 
	 * @param parameters the parameters
	 * @return true, if successful
	 * @throws SQLException the sQL exception
	 */
	public boolean saveWPolWC(Map<String, Object> parameters) throws Exception;
	
	public List<GIPIWPolicyWarrantyAndClause> getAllWPolicyWCs(Map<String, Object> params) throws Exception;
	
	public List<GIPIPackWarrantyAndClauses> getPolicyListWC (Integer packParId) throws SQLException;
	
	public void saveGIPIWPolWC(List<GIPIWPolicyWarrantyAndClause> setRows, List<GIPIWPolicyWarrantyAndClause> delRows) throws SQLException, Exception;
	
	public void deleteGIPIWPolWCTableGrid(Map<String, Object> parameters) throws SQLException; //added by steven 4.30.2012
	
	public void saveGIPIWPolWCTableGrid(Map<String, Object> parameters) throws SQLException; //added by steven 4.30.2012
	
	String validatePrintSeqNo(Map<String, Object> parameters) throws  SQLException; //added by steven 4.30.2012
	
	public String checkExistingRecord(Map<String, Object> parameters) throws SQLException; //added by steven 6.1.2012 
	
}
