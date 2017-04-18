package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.gipi.dao.GIPIReminderDAO;
import com.geniisys.gipi.entity.GIPIReminder;
import com.ibatis.sqlmap.client.SqlMapClient;
import org.apache.log4j.Logger;

public class GIPIReminderDAOImpl implements GIPIReminderDAO{

	private SqlMapClient sqlMapClient;
	
	private Logger log = Logger.getLogger(GIPIReminderDAOImpl.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIReminder> getGIPIReminderListing(String alertUser)
			throws SQLException {
		log.info("DAO - Retrieving reminder listing...");
		return this.getSqlMapClient().queryForList("getGIPIReminderListing", alertUser);
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public String saveReminder(Map<String, Object> allParams)
			throws SQLException {
		String message = "SUCCESS";
		@SuppressWarnings("unchecked")
		List<GIPIReminder> setRows = (List<GIPIReminder>) allParams.get("setRows");
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			log.info("Saving reminder...");
			
			for(GIPIReminder set : setRows){
				this.sqlMapClient.insert("setGIPIReminder", set);
				this.getSqlMapClient().executeBatch();
			}
			
			log.info(setRows.size() + " Reminder/s inserted.");			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> validateAlarmUser(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("validateAlarmUser", params);
	}
	
	public Integer getClaimParId(String claimId) throws SQLException{	//SR-19555 : shan 07.07.2015
		System.out.println("getClaimParId: " + claimId);
		return (Integer) this.getSqlMapClient().queryForObject("getClaimParId", claimId);
	}

}
