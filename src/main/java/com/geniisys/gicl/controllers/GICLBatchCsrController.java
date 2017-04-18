package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.servlet.ServletException;
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
import com.geniisys.gicl.entity.GICLBatchCsr;
import com.geniisys.gicl.service.GICLBatchCsrService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GICLBatchCsrController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GICLBatchCsrController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
			
		log.info("Initializing: "+this.getClass().getSimpleName());
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLBatchCsrService giclBatchCsrServ = (GICLBatchCsrService) APPLICATION_CONTEXT.getBean("giclBatchCsrService");
		
		try{
			if("showBatchCsrPage".equals(ACTION)){
				String insertTag = request.getParameter("insertTag");
				GICLBatchCsr batchCsr = new GICLBatchCsr();
				
				if(insertTag.equals("1")){
					Integer batchCsrId = Integer.parseInt(request.getParameter("batchCsrId") == null ? "0" : request.getParameter("batchCsrId"));
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("batchCsrId", batchCsrId);
					params.put("moduleId", "GICLS043");
					params.put("appUser", USER.getUserId());
					batchCsr = giclBatchCsrServ.getGICLBatchCsr(params);
					request.setAttribute("giclBatchCsrJSON", new JSONObject(StringFormatter.escapeHTMLInObject(batchCsr)));//marco - 3.26.2014 - escapeHTMLInObject
				}
				
				request.setAttribute("insertTag", insertTag);
				PAGE = "/pages/claims/batchCsr/batchCsrMain.jsp";
			}else if("getGiclBatchCsrTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("moduleId", request.getParameter("moduleId") == null ? "GICLS043" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> batchCsrTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonBatchCsr = new JSONObject(batchCsrTableGrid);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonBatchCsr", jsonBatchCsr);
					PAGE = "/pages/claims/batchCsr/batchCsrListing.jsp";
				}else{
					message = jsonBatchCsr.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("generateBatchNo".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameters"));
				Integer newBatchCsrId = giclBatchCsrServ.generateBatchNumber(objParams, USER);
				message = newBatchCsrId.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showForeignCurrAmts".equals(ACTION)){
				PAGE = "/pages/claims/batchCsr/foreignCurrency.jsp";
			}else if("cancelBatchCsr".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("batchCsrId", request.getParameter("batchCsrId"));
				params.put("moduleId", request.getParameter("moduleId"));
				params.put("userId", USER.getUserId());
				giclBatchCsrServ.cancelBatchCsr(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGiclAcctEntriesTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				Integer adviceId = Integer.parseInt(request.getParameter("adviceId") == null ? "0" : request.getParameter("adviceId"));
				Integer claimId = Integer.parseInt(request.getParameter("claimId") == null ? "0" : request.getParameter("claimId"));
				params.put("ACTION", ACTION);
				params.put("adviceId", adviceId);
				params.put("claimId", claimId);
				params.put("pageSize", 5);
				Map<String, Object> acctEntriesTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonAcctEntries = new JSONObject(acctEntriesTableGrid);
				if("1".equals(request.getParameter("ajax"))){
					Map<String, Object> parameters = new HashMap<String, Object>();
					parameters.put("adviceId", adviceId);
					parameters.put("claimId", claimId);
					parameters.put("refId", request.getParameter("refId")== null || request.getParameter("refId").equals("")? null : Integer.parseInt(request.getParameter("refId")));
					parameters = giclBatchCsrServ.gicls043C024PostQuery(parameters);
					request.setAttribute("claimNo", parameters.get("claimNo"));
					request.setAttribute("adviceNo", parameters.get("adviceNo"));
					request.setAttribute("requestNo", parameters.get("requestNo"));
					request.setAttribute("totalDebitAmt", parameters.get("totalDebitAmt"));
					request.setAttribute("totalCreditAmt", parameters.get("totalCreditAmt"));
					request.setAttribute("jsonAcctEntries", jsonAcctEntries);
					PAGE = "/pages/claims/batchCsr/acctEntriesListing.jsp";
				}else{
					message = jsonAcctEntries.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("saveBatchCsr".equals(ACTION)){
				JSONObject objParams = new JSONObject(request.getParameter("parameters"));
				giclBatchCsrServ.saveBatchCsr(objParams, USER);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("showBatchCSRApprovalOverlay".equals(ACTION)){
				PAGE = "/pages/claims/batchCsr/batchCsrApprovalOverlay.jsp";
			}else if("showPrintCsrDialog".equals(ACTION)){
				//LOVHelper helper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				//List<LOV> printerList = helper.getList(LOVHelper.PRINTER_LISTING);
				//PrintService[] printers = printServiceLookup.lookupPrintServices(null, null);
				//String printerNames = "";
				
				//replaced by marco - 02.06.2013
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				
				/*for (int i = 0; i < printers.length; i++){
					printerNames = printerNames + printers[i].getName();
					if (i != (printers.length-1)){
						printerNames = printerNames + ",";
					}
				}*/
				
				String batchCsrId = request.getParameter("batchCsrId");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("batchCsrId", batchCsrId);
				params.put("issCd", request.getParameter("issCd"));
				String reportId = giclBatchCsrServ.getBatchCsrReportId(params);
				request.setAttribute("batchCsrId", batchCsrId);
				//request.setAttribute("printerNames", printerNames);	
				//request.setAttribute("printers", printerList);
				request.setAttribute("reportId", reportId);
				PAGE = "/pages/claims/batchCsr/printCsrDialog.jsp";
			}
		}catch(SQLException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
	
}
