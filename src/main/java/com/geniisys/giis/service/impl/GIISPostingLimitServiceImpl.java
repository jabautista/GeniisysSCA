package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISPostingLimitDAO;
import com.geniisys.giis.entity.GIISPostingLimit;
import com.geniisys.giis.service.GIISPostingLimitService;
import com.seer.framework.util.StringFormatter;

public class GIISPostingLimitServiceImpl implements GIISPostingLimitService{

	private GIISPostingLimitDAO giisPostingLimitDAO;
	
	public GIISPostingLimitDAO getGiisPostingLimitDAO() {
		return giisPostingLimitDAO;
	}

	public void setGiisPostingLimitDAO(GIISPostingLimitDAO giisPostingLimitDAO) {
		this.giisPostingLimitDAO = giisPostingLimitDAO;
	}
	
	@Override
	public String validateCopyUser(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateCopyUser");
		params.put("userId", request.getParameter("userId"));
		return this.giisPostingLimitDAO.validateCopyUser(params);
	}
	
	@Override
	public String validateCopyBranch(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateCopyBranch");
		params.put("issCd", request.getParameter("issCd"));
		return this.giisPostingLimitDAO.validateCopyBranch(params);
	}
	
	@Override
	public String validateLineName(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "validateLineName");
		params.put("lineName", request.getParameter("lineName"));
		params.put("userId", request.getParameter("userId"));
		params.put("issCd", request.getParameter("issCd"));
		return this.giisPostingLimitDAO.validateLineName(params);
	}
	
	@Override
	public JSONObject getPostingLimits(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPostingLimits");
		params.put("postingUser", request.getParameter("postingUser"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("appUser", USER.getUserId());
		Map<String, Object> postingLimits = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(StringFormatter.escapeHTMLInMap(postingLimits));
		request.setAttribute("postingLimits", json);
		return json;
	}

	@Override
	public void savePostingLimits(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISPostingLimit.class));
		params.put("delEvents", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISPostingLimit.class));
		this.giisPostingLimitDAO.savePostingLimits(params);
	}

	@Override
	public void saveCopyToAnotherUser(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", userId);
		params.put("copyToUser", request.getParameter("copyToUser"));
		params.put("copyToBranch", request.getParameter("copyToBranch"));
		params.put("copyFromUser", request.getParameter("copyFromUser"));
		params.put("copyFromBranch", request.getParameter("copyFromBranch"));
		params.put("populateAllSw", request.getParameter("populateAllSw"));
		this.giisPostingLimitDAO.saveCopyToAnotherUser(params);
	}
}
