/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gipi.controllers
	File Name: GIPIReassignParEndtController.java
	Author: Computer Professional Inc
	Created By: Steven Ramirez
	Created Date: March 13, 2013
	Description: 
*/
package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.service.GIPIReassignParEndtService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIReassignParEndtController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7811442911348005061L;
	private static Logger log = Logger.getLogger(GIPIReassignParEndtController.class);
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIPIReassignParEndtService gipiReassignParEndt = (GIPIReassignParEndtService) APPLICATION_CONTEXT.getBean("gipiReassignParEndtService");
			if ("getReassignParEndtListing".equals(ACTION)) {
				GIISParameterFacadeService parameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("popupDir", parameterService.getParamValueV2("REALPOPUP_DIR"));
				JSONObject objReassignParEndt = gipiReassignParEndt.getReassignParEndtListing(request,USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = objReassignParEndt.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("objReassignParEndt", objReassignParEndt);
					PAGE = "/pages/underwriting/utilities/reassignment/reassignParEndt.jsp";
				}
			}else if ("checkUser".equals(ACTION)) {
				message = gipiReassignParEndt.checkUser(request,USER.getUserId());
				PAGE =  "/pages/genericMessage.jsp";
			}else if ("saveReassignParEndt".equals(ACTION)) {
				JSONArray objSaveReassign =  new JSONArray(gipiReassignParEndt.saveReassignParEndt(request,USER));
				message = objSaveReassign.toString();
				PAGE =  "/pages/genericMessage.jsp";
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

}
