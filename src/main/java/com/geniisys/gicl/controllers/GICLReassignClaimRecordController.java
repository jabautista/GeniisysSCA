package com.geniisys.gicl.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLReassignClaimRecordService;
import com.seer.framework.util.ApplicationContextReader;


@WebServlet(name = "GICLReassignClaimRecordController", urlPatterns = "/GICLReassignClaimRecordController")
public class GICLReassignClaimRecordController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GICLReassignClaimRecordService reassignClaimRecordService = (GICLReassignClaimRecordService) appContext.getBean("giclReassignClaimRecordService");
		try {
			if ("showReassignClaimRecord".equals(ACTION)) {
				JSONObject jsonReassignClaim = reassignClaimRecordService.getClaimDetail(request, USER);
				if("1".equals(request.getParameter("ajax"))){
					PAGE = "/pages/claims/reassignClaimRecord/reassignClaimRecord.jsp";	
				}else{
					message = jsonReassignClaim.toString();
					PAGE = "/pages/genericMessage.jsp";		
				}
			}else if("updateClaimRecord".equals(ACTION)){
				message = reassignClaimRecordService.updateClaimRecord(request, USER.getUserId()).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkIfCanReassignClaim".equals(ACTION)){
				message = reassignClaimRecordService.checkIfCanReassignClaim(USER).toString();
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
