package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISLossExpDAO;
import com.geniisys.common.entity.GIISLossExp;
import com.geniisys.common.service.GIISLossExpService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISLossExpServiceImpl implements GIISLossExpService {
	
	private GIISLossExpDAO giisLossExpDAO;

	public GIISLossExpDAO getGiisLossExpDAO() {
		return giisLossExpDAO;
	}

	public void setGiisLossExpDAO(GIISLossExpDAO giisLossExpDAO) {
		this.giisLossExpDAO = giisLossExpDAO;
	}

	@Override
	public JSONObject showGicls104(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGicls104RecList");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("partSw", request.getParameter("partSw"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("lossExpType", request.getParameter("lossExpType"));
		this.giisLossExpDAO.valDeleteRec(params);
	}

	@Override
	public void saveGicls104(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLossExp.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLossExp.class));
		params.put("appUser", userId);
		this.giisLossExpDAO.saveGicls104(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("lossExpType", request.getParameter("lossExpType"));
		this.giisLossExpDAO.valAddRec(params);
	}

	@Override
	public Map<String, Object> valPartSw(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("partVar", "");
		params.put("partExists", "");
		params.put("lpsExists", "");
		
		return this.giisLossExpDAO.valPartSw(params);
	}

	@Override
	public String valLpsSw(HttpServletRequest request) throws SQLException {
		String lossExpCd = request.getParameter("lossExpCd");
		return this.giisLossExpDAO.valLpsSw(lossExpCd);
	}

	@Override
	public Map<String, Object> valCompSw(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("lossExpDesc", request.getParameter("lossExpDesc"));
		params.put("lossExpType", request.getParameter("lossExpType"));
		return this.giisLossExpDAO.valCompSw(params);
	}

	@Override
	public String valLossExpType(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("lossExpType", request.getParameter("lossExpType"));
		return this.giisLossExpDAO.valLossExpType(params);
	}
	
	@Override
	public Map<String, Object> getOrigSurplusAmt(HttpServletRequest request) //Added by Kenneth L. 06.11.2015 SR 3626 @lines 105 - 115
			throws SQLException {			
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("lossExpCd", request.getParameter("lossExpCd"));
		params.put("tag", request.getParameter("tag"));
		return this.giisLossExpDAO.getOrigSurplusAmt(params);
	}
}
