package com.geniisys.gism.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gism.dao.GISMMessagesSentDAO;
import com.geniisys.gism.service.GISMMessagesSentService;

public class GISMMessagesSentServiceImpl implements GISMMessagesSentService{

	private GISMMessagesSentDAO gismMessagesSentDAO;

	public GISMMessagesSentDAO getGismMessagesSentDAO() {
		return gismMessagesSentDAO;
	}

	public void setGismMessagesSentDAO(GISMMessagesSentDAO gismMessagesSentDAO) {
		this.gismMessagesSentDAO = gismMessagesSentDAO;
	}

	@Override
	public JSONObject getMessagesSent(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMessagesSent");
		params.put("status", request.getParameter("status"));
		params.put("userId", userId);
		
		Map<String, Object> messagesSentTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(messagesSentTG);
	}

	@Override
	public JSONObject getMessageDetails(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getMessageDetails");
		params.put("messageId", request.getParameter("messageId"));
		
		Map<String, Object> messagesSentTG = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(messagesSentTG);
	}

	@Override
	public void resendMessage(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("messageId", request.getParameter("messageId"));
		params.put("userId", userId);
		
		this.getGismMessagesSentDAO().resendMessage(params);
	}

	@Override
	public JSONObject getCreatedMessages(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCreatedMessages");
		params.put("userId", userId);
		
		Map<String, Object> messageJSON = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(messageJSON);
	}

	@Override
	public void cancelMessage(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("messageId", request.getParameter("messageId"));
		params.put("userId", userId);
		
		this.getGismMessagesSentDAO().cancelMessage(params);
	}

	@Override
	public JSONObject getCreatedMessagesDtl(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getCreatedMessagesDtl");
		params.put("messageId", request.getParameter("messageId"));
		
		Map<String, Object> messageDtlJSON = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(messageDtlJSON);
	}

	@Override
	public JSONObject getRecipientList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRecipientList");
		params.put("groupCd", request.getParameter("groupCd"));
		params.put("bdaySw", request.getParameter("bdaySw"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("default", request.getParameter("chkDefault"));
		params.put("globe", request.getParameter("chkGlobe"));
		params.put("smart", request.getParameter("chkSmart"));
		params.put("sun", request.getParameter("chkSun"));
		
		Map<String, Object> recipientJSON = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(recipientJSON);
	}

	@Override
	public void saveMessages(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("setRows"))));
		params.put("delRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("delRows"))));
		params.put("delDtlRows", JSONUtil.prepareMapListFromJSON(new JSONArray(paramsObj.getString("delDtlRows"))));
		params.put("userId", userId);
		this.getGismMessagesSentDAO().saveMessages(params);
	}

	@Override
	public String validateCellphoneNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("cellphoneNo", request.getParameter("cellphoneNo"));
		params.put("default", request.getParameter("chkDefault"));
		params.put("globe", request.getParameter("chkGlobe"));
		params.put("smart", request.getParameter("chkSmart"));
		params.put("sun", request.getParameter("chkSun"));
		return this.getGismMessagesSentDAO().validateCellphoneNo(params);
	}
	
}
