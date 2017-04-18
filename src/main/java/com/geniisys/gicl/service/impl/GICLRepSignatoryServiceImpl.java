package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLRepSignatoryDAO;
import com.geniisys.gicl.entity.GICLRepSignatory;
import com.geniisys.gicl.service.GICLRepSignatoryService;
import com.seer.framework.util.StringFormatter;

public class GICLRepSignatoryServiceImpl implements GICLRepSignatoryService {
	
	private GICLRepSignatoryDAO giclRepSignatoryDAO;

	@Override
	public JSONObject showGicls181(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getDocumentsGicls181List");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}
	
	@Override
	public JSONObject showRepSignatory(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getRepSignatoryGicls181List");
		params.put("reportId", request.getParameter("reportId"));
		params.put("reportNo", request.getParameter("reportNo") == null || request.getParameter("reportNo") == "" ? 0 : Integer.parseInt(request.getParameter("reportNo")));

		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}
	
	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("reportId", request.getParameter("reportId"));
		params.put("itemNo", request.getParameter("itemNo") == null || request.getParameter("itemNo") == "" ? 0 : Integer.parseInt(request.getParameter("itemNo")));
		params.put("reportNo", request.getParameter("reportNo") == null || request.getParameter("reportNo") == "" ? 0 : Integer.parseInt(request.getParameter("reportNo")));
		this.giclRepSignatoryDAO.valAddRec(params);
	}

	@Override
	public void saveGicls181(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GICLRepSignatory.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GICLRepSignatory.class));
		params.put("appUser", userId);
		this.giclRepSignatoryDAO.saveGicls181(params);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("reportId") != null){
			String reportId = request.getParameter("reportId");
			this.giclRepSignatoryDAO.valDeleteRec(reportId);
		}
	}

	public GICLRepSignatoryDAO getGiclRepSignatoryDAO() {
		return giclRepSignatoryDAO;
	}

	public void setGiclRepSignatoryDAO(GICLRepSignatoryDAO giclRepSignatoryDAO) {
		this.giclRepSignatoryDAO = giclRepSignatoryDAO;
	}

	

	
}
