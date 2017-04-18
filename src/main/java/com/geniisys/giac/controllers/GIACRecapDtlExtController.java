package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACRecapDtlExtService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACRecapDtlExtController", urlPatterns={"/GIACRecapDtlExtController"})
public class GIACRecapDtlExtController extends BaseController{
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
			GIACRecapDtlExtService giacRecapDtlExtService = (GIACRecapDtlExtService) appContext.getBean("giacRecapDtlExtService");
			
			if("showRecapsI-V".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				
				Map<String, Object> formVariables = giacRecapDtlExtService.getRecapVariables();
				request.setAttribute("formVariables", new JSONObject((HashMap<String, Object>) formVariables));
				
				PAGE = "/pages/accounting/generalLedger/report/recapsI-V/recapsI-V.jsp";
			}else if("showRecapDetails".equals(ACTION)){
				JSONObject recapDetailsJSON = giacRecapDtlExtService.getRecapDetailsTableGrid(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = recapDetailsJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("recapDetailsJSON", recapDetailsJSON);
					PAGE = "/pages/accounting/generalLedger/report/recapsI-V/popups/recapsI-VDetails.jsp";
				}
			}else if("showLineDetails".equals(ACTION)){
				JSONObject lineDetailsJSON = giacRecapDtlExtService.getRecapLineDetailsTableGrid(request);
				
				if("1".equals(request.getParameter("refresh"))){
					message = lineDetailsJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("lineDetailsJSON", lineDetailsJSON);
					PAGE = "/pages/accounting/generalLedger/report/recapsI-V/popups/recapsI-VLineDetails.jsp";
				}
			}else if("extractRecap".equals(ACTION)){
				giacRecapDtlExtService.extractRecap(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkDataFetched".equals(ACTION)){
				request.setAttribute("object", giacRecapDtlExtService.checkDataFetched());
				PAGE = "/pages/genericObject.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
