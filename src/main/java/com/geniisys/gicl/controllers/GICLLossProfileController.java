package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
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
import com.geniisys.gicl.service.GICLLossProfileService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GICLLossProfileController", urlPatterns={"/GICLLossProfileController"})
public class GICLLossProfileController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossProfileService giclLossProfileService = (GICLLossProfileService) APPLICATION_CONTEXT.getBean("giclLossProfileService");
		
		try{
			if("showGICLS211".equals(ACTION)){
				JSONObject jsonLossProfileParam = giclLossProfileService.showLossProfileParam(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossProfileParam.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
					Map<String, Object> formVariables = giclLossProfileService.whenNewFormInstance();
					
					request.setAttribute("formVariables", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(formVariables)));
					request.setAttribute("printers", printers);
					request.setAttribute("jsonLossProfileParam", jsonLossProfileParam);
					//marco - 1/30/2014 - change page to lossProfile.jsp for old version
					PAGE = "/pages/claims/reports/lossProfile/lossProfile2.jsp";
				}
			}else if("showRange".equals(ACTION)){
				JSONObject jsonLossProfileRange = giclLossProfileService.showRange(request, USER.getUserId());
				message = jsonLossProfileRange.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("saveProfile".equals(ACTION)){
				giclLossProfileService.saveProfile(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractLossProfile".equals(ACTION)){
				message = giclLossProfileService.extractLossProfile(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("showLossProfileSummary".equals(ACTION)){
				JSONObject jsonLossProfileSummary = giclLossProfileService.showLossProfileSummary(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossProfileSummary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLossProfileSummary", jsonLossProfileSummary);
					PAGE = "/pages/claims/reports/lossProfile/lossProfileDetails/subPages/summary.jsp";
				}
			}else if("showLossProfileDetails".equals(ACTION)){
				JSONObject jsonRangeDtl = giclLossProfileService.showRange(request, USER.getUserId());
				
				/*JSONObject jsonDetailList = giclLossProfileService.showLossProfileDetail(request, USER.getUserId());
				request.setAttribute("jsonDetailList", jsonDetailList);*/
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRangeDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRangeDtl", jsonRangeDtl);
					PAGE = "/pages/claims/reports/lossProfile/lossProfileDetails/subPages/details.jsp";
				}
			}else if("showDetail".equals(ACTION)){
				JSONObject jsonDetailList = giclLossProfileService.showLossProfileDetail(request, USER.getUserId());
				message = jsonDetailList.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkRecovery".equals(ACTION)){
				message = giclLossProfileService.checkRecovery(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showRecoveryListing".equals(ACTION)){
				JSONObject jsonRecoveryDtl = giclLossProfileService.showRecoveryListing(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRecoveryDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRecoveryDtl", jsonRecoveryDtl);
					PAGE = "/pages/claims/reports/lossProfile/lossProfileDetails/subPages/lossProfileRecovery.jsp";
				}
			}else if("validateRange".equals(ACTION)){
				giclLossProfileService.validateRange(request, USER.getUserId());
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
