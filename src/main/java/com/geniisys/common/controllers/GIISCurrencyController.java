package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISCurrencyService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIISCurrencyController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIISCurrencyController.class);
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("");
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			PAGE = "/pages/genericMessage.jsp";
			
			if ("openSearchGIISCurrencyLOV".equals(ACTION)) {
				
				PAGE = "/pages/pop-ups/searchCurrencyLOV.jsp";
			} else if ("getGIISCurrencyLOV".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
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
				
				searchResult = giisCurrencyService.getGiisCurrencyLOV(pageNo, keyword);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/pop-ups/searchCurrencyLOVAjaxResult.jsp";
			} else if ("showDCBCurrencyLOV".equals(ACTION)) {
				request.setAttribute("payMode", request.getParameter("payMode"));
				
				PAGE = "/pages/accounting/dcb/pop-ups/showDCBCurrencyLOV.jsp";
			} else if ("getDCBCurrencyListing".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				String keyword = request.getParameter("keyword");
				Map<String, Object> params = new HashMap<String, Object>();
				
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
				
				params.put("gibrBranchCd", request.getParameter("gibrBranchCd"));
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("dcbNo", (request.getParameter("dcbNo") == null) ? null : (request.getParameter("dcbNo").isEmpty() ? null : new Integer(request.getParameter("dcbNo"))));
				params.put("dcbDate", request.getParameter("dcbDate"));
				params.put("payMode", request.getParameter("payMode"));
				params.put("keyword", keyword);
				
				searchResult = giisCurrencyService.getDCBCurrencyLOV(pageNo, params);
				
				request.setAttribute("searchResult", searchResult);
				request.setAttribute("pageNo", searchResult.getPageIndex()+1);
				request.setAttribute("noOfPages", searchResult.getNoOfPages());
				
				PAGE = "/pages/accounting/dcb/pop-ups/searchDCBCurrencyLOVAjaxResult.jsp";
			} else if("showCurrencyShortNameList".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				List<GIISCurrency> currency = giisCurrencyService.getCurrencyLOVByShortName(request.getParameter("shortName"));
				JSONArray json = new JSONArray((List<GIISCurrency>) StringFormatter.replaceQuotesInList(currency));
				request.setAttribute("currencyList", json);
				request.setAttribute("block", request.getParameter("block"));
				PAGE = "/pages/accounting/dcb/pop-ups/currencyShortNameLOVOverlay.jsp";
			} else if ("getCurrencyListByShortName".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				List<GIISCurrency> currency = giisCurrencyService.getCurrencyLOVByShortName(request.getParameter("shortName"));
				JSONObject json = new JSONObject((List<GIISCurrency>) StringFormatter.replaceQuotesInList(currency));
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			} else if ("showCurrencyList".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				
				JSONObject json = giisCurrencyService.showCurrencyList(request, USER.getUserId());
				if(request.getParameter("refresh") == null) {
					JSONObject allMainCurrencyCd = giisCurrencyService.getAllMainCurrencyCd(request, USER.getUserId());
					JSONObject allShortName = giisCurrencyService.getAllShortName(request, USER.getUserId());
					JSONObject allCurrencyDesc = giisCurrencyService.getAllCurrencyDesc(request, USER.getUserId());
					request.setAttribute("jsonCurrencyMaintenance", json);
					request.setAttribute("jsonMainCurrencyCdList", allMainCurrencyCd);
					request.setAttribute("jsonShortNameList", allShortName);
					request.setAttribute("jsonCurrencyDescList", allCurrencyDesc);
					PAGE = "/pages/underwriting/fileMaintenance/general/currency/currency.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("valDeleteRec".equals(ACTION)){
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				
				giisCurrencyService.valDeleteRec(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("saveGiiss009".equals(ACTION)) {
				GIISCurrencyService giisCurrencyService = (GIISCurrencyService) APPLICATION_CONTEXT.getBean("giisCurrencyService");
				
				giisCurrencyService.saveGiiss009(request, USER.getUserId());
				message = "SUCCESS	";
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
