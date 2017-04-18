/** 
 *  Created by   : Gzelle
 *  Date Created : 10-29-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACGlSubAccountTypesService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACGlSubAccountTypesController", urlPatterns={"/GIACGlSubAccountTypesController"})
public class GIACGlSubAccountTypesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2234016833393501273L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACGlSubAccountTypesService giacGlSubAccountTypesService = (GIACGlSubAccountTypesService) APPLICATION_CONTEXT.getBean("giacGlSubAccountTypesService");
		
		try {
			if("showGiacs341".equals(ACTION)){
				JSONObject json = giacGlSubAccountTypesService.showGiacs341(request);
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"YES NO"};
					List<LOV> activeTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("activeTagLOV", activeTagLOV);
					request.setAttribute("jsonGlSubAccountTypes", json);	
					request.setAttribute("ledgerCd", request.getParameter("ledgerCd"));
					request.setAttribute("ledgerDesc", request.getParameter("ledgerDesc"));
					PAGE = "/pages/accounting/maintenance/glSubAccountTypes/glSubAccountTypes.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDelGlSubAcctType".equals(ACTION)){
				giacGlSubAccountTypesService.valDelGlSubAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddGlSubAcctType".equals(ACTION)){
				giacGlSubAccountTypesService.valAddGlSubAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";			
			} else if ("valUpdGlSubAcctType".equals(ACTION)){
				giacGlSubAccountTypesService.valUpdGlSubAcctType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";	
			}else if("getAllGlAcctIdGiacs341".equals(ACTION)){
				JSONArray jsonGlAcctIdList = giacGlSubAccountTypesService.getAllGlAcctIdGiacs341(request);
				message = jsonGlAcctIdList.toString();
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs341".equals(ACTION)) {
				giacGlSubAccountTypesService.saveGiacs341(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showTransactionTypes".equals(ACTION)){
				JSONObject json = giacGlSubAccountTypesService.showTransactionTypes(request);
				if(request.getParameter("refresh") == null) {
					LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String[] params = {"YES NO"};
					List<LOV> activeTagLOV = lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, params);
					request.setAttribute("activeTagLOV", activeTagLOV);
					request.setAttribute("jsonGlTransactionTypes", json);
					request.setAttribute("ledgerCd", request.getParameter("ledgerCd"));
					request.setAttribute("subLedgerCd", request.getParameter("subLedgerCd"));
					PAGE = "/pages/accounting/maintenance/glSubAccountTypes/subPages/glTransactionTypes.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDelGlTransactionType".equals(ACTION)){
				giacGlSubAccountTypesService.valDelGlTransactionType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddGlTransactionType".equals(ACTION)){
				giacGlSubAccountTypesService.valAddGlTransactionType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";		
			} else if ("valUpdGlTransactionType".equals(ACTION)){
				giacGlSubAccountTypesService.valUpdGlTransactionType(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";					
			} else if ("saveGlTransactionType".equals(ACTION)) {
				giacGlSubAccountTypesService.saveGlTransactionType(request, USER.getUserId());
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
