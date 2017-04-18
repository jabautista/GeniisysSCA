package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISXolMaintDAO;
import com.geniisys.common.entity.GIISXol;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISXolMaintDAOImpl implements GIISXolMaintDAO{
	
	private Logger log = Logger.getLogger(GIISXolMaintDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveXol(Map<String, Object> allParams) throws SQLException {
		
		String message = "SUCCESS";
	
		List<GIISXol> delRows = (List<GIISXol>) allParams.get("delRows");
		List<GIISXol> setRows = (List<GIISXol>) allParams.get("setRows");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving XOL...");
			
			for (GIISXol del : delRows) {
				this.getSqlMapClient().delete("deleteXolMaintRow", del);
			}
			
			for (GIISXol set : setRows) {
				this.sqlMapClient.insert("setXolMaintRow", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			log.info("End of saving XOL.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	public String validateAddXol(Map<String, Object> params) throws SQLException{
		log.info("start of validating xol");
		return (String) this.getSqlMapClient().queryForObject("validateAddXol", params);
	}
	
	public String validateUpdateXol(Map<String, Object> params) throws SQLException{
		log.info("start of validating update of xol");
		return (String) this.getSqlMapClient().queryForObject("validateUpdateXol", params);
	}
	
	public String validateDeleteXol(Map<String, Object> params) throws SQLException {
		log.info("start of validating deletion of xol");
		return (String) this.getSqlMapClient().queryForObject("validateDeleteXol", params);
	}

}
