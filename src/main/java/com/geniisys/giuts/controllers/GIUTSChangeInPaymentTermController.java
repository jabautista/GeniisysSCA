package com.geniisys.giuts.controllers;

import java.io.IOException;
import java.sql.SQLException;

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
import com.geniisys.giuts.service.GIUTSChangeInPaymentTermService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name = "GIUTSChangeInPaymentTermController", urlPatterns = "/GIUTSChangeInPaymentTermController")
public class GIUTSChangeInPaymentTermController extends BaseController {

	/**
	 * 
	 */
	private Logger log = Logger.getLogger(GIUTSChangeInPaymentTermController.class);
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIUTSChangeInPaymentTermService changePayTermService = (GIUTSChangeInPaymentTermService) appContext.getBean("giutsChangeInPaymentTermService");
		try {
			if ("showChangeInPaymentTerm".equals(ACTION)) {
				if ("1".equals(request.getParameter("refresh"))) {
					/*Integer policyId = Integer.parseInt(request.getParameter("policyId"));		//kenneth L. 06.14.2013 changed to table grid
					GIUTSChangeInPaymentTerm changePayTerm = changePayTermService.getGIUTS022InvoiceInfo(policyId);
					StringFormatter.escapeHTMLInObject(changePayTerm);
					JSONObject gipiJSON = new JSONObject(changePayTerm);
					message = gipiJSON.toString();
					PAGE = "/pages/genericMessage.jsp";*/
					JSONObject invoiceJSON = changePayTermService.getGIUTS022InvoiceInfo(request);
					request.setAttribute("jsonInvoice", invoiceJSON);
					System.out.println(invoiceJSON.toString());
					message = invoiceJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
					
				} else {
					PAGE = "/pages/accounting/cashReceipts/utilities/changeInPaymentTerm/changeInPaymentTerm.jsp";
				}
			}else if("getInstallmentDetails".equals(ACTION)){
				JSONObject installmentJSON = changePayTermService.showInstallmentDetails(request, USER);
				if ("1".equals(request.getParameter("refresh"))) {
					request.setAttribute("jsonInstallment", installmentJSON);
					System.out.println(installmentJSON.toString());
					message = installmentJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/cashReceipts/utilities/changeInPaymentTerm/subPages/invoiceInformation.jsp";
				}
			}else if("updatePaymentTerm".equals(ACTION)){
				message = new JSONObject(changePayTermService.updatePaymentTerm(request, USER)).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if(ACTION.equals("updateDueDate")){ 
				message = changePayTermService.updateDueDate(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getTaxAllocation".equals(ACTION)){
				JSONObject taxAllocationJSON = changePayTermService.showTaxAllocation(request, USER);
				if ("1".equals(request.getParameter("refresh"))) {
					request.setAttribute("jsonTaxAllocation", taxAllocationJSON);
					System.out.println(taxAllocationJSON.toString());
					message = taxAllocationJSON.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/cashReceipts/utilities/changeInPaymentTerm/subPages/taxAllocation.jsp";
				}
			}else if(ACTION.equals("validateFullyPaid")){ 
				message = changePayTermService.validateFullyPaid(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("getDates")){ 
				message = changePayTermService.validateInceptExpiry(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("updateInvoiceDueDate")){ 
				message = changePayTermService.updateDueDateInvoice(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("checkIfCanChange")){
				message = changePayTermService.checkIfCanChange(request);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("updateWorkflowSwitch")){
				message = changePayTermService.updateWorkflowSwitch(request, USER);
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("updateTaxAllocation")){
				message = new JSONObject(changePayTermService.updateTaxAllocation(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if(ACTION.equals("updateAllocation")){
				message = new JSONObject(changePayTermService.updateAllocation(request, USER.getUserId())).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGIUTS022PolicyLOV".equals(ACTION)){
				JSONObject checkPolicyJSON = changePayTermService.checkIfPolicyExists(request, USER);
				message = checkPolicyJSON.toString();
				PAGE = "/pages/genericMessage.jsp";
			}  else if("getDueDate".equals(ACTION)){ //carlo SR 5928 02-14-2017
				request.setAttribute("object", new JSONObject(changePayTermService.getDueDate(request)));
				PAGE = "/pages/genericObject.jsp";
			}
		}catch(SQLException e){
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
