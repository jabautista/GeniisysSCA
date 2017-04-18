package com.geniisys.giac.controllers;

import java.io.IOException;
import java.math.BigDecimal;
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

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACAcctEntriesDAO;
import com.geniisys.giac.entity.GIACAcctEntries;
import com.geniisys.giac.entity.GIACChartOfAccts;
import com.geniisys.giac.service.GIACAccTransService;
import com.geniisys.giac.service.GIACAcctEntriesService;
import com.geniisys.giac.service.GIACParameterFacadeService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIACAcctEntriesController extends BaseController{

	private static final long serialVersionUID = -498136169161580220L;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIACAcctEntriesController.class);

	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			//final String moduleNameParameter = "GIACS030";
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACAcctEntriesService acctEntriesService = APPLICATION_CONTEXT.getBean(GIACAcctEntriesService.class);
//			LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
			log.info("action: " + ACTION);
			if("showAcctEntries".equals(ACTION)) {
				Integer gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals("")) ? "0" : request.getParameter("gaccTranId"));
				GIACAccTransService accTransServ = APPLICATION_CONTEXT.getBean(GIACAccTransService.class);
				GIACParameterFacadeService giacp = APPLICATION_CONTEXT.getBean(GIACParameterFacadeService.class);
				//GIACChartOfAcctsService chartService = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacCharOfAccts");
				System.out.println("Show Acctg. Entries - "+gaccTranId);
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				List<GIACAcctEntries> acctEntries = acctEntriesService.getAcctEntries(param);
				request.setAttribute("acctEntries", new JSONArray((List<GIACAcctEntries>) StringFormatter.escapeHTMLInList(acctEntries)));
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("userId", USER.getUserId());
				params = acctEntriesService.checkManualAcctEntry(params);
				request.setAttribute("checkManualEntry", new JSONObject(params));
				
				request.setAttribute("sapSw", giacp.getParamValueV2("SAP_INTEGRATION_SW"));
				//request.setAttribute("uploadSw", giacp.getParamValueV2("UPLOAD_IMPLEMENTATION_SW"));
				/*List<GIACChartOfAccts> glAccts = chartService.getAllChartOfAccts();
				StringFormatter.replaceQuotesInList(glAccts);
				request.setAttribute("allAccts", new JSONArray(StringFormatter.replaceQuotesInList(glAccts)));*/
				
				/*List<LOV> slList = lovHelper.getList(lovHelper.ACCT_ENTRIES_SL_LISTING, null);
				StringFormatter.replaceQuotesInList(slList);
				request.setAttribute("slList", new JSONArray(slList));*/
				
				if("Y".equals(request.getParameter("dcbFlag"))) {
					request.setAttribute("gacc", accTransServ.getGiacAcctransDtl(gaccTranId));
					PAGE = "/pages/accounting/dcb/dcbAcctEntries/dcbAcctEntries.jsp";
				} else {
					request.setAttribute("tranFlag", accTransServ.getTranFlag(gaccTranId));
					PAGE = "/pages/accounting/officialReceipt/acctEntries/accountingEntries.jsp";
				}
			}else if("showAcctEntriesTableGrid".equals(ACTION)) {//added by c.santos - 06.06.2012
				Integer gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals("")) ? "0" : request.getParameter("gaccTranId"));
				GIACAccTransService accTransServ = APPLICATION_CONTEXT.getBean(GIACAccTransService.class);
				GIACParameterFacadeService giacp = APPLICATION_CONTEXT.getBean(GIACParameterFacadeService.class);
				//GIACChartOfAcctsService chartService = (GIACChartOfAcctsService) APPLICATION_CONTEXT.getBean("giacCharOfAccts");
				BigDecimal totalDebitAmt = new BigDecimal(0);
				BigDecimal totalCreditAmt = new BigDecimal(0);
				
				Map<String, Object> param = new HashMap<String, Object>();
				param.put("gaccTranId", request.getParameter("gaccTranId") == "" ? null : Integer.parseInt(request.getParameter("gaccTranId")));
				List<GIACAcctEntries> acctEntries = acctEntriesService.getAcctEntries(param);
				request.setAttribute("acctEntries", new JSONArray((List<GIACAcctEntries>) StringFormatter.escapeHTMLInList(acctEntries)));
				
				//-----
				Map<String, Object> tableParams = new HashMap<String, Object>();
				tableParams.put("ACTION", "getGiacAcctEntries");
				tableParams.put("gaccTranId", request.getParameter("gaccTranId") == "" ? null :Integer.parseInt(request.getParameter("gaccTranId")));
				Map<String, Object> acctEntriesTableGrid = TableGridUtil.getTableGrid(request, tableParams);
				//StringFormatter.replaceQuotesInMap(acctEntriesTableGrid);
				JSONObject json = new JSONObject(acctEntriesTableGrid);
				request.setAttribute("acctEntriesJSON", json);
				System.out.println("acctEntriesJSON: " + json);
				
				JSONArray rows = json.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					totalDebitAmt = new BigDecimal(rows.getJSONObject(i).getString("totalDebitAmt"));
					totalCreditAmt = new BigDecimal(rows.getJSONObject(i).getString("totalCreditAmt"));
				}
				request.setAttribute("totalDebitAmt", totalDebitAmt);
				request.setAttribute("totalCreditAmt", totalCreditAmt);
				//-----
				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("userId", USER.getUserId());
				params = acctEntriesService.checkManualAcctEntry(params);
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("checkManualEntry", new JSONObject(params));
				request.setAttribute("sapSw", giacp.getParamValueV2("SAP_INTEGRATION_SW"));				
				request.setAttribute("gacc", accTransServ.getGiacAcctransDtl(gaccTranId));
				//System.out.println("gacc " + (accTransServ.getGiacAcctransDtl(gaccTranId).toString()));
				
				if("Y".equals(request.getParameter("dcbFlag"))) {
					PAGE = "/pages/accounting/dcb/dcbAcctEntries/dcbAcctEntries.jsp";
				}else if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else {
					request.setAttribute("tranFlag", accTransServ.getTranFlag(gaccTranId));
					PAGE = "/pages/accounting/officialReceipt/acctEntries/accountingEntries.jsp";
				}
			} else if("showChartOfAccts".equals(ACTION)) {
				int act = Integer.parseInt(request.getParameter("act"));
				int pageNo = Integer.parseInt(request.getParameter("pageNo"));
				System.out.println("PageNo: "+pageNo);
				PaginatedList chartOfAccts = null;
				if(act==0) {
					PAGE = "/pages/accounting/officialReceipt/acctEntries/pop-ups/chartOfAcctListing.jsp";
					System.out.println("entering chart of accts " + act + " - keyword: " + request.getParameter("keyword"));
					chartOfAccts = acctEntriesService.getGlAcctListing(request.getParameter("acctIdObj"), 1, request.getParameter("keyword"));
					chartOfAccts.gotoPage(pageNo-1);
				} else {
					PAGE = "/pages/accounting/officialReceipt/acctEntries/pop-ups/chartOfAcctListingTable.jsp";
					System.out.println("controller - filtering list " + act + " - keyword: " + request.getParameter("keyword"));
					chartOfAccts = acctEntriesService.getGlAcctListing(request.getParameter("acctIdObj"), pageNo, request.getParameter("keyword"));	
				}
				StringFormatter.replaceQuotesInList(chartOfAccts);
				request.setAttribute("glAcctList", new JSONArray(chartOfAccts));
				request.setAttribute("pageNo", pageNo);
				request.setAttribute("noOfPages", chartOfAccts.getNoOfPages());
			} else if("saveAcctEntries".equals(ACTION)) {
				int gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals("")) ? "0" : request.getParameter("gaccTranId"));
				String param = request.getParameter("parameters");
				
				System.out.println("--------------------------------------------------------");
				System.out.println("saveAcctEntries " + param);
				
				acctEntriesService.saveGIACAcctEntries(param, gaccTranId, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("viewGlBalance".equals(ACTION)) {
				/*Map<String, Object> tableParams = new HashMap<String, Object>();
				tableParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				
				List<GIACAcctEntries> acctEntries = acctEntriesService.getAcctEntries(tableParams);
				StringFormatter.replaceQuotesInList(acctEntries);
				request.setAttribute("glBalance", new JSONArray(acctEntries));*/
				//-----
				BigDecimal totalDebitAmt = new BigDecimal(0);
				BigDecimal totalCreditAmt = new BigDecimal(0);
				
				Map<String, Object> tableParams = new HashMap<String, Object>();
				tableParams.put("ACTION", "getGiacAcctEntries");
				tableParams.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				
				Map<String, Object> acctEntriesTableGrid = TableGridUtil.getTableGrid(request, tableParams);
				//StringFormatter.replaceQuotesInMap(acctEntriesTableGrid);
				JSONObject json = new JSONObject(acctEntriesTableGrid);
				
				request.setAttribute("acctEntriesJSON", json);
				System.out.println("js: " + json);
				
				JSONArray rows = json.getJSONArray("rows");
				for (int i = 0; i < rows.length(); i++) {
					totalDebitAmt = new BigDecimal(rows.getJSONObject(i).getString("totalDebitAmt"));
					totalCreditAmt = new BigDecimal(rows.getJSONObject(i).getString("totalCreditAmt"));
				}
				request.setAttribute("totalDebitAmt", totalDebitAmt);
				request.setAttribute("totalCreditAmt", totalCreditAmt);
				//-----
				PAGE = "/pages/accounting/officialReceipt/acctEntries/pop-ups/viewGlBalance.jsp";
			} else if("closeTrans".equals(ACTION)) {
				Integer gaccTranId = Integer.parseInt( (request.getParameter("gaccTranId").equals("")) ? "0" : request.getParameter("gaccTranId"));
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", gaccTranId);
				params.put("appUser", USER.getUserId());
				params.put("mesg", "");
				params.put("workmsg", "");
				params = acctEntriesService.closeTransaction(params);
				log.info("Close Trans Params - "+params);
				message = (String) params.get("mesg");
				PAGE = "/pages/genericMessage.jsp";
			} else if("retrieveGlAcct".equals(ACTION)) {
				String strParams = request.getParameter("glAcctObj");
				System.out.println("Retrieving chart of accounts - "+strParams);
				
				GIACChartOfAccts chartAccts = acctEntriesService.retrieveGLAccount(strParams);
				StringFormatter.replaceQuotesInObject(chartAccts);

				JSONObject acctEntriesObject = new JSONObject(chartAccts == null ? "" : chartAccts);
				request.setAttribute("object", acctEntriesObject == null ? "[]" : acctEntriesObject);
				System.out.println("object " + acctEntriesObject);
				//System.out.println(new JSONObject(chartAccts == null ? "" : chartAccts).toString());
				//message = new JSONObject(chartAccts == null ? "" : chartAccts).toString();
				PAGE = "/pages/genericObject.jsp";
				//PAGE = "/pages/genericMessage.jsp";
			} else if ("checkGIACS060GLTrans".equals(ACTION)) {
				request.setAttribute("object", acctEntriesService.checkGIACS060GLTrans(request));
				PAGE = "/pages/genericObject.jsp";
			}
			
			
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
