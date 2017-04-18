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

import org.json.JSONException;

import com.geniisys.common.dao.GIISUserGrpModuleDAO;
import com.geniisys.common.entity.GIISModule;
import com.geniisys.common.entity.GIISUserGrpModule;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISUserGrpModuleDAOImpl.
 */
public class GIISUserGrpModuleDAOImpl implements GIISUserGrpModuleDAO {

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
	 * @see com.geniisys.common.dao.GIISUserGrpModuleDAO#getGiisGrpModulesList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISModule> getGiisGrpModulesList(String userGrp) throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisGrpModulesList", userGrp);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpModuleDAO#deleteGiisUserGrpModule(com.geniisys.common.entity.GIISUserGrpModule)
	 */
	@Override
	public void deleteGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException {
		this.getSqlMapClient().delete("deleteGiisUserGrpModule", giisUserGrpModule);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserGrpModuleDAO#setGiisUserGrpModule(com.geniisys.common.entity.GIISUserGrpModule)
	 */
	@Override
	public void setGiisUserGrpModule(GIISUserGrpModule giisUserGrpModule) throws SQLException {
		this.getSqlMapClient().insert("setGiisUserGrpModule", giisUserGrpModule);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUserGrpModule> getModuleUserGrps(String moduleId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getModuleUserGrps", moduleId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveUserGrpModules(Map<String, Object> params)
			throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISUserGrpModule> rows = (List<GIISUserGrpModule>) params.get("modRows");
			for(GIISUserGrpModule row : rows){
				if(row.getIncTag().toString().equals("Y")){
					this.getSqlMapClient().update("updateUserGrpModule", row);
				}else{
					this.getSqlMapClient().update("deleteUserGrpModule", row);
				}
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void checkUncheckModules(Map<String, Object> params)
			throws SQLException {
		if(params.get("check").toString().equals("Y")){
			this.getSqlMapClient().update("checkAllUserGrpModules", params);
		}else{
			this.getSqlMapClient().update("uncheckAllUserGrpModules", params);
		}
	}

}
