package com.geniisys.gipi.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISEvent;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.Mailer;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.dao.GIPIUserEventDAO;
import com.geniisys.gipi.entity.GIPIUserEvent;
import com.geniisys.gipi.entity.GUEAttach;
import com.geniisys.gipi.service.GIPIUserEventService;
import com.seer.framework.util.StringFormatter;

public class GIPIUserEventServiceImpl implements GIPIUserEventService {

	private GIPIUserEventDAO gipiUserEventDAO;
	private Mailer mailer;
	private static Logger log = Logger.getLogger(GIPIUserEventServiceImpl.class);
	
	public void setGipiUserEventDAO(GIPIUserEventDAO gipiUserEventDAO) {
		this.gipiUserEventDAO = gipiUserEventDAO;
	}

	public GIPIUserEventDAO getGipiUserEventDAO() {
		return gipiUserEventDAO;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIPIUserEventTableGrid(Map<String, Object> params)
			throws SQLException, JSONException {
		log.info("Preparing GIPI User Event Table Grid...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareUserEventFilter((String) params.get("filter")));
		List<GIPIUserEvent> list = this.getGipiUserEventDAO().getGIPIUserEventTableGrid(params);
		params.put("rows", new JSONArray((List<GIPIUserEvent>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println(grid.getNoOfPages());
		System.out.println(grid.getNoOfRows());
		log.info("GIPI User Event Table Grid preparation done.");
		return params;
	}
	
	private GIPIUserEvent prepareUserEventFilter(String filter) throws JSONException{
		GIPIUserEvent userEvent = new GIPIUserEvent();
		JSONObject jsonFilter = null;
		if(null == filter) {
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		userEvent.setEventDesc(jsonFilter.isNull("eventDesc") ? "%%" : "%"+jsonFilter.getString("eventDesc")+"%");
		return userEvent;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIPIUserEventDetailTableGrid(
			Map<String, Object> params) throws SQLException, JSONException, ParseException {
		log.info("Preparing GIPI User Event Detail Table Grid...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		params.put("filter", this.prepareUserEventDetailFilter((String) params.get("filter")));
		List<GIPIUserEvent> list = this.getGipiUserEventDAO().getGIPIUserEventDetailTableGrid(params);
		params.put("rows", new JSONArray((List<GIPIUserEvent>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());				
		log.info("GIPI User Event Table Grid Detail preparation done.");
		return params;
	}

	private GIPIUserEvent prepareUserEventDetailFilter(String filter) throws JSONException, ParseException{
		GIPIUserEvent userEvent = new GIPIUserEvent();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		JSONObject jsonFilter = null;
		if(null == filter) {
			jsonFilter = new JSONObject();
		} else {
			jsonFilter = new JSONObject(filter);
		}
		
		userEvent.setTranDtl(jsonFilter.isNull("tranDtl") ? "%%" : jsonFilter.getString("tranDtl"));
		userEvent.setSender(jsonFilter.isNull("sender") ? "%%" : jsonFilter.getString("sender"));
		userEvent.setRecipient(jsonFilter.isNull("recepient") ? "%%" : jsonFilter.getString("recepient"));
		userEvent.setDateReceived(jsonFilter.isNull("dateReceived") ? null : df.parse(jsonFilter.getString("dateReceived")));
		userEvent.setRemarks(jsonFilter.isNull("remarks") ? "%%" : jsonFilter.getString("remarks"));
		userEvent.setTranId(jsonFilter.isNull("tranId") ? null : jsonFilter.getInt("tranId"));
		userEvent.setStatusDesc(jsonFilter.isNull("status") ? "%%" : jsonFilter.getString("status"));
		userEvent.setDateDue(jsonFilter.isNull("dateDue") ? null : df.parse(jsonFilter.getString("dateDue")));
		
		return userEvent;
	}

	@Override
	public String saveCreatedEvent(Map<String, Object> params)
			throws SQLException, JSONException, Exception {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		String userId = (String) params.get("userId");
		params.put("users", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("users")), userId, GIISUser.class));
		params.put("event", JSONUtil.prepareObjectFromJSON(new JSONObject(request.getParameter("event")), userId, GIISEvent.class));
		params.put("attachments", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("attachments")), userId, GUEAttach.class));
		params.put("tranDtls", (request.getParameter("tranDtls") != null && !"".equals(request.getParameter("tranDtls")) ? JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("tranDtls"))) : null ));
		params.put("remarks", request.getParameter("remarks"));
		params.put("status", request.getParameter("status"));
		params.put("statusDesc", request.getParameter("statusDesc"));
		params.put("dateDue", request.getParameter("dateDue"));
		params.put("createTag", request.getParameter("createTag"));
		String workflowMsgr = request.getParameter("workflowMsgr");
		
		Map<String, Object> resultParams = this.gipiUserEventDAO.saveCreatedEvent(params);
		if("SUCCESS".equals(resultParams.get("messageType"))){
			if(workflowMsgr.equals("2") || workflowMsgr.equals("3")){
				sendWorkflowEmail(resultParams);
			}
		}
		
		String result = resultParams.get("messageType") + ApplicationWideParameters.RESULT_MESSAGE_DELIMITER + "Transaction completed. Transaction ID is " + resultParams.get("message");		
		return result;
	}

	public String transferEvents(Map<String, Object> params)
			throws SQLException, JSONException, Exception {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		String userId = (String) params.get("userId");
		params.put("users", JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("users"))));
		params.put("userEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("userEvents")), userId, GIPIUserEvent.class));
		params.put("event", JSONUtil.prepareObjectFromJSON(new JSONObject(request.getParameter("event")), userId, GIISEvent.class));		
	//	params.put("tranDtls", (request.getParameter("tranDtls") != null && !"".equals(request.getParameter("tranDtls")) ? JSONUtil.prepareMapListFromJSON(new JSONArray(request.getParameter("tranDtls"))) : null ));
		params.put("remarks", request.getParameter("remarks"));
		params.put("status", request.getParameter("status"));
		params.put("statusDesc", request.getParameter("statusDesc"));
		params.put("dateDue", request.getParameter("dateDue"));
		params.put("userId", userId);
		String workflowMsgr = request.getParameter("workflowMsgr");
		
		List<Map<String, Object>> resultParamsList = this.gipiUserEventDAO.transferEvents(params);
		String result = "";
		for(Map<String, Object> resultParam: resultParamsList){
			if("SUCCESS".equals(resultParam.get("messageType"))){
				if(workflowMsgr.equals("2") || workflowMsgr.equals("3")){
					sendWorkflowEmail(resultParam);
				}
				result = resultParam.get("messageType") + ApplicationWideParameters.RESULT_MESSAGE_DELIMITER + "Transaction completed. Transaction ID is " + resultParam.get("message");
			}			
		}			
		return result;
	}	
	
	@Override
	public void setWorkflowGICLS010(Map<String, Object> params)			throws SQLException {
		this.gipiUserEventDAO.setWorkflowGICLS010(params);
	}
		
	@SuppressWarnings("unchecked")
	private void sendWorkflowEmail(Map<String, Object> params){
		log.info("Sending email notification to users...");
		List<String> emailAddresses = (List<String>) params.get("emailAddresses");
		List<String> files = (List<String>) params.get("files");
		List<Map<String, Object>> tranDtls = (List<Map<String, Object>>) params.get("tranDtls");
		//String[] recipients = (String[]) emailAddresses.toArray(new String[emailAddresses.size()]);
				
		mailer.setRecepientList(emailAddresses);
		if(files != null) {
			mailer.setAttachments(files);
		}
		mailer.setEmailSubjectText("GENIISYS - Workflow");
		
		StringBuilder sb = new StringBuilder();
		sb.append(params.get("appUser"));
		sb.append(" assigned a new transaction - ");		
		sb.append(params.get("eventDesc"));
		if(tranDtls != null){
			for(Map<String, Object> tranDtl : tranDtls){
				sb.append("\n");
				sb.append(tranDtl.get("tranDtl"));
			}
		}		
		
		sb.append("\n\nTransaction Id : ");
		sb.append(params.get("message"));		
		sb.append("\nStatus : ");
		sb.append(params.get("statusDesc"));
		sb.append("\nDate Due : ");
		sb.append(params.get("dateDue"));
		sb.append("\nRemarks : ");
		sb.append(params.get("remarks"));
		
		mailer.setEmailMsgText(sb.toString());
		
		try {
			mailer.sendMailWithAttachments();
		} catch (MessagingException e) {
			ExceptionHandler.logException(e);
		}
	}

	public void setMailer(Mailer mailer) {
		this.mailer = mailer;
	}

	public Mailer getMailer() {
		return mailer;
	}

	@Override
	public void deleteEvents(Map<String, Object> params) throws SQLException, JSONException {
		HttpServletRequest request = (HttpServletRequest) params.get("request");
		String userId = (String) params.get("userId");
		params.put("userEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("userEvents")), userId, GIPIUserEvent.class));
		//params.put("userId", userId);
		
		this.gipiUserEventDAO.deleteEvents(params);
	}

	@Override
	public void saveGIPIUserEventDtls(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIPIUserEvent.class));
		this.gipiUserEventDAO.saveGIPIUserEventDtls(params);
	}	
}
