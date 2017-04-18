package com.geniisys.gipi.controllers;

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

@WebServlet (name="GIPIUserEventHistController", urlPatterns={"/GIPIUserEventHistController"})
public class GIPIUserEventHistController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8477124605877024036L;

	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		try {
			if("getGIPIUserEventHistList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("tranId", request.getParameter("tranId"));
				Map<String, Object> historyTableGrid = TableGridUtil.getTableGrid(request, params);			
				JSONObject json = new JSONObject(historyTableGrid);	
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("historyTableGrid", json);
					PAGE = "/pages/workflow/workflow/subPages/history.jsp";
				}						
			}	else if("getEventHistByDateSent".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("eventCd", request.getParameter("eventCd"));
				params.put("date", request.getParameter("date"));
				params.put("userId", USER.getUserId());
				Map<String, Object> eventHistTableGrid = TableGridUtil.getTableGrid(request, params);		
				JSONObject json = new JSONObject(eventHistTableGrid);			

				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("getEventHistByDateRange".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);
				params.put("eventCd", request.getParameter("eventCd"));
				params.put("dateFrom", request.getParameter("dateFrom"));
				params.put("dateTo", request.getParameter("dateTo"));
				params.put("userId", USER.getUserId());
				Map<String, Object> eventHistTableGrid = TableGridUtil.getTableGrid(request, params);		
				JSONObject json = new JSONObject(eventHistTableGrid);

				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("printHistory".equals(ACTION)){
				System.out.println(request.getParameter("destination"));
				System.out.println(request.getParameter("printer"));
				System.out.println(request.getParameter("noOfCopies"));
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			doDispatch(request, response, PAGE);
		}
	}

	
	
}
