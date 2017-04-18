/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import javax.mail.AuthenticationFailedException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.geniisys.common.dao.GIISUserDAO;
import com.geniisys.common.dao.GIISValidIPDAO;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.entity.GIISUserLine;
import com.geniisys.common.entity.GIISUserModules;
import com.geniisys.common.entity.GIISUserTran;
import com.geniisys.common.entity.GIISValidIP;
import com.geniisys.common.exceptions.AccountInactiveException;
import com.geniisys.common.exceptions.AccountLockedException;
import com.geniisys.common.exceptions.ExceedsAllowableLogException;
import com.geniisys.common.exceptions.ExpiredPasswordException;
import com.geniisys.common.exceptions.ExpiredTemporaryPasswordException;
import com.geniisys.common.exceptions.InvalidLoginException;
import com.geniisys.common.exceptions.InvalidUserLoginIPException;
import com.geniisys.common.exceptions.NoLastLoginException;
import com.geniisys.common.exceptions.NoPasswordException;
import com.geniisys.common.exceptions.NoSaltException;
import com.geniisys.common.exceptions.PasswordException;
import com.geniisys.common.exceptions.TemporaryAccountException;
import com.geniisys.common.exceptions.UnmatchedStringException;
import com.geniisys.common.exceptions.UseridAlreadyTakenException;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.common.service.GIISUserModulesService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.ContextParameters;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.MacAddress;
import com.geniisys.framework.util.Mailer;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.PasswordChecker;
import com.geniisys.framework.util.PasswordEncoder;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.framework.util.UserSessionListener;
import com.geniisys.giac.service.GIACModulesService;
import com.geniisys.gicl.service.GICLMcEvaluationService;
import com.seer.framework.db.DBSequenceUtil;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISUserFacadeServiceImpl.
 */
public class GIISUserFacadeServiceImpl implements GIISUserFacadeService {
	
	/** The giis user dao. */
	private GIISUserDAO giisUserDAO;
	
	/** The db sequence util. */
	private DBSequenceUtil dbSequenceUtil;
	
	/** The giis valid ip dao. */
	private GIISValidIPDAO giisValidIpDAO;
	
	/** The days before password expires. */
	private int daysBeforePasswordExpires;
	
	/** The days to deactivate account. */
	private int daysToDeactivateAccount;
	
	/** The no of login tries before lock. */
	private int noOfLoginTriesBeforeLock;
	private boolean ipValidation;
	private boolean concurrentLoginValidation;
	private int noOfAppPerUser;	
	private boolean macAddressValidation;
	
	/** added by alfie 01.19.2011 */
	private GIACModulesService giacModulesService;
	

	public boolean isIpValidation() {
		return ipValidation;
	}

	public void setIpValidation(boolean ipValidation) {
		this.ipValidation = ipValidation;
	}

	public boolean isConcurrentLoginValidation() {
		return concurrentLoginValidation;
	}

	public void setConcurrentLoginValidation(boolean concurrentLoginValidation) {
		this.concurrentLoginValidation = concurrentLoginValidation;
	}
	
	/**
	 * Gets the giis valid ip dao.
	 * 
	 * @return the giis valid ip dao
	 */
	public GIISValidIPDAO getGiisValidIpDAO() {
		return giisValidIpDAO;
	}

	/**
	 * Sets the giis valid ip dao.
	 * 
	 * @param giisValidIpDAO the new giis valid ip dao
	 */
	public void setGiisValidIpDAO(GIISValidIPDAO giisValidIpDAO) {
		this.giisValidIpDAO = giisValidIpDAO;
	}
	
	/**
	 * Gets the days to deactivate account.
	 * 
	 * @return the days to deactivate account
	 */
	public int getDaysToDeactivateAccount() {
		return daysToDeactivateAccount;
	}

	/**
	 * Sets the days to deactivate account.
	 * 
	 * @param daysToDeactivateAccount the new days to deactivate account
	 */
	public void setDaysToDeactivateAccount(int daysToDeactivateAccount) {
		this.daysToDeactivateAccount = daysToDeactivateAccount;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getNoOfLoginTriesBeforeLock()
	 */
	public int getNoOfLoginTriesBeforeLock() {
		return noOfLoginTriesBeforeLock;
	}

	/**
	 * Sets the no of login tries before lock.
	 * 
	 * @param noOfLoginTriesBeforeLock the new no of login tries before lock
	 */
	public void setNoOfLoginTriesBeforeLock(int noOfLoginTriesBeforeLock) {
		this.noOfLoginTriesBeforeLock = noOfLoginTriesBeforeLock;
	}

	/**
	 * Gets the days before password expires.
	 * 
	 * @return the days before password expires
	 */
	public int getDaysBeforePasswordExpires() {
		return daysBeforePasswordExpires;
	}

	/**
	 * Sets the days before password expires.
	 * 
	 * @param daysBeforePasswordExpires the new days before password expires
	 */
	public void setDaysBeforePasswordExpires(int daysBeforePasswordExpires) {
		this.daysBeforePasswordExpires = daysBeforePasswordExpires;
	}
	
	/**
	 * @return the giacModulesService
	 */
	public GIACModulesService getGiacModulesService() {
		return giacModulesService;
	}

	/**
	 * @param giacModulesService the giacModulesService to set
	 */
	public void setGiacModulesService(GIACModulesService giacModulesService) {
		this.giacModulesService = giacModulesService;
	}

	/** The log. */
	private static Logger log = Logger.getLogger(GIISUserFacadeServiceImpl.class);	
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#deleteGIISUser(com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void deleteGIISUser(GIISUser giisUser) throws SQLException {
		this.getGiisUserDAO().deleteGIISUser(giisUser);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getGiisUserAllList()
	 */
	@Override
	public List<GIISUser> getGiisUserAllList() throws SQLException {
		return giisUserDAO.getGiisUserAllList();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getGIISUser(java.lang.String)
	 */
	@Override
	public GIISUser getGIISUser(String userId) throws InvalidLoginException, Exception {
		GIISUser user = giisUserDAO.getGIISUser(userId);
		
		if(user == null){
			throw new InvalidLoginException("Invalid login credentials.");
		}
		
		if (userId != null && user.getEmailAdd() != null){
			user.setEmailAdd(PasswordEncoder.doDecrypt(user.getEmailAdd()));
		}		
		return user;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#saveGIISUser(com.geniisys.common.entity.GIISUser, java.lang.String)
	 */
	@Override
	public void saveGIISUser(GIISUser giisUser, String action) throws SQLException, UseridAlreadyTakenException {
		for (GIISUser user : getGiisUserAllList()) {
			if ("addUser".equals(action) && giisUser.getUserId().equalsIgnoreCase(user.getUserId())) {
				throw new UseridAlreadyTakenException("User id is already taken, input another.");
			}
		}
		giisUserDAO.saveGIISUser(giisUser);
	}

	private boolean validateUserLogin(GIISUser user, String password, String ip) throws AccountLockedException, InvalidUserLoginIPException, 
		InvalidLoginException, NoLastLoginException, SQLException, NoSuchAlgorithmException, AccountInactiveException, 
		PasswordException, NoPasswordException, IOException, ExceedsAllowableLogException, ExpiredTemporaryPasswordException, 
		NoSaltException, TemporaryAccountException, ExpiredPasswordException {

		boolean result = false;
		
		if (ContextParameters.ENABLE_MAC_VALIDATION.equals("Y")){
			log.info("Validating MAC Address of " + ip);
			// IP - 0:0:0:0:0:0:0:1 and 127.0.0.1 are for developers' localhost machine
			String macAddress = (ip.equals("0:0:0:0:0:0:0:1") || ip.equals("127.0.0.1") ? "DE-VE-LO-PE-RS" : MacAddress.getMacAddressByArp(ip));		
			log.info("MAC ADDRESS : " + macAddress);
			GIISValidIP validMacAddress = this.getGiisValidIpDAO().getValidUserByMacAddress(macAddress);			
			if (null != validMacAddress) {
				if (null == validMacAddress.getValidUserId() || user.getUserId().equals(validMacAddress.getValidUserId())) {
					result = this.validateUserAccount(user, password);
				} else {
					throw new InvalidUserLoginIPException("Invalid user login IP.");
				}
			} else {
				throw new InvalidUserLoginIPException("Invalid user login IP.");
			}
		} else {
			log.info("IP/Mac Address validation scheme disabled.");
			result = this.validateUserAccount(user, password);
		}
		
		return result;
	}
	
	private boolean validateUserAccount(GIISUser user, String password) throws AccountLockedException, AccountInactiveException, 
		NoLastLoginException, PasswordException, NoPasswordException, IOException, ExceedsAllowableLogException, 
		InvalidLoginException, ExpiredTemporaryPasswordException, NoSuchAlgorithmException, NoSaltException, 
		SQLException, TemporaryAccountException, ExpiredPasswordException {
		
		Boolean result = false;
		
		if (null != user) {
			log.info("Active Flag: " + user.getActiveFlag());
			
			if(user.getUnchangedPw().equals("Y") 
					&& (user.getResetPwDuration().compareTo(new BigDecimal(ContextParameters.NEW_PASSWORD_VALIDITY))) == 1) {
				throw new ExpiredTemporaryPasswordException("The generated password has expired.");
			} else if ("L".equals(user.getActiveFlag())) {
				throw new AccountLockedException("Account locked. Contact your administrator.");
			} else {
				if(checkUserPassword(user, password)){
					int passwordExpiry = ContextParameters.PASSWORD_EXPIRY - user.getDaysBeforePasswordExpires();
					log.info("Days before password expires: " + passwordExpiry);
					if ("N".equals(user.getTempAccessTag())) {
						throw new TemporaryAccountException("Account tagged as temporary. Contact your administrator.");
					} else if (passwordExpiry <= 0){						
						throw new ExpiredPasswordException("Password is expired.");
					} else if ("N".equals(user.getActiveFlag())) {
						throw new AccountInactiveException("Account inactive. Contact your administrator.");
					} else if ("FALSE".equals(this.giisUserDAO.validateIfActiveUser(user.getUserId()))) {						
						this.giisUserDAO.updateActiveFlag(user.getUserId(), "N");
						throw new AccountInactiveException("Account inactive. Contact your administrator.");
					} else {
						result = true;
					}
				}
			}
		} else {
			throw new InvalidLoginException("Invalid login credentials.");
		}
		
		return result;
	}
	
	private boolean checkUserPassword(GIISUser giisUser, String password) throws IOException, ExceedsAllowableLogException, 
		PasswordException, InvalidLoginException, NoPasswordException, NoSuchAlgorithmException, NoSaltException, 
		SQLException, NoLastLoginException{
		
		if (giisUser.getPassword() == null 
				&& giisUser.getSalt() == null 
				&& password.toUpperCase().equals(giisUser.getUserId().toUpperCase())
				&& giisUser.getMisSw().equals("Y")
				) {
			throw new NoPasswordException("User "+ giisUser.getUserId() +" must set password now.");
		}
				
		boolean isValid = PasswordEncoder.comparePassword(password, giisUser.getPassword(), giisUser.getSalt(), this.giisUserDAO.getHashingParameters());			
		if(isValid) {
			if (giisUser.getLastLogin() == null){
				throw new NoLastLoginException("User "+ giisUser.getUserId() +" must set new password now.");
			} else if (ContextParameters.ENABLE_CON_LOGIN_VALIDATION.equals("Y")){
				if (!validateAllowableAppPerUser(giisUser.getUserId())) {
					throw new ExceedsAllowableLogException("You have exceeded the maximum allowable concurrent logins.");
				}
			}
		} else {
			throw new InvalidLoginException("Invalid login credentials.");
		}
		
		return isValid;
	}
	
	/**
	 * Gets the giis user dao.
	 * 
	 * @return the giis user dao
	 */
	public GIISUserDAO getGiisUserDAO() {
		return giisUserDAO;
	}

	/**
	 * Sets the giis user dao.
	 * 
	 * @param giisUserDAO the new giis user dao
	 */
	public void setGiisUserDAO(GIISUserDAO giisUserDAO) {
		this.giisUserDAO = giisUserDAO;
	}

	/**
	 * Gets the db sequence util.
	 * 
	 * @return the db sequence util
	 */
	public DBSequenceUtil getDbSequenceUtil() {
		return dbSequenceUtil;
	}

	/**
	 * Sets the db sequence util.
	 * 
	 * @param dbSequenceUtil the new db sequence util
	 */
	public void setDbSequenceUtil(DBSequenceUtil dbSequenceUtil) {
		this.dbSequenceUtil = dbSequenceUtil;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getUserPassword(java.lang.String, java.lang.String)
	 */
	@Override
	public GIISUser getUserPassword(String userId, String emailAddress)
			throws Exception {
		return this.getGiisUserDAO().getUserPassword(userId, emailAddress);
	}

	/* benjo 02.01.2016 GENQA-SR-4941 */
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#updateActiveFlag(java.lang.String, java.lang.String)
	 */
	@Override
	public String forgotPassValidateUser(String userId) throws SQLException {
		return this.getGiisUserDAO().forgotPassValidateUser(userId);
	}
	
	public GIISUser getPasswordAndEmail(String userId) throws SQLException {
		return this.getGiisUserDAO().getPasswordAndEmail(userId);
	}	
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#updateActiveFlag(java.lang.String, java.lang.String)
	 */
	@Override
	public void updateActiveFlag(String userId, String activeFlag)
			throws SQLException {
		this.getGiisUserDAO().updateActiveFlag(userId, activeFlag);
	}

	// Update all passwords at a time when the secret key is changed
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#updatePassword()
	 */
	@Override
	public void updatePassword() throws SQLException {
		List<GIISUser> users = giisUserDAO.getGiisUsersList(new HashMap<String, Object>());
		for(GIISUser user: users) {
			try {
				this.getGiisUserDAO().updatePassword(user.getUserId(), PasswordEncoder.doEncrypt(user.getPassword()));
			} catch (Exception e) {
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}
		}
	}
	

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#updatePassword(com.geniisys.common.entity.GIISUser, java.lang.String, java.lang.String)
	 */
	@Override
	public void updatePassword(GIISUser user, String newPassword, String oldPassword)
			throws SQLException, UnmatchedStringException, Exception {
		if (user.getPassword() != null && !user.getPassword().equals(PasswordEncoder.doEncrypt(oldPassword))) {
			throw new UnmatchedStringException("Invalid old password.");
		}
		this.getGiisUserDAO().updatePassword(user.getUserId(), PasswordEncoder.doEncrypt(newPassword));
	}
	
	public void updatePassword(String userId, String newPassword) throws PasswordException, SQLException, Exception {		
		if(this.validatePassword(newPassword, userId)){			
			Map<String, Object> params = this.hashPassword(newPassword);
			params.put("userId", userId);
			this.getGiisUserDAO().updatePassword(params);
			this.getGiisUserDAO().savePwHist(params);
			//this.getGiisUserDAO().updatePassword(userId, PasswordEncoder.doEncrypt(newPassword));
		}
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#updateLastLogin(java.lang.String)
	 */
	@Override
	public void updateLastLogin(String userId) throws SQLException {
		this.getGiisUserDAO().updateLastLogin(userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#deactivateInactiveUsers()
	 */
	@Override
	public void deactivateInactiveUsers() throws SQLException {
		this.getGiisUserDAO().deactivateInactiveUsers(getDaysToDeactivateAccount());
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getGiisUsersList(java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGiisUsersList(Map<String, Object> params) throws SQLException {
		int pageNo = (Integer) params.get("pageNo");
		List<GIISUser> users =  this.getGiisUserDAO().getGiisUsersList(params);
		PaginatedList paginatedList = new PaginatedList(users, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo-1);
		return paginatedList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#checkSamePassword(java.lang.String, java.lang.String)
	 */
	@Override
	public boolean checkSamePassword(String userId, String password)
			throws UnmatchedStringException, Exception {
		GIISUser u = getGIISUser(userId);
		//System.out.println("Password: " + password);
		//System.out.println("User Password: " + u.getPassword());
		if (password.equals(PasswordEncoder.doDecrypt(u.getPassword()))) {
			throw new UnmatchedStringException("Old and new password cannot be the same.");
		}
		return false;
	}
	
	public boolean checkOldPassword(String userId, String password)
			throws UnmatchedStringException, Exception {
		GIISUser u = getGIISUser(userId);
		
		if (!password.equals(PasswordEncoder.doDecrypt(u.getPassword()))){
			throw new UnmatchedStringException("Current password is incorrect.");
		}
		return false;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#setUserTransaction(java.util.Map)
	 */
	@Override
	public void setUserTransaction(Map<String, Object> params) throws SQLException {
		log.info("Service preparing user details for saving...");
		String userID = (String) params.get("userID");
		String userId = (String) params.get("userId");
		
		String[] pTransactions = (String[]) params.get("pTransactions");
		String[] pModules = (String[]) params.get("pModules");
		String[] pIssSources = (String[]) params.get("pIssSources");
		String[] pLines = (String[]) params.get("pLines");
		
		GIISUser user = new GIISUser(userID);
		user.setTransactions(new ArrayList<GIISUserTran>());
		GIISUserTran userTran = null;
		for (int i=0; i<pTransactions.length; i++) {
			if (pTransactions[i] != ""){
				int tranCd = Integer.parseInt(pTransactions[i]); //added by angelo
				userTran = new GIISUserTran(userID, tranCd, "Y", userId);
				
				String[] issSources = pIssSources[i].split(",");
				String[] modules = pModules[i].split(",");
				
				List<GIISUserIssCd> issList = new ArrayList<GIISUserIssCd>();
				
				if (i < pLines.length){ //remedy to avoid array out of bounds exception
					String[] pplines = pLines[i].split("--");
					for (int j=0; j<issSources.length; j++) {
						if (!issSources[j].equals("void")){ //added by angelo
							List<GIISUserLine> lines = new ArrayList<GIISUserLine>();
							if (j < pplines.length) {
								String[] tLines = pplines[j].split(",");
								
								for (int k=0; k<tLines.length; k++) {
									if (!tLines[k].equals("void")) {
										lines.add(new GIISUserLine(userID, tranCd, issSources[j], tLines[k], userId));
									}
								}
								
								GIISUserIssCd issSource = new GIISUserIssCd(userID, tranCd, issSources[j], userId, lines);
								issList.add(issSource);
							}
						}
					}
				}
	
				List<GIISUserModules> userModules = new ArrayList<GIISUserModules>();
				for (String m: modules) {
					if (!m.equals("void")){ //added by angelo
						userModules.add(new GIISUserModules(userID, m, "", "1", tranCd, userId)); //marco - 05.23.2013 - added default accessTag (1)
					}
				}
				
				userTran.setModules(userModules);
				userTran.setIssSources(issList);
				user.getTransactions().add(userTran);
			}
			
			log.info("Service calling DAO to delete user grp hdr details...");
			this.getGiisUserDAO().deleteGiisUserTransaction(userID);
			log.info("Deletion of transactions successful!");
			
			log.info("Service calling DAO to save user grp hdr...");
			this.getGiisUserDAO().setGiisUserTransaction(user);
			log.info("Saving of transactions successful!");
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getCommUpdateTag(java.lang.String)
	 */
	@Override
	public String getCommUpdateTag(String user) throws SQLException {
		String result = null;
		
		/*
		 * NOTE: (String) and not .toString(). To handle null value.
		 */
		result = this.getGiisUserDAO().getCommUpdateTag(user);		
		
		return result;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#giacValidateUser(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String giacValidateUser(String userId, String functionCd, String moduleId) throws SQLException {
		return this.getGiisUserDAO().giacValidateUser(userId, functionCd, moduleId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#checkUserAccess(java.lang.String)
	 */
	@Override
	public int checkUserAccess(String moduleName) throws SQLException {
		return Integer.parseInt(this.getGiisUserDAO().checkUserAccess(moduleName));
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getGroupIssCd()
	 */
	@Override
	public String getGroupIssCd(String userId) throws SQLException {
		return this.getGiisUserDAO().getGroupIssCd(userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#userOveride(java.util.Map)
	 */
	@Override
	public Map<String, Object> userOveride(Map<String, Object> params) 
			throws SQLException, Exception {
		
		Map<String, Object> returnParams = new HashMap<String, Object>();
		try {
			GIISUser user = this.getGIISUser(params.get("user").toString());
			if (this.validateUserAccount(user, params.get("password").toString())) {
				returnParams.put("message", this.getGiacModulesService().validateUserFunc(params));
			}else{
				returnParams.put("message", "Invalid username/password.");
			}
		} catch (ExceedsAllowableLogException e){
			returnParams.put("message", e.getMessage());
		} catch (NoLastLoginException e){
			returnParams.put("message", e.getMessage());
		} catch (AccountLockedException e) {
			returnParams.put("message", e.getMessage());
		} catch (AccountInactiveException e) {
			returnParams.put("message", e.getMessage());
		} catch (NullPointerException e) {
			returnParams.put("message", "Invalid username/password.");
		}
		return returnParams;
	}
	
	public String checkIfUserAllowedForEdit(Map<String, Object> params) throws SQLException{
		return this.getGiisUserDAO().checkIfUserAllowedForEdit(params);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#verifyUser(java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String verifyUser(String username, String password, String database)
			throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		params.put("password", password);
		params.put("dbstring", database);
		this.getGiisUserDAO().verifyUser(params);
		return params.get("message").toString();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getUserGrp(java.lang.String)
	 */
	@Override
	public Integer getUserGrp(String userId) throws SQLException {
		return this.getGiisUserDAO().getUserGrp(userId);
	}

	public void setNoOfAppPerUser(int noOfAppPerUser) {
		this.noOfAppPerUser = noOfAppPerUser;
	}

	public int getNoOfAppPerUser() {
		return noOfAppPerUser;
	}
	
	/**
	 * 
	 * @param userId
	 * @return
	 * @throws IOException
	 */
	public boolean validateAllowableAppPerUser(String userId) throws IOException {		
		Integer noOfLog = UserSessionListener.getActiveLoginCount(userId);
		log.info("Validating allowable concurrent login per user. There are " +noOfLog+ " active login for user " + userId);
		//if(noOfLog >= noOfAppPerUser){
		if(noOfLog >= ContextParameters.NO_OF_APP_PER_USER){
			return false;
		}
		return true;
	}
	
	public String resetPassword(HttpServletRequest request) throws SQLException, Exception {	
		String userId = request.getParameter("userId");
		String lastUserId = request.getParameter("lastUserId");
		String userName = request.getParameter("userName");
		String mode = request.getParameter("mode");
		String[] emailAddress = request.getParameterValues("emailAddress");
		
		String password = this.generatePassword();	
			
		Map<String, Object> params = this.hashPassword(password);
		params.put("userId", userId);
		params.put("lastUserId", lastUserId);
		this.getGiisUserDAO().resetPassword(params);
		this.updateInvalidLoginTries(userId, 0);
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(request.getServletContext());
		
		if(ContextParameters.ENABLE_EMAIL_NOTIFICATION == null || ContextParameters.ENABLE_EMAIL_NOTIFICATION.equals("Y")){
			Mailer mailer = (Mailer) APPLICATION_CONTEXT.getBean("mailer");			
			mailer.setEmailSubjectText("Your Geniisys Account Password Has Been " + (mode.equals("generate") ? "Generated" : "Reset"));
			mailer.setEmailMsgText("Dear "+userName+","
									+"\r\n\r\nThe password of your Geniisys account has been " + (mode.equals("generate") ? "generated." : "reset.")
									+"\r\nYou may now access your account using your new password:"
									+"\r\n\r\n"+password
									+"\r\n\r\nPlease be advised that this password will expire after " 
									+ ContextParameters.NEW_PASSWORD_VALIDITY + " hours."
									+ "\r\n\r\nTHIS IS A SYSTEM GENERATED EMAIL. PLEASE DO NOT REPLY TO THIS.");
			
			try {
				mailer.sendMail(emailAddress);
			} catch(AuthenticationFailedException e){
				ExceptionHandler.logException(e);
				throw new AuthenticationFailedException("Geniisys Exception#I#Your password has been reset but the system was unable to send email notification due to authentication problem. Please contact your system administrator.");
			}
		}
		
		log.info(userId + "'s password had been reset by " + lastUserId);
		
		return password;
	}
	
	public String generatePassword() {
		String letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		String numbers = "0123456789";
		String specialCharacters = "!@#$%^&*()_+<>?";
		
		Random random = new Random();
		StringBuilder sb = new StringBuilder(12);
		
		for(int i = 0; i < 4; i++) {
			sb.append(letters.charAt(random.nextInt(letters.length())));
			sb.append(numbers.charAt(random.nextInt(numbers.length())));
			sb.append(specialCharacters.charAt(random.nextInt(specialCharacters.length())));
		}
		
		List<String> l = Arrays.asList(sb.toString().split(""));		
		Collections.shuffle(Arrays.asList(sb.toString().split("")));
		
		sb.setLength(0);
		
		for (String a : l)
			sb.append(a);
		
		return sb.toString();
	}
	
	public void setMacAddressValidation(boolean macAddressValidation) {
		this.macAddressValidation = macAddressValidation;
	}

	public boolean isMacAddressValidation() {
		return macAddressValidation;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getUnderwriterForReassignQuote(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void getUnderwriterForReassignQuote(
			Map<String, Object> params) throws SQLException, JSONException {
		log.info("Retrieving underwriters ...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());		
		List<GIISUser> underwriters = this.getGiisUserDAO().getUnderwriterForReassignQuote(params);
		
		params.put("rows", new JSONArray((List<GIISUser>) StringFormatter.replaceQuotesInList(underwriters)));		
		grid.setNoOfPages(underwriters);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		log.info("Underwriters retireved ...");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#checkUserAccess2(java.lang.String, java.lang.String)
	 */
	@Override
	public String checkUserAccess2(String module, String userId)
			throws SQLException {
		return this.getGiisUserDAO().checkUserAccess2(module, userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getUserLevel(java.lang.String)
	 */
	@Override
	public Map<String, Object> getUserLevel(String userId) throws SQLException {
		Integer userLevel = this.getGiisUserDAO().getUserLevel(userId);
		Map<String, Object> params = new HashMap<String, Object>();
		if (userLevel == 0){
			params.put("message", "Your User ID does not correspond to any user level.");
			params.put("userLevel", userLevel);
		}else{
			params.put("message", "");
			params.put("userLevel", userLevel);
		}
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#getUserByIssCd(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getUserByIssCd(Map<String, Object> params) throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		//params.put("filter", this.prepareClaimListDetailFilter((String) params.get("filter")));
		List<Map<String, Object>> userList = this.getGiisUserDAO().getUserByIssCd(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(userList)));
		grid.setNoOfPages(userList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}
	
	@Override
	public Map<String, Object> validateUserGIEXS001(Map<String, Object> params)
			throws SQLException {
		return this.getGiisUserDAO().validateUserGIEXS001(params);
	}

	@Override
	public Map<String, Object> userOveride2(Map<String, Object> params)
			throws Exception, SQLException, AccountLockedException,
			AccountInactiveException {
		Map<String, Object> returnParams = new HashMap<String, Object>();
		try {
			GIISUser user = this.getGIISUser(params.get("user").toString());
			if (this.validateUserAccount(user, params.get("password").toString())) {
				returnParams.put("message", this.getGiacModulesService().validateUserFunc2(params));
			}else{
				returnParams.put("message", "Invalid username/password.");
			}
		} catch (ExceedsAllowableLogException e){
			returnParams.put("message", e.getMessage());
		} catch (NoLastLoginException e){
			returnParams.put("message", e.getMessage());
		} catch (AccountLockedException e) {
			returnParams.put("message", e.getMessage());
		} catch (AccountInactiveException e) {
			returnParams.put("message", e.getMessage());
		} catch (NullPointerException e) {
			returnParams.put("message", "Invalid username/password.");
		}
		return returnParams;
	}
	
	public String validateOverrideUser(HttpServletRequest request)
			throws Exception, SQLException, AccountLockedException,
			AccountInactiveException {
		String message = null;
		try {
			GIISUser user = this.getGIISUser(request.getParameter("userId"));
			if (this.validateUserAccount(user, request.getParameter("password"))) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", request.getParameter("userId"));
				params.put("moduleName", request.getParameter("moduleId"));
				params.put("funcCode", request.getParameter("functionCode"));
				message = this.getGiacModulesService().validateUserFunc3(params);
			} else {
				message = "Invalid username/password.";
			}
		} catch (ExceedsAllowableLogException e) {
			ExceptionHandler.logException(e);
			message = e.getMessage();
		} catch (NoLastLoginException e) {
			ExceptionHandler.logException(e);
			message = e.getMessage();
		} catch (AccountLockedException e) {
			ExceptionHandler.logException(e);
			message = e.getMessage();
		} catch (AccountInactiveException e) {
			ExceptionHandler.logException(e);
			message = e.getMessage();
		} catch (NullPointerException e) {
			ExceptionHandler.logException(e);
			message = "Invalid username/password.";
		}
		return message;
	}	

	@Override
	public Map<String, Object> userOverideMCEval(Map<String, Object> params)
			throws Exception, SQLException, AccountLockedException,
			AccountInactiveException {
		Map<String, Object> returnParams = new HashMap<String, Object>();
		try {
			GIISUser user = this.getGIISUser(params.get("userId").toString());
			if (this.validateUserAccount(user, params.get("password").toString())) {
				GICLMcEvaluationService service = (GICLMcEvaluationService) params.get("giclMcEvaluationService");
				returnParams.put("message", service.validateOverrideUserMcEval(params));
			}else{
				returnParams.put("message", "Invalid username/password.");
			}
		} catch (ExceedsAllowableLogException e){
			returnParams.put("message", e.getMessage());
		} catch (NoLastLoginException e){
			returnParams.put("message", e.getMessage());
		} catch (AccountLockedException e) {
			returnParams.put("message", e.getMessage());
		} catch (AccountInactiveException e) {
			returnParams.put("message", e.getMessage());
		} catch (NullPointerException e) {
			returnParams.put("message", "Invalid username/password.");
		}
		return returnParams;
	}

	@Override
	public String checkUserAccessGiuts008a(String moduleId) throws SQLException {
		return this.getGiisUserDAO().checkUserAccessGiuts008a(moduleId);
	}
	
	public String checkUserPerLineGiuts007(Map<String, Object> params) throws SQLException{
		return this.getGiisUserDAO().checkUserPerLineGiuts007(params);
	}

	public String checkIssCdExistPerUserGiuts007(Map<String, Object> params)throws SQLException {
		return this.getGiisUserDAO().checkIssCdExistPerUserGiuts007(params);
	}

	@Override
	public List<GIISUser> getUserListing(Map<String, Object> params) throws SQLException {
		return this.getGiisUserDAO().getUserListing(params);
	}

	@Override
	public List<GIISUser> getAllUserListing(Map<String, Object> params)	throws SQLException {
		return this.getGiisUserDAO().getAllUserListing(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserFacadeService#checkUserAccessGipis162(java.lang.String)
	 */
	@Override
	public String checkUserAccessGipis162(String moduleId, String userId) throws SQLException {
		//return this.getGiisUserDAO().checkUserAccessGipis162(moduleId);	// shan 07.08.2014
		return this.getGiisUserDAO().checkUserAccess2(moduleId, userId);
	}

	@Override
	public Map<String, Object> checkUserStat(Map<String, Object> params) throws SQLException {
		return this.getGiisUserDAO().checkUserStat(params);
	}

	@Override
	public Map<String, Object> hashPassword(String password) throws SQLException, NumberFormatException, NoSuchAlgorithmException {
		Map<String, Object> params = this.getGiisUserDAO().getHashingParameters();		
		
		byte[] salt = PasswordEncoder.generateSalt(Integer.parseInt(params.get("SALT_BYTE_SIZE").toString())); 
		byte[] hash = PasswordEncoder.createHash(password, params.get("ALGORITHM").toString(), salt,
				Integer.parseInt(params.get("NO_OF_ITERATIONS").toString()));		
		
		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("salt", PasswordEncoder.toBase64(salt));
		map.put("password", PasswordEncoder.toBase64(hash));
		
		return map;
	}

	@Override
	public Map<String, Object> getHashingParameters() throws SQLException {
		return this.giisUserDAO.getHashingParameters();
	}

	@Override
	public boolean validatePassword(String password, String userId) throws SQLException, PasswordException, NoSuchAlgorithmException, IOException, NoSaltException {
		boolean isValid = true;
		Map<String, Object> params = this.giisUserDAO.getPwMeterParameters();
		params.put("password", password);
		
		if(PasswordChecker.validatePassword(params)) {
			isValid = true;
			if(params.get("NO_OF_PREV_PW_TO_STORE").toString() != "0") {
				List<Map<String, Object>> l = this.giisUserDAO.getPwHist(userId);
				Map<String, Object> hashingParams = this.giisUserDAO.getHashingParameters();
				
				for(Map<String, Object> m : l) {
					if(PasswordEncoder.comparePassword(password, m.get("password").toString(), m.get("salt").toString(), hashingParams))
						throw new PasswordException("Invalid password. Please do not reuse your last " + params.get("NO_OF_PREV_PW_TO_STORE").toString() + " password(s).");
				}
			}
		} else
			isValid = false;
		
		return isValid;
	}

	@Override
	public String forgotPassword(HttpServletRequest request) throws SQLException, Exception {
		String message = "Your password has been sent!";
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(request.getServletContext());
		Mailer mailer = (Mailer) APPLICATION_CONTEXT.getBean("mailer");
		String userId = request.getParameter("username");
		
		if (request.getParameter("validate").equals("Y")){
			message = this.forgotPassValidateUser(userId);
		} else {
			String password = this.generatePassword();
			String lastUserId = request.getParameter("lastUserId");
			
			mailer.setEmailSubjectText("Your Geniisys Account Password Has Been Reset");
			GIISUser user = this.getPasswordAndEmail(userId);
			List<String> emailAddress = new ArrayList<String>();
			emailAddress.add(PasswordEncoder.doDecrypt(user.getEmailAdd()));
			log.info("Forgot Password feature is used by " + userId + " with email " + emailAddress.get(0));
			
			Map<String, Object> params = this.hashPassword(password);
			params.put("userId", userId);
			params.put("lastUserId", lastUserId);
			String userName = user.getUsername();
			this.getGiisUserDAO().resetPassword(params);
			this.updateInvalidLoginTries(userId, 0);
			
			mailer.setEmailMsgText("Dear "+userName+","
									+"\r\n\r\nThe password of your Geniisys account has been reset."
									+"\r\nYou may now access your account using your new password:"
									+"\r\n\r\n"+password
									+"\r\n\r\nPlease be advised that this password will expire after " 
									+ ContextParameters.NEW_PASSWORD_VALIDITY + " hours."
									+ "\r\n\r\nTHIS IS A SYSTEM GENERATED EMAIL. PLEASE DO NOT REPLY TO THIS.");
			
			mailer.setRecepientList(emailAddress);
			try {
				mailer.sendMailWithAttachments();
			} catch(AuthenticationFailedException e){
				ExceptionHandler.logException(e);
				message = "Geniisys Exception#I#Your password has been reset but the system was unable to send email notification due to authentication problem. Please contact your system administrator.";
			}
		}
		
		return message;
	}

	@SuppressWarnings({ "unchecked"})
	@Override
	public void userLogin(HttpServletRequest request) throws SQLException, NoSaltException, AccountLockedException,
			TemporaryAccountException, ExpiredPasswordException, AccountInactiveException, InvalidUserLoginIPException,
			NoPasswordException, NoLastLoginException, ExceedsAllowableLogException, PasswordException, 
			InvalidLoginException, Exception {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(request.getServletContext());
		
		HttpSession session = request.getSession();
		session.removeAttribute("PARAMETERS");		
		String userId = request.getParameter("userId");
		String password = request.getParameter("password");

		String message = request.getParameter("message");
		
		log.info("Login tries: " + request.getParameter("timesFailed"));
		
		GIISUser user = this.getGIISUser(userId);
		
		if(user == null){
			throw new InvalidLoginException("Invalid login credentials.");
		} else {
			try {
				this.validateUserLogin(user, password, request.getRemoteAddr());
	
				Integer passwordExpiry = ContextParameters.PASSWORD_EXPIRY - user.getDaysBeforePasswordExpires();
	
				DriverManagerDataSource dataSource = (DriverManagerDataSource) appContext.getBean("dataSource");
				String database = dataSource.getUrl().substring(dataSource.getUrl().lastIndexOf(":")+1, dataSource.getUrl().length());
				
				Map<String, Object> sessionParameters = (Map<String, Object>) session.getAttribute("PARAMETERS");	
				sessionParameters = new HashMap<String,Object>();
				sessionParameters.put("USER", user);
				sessionParameters.put("userId", userId);
				//SESSION_PARAMETERS.put("password", password);
				sessionParameters.put("username", user.getUsername());
				sessionParameters.put("message", message);
				sessionParameters.put("database", database);
				sessionParameters.put("invalidLoginTries", user.getInvalidLoginTries());
				sessionParameters.put("itemTablegridSw", ContextParameters.ITEM_TABLEGRID_SW); // temporary - andrew 05.03.2012
				sessionParameters.put("endtBasicInfoSw", ContextParameters.ENDT_BASIC_INFO_SW); // temporary - andrew 05.03.2012
				session.setAttribute("PARAMETERS", sessionParameters);
				
				// get user accessible modules
				GIISUserModulesService userModulesService = (GIISUserModulesService) appContext.getBean("giisUserModulesService");
				session.setAttribute("modules", userModulesService.getGiisUserModulesList(userId));
				
				// update last_login column of user
				log.info("Updating last login of " + user.getUserId());
				this.updateLastLogin(user.getUserId());
				
				request.setAttribute("passwordExpiry", passwordExpiry);
				this.updateInvalidLoginTries(user.getUserId(), 0);
				message = "SUCCESS";
			} catch(InvalidLoginException e) {			
				if(user != null) {
					Integer invalidLoginTries = 0;
					invalidLoginTries = user.getInvalidLoginTries() + 1;
					
					if (invalidLoginTries >= ContextParameters.NO_OF_LOGIN_TRIES) {
						this.updateActiveFlag(userId, GIISUserFacadeService.LOCKED);
						this.updateInvalidLoginTries(user.getUserId(), invalidLoginTries);
						throw new AccountLockedException("Account locked! Contact your administrator.");
					} else {
						this.updateInvalidLoginTries(user.getUserId(), invalidLoginTries);
						throw e;
					}
				}
			}
		}
	}

	private void updateInvalidLoginTries(String userId, Integer invalidLoginTries) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("invalidLoginTries", invalidLoginTries);
		params.put("userId", userId);
		System.out.println("Updating invalid login tries: " + params);
		this.giisUserDAO.updateInvalidLoginTries(params);
	}
}