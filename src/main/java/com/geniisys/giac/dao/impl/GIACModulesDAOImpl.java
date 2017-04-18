/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACModulesDAO;
import com.geniisys.giac.entity.GIACModules;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACModulesDAOImpl implements GIACModulesDAO{

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACModulesDAOImpl.class);
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACModulesDAO#validateUserFunc(java.util.Map)
	 */
	@Override
	public String validateUserFunc(Map<String, Object> param) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateUserFunc", param);
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
		GIACModulesDAOImpl.log = log;
	}

	@Override
	public String validateUserFunc2(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateUserFunc2", params);
	}

	@Override
	public String validateUserFunc3(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateUserFunc3", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs317(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACModules> delList = (List<GIACModules>) params.get("delRows");
			for(GIACModules d: delList){
				this.sqlMapClient.update("delModules", d.getModuleId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACModules> setList = (List<GIACModules>) params.get("setRows");
			for(GIACModules s: setList){
				this.sqlMapClient.update("setModules", s);
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
	public String valDeleteRec(Integer moduleId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDelModules", moduleId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddModules", params);		
	}
	
	public Map<String, Object> validateGiacs317ScreenRepTag(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiacs317ScreenRepTag", params);
		return params;
	}
}
