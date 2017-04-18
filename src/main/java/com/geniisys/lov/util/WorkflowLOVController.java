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

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;

@WebServlet (name="WorkflowLOVController", urlPatterns={"/WorkflowLOVController"})
public class WorkflowLOVController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(UnderwritingLOVController.class);

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		log.info("do processing");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("currentPage", Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null)
			params.put("findText", request.getParameter("filterText"));
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals(""))
			params.put("notIn", request.getParameter("notIn"));
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null : request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		
		try {
			
			if("getGiis168ModuleLov".equals(ACTION))
				params.put("selectedModules", request.getParameter("selectedModules"));
			else if("getGiiss168PassingUserLov".equals(ACTION)) {
				params.put("eventModCd", request.getParameter("eventModCd"));
				params.put("selectedPassingUsers", request.getParameter("selectedPassingUsers"));
			} else if("getGiiss168ReceivingUserLov".equals(ACTION)){
				params.put("eventModCd", request.getParameter("eventModCd"));
				params.put("passingUserid", request.getParameter("passingUserid"));
				params.put("selectedReceivingUsers", request.getParameter("selectedReceivingUsers"));
				
				System.out.println("PARAMS");
				System.out.println(params);
			}
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(params);
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
