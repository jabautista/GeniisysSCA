/**
 * 
 */
package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLBatchOSPrintingService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */
@WebServlet(name= "GICLBatchOSPrintingController", urlPatterns={"/GICLBatchOSPrintingController"})
public class GICLBatchOSPrintingController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 864160860274024690L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GICLBatchOSPrintingService giclBatchOSPrintingService = (GICLBatchOSPrintingService) APPLICATION_CONTEXT.getBean("giclBatchOSPrintingService");
			if (ACTION.equals("showBatchOSPrinting")) {
				JSONObject jsonBatchOS = giclBatchOSPrintingService.showBatchOSPrinting(request,USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonBatchOS.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonBatchOS", jsonBatchOS);
					PAGE = "/pages/claims/reports/batchOSPrinting/batchOSPrinting.jsp";
				}
			}else if (ACTION.equals("getBatchOSRecord")) {
				JSONArray jsonArrayBatchOS = new JSONArray(giclBatchOSPrintingService.getBatchOSRecord(request,USER)); 
				message = jsonArrayBatchOS.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if (ACTION.equals("getBatchOSLossExpRecord")) {
				JSONArray jsonArrayBatchOS = new JSONArray(giclBatchOSPrintingService.getBatchOSRecord(request,USER)); 
				message = jsonArrayBatchOS.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if (ACTION.equals("extractOSDetail")) {
				giclBatchOSPrintingService.extractOSDetail(request,USER); 
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
