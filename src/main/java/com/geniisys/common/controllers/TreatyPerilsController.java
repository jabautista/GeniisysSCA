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
import com.geniisys.common.service.TreatyPerilsService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="TreatyPerilsController", urlPatterns={"/TreatyPerilsController"})
public class TreatyPerilsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		TreatyPerilsService treatyPerilsService = (TreatyPerilsService) APPLICATION_CONTEXT.getBean("treatyPerilsService");
		try {
			if("showGiris007".equals(ACTION)){
				if("GIISS031".equals(request.getParameter("callForm"))){					
					if("2".equals(request.getParameter("shareType"))){
						JSONObject jsonDistShare = treatyPerilsService.showGiris007DistShare(request, USER.getUserId());
						if(request.getParameter("refresh") == null) {
							request.setAttribute("jsonDistShareList", jsonDistShare);
							PAGE = "/pages/underwriting/fileMaintenance/reinsurance/proportionalTreatyPeril/proportionalTreatyPeril.jsp";
						} else {
							message = jsonDistShare.toString();
							PAGE = "/pages/genericMessage.jsp";
						}
					} else {
						JSONObject jsonXol = treatyPerilsService.showGiris007Xol(request, USER.getUserId());
						if(request.getParameter("refresh") == null) {
							request.setAttribute("jsonXolList", jsonXol);
							PAGE = "/pages/underwriting/fileMaintenance/reinsurance/nonProportionalTreatyPeril/nonProportionalTreatyPeril.jsp";
						} else {
							message = jsonXol.toString();
							PAGE = "/pages/genericMessage.jsp";
						}
					}
				} else {
					if("Y".equals(request.getParameter("proportionalTreaty"))){
						JSONObject jsonDistShare = treatyPerilsService.showGiris007DistShare(request, USER.getUserId());
						if(request.getParameter("refresh") == null) {
							request.setAttribute("jsonDistShareList", jsonDistShare);
							JSONObject jsonA6401 = treatyPerilsService.executeA6401(request, USER.getUserId());
							request.setAttribute("jsonA6401List", jsonA6401);
							PAGE = "/pages/underwriting/fileMaintenance/reinsurance/proportionalTreatyPeril/proportionalTreatyPeril.jsp";
						} else {
							request.setAttribute("jsonDistShareList", jsonDistShare);
							message = jsonDistShare.toString();
							PAGE = "/pages/genericMessage.jsp";
						}
					} else {
						JSONObject jsonXol = treatyPerilsService.showGiris007Xol(request, USER.getUserId());
						if(request.getParameter("refresh") == null) {
							JSONObject jsonTrtyPerilXol = treatyPerilsService.executeTrtyPerilXol(request, USER.getUserId());
							request.setAttribute("jsonXolList", jsonXol);
							request.setAttribute("jsonTrtyPerilXol", jsonTrtyPerilXol);
							PAGE = "/pages/underwriting/fileMaintenance/reinsurance/nonProportionalTreatyPeril/nonProportionalTreatyPeril.jsp";
						} else {
							request.setAttribute("jsonXolList", jsonXol);
							message = jsonXol.toString();
							PAGE = "/pages/genericMessage.jsp";
						}
					}
				}
			} else if("executeA6401".equals(ACTION)){
				JSONObject jsonA6401 = treatyPerilsService.executeA6401(request, USER.getUserId());
				request.setAttribute("jsonA6401List", jsonA6401);
				message = jsonA6401.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddA6401Rec".equals(ACTION)){
				treatyPerilsService.valAddA6401Rec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveA6401".equals(ACTION)) {
				treatyPerilsService.saveA6401(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("includeAllA6401".equals(ACTION)){
				JSONObject jsonA6401 = treatyPerilsService.includeAllA6401(request, USER.getUserId());
				request.setAttribute("jsonA6401List", jsonA6401);
				message = jsonA6401.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("executeTrtyPerilXol".equals(ACTION)){
				JSONObject jsonTrtyPerilXol = treatyPerilsService.executeTrtyPerilXol(request, USER.getUserId());
				request.setAttribute("jsonTrtyPerilXol", jsonTrtyPerilXol);
				message = jsonTrtyPerilXol.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddTrtyPerilXolRec".equals(ACTION)){
				treatyPerilsService.valAddTrtyPerilXolRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveTrtyPerilXol".equals(ACTION)) {
				treatyPerilsService.saveTrtyPerilXol(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getAllPerils".equals(ACTION)){
				request.setAttribute("object", treatyPerilsService.getAllPerils(request));
				PAGE = "/pages/genericObject.jsp";
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
