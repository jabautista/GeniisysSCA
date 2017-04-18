package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISSpoilageReasonDAO;
import com.geniisys.common.entity.GIISSpoilageReason;
import com.geniisys.common.service.GIISSpoilageReasonService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;

public class GIISSpoilageReasonServiceImpl implements GIISSpoilageReasonService{

	private GIISSpoilageReasonDAO giisSpoilageReasonDAO;
	
	
	/**
	 * @return the giisSpoilageReasonDAO
	 */
	public GIISSpoilageReasonDAO getGiisSpoilageReasonDAO() {
		return giisSpoilageReasonDAO;
	}

	/**
	 * @param giisSpoilageReasonDAO the giisSpoilageReasonDAO to set
	 */
	public void setGiisSpoilageReasonDAO(GIISSpoilageReasonDAO giisSpoilageReasonDAO) {
		this.giisSpoilageReasonDAO = giisSpoilageReasonDAO;
	}

	@Override
	public JSONObject showGiiss212(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss212RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(map);
	}
	
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("spoilCd") != null){
			String recId = request.getParameter("spoilCd");
			this.giisSpoilageReasonDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss212(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISSpoilageReason.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISSpoilageReason.class));
		params.put("appUser", userId);
		this.giisSpoilageReasonDAO.saveGiiss212(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("spoilCd") != null){
			String recId = request.getParameter("spoilCd");
			this.giisSpoilageReasonDAO.valAddRec(recId);
		}
	}
}
