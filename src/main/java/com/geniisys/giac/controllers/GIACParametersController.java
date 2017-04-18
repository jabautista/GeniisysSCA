package com.geniisys.giac.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.exceptions.BatchAccountingProcessInProgressException;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACParametersController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
			if ("checkBatchAccountingProcess".equals(ACTION)) {
				
				String allowProcess = giacParamService.getParamValueV2("ALLOW_SPOILAGE");
				
				if (allowProcess == null) {
					allowProcess = "N";
				}
				
				if ("N".equals(allowProcess)) {
					throw new BatchAccountingProcessInProgressException("Batch Accounting Process is currently in progress. You are not yet allowed to redistribute policies.");
				}
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkGIACParameter".equals(ACTION)){
				
				message = giacParamService.getParamValueV2(request.getParameter("paramName"));
				System.out.println(message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGiacs301".equals(ACTION)){
				JSONObject json = giacParamService.showGiacs301(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonAcctgParameterList", json);
					PAGE = "/pages/accounting/maintenance/accountingSetup/parameter/parameter.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if ("valDeleteRec".equals(ACTION)){
				giacParamService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				giacParamService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs301".equals(ACTION)) {
				giacParamService.saveGiacs301(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (BatchAccountingProcessInProgressException e) {
			message = e.getMessage();
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
