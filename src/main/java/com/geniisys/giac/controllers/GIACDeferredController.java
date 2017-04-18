package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACDeferredService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name="GIACDeferredController", urlPatterns="/GIACDeferredController")
public class GIACDeferredController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1132644944621847997L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION,
								HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACDeferredService giacDeferredService = (GIACDeferredService) APPLICATION_CONTEXT.getBean("giacDeferredService");
			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper"); 
			
			if ("show24thMethod".equals(ACTION)) {
				GIISParameterFacadeService parametersService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				Calendar cal=Calendar.getInstance();
				request.setAttribute("sysYear", cal.get(Calendar.YEAR));
				request.setAttribute("sysMonth", cal.get(Calendar.MONTH));
				request.setAttribute("methodListing", lovHelper.getList(LOVHelper.METHOD_LISTING));
				request.setAttribute("codeListing", lovHelper.getList(LOVHelper.CODE_LISTING));//added by Carlo Rubenecia 04.05.2016 SR 5490
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("lastExtract", parametersService.getFormattedSysdate());
				request.setAttribute("userIss", giacDeferredService.checkIss(request, USER));
				request.setAttribute("unearnedCompMethod", giacParamService.getParamValueV2("UNEARNED_COMP_METHOD")); //Added by Jerome 09.21.2016 SR 5655
				PAGE = "/pages/accounting/endOfMonth/24thMethod/24thMethodExtract.jsp";
			}else if ("checkIfDataExists".equals(ACTION)) {
				message = giacDeferredService.checkIfDataExists(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkGenTag".equals(ACTION)) {
				message = giacDeferredService.checkGenTag(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("checkStatus".equals(ACTION)) {
				message = giacDeferredService.checkStatus(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("setTranFlag".equals(ACTION)) {
				giacDeferredService.setTranFlag(request, USER);
				message = "UPDATED";
				PAGE = "/pages/genericMessage.jsp";
			}else if ("extractMethod".equals(ACTION)) {
				message = giacDeferredService.extractMethod(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("show24thMethodView".equals(ACTION)) {
				PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodView.jsp";
			}else if ("getGdMain".equals(ACTION)) {
				JSONObject gdMain = giacDeferredService.getGdMain(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = gdMain.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/gdMain.jsp";					
				}				
			}else if ("getExtractHistory".equals(ACTION)) {
				JSONObject extractHistory = giacDeferredService.getExtractHistory(request);
				if("1".equals(request.getParameter("refresh"))){
					message = extractHistory.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodExtractHistory.jsp";					
				}
			}else if ("show24thMethodViewDetails".equals(ACTION)) {
				PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodViewDetails.jsp";
			}else if ("getGdDetail".equals(ACTION)) {
				JSONObject gdDetail = giacDeferredService.getGdDetail(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = gdDetail.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/gdDetail.jsp";					
				}	
			}else if ("checkIfComputed".equals(ACTION)) {
				message = giacDeferredService.checkIfComputed(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("computeMethod".equals(ACTION)) {
				message = giacDeferredService.computeMethod(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("show24thMethodGenerateAcctgEntries".equals(ACTION)) {
				PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodGenerate.jsp";
			}else if ("cancelAcctEntries".equals(ACTION)) {
				message = giacDeferredService.cancelAcctEntries(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("reversePostedTrans".equals(ACTION)) {
				message = giacDeferredService.reversePostedTrans(request, USER);
				PAGE = "/pages/genericMessage.jsp";			
			}else if ("generateAcctEntries".equals(ACTION)) {
				message = giacDeferredService.generateAcctEntries(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("setGenTag".equals(ACTION)) {
				message = giacDeferredService.setGenTag(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getDeferredAcctEntries".equals(ACTION)) {
				JSONObject acctEntries = giacDeferredService.getDeferredAcctEntries(request);
				if("1".equals(request.getParameter("refresh"))){
					message = acctEntries.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodAccountingEntries.jsp";					
				}
			}else if ("getDeferredGLSummary".equals(ACTION)) {
				JSONObject glSummary = giacDeferredService.getDeferredGLSummary(request);
				if("1".equals(request.getParameter("refresh"))){
					message = glSummary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodGLSummary.jsp";					
				}
			}else if ("getBranchList".equals(ACTION)) {
				JSONObject branchList = giacDeferredService.getBranchList(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = branchList.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/endOfMonth/24thMethod/subPages/24thMethodPerBranch.jsp";					
				}
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
