package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportsService;
import com.geniisys.common.service.GIISUserFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLPrintPLAFLAService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GICLPrintPLAFLAController",  urlPatterns={"/GICLPrintPLAFLAController"})
public class GICLPrintPLAFLAController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GICLPrintPLAFLAController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		log.info("Initializing: "+ this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLPrintPLAFLAService giclPrintPLAFLAService = (GICLPrintPLAFLAService) APPLICATION_CONTEXT.getBean("giclPrintPLAFLAService");
		GIISUserFacadeService giisUserFacadeService = (GIISUserFacadeService) APPLICATION_CONTEXT.getBean("giisUserFacadeService");
		
		try {
			if("showPrintPLAFLAPage".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", (request.getParameter("lineCd") != null && !request.getParameter("lineCd").equals("")) ? request.getParameter("lineCd") : null);
				String newAction = (request.getParameter("currentView") != null && !request.getParameter("currentView").equals("") && request.getParameter("currentView").equals("F")) ? "getUnprintedFLAListing" : "getUnprintedPLAListing";
				params.put("ACTION", newAction);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					params.put("allUserSw", request.getParameter("allUserSw"));
					params.put("validTag", request.getParameter("validTag"));
					params.put("moduleId", request.getParameter("moduleId"));
					params.put("userId", USER.getUserId());
					params = TableGridUtil.getTableGrid(request, params);
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					params.put("functionCd", "PP");
					params.put("moduleId", 178);
					params.put("userId", USER.getUserId());
					params.put("allUserSw", null);
					params.put("validTag", null);
					params = giisUserFacadeService.checkUserStat(params);
					request.setAttribute("userParams", new JSONObject(params));
					System.out.println("params returned: "+params);
					
					params.put("moduleId", request.getParameter("moduleId"));
					params = TableGridUtil.getTableGrid(request, params);
					System.out.println("params for tablegrid: "+params);
					
					request.setAttribute("plaList", params != null ? new JSONObject(params) : new JSONObject());
					PAGE = "/pages/claims/reports/printPLAFLA/printPLAFLA.jsp";
				}
				
			} else if("queryCountLossAdvice".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params = giclPrintPLAFLAService.queryCountLossAdvice(request, USER.getUserId());
				JSONObject json = new JSONObject(params);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateReportId".equals(ACTION)){
				GIISReportsService giisReportsService = (GIISReportsService) APPLICATION_CONTEXT.getBean("giisReportsService");
				message = giisReportsService.validateReportId(request.getParameter("reportId"));
				PAGE = "/pages/genericMessage.jsp";
			} else if("tagPlaAsPrinted".equals(ACTION)){
				message = giclPrintPLAFLAService.tagPlaAsPrinted(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			} else if("tagFlaAsPrinted".equals(ACTION)){
				message = giclPrintPLAFLAService.tagFlaAsPrinted(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch(SQLException e) {
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
