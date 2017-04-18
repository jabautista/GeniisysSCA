package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.common.service.GIISLossExpService;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIISLossExpController", urlPatterns={"/GIISLossExpController"})
public class GIISLossExpController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIISLossExpService giisLossExpService = (GIISLossExpService) APPLICATION_CONTEXT.getBean("giisLossExpService");
		GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
		GIISLineFacadeService giisLineService = (GIISLineFacadeService) APPLICATION_CONTEXT.getBean("giisLineFacadeService");
		
		try {
			if("showGicls104".equals(ACTION)){
				JSONObject json = giisLossExpService.showGicls104(request, USER.getUserId());
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					String giispLineCdMC = giisParameterFacadeService.getParamValueV("LINE_CODE_MC").getParamValueV();
					request.setAttribute("giispLineCdMC", giispLineCdMC);
					request.setAttribute("giispLineNameMC", giisLineService.getGiisLineName2(giispLineCdMC));
					PAGE = "/pages/claims/tableMaintenance/lossExpense/lossExpense.jsp";
				}				
			} else if ("valDeleteRec".equals(ACTION)){
				giisLossExpService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giisLossExpService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGicls104".equals(ACTION)) {
				giisLossExpService.saveGicls104(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validatePartSw".equals(ACTION)){
				Map<String, Object> params = giisLossExpService.valPartSw(request);
				JSONObject json = params != null ? new JSONObject(params) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateLpsSw".equals(ACTION)){
				message = giisLossExpService.valLpsSw(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateCompSw".equals(ACTION)){
				Map<String, Object> params = giisLossExpService.valCompSw(request);
				JSONObject json = params != null ? new JSONObject(params) : new JSONObject();
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateLossExpType".equals(ACTION)){				
				message = giisLossExpService.valLossExpType(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getOrigSurplusAmt".equals(ACTION)){ //Added by Kenneth L. 06.11.2015 SR 3626 @lines 82 - 87	
				Map<String, Object> params = giisLossExpService.getOrigSurplusAmt(request);
				JSONObject jsonAmount = new JSONObject(params);
				message = jsonAmount.toString();
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
