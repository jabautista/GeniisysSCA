package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import atg.taglib.json.util.JSONException;
import atg.taglib.json.util.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.dao.GIACEndOfMonthReportsDAO;
import com.geniisys.giac.service.GIACEndOfMonthReportsService;

public class GIACEndOfMonthReportsServiceImpl implements GIACEndOfMonthReportsService{

	private GIACEndOfMonthReportsDAO giacEndOfMonthReportsDAO;

	/**
	 * @return the giacEndOfMonthReportsDAO
	 */
	public GIACEndOfMonthReportsDAO getGiacEndOfMonthReportsDAO() {
		return giacEndOfMonthReportsDAO;
	}

	/**
	 * @param giacEndOfMonthReportsDAO the giacEndOfMonthReportsDAO to set
	 */
	public void setGiacEndOfMonthReportsDAO(GIACEndOfMonthReportsDAO giacEndOfMonthReportsDAO) {
		this.giacEndOfMonthReportsDAO = giacEndOfMonthReportsDAO;
	}

	@Override
	public void giacs138ExtractRecord(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("fromDate", date.parse(request.getParameter("fromDate")));
		params.put("toDate", date.parse(request.getParameter("toDate")));
		params.put("perBranch", request.getParameter("perBranch"));
		params.put("userId", USER.getUserId());
		getGiacEndOfMonthReportsDAO().giacs138ExtractRecord(params);
	}

	@Override
	public void giacs128ExtractRecord(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat date = new SimpleDateFormat("MM-dd-yyyy");
		params.put("fromDate", date.parse(request.getParameter("fromDate")));
		params.put("toDate", date.parse(request.getParameter("toDate")));
		params.put("perBranch", request.getParameter("perBranch"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", USER.getUserId());
		getGiacEndOfMonthReportsDAO().giacs128ExtractRecord(params);
	}

	@Override
	public String deleteGiacProdExt() throws SQLException {
		return this.getGiacEndOfMonthReportsDAO().deleteGiacProdExt();
	}

	@Override
	public String insertGiacProdExt(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException {
		String message = "";
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", USER.getUserId());
		param.put("fromDate", df.parse(request.getParameter("fromDate")));
		param.put("toDate", df.parse(request.getParameter("toDate")));
		message = this.getGiacEndOfMonthReportsDAO().insertGiacProdExt(param);
		System.out.println(message);
		return message;
	}

	@Override
	public String checkPrevExt(GIISUser USER) throws SQLException, Exception {
		JSONObject result = new JSONObject(this.getGiacEndOfMonthReportsDAO().checkPrevExt(USER));
		return result.toString();
	}
}
