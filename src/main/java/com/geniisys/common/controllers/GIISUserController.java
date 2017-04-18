/**
 * 
  * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.controllers;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
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
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ContextParameters;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.LocaleHelper;
import com.geniisys.framework.util.PasswordChecker;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.service.GIACDCBUserService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACUserFunctionsService;
import com.seer.framework.util.ApplicationContextReader;


/**
 * The Class GIISUserController.
 */
public class GIISUserController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -8200069010485401981L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISUserController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	@SuppressWarnings({ "unchecked" })
	public void doProcessing(HttpServletRequest request, 
			HttpServletResponse response,
			GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException{

		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());		
		Map<String, Object> SESSION_PARAMETERS = (Map<String, Object>) SESSION.getAttribute("PARAMETERS");		
		/*end of default attributes*/
		
		GIISUserFacadeService userService = null;
		try {
			if (!"logout".equals(ACTION)) {
				userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
			}
	
			if ("login".equals(ACTION))	{
				/* Service Definitions */
				String userId = request.getParameter("userId");				
				try{
					userService.userLogin(request);
					message = "SUCCESS";					
				} catch (InvalidLoginException e) {
					ExceptionHandler.logException(e, userId);
					message = "invalid";
				} catch (NoSaltException e) {
					ExceptionHandler.logException(e, userId);
					message = "nosalt";
				} catch (AccountLockedException e) {
					ExceptionHandler.logException(e, userId);
					message = "locked";
				} catch (TemporaryAccountException e) {
					ExceptionHandler.logException(e, userId);
					message = "temporary";
				} catch (ExpiredTemporaryPasswordException e) {
					ExceptionHandler.logException(e, userId);
					message = "expiredtemporarypassword";
				} catch (ExpiredPasswordException e) {
					ExceptionHandler.logException(e, userId);
					message = "expiredpassword";				
				} catch (AccountInactiveException e) {
					ExceptionHandler.logException(e, userId);
					message = "inactive";
				} catch (InvalidUserLoginIPException e) {
					ExceptionHandler.logException(e, userId);
					message = "iperror";
				} catch (NoPasswordException e) {
					ExceptionHandler.logException(e, userId);
					message = "nopassworderror";					
				} catch (NoLastLoginException e) {
					ExceptionHandler.logException(e, userId);
					message = "nolastloginerror";
				} catch (ExceedsAllowableLogException e) {
					ExceptionHandler.logException(e, userId);
					message = "applogerror";
				} catch (PasswordException e) {
					ExceptionHandler.logException(e, userId);
					message = "passworderror:"+e.getMessage();
				} catch (SQLException e) {
					ExceptionHandler.logException(e, userId);
					if (e.getErrorCode() == 1017 || e.getCause().toString().contains("ORA-12505") || e.getCause().toString().contains("The Network Adapter could not establish the connection")){
						message = "connectionerror";
					} else {
						message = "dberror";
					}
				} catch (Exception e) {
					ExceptionHandler.logException(e, userId);
					message = "invalid";
				} finally {
					PAGE = "/pages/loginResult.jsp";
				}
			} else if ("checkPWExpiry".equals(ACTION)) {
				request.setAttribute("message", ContextParameters.PASSWORD_EXPIRY - USER.getDaysBeforePasswordExpires());
				PAGE = "/pages/genericMessage.jsp";
			} else if ("resetPassword".equals(ACTION)) {
				String newPassword = request.getParameter("newPassword");
				String oldPassword = request.getParameter("oldPassword");
				GIISUser user = (GIISUser) SESSION_PARAMETERS.get("USER");
				//try {
				message = "SUCCESS";
				userService.updatePassword(USER, newPassword, oldPassword);
				user.setPassword(newPassword);
				SESSION_PARAMETERS.put("USER", user);
				SESSION.setAttribute("PARAMETERS", SESSION_PARAMETERS);
				
				//request.setAttribute("message", message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("forgotPassword".equals(ACTION) && (ContextParameters.ENABLE_EMAIL_NOTIFICATION == null || ContextParameters.ENABLE_EMAIL_NOTIFICATION.equals("Y"))) {
				message = userService.forgotPassword(request);
				
				PAGE = "/pages/genericMessage.jsp";
			} else if ("logout".equals(ACTION))	{
				SESSION.removeAttribute("PARAMETERS");
				SESSION.invalidate();
				SESSION = request.getSession(true);
				LocaleHelper helper = LocaleHelper.getInstance();
				helper.setDefault();
				SESSION.setAttribute("locale", helper.getLocale());
				PAGE = "/pages/login.jsp";
			} else if ("goToHome".equals(ACTION)) {
				request.setAttribute("adHocUrl", ContextParameters.AD_HOC_URL);
				PAGE = "/pages/main.jsp";
			} else if ("goToMarketing".equals(ACTION)) {
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				request.setAttribute("lineCodes", new JSONArray(helper.getList(LOVHelper.LINE_CODES)));
				PAGE = "/pages/marketing/main.jsp";
			} else if ("goToUnderwriting".equals(ACTION)) {
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				request.setAttribute("lineCodes", new JSONArray(helper.getList(LOVHelper.LINE_CODES)));
				PAGE = "/pages/underwriting/main.jsp";
			} else if ("goToAccounting".equals(ACTION))	{
				GIACDCBUserService giacDCBUserService = (GIACDCBUserService) APPLICATION_CONTEXT.getBean("giacDCBUserService");
				GIACUserFunctionsService giacUserFunctionsService = (GIACUserFunctionsService) APPLICATION_CONTEXT.getBean("giacUserFunctionsService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				request.setAttribute("isUserDCBUser", giacDCBUserService.checkIfDcbUserExists(USER.getUserId()));
				request.setAttribute("hasORFunction", giacUserFunctionsService.checkIfUserHasFunction("OR", "GIACM000", USER.getUserId()));
				request.setAttribute("hasMOFunction", giacUserFunctionsService.checkIfUserHasFunction("MO", "GIACM000", USER.getUserId()));
				request.setAttribute("hasORCancellation", giacParamService.getParamValueV2("OR_CANCELLATION")); //marco - 09.11.2014
				request.setAttribute("userFunctionValidity", new JSONObject(giacUserFunctionsService.checkUserFunctionValidity(request, USER.getUserId()))); //john - 09.15.2014
				PAGE = "/pages/accounting/main.jsp";
			} else if ("goToSecurity".equals(ACTION)) {
				PAGE = "/pages/security/main.jsp";
			} else if ("goToWorkflow".equals(ACTION)){
				PAGE = "/pages/workflow/main.jsp";
			} else if ("goToClaims".equals(ACTION)){
				LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				request.setAttribute("lineCodes", new JSONArray(helper.getList(LOVHelper.LINE_CODES)));
				request.setAttribute("branchCd", USER.getIssCd());
				request.setAttribute("riIssCd", giacParamService.getParamValueV2("RI_ISS_CD"));
				PAGE = "/pages/claims/main.jsp";
			} else if ("goToSMS".equals(ACTION)){
				PAGE = "/pages/sms/main.jsp";
			} else if ("getServerDateAndTime".equals(ACTION)) {
				request.setAttribute("serverDateAndTime", new java.text.SimpleDateFormat("MMM dd, yyyy HH:mm:ss").format(new java.util.Date()));
				log.info(request.getAttribute("serverDate"));
				PAGE = "/pages/serverDateAndTime.jsp";
			} else if ("giacValidateUser".equals(ACTION)) {
				String functionCd = request.getParameter("functionCd");
				String moduleId = request.getParameter("moduleId");
				message = userService.giacValidateUser(USER.getUserId(), functionCd, moduleId);
				PAGE = "/pages/genericMessage.jsp";
			} else if("showUnderwriterForReassignQuote".equals(ACTION)){
				userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				Map<String, Object> params = new HashMap<String, Object>();
				
				params.put("currentPage", Integer.parseInt(request.getParameter("page")));
				params.put("keyword", request.getParameter("keyword"));
				params.put("sortColumn", request.getParameter("sortColumn"));
				
				userService.getUnderwriterForReassignQuote(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("underwriters", new JSONObject(params));
					PAGE = "/pages/marketing/quotation/pop-ups/reassignQuoteUnderwriter.jsp";
				}
			} else if("getWorkflowUserList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("appUser", USER.getUserId());
				params.put("eventCd", request.getParameter("eventCd"));
				params.put("eventType", request.getParameter("eventType"));
				params.put("recipient", (request.getParameter("recipient") != null && !request.getParameter("recipient").equals("") ? request.getParameter("recipient") : null));
				params.put("tranId", request.getParameter("tranId"));
				params.put("eventModCd", request.getParameter("eventModCd"));
				params.put("eventColCd", request.getParameter("eventColCd"));
				params.put("createSw", request.getParameter("createSw"));
				Map<String, Object> eventTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(eventTableGrid);
				request.setAttribute("userListTableGrid", json);
				request.setAttribute("mode", request.getParameter("mode"));
				PAGE = "/pages/workflow/workflow/subPages/userList.jsp";
			} else if("setReportParamsToSession".equalsIgnoreCase(ACTION)){
				SESSION.setAttribute("reportUrl", request.getParameter("reportUrl"));
				SESSION.setAttribute("reportTitle", request.getParameter("reportTitle"));
			} else if("setReportListToSession".equals(ACTION)){
				List<Map<String, Object>> reportList = JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("reportList")));
				SESSION.setAttribute("reportList", reportList);
			} else if("turnMaintenanceMode".equals(ACTION)){
				String mode = request.getParameter("mode");
				ContextParameters.UNDER_MAINTENANCE = (mode.equals("On") ? true : false);
				SESSION.setAttribute("maintenanceMode", mode);
				log.info("Geniisys maintenance is turned " + mode.toLowerCase());
				message = mode;
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateOverrideUser".equals(ACTION)) {
				GIISUserFacadeService giisUserService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				message = giisUserService.validateOverrideUser(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkUserAccessGiuts".equals(ACTION)){
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String moduleId = request.getParameter("moduleId");
				message = giisUserFacadeService.checkUserAccess2(moduleId, USER.getUserId()); //giisUserFacadeService.checkUserAccessGiuts008a(moduleId);	// shan 07.08.2014
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkUserAccessGipis162".equals(ACTION)){
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String moduleId = request.getParameter("moduleId");
				message = giisUserFacadeService.checkUserAccessGipis162(moduleId, USER.getUserId());
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
				
			}else if("checkUserAccessGicls".equals(ACTION)){
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String moduleId = request.getParameter("moduleId");
				message = giisUserFacadeService.checkUserAccessGipis162(moduleId, USER.getUserId());
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkUserAccessGiacs".equals(ACTION)){
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				String moduleId = request.getParameter("moduleId");
				message = giisUserFacadeService.checkUserAccessGipis162(moduleId, USER.getUserId());
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("checkUserAccess2Gipis".equals(ACTION)){
				GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				message = giisUserFacadeService.checkUserAccess2(request.getParameter("moduleId"), USER.getUserId());
				System.out.println("message: " + message);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("deleteCSVFileFromServer".equals(ACTION)) {
				String realPath = request.getSession().getServletContext().getRealPath("");
				String filename = request.getParameter("filename");
				filename = filename.substring(filename.lastIndexOf("/")+1, filename.length());
				(new File(realPath + "\\csv\\" + filename)).delete();	    		
	    		message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getPasswordStrength".equals(ACTION)) {
				message = PasswordChecker.getPasswordStrength(request.getParameter("password"));
				PAGE = "/pages/genericMessage.jsp";
			} else if("goToAdhoc".equals(ACTION)){
				Cookie adhocUser = new Cookie("adhocUser", USER.getUserId());
				adhocUser.setPath("/GeniisysAdHocReports/");
				adhocUser.setMaxAge(2);
				response.addCookie(adhocUser);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (MessagingException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (NullPointerException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (UnmatchedStringException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}  finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}