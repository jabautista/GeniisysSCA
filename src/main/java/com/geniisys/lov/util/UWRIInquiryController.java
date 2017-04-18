package com.geniisys.lov.util;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.StringFormatter;

@WebServlet(name = "UWRIInquiryController", urlPatterns = { "/UWRIInquiryController" })
public class UWRIInquiryController extends BaseController {

	/**
	 * created by Gab Ramos 07.28.15
	 */
	private static final long serialVersionUID = -5149745550734999239L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {

			Map<String, Object> params = new HashMap<String, Object>();
			params.put("currentPage",
					Integer.parseInt(request.getParameter("page")));
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("userId", USER.getUserId());
			params.put("sortColumn", request.getParameter("sortColumn"));
			params.put("ascDescFlg", request.getParameter("ascDescFlg"));
			params.put("findText", request.getParameter("findText"));
			if (request.getParameter("findText") == null
					&& request.getParameter("filterText") != null) {
				params.put("findText", request.getParameter("filterText"));
			}
			if (request.getParameter("notIn") != null
					&& !request.getParameter("notIn").equals("")) {
				params.put("notIn", request.getParameter("notIn"));
			}
			params.put("filter", "".equals(request.getParameter("objFilter"))
					|| "{}".equals(request.getParameter("objFilter")) ? null
					: request.getParameter("objFilter"));
			params.put("ACTION", ACTION);
			PAGE = "/pages/genericMessage.jsp";
			
			if("getPolicyNumberLOV".equals(ACTION)){
				params.put("polLineCd", StringFormatter.unescapeBackslash3(StringFormatter.unescapeHTML2(request.getParameter("polLineCd")).replace("&#124;", "|")));
				params.put("sublineCd", StringFormatter.unescapeBackslash3(StringFormatter.unescapeHTML2(request.getParameter("sublineCd")).replace("&#124;", "|")));
				params.put("issCd", StringFormatter.unescapeBackslash3(StringFormatter.unescapeHTML2(request.getParameter("issCd")).replace("&#124;", "|")));
				params.put("issueYy", request.getParameter("issueYy")); 
				params.put("polSeqNo", request.getParameter("polSeqNo"));
				params.put("renewNo", request.getParameter("renewNo"));
				// added by gab ramos 07.28.2015
			}
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
			message = json.toString();
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
