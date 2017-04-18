package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.ApplicationContext;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.entity.LOV;
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.LOVHelper;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIUserEventService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIUserEventController extends BaseController{

	private static final long serialVersionUID = -1921156799323929229L;
	private static Logger log = Logger.getLogger(GIPIUserEventController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		log.info("do processing");
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIUserEventService userEventService = (GIPIUserEventService) APPLICATION_CONTEXT.getBean("gipiUserEventService");	
		
		try {
			if("showWorkflow".equals(ACTION)){				
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", Integer.parseInt((request.getParameter("page") == null ? "1" : request.getParameter("page"))));
				params.put("userId", (USER.getAllUserSw().equals("Y") ? null : USER.getUserId()));
				Map<String, Object> userEventTableGrid = userEventService.getGIPIUserEventTableGrid(params); 
				request.setAttribute("userEventTableGrid", new JSONObject(userEventTableGrid));				
				PAGE = "/pages/workflow/workflow/workflowMain.jsp";
			} else if ("refreshUserEvents".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("currentPage", Integer.parseInt(request.getParameter("page")));
				params.put("filter", request.getParameter("objFilter"));
				params.put("userId", (USER.getAllUserSw().equals("Y") ? null : USER.getUserId()));
				params.put("sortColumn", request.getParameter("sortColumn"));
				params.put("ascDescFlg", request.getParameter("ascDescFlg"));
				Map<String, Object> userEventTableGrid = userEventService.getGIPIUserEventTableGrid(params);
				JSONObject json = new JSONObject(userEventTableGrid);				
				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if ("getGIPIUserEventDetailListing".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", request.getParameter("action"));
				params.put("eventCd", request.getParameter("eventCd"));				
				params.put("userId", request.getParameter("userId"));
				Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);		
				JSONObject json = new JSONObject(tranListTableGrid);
				
				if(request.getParameter("refresh")!= null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					LOVHelper helper = (LOVHelper)APPLICATION_CONTEXT.getBean("lovHelper");
					String args[] = {"GIPI_USER_EVENTS.STATUS"};
					List<LOV> status = helper.getList(LOVHelper.CG_REF_CODES_ORDER_BY_VALUE_LISTING, args);
					request.setAttribute("status", new JSONArray(status));
					request.setAttribute("userEventDetailTableGrid", json);
					PAGE = "/pages/workflow/workflow/subPages/userEventDetailListing.jsp";
				}
			} else if("showWorkflowRemarks".equals(ACTION)){
				LOVHelper lovHelper = (LOVHelper) APPLICATION_CONTEXT.getBean("lovHelper");
				String args[] = {"GIPI_USER_EVENTS.STATUS"};				
				request.setAttribute("status", lovHelper.getList(LOVHelper.CG_REF_CODE_LISTING, args));
				request.setAttribute("mode", request.getParameter("mode"));
				GIISParameterFacadeService parameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("workflowMsgr", parameterService.getParamValueV2("WORKFLOW_MSGR"));
				request.setAttribute("popupDir", parameterService.getParamValueV2("REALPOPUP_DIR"));
				PAGE = "/pages/workflow/workflow/subPages/workflowRemarks.jsp";
			} else if("saveCreatedEvent".equals(ACTION)){
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				GIPIUserEventService gipiUserEventService = (GIPIUserEventService) appContext.getBean("gipiUserEventService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("userId", USER.getUserId());
				message = gipiUserEventService.saveCreatedEvent(params);
				PAGE = "/pages/genericMessage.jsp";
			} else if("transferEvents".equals(ACTION)){
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				GIPIUserEventService gipiUserEventService = (GIPIUserEventService) appContext.getBean("gipiUserEventService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("userId", USER.getUserId());
				message = gipiUserEventService.transferEvents(params);
				PAGE = "/pages/genericMessage.jsp";	
			} else if("deleteEvents".equals(ACTION)){
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				GIPIUserEventService gipiUserEventService = (GIPIUserEventService) appContext.getBean("gipiUserEventService");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("request", request);
				params.put("userId", USER.getUserId());
				gipiUserEventService.deleteEvents(params);
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";						
			} else if ("getWorkflowTranList".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("eventCd", request.getParameter("eventCd"));
				Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);				
				JSONObject json = new JSONObject(tranListTableGrid);			
				request.setAttribute("tranListTableGrid", json);				
				PAGE = "/pages/workflow/workflow/subPages/tranList.jsp";
			} else if("getEventsByDateSent".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("date", request.getParameter("date"));
				params.put("userId", USER.getUserId());
				Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);		
				JSONObject json = new JSONObject(tranListTableGrid);			

				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("eventListTableGrid", json);
					PAGE = "/pages/workflow/workflow/subPages/sentTransaction.jsp";
				}
			} else if("getEventsByDateRange".equals(ACTION)){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("ACTION", ACTION);	
				params.put("dateFrom", request.getParameter("dateFrom"));
				params.put("dateTo", request.getParameter("dateTo"));
				params.put("userId", USER.getUserId());
				Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);		
				JSONObject json = new JSONObject(tranListTableGrid);			

				message = json.toString();
				PAGE = "/pages/genericMessage.jsp";
			} else if("saveUserEventDetails".equals(ACTION)){
				ApplicationContext appContext = ApplicationContextReader.getServletContext(getServletContext());
				GIPIUserEventService gipiUserEventService = (GIPIUserEventService) appContext.getBean("gipiUserEventService");
				gipiUserEventService.saveGIPIUserEventDtls(request, USER.getUserId());
				message = "SUCCESS";
				PAGE = "/pages/genericMessage.jsp";
			}
		} catch (SQLException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (JSONException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (ParseException e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} catch (Exception e) {
			message = ExceptionHandler.handleException(e, USER);
			PAGE = "/pages/genericMessage.jsp";
		} finally {
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}

}
