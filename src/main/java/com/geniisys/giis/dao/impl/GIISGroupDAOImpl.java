package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISGroup;
import com.geniisys.giis.dao.GIISGroupDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISGroupDAOImpl implements GIISGroupDAO {
	
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
	public void saveGiiss118(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISGroup> delList = (List<GIISGroup>) params.get("delRows");
			for(GIISGroup d: delList){
				this.sqlMapClient.update("delAssuredGroup", String.valueOf(d.getGroupCd()));
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISGroup> setList = (List<GIISGroup>) params.get("setRows");
			for(GIISGroup s: setList){
				this.sqlMapClient.update("setAssuredGroup", s);
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
		this.sqlMapClient.update("valDeleteAssuredGroup", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAssuredGroup", recId);		
	}
}
