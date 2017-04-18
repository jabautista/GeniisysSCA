package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


import com.geniisys.common.dao.GIISCoverageDAO;
import com.geniisys.common.entity.GIISCoverage;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCoverageDAOImpl implements GIISCoverageDAO{
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddCoverage", params);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelCoverage", params);
	}

	@Override
	public void saveGiiss113(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISCoverage> delList = (List<GIISCoverage>) params.get("delRows");
			for(GIISCoverage d : delList){
				this.sqlMapClient.update("delCoverage", d);
			}
			this.sqlMapClient.executeBatch();
			
			
			@SuppressWarnings("unchecked")
			List<GIISCoverage> setList = (List<GIISCoverage>) params.get("setRows");
			for(GIISCoverage s: setList){
				this.sqlMapClient.update("setCoverage", s);
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
