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

@WebServlet(name="UWRenewalProcessingLOVController", urlPatterns={"/UWRenewalProcessingLOVController"})
public class UWRenewalProcessingLOVController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -419448722672930009L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		// common parameters
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("currentPage", Integer.parseInt(request.getParameter("page")));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		params.put("sortColumn", request.getParameter("sortColumn"));
		params.put("ascDescFlg", request.getParameter("ascDescFlg"));
		params.put("findText", request.getParameter("findText"));
		if (request.getParameter("findText") == null && request.getParameter("filterText") != null){
			params.put("findText", request.getParameter("filterText"));
		}
		if (request.getParameter("notIn") != null && !request.getParameter("notIn").equals("")){
			params.put("notIn",request.getParameter("notIn"));
		}
		params.put("filter", "".equals(request.getParameter("objFilter")) || "{}".equals(request.getParameter("objFilter")) ? null :request.getParameter("objFilter"));
		params.put("ACTION", ACTION);
		
		
		try {		
			// IMPORTANT: use the specified action for controller as the id for sqlMap select/procedure
			
			// parameters per action

			if("getGiexs008LineLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));			
				params.put("issCd", request.getParameter("issCd"));
			}else if("getGiexs008SublineLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));			
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiexs008IssLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));			
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGiexs008CredBranchLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));			
				params.put("lineCd", request.getParameter("lineCd"));			
			}else if("getGiexs008IntmLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));	
			}else if("getGiexs008UserLov".equals(ACTION)){
				params.put("search", request.getParameter("search"));	
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("issCd", request.getParameter("issCd"));
				params.put("policyId", request.getParameter("policyId"));
				params.put("statusTag", request.getParameter("statusTag"));
				params.put("userId", USER.getUserId());
				params.put("toPage", request.getParameter("to"));
			}else if("getGiexs001CredBranchLOV".equals(ACTION)) { //benjo 11.12.2015 UW-SPECS-2015-087
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("moduleId", request.getParameter("moduleId"));
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
