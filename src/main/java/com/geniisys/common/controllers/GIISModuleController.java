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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISModule;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISModuleService;
import com.geniisys.common.service.GIISUserGrpModuleService;
import com.geniisys.common.service.GIISUserModulesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISModuleController.
 */
public class GIISModuleController extends BaseController {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 6063681229625756660L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIISUserController.class);

	/* (non-Javadoc)
	 * @see com.geniisys.framework.util.BaseController#doProcessing(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, com.geniisys.common.entity.GIISUser, java.lang.String, javax.servlet.http.HttpSession)
	 */
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		/*default attributes*/
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIISModuleService moduleService = (GIISModuleService) appContext.getBean("giisModuleService");
		GIISUserModulesService userModulesService = (GIISUserModulesService) appContext.getBean("giisUserModulesService");
		GIISUserGrpModuleService userGrpModuleService = (GIISUserGrpModuleService) appContext.getBean("giisUserGrpModuleService");
		LOVHelper lovHelper = (LOVHelper) appContext.getBean("lovHelper");
		/*end of default attributes*/

		// services needed
		
		// local variable declaration

		try {
			if ("showModuleListing".equals(ACTION)) {
				Thread.sleep(1000);
				PAGE = "/pages/security/module/moduleListing.jsp";
			} else if ("getModuleList".equals(ACTION)) {
				String keyword = request.getParameter("keyword") == null || "".equals(request.getParameter("keyword"))? "" : request.getParameter("keyword");
				int pageNo = request.getParameter("pageNo") == null || "".equals(request.getParameter("pageNo")) ? 1 : Integer.parseInt(request.getParameter("pageNo"));

				PaginatedList modules = moduleService.getCompleteModuleList(keyword, pageNo-1);
				request.setAttribute("searchResult", modules);
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", modules.getNoOfPages());
				PAGE = "/pages/security/module/subPages/moduleListingTable.jsp";
			} else if ("showAddModulePage".equals(ACTION)) {
				String[] args = {"GIIS_MODULES.MODULE_GRP"};
				request.setAttribute("moduleGrps", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, args));
				
				String[] types = {"GIIS_MODULES.MODULE_TYPE"};
				request.setAttribute("moduleTypes", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, types));
				
				String[] accessTag = {"GIIS_MODULES.MOD_ACCESS_TAG"};
				request.setAttribute("accessTags", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, accessTag));
				
				if (!"".equals(request.getParameter("moduleId"))) {
					request.setAttribute("module", moduleService.getGiisModule(request.getParameter("moduleId")));
				}
				
				PAGE = "/pages/security/module/subPages/addModule.jsp";
			} else if ("getModuleTranList".equals(ACTION)) {
				request.setAttribute("moduleTrans", moduleService.getModuleTranList(request.getParameter("moduleId")));
				PAGE = "/pages/security/module/subPages/moduleTranList.jsp";
			} else if ("setGiisModule".equals(ACTION)) {
				moduleService.setGiisModule(this.setupModule(request, USER.getUserId()));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateGiisModule".equals(ACTION)) {
				moduleService.updateGiisModule(this.setupModule(request, USER.getUserId()));
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getModuleUsers".equals(ACTION)) {
				request.setAttribute("moduleDesc", request.getParameter("moduleDesc"));
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("moduleUsers", userModulesService.getModuleUsers(request.getParameter("moduleId")));
				PAGE = "/pages/security/module/subPages/moduleUsers.jsp";
			} else if ("getModuleUserGrps".equals(ACTION)) {
				request.setAttribute("moduleDesc", request.getParameter("moduleDesc"));
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("accessTag", request.getParameter("accessTag"));
				request.setAttribute("moduleUserGrps", userGrpModuleService.getModuleUserGrps(request.getParameter("moduleId")));
				PAGE = "/pages/security/module/subPages/moduleUserGrps.jsp";
			} else if("showGiiss081".equals(ACTION)){
				JSONObject json = moduleService.showGiiss081(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGeniisysModulesList", json);
					PAGE = "/pages/security/geniisysModules/geniisysModules.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				moduleService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				moduleService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss081".equals(ACTION)) {
				moduleService.saveGiiss081(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGeniisysModuleTran".equals(ACTION)){
				JSONObject json = moduleService.showGeniisysModuleTran(request, USER.getUserId());
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGeniisysModuleTranList", json);
					PAGE = "/pages/security/geniisysModules/subPages/geniisysModulesTran.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteTranRec".equals(ACTION)){
				moduleService.valDeleteTranRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddTranRec".equals(ACTION)){
				moduleService.valAddTranRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGeniisysModuleTran".equals(ACTION)) {
				moduleService.saveGeniisysModuleTran(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGeniisysUsersWAccess".equals(ACTION)){
				JSONObject json = moduleService.showGeniisysUsersWAccess(request, USER.getUserId());
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("moduleDesc", request.getParameter("moduleDesc"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisUserModulesList", json);
					PAGE = "/pages/security/geniisysModules/subPages/geniisysUsersWAccess.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showGeniisysUserGrpWAccess".equals(ACTION)){
				JSONObject json = moduleService.showGeniisysUserGrpWAccess(request, USER.getUserId());
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("moduleDesc", request.getParameter("moduleDesc"));
				if(request.getParameter("refresh") == null) {
					JSONObject jsonGiisUsersList = moduleService.queryGiisUsers(request, USER.getUserId());
					request.setAttribute("jsonGiisUserGrpModulesList", json);
					request.setAttribute("jsonGiisUsersList", jsonGiisUsersList);
					PAGE = "/pages/security/geniisysModules/subPages/geniisysUserGrpWAccess.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("queryGiisUsers".equals(ACTION)){
				JSONObject json = moduleService.queryGiisUsers(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonGiisUsersList", json);
				} else {
					message = json.toString();
				}
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	private GIISModule setupModule(HttpServletRequest request, String userId) {
		GIISModule module = new GIISModule();
		module.setModuleId(request.getParameter("moduleId"));
		module.setModuleDesc(request.getParameter("moduleDesc"));
		module.setUserId(userId);
		module.setRemarks(request.getParameter("remarks"));
		module.setModuleType(request.getParameter("moduleType"));
		module.setModuleGrp(request.getParameter("moduleGrp"));
		module.setAccessTag(request.getParameter("accessTag"));
		
		return module;
	}

}
