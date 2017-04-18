package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.dao.GICLLossExpDsDAO;
import com.geniisys.gicl.service.GICLLossExpDsService;

public class GICLLossExpDsServiceImpl implements GICLLossExpDsService {
	
	private GICLLossExpDsDAO giclLossExpDsDAO;
	
	public void setGiclLossExpDsDAO(GICLLossExpDsDAO giclLossExpDsDAO) {
		this.giclLossExpDsDAO = giclLossExpDsDAO;
	}

	public GICLLossExpDsDAO getGiclLossExpDsDAO() {
		return giclLossExpDsDAO;
	}

	@Override
	public Map<String, Object> checkXOL(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("catastrophicCd", request.getParameter("catastrophicCd"));
		return this.getGiclLossExpDsDAO().checkXOL(params);
	}

	@Override
	public String distributeLossExpHistory(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		params.put("nbtDistDate", df.parse(request.getParameter("nbtDistDate")));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("distRG", request.getParameter("distRG"));
		params.put("distSw", request.getParameter("distSw"));
		return this.getGiclLossExpDsDAO().distributeLossExpHistory(params);
	}

	@Override
	public String redistributeLossExpHistory(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		params.put("userId", USER.getUserId());
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("nbtDistDate", df.parse(request.getParameter("nbtDistDate")));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("payeeType", request.getParameter("payeeType"));
		params.put("distRG", request.getParameter("distRG"));
		params.put("distSw", request.getParameter("distSw"));
		return this.getGiclLossExpDsDAO().redistributeLossExpHistory(params);
		
	}

	@Override
	public String negateLossExpenseHistory(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("clmLossId", request.getParameter("clmLossId"));
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeCd", request.getParameter("payeeCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", USER.getUserId());
		params.put("vXol", request.getParameter("vXol"));
		params.put("vCurrXol", request.getParameter("vCurrXol"));
		params.put("catastrophicCd", request.getParameter("catastrophicCd"));
		return this.getGiclLossExpDsDAO().negateLossExpenseHistory(params);
	}

}
