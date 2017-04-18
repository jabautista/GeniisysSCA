package com.geniisys.gipi.controllers;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
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
import com.geniisys.common.service.GIISParameterFacadeService;
import com.geniisys.framework.util.BaseController;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.service.GIPIReminderService;
import com.seer.framework.util.ApplicationContextReader;

public class GIPIReminderController extends BaseController {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3019719371141298181L;
	private static Logger log = Logger.getLogger(GIPIReminderController.class);
	
	@Override
	public void doProcessing(HttpServletRequest request,
			HttpServletResponse response, GIISUser USER, String ACTION,
			HttpSession SESSION) throws ServletException, IOException {
		ApplicationContext APPLICATION_CONTEXT = ApplicationContextReader.getServletContext(getServletContext());
		GIPIReminderService reminderService = (GIPIReminderService) APPLICATION_CONTEXT.getBean("gipiReminderService");
		log.info("doProcessing");
		try {
			if("getGIPIReminderListing".equals(ACTION)){
				JSONObject json = reminderService.getGIPIReminderListing(request, USER.getUserId());
				if(request.getParameter("refresh") != null && request.getParameter("refresh").equals("1")){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				} else {
					request.setAttribute("reminderListing", json);
					PAGE = "/pages/workflow/workflow/subPages/reminder.jsp";
				}								
			} else if("showMiniReminder".equals(ACTION)){ // jomsdiago 08.22.2013
				//JSONObject jsonMiniReminder = reminderService.getGIPIReminderDetails(request, USER.getUserId());
				GIISParameterFacadeService parameterService = (GIISParameterFacadeService) APPLICATION_CONTEXT.getBean("giisParameterFacadeService");
				request.setAttribute("popupDir", parameterService.getParamValueV2("REALPOPUP_DIR"));
				Map<String, Object> params = new HashMap<String, Object>();
				String claimId = request.getParameter("claimId");	//SR-19555 : shan 07.07.2015 
				String parId = (claimId != "" && claimId != null) ? null : request.getParameter("parId");	//SR-19555 : shan 07.07.2015 
				
				params.put("ACTION", "getGIPIReminderDetails");
				params.put("parId", /*request.getParameter("parId")*/ parId);	//SR-19555 : shan 07.07.2015
				params.put("claimId", /*request.getParameter("claimId")*/ claimId);	//SR-19555 : shan 07.07.2015
				Map<String, Object> miniReminderTableGrid = TableGridUtil.getTableGrid(request, params);
				JSONObject jsonMiniReminder = new JSONObject(miniReminderTableGrid);
				JSONArray rows = jsonMiniReminder.getJSONArray("rows");
				
				for (int i = 0; i < rows.length(); i++) {
					rows.getJSONObject(i).put("tbgAlarmFlag", rows.getJSONObject(i).getString("alarmFlag").equals("Y") ? true : false);
					rows.getJSONObject(i).put("tbgRenewFlag", rows.getJSONObject(i).getString("renewFlag").equals("Y") ? true : false);
				}
				
				jsonMiniReminder.remove("rows");
				jsonMiniReminder.put("rows", rows);

				if (claimId != "" && claimId != null){	//SR-19555 : shan 07.07.2015
					parId = reminderService.getClaimParId(request.getParameter("claimId")).toString();
				}
				
				request.setAttribute("jsonMiniReminder", jsonMiniReminder);
				request.setAttribute("parId", /*request.getParameter("parId")*/ parId);	//SR-19555 : shan 07.07.2015
				request.setAttribute("claimId", /*request.getParameter("claimId")*/ claimId); 	//SR-19555 : shan 07.07.2015
				request.setAttribute("userId", USER.getUserId());
				
				if("1".equals(request.getParameter("refresh"))){
					message = jsonMiniReminder.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/common/miniReminder/miniReminder.jsp";					
				}
			}else if ("saveReminder".equals(ACTION)) {
				log.info("saving reminder...");
				message = reminderService.saveReminder(request, USER.getUserId());
				PAGE = "/pages/genericMessage.jsp";	
			}else if("validateAlarmUser".equals(ACTION)){
				message = reminderService.validateAlarmUser(request).toString();
				PAGE = "/pages/genericMessage.jsp";
			}else if("showGipis208".equals(ACTION)){		
				JSONObject json = reminderService.showNotesPage(request, USER);
				if("1".equals(request.getParameter("refresh"))){
					message = json.toString();
					PAGE = "/pages/genericMessage.jsp";
				}else{
					PAGE = "/pages/underwriting/policyInquiries/policyInformation/notes.jsp";					
				}							
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
		} finally {		
			request.setAttribute("message", message);
			this.doDispatch(request, response, PAGE);
		}
	}
}
