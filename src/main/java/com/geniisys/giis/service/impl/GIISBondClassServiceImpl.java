package com.geniisys.giis.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISBondClass;
import com.geniisys.common.entity.GIISBondClassRt;
import com.geniisys.common.entity.GIISBondClassSubline;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giis.dao.GIISBondClassDAO;
import com.geniisys.giis.service.GIISBondClassService;
import com.seer.framework.util.StringFormatter;

public class GIISBondClassServiceImpl implements GIISBondClassService{

private GIISBondClassDAO giisBondClassDAO;
	
	public GIISBondClassDAO getGissBondClassDAO() {
		return giisBondClassDAO;
	}

	public void setGiisBondClassDAO(GIISBondClassDAO giisBondClassDAO) {
		this.giisBondClassDAO = giisBondClassDAO;
	}

	@Override
	public JSONObject getGiiss043BondClass(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss043BondClass");
		params.put("pageSize", 5);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	@Override
	public void saveGiiss043(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		System.out.println("Service - saveGiiss043");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISBondClass.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISBondClass.class));
		params.put("setRowsSubline", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRowsSubline")), userId, GIISBondClassSubline.class));
		params.put("delRowsSubline", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsSubline")), userId, GIISBondClassSubline.class));
		params.put("setRowsRt", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRowsRt")), userId, GIISBondClassRt.class));
		params.put("delRowsRt", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRowsRt")), userId, GIISBondClassRt.class));
		params.put("appUser", userId);
		this.giisBondClassDAO.saveGiiss043(params);		
	}

	@Override
	public void giiss043ValAddBondClass(HttpServletRequest request) throws SQLException {
		String classNo = request.getParameter("classNo");
		giisBondClassDAO.giiss043ValAddBondClass(classNo);
	}
	
	@Override
	public void giiss043ValDelBondClass(HttpServletRequest request) throws SQLException {
		String classNo = request.getParameter("classNo");
		giisBondClassDAO.giiss043ValDelBondClass(classNo);
	}

	@Override
	public JSONObject getGiiss043BondClassSubline(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss043BondClassSubline");
		params.put("classNo", request.getParameter("classNo"));
		params.put("pageSize", 5);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	@Override
	public void giiss043ValAddBondClassSubline(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("clauseType", request.getParameter("clauseType"));
		params.put("classNo", request.getParameter("classNo"));
		giisBondClassDAO.giiss043ValAddBondClassSubline(params);
	}

	@Override
	public void giiss043ValDelBondClassSubline(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("clauseType", request.getParameter("clauseType"));
		giisBondClassDAO.giiss043ValDelBondClassSubline(params);
	}

	@Override
	public JSONObject getGiiss043BondClassRt(HttpServletRequest request)
			throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss043BondClassRt");
		params.put("classNo", request.getParameter("classNo"));
		params.put("pageSize", 5);
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);		
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	@Override
	public void giiss043ValAddBondClassRt(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("rangeLow", request.getParameter("rangeLow"));
		params.put("rangeHigh", request.getParameter("rangeHigh"));
		params.put("classNo", request.getParameter("classNo"));
		giisBondClassDAO.giiss043ValAddBondClassRt(params);
	}
}
