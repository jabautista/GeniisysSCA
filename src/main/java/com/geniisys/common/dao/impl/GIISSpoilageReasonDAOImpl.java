package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISSpoilageReasonDAO;
import com.geniisys.common.entity.GIISSpoilageReason;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSpoilageReasonDAOImpl implements GIISSpoilageReasonDAO{
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss212(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISSpoilageReason> delList = (List<GIISSpoilageReason>) params.get("delRows");
			for(GIISSpoilageReason d: delList){
				this.sqlMapClient.update("delGIISSpoilageReason", d.getSpoilCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISSpoilageReason> setList = (List<GIISSpoilageReason>) params.get("setRows");
			for(GIISSpoilageReason s: setList){
				this.sqlMapClient.update("setGIISSpoilageReason", s);
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
		this.sqlMapClient.update("valDeleteGIISSpoilageReason", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddGIISSpoilageReason", recId);		
	}
}
