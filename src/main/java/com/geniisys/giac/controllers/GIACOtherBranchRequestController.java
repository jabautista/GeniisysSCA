package com.geniisys.giac.controllers;

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

@WebServlet (name="GIACOtherBranchRequestController", urlPatterns="/GIACOtherBranchRequestController")
public class GIACOtherBranchRequestController extends BaseController{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2787747057625655028L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if ("showOtherBranchTableGrid".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", "getOtherBranchDisbRequestGrid");
				params.put("moduleId", request.getParameter("moduleId") == null ? "GIACS055" : request.getParameter("moduleId"));
				params.put("appUser", USER.getUserId());
				params.put("clmSw", request.getParameter("clmSw"));
				Map<String, Object> disbRequestOtherBranchTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsondisbRequestOtherBranchTableGrid = new JSONObject(disbRequestOtherBranchTableGrid);
				System.out.println(jsondisbRequestOtherBranchTableGrid.toString());
				if("1".equals(request.getParameter("refresh"))){
					message = jsondisbRequestOtherBranchTableGrid.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsondisbRequestOtherBranchTableGrid", jsondisbRequestOtherBranchTableGrid);
					PAGE = "/pages/accounting/generalDisbursements/otherBranchDisbRequests/otherBranchTableGridListing.jsp";
				}
			
				request.setAttribute("clmSw", request.getParameter("clmSw"));
				request.setAttribute("tranType", request.getParameter("tranType"));
				request.setAttribute("fromClaimItemInfo",request.getParameter("fromClaimItemInfo"));
				request.setAttribute("moduleTitle", request.getParameter("moduleTitle") == "" ? "Branch DV" : request.getParameter("moduleTitle")); //modified by apollo 8.11.2014
				request.setAttribute("disbursementCd", request.getParameter("disbursementCd"));
			}
			
			
		}  catch (Exception e) {			
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
		
	}

}
