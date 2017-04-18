/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserIssCd;
import com.geniisys.common.exceptions.PasswordException;
import com.geniisys.common.exceptions.UnmatchedStringException;
import com.geniisys.common.exceptions.UseridAlreadyTakenException;
import com.geniisys.common.service.GIISGrpIsSourceService;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISModuleService;
import com.geniisys.common.service.GIISTransactionService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.common.service.GIISUserGrpHdrService;
import com.geniisys.common.service.GIISUserGrpHistService;
import com.geniisys.common.service.GIISUserIssCdService;
import com.geniisys.common.service.GIISUserLineService;
import com.geniisys.common.service.GIISUserModulesService;
import com.geniisys.common.service.GIISUserTranService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.PasswordEncoder;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIISUserMaintenanceController.
 */
public class GIISUserMaintenanceController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6063681229625756660L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISUserController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@SuppressWarnings({"deprecation"})
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		/*end of default attributes*/

		// services needed
		GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService"); // +env
		
		// local variable declaration

		try {
			if ("showUserListing".equals(ACTION)) {
				PAGE = "/pages/security/user/userListing.jsp";
			} else if ("getUserList".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("keyword", request.getParameter("keyword"));
				params.put("activeFlag", request.getParameter("activeFlag"));
				params.put("commUpdateTag", request.getParameter("commUpdateTag"));
				params.put("allUserSw", request.getParameter("allUserSw"));
				params.put("managerSw", request.getParameter("managerSw"));
				params.put("marketingSw", request.getParameter("marketingSw"));
				params.put("misSw", request.getParameter("misSw"));
				params.put("workflowTag", request.getParameter("workflowTag"));
				params.put("pageNo", new Integer(request.getParameter("pageNo")));

				PaginatedList users = userService.getGiisUsersList(params);
				request.setAttribute("searchResult", users);
				request.setAttribute("pageNo", users.getPageIndex()+1);
				request.setAttribute("noOfPages", users.getNoOfPages());
				PAGE = "/pages/security/user/subPages/userListingTable.jsp";
			} else if ("changePasswordForm".equals(ACTION)) {
				request.setAttribute("userId", request.getParameter("userId"));
				request.setAttribute("action", "changePassword");				
				PAGE = "/pages/security/user/changePassword.jsp";
			} else if ("showChangePassword".equals(ACTION)) {
				request.setAttribute("userId", request.getParameter("userId"));
				if(request.getParameter("noPassword").equals("true")){
					request.setAttribute("action", "setNoPassword");
				} else if(request.getParameter("changePasswordForExpiry").equals("true")){
					request.setAttribute("action", "changePasswordForExpiry");
				} else {
					request.setAttribute("action", "firstLoginChangePassword");
				}
				PAGE = "/pages/security/user/changePassword.jsp";
			} /* else if ("firstLoginChangePassword".equals(ACTION)) {
				String userId = request.getParameter("userId");
				String newPassword = request.getParameter("newPassword");
				String oldPassword = request.getParameter("oldPassword");
							
				if (!userService.checkSamePassword(userId, newPassword) && !userService.checkOldPassword(userId, oldPassword)) {
					userService.updatePassword(userId, newPassword);
					userService.updateLastLogin(userId);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("changePasswordForExpiry".equals(ACTION)) {
				String userId = USER.getUserId();
				String newPassword = request.getParameter("newPassword");
				String oldPassword = request.getParameter("oldPassword");
							
				if (!userService.checkSamePassword(userId, newPassword) && !userService.checkOldPassword(userId, oldPassword)) {
					userService.updatePassword(userId, newPassword);
					userService.updateLastLogin(userId);
					message = "SUCCESS";
					PAGE = "/pages/genericMessage.jsp";
				}				
			}*/ else if ("changePassword".equals(ACTION) || "firstLoginChangePassword".equals(ACTION) || "changePasswordForExpiry".equals(ACTION)) {
				String userId = request.getParameter("userId"); System.out.println("userId : " + userId);
				String newPassword = request.getParameter("newPassword");
				String oldPassword = request.getParameter("oldPassword");
				GIISUser giisUser = userService.getGIISUser(userId);
				Map<String, Object> hashingParams = userService.getHashingParameters();
				
				if(!PasswordEncoder.comparePassword(oldPassword, giisUser.getPassword(), giisUser.getSalt(), hashingParams)) {
					throw new UnmatchedStringException("Current password is incorrect.");
				} else if (PasswordEncoder.comparePassword(newPassword, giisUser.getPassword(), giisUser.getSalt(), hashingParams)) {
					throw new UnmatchedStringException("Old and new password cannot be the same.");
				}			
				
				userService.updatePassword(userId, newPassword);
				if(!"changePassword".equals(ACTION))
					userService.updateLastLogin(userId);
				message = "SUCCESS - Password changed.";
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("setNoPassword".equals(ACTION)){
				String userId = request.getParameter("userId");
				String newPassword = request.getParameter("newPassword");
							
				userService.updatePassword(userId, newPassword);
				userService.updateLastLogin(userId);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteUser".equals(ACTION)) {
				userService.deleteGIISUser(new GIISUser(request.getParameter("userId")));
				message = "SUCCESS - User deleted.";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getEditUserForm".equals(ACTION)) {
				GIISUserGrpHdrService userGrpService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService");
				GIISGrpIsSourceService grpIsSourceService = (GIISGrpIsSourceService) APPLICATION_CONTEXT.getBean("giisGrpIsSourceService");
				
				request.setAttribute("userGroups", userGrpService.getGiisUserGrpList(""));
				request.setAttribute("grpIsSources", grpIsSourceService.getGrpIsSourceAllList());
				
				request.setAttribute("userInfo", userService.getGIISUser(request.getParameter("userId")));
				PAGE = "/pages/security/user/editUser.jsp";
			} else if ("updateUser".equals(ACTION) || "addUser".equals(ACTION)) {
				String userId = request.getParameter("userId");
				String username = request.getParameter("username");
				int userGroup = Integer.parseInt(request.getParameter("userGroup"));
				String grpIssCd = request.getParameter("grpIssCd");
				String remarks = request.getParameter("remarks");
				String email = request.getParameter("email"); //email
				String activeFlag = null == request.getParameter("activeFlag1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String commUpdateTag = null == request.getParameter("commUpdateTag1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String allUserSw = null == request.getParameter("allUserSw1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String managerSw = null == request.getParameter("managerSw1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String marketingSw = null == request.getParameter("marketingSw1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String misSw = null == request.getParameter("misSw1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				String workflowTag = null == request.getParameter("workflowTag1") ? ApplicationWideParameters.N : ApplicationWideParameters.Y;
				
				GIISUser user = new GIISUser();
				user.setUserId(userId);
				user.setUserGrp(userGroup);
				user.setUsername(username);
				user.setIssCd(grpIssCd);
				user.setRemarks(remarks);
				user.setActiveFlag(activeFlag);
				user.setCommUpdateTag(commUpdateTag);
				user.setAllUserSw(allUserSw);
				user.setMgrSw(managerSw);
				user.setMktngSw(marketingSw);
				user.setMisSw(misSw);
				user.setWorkflowTag(workflowTag);
				user.setLastUserId(USER.getUserId());
				user.setPassword(PasswordEncoder.doEncrypt(userId));
				user.setEmailAdd(PasswordEncoder.doEncrypt(email)); //encryption for email
				
				userService.saveGIISUser(user, ACTION);
				if ("updateUser".equals(ACTION)) {
					message = "SUCCESS - User updated!";
				} else if ("addUser".equals(ACTION)) {
					message = "SUCCESS - User added!";
				}
				PAGE = "/pages/genericMessage.jsp";
				
			} else if ("transactionMaintenance".equals(ACTION)) {
				GIISTransactionService transactionService = (GIISTransactionService) APPLICATION_CONTEXT.getBean("giisTransactionService"); // +env
				GIISUserTranService userTranService = (GIISUserTranService) APPLICATION_CONTEXT.getBean("giisUserTranService");
				String userID = request.getParameter("userID");
				// list of user transactions
				request.setAttribute("userTransactions", userTranService.getGiisUserTranList(userID));
				
				// list of transactions
				request.setAttribute("transactions", transactionService.getGiisTransactionList());
				
				request.setAttribute("userID", userID);
				request.setAttribute("username", request.getParameter("username"));
				PAGE = "/pages/security/user/transaction.jsp";
			} else if ("populateIssueSources".equals(ACTION)) {
				String userID = request.getParameter("userID");
				GIISUserIssCdService issCdService = (GIISUserIssCdService) APPLICATION_CONTEXT.getBean("giisUserIssCdService");
				GIISISSourceFacadeService isSourceService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				
				// list of issue sources
				request.setAttribute("userIssSources", isSourceService.getIssueSourceAllList());
				
				// list of user issue sources
				request.setAttribute("curUserIssSources", issCdService.getGiisUserIssCdList(userID));
				
				@SuppressWarnings("unused")
				List<GIISUserIssCd> issCds = issCdService.getGiisUserIssCdList(userID);
				PAGE = "/pages/security/user/transaction/subPages/userIssSources.jsp";
			}  else if ("populateModules".equals(ACTION)) {
				String userID = request.getParameter("userID");
				GIISUserModulesService userModulesService = (GIISUserModulesService) APPLICATION_CONTEXT.getBean("giisUserModulesService");
				GIISModuleService giisModuleService = (GIISModuleService) APPLICATION_CONTEXT.getBean("giisModuleService");
				
				// list of modules
				request.setAttribute("userModules", giisModuleService.getGiisModulesList());
				
				// list of user modules
				request.setAttribute("curUserModules", userModulesService.getGiisUserModulesTranList(userID));
				PAGE = "/pages/security/user/transaction/subPages/userModules.jsp";
			}   else if ("populateLines".equals(ACTION)) {
				String userID = request.getParameter("userID");
				GIISUserLineService userLineService = (GIISUserLineService) APPLICATION_CONTEXT.getBean("giisUserLineService");
				GIISLineFacadeService lineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				
				// list of lines
				request.setAttribute("userLines", lineService.getGiisLineList());
				
				// list of user lines
				request.setAttribute("curUserLines", userLineService.getGiisUserLineList(userID));
				PAGE = "/pages/security/user/transaction/subPages/userLines.jsp";
			} else if ("setUserTransaction".equals(ACTION)) {
				String userID = request.getParameter("userID");
				String[] pTransactions = request.getParameter("pTransactions").split(",");
				log.info("pTransactions Length: " + pTransactions.length);
				
				String[] pModules = request.getParameter("pModules").split("--"); // array of JS arrays
				log.info("pModules Length: " + pModules.length);
				
				String[] pIssSources = request.getParameter("pIssSources").split("--"); // array of JS arrays
				log.info("pIssSources Length: " + pIssSources.length);
				
				String[] pLines = request.getParameter("pLines").split("\\]");
				log.info("pLines Length: " + pLines.length);

				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pTransactions", pTransactions);
				params.put("pModules", pModules);
				params.put("pIssSources", pIssSources);
				params.put("pLines", pLines);
				params.put("userID", userID);
				params.put("userId", USER.getUserId());

				userService.setUserTransaction(params);
				message = "SUCCESS - User transaction saved!";
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkIfUserAllowedForEdit".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userId", request.getParameter("userId"));
				params.put("moduleName", request.getParameter("moduleName"));
				
				message = userService.checkIfUserAllowedForEdit(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("verifyUser".equals(ACTION)){ //subject to change
				DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
				String url = dataSource.getUrl();
				message = userService.verifyUser(request.getParameter("username"), request.getParameter("password"), url.substring(url.lastIndexOf(":")+1, url.length()));
				PAGE = "/pages/genericMessage.jsp";
			}else if ("verifyOverrideUser".equals(ACTION)) {
				GIISUserFacadeService giisUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				DriverManagerDataSource dataSource = (DriverManagerDataSource) APPLICATION_CONTEXT.getBean("dataSource");
				String url = dataSource.getUrl();
				String databaseName = url.substring(url.lastIndexOf(":")+1, url.length());
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("user", 		request.getParameter("userName"));
				params.put("password", 		request.getParameter("password"));
				Map<String, Object> usrParams = giisUserService.userOveride(params);
		
				StringBuilder sb = new StringBuilder();
				sb.append(usrParams.get("message").toString());
				Debug.print(sb);
				
				System.out.println("database: " + databaseName);
				PAGE = "/pages/genericMessage.jsp";
				message = sb.toString();
			}else if ("getUserHistory".equals(ACTION)){
				GIISUserGrpHistService giisUserGrpHist = (GIISUserGrpHistService) APPLICATION_CONTEXT.getBean("giisUserGrpHistService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("page", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("userId", request.getParameter("userId"));
				params.put("currentPage", params.get("page"));
				params.put("filter", "");
				params = giisUserGrpHist.getUserHistory(params);
				
				request.setAttribute("pagerParams", new JSONObject(params));
				
				PAGE = "/pages/security/user/subPages/userHistoryTable.jsp";
			} else if ("refreshHistoryTable".equals(ACTION)){
				GIISUserGrpHistService giisUserGrpHist = (GIISUserGrpHistService) APPLICATION_CONTEXT.getBean("giisUserGrpHistService");
				Map<String, Object> params = new HashMap<String, Object>();
				Integer page= request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page"));

				params.put("currentPage", page);
				params.put("userId", request.getParameter("userId"));
				params.put("filter", request.getParameter("objFilter"));
				params = giisUserGrpHist.getUserHistory(params);
				
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("resetPassword".equals(ACTION)){
				String userId = request.getParameter("userId");
				userService.resetPassword(request);
				message = userId + "'s password had been reset.";				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("changePasswordFromMenu".equals(ACTION)) {
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("action", "changePassword");				
				PAGE = "/pages/security/user/changePassword.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (UnmatchedStringException e) {
			message = "passworderror:"+e.getMessage();
			PAGE = "/pages/genericMessage.jsp";
		} catch (UseridAlreadyTakenException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (MessagingException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (PasswordException e) {
			ExceptionHandler.handleException(e, USER);
			message = "passworderror:" + e.getMessage();
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";	
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
