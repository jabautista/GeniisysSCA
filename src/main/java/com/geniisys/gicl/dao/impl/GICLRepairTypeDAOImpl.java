package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLRepairTypeDAO;
import com.geniisys.gicl.entity.GICLRepairType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLRepairTypeDAOImpl implements GICLRepairTypeDAO {
	
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
	public void saveGicls172(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLRepairType> delList = (List<GICLRepairType>) params.get("delRows");
			for(GICLRepairType d: delList){
				this.sqlMapClient.update("delRepairType", d.getRepairCode());
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLRepairType> setList = (List<GICLRepairType>) params.get("setRows");
			for(GICLRepairType s: setList){
				this.sqlMapClient.update("setRepairType", s);
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
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddRepairType", recId);		
	}
	
	public void valDelRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDelRepairType", recId);		
	}
}
