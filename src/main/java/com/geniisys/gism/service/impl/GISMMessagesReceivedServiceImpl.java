package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gism.dao.GISMMessagesReceivedDAO;
import com.geniisys.gism.service.GISMMessagesReceivedService;
import com.seer.framework.util.StringFormatter;

public class GISMMessagesReceivedServiceImpl implements GISMMessagesReceivedService{

	private GISMMessagesReceivedDAO gismMessagesReceivedDAO;

	public GISMMessagesReceivedDAO getGismMessagesReceivedDAO() {
		return gismMessagesReceivedDAO;
	}

	public void setGismMessagesReceivedDAO(GISMMessagesReceivedDAO gismMessagesReceivedDAO) {
		this.gismMessagesReceivedDAO = gismMessagesReceivedDAO;
	}

	@Override
	public JSONObject getMessagesReceived(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMessagesReceived");
		
		Map<String, Object> messagesReceivedTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(messagesReceivedTG);
	}

	@Override
	public JSONObject getMessageDetail(HttpServletRequest request)
			throws SQLException, JSONException {
		Integer messageId = request.getParameter("messageId") == null || request.getParameter("messageId").equals("") ? 0 :
								Integer.parseInt(request.getParameter("messageId"));
		
		Map<String, Object> detail = this.getGismMessagesReceivedDAO().getMessageDetail(messageId);
		JSONObject json = detail == null ? new JSONObject() :
			new JSONObject(StringFormatter.escapeHTMLInMap(this.getGismMessagesReceivedDAO().getMessageDetail(messageId)));
		
		return json;
	}

	@Override
	public void replyToMessage(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("message", request.getParameter("message"));
		params.put("sender", request.getParameter("sender"));
		params.put("cellphoneNo", request.getParameter("cellphoneNo"));
		params.put("dateReceived", request.getParameter("dateReceived"));
		params.put("userId", userId);
		
		this.getGismMessagesReceivedDAO().replyToMessage(params);
	}

	@Override
	public JSONObject getSMSErrorLog(HttpServletRequest request)
			throws SQLException, JSONException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getSMSErrorLog");
		
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
		
	}

	@Override
	public void gisms008Assign(HttpServletRequest request, String userId)
			throws SQLException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("number", request.getParameter("number"));
		params.put("cellphoneNo", request.getParameter("cellphoneNo"));
		params.put("keyword", request.getParameter("keyword"));
		params.put("message", request.getParameter("message"));
		params.put("classCd", request.getParameter("classCd"));
		
		System.out.println(params);
		
		gismMessagesReceivedDAO.gisms008Assign(params);
	}

	@Override
	public void gisms008Purge(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("cellphoneNo", request.getParameter("cellphoneNo"));
		params.put("keyword", request.getParameter("keyword"));
		params.put("message", request.getParameter("message"));
		
		JSONObject obj = new JSONObject(request.getParameter("rows"));
		JSONArray arr = new JSONArray(obj.getString("rows"));
		
		params.put("arr", arr);
		
		gismMessagesReceivedDAO.gisms008Purge(params);
	}
	
}
