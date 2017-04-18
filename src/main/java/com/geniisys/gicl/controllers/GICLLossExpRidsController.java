package com.geniisys.gicl.controllers;

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
import com.geniisys.framework.util.TableGridUtil;

@WebServlet(name="GICLLossExpRidsController", urlPatterns={"/GICLLossExpRidsController"})
public class GICLLossExpRidsController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			if("getGiclLossExpRidsList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("clmDistNo", request.getParameter("clmDistNo"));
				params.put("grpSeqNo", request.getParameter("grpSeqNo"));
				
				Map<String, Object> giclLossExpRids = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpRids = new JSONObject(giclLossExpRids);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpRids", jsonGiclLossExpRids);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/giclLossExpRidsTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpRids.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}
	
	
}
