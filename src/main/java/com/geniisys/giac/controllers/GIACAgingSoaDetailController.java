package com.geniisys.giac.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

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
import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.framework.util.QueryParamGenerator;
import com.geniisys.giac.service.GIACAgingSoaDetailService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GIACAgingSoaDetailController", urlPatterns={"/GIACAgingSoaDetailController"})
public class GIACAgingSoaDetailController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8131647525341377935L;
	private Logger log = Logger.getLogger(GIACAgingSoaDetailController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		try {
			if("getBillInfo".equals(ACTION)){
				GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) appContext.getBean("giacAgingSoaDetailService");
				JSONObject obj = agingSoaService.getBillInfo(request);
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getInstInfo".equals(ACTION)){
				GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) appContext.getBean("giacAgingSoaDetailService");
				JSONObject obj = agingSoaService.getInstInfo(request);
				message = obj.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getPolicyDtlsGIACS007".equals(ACTION)) {
				GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) appContext.getBean("giacAgingSoaDetailService");
				Map<String, Object> params = FormInputUtil.getFormInputs(request);
				params = agingSoaService.getPolicyDtlsGIACS007(params);
				message = QueryParamGenerator.generateQueryParams(params);
				log.info(message);
				PAGE = "/pages/genericMessage.jsp";
			} else if("getInvoiceSoaDetails".equals(ACTION)){
				GIACAgingSoaDetailService agingSoaService = (GIACAgingSoaDetailService) appContext.getBean("giacAgingSoaDetailService");
				JSONObject json = agingSoaService.getInvoiceSoaDetails(request);
				request.setAttribute("invoiceSoaDetails", json);
				PAGE = "/pages/underwriting/policyInquiries/invoiceInformation/overlay/invoiceStatementOfAccount.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
		
	}

}
