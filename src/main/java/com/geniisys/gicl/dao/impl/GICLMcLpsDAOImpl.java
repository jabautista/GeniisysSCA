package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLMcLpsDAO;
import com.geniisys.gicl.entity.GICLMcLps;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMcLpsDAOImpl implements GICLMcLpsDAO {
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void saveGicls171(Map<String, Object> params)
			throws SQLException {
		
		try {
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GICLMcLps> setList = (List<GICLMcLps>) params.get("setRows");
			for(GICLMcLps s: setList){
				System.out.println("Loss Exp Cd : " + s.getLossExpCd());
				this.sqlMapClient.update("saveGicls171", s);
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
