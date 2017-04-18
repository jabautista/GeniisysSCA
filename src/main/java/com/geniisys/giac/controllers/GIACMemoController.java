package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.entity.GIACMemo;
import com.geniisys.giac.service.GIACMemoService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

@WebServlet(name="GIACMemoController", urlPatterns="/GIACMemoController")
public class GIACMemoController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIACMemoController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			log.info("Initializing " + this.getClass().getSimpleName());
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIACMemoService giacMemoService = (GIACMemoService) APPLICATION_CONTEXT.getBean("giacMemoService");
			
			if ("getMemoList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("branchCd", request.getParameter("branchCd") == null ? "" : request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd") == null ? "" : request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIACS071" : request.getParameter("moduleId"));	
				params.put("gaccTranId", null/*request.getParameter("gaccTranId") == null ? null : request.getParameter("gaccTranId")*/);
				params.put("tranStatus", request.getParameter("tranStatus") == null ? "" : request.getParameter("tranStatus")); //Added by Jerome Bautista 12.14.2015 SR 3467
				params.put("userId", USER.getUserId());
				//System.out.println("PARAMS for memoListing: " + params);
				params = TableGridUtil.getTableGrid(request, params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					JSONObject json = new JSONObject(params);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("memoList", new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)));
					request.setAttribute("branchCd" , request.getParameter("branchCd") == null ? "" : request.getParameter("branchCd"));
					request.setAttribute("fundCd" , request.getParameter("funcdCd") == null ? "" : request.getParameter("fundCd"));
					request.setAttribute("cancelFlag",  request.getParameter("cancelFlag") == null ? "" : request.getParameter("cancelFlag"));
					PAGE = "/pages/accounting/generalLedger/memo/creditDebitMemoTable.jsp";
				}
			}else if("updateMemoInformation".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("branchCd", request.getParameter("branchCd") == null ? "" : request.getParameter("branchCd"));
				params.put("fundCd", request.getParameter("fundCd") == null ? "" : request.getParameter("fundCd"));
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIACS071" : request.getParameter("moduleId"));	
				params.put("userId", USER.getUserId());
				
				GIACMemo memoInfo = giacMemoService.getMemoInfo(params);
				
				request.setAttribute("memoInfo", new JSONObject(StringFormatter.escapeHTMLInObject(memoInfo)));
				request.setAttribute("cancelFlag",  request.getParameter("cancelFlag") == null ? "" : request.getParameter("cancelFlag"));
				PAGE = "/pages/accounting/generalLedger/memo/creditDebitMemo.jsp";
			}else if("showAddCreditDebitMemoPage".equals(ACTION)){
				GIACMemo defaultMemo = giacMemoService.getDefaultMemo();
				defaultMemo.setUserId(USER.getUserId());
				request.setAttribute("memoInfo", new JSONObject(defaultMemo));
				request.setAttribute("cancelFlag", request.getParameter("cancelFlag"));
				PAGE = "/pages/accounting/generalLedger/memo/creditDebitMemo.jsp";
			} else if("saveMemo".equals(ACTION)){
				GIACMemo memo = giacMemoService.saveMemo(request,USER);
				JSONObject json = new JSONObject(memo);
				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("updateMemoStatus".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("memoStatus", request.getParameter("memoStatus"));
				params.put("userId", USER.getUserId());
				
				giacMemoService.updateMemoStatus(params);
				
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("getClosedTag".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("memoDate", new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("memoDate")));
				
				message = giacMemoService.getClosedTag(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("cancelMemo".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gaccTranId", request.getParameter("gaccTranId") == null ? null : Integer.parseInt(request.getParameter("gaccTranId")));
				params.put("fundCd", request.getParameter("fundCd"));
				params.put("branchCd", request.getParameter("branchCd"));
				params.put("memoType", request.getParameter("memoType"));
				params.put("memoYear", request.getParameter("memoYear") == null ? null : Integer.parseInt(request.getParameter("memoYear")));
				params.put("memoSeqNo", request.getParameter("memoSeqNo") == null ? null : Integer.parseInt(request.getParameter("memoSeqNo")));
				params.put("memoDate", request.getParameter("memoDate") == null ? null : new SimpleDateFormat("MM-dd-yyyy").parse(request.getParameter("memoDate")));
				params.put("userId", USER.getUserId());
				params.put("tranFlag", request.getParameter("tranFlag"));
				params.put("message", "");
				
				message = giacMemoService.cancelMemo(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("validateCurrSname".equals(ACTION)){
				message = giacMemoService.validateCurrSname(request.getParameter("shortname"));
				PAGE = "/pages/genericMessage.jsp";
			} else if ("showGIACS072".equals(ACTION)) {
				/* Pol Cruz
				 * 06.13.2013
				 * GIACS072 - Credit/Debit Memos Report
				 * */
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);				
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalLedger/report/creditDebitMemoReport.jsp";
			}
			
		} catch(SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch(NullPointerException e) {
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
