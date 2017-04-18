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

import com.geniisys.giac.dao.GIACPdcPremCollnDAO;
import com.geniisys.giac.entity.GIACPdcPremColln;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACPdcPremCollnDAOImpl implements GIACPdcPremCollnDAO{
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACPdcPremCollnDAOImpl.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACPdcPremCollnDAO#getDatedChkDtls(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPdcPremColln> getDatedChkDtls(Integer gaccTranId) throws SQLException {
		return this.sqlMapClient.queryForList("getDatedChksDtls", gaccTranId);
	}

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

	/**
	 * @return the log
	 */
	public static Logger getLog() {
		return log;
	}

	/**
	 * @param log the log to set
	 */
	public static void setLog(Logger log) {
		GIACPdcPremCollnDAOImpl.log = log;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACPdcPremColln> getPostDatedCheckDtls(HashMap<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getPostDatedChecksDtls", params);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> validatePremSeqNo(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.sqlMapClient.queryForObject("validatePremSeqNo", params);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> getPdcPremCollnDtls(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.sqlMapClient.queryForObject("getPdcPremCollnDtls", params);
	}
	
	@SuppressWarnings("unchecked")
	public HashMap<String, Object> fetchPremCollnUpdateValues(Map<String, Object> params)
			throws SQLException {
		return (HashMap<String, Object>) this.sqlMapClient.queryForObject("fetchPremCollnUpdateValues", params);
	}

	public String getParticulars(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getParticulars", params);
	}
	
	public String getParticulars2(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getParticulars2", params);
	}

	@Override
	public void getPremCollnUpdateValues(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getPremCollnUpdateValues", params);
	}
	
	@Override
	public String getRefPolNo(Map<String, Object> params) throws SQLException { //benjo 11.08.2016 SR-5802
		return (String) this.sqlMapClient.queryForObject("getRefPolNoGiacs090", params);
	}
	
	@Override
	public String validatePolicy(Map<String, Object> params) throws SQLException { //benjo 11.08.2016 SR-5802
		return (String) this.sqlMapClient.queryForObject("validatePolicyGiacs090", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPolicyInvoices(Map<String, Object> params) throws SQLException { //benjo 11.08.2016 SR-5802
		return (List<Map<String, Object>>) this.sqlMapClient.queryForList("getPolicyInvoicesGiacs090", params);
	}
}
