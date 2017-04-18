package com.geniisys.giac.controllers;

import java.io.IOException;

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
import com.geniisys.giac.service.GIACCopyJVService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACCopyJVController", urlPatterns="/GIACCopyJVController")
public class GIACCopyJVController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACCopyJVService giacCopyJVService = (GIACCopyJVService) APPLICATION_CONTEXT.getBean("giacCopyJVService");
			
			if("showCopyJV".equals(ACTION)) {
				PAGE = "/pages/accounting/generalLedger/utilities/copyJV/copyJV.jsp";
			} else if ("giacs051CheckCreateTransaction".equals(ACTION)) {
				String tag = giacCopyJVService.giacs051CheckCreateTransaction(request);
				request.setAttribute("object", tag);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051CopyJV".equals(ACTION)) {
				request.setAttribute("object", giacCopyJVService.giacs051CopyJV(request, USER.getUserId()));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051ValidateBranchCdFrom".equals(ACTION)) {
				String check = giacCopyJVService.giacs051ValidateBranchCdFrom(request, USER.getUserId());
				request.setAttribute("object", check);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051ValidateDocYear".equals(ACTION)) {
				String check = giacCopyJVService.giacs051ValidateDocYear(request);
				request.setAttribute("object", check);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051ValidateDocMm".equals(ACTION)) {
				String check = giacCopyJVService.giacs051ValidateDocMm(request);
				request.setAttribute("object", check);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051ValidateDocSeqNo".equals(ACTION)) {
				JSONObject json = new JSONObject(giacCopyJVService.giacs051ValidateDocSeqNo(request));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs051ValidateBranchCdTo".equals(ACTION)) {
				String check = giacCopyJVService.giacs051ValidateBranchCdTo(request, USER.getUserId());
				request.setAttribute("object", check);
				PAGE = "/pages/genericObject.jsp";
			} else if  ("showNewTransactionNo".equals(ACTION)) {
				PAGE = "/pages/accounting/generalLedger/utilities/copyJV/newTransactionNo.jsp";
			}
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
