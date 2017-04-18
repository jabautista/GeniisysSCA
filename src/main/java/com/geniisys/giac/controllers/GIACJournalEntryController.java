package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACJournalEntryService;
import com.seer.framework.util.ApplicationContextReader;

/**
 * @author steven
 *
 */
public class GIACJournalEntryController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 3520645133946552932L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACJournalEntryService giacJournalEntryService = (GIACJournalEntryService) APPLICATION_CONTEXT.getBean("giacJournalEntryService");
			if ("showJournalListing".equals(ACTION)) {
				if("1".equals(request.getParameter("refresh"))){
					JSONObject objJournalListing = giacJournalEntryService.getJournalListing(request,USER.getUserId());
					message = objJournalListing.toString();
					PAGE =  "/pages/genericMessage.jsp";
				}else{
					String action2 = request.getParameter("action2");
					if (action2.equals("getCancelJVList")) {
						request.setAttribute("isCancelJVList", "Y");
					}else{
						request.setAttribute("isCancelJVList", "N");
					}
					PAGE = "/pages/accounting/generalLedger/journalEntryList/journalEntryListing.jsp";
				}
			}else if("showJournalEntries".equals(ACTION)){
				giacJournalEntryService.getJournalEntries(request,USER.getUserId());
				PAGE = "/pages/accounting/generalLedger/enterJournalEntries/enterJournalEntries.jsp";
			}else if ("setGiacAcctrans".equals(ACTION)) {
				JSONArray objJsonArray =  new JSONArray(giacJournalEntryService.setGiacAcctrans(request,USER));
				message = objJsonArray.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateCash".equals(ACTION)) {
				message = giacJournalEntryService.getJVTranType(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateTranDate".equals(ACTION)) {
				message = giacJournalEntryService.validateTranDate(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("printOpt".equals(ACTION)) { 
				JSONObject printOptObj =  new JSONObject(giacJournalEntryService.printOpt(request));
				message = printOptObj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkUserPerIssCdAcctg".equals(ACTION)) {
				message = giacJournalEntryService.checkUserPerIssCdAcctg(request,USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkCommPayts".equals(ACTION)) {
				System.out.println("steven "+giacJournalEntryService.checkCommPayts(request));
				message = giacJournalEntryService.checkCommPayts(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("saveCancelOpt".equals(ACTION)) {
				JSONArray cancelOptObj =  new JSONArray(giacJournalEntryService.saveCancelOpt(request,USER));
				message = cancelOptObj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getDetailModule".equals(ACTION)) {
				message = giacJournalEntryService.getDetailModule(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("showDVInfo".equals(ACTION)) {
				JSONArray dvInfoObj =  new JSONArray(giacJournalEntryService.showDVInfo(request));
				message = dvInfoObj.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("validateJVCancel".equals(ACTION)){ // added by John Daniel SR-5128
				message = giacJournalEntryService.validateJVCancel(request);
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
