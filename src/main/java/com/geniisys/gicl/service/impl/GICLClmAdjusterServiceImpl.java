package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmAdjusterDAO;
import com.geniisys.gicl.entity.GICLClmAdjHist;
import com.geniisys.gicl.entity.GICLClmAdjuster;
import com.geniisys.gicl.service.GICLClmAdjusterService;
import com.seer.framework.util.StringFormatter;

public class GICLClmAdjusterServiceImpl implements GICLClmAdjusterService{
	
	GICLClmAdjusterDAO giclClmAdjusterDAO;
	
	/**
	 * @return the giclClmAdjusterDAO
	 */
	public GICLClmAdjusterDAO getGiclClmAdjusterDAO() {
		return giclClmAdjusterDAO;
	}


	/**
	 * @param giclClmAdjusterDAO the giclClmAdjusterDAO to set
	 */
	public void setGiclClmAdjusterDAO(GICLClmAdjusterDAO giclClmAdjusterDAO) {
		this.giclClmAdjusterDAO = giclClmAdjusterDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmAdjusterService#getClmAdjusterListing(java.util.Map)
	 */
	@Override
	public Map<String, Object> getClmAdjusterListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmAdjusterListing");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.escapeHTMLInMap(params)).toString();
		request.setAttribute("adjusterListTableGrid", grid);
		request.setAttribute("object", grid);
		return params;
	}
	
	@Override
	public String checkBeforeDeleteAdj(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
		params = this.giclClmAdjusterDAO.checkBeforeDeleteAdj(params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(params)).toString();
	}


	@Override
	public String saveClmAdjuster(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		JSONObject objParams = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("adjSetRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setRows")), USER.getUserId(), GICLClmAdjuster.class));
		params.put("adjDelRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("delRows")), USER.getUserId(), GICLClmAdjuster.class));
		params.put("histRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("histRows")), USER.getUserId(), GICLClmAdjHist.class));
		return new JSONObject((Map<String, Object>) StringFormatter.escapeHTMLInMap(this.giclClmAdjusterDAO.saveClmAdjuster(params))).toString();
	}


	@Override
	public List<GICLClmAdjuster> getLossExpAdjusterList(Integer claimId)
			throws SQLException {
		return this.getGiclClmAdjusterDAO().getLossExpAdjusterList(claimId);
	}


	@Override
	public List<GICLClmAdjuster> getClmAdjusterList(Integer claimId)
			throws SQLException {
		return this.getGiclClmAdjusterDAO().getClmAdjusterList(claimId);
	}
}
