package com.geniisys.giac.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

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
import com.geniisys.giac.service.GIACApdcPaytDtlService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet (name="GIACApdcPaytDtlController", urlPatterns={"/GIACApdcPaytDtlController"})
public class GIACApdcPaytDtlController extends BaseController{
	private static final long serialVersionUID = 138546085636672017L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIACApdcPaytDtlService giacApdcDtlService = (GIACApdcPaytDtlService) APPLICATION_CONTEXT.getBean("giacApdcPaytDtlService");
		
		try {
			if("showGiacs091".equals(ACTION)){
				JSONObject json = giacApdcDtlService.showGiacs091(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					request.setAttribute("funds", new JSONArray(giacApdcDtlService.getGiacs091Funds(USER.getUserId())));
					request.setAttribute("jsonRecList", json);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/datedChecks.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("saveGiacs091".equals(ACTION)) {
				giacApdcDtlService.saveGiacs091(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showOrParticulars".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pdcId", request.getParameter("pdcId"));
				params.put("payor", request.getParameter("payor"));
				params.put("address1", request.getParameter("address1"));
				params.put("address2", request.getParameter("address2"));
				params.put("address3", request.getParameter("address3"));
				params.put("tin", request.getParameter("tin"));
				params.put("intmNo", request.getParameter("intmNo"));
				params.put("particulars", request.getParameter("particulars"));
				//request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params))); removed by jdiago 08.05.2014 : params are escaped already in page
				request.setAttribute("objectParams", new JSONObject(params)); //added by jdiago 08.05.2014
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/particulars.jsp";
			} else if ("saveOrParticulars".equals(ACTION)) {
				giacApdcDtlService.saveOrParticulars(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showEnterMisc".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("grossAmt", request.getParameter("grossAmt"));
				params.put("commissionAmt", request.getParameter("commissionAmt"));
				params.put("vatAmt", request.getParameter("vatAmt"));
				request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/enterMisc.jsp";
			} else if ("showForeignCurrency".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currDesc", request.getParameter("currDesc"));
				params.put("convertRt", request.getParameter("convertRt"));
				params.put("fcurrencyAmt", request.getParameter("fcurrencyAmt"));
				request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/foreignCurrency.jsp";
			} else if ("showDetails".equals(ACTION)) {
				JSONObject json = giacApdcDtlService.showDatedChecksDetails(request, USER.getUserId());
				request.setAttribute("pdcId", request.getParameter("pdcId"));
				if(request.getParameter("refresh") == null) {
					request.setAttribute("jsonRecListDetails", json);
					PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/datedChecksDetails.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("showBreakdown".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("taxAmt", request.getParameter("taxAmt"));
				params.put("premiumAmt", request.getParameter("premiumAmt"));
				request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params)));
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/breakdown.jsp";
			} else if ("showApplyBank".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("applyMode", request.getParameterValues("applyMode"));
				params.put("checkDate", request.getParameterValues("checkDate"));
				params.put("group", request.getParameterValues("group"));
				request.setAttribute("objectParams", new JSONObject(StringFormatter.escapeHTMLInMap(params)));//changed JSONArray to JSONObject to avoid exception by carlo SR 23544 12/13/2016
				PAGE = "/pages/accounting/cashReceipts/enterTransactions/pdcPayment/datedChecks/overlay/applyBank.jsp";
			} else if ("multipleOR".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacApdcDtlService.multipleOR(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("groupOr".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacApdcDtlService.groupOr(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateDcbNo".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacApdcDtlService.validateDcbNo(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("createDbcNo".equals(ACTION)) {
				giacApdcDtlService.createDbcNo(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("giacs091DefaultBank".equals(ACTION)) {
				request.setAttribute("object", new JSONObject(StringFormatter.escapeHTMLInMap(giacApdcDtlService.giacs091DefaultBank(request, USER.getUserId()))));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs091ValidateTransactionDate".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("checkDate", request.getParameter("checkDate"));
				request.setAttribute("object", giacApdcDtlService.giacs091ValidateTransactionDate(params));
				PAGE = "/pages/genericObject.jsp";
			} else if ("giacs091CheckSOABalance".equals(ACTION)) { /*added by MarkS 12.13.2016 SR5881*/
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pdcId", request.getParameter("pdcId"));
				request.setAttribute("object", giacApdcDtlService.giacs091CheckSOABalance(params));
				PAGE = "/pages/genericObject.jsp";
			}
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
