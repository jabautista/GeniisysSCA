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

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.giac.service.GIACGeneralDisbReportService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACGenearalDisbReportController", urlPatterns="/GIACGenearalDisbReportController")
public class GIACGenearalDisbReportController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 5546708819854086055L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		
		try {
			GIACGeneralDisbReportService giacGeneralDisbReportService = (GIACGeneralDisbReportService) APPLICATION_CONTEXT.getBean("giacGeneralDisbReportService");
			GIACBranchService giacBranchService = (GIACBranchService) APPLICATION_CONTEXT.getBean("giacBranchService");
			
			if("showPaytReqList".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/paytReqList/paymentRequestList.jsp";
				
			// GIACS273
			}else if("showDisbursementListPage".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("fundCd",	giacGeneralDisbReportService.getGIACS273InitialFundCd());
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/disbursementList/disbursementList.jsp";
			}else if("validateGIACS273BranchCd".equals(ACTION)){
				message = giacBranchService.validateGIACS273BranchCd(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateGIACS273DocCd".equals(ACTION)){
				message = giacGeneralDisbReportService.validateGIACS273DocCd(request);
				PAGE = "/pages/genericMessage.jsp";
				
			//GIACS149
			}else if("showGIACS149Page".equals(ACTION)){				
				JSONObject json = giacGeneralDisbReportService.showOvrideCommVoucher(request, USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					//giacGeneralDisbReportService.giacs149WhenNewFormInstance(request.getParameter("vUpdate"));
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					String vUpdate = request.getParameter("intmNo").equals(null) || request.getParameter("intmNo").equals("") ? "Y" : "N";
					request.setAttribute("fundCd", giacGeneralDisbReportService.giacs149WhenNewFormInstance(vUpdate));
					PAGE = "/pages/accounting/generalDisbursements/reports/overridingCommissionVoucher/overridingCommissionVoucher.jsp";
				}
			}else if ("countTaggedVouchers".equals(ACTION)){
				message = giacGeneralDisbReportService.countTaggedVouchers(request.getParameter("intmNo")).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("computeGIACS149Totals".equals(ACTION)){
				JSONObject res = giacGeneralDisbReportService.computeGIACS149Totals(request, USER.getUserId());
				System.out.println(res.toString());
				
				request.setAttribute("object", res);
				PAGE = "/pages/genericObject.jsp";
			/*}else if("updateGIACS149DtlAmount".equals(ACTION)){
				message = giacGeneralDisbReportService.updateCommVoucherAmount(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp"; */
			}else if("updateGIACS149PrintTag".equals(ACTION)){
				message = giacGeneralDisbReportService.updateCommVoucherPrintTag(request, USER.getUserId()).toString();
				System.out.println("============== \n "+message);
				PAGE = "/pages/genericMessage.jsp";
			}else if("getCvPrefGIACS149".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("gfunFundCd", request.getParameter("gfunFundCd"));
				params.put("userId", USER.getUserId());
				JSONObject json = new JSONObject(giacGeneralDisbReportService.getCvPrefGIACS149(params));
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("checkCvSeqGIACS149".equals(ACTION)){
				JSONObject json = giacGeneralDisbReportService.checkCvSeqGIACS149(request, USER.getUserId());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("updateVatGIACS149".equals(ACTION)){
				message = giacGeneralDisbReportService.updateVatGIACS149(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showPrintCommDialog".equals(ACTION)){
				PrintService[] printers = PrintServiceLookup.lookupPrintServices(null, null);
				request.setAttribute("printers", printers);
				PAGE = "/pages/accounting/generalDisbursements/reports/overridingCommissionVoucher/printCommDialog.jsp";
			}else if("populateCvSeqGIACS149".equals(ACTION)){
				JSONObject json = giacGeneralDisbReportService.populateCvSeqGIACS149(request, USER.getUserId());
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("getGpcvGIACS149".equals(ACTION)){
				JSONArray json = giacGeneralDisbReportService.getGpcvGIACS149(Integer.parseInt(request.getParameter("intmNo")));
				
				if("Y".equals(request.getParameter("printOCV"))){
					giacGeneralDisbReportService.updateGpcvGIACS149(json, request, USER.getUserId());					
				}
				request.setAttribute("object", json);
				PAGE = "/pages/genericObject.jsp";
			}else if("delWorkflowRecGIACS149".equals(ACTION)){
				giacGeneralDisbReportService.delWorkflowRec(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("gpcvRestore".equals(ACTION)){
				giacGeneralDisbReportService.gpcvRestore(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateUnprintedVoucher".equals(ACTION)){
				message = giacGeneralDisbReportService.updateUnprintedVoucher(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("updateDocSeqGIACS149".equals(ACTION)){
				message = giacGeneralDisbReportService.updateDocSeqGIACS149(request, USER.getUserId());
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
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
