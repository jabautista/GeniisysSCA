package com.geniisys.gipi.controllers;

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
import com.geniisys.framework.util.TableGridUtil;

@WebServlet(name="GIPIWBeneficiaryController", urlPatterns={"/GIPIWBeneficiaryController"})
public class GIPIWBeneficiaryController extends BaseController {
	
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try{
			if("getGIPIWBeneficiaryTableGrid".equals(ACTION)){
				Map<String, Object> tgParams = new HashMap<String, Object>();
				Integer parId = Integer.parseInt(request.getParameter("parId") != null ? request.getParameter("parId") : null);
				Integer itemNo = Integer.parseInt(request.getParameter("itemNo") != null ? request.getParameter("itemNo") : null);
				
				tgParams.put("ACTION", ACTION);
				tgParams.put("parId", parId);
				tgParams.put("itemNo", itemNo);
				//tgParams.put("pageSize", 5);
				
				//Map<String, Object> tgBeneficiaries = TableGridUtil.getTableGrid2(request, tgParams);
				Map<String, Object> tgBeneficiaries = TableGridUtil.getTableGrid(request, tgParams);
				
				if("1".equals(request.getParameter("refresh"))){
					message = (new JSONObject(tgBeneficiaries)).toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("tgBeneficiaries", new JSONObject(tgBeneficiaries));				
					PAGE = "/pages/underwriting/parTableGrid/accident/subPages/beneficiary/beneficiaryTableGridListing.jsp";
				}
			}
		}catch(NullPointerException e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}catch(Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		}finally{
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);			
		}		
	}
}