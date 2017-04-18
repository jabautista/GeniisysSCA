package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.service.GIACBankAccountsService;
import com.seer.framework.util.ApplicationContextReader;

public class GIACBankAccountsController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIACBankAccountsController.class);

	@SuppressWarnings("deprecation")
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACBankAccountsService bankAcctService = (GIACBankAccountsService) APPLICATION_CONTEXT.getBean("giacBankAccountsService");
		
		try {
			if ("showBankAcctNoLOV".equals(ACTION)) {
				
				PAGE = "/pages/accounting/dcb/pop-ups/showBankAcctNoLOV.jsp";
			} else if ("getBankAcctNoListing".equals(ACTION)) {				
				String keyword = request.getParameter("keyword");
				
				if (null==keyword) {
					keyword = "";
				}
				
				PaginatedList searchResult = null;
				Integer pageNo = 0;
				
				if (null != request.getParameter("pageNo")) {
					if (!"undefined".equals(request.getParameter("pageNo"))) {
						pageNo = new Integer(request.getParameter("pageNo")) - 1;
					}
				}
				
				searchResult = bankAcctService.getBankAcctNoLOV(pageNo, keyword);
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchBankAcctNoLOVAjaxResult.jsp";
			} else if("showGiacs312".equals(ACTION)){
				JSONObject json = bankAcctService.showGiacs312(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonBankAccountList", json);
					PAGE = "/pages/accounting/maintenance/bankAccount/bankAccount.jsp";
				} else {					
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				bankAcctService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddRec".equals(ACTION)){
				bankAcctService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiacs312".equals(ACTION)) {
				bankAcctService.saveGiacs312(request, USER.getUserId());
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
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
