package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.dao.GIISBinderStatusDAO;
import com.geniisys.giis.entity.GIISBinderStatus;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBinderStatusDAOImpl implements GIISBinderStatusDAO{
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss209(Map<String, Object> params) throws SQLException {
		
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISBinderStatus> delList = (List<GIISBinderStatus>) params.get("delRows");
			for(GIISBinderStatus d: delList){
				this.sqlMapClient.update("delBinderStat", d.getBndrStatCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISBinderStatus> oucsList = (List<GIISBinderStatus>) params.get("setRows");
			for(GIISBinderStatus s: oucsList){
				this.sqlMapClient.update("setBinderStat", s);
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
	public void valAddBinderStatus(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("valAddBinderStatus", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteRec", params);
	}
	
}
