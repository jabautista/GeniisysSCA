package com.geniisys.gixx.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gixx.dao.GIXXProdBudgetDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIXXProdBudgetDAOImpl implements GIXXProdBudgetDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIXXProdBudgetDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> extractBudgetProduction(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Extracting Budget Production...");
			log.info("params: " + params);
			this.getSqlMapClient().update("extractBudgetProduction", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	
}
