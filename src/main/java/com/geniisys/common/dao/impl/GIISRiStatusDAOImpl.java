package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISRiStatusDAO;
import com.geniisys.common.entity.GIISRiStatus;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISRiStatusDAOImpl implements GIISRiStatusDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss073(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISRiStatus> delList = (List<GIISRiStatus>) params.get("delRows");
			for(GIISRiStatus d: delList){
				this.sqlMapClient.update("delRiStatus", d.getStatusCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISRiStatus> setList = (List<GIISRiStatus>) params.get("setRows");
			for(GIISRiStatus s: setList){
				this.sqlMapClient.update("setRiStatus", s);
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
		this.sqlMapClient.update("valDeleteRiStatus", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRiStatus", params);		
	}
}
