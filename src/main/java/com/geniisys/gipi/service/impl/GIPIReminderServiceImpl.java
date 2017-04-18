package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISCurrency;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIReminderDAO;
import com.geniisys.gipi.entity.GIPIReminder;
import com.geniisys.gipi.service.GIPIReminderService;

public class GIPIReminderServiceImpl implements GIPIReminderService {
	
	private GIPIReminderDAO gipiReminderDAO;
	
	private Logger log = Logger.getLogger(GIPIReminderServiceImpl.class);
	
	public void setGipiReminderDAO(GIPIReminderDAO gipiReminderDAO) {
		this.gipiReminderDAO = gipiReminderDAO;
	}

	public GIPIReminderDAO getGipiReminderDAO() {
		return gipiReminderDAO;
	}

	@Override
	public JSONObject getGIPIReminderListing(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		log.info("Retrieving reminder listing...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("action"));	
		params.put("date", request.getParameter("date"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("dateMode", request.getParameter("dateMode"));
		params.put("rangeMode", request.getParameter("rangeMode"));
		params.put("userId", userId);
		Map<String, Object> tranListTableGrid = TableGridUtil.getTableGrid(request, params);		
		JSONObject json = new JSONObject(tranListTableGrid);
		return json;
	}

	@Override
	public JSONObject getGIPIReminderDetails(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		log.info("Retrieving reminder details...");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIPIReminderDetails");
		params.put("userId", userId);
		params.put("parId", request.getParameter("parId"));
		params.put("claimId", request.getParameter("claimId"));
		System.out.println("getGIPIReminderDetails params..........." + params);
		Map<String, Object> miniReminderTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonMiniReminder = new JSONObject(miniReminderTableGrid);
		request.setAttribute("jsonMiniReminder", jsonMiniReminder);
		return jsonMiniReminder;
	}

	@Override
	public String saveReminder(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIPIReminder.class));
		return this.getGipiReminderDAO().saveReminder(allParams);	
	}

	@Override
	public String validateAlarmUser(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("alarmUser", request.getParameter("alarmUser"));
		System.out.println("Validating GIUTS034 (Mini Reminder) alarm user...." + params);
		JSONObject result = new JSONObject(this.getGipiReminderDAO().validateAlarmUser(params));
		return result.toString();
	}

	@Override
	public JSONObject showNotesPage(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException, ParseException {		
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("ACTION", "getGipis208RecList");
	
		params.put("dateOpt",request.getParameter("dateOpt"));
		params.put("dateAsOf", request.getParameter("dateAsOf"));
		params.put("dateFrom", request.getParameter("dateFrom"));
		params.put("dateTo", request.getParameter("dateTo"));
		params.put("noteType", request.getParameter("noteType"));
		params.put("alarmFlag", request.getParameter("alarmFlag"));
		params.put("parId",request.getParameter("parId"));
		
		Map<String, Object> notesTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonNotesList = new JSONObject(notesTableGrid);
		request.setAttribute("dateOpt", request.getParameter("dateOpt"));
		request.setAttribute("dateAsOf", request.getParameter("dateAsOf"));
		request.setAttribute("parId", request.getParameter("parId"));
		request.setAttribute("jsonReminderList", jsonNotesList);
		return jsonNotesList;		
	}
	
	public Integer getClaimParId(String claimId) throws SQLException{	//SR-19555 : shan 07.07.2015
		return this.gipiReminderDAO.getClaimParId(claimId);
	}
}
