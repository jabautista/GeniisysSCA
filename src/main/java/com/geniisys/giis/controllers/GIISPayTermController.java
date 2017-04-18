package com.geniisys.giis.controllers;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.service.GIISPayTermService;
import com.seer.framework.util.ApplicationContextReader;

public class GIISPayTermController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 2193429038708435180L;


	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			GIISPayTermService giisPayTermService = (GIISPayTermService) APPLICATION_CONTEXT.getBean("giisPayTermService");
			if ("getPaymentTerm".equals(ACTION)) {
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				String modId = "GIISS018";
				params.put("moduleId", request.getParameter("moduleId") == null ? modId : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				Map<String, Object> payTermMaintenance = TableGridUtil.getTableGrid(request, params);
				JSONObject json = new JSONObject(payTermMaintenance);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("payTermMaintenance", json);
					PAGE = "/pages/underwriting/fileMaintenance/general/paymentTerm/paymentTerm.jsp";
				}else{
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("savePaymentTerm".equals(ACTION)){
				message = giisPayTermService.savePaymentTerm(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateDeletePaytTerm".equals(ACTION)){
				message = giisPayTermService.validateDeletePaytTerm(request.getParameter("parameters"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAddPaytTerm".equals(ACTION)){
				message = giisPayTermService.validateAddPaytTerm(request.getParameter("parameters"));
				PAGE = "/pages/genericMessage.jsp";
			}else if("validateAddPaytTermDesc".equals(ACTION)){
				message = giisPayTermService.validateAddPaytTermDesc(request);
				PAGE = "/pages/genericMessage.jsp";
			}
		}catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
		}finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
