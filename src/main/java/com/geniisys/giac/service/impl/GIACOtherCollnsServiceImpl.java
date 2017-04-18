package com.geniisys.giac.service.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACOtherCollnsDAO;
import com.geniisys.giac.entity.GIACOtherCollns;
import com.geniisys.giac.service.GIACOtherCollnsService;
import com.ibm.disthub2.impl.matching.selector.ParseException;

public class GIACOtherCollnsServiceImpl implements GIACOtherCollnsService{
	
	private GIACOtherCollnsDAO giacOtherCollnsDAO;
	
	public GIACOtherCollnsDAO getGiacOtherCollnsDAO() {
		return giacOtherCollnsDAO;
	}

	public void setGiacOtherCollnsDAO(GIACOtherCollnsDAO giacOtherCollnsDAO) {
		this.giacOtherCollnsDAO = giacOtherCollnsDAO;
	}

	@Override
	public JSONObject getGIACOtherCollns(HttpServletRequest request) throws JSONException, SQLException, IOException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACOtherCollns");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("fundCd", request.getParameter("fundCd"));
		Map<String, Object> otherCollections = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(otherCollections);
		return json;
	}
	
	@Override
	public String setOtherCollnsDtls(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("appUser", userId);
		allParams.put("user", userId);
		allParams.put("gaccTranId", request.getParameter("gaccTranId"));
		allParams.put("fundCd", request.getParameter("fundCd"));
		allParams.put("branchCd", request.getParameter("branchCd"));
		allParams.put("moduleName", "GIACS015");
		allParams.put("orFlag", request.getParameter("orFlag"));
		allParams.put("tranSource", request.getParameter("tranSource"));
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIACOtherCollns.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIACOtherCollns.class));
		return this.getGiacOtherCollnsDAO().setOtherCollnsDtls(allParams);
	}

	@Override
	public String validateOldTranNoGIACS015(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("tranYear", request.getParameter("tranYear"));
		params.put("tranMonth", request.getParameter("tranMonth"));
		params.put("tranSeqNo", request.getParameter("tranSeqNo"));
		return this.getGiacOtherCollnsDAO().validateOldTranNoGIACS015(params);
	}

	@Override
	public String validateOldItemNoGIACS015(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.getGiacOtherCollnsDAO().validateOldItemNoGIACS015(params);
	}

	@Override
	public String validateItemNoGIACS015(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.getGiacOtherCollnsDAO().validateItemNoGIACS015(params);
	}

	@Override
	public String validateDeleteGiacs015(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		return this.getGiacOtherCollnsDAO().validateDeleteGiacs015(params);
	}

	@Override
	public String checkSLCode(HttpServletRequest request) throws SQLException, Exception { //added by John Daniel SR-5056
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("slTypeCd", request.getParameter("slTypeCd"));
		params.put("slCd", request.getParameter("slCd"));
		return giacOtherCollnsDAO.checkSLCode(params);
	}
}
