package com.geniisys.lov.util;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.seer.framework.util.StringFormatter;

@WebServlet(name = "CLTransactionsLOVController", urlPatterns = { "/CLTransactionsLOVController" })
public class CLTransactionsLOVController extends BaseController {

	private static final long serialVersionUID = -2330391225494606196L;

	/**
	 * created by Kenneth L. 11.09.15
	 */
	

	@Override
	public void doProcessing(HttpServletRequest request, HttpServletResponse response, GIISUser USER, String ACTION, HttpSession SESSION) throws ServletException, IOException {
		try {

			Map<String, Object> params = new HashMap<String, Object>();
			params.put("currentPage", Integer.parseInt(request.getParameter("page")));
			params.put("moduleId", request.getParameter("moduleId"));
			params.put("userId", USER.getUserId());
			params.put("sortColumn", request.getParameter("sortColumn"));
			params.put("ascDescFlg", request.getParameter("ascDescFlg"));
			params.put("findText", request.getParameter("findText"));
			if (request.getParameter("findText") == null && request.getParameter("filterText") != null) {
				params.put("findText", request.getParameter("filterText"));
			}
			if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")) {
				params.put("notIn", request.getParameter("notIn"));
			}
			params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null : request.getParameter("objFilter"));
			params.put("ACTION", ACTION);
			if ("showReasonLOV".equals(ACTION)) {
				// no specific parameters for this LOV
			}
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(params));
			message = json.toString();
			PAGE = "/pages/genericMessage.jsp";
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
