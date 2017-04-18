package com.geniisys.common.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISReportParameter;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReportParameterService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIISReportParameterController", urlPatterns="/GIISReportParameterController")
public class GIISReportParameterController extends BaseController {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 5294649608120690217L;
	
	private static Logger log = Logger.getLogger(GIISReportParameter.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";		
			
			GIISReportParameterService giisReportParameterService = (GIISReportParameterService) APPLICATION_CONTEXT.getBean("giisReportParameterService");
			if("getReportParameterList".equals(ACTION)) { // For retrieving Report Parameter list used for maintenance
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);				
				params.put("appUser", USER.getUserId());
				
				Map<String, Object> reportParameterMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonReportParameter = new JSONObject(reportParameterMaintenance);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					message = jsonReportParameter.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonReportParameter", jsonReportParameter);
					PAGE = "/pages/underwriting/fileMaintenance/system/reportParameter/reportParameterMaintenance.jsp";
				}				
			}else if("saveReportParameter".equals(ACTION)){
				log.info("Saving Report Parameter Maintenance...");
				Map<String, Object> params = new HashMap<String, Object>();
				params = giisReportParameterService.saveReportParameter(request.getParameter("parameters"), USER);
				Map<String, Object> paramsOut = new HashMap<String, Object>();
				paramsOut.put("message", params.get("message"));
				JSONObject result = new JSONObject(paramsOut);
				message = result.toString();
				PAGE = "/pages/genericMessage.jsp";		
			}
		} catch (NullPointerException e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}