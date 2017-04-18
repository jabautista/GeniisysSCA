package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISVestypeDAO;
import com.geniisys.common.entity.GIISVestype;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISVestypeDAOImpl implements GIISVestypeDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public void saveGiiss077(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISVestype> delList = (List<GIISVestype>) params.get("delRows");
			for(GIISVestype d: delList){
				this.sqlMapClient.update("delVesselType", d.getVestypeCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISVestype> setList = (List<GIISVestype>) params.get("setRows");
			for(GIISVestype s: setList){
				this.sqlMapClient.update("setVesselType", s);
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

	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteVesselType", recId);
	}

	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddVesselType", recId);		
	}
}
