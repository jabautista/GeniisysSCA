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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.GIISUserGrpHdr;
import com.geniisys.common.service.GIISISSourceFacadeService;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISModuleService;
import com.geniisys.common.service.GIISTransactionService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.common.service.GIISUserGrpDtlService;
import com.geniisys.common.service.GIISUserGrpHdrService;
import com.geniisys.common.service.GIISUserGrpLineService;
import com.geniisys.common.service.GIISUserGrpModuleService;
import com.geniisys.common.service.GIISUserGrpTranService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIISUserGroupMaintenanceController.
 */
public class GIISUserGroupMaintenanceController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6063681229625756660L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISUserGroupMaintenanceController.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISUserGrpHdrService giisUserGrpHdrService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService");
		GIISUserGrpTranService giisUserGrpTranService = (GIISUserGrpTranService) APPLICATION_CONTEXT.getBean("giisUserGrpTranService");
		GIISUserGrpDtlService giisUserGrpDtlService = (GIISUserGrpDtlService) APPLICATION_CONTEXT.getBean("giisUserGrpDtlService");
		GIISUserGrpLineService giisUserGrpLineService = (GIISUserGrpLineService) APPLICATION_CONTEXT.getBean("giisUserGrpLineService");
		GIISUserGrpModuleService giisUserGrpModuleService = (GIISUserGrpModuleService) APPLICATION_CONTEXT.getBean("giisUserGrpModuleService");
		/*end of default attributes*/

		// services needed
		
		// local variable declaration

		try {
			if ("showUserGroupListing".equals(ACTION)) {
				Thread.sleep(500);
				PAGE = "/pages/security/userGroup/userGroupListing.jsp";
			} else if ("getUserGroupList".equals(ACTION)) {
				GIISUserGrpHdrService userGroupService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService"); // +env
				String param = request.getParameter("keyword");
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));

				PaginatedList userGroups = userGroupService.getGiisUserGroupList(param, pageNo);
				request.setAttribute("searchResult", userGroups);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", userGroups.getNoOfPages());
				PAGE = "/pages/security/userGroup/subPages/userGroupListingTable.jsp";
			} else if ("transactionMaintenance".equals(ACTION)) {
				GIISISSourceFacadeService isSourceService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				GIISTransactionService transactionService = (GIISTransactionService) APPLICATION_CONTEXT.getBean("giisTransactionService"); // +env
				int userGrp = Integer.parseInt(null == request.getParameter("userGrp") ? "0" : request.getParameter("userGrp"));
				
				// list of transactions
				request.setAttribute("transactions", transactionService.getGiisTransactionList());
				
				// list of current transactions
				request.setAttribute("userGrouptransactions", giisUserGrpTranService.getGiisUserGrpTranList(userGrp));
				
				// list of issue sources
				request.setAttribute("issSources", isSourceService.getIssueSourceAllList());//getGIISISSourceListing());
				
				GIISUserGrpHdr userGrpHdr = giisUserGrpHdrService.getGiisUserGrpHdr(userGrp);
				request.setAttribute("userGrpHdr", userGrpHdr);

				request.setAttribute("tranUserId", USER.getUserId());
				
				Date sysdate = new SimpleDateFormat("MM-dd-yyyy").parse(new SimpleDateFormat("MM-dd-yyyy").format(new Date())); 
				
				if (null != userGrpHdr) {
					sysdate = userGrpHdr.getLastUpdate();
				} else {
					request.setAttribute("userGrps", giisUserGrpHdrService.getUserGrpHdrs());
				}
							
				request.setAttribute("sysdate", sysdate);
				PAGE = "/pages/security/userGroup/transaction.jsp";
			} else if ("populateModules".equals(ACTION)) {
				GIISModuleService giisModuleService = (GIISModuleService) APPLICATION_CONTEXT.getBean("giisModuleService");
				// list of current modules
				request.setAttribute("grpModules", giisUserGrpModuleService.getGiisGrpModulesList(request.getParameter("userGrp")));
				
				// list of modules
				request.setAttribute("modules", giisModuleService.getGiisModulesList());
				PAGE = "/pages/security/userGroup/subPages/modules.jsp";
			} else if ("populateIssueSources".equals(ACTION)) {
				GIISISSourceFacadeService isSourceService = (GIISISSourceFacadeService) APPLICATION_CONTEXT.getBean("giisIssourceFacadeService");
				
				// list of current issue sources
				request.setAttribute("grpIssSources", giisUserGrpDtlService.getGiisUserGrpDtlGrpList(request.getParameter("userGrp")));
				
				// list of issue sources
				request.setAttribute("issSources", isSourceService.getIssueSourceAllList());//getGIISISSourceListing());
				PAGE = "/pages/security/userGroup/subPages/issueSources.jsp";
			} else if("populateLinesOfBusiness".equals(ACTION)) {
				GIISLineFacadeService lineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
				
				// list of current lines
				request.setAttribute("curLines", giisUserGrpLineService.getGiisUserGrpLineList(request.getParameter("userGrp")));
				
				// list of lines
				request.setAttribute("lines", lineService.getGiisLineList());
				PAGE = "/pages/security/userGroup/subPages/lines.jsp";
			} else if ("setUserGrpHdr".equals(ACTION)) {
				System.out.println("pumunta dito...");
				
				log.info("User Group Controller preparing parameters for user grp hdr saving...");
				GIISUserGrpHdrService userGroupService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService"); // +env
				
				int userGrp = Integer.parseInt(request.getParameter("userGrp"));
				String userGrpDesc = request.getParameter("userGrpDesc");
				String grpIssCd = request.getParameter("grpIssCd");
				String remarks = request.getParameter("remarks");
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
				params.put("userGrp", userGrp);
				params.put("userGrpDesc", userGrpDesc);
				params.put("grpIssCd", grpIssCd);
				params.put("remarks", remarks);
				params.put("userId", USER.getUserId());
				
				log.info("User Group Controller calling service to save user grp hdr...");
				//userGroupService.deleteGiisUserGrpHdrDetails(userGrpHdr);
				userGroupService.setGiisUserGrpHdr(params);
				log.info("All user grp details saved...");
				PAGE = "/pages/genericMessage.jsp";
				message = "SUCCESS - User group saved!";
			} else if ("deleteUserGroup".equals(ACTION)) {
				GIISUserGrpHdrService userGroupService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService"); // +env
				userGroupService.deleteGiisUserGrpHdr(Integer.parseInt(request.getParameter("userGrp")));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getUserGroupAccess".equals(ACTION)){
				GIISUserGrpHdrService userGroupService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService");
				GIISUserFacadeService userService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
				
				Integer userGrp = userService.getUserGrp(request.getParameter("userId"));
				Map<String, Object> grpAccessParams = new HashMap<String, Object>();
				
				grpAccessParams.put("userGrpHdr", new JSONObject(userGroupService.getGiisUserGrpHdr(userGrp)));
				grpAccessParams.put("userGroupTransactions", new JSONArray(giisUserGrpTranService.getGiisUserGrpTranList(userGrp)));
				grpAccessParams.put("grpIssSources", new JSONArray(giisUserGrpDtlService.getGiisUserGrpDtlGrpList(userGrp.toString())));
				grpAccessParams.put("grpCurLines", new JSONArray(giisUserGrpLineService.getGiisUserGrpLineList(userGrp.toString())));
				grpAccessParams.put("grpModules", new JSONArray(giisUserGrpModuleService.getGiisGrpModulesList(userGrp.toString())));
				
				request.setAttribute("grpAccessParams", new JSONObject(grpAccessParams));
				
				PAGE = "/pages/security/user/subPages/userGroupAccessTable.jsp";
			} else if ("copyUserGrp".equals(ACTION)){
				GIISUserGrpHdrService userGroupService = (GIISUserGrpHdrService) APPLICATION_CONTEXT.getBean("giisUserGrpHdrService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("userGrp", request.getParameter("userGrp"));
				params.put("newUserGrp", request.getParameter("newUserGrp"));
				params.put("userId", USER.getUserId());
				//params.put("userGrpDesc", request.getParameter("userGrpDesc"));
				//params.put("grpIssCd", request.getParameter("grpIssCd"));
				//params.put("remarks", request.getParameter("remarks"));
				message = userGroupService.copyUserGrp(params);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGIISS041".equals(ACTION)){
				JSONObject json = giisUserGrpHdrService.showGIISS041(request);
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("userGrpJSON", json);
					PAGE = "/pages/security/userGroup/userGroupTG/userGroupMaintenance.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("valDeleteRec".equals(ACTION)){
				giisUserGrpHdrService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddRec".equals(ACTION)){
				giisUserGrpHdrService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIISS041".equals(ACTION)){
				giisUserGrpHdrService.saveGIISS041(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showUserGrpTransactions".equals(ACTION)){
				JSONObject json = giisUserGrpTranService.getUserGrpTran(request);
				
				if(request.getParameter("refresh") == null) {
					request.setAttribute("userGrpTranJSON", json);
					PAGE = "/pages/security/userGroup/userGroupTG/userGroupTransaction.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("getUserGrpDtl".equals(ACTION)){
				JSONObject json = giisUserGrpDtlService.getUserGrpDtl(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("getUserGrpLine".equals(ACTION)){
				JSONObject json = giisUserGrpLineService.getUserGrpLine(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddUserGrpTran".equals(ACTION)){
				giisUserGrpTranService.valAddUserGrpTran(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddDeleteDtl".equals(ACTION)){
				giisUserGrpDtlService.valAddDeleteDtl(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveUserGrpTran".equals(ACTION)){
				giisUserGrpTranService.saveUserGrpTran(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showModulesOverlay".equals(ACTION)){
				JSONObject json = giisUserGrpModuleService.getUserGrpModules(request);
				
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
					String params[] = {"GIIS_MODULES_USER.ACCESS_TAG"};
					request.setAttribute("accessTagList", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params));
					request.setAttribute("modulesJSON", json);
					PAGE = "/pages/security/userGroup/userGroupTG/userGroupModules.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveUserGrpModules".equals(ACTION)){
				giisUserGrpModuleService.saveUserGrpModules(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkUncheckModules".equals(ACTION)){
				giisUserGrpModuleService.checkUncheckModules(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getAllIssCodes".equals(ACTION)){
				request.setAttribute("object", StringFormatter.escapeHTMLInObject(giisUserGrpDtlService.getAllIssCodes(request)));
				PAGE = "/pages/genericObject.jsp";
			}else if("valDeleteLine".equals(ACTION)){
				giisUserGrpLineService.valDeleteLine(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getAllLineCodes".equals(ACTION)){
				request.setAttribute("object", giisUserGrpLineService.getAllLineCodes(request));
				PAGE = "/pages/genericObject.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (NumberFormatException e) {
			message = ExceptionHandler.handleException(e, USER);
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
