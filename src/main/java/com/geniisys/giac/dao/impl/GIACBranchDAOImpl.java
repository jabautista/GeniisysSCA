/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACBranchDAO;
import com.geniisys.giac.entity.GIACBranch;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIACBranchDAOImpl.
 */
public class GIACBranchDAOImpl implements GIACBranchDAO{
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACBranchDAOImpl.class);
	
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBranchDAO#getBranchDetails(com.geniisys.giac.entity.GIACBranch)
	 */
	@Override
	public GIACBranch getBranchDetails() throws SQLException {
		log.info("Getting giac branch details");
		return (GIACBranch) this.getSqlMapClient().queryForObject("getBranchDetails");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBranchDAO#getOtherBranchOR(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBranch> getOtherBranchOR(String moduleId, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", moduleId);
		params.put("userId", userId);
		log.info("DAO - Retriving Branch OR List for "+params);
		List<GIACBranch> list = this.getSqlMapClient().queryForList("getOtherBranchOR", params);
		log.info("DAO - " + list.size() + " Branch OR records retrived...");
		return list;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBranchDAO#getDefBranchBankDtls(java.util.Map)
	 */
	@Override
	public Map<String, Object> getDefBranchBankDtls(Map<String, Object> params)	throws SQLException {
		this.sqlMapClient.queryForObject("defBankAcctList", params);
		return params;
		//return (Map<String, Object>) this.getSqlMapClient().queryForObject("defBankAcctList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBranchDAO#getBranchCdLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBranchCdLOV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getBranchCdLOV", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBranch> getBranchesGIACS333(String userId)
			throws SQLException {
		log.info("Getting list of branches for DCB No. Maintenance...");
		return this.getSqlMapClient().queryForList("getBranchesGIACS333", userId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBranch> getBranchLOV(Map<String, Object> params)
			throws SQLException {		
		return (List<GIACBranch>) this.getSqlMapClient().queryForList("getGIACBranchLOV", params);
	}

	@Override
	public GIACBranch getBranchDetails2(String branchCd) throws SQLException {
		log.info("Getting branch details...");
		return (GIACBranch) this.getSqlMapClient().queryForObject("getBranchDetails2", branchCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBranch> getGIACS002BranchLOV(Map<String, Object> params) throws SQLException {
		log.info("DAO - Getting branch LOV for GIACS002...");
		return this.getSqlMapClient().queryForList("getGIACS002BranchLOV", params);
	}

	@Override
	public String validateGIACS117BranchCd(Map<String, Object> params) throws SQLException {
		log.info("DAO - validating Branch Cd for GIACS117...");
		return (String) this.getSqlMapClient().queryForObject("validateGIACS117BranchCd", params);
	}
	
	@Override
	public String validateGIACS170BranchCd(Map<String, Object> params) throws SQLException {
		log.info("DAO - validating Branch Cd for GIACS170...");
		return (String) this.getSqlMapClient().queryForObject("validateGIACS170BranchCd", params);
	}
	
	@Override
	public String validateGIACS078BranchCd(Map<String, Object> params) throws SQLException {
		log.info("DAO - validating Branch Cd for GIACS078...");
		return (String) this.getSqlMapClient().queryForObject("validateGIACS078BranchCd", params);
	}

	@Override
	public String validateGIACBranchCd(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateGIACBranchCd", params);
	}

	@Override
	public String validateGIACS178BranchCd(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateGIACS178BranchCd", params);
	}

	@Override
	public String validateGIACS273BranchCd(Map<String, Object> params)throws SQLException {		
		return (String) this.getSqlMapClient().queryForObject("validateGIACS273BranchCd", params);
	}

	@Override
	public void giacs303NewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("giacs303NewFormInstance", params);
	}

	@Override
	public void valDeleteBranch(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("giacs303ValDeleteBranch", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs303(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBranch> branchList = (List<GIACBranch>) params.get("setRows");
			for(GIACBranch b: branchList){
				this.sqlMapClient.update("giacs303UpdateBranch", b);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public String validateBranchCdInAcctrans(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateBranchCdInAcctrans", params);
	}
}
