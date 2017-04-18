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
import com.geniisys.giac.service.GIACWholdingTaxesService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACWholdingTaxController", urlPatterns={"/GIACWholdingTaxController"})
public class GIACWholdingTaxController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3990581353843489832L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACWholdingTaxesService giacWholdingTaxesService = (GIACWholdingTaxesService) APPLICATION_CONTEXT.getBean("giacWholdingTaxesService");
		
		try {
			if("showGiacs318".equals(ACTION)){
				JSONObject json = giacWholdingTaxesService.showGiacs318(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					PAGE = "/pages/accounting/maintenance/withholdingTax/withholdingTax.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteWhtax".equals(ACTION)){
				giacWholdingTaxesService.valDeleteWhtax(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs318".equals(ACTION)) {
				giacWholdingTaxesService.saveGiacs318(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showAllGiacs318".equals(ACTION)){
				JSONObject json = giacWholdingTaxesService.showAllGiacs318(request, USER.getUserId());
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
