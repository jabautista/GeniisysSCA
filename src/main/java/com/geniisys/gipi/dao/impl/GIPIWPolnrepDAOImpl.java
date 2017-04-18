/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWPolnrepDAO;
import com.geniisys.gipi.entity.GIPIWPolnrep;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWPolnrepDAOImpl.
 */
public class GIPIWPolnrepDAOImpl implements GIPIWPolnrepDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolnrep.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolnrepDAO#getWPolnrep(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolnrep> getWPolnrep(int parId) throws SQLException {
		
		log.info("DAO - Retrieving WPolnrep...");
		List<GIPIWPolnrep> wpolnrepList = this.getSqlMapClient().queryForList("getWPolnrep", parId);
		log.info("DAO - WPolnrep Size(): " + wpolnrepList.size());
		
		return wpolnrepList;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolnrepDAO#deleteWPolnreps(int)
	 */
	@Override
	public boolean deleteWPolnreps(int parId) throws SQLException {
		
		log.info("DAO - Deleting all WPolnreps... ");
		this.getSqlMapClient().delete("deleteWPolnreps", parId);
		log.info("DAO - All WPolnreps deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolnrepDAO#saveWPolnrep(com.geniisys.gipi.entity.GIPIWPolnrep, java.lang.String)
	 */
	@Override
	public Map<String, Object> saveWPolnrep(GIPIWPolnrep wpolnrep, String polFlag) throws SQLException {	
		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("parId", wpolnrep.getParId());
		params.put("oldPolicyId", wpolnrep.getOldPolicyId());
		params.put("polFlag", polFlag);
		params.put("userId", wpolnrep.getUserId());
				
		log.info("DAO - Inserting WPolnrep...");
		this.getSqlMapClient().update("saveWPolnrep", params);		
		log.info("DAO - WPolnrep inserted.");
				
		return params;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolnrepDAO#checkPolicyForRenewal(com.geniisys.gipi.entity.GIPIWPolnrep, java.lang.String)
	 */
	@Override
	public Map<String, Object> checkPolicyForRenewal(GIPIWPolnrep wpolnrep, String polFlag) throws SQLException {
 
		Map<String, Object> parameters = new HashMap<String, Object>();
		
		parameters.put("parId", wpolnrep.getParId());
		parameters.put("lineCd", wpolnrep.getLineCd());
		parameters.put("sublineCd", wpolnrep.getSublineCd());
		parameters.put("issCd", wpolnrep.getIssCd());
		parameters.put("issueYy", wpolnrep.getIssueYy());
		parameters.put("polSeqNo", wpolnrep.getPolSeqNo());
		parameters.put("renewNo", wpolnrep.getRenewNo());
		parameters.put("polFlag", polFlag);
		
		System.out.println("DAO - Retrieving old policy id...");
		this.getSqlMapClient().update("checkPolicyForRenewal", parameters);
		log.info("Old policy id retrieved - "+parameters);
		
		return parameters;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolnrepDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWPolnrep", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolnrep> getWPolnrep2(Integer parId) throws SQLException {
		log.info("DAO - Retrieving WPolnrep...");
		List<GIPIWPolnrep> wpolnrepList = this.getSqlMapClient().queryForList("getWPolnrep2", parId);
		log.info("DAO - WPolnrep Size(): " + wpolnrepList.size());
		
		return wpolnrepList;
	}

}
