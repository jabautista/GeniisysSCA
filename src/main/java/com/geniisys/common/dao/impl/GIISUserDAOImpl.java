/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISUserDAO;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.entity.GIISUserLine;
import com.geniisys.common.entity.GIISUserModules;
import com.geniisys.common.entity.GIISUserTran;
import com.geniisys.framework.util.PasswordEncoder;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;


/**
 * The Class GIISUserDAOImpl.
 */
public class GIISUserDAOImpl implements GIISUserDAO {
	
	/** The log. */
	private Logger log = Logger.getLogger(GIISUserDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;
		
	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getGIISUser(java.lang.String)
	 */
	@Override
	public GIISUser getGIISUser(String userId) throws SQLException {
		log.info("Getting user record: " + userId);
		return (GIISUser) getSqlMapClient().queryForObject("getGIISUser", userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#saveGIISUser(com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void saveGIISUser(GIISUser giisUser) throws SQLException {
		this.getSqlMapClient().insert("saveGIISUser", giisUser);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#deleteGIISUser(com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void deleteGIISUser(GIISUser giisUser) throws SQLException {
		log.info("Deleting user record: " + giisUser.getUserId());
		this.getSqlMapClient().delete("deleteGiisUser", giisUser.getUserId());
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getGiisUserAllList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUser> getGiisUserAllList() throws SQLException {
		return this.getSqlMapClient().queryForList("getGiisUserAllList");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getUserPassword(java.lang.String, java.lang.String)
	 */
	@Override
	public GIISUser getUserPassword(String userId, String emailAddress)
			throws Exception {
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", userId);
		params.put("emailAddress", emailAddress);
		log.info("Getting password of " + userId + " with email " + PasswordEncoder.doDecrypt(emailAddress));
		return (GIISUser) this.getSqlMapClient().queryForObject("getUserPassword", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#updateActiveFlag(java.lang.String, java.lang.String)
	 */
	@Override
	public void updateActiveFlag(String userId, String activeFlag)
			throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", userId);
		params.put("activeFlag", activeFlag);
		this.getSqlMapClient().update("updateActiveFlag", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#updatePassword(java.lang.String, java.lang.String)
	 */
	@Override
	public void updatePassword(String userId, String password)
			throws SQLException {
		log.info("Updating password of user : " + userId);
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", userId);
		params.put("password", password);
		this.getSqlMapClient().update("updatePassword", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#updateLastLogin(java.lang.String)
	 */
	@Override
	public void updateLastLogin(String userId) throws SQLException {
		this.getSqlMapClient().update("updateLastLogin", userId);				
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#deactivateInactiveUsers(int)
	 */
	@Override
	public void deactivateInactiveUsers(int noOfDays) throws SQLException {
		this.getSqlMapClient().update("deactivateInactiveUsers", noOfDays);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getGiisUsersList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUser> getGiisUsersList(Map<String, Object> params) throws SQLException {
		return getSqlMapClient().queryForList("getGiisUsersList", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#deleteGiisUserTransaction(java.lang.String)
	 */
	@Override
	public void deleteGiisUserTransaction(String userID) throws SQLException {
		log.info("DAO calling deleteGiisUserTransaction...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.getSqlMapClient().delete("deleteGiisUserLine", userID);
			this.getSqlMapClient().delete("deleteGiisUserIssCd", userID);
			this.getSqlMapClient().delete("deleteGiisUserModules", userID);
			this.getSqlMapClient().delete("deleteGiisUserTran", userID);

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Done deleting user transactions...");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#setGiisUserTransaction(com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void setGiisUserTransaction(GIISUser user) throws SQLException {
		log.info("DAO calling setGiisUserTransaction...");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			// save transactions
			for (GIISUserTran t : user.getTransactions()) {
				System.out.println("USERID: " + t.getUserID() + "\nTRAN_CD: " + t.getTranCd() + "\nACCESS_TAG: " + t.getAccessTag()+"\nUSER_ID: " + t.getUserId());
				this.getSqlMapClient().insert("setGiisUserTran", t);

				// save transaction issue sources
				for (GIISUserIssCd i : t.getIssSources()) {
					System.out.println("Saving Issue: " + i.getIssCd() + " | " + i.getTranCd());
					this.getSqlMapClient().insert("setGiisUserIssCd", i);

					// save transaction issue source lines
					for (GIISUserLine l : i.getLines()) {
						System.out.println("Saving Line: " + l.getLineCd() + " | " + l.getIssCd() + " | " + l.getTranCd());
						this.getSqlMapClient().insert("setGiisUserLine", l);
					}
				}
				
				// save transaction modules
				for (GIISUserModules m: t.getModules()) {
					System.out.println("Module: " + m.getUserID() + " - " + m.getTranCd() + " - " + m.getModuleId() + " - " + m.getUserId() + " - " + m.getRemarks() + " - " + m.getAccessTag());
					this.getSqlMapClient().insert("setGiisUserModule", m);
				}
			}

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		log.info("Done saving user transactions...");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getCommUpdateTag(java.lang.String)
	 */
	@Override
	public String getCommUpdateTag(String user) throws SQLException {
		String result = null;
		
		/*
		 * NOTE: (String) and not .toString(). To handle null value.
		 */
		log.info("Retrieving comm update tag...");
		result = (String)this.getSqlMapClient().queryForObject("getCommUpdateTag", user);
		log.info("Comm update tag successfully retrieved.");
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#giacValidateUser(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String giacValidateUser(String userId, String functionCd, String moduleId) throws SQLException {
		Map<String, String> params = new HashMap<String, String>();
		params.put("userId", userId);
		params.put("functionCd", functionCd);
		params.put("moduleId", moduleId);
		return (String) this.getSqlMapClient().queryForObject("giacValidateUser", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#checkUserAccess(java.lang.String)
	 */
	@Override
	public String checkUserAccess(String moduleName) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkUserAccess", moduleName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getGroupIssCd(java.lang.String)
	 */
	@Override
	public String getGroupIssCd(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGroupIssCd", userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#userOveride(java.util.Map)
	 */
	@Override
	public Map<String, Object> userOveride(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().queryForObject("userOveride", params);
		Debug.print(params);
		return params;
	}
	
	public String checkIfUserAllowedForEdit(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkIfUserAllowedForEdit", params);
	}
	
	public void verifyUser(Map<String, Object> params) throws SQLException{
		this.getSqlMapClient().queryForObject("verifyUser", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getUserGrp(java.lang.String)
	 */
	@Override
	public Integer getUserGrp(String userId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getUserGrp", userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#resetPassword(java.util.Map)
	 */
	@Override
	public void resetPassword(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("resetPassword", params);		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getUnderwriterForReassignQuote(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUser> getUnderwriterForReassignQuote(
			Map<String, Object> params) throws SQLException {		
		return (List<GIISUser>) this.getSqlMapClient().queryForList("getUnderwriterForReassignQuote", params);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#checkUserAccess2(java.lang.String, java.lang.String)
	 */
	@Override
	public String checkUserAccess2(String moduleName, String userId)
			throws SQLException {
		log.info("Checking if module "+moduleName+" is valid for user "+userId);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("module", moduleName);
		params.put("userId", userId);
		return (String) this.getSqlMapClient().queryForObject("checkUserAccess2", params);
	}

	/* benjo 02.01.2016 GENQA-SR-4941 */
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getPasswordAndEmail(java.lang.String)
	 */
	@Override
	public String forgotPassValidateUser(String userId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("forgotPassValidateUser", userId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getPasswordAndEmail(java.lang.String)
	 */
	@Override
	public GIISUser getPasswordAndEmail(String userId) throws SQLException {
		log.info("Getting password and email of " + userId);
		return (GIISUser) this.getSqlMapClient().queryForObject("getPasswordAndEmail", userId);		
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getUserLevel(java.lang.String)
	 */
	@Override
	public Integer getUserLevel(String userId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getUserLevel", userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#getUserByIssCd(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getUserByIssCd(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getUserListLOV", params);
	}
	
	@Override
	public Map<String, Object> validateUserGIEXS001(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateUserGIEXS001", params);
		Debug.print(params);
		return params ;
	}
	
	public String validateIfActiveUser(String userId) throws SQLException{
		return (String) this.getSqlMapClient().queryForObject("validateIfActiveUser", userId);
	}

	@Override
	public String checkUserAccessGiuts008a(String moduleId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkUserAccess", moduleId);
	}
	
	public String checkUserPerLineGiuts007(Map<String, Object> params) throws SQLException {
		Debug.print(params);
		return (String) this.getSqlMapClient().queryForObject("checkUserPerLine", params);
	}

	public String checkIssCdExistPerUserGiuts007(Map<String, Object> params)throws SQLException {
		Debug.print(params);
		return (String) this.getSqlMapClient().queryForObject("checkIssCdExPerUser", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUser> getUserListing(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getUserListing", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISUser> getAllUserListing(Map<String, Object> params)	throws SQLException {
		return this.sqlMapClient.queryForList("getAllUserListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISUserDAO#checkUserAccessGipis162(java.lang.String)
	 */
	@Override
	public String checkUserAccessGipis162(String moduleId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkUserAccess", moduleId);
	}

	@Override
	public Map<String, Object> checkUserStat(Map<String, Object> params) throws SQLException {
		log.info("Checking user stat...");
		this.getSqlMapClient().queryForObject("checkUserStat", params);
		System.out.println("DAO - returned params: "+params);
		return  params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getHashingParameters() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getHashingParameters");
	}

	@Override
	public void updatePassword(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updatePassword", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPwMeterParameters() throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getPwMeterParameters");
	}

	@Override
	public void savePwHist(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("savePwHist", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getPwHist(String userId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPwHist", userId);
	}

	@Override
	public void updateInvalidLoginTries(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("updateInvalidLoginTries", params);
	}	
}