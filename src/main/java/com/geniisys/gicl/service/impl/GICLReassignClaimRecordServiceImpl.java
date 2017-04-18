package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReassignClaimRecordDAO;
import com.geniisys.gicl.entity.GICLClaims;
import com.geniisys.gicl.service.GICLReassignClaimRecordService;

public class GICLReassignClaimRecordServiceImpl implements GICLReassignClaimRecordService {

	private GICLReassignClaimRecordDAO giclReassignClaimRecordDAO;

	public GICLReassignClaimRecordDAO getGiclReassignClaimRecordDAO() {
		return giclReassignClaimRecordDAO;
	}
	
	public void setGiclReassignClaimRecordDAO(GICLReassignClaimRecordDAO giclReassignClaimRecordDAO) {
		this.giclReassignClaimRecordDAO = giclReassignClaimRecordDAO;
	}
	
	@Override
	public JSONObject getClaimDetail(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "showReassignClaimRecord");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("allUserSw", USER.getAllUserSw());
		params.put("userId", USER.getUserId());
		System.out.println(USER.getAllUserSw().toString());
		Map<String, Object> reassignTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonReassign = new JSONObject(reassignTableGrid);
		request.setAttribute("jsonReassign", jsonReassign);
		return jsonReassign;
	}

	@Override
	public String updateClaimRecord(HttpServletRequest request, String USER)
			throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER);
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER, GICLClaims.class));
		System.out.println(new JSONArray(objParameters.getString("setRows")));
		return this.getGiclReassignClaimRecordDAO().updateClaimRecord(params);
	}

	@Override
	public String checkIfCanReassignClaim(GIISUser USER) throws JSONException, SQLException, ParseException {
		System.out.println(USER.getUserId());
		return this.getGiclReassignClaimRecordDAO().checkIfCanReassignClaim(USER.getUserId());
	}

	

}
