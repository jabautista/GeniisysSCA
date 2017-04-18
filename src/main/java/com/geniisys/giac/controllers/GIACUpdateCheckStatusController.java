package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACUpdateCheckStatusService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACUpdateCheckStatusController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -8678466714965069141L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACUpdateCheckStatusService giacUpdateCheckStatusService = (GIACUpdateCheckStatusService) APPLICATION_CONTEXT.getBean("giacUpdateCheckStatusService");
			if ("showUpdateCheckStatus".equals(ACTION)) {
				giacUpdateCheckStatusService.showUpdateCheckStatus(request,USER);
				PAGE = "/pages/accounting/generalDisbursements/updateCheckStatus/updateCheckStatusPage.jsp";
			}else if ("showBankAccount".equals(ACTION)) {
				JSONObject jsonBankAccount = giacUpdateCheckStatusService.showBankAccount(request,USER);
				message = jsonBankAccount.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showDisbursementAccount".equals(ACTION)) {
				JSONObject jsonBankAccount = giacUpdateCheckStatusService.showDisbursementAccount(request,USER);
				message = jsonBankAccount.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveChkDisbursement".equals(ACTION)) {
				giacUpdateCheckStatusService.saveChkDisbursement(request,USER);
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
