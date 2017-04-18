package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISReportsAgingDAO;
import com.geniisys.common.entity.GIISReportsAging;
import com.geniisys.common.service.GIISReportsAgingService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISReportsAgingServiceImpl implements GIISReportsAgingService {

	private GIISReportsAgingDAO giisReportsAgingDAO;
	
	public GIISReportsAgingDAO getGiisReportsAgingDAO() {
		return giisReportsAgingDAO;
	}

	public void setGiisReportsAgingDAO(GIISReportsAgingDAO giisReportsAgingDAO) {
		this.giisReportsAgingDAO = giisReportsAgingDAO;
	}

	@Override
	public JSONObject showReportAging(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss090RecAgingList");
		params.put("reportId", request.getParameter("reportId"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		System.out.println("returned: "+recList);
		StringFormatter.escapeHTMLInMap(recList);
		System.out.println("escaped: "+recList);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reportId") != null){
			String recId = request.getParameter("reportId");
			this.giisReportsAgingDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss090Aging(HttpServletRequest request, String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISReportsAging.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISReportsAging.class));
		params.put("appUser", userId);
		this.giisReportsAgingDAO.saveGiiss090Aging(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("reportId", request.getParameter("reportId"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("columnNo", Integer.parseInt(request.getParameter("columnNo")));
		this.giisReportsAgingDAO.valAddRec(params);
	}

}
