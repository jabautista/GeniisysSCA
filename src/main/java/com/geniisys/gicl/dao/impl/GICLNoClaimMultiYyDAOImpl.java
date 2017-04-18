package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLNoClaimMultiYyDAO;
import com.geniisys.gicl.entity.GICLNoClaim;
import com.geniisys.gicl.entity.GICLNoClaimMultiYy;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLNoClaimMultiYyDAOImpl implements GICLNoClaimMultiYyDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLNoClaimMultiYyDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNoClaimMultiYyList(
			HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getNoClaimMultiYyList");
	}

	@Override
	public GICLNoClaimMultiYy getNoClaimMultiYyDetails(Integer noClaimId) throws SQLException {
		// TODO Auto-generated method stub
		return (GICLNoClaimMultiYy) this.getSqlMapClient().queryForObject("getNoClaimMultiYyDetails",noClaimId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList(
			HashMap<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getNoClaimMultiYyPolicyList",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList2(
			HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getNoClaimMultiYyPolicyList2",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getNoClaimMultiYyPolicyList3(
			HashMap<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		return (Map<String, Object>) this.getSqlMapClient().queryForList("getNoClaimMultiYyPolicyList3",params);
	}

	@Override
	public Integer getNoClaimMultiYyNo() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getNoClaimNumber",null);
		
	}

	@Override
	public GICLNoClaimMultiYy populateDetails(HashMap<String, Object> params)
			throws SQLException {
		return (GICLNoClaimMultiYy) this.getSqlMapClient().queryForObject("populateNewDetails",params);
	}

	@Override
	public String validateExisting(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateSavingResult",params);
	}

	@Override
	public GICLNoClaimMultiYy additionalDtl() throws SQLException {
		return (GICLNoClaimMultiYy) this.getSqlMapClient().queryForObject("addtDtls");
	}
	
	public GICLNoClaimMultiYy updateDtls(Integer noClaimId) throws SQLException {
		return (GICLNoClaimMultiYy) this.getSqlMapClient().queryForObject("updateDtls",noClaimId);
	}

	@Override
	public Map<String, Object> saveNewDetails(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.sqlMapClient.update("setNewDetails", params);
			System.out.println(" PARAMS SA UPDATE "+params);
			this.getSqlMapClient().executeBatch();
			System.out.println(":::::::::::::::::::: DATA :::::::::::::::::::::::"+params);
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
			
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of Saving No Claim Multi Year.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public GICLNoClaim getNoClaimCertDtls(Integer noClaimId)
			throws SQLException {
		log.info("Getting No Claim Certificate Details");
		return (GICLNoClaim) this.getSqlMapClient().queryForObject("getNoClaimCertDtls", noClaimId);
	}
}
