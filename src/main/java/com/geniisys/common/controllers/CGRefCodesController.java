package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.CGRefCodesService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.ApplicationContextReader;
import com.seer.framework.util.StringFormatter;

public class CGRefCodesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
			CGRefCodesService cgRefCodesService = (CGRefCodesService) APPLICATION_CONTEXT.getBean("cgRefCodesService");
			
			if ("checkCharRefCodes".equals(ACTION)) {
				String value = request.getParameter("value");
				String meaning = request.getParameter("meaning");
				String domain = request.getParameter("domain");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("pValue", value);
				params.put("pMeaning", meaning);
				params.put("pDomain", domain);
				cgRefCodesService.checkCharRefCodes(params);
				message = new JSONObject(StringFormatter.replaceQuotesInMap(params)).toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("validateMemoType".equals(ACTION)) {
				request.setAttribute("object", cgRefCodesService.validateMemoType(request));
				System.out.println(cgRefCodesService.validateMemoType(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIACS127TranClass".equals(ACTION)) {
				request.setAttribute("object", cgRefCodesService.validateGIACS127TranClass(request));
				PAGE = "/pages/genericObject.jsp";
			} else if ("validateGIACS127JVTran".equals(ACTION)) {
				request.setAttribute("object", cgRefCodesService.validateGIACS127JVTran(request));
				PAGE = "/pages/genericObject.jsp";
			}
			
			
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
