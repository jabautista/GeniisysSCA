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
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWOpenPolicyDAO;
import com.geniisys.gipi.entity.GIPIWOpenPolicy;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWOpenPolicyDAOImpl.
 */
public class GIPIWOpenPolicyDAOImpl implements GIPIWOpenPolicyDAO  {
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWOpenPolicyDAOImpl.class);

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenPolicyDAO#saveOpenPolicyDetails(com.geniisys.gipi.entity.GIPIWOpenPolicy)
	 */
	@Override
	public void saveOpenPolicyDetails(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Saving open policy details...");
			log.info("parId: "+params.get("parId"));
			log.info("lineCd: "+params.get("lineCd"));
			log.info("opSublineCd: "+params.get("opSublineCd"));
			log.info("opIssCd: "+params.get("opIssCd"));
			log.info("opIssueYy: "+params.get("opIssueYy"));
			log.info("opPolSeqno: "+params.get("opPolSeqno"));
			log.info("opRenewNo: "+params.get("opRenewNo"));
			log.info("decltnNo: "+params.get("decltnNo"));
			this.getSqlMapClient().queryForObject("saveOpenPolicy1", params);
			
			String openPolicyChanged = (String) params.get("openPolicyChanged");
			System.out.println("openPolicyChanged: "+openPolicyChanged);
			if ("Y".equals(openPolicyChanged)){
				log.info("parId: "+params.get("parId"));
				this.getSqlMapClient().queryForObject("saveOpenPolicy2", params);
				this.getSqlMapClient().queryForObject("saveOpenPolicyDetails", params);
			}
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
			System.out.println("Record/s are committed!");
		}
		
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
	 * @see com.geniisys.gipi.dao.GIPIWOpenPolicyDAO#getWOpenPolicy(java.lang.Integer)
	 */
	@Override
	public GIPIWOpenPolicy getWOpenPolicy(Integer parId) throws SQLException {
		log.info("Getting open policy details...");
		GIPIWOpenPolicy policy = (GIPIWOpenPolicy) this.getSqlMapClient().queryForObject("getGipiWOpenPolicyDetails", parId);
		log.info("SUCCESSFUL.");
		return policy;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWOpenPolicyDAO#isExist(java.lang.Integer)
	 */
	@Override
	public Map<String, String> isExist(Integer parId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("parId", parId.toString());
		this.sqlMapClient.update("isExistWOpenPolicy", params);
		return params;
	}

	@Override
	public Map<String, Object> validatePolicyDate(Map<String, Object> params)
			throws SQLException {
		log.info("Validating policy dates...");
		this.getSqlMapClient().update("validatePolicyDate", params);
		return params;
	}

}
