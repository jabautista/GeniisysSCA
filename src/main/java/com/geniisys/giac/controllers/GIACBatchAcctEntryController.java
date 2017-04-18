/**
 * 
 */
package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBatchAcctEntryService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 * @date 04.11.2013
 */
public class GIACBatchAcctEntryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -9164688906349357301L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACBatchAcctEntryService giacBatchAcctEntryService = (GIACBatchAcctEntryService) APPLICATION_CONTEXT.getBean("giacBatchAcctEntryService");
			if ("showBatchAccountingEntry".equals(ACTION)) {
				giacBatchAcctEntryService.showBatchAccountingEntry(request,USER);
				PAGE = "/pages/accounting/endOfMonth/batchAccountingEntry/batchAccountingEntry.jsp";
			}else if ("validateProdDate".equals(ACTION)) {
				JSONArray prodDateArray = new JSONArray(giacBatchAcctEntryService.validateProdDate(request));
				message = prodDateArray.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("generateDataCheck".equals(ACTION)) {
				JSONArray dateCheckArray = new JSONArray(giacBatchAcctEntryService.generateDataCheck(request,USER));
				message = dateCheckArray.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("giacb000Proc".equals(ACTION)) {
				JSONArray genAccountingEntryArray = new JSONArray(giacBatchAcctEntryService.genAccountingEntry(request,USER));
				message = genAccountingEntryArray.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("prodSumRepAndPerilExt".equals(ACTION)) {
				giacBatchAcctEntryService.prodSumRepAndPerilExt(request,USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateWhenExit".equals(ACTION)) {
				giacBatchAcctEntryService.validateWhenExit();
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
