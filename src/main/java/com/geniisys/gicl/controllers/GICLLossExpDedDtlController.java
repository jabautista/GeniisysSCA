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

@WebServlet(name="GICLLossExpDedDtlController", urlPatterns={"/GICLLossExpDedDtlController"})
public class GICLLossExpDedDtlController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try{
			if("getGiclLossExpDedDtlList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				
				Map<String, Object> giclLossExpDedDtl = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpDedDtl = new JSONObject(giclLossExpDedDtl);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("jsonGiclLossExpDedDtl", jsonGiclLossExpDedDtl);
					PAGE = "/pages/claims/lossExpenseHistory/subPages/lossExpDedDetailsTableGridListing.jsp";
				}else{
					message = jsonGiclLossExpDedDtl.toString();
					PAGE = "/pages/genericMessage.jsp";
				}
			}else if("showGICLS260LossExpDedDtl".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getGiclLossExpDedDtlList");
				params.put("claimId", request.getParameter("claimId"));
				params.put("clmLossId", request.getParameter("clmLossId"));
				params.put("lossExpCd", request.getParameter("lossExpCd"));
				params.put("lineCd", request.getParameter("lineCd"));
				params.put("sublineCd", request.getParameter("sublineCd"));
				params.put("payeeType", request.getParameter("payeeType"));
				
				Map<String, Object> giclLossExpDedDtl = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonGiclLossExpDedDtl = new JSONObject(giclLossExpDedDtl);
				if("1".equals(request.getParameter("ajax"))){
					request.setAttribute("clmLossId", request.getParameter("clmLossId"));
					request.setAttribute("lossExpCd", request.getParameter("lossExpCd"));
					request.setAttribute("sublineCd", request.getParameter("sublineCd"));
					request.setAttribute("payeeType", request.getParameter("payeeType"));
					request.setAttribute("dspExpDesc", request.getParameter("dspExpDesc"));
					request.setAttribute("jsonGiclLossExpDedDtl", jsonGiclLossExpDedDtl);
					PAGE = "/pages/claims/inquiry/claimInformation/lossExpenseHistory/overlay/dedDetailsListing.jsp";
				}else{
					message = jsonGiclLossExpDedDtl.toString();
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
