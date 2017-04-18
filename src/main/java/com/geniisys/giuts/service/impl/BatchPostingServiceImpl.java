package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.giuts.dao.BatchPostingDAO;
import com.geniisys.giuts.service.BatchPostingService;
import com.seer.framework.util.StringFormatter;

public class BatchPostingServiceImpl implements BatchPostingService {

	private BatchPostingDAO batchPostingDAO;

	public BatchPostingDAO getBatchPostingDAO() {
		return batchPostingDAO;
	}

	public void setBatchPostingDAO(BatchPostingDAO batchPostingDAO) {
		this.batchPostingDAO = batchPostingDAO;
	}

	@Override
	public JSONObject getParListForBatchPosting(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParListForBatchPosting");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("appUser", USER.getUserId());
		Map<String, Object> batchPostingTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBatchPosting = new JSONObject(batchPostingTbg);
		request.setAttribute("jsonBatchPosting", jsonBatchPosting);
		return jsonBatchPosting;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getParListByParameter(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getParListByParameter");
		params.put("lineCd", request.getParameter("paramLineCd"));
		params.put("appUser", USER.getUserId());
		params.put("paramLineCd", request.getParameter("paramLineCd"));
		params.put("paramSublineCd", request.getParameter("paramSublineCd"));
		params.put("paramIssCd", request.getParameter("paramIssCd"));
		params.put("paramUserId", request.getParameter("paramUserId"));
		params.put("paramParType", request.getParameter("paramParType"));
		params =  this.batchPostingDAO.getParListByParameter(params);
		List<GIPIPARList> list =  (List<GIPIPARList>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("par", new JSONArray(list));
		return params;
	}

	@Override
	public JSONObject getErrorLogForBatchPosting(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getErrorLogForBatchPosting");
		params.put("user", USER.getUserId()); // added by kenneth L. 02.10.2014
		Map<String, Object> errorLogTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonErrorLog = new JSONObject(errorLogTbg);
		request.setAttribute("jsonErrorLog", jsonErrorLog);
		return jsonErrorLog;
	}
	
	@Override
	public JSONObject getPostedLogForBatchPosting(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPostedLogForBatchPosting");
		params.put("user", USER.getUserId());
		Map<String, Object> postedLogTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPostedLog = new JSONObject(postedLogTbg);
		request.setAttribute("jsonPostedLog", jsonPostedLog);
		return jsonPostedLog;
	}
	
	@Override
	public void deleteLog(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ACTION", "deleteLog");
		param.put("appUser", USER.getUserId());
		param.put("userId", USER.getUserId());
		this.batchPostingDAO.deleteLog(param);
	}

	@Override
	public String checkIfBackEndt(HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ACTION", "checkIfBackEndt");
		param.put("parId", request.getParameter("parId"));
		return batchPostingDAO.checkIfBackEndt(param);
	}

	@Override
	public String batchPost(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("parId", Integer.parseInt(request.getParameter("parId")));
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("issCd", request.getParameter("issCd"));
		param.put("userId", USER.getUserId());
		param.put("backEndt", request.getParameter("backEndt"));
		param.put("credBranchConf", request.getParameter("credBranchConf"));
		param.put("moduleId", request.getParameter("moduleId"));
		param.put("parType", request.getParameter("parType"));
		return this.batchPostingDAO.batchPost(param);
	}


}
