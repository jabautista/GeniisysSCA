package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISBondSeqDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISBondSeqDAOImpl implements GIISBondSeqDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISBondSeqDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	public Integer generateBondSeq(Map<String, Object> params, Integer noOfSequence)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (int i = 0; i < noOfSequence.intValue(); i++){
				this.getSqlMapClient().update("generateBondSeq", params);
				this.getSqlMapClient().executeBatch();
			}
			this.getSqlMapClient().getCurrentConnection().commit();
			return (Integer) params.get("generatedBondSeq");
			
		}catch(SQLException e){
			if (e.getErrorCode() != 1438){ // Print stacktrace if SqlException is caused by oracle error other than ORA-1438 
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());				
			}
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	
}
