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

@WebServlet(name = "UWReinsuranceLOVController", urlPatterns = { "/UWReinsuranceLOVController" })
public class UWReinsuranceLOVController extends BaseController {

	/**
	 * created by Gab Ramos 07.31.15
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
			
			if ("showBinderLov".equals(ACTION)) { 
				params.put("userId", USER.getUserId());
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("binderYy", request.getParameter("binderYy"));
				params.put("binderSeqNo", request.getParameter("binderSeqNo"));
			}
			/* benjo 08.03.2016 SR-5512 */
			else if("getGIRIS056TrtyYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGIRIS056TrtyNameLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("trtyYy", request.getParameter("trtyYy"));
			}else if("getGIRIS056RiLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("trtyYy", request.getParameter("trtyYy"));
				params.put("shareCd", request.getParameter("shareCd"));
				params.put("riCd", request.getParameter("riCd"));
			}else if("getGIRIS056TaxesLOV".equals(ACTION)){
				params.put("taxType", request.getParameter("taxType"));
			}else if("getGIRIS056SlLOV".equals(ACTION)){
				params.put("slTypeCd", request.getParameter("slTypeCd"));
			}else if("getGIRIS057TrtyYyLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
			}else if("getGIRIS057IntrtySeqNoLOV".equals(ACTION)){
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("trtyYy", request.getParameter("trtyYy"));
			}
			/* end */
			
			LOVUtil.getLOV(params);
			JSONObject json = new JSONObject(
					StringFormatter.escapeHTMLInMap(params));
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
