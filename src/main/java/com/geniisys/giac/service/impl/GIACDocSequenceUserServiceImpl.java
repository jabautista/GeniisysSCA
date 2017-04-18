package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDocSequenceUserDAO;
import com.geniisys.giac.entity.GIACDocSequenceUser;
import com.geniisys.giac.service.GIACDocSequenceUserService;

public class GIACDocSequenceUserServiceImpl implements GIACDocSequenceUserService {

	private GIACDocSequenceUserDAO giacDocSequenceUserDAO;

	public GIACDocSequenceUserDAO getGiacDocSequenceUserDAO() {
		return giacDocSequenceUserDAO;
	}

	public void setGiacDocSequenceUserDAO(GIACDocSequenceUserDAO giacDocSequenceUserDAO) {
		this.giacDocSequenceUserDAO = giacDocSequenceUserDAO;
	}

	@Override
	public JSONObject showGiacs316(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs316RecList");
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userCd", request.getParameter("userCd") != null && !request.getParameter("userCd").equals("") ? Integer.parseInt(request.getParameter("userCd")) : null);
		params.put("docPref", request.getParameter("docPref"));
		params.put("minSeqNo", request.getParameter("minSeqNo")); // != null && !request.getParameter("minSeqNo").equals("") ? Integer.parseInt(request.getParameter("minSeqNo")) : null);
		params.put("maxSeqNo", request.getParameter("maxSeqNo")); // != null && !request.getParameter("maxSeqNo").equals("") ? Integer.parseInt(request.getParameter("maxSeqNo")) : null);
		this.giacDocSequenceUserDAO.valDeleteRec(params);
	}

	@Override
	public void saveGiacs316(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACDocSequenceUser.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACDocSequenceUser.class));
		params.put("appUser", userId);
		this.giacDocSequenceUserDAO.saveGiacs316(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userCd", request.getParameter("userCd") != null && !request.getParameter("userCd").equals("") ? Integer.parseInt(request.getParameter("userCd")) : null);
		params.put("docPref", request.getParameter("docPref"));
		params.put("minSeqNo", request.getParameter("minSeqNo")); // != null && !request.getParameter("minSeqNo").equals("") ? Integer.parseInt(request.getParameter("minSeqNo")) : null);
		params.put("maxSeqNo", request.getParameter("maxSeqNo")); // != null && !request.getParameter("maxSeqNo").equals("") ? Integer.parseInt(request.getParameter("maxSeqNo")) : null);
		this.giacDocSequenceUserDAO.valAddRec(params);
	}

	@Override
	public void valMinSeqNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userCd", request.getParameter("userCd") != null && !request.getParameter("userCd").equals("") ? Integer.parseInt(request.getParameter("userCd")) : null);
		params.put("docPref", request.getParameter("docPref"));
		params.put("minSeqNo", request.getParameter("minSeqNo")); // != null && !request.getParameter("minSeqNo").equals("") ? Integer.parseInt(request.getParameter("minSeqNo")) : null);
		params.put("maxSeqNo", request.getParameter("maxSeqNo"));
		params.put("oldMinSeqNo", request.getParameter("oldMinSeqNo"));
		this.giacDocSequenceUserDAO.valMinSeqNo(params);
	}

	@Override
	public void valMaxSeqNo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userCd", request.getParameter("userCd") != null && !request.getParameter("userCd").equals("") ? Integer.parseInt(request.getParameter("userCd")) : null);
		params.put("docPref", request.getParameter("docPref"));
		params.put("minSeqNo", request.getParameter("minSeqNo")); // != null && !request.getParameter("minSeqNo").equals("") ? Integer.parseInt(request.getParameter("minSeqNo")) : null);
		params.put("maxSeqNo", request.getParameter("maxSeqNo")); // != null && !request.getParameter("maxSeqNo").equals("") ? Integer.parseInt(request.getParameter("maxSeqNo")) : null);
		params.put("oldMaxSeqNo", request.getParameter("oldMaxSeqNo"));
		this.giacDocSequenceUserDAO.valMaxSeqNo(params);
	}

	@Override
	public void valActiveTag(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("docCode", request.getParameter("docCode"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("userCd", request.getParameter("userCd") != null && !request.getParameter("userCd").equals("") ? Integer.parseInt(request.getParameter("userCd")) : null);
		params.put("docPref", request.getParameter("docPref"));
		params.put("minSeqNo", request.getParameter("minSeqNo")); // != null && !request.getParameter("minSeqNo").equals("") ? Integer.parseInt(request.getParameter("minSeqNo")) : null);
		params.put("maxSeqNo", request.getParameter("maxSeqNo")); // != null && !request.getParameter("maxSeqNo").equals("") ? Integer.parseInt(request.getParameter("maxSeqNo")) : null);
		params.put("oldMinSeqNo", request.getParameter("oldMinSeqNo"));
		params.put("oldMaxSeqNo", request.getParameter("oldMaxSeqNo"));
		params.put("opt", request.getParameter("option"));
		this.giacDocSequenceUserDAO.valActiveTag(params);
	}

}
