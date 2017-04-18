package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISObligeeDAO;
import com.geniisys.common.entity.GIISObligee;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISObligeeDAOImpl implements GIISObligeeDAO{
	
	/** The SQL Map Client.	 */
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIISObligeeDAOImpl.class);
	
	
	/**
	 * Gets the SQL Map Client.
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the SQL Map Client.
	 * @param sqlMapClient
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISObligeeDAO#getObligeeList(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISObligee> getObligeeList(HashMap<String, Object> params) throws SQLException {
		List<GIISObligee> list = null;
		
		try {
			list = this.getSqlMapClient().queryForList("getObligeeList2",params);
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}		
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISObligeeDAO#getObligeeListMaintenance(java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISObligee> getObligeeListMaintenance(HashMap<String, Object> params) throws SQLException {
		List<GIISObligee> list = null;
		
		try {
			list = this.getSqlMapClient().queryForList("getObligeeListMaintenance", params);
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}		
		return list;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISObligeeDAO#saveObligee(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public String saveObligee(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		
		List<GIISObligee> setRows = (List<GIISObligee>) allParams.get("setRows");
		List<GIISObligee> delRows = (List<GIISObligee>) allParams.get("delRows");
		String userId = (String) allParams.get("userId");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("start of saving Obligee");
			
			for(GIISObligee del : delRows){
				log.info("DELETING: " + del);
				this.getSqlMapClient().delete("deleteObligee", del.getObligeeNo());
			}
			
			for(GIISObligee set : setRows) {
				log.info("INSERTING: " + set);
				set.setUserId(userId); //marco - 05.02.2013
				this.getSqlMapClient().insert("setObligee", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){ //marco - 08.18.2014
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("End of saving Obligee.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISObligeeDAO#validateObligeeNoOnDelete(java.lang.Integer)
	 */
	@Override
	public String validateObligeeNoOnDelete(Integer obligeeNo) throws SQLException {
		String message = "";
		log.info("start of validating Obligee Number to delete.");
		message = (String) this.getSqlMapClient().queryForObject("validateObligeeNoOnDelete", obligeeNo);
		log.info("end of validating Obligee Number to delete.");
		
		return message;
	}
}
