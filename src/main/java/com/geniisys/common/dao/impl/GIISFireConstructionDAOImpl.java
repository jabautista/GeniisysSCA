package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISFireConstructionDAO;
import com.geniisys.fire.entity.GIISFireConstruction;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISFireConstructionDAOImpl implements GIISFireConstructionDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss098(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISFireConstruction> delList = (List<GIISFireConstruction>) params.get("delRows");
			for(GIISFireConstruction d: delList){
				this.sqlMapClient.update("delGIISFireConstruction", d.getConstructionCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISFireConstruction> setList = (List<GIISFireConstruction>) params.get("setRows");
			for(GIISFireConstruction s: setList){
				this.sqlMapClient.update("setGIISFireConstruction", s);
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
		this.sqlMapClient.update("valDeleteGIISFireConstruction", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddGIISFireConstruction", recId);		
	}
}
