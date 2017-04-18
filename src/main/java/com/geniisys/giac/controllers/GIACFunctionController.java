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
import com.geniisys.giac.service.GIACFunctionService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACFunctionController", urlPatterns={"/GIACFunctionController"})
public class GIACFunctionController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACFunctionService giacFunctionService = (GIACFunctionService) APPLICATION_CONTEXT.getBean("giacFunctionService");
		
		try {
			if("showGiacs314".equals(ACTION)){
				JSONObject json = giacFunctionService.showGiacs314(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonAccountingFunctions", json);
					PAGE = "/pages/accounting/maintenance/accountingSetup/userAccess/accountingFunction/accountingFunctions.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				message = giacFunctionService.valDeleteRec(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacFunctionService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs314".equals(ACTION)) {
				giacFunctionService.saveGiacs314(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateGiacs314Module".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacFunctionService.validateGiacs314Module(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("showFunctionColumn".equals(ACTION)){
				JSONObject jsonFunctionColumn = giacFunctionService.showFunctionColumn(request, USER.getUserId());
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("functionCode", request.getParameter("functionCode"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonFunctionColumn.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonFunctionColumn", jsonFunctionColumn);
					PAGE = "/pages/accounting/maintenance/accountingSetup/userAccess/accountingFunction/subPages/functionColumn.jsp";					
				}
			} else if("validateGiacs314Table".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacFunctionService.validateGiacs314Table(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if("validateGiacs314Column".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacFunctionService.validateGiacs314Column(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("valAddFunctionColumn".equals(ACTION)){
				giacFunctionService.valAddFunctionColumn(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveFunctionColumn".equals(ACTION)) {
				giacFunctionService.saveFunctionColumn(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showFunctionDisplay".equals(ACTION)){
				JSONObject jsonFunctionDisplay = giacFunctionService.showFunctionDisplay(request, USER.getUserId());
				request.setAttribute("moduleId", request.getParameter("moduleId"));
				request.setAttribute("functionCode", request.getParameter("functionCode"));
				if("1".equals(request.getParameter("refresh"))){
					message = jsonFunctionDisplay.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonFunctionDisplay", jsonFunctionDisplay);
					PAGE = "/pages/accounting/maintenance/accountingSetup/userAccess/accountingFunction/subPages/functionDisplay.jsp";					
				}
			} else if("validateGiacs314Display".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacFunctionService.validateGiacs314Display(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("valAddColumnDisplay".equals(ACTION)){
				giacFunctionService.valAddColumnDisplay(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveColumnDisplay".equals(ACTION)) {
				giacFunctionService.saveColumnDisplay(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("checkFuncExists".equals(ACTION)){ //Added by Jerome Bautista 05.28.2015 SR 4225
				message = giacFunctionService.checkFuncExists(request);
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
