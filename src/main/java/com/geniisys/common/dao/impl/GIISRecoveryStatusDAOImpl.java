package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISRecoveryStatusDAO;
import com.geniisys.common.entity.GIISRecoveryStatus;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISRecoveryStatusDAOImpl implements GIISRecoveryStatusDAO{
	
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
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls100(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRecoveryStatus> delList = (List<GIISRecoveryStatus>) params.get("delRows");
			for(GIISRecoveryStatus d: delList){
				this.sqlMapClient.update("delGIISRecoveryStatus", d.getRecStatCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRecoveryStatus> setList = (List<GIISRecoveryStatus>) params.get("setRows");
			for(GIISRecoveryStatus s: setList){
				this.sqlMapClient.update("setGIISRecoveryStatus", s);
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
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteGIISRecoveryStatus", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGIISRecoveryStatus", params);		
	}
}
