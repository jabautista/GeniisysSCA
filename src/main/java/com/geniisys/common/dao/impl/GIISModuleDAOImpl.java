/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISModuleDAO;
import com.geniisys.common.entity.GIISModule;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISModuleDAOImpl.
 */
public class GIISModuleDAOImpl implements GIISModuleDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
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
	 * @see com.geniisys.common.dao.GIISModuleDAO#getModuleMenuList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISModule> getModuleMenuList(String userId) throws SQLException {
		return this.getSqlMapClient().queryForList("getModuleMenuList", userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISModuleDAO#getGiisModulesList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISModule> getGiisModulesList() throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisModulesList");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISModule> getCompleteModuleList(String keyword)
			throws SQLException {
		List<GIISModule> modules = this.getSqlMapClient().queryForList("getCompleteModuleList", keyword);
		return modules;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISModule> getModuleTranList(String moduleId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getModuleTranList", moduleId);
	}

	@Override
	public void setGiisModule(GIISModule module) throws SQLException {
		this.getSqlMapClient().insert("setGiisModule", module);
	}

	@Override
	public GIISModule getGiisModule(String moduleId) throws SQLException {
		return (GIISModule) this.getSqlMapClient().queryForObject("getGiisModule", moduleId);
	}

	@Override
	public void updateGiisModule(GIISModule module) throws SQLException {
		this.getSqlMapClient().update("updateGiisModule", module);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelGeniisysModule", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss081(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISModule> delList = (List<GIISModule>) params.get("delRows");
			for(GIISModule d : delList){
				this.sqlMapClient.update("delGiisModule081", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISModule> setList = (List<GIISModule>) params.get("setRows");
			for(GIISModule s: setList){
				this.sqlMapClient.update("setGiisModule081", s);
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
	public void valDeleteTranRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valDelGeniisysModuleTran", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGeniisysModuleTran(Map<String, Object> params)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISModule> delList = (List<GIISModule>) params.get("delRows");
			for(GIISModule d : delList){
				this.sqlMapClient.update("delGiisModulesTran081", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISModule> setList = (List<GIISModule>) params.get("setRows");
			for(GIISModule s: setList){
				this.sqlMapClient.update("setGiisModulesTran081", s);
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGeniisysModule", params);
	}

	@Override
	public void valAddTranRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddTranRec", params);
	}

}
