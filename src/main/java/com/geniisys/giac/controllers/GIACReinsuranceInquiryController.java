package com.geniisys.giac.controllers;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.giac.service.GIACReinsuranceInquiryService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name = "GIACReinsuranceInquiryController", urlPatterns = "/GIACReinsuranceInquiryController")
public class GIACReinsuranceInquiryController extends BaseController {


	private static final long serialVersionUID = -6887562067933991646L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
		
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIACReinsuranceInquiryService giacReinsuranceInquiryService = (GIACReinsuranceInquiryService) APPLICATION_CONTEXT.getBean("giacReinsuranceInquiryService");
			
			GIISParameterFacadeService giisParameterFacadeService = (GIISParameterFacadeService)APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
			if ("showRiBillPayment".equals(ACTION)) {
				if("1".equals(request.getParameter("refresh"))){
					JSONObject jsonGiacInwfaculPremCollnsTg = giacReinsuranceInquiryService.showRiBillPayment(request,USER);
					request.setAttribute("jsonGiacInwfaculPremCollnsTg", jsonGiacInwfaculPremCollnsTg);
					PAGE = "/pages/accounting/reinsurance/inquiry/riBillPayments/riBillPayments.jsp";
				}else{
					PAGE = "/pages/accounting/reinsurance/inquiry/riBillPayments/riBillPayments.jsp";
				}
				String issCd = giisParameterFacadeService.getParamValueV2("ISS_CD_RI");
				request.setAttribute("issCdRi", issCd);
			}else if ("getGIACS270GipiInvoice".equals(ACTION)){
				JSONObject jsonGipiInvoiceRi = giacReinsuranceInquiryService.getGIACS270GipiInvoice(request, USER);
				message = jsonGipiInvoiceRi.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if ("getGIACS270GiacInwfaculPremCollns".equals(ACTION)) {
				JSONObject jsonGiacInwfaculPremCollnsTg = giacReinsuranceInquiryService.getGIACS270GiacInwfaculPremCollns(request, USER);
				message = jsonGiacInwfaculPremCollnsTg.toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showCurrencyInfoOverlay".equals(ACTION)){
				PAGE = "/pages/accounting/reinsurance/inquiry/riBillPayments/overlay/foreignAmtOverlay.jsp";
			}else if ("viewRiLossRecoveries".equals(ACTION)) {
				JSONObject json = giacReinsuranceInquiryService.viewRiLossRecoveries(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/accounting/reinsurance/inquiry/lossesRecoverable/lossesRecoverable.jsp";					
				}
			}else if("showRiLossOverlay".equals(ACTION)){
				JSONObject jsonRiOverlay = giacReinsuranceInquiryService.viewRiLossRecoveriesOverlay(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonRiOverlay.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonRiOverlay", jsonRiOverlay);
					PAGE = "/pages/accounting/reinsurance/inquiry/lossesRecoverable/pop-ups/riLossOverlay.jsp";
				}
			} 
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
