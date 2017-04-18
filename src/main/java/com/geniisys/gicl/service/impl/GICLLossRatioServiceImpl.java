package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLLossRatioDAO;
import com.geniisys.gicl.service.GICLLossRatioService;

public class GICLLossRatioServiceImpl implements GICLLossRatioService{

	private GICLLossRatioDAO giclLossRatioDAO;

	public GICLLossRatioDAO getGiclLossRatioDAO() {
		return giclLossRatioDAO;
	}

	public void setGiclLossRatioDAO(GICLLossRatioDAO giclLossRatioDAO) {
		this.giclLossRatioDAO = giclLossRatioDAO;
	}

	@Override
	public String validateAssdNoGicls204(HttpServletRequest request) throws SQLException {
		BigDecimal assdNo = new BigDecimal(request.getParameter("assdNo"));
		return getGiclLossRatioDAO().validateAssdNoGicls204(assdNo);
	}

	@Override
	public String validatePerilCdGicls204(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd")));
		return getGiclLossRatioDAO().validatePerilCdGicls204(params);
	}

	@Override
	public String extractGicls204(HttpServletRequest request, String userId) throws SQLException, ParseException {
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", request.getParameter("assdNo") == "" || request.getParameter("assdNo") == null ? null : Integer.parseInt(request.getParameter("assdNo")));
		params.put("date", request.getParameter("date") == null || request.getParameter("date") == "" ? null : df.parse(request.getParameter("date")));
		params.put("date24th", request.getParameter("date24th"));
		params.put("extractCat", request.getParameter("extractCat"));
		params.put("extractProc", request.getParameter("extractProc"));
		params.put("intmNo", request.getParameter("intmNo") == "" || request.getParameter("intmNo") == null ? null : Integer.parseInt(request.getParameter("intmNo")));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issueOption", request.getParameter("issueOption"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("perilCd", request.getParameter("perilCd") == "" || request.getParameter("perilCd") == null ? null : Integer.parseInt(request.getParameter("perilCd")));
		params.put("prntDate", request.getParameter("prntDate"));
		params.put("prntOption", request.getParameter("prntOption"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("userId", userId);

		JSONObject result = new JSONObject(this.getGiclLossRatioDAO().extractGicls204(params)); 
		return result.toString();
	}

	@Override
	public String getDetailReportDate(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("date", request.getParameter("date"));
		params.put("extractProc", request.getParameter("extractProc"));
		JSONObject result = new JSONObject(this.getGiclLossRatioDAO().getDetailReportDate(params)); 
		return result.toString();
	}

	@Override
	public JSONObject showLossRatioSummary(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getLossRatioSummaryList");
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));
		params.put("prntOption", request.getParameter("prntOption"));
		
		Map<String, Object> lossRatioSummaryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonLossRatioSummaryList = new JSONObject(lossRatioSummaryTableGrid);
		return jsonLossRatioSummaryList;
	}
	
	@Override
	public JSONObject showPremiumsWrittenCurr(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("queryAction"));
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));
		params.put("prntDate", request.getParameter("prntDate"));

		Map<String, Object> premWrittenCurrTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPremWrittenCurrList = new JSONObject(premWrittenCurrTableGrid);
		return jsonPremWrittenCurrList;
	}
	
	@Override
	public JSONObject showPremiumsWrittenPrev(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("queryAction"));
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));
		params.put("prntDate", request.getParameter("prntDate"));

		Map<String, Object> premWrittenPrevTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonPremWrittenPrevList = new JSONObject(premWrittenPrevTableGrid);
		return jsonPremWrittenPrevList;
	}

	@Override
	public JSONObject showOutLoss(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("queryAction"));
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));

		Map<String, Object> outLossTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonOutLossList = new JSONObject(outLossTableGrid);
		return jsonOutLossList;
	}
	
	@Override
	public JSONObject showLossPaid(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("queryAction"));
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));

		Map<String, Object> lossPaidTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonLossPaidList = new JSONObject(lossPaidTableGrid);
		return jsonLossPaidList;
	}
	
	@Override
	public JSONObject showLossRec(HttpServletRequest request) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", request.getParameter("queryAction"));
		params.put("sessionId", Integer.parseInt(request.getParameter("sessionId")));

		Map<String, Object> lossRecTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonLossRecList = new JSONObject(lossRecTableGrid);
		return jsonLossRecList;
	}
}