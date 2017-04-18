package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLossCtgryService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLAdvLineAmtService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLAdvLineAmtController", urlPatterns={"/GICLAdvLineAmtController"})
public class GICLAdvLineAmtController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -212171001297508769L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLAdvLineAmtService giclAdvLineAmtService = (GICLAdvLineAmtService) APPLICATION_CONTEXT.getBean("giclAdvLineAmtService");
		GIISLossCtgryService lossCatService = (GIISLossCtgryService) APPLICATION_CONTEXT.getBean("giisLossCtgryService");
		
		try {
			if("getRangeTo".equals(ACTION)){
				BigDecimal rangeTo = giclAdvLineAmtService.getRangeTo(request);
				if(rangeTo != null){
					message =  rangeTo.toString();
				} else {
					message = null;
				}
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS182".equals(ACTION)){
				JSONObject json = giclAdvLineAmtService.showGicls182(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonAdvLineAmtList", json);
					PAGE = "/pages/claims/tableMaintenance/adviceApprovalLimit/adviceApprovalLimit.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveGicls182".equals(ACTION)){
				giclAdvLineAmtService.saveGicls182(request, USER.getUserId());
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
