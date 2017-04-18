/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACBranch;

/**
 * The Interface GIACBranchDAO.
 */
public interface GIACBranchDAO {

	/**
	 * Gets the Branch Details.
	 * 
	 * @return the GIACBranch
	 * @throws SQLException the sQL exception
	 */
	GIACBranch getBranchDetails() throws SQLException;
	
	/**
	 * 
	 * @param moduleId
	 * @return
	 * @throws SQLException
	 */
	List<GIACBranch> getOtherBranchOR(String moduleId, String userId) throws SQLException;
	
	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	Map<String, Object> getDefBranchBankDtls(Map<String, Object> params)  throws SQLException;
	
	/**
	 * Gets the records of BRANCH_CD LOV in GIACS035 (Close DCB)
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<Map<String, Object>> getBranchCdLOV(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param userId
	 * @return
	 * @throws SQLException
	 */
	List<GIACBranch> getBranchesGIACS333(String userId) throws SQLException;

	/**
	 * 
	 * @param params
	 * @return
	 * @throws SQLException
	 */
	List<GIACBranch> getBranchLOV(Map<String, Object> params) throws SQLException;
	
	/**
	 * 
	 * @param branchCd
	 * @return
	 * @throws SQLException
	 */
	GIACBranch getBranchDetails2(String branchCd) throws SQLException;
	
	List<GIACBranch> getGIACS002BranchLOV(Map<String, Object> params) throws SQLException;
	
	public String validateGIACS117BranchCd(Map<String, Object> params) throws SQLException;
	public String validateGIACS170BranchCd(Map<String, Object> params) throws SQLException;
	public String validateGIACS078BranchCd(Map<String, Object> params) throws SQLException;
	
	String validateGIACBranchCd(Map<String, Object> params) throws SQLException;
	String validateGIACS178BranchCd(Map<String, Object> params) throws SQLException;
	
	public String validateGIACS273BranchCd(Map<String, Object> params) throws SQLException;
	void giacs303NewFormInstance(Map<String, Object> params) throws SQLException;
	void valDeleteBranch(Map<String, Object> params) throws SQLException;
	void saveGiacs303(Map<String, Object> params) throws SQLException;
	
	String validateBranchCdInAcctrans(Map<String, Object> params) throws SQLException;
	
}
