package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClmAdjHistDAO;
import com.geniisys.gicl.service.GICLClmAdjHistService;
import com.seer.framework.util.StringFormatter;

public class GICLClmAdjHistServiceImpl implements GICLClmAdjHistService{

	private GICLClmAdjHistDAO giclClmAdjHistDAO;

	public GICLClmAdjHistDAO getGiclClmAdjHistDAO() {
		return giclClmAdjHistDAO;
	}

	public void setGiclClmAdjHistDAO(GICLClmAdjHistDAO giclClmAdjHistDAO) {
		this.giclClmAdjHistDAO = giclClmAdjHistDAO;
	}

	@Override
	public String getGiclClmAdjHistExist(String claimId) throws SQLException {
		return this.giclClmAdjHistDAO.getGiclClmAdjHistExist(claimId);
	}

	@Override
	public String getDateCancelled(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
		return this.giclClmAdjHistDAO.getDateCancelled(params);
	}

	@Override
	public void getClmAdjHistListGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmAdjHistListGrid");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("pageSize", 1);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("adjHistListGrid", grid);
		request.setAttribute("object", grid);
	}
	
	@Override
	public void getClmAdjHistListGrid2(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getClmAdjHistListGrid2");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("adjCompanyCd", request.getParameter("adjCompanyCd"));
		params.put("privAdjCd", request.getParameter("privAdjCd"));
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("adjHistSubListGrid", grid);
		request.setAttribute("object", grid);
	}
}
