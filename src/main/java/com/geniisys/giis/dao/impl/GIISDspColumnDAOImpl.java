package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.ibatis.sqlmap.client.SqlMapClient;

import com.geniisys.giis.dao.GIISDspColumnDAO;
import com.geniisys.giis.entity.GIISDspColumn;

public class GIISDspColumnDAOImpl implements GIISDspColumnDAO{
	
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddDspColumn", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss167(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISDspColumn> delList = (List<GIISDspColumn>) params.get("delRows");
			for(GIISDspColumn d : delList){
				this.sqlMapClient.update("delDspColumn", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			List<GIISDspColumn> setList = (List<GIISDspColumn>) params.get("setRows");
			for(GIISDspColumn s: setList){
				this.sqlMapClient.update("setDspColumn", s);
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

}
