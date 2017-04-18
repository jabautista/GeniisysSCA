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

@WebServlet (name="GICLClaimStatusController", urlPatterns={"/GICLClaimStatusController"})
public class GICLClaimStatusController extends BaseController{
	private static final long serialVersionUID = 1L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if("showMenuClaimStatus".equals(ACTION)){
				String clmStatusType = null;
				String dateBy = request.getParameter("dateBy");
				String dateAsOf = request.getParameter("dateAsOf");
				String dateFrom = request.getParameter("dateFrom");
				String dateTo = request.getParameter("dateTo");
							
				try{
					clmStatusType = request.getParameter("clmStatusType");
					if (clmStatusType.equals(null))
						clmStatusType = "%";
				}catch(NullPointerException e){
					clmStatusType = "%";
				}
				
				Map<String, Object> params = new HashMap<String, Object>();				
				params.put("ACTION", "getClaimStatus");				
				params.put("appUser", USER.getUserId());
				params.put("clmStatusType", clmStatusType);
				params.put("dateBy", dateBy);
				params.put("dateAsOf", dateAsOf);
				params.put("dateFrom", dateFrom);
				params.put("dateTo", dateTo);
				
				Map<String, Object> clmStatusTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonClmStatus = new JSONObject(clmStatusTableGrid);
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonClmStatus.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					request.setAttribute("jsonClmStatus", jsonClmStatus);
					PAGE = "/pages/claims/inquiry/claimStatus/claimStatus.jsp";				
				}
			}
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
