package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISEventDAO;
import com.geniisys.common.entity.GIISEvent;
import com.geniisys.common.entity.GIISEventsColumn;
import com.geniisys.common.entity.GIISEventsDisplay;
import com.geniisys.common.service.GIISEventService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISEventServiceImpl implements GIISEventService {

	private GIISEventDAO giisEventDAO;

	public void setGiisEventDAO(GIISEventDAO giisEventDAO) {
		this.giisEventDAO = giisEventDAO;
	}

	public GIISEventDAO getGiisEventDAO() {
		return giisEventDAO;
	}

	public void saveGIISEvents(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEvent.class));
		params.put("delEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEvent.class));
		params.put("appUser", userId);
		this.giisEventDAO.saveGIISEvents(params);
	}

	@Override
	public String createTransferEvent(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		String delimiter = ApplicationWideParameters.RESULT_MESSAGE_DELIMITER;
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		params.put("appUser", userId);
		params.put("eventDesc", request.getParameter("eventDesc"));
		params.put("colValue", request.getParameter("colValue"));
		params.put("info", request.getParameter("info"));
		params.put("delimiter", delimiter);
		
		this.getGiisEventDAO().createTransferEvent(params);
		
		String strMessages = params.get("messages").toString();
/*		List<Map<String, String>> messages = new ArrayList<Map<String,String>>();
		Map<String, String> message = null;
		if (strMessages != null && strMessages.contains(delimiter)) {
			String[] delimitedMessages = strMessages.split(delimiter);
			for(int i=0; i<delimitedMessages.length; i++){
				message = new HashMap<String, String>();
				message.put("message", delimitedMessages[i]);
				
				messages.add(message);
			}
		}*/
		
		//return new JSONObject(messages);
		return strMessages;
	}
	
	@Override
	public void valDeleteGIISEvents(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("eventCd") != null){
			String recId = request.getParameter("eventCd");
			this.getGiisEventDAO().valDeleteGIISEvents(recId);
		}
	}

	@Override
	public JSONObject getGIISEventColumn(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISEventColumn");
		params.put("eventCd", request.getParameter("eventCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}

	@Override
	public void valDeleteGIISEventsColumn(HttpServletRequest request)
			throws SQLException {
		if(request.getParameter("eventColCd") != null){
			String recId = request.getParameter("eventColCd");
			this.getGiisEventDAO().valDeleteGIISEventsColumn(recId);
		}
	}

	@Override
	public void valAddGIISEventsColumn(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("tableName", request.getParameter("tableName"));
		params.put("columnName", request.getParameter("columnName"));
		this.getGiisEventDAO().valAddGIISEventsColumn(params);
	}

	@Override
	public void setGIISEventsColumn(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEventsColumn.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEventsColumn.class));
		params.put("appUser", userId);
		this.getGiisEventDAO().setGIISEventsColumn(params);
	}
	
	@Override
	public JSONObject getGIISEventDisplay(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISEventDisplay");
		params.put("eventColCd", request.getParameter("eventColCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}

	@Override
	public void valAddGIISEventsDisplay(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("dspColId", request.getParameter("dspColId"));
		params.put("eventColCd", request.getParameter("eventColCd"));
		this.getGiisEventDAO().valAddGIISEventsDisplay(params);
	}

	@Override
	public void setGIISEventsDisplay(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISEventsDisplay.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISEventsDisplay.class));
		params.put("appUser", userId);
		this.getGiisEventDAO().setGIISEventsDisplay(params);
	}
	
}
