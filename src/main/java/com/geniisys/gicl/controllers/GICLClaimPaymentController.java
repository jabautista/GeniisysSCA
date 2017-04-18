package com.geniisys.gicl.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.service.GICLClaimPaymentService;
import com.seer.framework.util.ApplicationContextReader;

@WebServlet(name = "GICLClaimPaymentController", urlPatterns = { "/GICLClaimPaymentController" })
public class GICLClaimPaymentController extends BaseController {

	/**
	 * Created By : Aliza Garza Date Created: 06/04/2013 Reference By: (
	 * GICLS261 - Claim Payment Inquiry Screen GICLS260 - Claim Information
	 * Screen (button) - not yer impl as of date created ) Description: Module
	 * Controller will handle dispatch and exceptions
	 */

	private static final long serialVersionUID = -622810858599008481L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {

		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GICLClaimPaymentService giclClaimPaymentService = (GICLClaimPaymentService) APPLICATION_CONTEXT.getBean("giclClaimPaymentService");
		String action = request.getParameter("action");
		try {
			if ("showClaimPayment".equals(action)) {
				Map<String, Object> params = new HashMap<String, Object>();
				request.setAttribute("action", action);
				request.setAttribute("moduleId", "GICLS261");
				request.setAttribute("userId", USER.getUserId());
				request.setAttribute("params", params);
				JSONObject json = giclClaimPaymentService.showClaimPayment(request, USER);
				if ("1".equals(request.getParameter("refresh"))) {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonClaimPayment", json);
					PAGE = "/pages/claims/inquiry/claimPayment/claimPayment.jsp";
				}
			} else if ("exitClaimPayment".equals(action)) {
				PAGE = "/pages/claims/inquiry/claimPayment/claimPayment.jsp";
			} else if ("getClmPolLOV".equals(action)) {
				String lineCd = request.getParameter("lineCd");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("lineCd", lineCd);
				params.put("moduleId", "GICLS261");
				params.put("userId", USER.getUserId());

				JSONObject json = new JSONObject(TableGridUtil.getTableGrid(
						request, params));
				if ("1".equals(request.getParameter("ajax"))) {
					request.setAttribute("lineCd", lineCd);
					request.setAttribute("lineName",
							request.getParameter("lineName"));
					request.setAttribute("jsonClaimInfoTableGrid", json);
					PAGE = "/pages/claims/inquiry/claimPayment/claimPayment.jsp";
				} else {
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			} else if ("getClmAdvice".equals(action)) {
				Map<String, Object> params = new HashMap<String, Object>();
				request.setAttribute("action", action);
				request.setAttribute("params", params);
				if ("1".equals(request.getParameter("refresh"))) {
					JSONObject json = giclClaimPaymentService
							.showClaimPaymentAdv(request, USER);
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonClaimPaymentAdv",
							new JSONObject());
					PAGE = "/pages/claims/inquiry/claimPayment/claimPayment.jsp";
				}
			} else if ("getCheckInfo".equals(action)) {
				request.setAttribute("tranId", request.getParameter("tranId"));
				request.setAttribute("checkPrefSuf",
						request.getParameter("checkPrefSuf"));
				request.setAttribute("checkNo", request.getParameter("checkNo"));
				request.setAttribute("checkReleaseDate",
						request.getParameter("checkReleaseDate"));
				request.setAttribute("checkReleasedBy",
						request.getParameter("checkReleasedBy"));
				request.setAttribute("checkReceivedBy",
						request.getParameter("checkReceivedBy"));
				request.setAttribute("userId", request.getParameter("userId"));
				request.setAttribute("orNo", request.getParameter("orNo"));
				request.setAttribute("orDate", request.getParameter("orDate"));
				request.setAttribute("lastUpdate",
						request.getParameter("lastUpdate"));
				System.out.println(request.getParameter("tranId"));
				PAGE = "/pages/claims/inquiry/claimPayment/subPages/checkRelease.jsp";
			} else if ("validateEntries".equals(action)) {
				message = giclClaimPaymentService.validateEntries(request);
				//PAGE = "/pages/claims/inquiry/claimPayment/claimPayment.jsp";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (JSONException e) {
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
