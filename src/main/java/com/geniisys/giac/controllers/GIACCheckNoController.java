package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACCheckNoService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACCheckNoController", urlPatterns={"/GIACCheckNoController"})
public class GIACCheckNoController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACCheckNoService giacCheckNoService = (GIACCheckNoService) APPLICATION_CONTEXT.getBean("giacCheckNoService");
		
		try{
			if("showGIACS326".equals(ACTION)){
				if(request.getParameter("refresh") == null) {
					request.setAttribute("fundCd", request.getParameter("fundCd"));
					request.setAttribute("fundDesc", request.getParameter("fundDesc"));
					request.setAttribute("branchCd", request.getParameter("branchCd"));
					request.setAttribute("branchName", request.getParameter("branchName"));
					PAGE = "/pages/accounting/maintenance/docSequencePerBranch/checkNumber/checkNumber.jsp";
				}else{
					JSONObject json = giacCheckNoService.getCheckNoList(request);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
				
			}else if("checkBranch".equals(ACTION)){
				giacCheckNoService.checkBranchForCheck(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valAddRec".equals(ACTION)){
				giacCheckNoService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDelRec".equals(ACTION)){
				giacCheckNoService.valDelRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveGIACS326".equals(ACTION)){
				giacCheckNoService.saveGIACS326(request, USER.getUserId());
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
		} catch (NullPointerException e) {
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
