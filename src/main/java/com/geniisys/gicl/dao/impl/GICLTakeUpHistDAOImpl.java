package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLTakeUpHistDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLTakeUpHistDAOImpl implements GICLTakeUpHistDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GICLTakeUpHistDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public Date getMaxAcctDate() throws SQLException {
		log.info("Getting Max Acct Date...");
		return (Date) this.getSqlMapClient().queryForObject("getMaxAcctDate");
	}
	
	@Override
	public Map<String, Object> validateTranDate(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateTranDate", params);
		Debug.print(params);
		return params ;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> bookOsGICLB001(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("bookOsGICLB001", params);
			List<Integer> tranIds = this.getSqlMapClient().queryForList("getTranIdsForPrinting", params);
			String strTranIds = tranIds.toString();
			String ids = strTranIds.substring(1, strTranIds.length()-1);
			Debug.print(tranIds);
			params.put("tranIds", ids);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
}
