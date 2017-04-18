package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACBatchCheckDAO;
import com.geniisys.giac.service.GIACBatchCheckService;
import com.seer.framework.util.StringFormatter;

public class GIACBatchCheckServiceImpl implements GIACBatchCheckService {
	private Logger log = Logger.getLogger(GIACBatchCheckServiceImpl.class);
	
	private GIACBatchCheckDAO giacBatchCheckDAO;
	
	public GIACBatchCheckDAO getBatchCheckDAO() {
		return giacBatchCheckDAO;
	}
	
	public void setGiacBatchCheckDAO(GIACBatchCheckDAO giacBatchCheckDAO) {
		this.giacBatchCheckDAO = giacBatchCheckDAO;
	}

	@Override
	public Map<String, Object> getPrevExtractParams(HttpServletRequest request,GIISUser USER) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getPrevExtractParams");
		params.put("batchType", request.getParameter("batchType"));
		params.put("appUser", USER.getUserId());
		params = this.giacBatchCheckDAO.getPrevExtractParams(params);
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}

	@Override
	public JSONObject getMainTable (HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		if (request.getParameter("table").equals("gross")) {
			log.info("Getting Gross Records...");
			params.put("ACTION", "getGross");
		}else if (request.getParameter("table").equals("facul")) {
			log.info("Getting Facul Records...");
			params.put("ACTION", "getFacul");
		}else if (request.getParameter("table").equals("treaty")) {
			log.info("Getting Treaty Records...");
			params.put("ACTION", "getTreaty");
		}else if(request.getParameter("table").equals("outstanding")){
			params.put("ACTION", "getOutstandingTab");
		}else if(request.getParameter("table").equals("paid")){
			params.put("ACTION", "getPaidTab");
		}
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("dateTag", request.getParameter("dateTag"));
		params.put("userId", userId);
		Map<String, Object> mainTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject mainJson = new JSONObject(mainTbg);
		request.setAttribute("main", mainJson);
		return mainJson;
	}

	@Override
	public JSONObject getDetail(HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		if (request.getParameter("table").equals("gross")) {
			log.info("Getting Gross Detail Records...");
			params.put("ACTION", "getGrossDtl");
		}else if (request.getParameter("table").equals("facul")) {
			log.info("Getting Facul Detail Records...");
			params.put("ACTION", "getFaculDtl");
		}else if (request.getParameter("table").equals("treaty")) {
			log.info("Getting Treaty Detail Records...");
			params.put("ACTION", "getTreatyDtl");
		}else if(request.getParameter("table").equals("outstanding")){ //marco - 03.02.2015 - added additional tabs
			params.put("ACTION", "getOutstandingDtl");
		}else if(request.getParameter("table").equals("paid")){
			params.put("ACTION", "getPaidDtl");
		}
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("baseAmt", request.getParameter("baseAmt")); //marco - 03.02.2015
		params.put("userId", userId);
		Map<String, Object> dtlTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject dtlJson = new JSONObject(dtlTbg);
		request.setAttribute("dtl", dtlJson);
		return dtlJson;
	}
	
	@Override
	public JSONObject getNet(HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("Getting Net Premiums Records...");
		params.put("ACTION", "getNet");
		params.put("userId", userId);
		Map<String, Object> netTbg = TableGridUtil.getTableGrid(request, params);
		JSONObject netJson = new JSONObject(netTbg);
		request.setAttribute("net", netJson);
		return netJson;
	}

	@Override
	public String extractBatchChecking(HttpServletRequest request, GIISUser USER) throws SQLException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("dateTag", request.getParameter("dateTag"));
		params.put("batchType", request.getParameter("batchType"));
		params.put("tab", request.getParameter("tab"));
		params.put("userId", USER.getUserId());
		params.put("appUser", USER.getUserId());
		message = this.giacBatchCheckDAO.extractBatchChecking(params);
		System.out.println(params);
		System.out.println(message);
		return message;
	}

	@Override
	public Map<String, Object> getTotalNet(HttpServletRequest request) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getTotalNet");
		params = this.giacBatchCheckDAO.getTotalNet(params);
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}

	@Override
	public Map<String, Object> getTotal(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("dateTag", request.getParameter("dateTag"));
		params.put("userId", userId);
		if (request.getParameter("table").equals("gross")) {
			log.info("Getting Gross Total...");
			params.put("ACTION", "getTotalGross");
			params = this.giacBatchCheckDAO.getTotalGross(params);
		}else if (request.getParameter("table").equals("facul")) {
			log.info("Getting Facul Total...");
			params.put("ACTION", "getTotalFacul");
			params = this.giacBatchCheckDAO.getTotalFacul(params);
		}else if (request.getParameter("table").equals("treaty")) {
			log.info("Getting Treaty Total...");
			params.put("ACTION", "getTotalTreaty");
			params = this.giacBatchCheckDAO.getTotalTreaty(params);
		}else if(request.getParameter("table").equals("outstanding")){
			params = this.giacBatchCheckDAO.getTotalOutstanding(params);
		}else if(request.getParameter("table").equals("paid")){
			params = this.giacBatchCheckDAO.getTotalPaid(params);
		}
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}

	@Override
	public Map<String, Object> getTotalDetail(HttpServletRequest request, String userId) throws SQLException, JSONException, ParseException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		if (request.getParameter("table").equals("gross")) {
			log.info("Getting Gross Total...");
			params.put("ACTION", "getTotalGrossDtl");
			params = this.giacBatchCheckDAO.getTotalGrossDtl(params);
		}else if (request.getParameter("table").equals("facul")) {
			log.info("Getting Facul Total...");
			params.put("ACTION", "getTotalFaculDtl");
			params = this.giacBatchCheckDAO.getTotalFaculDtl(params);
		}else if (request.getParameter("table").equals("treaty")) {
			log.info("Getting Treaty Total...");
			params.put("ACTION", "getTotalTreatyDtl");
			params = this.giacBatchCheckDAO.getTotalTreatyDtl(params);
		}else if(request.getParameter("table").equals("outstanding")){
			params = this.giacBatchCheckDAO.getTotalOutstandingDtl(params);
		}else if(request.getParameter("table").equals("paid")){
			params = this.giacBatchCheckDAO.getTotalPaidDtl(params);
		}
		List<?> list = (List<?>) StringFormatter.escapeHTMLInList(params.get("list"));
		params.put("rec", new JSONArray(list));
		return params;
	}

	@Override
	public void checkRecords(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("batchType", request.getParameter("batchType"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("userId", userId);
		this.getBatchCheckDAO().checkRecords(params);
	}

	@Override
	public void checkDetails(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("baseAmt", request.getParameter("baseAmt"));
		params.put("table", request.getParameter("table"));
		params.put("userId", userId);
		this.getBatchCheckDAO().checkDetails(params);
	}
}
