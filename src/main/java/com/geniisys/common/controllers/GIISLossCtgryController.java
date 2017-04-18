package com.geniisys.common.controllers;

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
import com.geniisys.common.service.GIISCollateralTypeService;
import com.geniisys.common.service.GIISLossCtgryService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISLossCtgryController", urlPatterns={"/GIISLossCtgryController"})
public class GIISLossCtgryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISLossCtgryService lossCatService = (GIISLossCtgryService) APPLICATION_CONTEXT.getBean("giisLossCtgryService");
			
			if("showGICLS105".equals(ACTION)){
				JSONObject json = lossCatService.showGicls105(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonLossCtgryList", json);
					PAGE = "/pages/claims/tableMaintenance/lossCategory/lossCategory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRec".equals(ACTION)){
				lossCatService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				lossCatService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls105".equals(ACTION)) {
				lossCatService.saveGicls105(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (SQLException e) {
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
