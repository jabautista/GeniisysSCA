/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUser;


/**
 * The Interface GIISUserDAO.
 */
public interface GIISUserDAO {
	
	/**
	 * Gets the gIIS user.
	 * 
	 * @param userId the user id
	 * @return the gIIS user
	 * @throws Exception the exception
	 * @throws SQLException the sQL exception
	 */
	GIISUser getGIISUser(String userId) throws Exception, SQLException;
	
	/**
	 * Gets the giis user all list.
	 * 
	 * @return the giis user all list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUser> getGiisUserAllList() throws SQLException;
	
	/**
	 * Gets the giis users list.
	 * 
	 * @param params the params
	 * @return the giis users list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUser> getGiisUsersList(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save giis user.
	 * 
	 * @param giisUser the giis user
	 * @throws SQLException the sQL exception
	 */
	void saveGIISUser(GIISUser giisUser) throws SQLException;
	//void updateGIISUser(GIISUser giisUser) throws SQLException;
	/**
	 * Delete giis user.
	 * 
	 * @param giisUser the giis user
	 * @throws SQLException the sQL exception
	 */
	void deleteGIISUser(GIISUser giisUser) throws SQLException;
	
	/**
	 * Gets the user password.
	 * 
	 * @param userId the user id
	 * @param emailAddress the email address
	 * @return the user password
	 * @throws SQLException the sQL exception
	 * @throws Exception 
	 */
	GIISUser getUserPassword(String userId, String emailAddress) throws SQLException, Exception;
	
	/**
	 * Update active flag.
	 * 
	 * @param userId the user id
	 * @param activeFlag the active flag
	 * @throws SQLException the sQL exception
	 */
	void updateActiveFlag(String userId, String activeFlag) throws SQLException;
	
	/**
	 * Update password.
	 * 
	 * @param userId the user id
	 * @param password the password
	 * @throws SQLException the sQL exception
	 */
	void updatePassword(String userId, String password) throws SQLException;
	
	/**
	 * Update last login.
	 * 
	 * @param userId the user id
	 * @throws SQLException the sQL exception
	 */
	void updateLastLogin(String userId) throws SQLException;
	
	/**
	 * Deactivate inactive users.
	 * 
	 * @param noOfDays the no of days
	 * @throws SQLException the sQL exception
	 */
	void deactivateInactiveUsers(int noOfDays) throws SQLException;
	
	/**
	 * Delete giis user transaction.
	 * 
	 * @param userID the user id
	 * @throws SQLException the sQL exception
	 */
	void deleteGiisUserTransaction(String userID) throws SQLException;
	
	/**
	 * Sets the giis user transaction.
	 * 
	 * @param user the new giis user transaction
	 * @throws SQLException the sQL exception
	 */
	void setGiisUserTransaction(GIISUser user) throws SQLException;
	
	/**
	 * Gets comm update tag by user
	 * 
	 * @param user The user. If null, then current user will be used.
	 * @return The Comm Update Tag.
	 * @throws SQLException the SQL Exception
	 */
	String getCommUpdateTag(String user) throws SQLException;
	
	String giacValidateUser(String userId, String functionCd, String moduleId) throws SQLException;
	
	/**
	 * Gets user access for module
	 * 
	 * @param module name
	 * @return access type
	 * @throws SQLException the SQL Exception
	 */
	String checkUserAccess(String moduleName) throws SQLException;
	
	/**
	 * Gets group issCd
	 * 
	 *
	 * @return group issCd
	 * @throws SQLException the SQL Exception
	 */
	
	/**
	 * Verify if user exist
	 * 
	 *
	 * @return boolean
	 * @throws SQLException the SQL Exception
	 */
	Map<String, Object> userOveride(Map<String, Object> params) throws SQLException;
	
	String checkIfUserAllowedForEdit(Map<String, Object> params) throws SQLException;
	
	void verifyUser(Map<String, Object> params) throws SQLException;
	
	Integer getUserGrp(String userId) throws SQLException;
	void resetPassword(Map<String, Object> params) throws SQLException;

	String getGroupIssCd(String userId) throws SQLException; 
	List<GIISUser> getUnderwriterForReassignQuote(Map<String, Object> params) throws SQLException;
	String checkUserAccess2(String moduleName, String userId) throws SQLException;
	String forgotPassValidateUser(String userId) throws SQLException; //benjo 02.01.2016 GENQA-SR-4941
	GIISUser getPasswordAndEmail(String userId) throws SQLException;
	Integer getUserLevel(String userId) throws SQLException;
	List<Map<String, Object>> getUserByIssCd(Map<String, Object> params)throws SQLException;
	Map<String, Object> validateUserGIEXS001(Map<String, Object> params) throws SQLException;
	String validateIfActiveUser(String userId) throws SQLException;
	String checkUserAccessGiuts008a(String moduleId) throws SQLException;
	String checkUserPerLineGiuts007(Map<String, Object> params) throws SQLException;
	String checkIssCdExistPerUserGiuts007(Map<String, Object> params) throws SQLException;
	
	List<GIISUser> getUserListing(Map<String, Object> params) throws SQLException;
	List<GIISUser> getAllUserListing(Map<String, Object> params) throws SQLException;
	
	String checkUserAccessGipis162(String moduleId) throws SQLException;	//shan 02.19.2013
	Map<String, Object> checkUserStat(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getHashingParameters() throws SQLException;
	void updatePassword(Map<String, Object> params) throws SQLException;
	Map<String, Object> getPwMeterParameters() throws SQLException;
	void savePwHist(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getPwHist(String userId) throws SQLException;
	void updateInvalidLoginTries(Map<String, Object> params) throws SQLException;
}
