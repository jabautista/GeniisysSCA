/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.exceptions.AccountInactiveException;
import com.geniisys.common.exceptions.AccountLockedException;
import com.geniisys.common.exceptions.ExceedsAllowableLogException;
import com.geniisys.common.exceptions.ExpiredPasswordException;
import com.geniisys.common.exceptions.InvalidUserLoginIPException;
import com.geniisys.common.exceptions.NoLastLoginException;
import com.geniisys.common.exceptions.NoPasswordException;
import com.geniisys.common.exceptions.NoSaltException;
import com.geniisys.common.exceptions.PasswordException;
import com.geniisys.common.exceptions.TemporaryAccountException;
import com.geniisys.common.exceptions.UnmatchedStringException;
import com.geniisys.common.exceptions.UseridAlreadyTakenException;
import com.geniisys.framework.util.PaginatedList;


/**
 * The Interface GIISUserFacadeService.
 */
public interface GIISUserFacadeService {

	/** The Constant LOCKED. */
	static final String LOCKED = "L";
	
	/** The Constant INACTIVE. */
	static final String INACTIVE = "N";
	
	/** The Constant ACTIVE. */
	static final String ACTIVE = "Y";
	
	/**
	 * Gets the giis user all list.
	 * 
	 * @return the giis user all list
	 * @throws SQLException the sQL exception
	 */
	List<GIISUser> getGiisUserAllList() throws SQLException;
	
	/**
	 * Gets the gIIS user.
	 * 
	 * @param userId the user id
	 * @return the gIIS user
	 * @throws Exception the exception
	 */
	GIISUser getGIISUser(String userId) throws Exception;
	
	/**
	 * Gets the giis users list.
	 * 
	 * @param params the params
	 * @return the giis users list
	 * @throws SQLException the sQL exception
	 */
	PaginatedList getGiisUsersList(Map<String, Object> params) throws SQLException;
	
	/**
	 * Save giis user.
	 * 
	 * @param giisUser the giis user
	 * @param action the action
	 * @throws SQLException the sQL exception
	 * @throws UseridAlreadyTakenException the userid already taken exception
	 */
	void saveGIISUser(GIISUser giisUser, String action) throws SQLException, UseridAlreadyTakenException;
	//void updateGIISUser(GIISUser giisUser)throws SQLException;
	/**
	 * Delete giis user.
	 * 
	 * @param giisUser the giis user
	 * @throws SQLException the sQL exception
	 */
	void deleteGIISUser(GIISUser giisUser) throws SQLException;
	
	GIISUser getUserPassword(String userId, String emailAddress) throws SQLException, Exception;
	void updateActiveFlag(String userId, String activeFlag) throws SQLException;
	void updatePassword() throws SQLException;
	void updatePassword(GIISUser user, String newPassword, String oldPassword) throws SQLException, UnmatchedStringException, Exception;	
	void updatePassword(String userId, String newPassword) throws SQLException, Exception;
	int getNoOfLoginTriesBeforeLock();
	void updateLastLogin(String userId) throws SQLException;
	void deactivateInactiveUsers() throws SQLException;
	boolean checkSamePassword(String userId, String password) throws UnmatchedStringException, Exception;	
	boolean checkOldPassword(String userId, String password) throws UnmatchedStringException, Exception;
	void setUserTransaction(Map<String, Object> params) throws SQLException;
	String getCommUpdateTag(String user) throws SQLException;
	String giacValidateUser(String userId, String functionCd, String moduleId) throws SQLException;
	int checkUserAccess(String moduleName) throws SQLException;
	String getGroupIssCd(String userId) throws SQLException;
	Map<String, Object> userOveride(Map<String, Object> params) throws Exception, SQLException, AccountLockedException, AccountInactiveException;
	String checkIfUserAllowedForEdit(Map<String, Object> params) throws SQLException;
	String verifyUser(String username, String password, String database) throws SQLException;
	Integer getUserGrp(String userId) throws SQLException;
	String resetPassword(HttpServletRequest request) throws SQLException, Exception;
	String generatePassword();
	void getUnderwriterForReassignQuote(Map<String, Object> params) throws SQLException, JSONException;
	String checkUserAccess2(String module, String userId) throws SQLException;
	String forgotPassValidateUser(String userId) throws SQLException; //benjo 02.01.2016 GENQA-SR-4941
	GIISUser getPasswordAndEmail(String userId) throws SQLException;
	Map<String, Object> getUserLevel(String userId) throws SQLException;
	Map<String, Object> getUserByIssCd(Map<String, Object> params)throws SQLException;
	Map<String, Object> validateUserGIEXS001(Map<String, Object> params) throws SQLException;
	Map<String, Object> userOveride2(Map<String, Object> params) throws Exception, SQLException, AccountLockedException, AccountInactiveException;
	Map<String, Object> userOverideMCEval(Map<String, Object> params) throws Exception, SQLException, AccountLockedException, AccountInactiveException;
	String validateOverrideUser(HttpServletRequest request) throws Exception, SQLException, AccountLockedException, AccountInactiveException;
	String checkUserAccessGiuts008a(String moduleId) throws SQLException;
	String checkUserPerLineGiuts007(Map<String, Object> params) throws SQLException;
	String checkIssCdExistPerUserGiuts007(Map<String, Object> params) throws SQLException;
	
	List<GIISUser> getUserListing(Map<String, Object> params) throws SQLException;
	List<GIISUser> getAllUserListing(Map<String, Object> params) throws SQLException;
	
	String checkUserAccessGipis162(String moduleId, String userId) throws SQLException;
	Map<String, Object> checkUserStat(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> hashPassword(String password) throws SQLException, NumberFormatException, NoSuchAlgorithmException;
	Map<String, Object> getHashingParameters() throws SQLException;
	
	boolean validatePassword(String password, String userId) throws SQLException, PasswordException, NoSuchAlgorithmException, IOException, NoSaltException;
	String forgotPassword(HttpServletRequest request) throws SQLException, Exception;
	void userLogin(HttpServletRequest request) throws SQLException, NoSaltException, AccountLockedException,
			TemporaryAccountException, ExpiredPasswordException, AccountInactiveException, InvalidUserLoginIPException,
			NoPasswordException, NoLastLoginException, ExceedsAllowableLogException, PasswordException, Exception;

}
