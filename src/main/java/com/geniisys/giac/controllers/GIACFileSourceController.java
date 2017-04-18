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
import com.geniisys.giac.service.GIACFileSourceService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name= "GIACFileSourceController", urlPatterns={"/GIACFileSourceController"})
public class GIACFileSourceController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 620154507521143311L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACFileSourceService giacFileSourceService = (GIACFileSourceService) APPLICATION_CONTEXT.getBean("giacFileSourceService");
			if ("showFileSource".equals(ACTION)) {
				JSONObject objFileSourceTable = giacFileSourceService.getFileSourceRecords(request);
				if("1".equals(request.getParameter("refresh"))){
					request.setAttribute("objFileSourceTable", objFileSourceTable);
					PAGE = "/pages/accounting/uploading/fileSource/fileSource.jsp";
				}else{
					message = objFileSourceTable.toString();
					PAGE = "/pages/genericMessage.jsp";	
				}
			}else if("saveFileSource".equals(ACTION)){
				message = giacFileSourceService.saveFileSource(request, USER.getUserId());
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
