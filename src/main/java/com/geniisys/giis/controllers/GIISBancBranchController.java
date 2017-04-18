package com.geniisys.giis.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giis.service.GIISBancBranchService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISBancBranchController", urlPatterns={"/GIISBancBranchController"})
public class GIISBancBranchController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISBancBranchService giisBancBranchService = (GIISBancBranchService) APPLICATION_CONTEXT.getBean("giisBancBranchService");
		
		try {
			
			if("showGiiss216".equals(ACTION)) {
				JSONObject json = giisBancBranchService.showGiiss216(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBancBranch", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/bancassurance/branchCode/branchCode.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			} else if("saveGiiss216".equals(ACTION)) {
				giisBancBranchService.saveGiiss216(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiiss216History".equals(ACTION)){
				JSONObject json = giisBancBranchService.showGiiss216Hist(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBancBranchHist", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/bancassurance/branchCode/history.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRecGiiss216".equals(ACTION)){
				giisBancBranchService.valAddRecGiiss216(request);
				message = "SUCCESS";
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

}
