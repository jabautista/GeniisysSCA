package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISNonRenewReasonDAO;
import com.geniisys.common.entity.GIISNonRenewReason;
import com.geniisys.common.service.GIISNonRenewReasonService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISNonRenewReasonServiceImpl implements GIISNonRenewReasonService{
	
	private GIISNonRenewReasonDAO giisNonRenewReasonDAO;

	/**
	 * @param giisNonRenewReasonDAO the giisNonRenewReasonDAO to set
	 */
	public void setGiisNonRenewReasonDAO(GIISNonRenewReasonDAO giisNonRenewReasonDAO) {
		this.giisNonRenewReasonDAO = giisNonRenewReasonDAO;
	}

	/**
	 * @return the giisNonRenewReasonDAO
	 */
	public GIISNonRenewReasonDAO getGiisNonRenewReasonDAO() {
		return giisNonRenewReasonDAO;
	}

	@Override
	public Map<String, Object> validateReasonCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisNonRenewReasonDAO().validateReasonCd(params);
	}
	
	@Override
	public JSONObject showGiiss210(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss210RecList");		
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("nonRenReasonCd") != null){
			String recId = request.getParameter("nonRenReasonCd");
			this.giisNonRenewReasonDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss210(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISNonRenewReason.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISNonRenewReason.class));
		params.put("appUser", userId);
		this.giisNonRenewReasonDAO.saveGiiss210(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("nonRenReasonCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("recId", request.getParameter("nonRenReasonCd"));
			params.put("recDesc", request.getParameter("nonRenReasonDesc"));
			this.giisNonRenewReasonDAO.valAddRec(params);
		}
	}
	
}
