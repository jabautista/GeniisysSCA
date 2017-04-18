package com.geniisys.gicl.controllers;

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
import com.geniisys.gicl.service.GICLRepSignatoryService;
import com.geniisys.gicl.service.GICLReportDocumentService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLReportDocumentController", urlPatterns={"/GICLReportDocumentController"})
public class GICLReportDocumentController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8814097370897555198L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLReportDocumentService giclReportDocumentService = (GICLReportDocumentService) APPLICATION_CONTEXT.getBean("giclReportDocumentService");
		GICLRepSignatoryService giclRepSignatoryService = (GICLRepSignatoryService) APPLICATION_CONTEXT.getBean("giclRepSignatoryService");
		
		try {
			if("showGICLS180".equals(ACTION)){
				JSONObject json = giclReportDocumentService.showGICLS180(request, USER.getUserId());

				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonReportDocumentList", json);
					PAGE = "/pages/claims/tableMaintenance/reportDocument/reportDocument.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveGICLS180".equals(ACTION)) {
				giclReportDocumentService.saveGICLS180(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("valDeleteRec".equals(ACTION)){
				giclReportDocumentService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showRepSignatoryGicls180".equals(ACTION)){
				JSONObject json = giclRepSignatoryService.showRepSignatory(request, USER.getUserId());
				message = json.toString();
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
