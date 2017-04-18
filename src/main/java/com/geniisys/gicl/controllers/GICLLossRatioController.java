package com.geniisys.gicl.controllers;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.service.GICLLossRatioService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet (name="GICLLossRatioController", urlPatterns={"/GICLLossRatioController"})
public class GICLLossRatioController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLLossRatioService giclLossRatioService = (GICLLossRatioService) APPLICATION_CONTEXT.getBean("giclLossRatioService");
		
		try{
			if("showGICLS204".equals(ACTION)){
				PAGE = "/pages/claims/reports/lossRatio/lossRatio.jsp";
			}else if("validateAssdNoGicls204".equals(ACTION)){
				message = giclLossRatioService.validateAssdNoGicls204(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("validatePerilCdGicls204".equals(ACTION)){
				message = giclLossRatioService.validatePerilCdGicls204(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("extractGicls204".equals(ACTION)){
				message = giclLossRatioService.extractGicls204(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("getDetailReportDate".equals(ACTION)){
				message = giclLossRatioService.getDetailReportDate(request);
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGICLS205".equals(ACTION)){
				PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/lossRatioDetails.jsp";
			}else if("showLossRatioSummary".equals(ACTION)){
				JSONObject jsonLossRatioSummary = giclLossRatioService.showLossRatioSummary(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossRatioSummary.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLossRatioSummary", jsonLossRatioSummary);
					PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/lossRatioSummary.jsp";
				}
			}else if("showPremiumsWrittenCurr".equals(ACTION)){
				JSONObject jsonPremiumsWrittenCurr = giclLossRatioService.showPremiumsWrittenCurr(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPremiumsWrittenCurr.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPremiumsWrittenCurr", jsonPremiumsWrittenCurr);
					PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/premiumsWrittenCurr.jsp";
				}
			}else if("showPremiumsWrittenPrev".equals(ACTION)){
				JSONObject jsonPremiumsWrittenPrev = giclLossRatioService.showPremiumsWrittenPrev(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonPremiumsWrittenPrev.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonPremiumsWrittenPrev", jsonPremiumsWrittenPrev);
					PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/premiumsWrittenPrev.jsp";
				}
			}else if("showOutLoss".equals(ACTION)){
				JSONObject jsonOutLoss = giclLossRatioService.showOutLoss(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonOutLoss.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonOutLoss", jsonOutLoss);
					if(request.getParameter("year").equals("curr")){
						PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/outstandingLossCurr.jsp";
					}else{
						PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/outstandingLossPrev.jsp";
					}
				}
			}else if("showLossPaid".equals(ACTION)){
				JSONObject jsonLossPaid = giclLossRatioService.showLossPaid(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossPaid.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLossPaid", jsonLossPaid);
					PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/lossPaid.jsp";
				}
			}else if("showLossRec".equals(ACTION)){
				JSONObject jsonLossRec = giclLossRatioService.showLossRec(request);
				if("1".equals(request.getParameter("refresh"))){
					message = jsonLossRec.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonLossRec", jsonLossRec);
					if(request.getParameter("year").equals("curr")){
						PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/lossRecoveryCurr.jsp";
					}else{
						PAGE = "/pages/claims/reports/lossRatio/lossRatioDetails/subPages/lossRecoveryPrev.jsp";
					}
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
