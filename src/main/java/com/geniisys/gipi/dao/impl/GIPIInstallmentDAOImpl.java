/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIInstallmentDAO;
import com.geniisys.gipi.entity.GIPIInstallment;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * The Class GIPIInstallmentDAOImpl.
 */
public class GIPIInstallmentDAOImpl implements GIPIInstallmentDAO{

	/** The log. */
	private Logger log = Logger.getLogger(GIPIParMortgageeDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIInstallmentDAO#checkInstNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> checkInstNo(Map<String, Object> param) throws SQLException {
		this.sqlMapClient.queryForObject("checkInstNo", param);
		return param;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIInstallmentDAO#getDaysOverdue(java.util.Map)
	 */
	@Override
	public Integer getDaysOverdue(Map<String, Object> param) throws SQLException {
		log.info("");
		return (Integer) this.sqlMapClient.queryForObject("getDaysDue", param);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIInstallmentDAO#getInstNoList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public List<GIPIInstallment> getInstNoList(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getInstNoList", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIInstallmentDAO#getUnpaidPremiumDtls(java.util.Map)
	 */
	@Override
	public Map<String, Object> getUnpaidPremiumDtls(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getUnpaidPremiumDtls", params);
		return params;
	}

	@Override
	public Integer checkInstNoGIACS007(Map<String, Object> param)
			throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("checkInstNoGIACS007", param);
	}
}
