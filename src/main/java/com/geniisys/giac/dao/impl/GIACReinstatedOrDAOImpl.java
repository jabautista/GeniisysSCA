package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACReinstatedOrDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACReinstatedOrDAOImpl implements GIACReinstatedOrDAO{
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACPremDepositDAOImpl.class);
	@Override
	public String reinstateOr(Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		String reinstateMessage = "";
		try {
			this.getSqlMapClient().startTransaction();			
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("reinstateOr", params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		 
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return reinstateMessage;
	}
	
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	/**
	 * @return the log
	 */
	public static Logger getLog() {
		return log;
	}
	/**
	 * @param log the log to set
	 */
	public static void setLog(Logger log) {
		GIACReinstatedOrDAOImpl.log = log;
	}
	
}
