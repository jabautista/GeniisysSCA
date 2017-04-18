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
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.geniisys.giac.service.GIACPdcChecksService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACPdcChecksController", urlPatterns={"/GIACPdcChecksController"})
public class GIACPdcChecksController extends BaseController {
	private static final long serialVersionUID = -252245052858622093L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACPdcChecksService giacPdcChecksService = (GIACPdcChecksService) APPLICATION_CONTEXT.getBean("giacPdcChecksService");
		
		try {
			if("showGiacs032".equals(ACTION)){
				JSONObject json = giacPdcChecksService.showGiacs032(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecList", json);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/postDatedChecks/postDatedChecks.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showForDeposit".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("itemId", request.getParameter("itemId"));
				params.put("checkNo", request.getParameter("checkNo"));
				params.put("checkDate", request.getParameter("checkDate"));
				params.put("refNo", request.getParameter("refNo"));
				params.put("itemNo", request.getParameter("itemNo"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/postDatedChecks/overlay/forDeposit.jsp";
			}  else if ("checkDateForDeposit".equals(ACTION)){
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacPdcChecksService.checkDateForDeposit(request))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("saveForDeposit".equals(ACTION)) {
				giacPdcChecksService.saveForDeposit(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showReplacementHistory".equals(ACTION)){
				JSONObject json = giacPdcChecksService.showReplacementHistory(request);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("itemNo", request.getParameter("itemNo"));
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecList", json);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/postDatedChecks/overlay/replacementHistory.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if("showPrintPostDatedChecks".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/printPostDatedChecks/printPostDatedChecks.jsp";
			} else if("showReplacePostDatedChecks".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("itemId", request.getParameter("itemId"));
				params.put("checkNo", request.getParameter("checkNo"));
				params.put("bankSname", request.getParameter("bankSname"));
				params.put("amount", request.getParameter("amount"));
				params.put("gaccTranId", request.getParameter("gaccTranId"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("itemNo", request.getParameter("itemNo"));
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/postDatedChecks/overlay/replacePostDatedChecks.jsp";
			} else if ("saveReplacePDC".equals(ACTION)) {
				giacPdcChecksService.saveReplacePDC(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("showGiacs031".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
				GIACParameterFacadeService giacParamService = (GIACParameterFacadeService) APPLICATION_CONTEXT.getBean("giacParameterFacadeService");
				
				String[] transType = {"GIAC_DIRECT_PREM_COLLNS.TRANSACTION_TYPE"};
				request.setAttribute("tranTypeLOV", lovHelper.getList(LOVHelper.TRANSACTION_TYPE_PARAM, transType));
				String[] argsIssCd = {"GIACS031", USER.getUserId()};
				request.setAttribute("issueSourceList", lovHelper.getList(LOVHelper.ACCTG_ISSUE_CD_LISTING, argsIssCd));
				request.setAttribute("oldIssCd", giacParamService.getParamValueV2("OLD_ISS_CD"));
				request.setAttribute("branchCd", giacParamService.getParamValueV2("BRANCH_CD"));
				
				JSONObject json = giacPdcChecksService.showGiacs031(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecList", json);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/applyPostDatedChecks/applyPostDatedChecks.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valAddRec".equals(ACTION)){
				giacPdcChecksService.valAddRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("saveGiacs031".equals(ACTION)) {
				giacPdcChecksService.saveGiacs031(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGiacs031ForeignCurr".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currencyCd", request.getParameter("currencyCd"));
				params.put("currencyDesc", request.getParameter("currencyDesc"));
				params.put("currencyRt", request.getParameter("currencyRt"));
				params.put("fcurrencyAmt", request.getParameter("fcurrencyAmt"));
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/applyPostDatedChecks/subPages/foreignCurrency.jsp";
			} else if ("queryPolicy".equals(ACTION)){
				JSONObject jsonPolicy = giacPdcChecksService.queryPolicyDummyTable(request);
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonPolicy", jsonPolicy);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/applyPostDatedChecks/subPages/policyPopup.jsp";
				} else {
					message = jsonPolicy.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("applyPDC".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(giacPdcChecksService.applyPDC(request, USER.getUserId())));
				PAGE = "/pages/genericObject.jsp";
			}
		}catch (SQLException e) {
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
