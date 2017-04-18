package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISFloodZoneDAO;
import com.geniisys.common.entity.GIISFloodZone;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISFloodZoneDAOImpl implements GIISFloodZoneDAO {

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss053(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISFloodZone> delList = (List<GIISFloodZone>) params.get("delRows");
			for(GIISFloodZone d: delList){
				this.sqlMapClient.update("delFloodZone", d.getFloodZone());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISFloodZone> setList = (List<GIISFloodZone>) params.get("setRows");
			for(GIISFloodZone s: setList){
				this.sqlMapClient.update("setFloodZone", s);
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
		this.sqlMapClient.update("valDeleteFloodZone", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddFloodZone", params);
	}

}
