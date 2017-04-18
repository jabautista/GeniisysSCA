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

@WebServlet (name="GICLAcctEntriesController", urlPatterns={"/GICLAcctEntriesController"})
public class GICLAcctEntriesController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 118257318260124637L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		
		try {
			if("getGICLAcctEntriesList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("claimId", request.getParameter("claimId"));
				params.put("adviceId", request.getParameter("adviceId"));
				params.put("payeeCd", request.getParameter("payeeCd"));
				params.put("payeeClassCd", request.getParameter("payeeClassCd"));
				Map<String, Object> acctEntriesTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(acctEntriesTableGrid);	
				if(request.getParameter("refresh") != null && "1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonAcctEntries", json);
					PAGE = "/pages/claims/generateAdvice/generateAdvice/subPages/accountingEntries.jsp";
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
