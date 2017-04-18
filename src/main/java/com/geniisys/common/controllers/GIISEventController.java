package com.geniisys.common.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISEventService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.ApplicationContextReader;

public class GIISEventController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = -9118285719255472072L;
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {		
		ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
		GIISEventService giisEventService = (GIISEventService) appContext.getBean("giisEventService");
		try {
			if("getGIISEventListing".equals(ACTION)){		
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);				
				Map<String, Object> eventTableGrid = TableGridUtil.getTableGrid(request, params);				
				JSONObject json = new JSONObject(eventTableGrid);				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("eventTableGrid", json);
					PAGE = "/pages/workflow/workflow/maintenance/eventMaintenance/eventMaintenance.jsp";
				}
			} else if("saveGIISEvents".equals(ACTION)){
				giisEventService.saveGIISEvents(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			/*} else if("getGIISUserEventListing".equals(ACTION)){		
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);				
				Map<String, Object> eventTableGrid = TableGridUtil.getTableGrid(request, params);				
				JSONObject json = new JSONObject(eventTableGrid);				
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();					
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("eventTableGrid", json);
					PAGE = "/pages/workflow/workflow/maintenance/userEventMaintenance.jsp";
				}*/
			} else if ("valDeleteGIISEvents".equals(ACTION)){
				giisEventService.valDeleteGIISEvents(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if("createTransferEvent".equals(ACTION)){
				String messages = giisEventService.createTransferEvent(request, USER.getUserId());
				message = messages;
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIISEventColumn".equals(ACTION)){
				JSONObject json = giisEventService.getGIISEventColumn(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISEventColumn", json);
					PAGE = "/pages/workflow/workflow/maintenance/eventMaintenance/pop-ups/eventColumnMaintenance.jsp";
				}				
			} else if ("valDeleteGIISEventsColumn".equals(ACTION)){
				giisEventService.valDeleteGIISEventsColumn(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			} else if ("valAddGIISEventsColumn".equals(ACTION)){
				giisEventService.valAddGIISEventsColumn(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("setGIISEventsColumn".equals(ACTION)) {
				giisEventService.setGIISEventsColumn(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}else if("getGIISEventDisplay".equals(ACTION)){
				JSONObject json = giisEventService.getGIISEventDisplay(request, USER.getUserId());
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("jsonGIISEventDisplay", json);
					PAGE = "/pages/workflow/workflow/maintenance/eventMaintenance/pop-ups/eventDisplayMaintenance.jsp";
				}				
			} else if ("valAddGIISEventsDisplay".equals(ACTION)){
				giisEventService.valAddGIISEventsDisplay(request);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";				
			} else if ("setGIISEventsDisplay".equals(ACTION)) {
				giisEventService.setGIISEventsDisplay(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ 
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = ExceptionHandler.handleException(e, USER);
			}
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e){
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}		
	}

}
