package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

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
import com.geniisys.gipi.service.GIPIInstallmentService;
import com.geniisys.gipi.service.GIPIInvoiceService;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class GIPIInvoiceController extends BaseController{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(GIPIInvoiceController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		try{
			
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			message = "SUCCESS";
			PAGE = "/pages/genericMessage.jsp";
			
			GIPIInvoiceService gipiInvoiceService = (GIPIInvoiceService) APPLICATION_CONTEXT.getBean("gipiInvoiceService");
			
			if("showPremiumColl".equals(ACTION)){
				
				HashMap<String, Object> params = new HashMap<String, Object>();
				String pageCalling = request.getParameter("pageCalling");
				params.put("currentPage", request.getParameter("page") == null ? 1 : Integer.parseInt(request.getParameter("page")));
				params.put("policyId", Integer.parseInt(request.getParameter("policyId")));
				params = gipiInvoiceService.getPolicyInvoice(params);
				
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")) {
					
					JSONObject json = new JSONObject(params);
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					if ("policyLeadOverlay".equals(pageCalling)){
						request.setAttribute("leadInvoiceList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/overlay/policyLeadInvoiceOverlay.jsp"; 
							
					}else{
						request.setAttribute("invoiceList", new JSONObject((HashMap<String, Object>)StringFormatter.replaceQuotesInMap(params)));
						PAGE = "/pages/underwriting/policyInquiries/policyInformation/subPages/policyPremColl.jsp";
						
					}
				}
			}else if ("getMultiBookingDateByPolicy".equals(ACTION)) {
				Integer policyId = new Integer((request.getParameter("policyId") == null) ? "0" : (request.getParameter("policyId").toString().isEmpty() ? "0" : request.getParameter("policyId").toString()));
				Integer distNo = new Integer((request.getParameter("distNo") == null) ? "0" : (request.getParameter("distNo").toString().isEmpty() ? "0" : request.getParameter("distNo").toString()));
				message = gipiInvoiceService.getMultiBookingDateByPolicy(policyId, distNo);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showViewInvoiceInformation".equals(ACTION)){
				JSONObject json = gipiInvoiceService.showInvoiceInformation(request, USER.getUserId());
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("invoiceList", json);
					PAGE = "/pages/underwriting/policyInquiries/invoiceInformation/viewInvoiceInformation.jsp";
				}				
			} else if("getInvoicePaytermsInfo".equals(ACTION)){
				GIPIInstallmentService gipiInstallmentService = (GIPIInstallmentService) APPLICATION_CONTEXT.getBean("gipiInstallmentService");
				JSONObject json = gipiInstallmentService.getInvoicePaytermsInfo(request);
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("invoicePaytermDetails", json);
					PAGE = "/pages/underwriting/policyInquiries/invoiceInformation/overlay/invoicePaymentTerms.jsp";
				}
			} else if("getInvoiceTaxDetails".equals(ACTION)){
				JSONObject json = gipiInvoiceService.getInvoiceTaxDetails(request, USER.getUserId());
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("invoiceList", json);
					PAGE = "/pages/underwriting/policyInquiries/invoiceInformation/overlay/invoiceTaxAmounts.jsp";
				}		
			}
			
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
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
