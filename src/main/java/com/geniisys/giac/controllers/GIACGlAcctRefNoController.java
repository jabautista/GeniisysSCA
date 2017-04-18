/** 
 *  Created by   : Gzelle
 *  Date Created : 11-09-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.controllers;

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
import com.geniisys.giac.service.GIACGlAcctRefNoService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACGlAcctRefNoController", urlPatterns={"/GIACGlAcctRefNoController"})
public class GIACGlAcctRefNoController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2234016833393501273L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACGlAcctRefNoService giacGlAcctRefNoService = (GIACGlAcctRefNoService) APPLICATION_CONTEXT.getBean("giacGlAcctRefNoService");
		
		try {
			if("showGlAcctRefNo".equals(ACTION)){
				JSONObject json = giacGlAcctRefNoService.showKnockOffAccount(request);
				request.setAttribute("parentGlAcctId", request.getParameter("glAcctId"));
				request.setAttribute("parentSlCd", request.getParameter("slCd"));
				request.setAttribute("parentTransactionCd", request.getParameter("transactionCd"));
				request.setAttribute("addedAcctRefNo", request.getParameter("addedAcctRefNo"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonKnockOff", json);			
					PAGE = "/pages/accounting/officialReceipt/acctEntries/pop-ups/accountRefNoListing.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("valGlAcctIdGiacs030".equals(ACTION)){
				JSONArray json = giacGlAcctRefNoService.valGlAcctIdGiacs030(request);
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("getOutstandingBal".equals(ACTION)) {
				message = giacGlAcctRefNoService.getOutstandingBal(request);
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("valAddGlAcctRefNo".equals(ACTION)) {
				giacGlAcctRefNoService.valAddGlAcctRefNo(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("valRemainingBalGiacs30".equals(ACTION)){
				JSONArray json = giacGlAcctRefNoService.valRemainingBalGiacs30(request);
				message = json.toString();
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
			message = ExceptionHandler.handleException(e, USER);
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
