package com.geniisys.gicl.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLReserveDsDAO;
import com.geniisys.gicl.entity.GICLReserveDs;
import com.geniisys.gicl.service.GICLReserveDsService;
import com.seer.framework.util.StringFormatter;

public class GICLReserveDsServiceImpl implements GICLReserveDsService{

	private GICLReserveDsDAO giclReserveDsDAO;
	private Logger log = Logger.getLogger(GICLReserveDsService.class);
	public GICLReserveDsDAO getGiclReserveDsDAO() {
		return giclReserveDsDAO;
	}

	public void setGiclReserveDsDAO(GICLReserveDsDAO giclReserveDsDAO) {
		this.giclReserveDsDAO = giclReserveDsDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLReserveDsService#getGiclReserveDsGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclReserveDsGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		log.info("get reserve ds");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("clmResHistId", request.getParameter("clmResHistId")); 
		params.put("itemNo", request.getParameter("itemNo")); 
		params.put("groupedItemNo", request.getParameter("groupedItemNo"));
		params.put("perilCd", request.getParameter("perilCd")); 
		params.put("histSeqNo", request.getParameter("histSeqNo"));
		params.put("ACTION", "getGiclReserveDsGrid");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("distDetailsTG", grid);
		request.setAttribute("object", grid);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLReserveDsService#getGiclReserveDsGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclReserveDsGrid2(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		log.info("get reserve ds grid 2");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("ACTION", "getGiclReserveDsGrid2");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("reserveDsTG", grid);
		request.setAttribute("object", grid);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLReserveDsService#saveReserveDs(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public String saveReserveDs(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("userId", USER.getUserId());
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("itemNo", request.getParameter("itemNo"));		
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		params.put("clmDistNo", Integer.parseInt(request.getParameter("clmDistNo")));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("distYear", Integer.parseInt(request.getParameter("distYear")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("histSeqNo", Integer.parseInt(request.getParameter("histSeqNo")));
		params.put("shareType", request.getParameter("shareType"));
		params.put("shrPct", new BigDecimal(Double.parseDouble(request.getParameter("shrPct"))));
		params.put("shrLossResAmt", Double.parseDouble(request.getParameter("shrLossResAmt")));
		params.put("shrExpResAmt", Double.parseDouble(request.getParameter("shrExpResAmt")));
		params.put("cpiRecNo", Integer.parseInt(request.getParameter("cpiRecNo")));
		params.put("cpiBranchCd", request.getParameter("cpiBranchCd"));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		
		GICLReserveDs giclReserveDs = GICLReserveDs.makeReserveDs(params);
		
		return this.getGiclReserveDsDAO().saveReserveDs(giclReserveDs);
	}

	@Override
	public String validateXolDeduc(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("shrLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrLossResAmt"))));
		params.put("shrExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrExpResAmt"))));
		params.put("xolDed", new BigDecimal(Double.parseDouble(request.getParameter("xolDed"))));
		params.put("dspXolDed", new BigDecimal(Double.parseDouble(request.getParameter("dspXolDed"))));
		params.put("triggerItem", request.getParameter("triggerItem"));
		System.out.println("validateXolDeduc result: "+params);
		params = this.getGiclReserveDsDAO().validateXolDeduc(params);
		return new JSONObject(params).toString();
	}

	@Override
	public String continueXolDeduc(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("xolDed", new BigDecimal(Double.parseDouble(request.getParameter("xolDed"))));
		params.put("dspXolDed", new BigDecimal(Double.parseDouble(request.getParameter("dspXolDed"))));
		System.out.println("continueXolDeduc result: "+params);
		params = this.getGiclReserveDsDAO().continueXolDeduc(params);
		return new JSONObject(params).toString();
	}

	@Override
	public String checkXOLAmtLimits(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("clmDistNo", Integer.parseInt(request.getParameter("clmDistNo")));
		params.put("cmlResHistId", Integer.parseInt(request.getParameter("cmlResHistId")));
		params.put("nbtCatCd", request.getParameter("nbtCatCd") == "" ? null : Integer.parseInt(request.getParameter("nbtCatCd")));
		params.put("triggerItem", request.getParameter("triggerItem"));
		params.put("expenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("expenseReserve"))));
		params.put("lossReserve", new BigDecimal(Double.parseDouble(request.getParameter("lossReserve"))));
		params.put("groupedItemNo", Integer.parseInt(request.getParameter("groupedItemNo")));
		params.put("shrLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrLossResAmt"))));
		params.put("prevLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("prevLossResAmt"))));
		params.put("xolDed", new BigDecimal(Double.parseDouble(request.getParameter("xolDed"))));
		params.put("dspXolDed", new BigDecimal(Double.parseDouble(request.getParameter("dspXolDed"))));
		params.put("shrExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrExpResAmt"))));
		params.put("prevExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("prevExpResAmt"))));
		params.put("shrPct", new BigDecimal(Double.parseDouble(request.getParameter("shrPct"))));
		params.put("prevShrPct", new BigDecimal(Double.parseDouble(request.getParameter("prevShrPct"))));
		System.out.println("checkXOLAmtLimits result: "+params);
		params = this.getGiclReserveDsDAO().checkXOLAmtLimits(params);
		return new JSONObject(params).toString();
	}

	@Override
	public Map<String, Object> updateShrLossResGICLS024(
			HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("clmDistNo", Integer.parseInt(request.getParameter("clmDistNo")));
		params.put("lossReserve", new BigDecimal(Double.parseDouble(request.getParameter("lossReserve"))));
		params.put("totLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totLossResAmt"))));
		params.put("totExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totExpResAmt"))));
		params.put("shrLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrLossResAmt"))));
		params.put("prevLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("prevLossResAmt"))));
		params.put("annTsiAmt", new BigDecimal(Double.parseDouble(request.getParameter("annTsiAmt"))));
		params.put("distributionDate", request.getParameter("distributionDate"));
		params.put("netRet", request.getParameter("netRet"));
		params.put("c022LossReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022LossReserve"))));
		params.put("c022ExpenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022ExpenseReserve"))));
		params.put("remarks", request.getParameter("remarks"));
		params.put("bookingMonth", request.getParameter("bookingMonth"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		System.out.println("checkXOLAmtLimits result: "+params);
		params = this.getGiclReserveDsDAO().updateShrLossResGICLS024(params);
		return params;
	}

	@Override
	public Map<String, Object> updateShrPctGICLS024(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("clmDistNo", Integer.parseInt(request.getParameter("clmDistNo")));
		params.put("lossReserve", new BigDecimal(Double.parseDouble(request.getParameter("lossReserve"))));
		params.put("totLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totLossResAmt"))));
		params.put("totExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totExpResAmt"))));
		params.put("totShrPct", new BigDecimal(Double.parseDouble(request.getParameter("totShrPct"))));
		params.put("shrPct", new BigDecimal(Double.parseDouble(request.getParameter("shrPct"))));
		params.put("annTsiAmt", new BigDecimal(Double.parseDouble(request.getParameter("annTsiAmt"))));
		params.put("distributionDate", request.getParameter("distributionDate"));
		params.put("netRet", request.getParameter("netRet"));
		params.put("c022LossReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022LossReserve"))));
		params.put("c022ExpenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022ExpenseReserve"))));
		params.put("remarks", request.getParameter("remarks"));
		params.put("bookingMonth", request.getParameter("bookingMonth"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		System.out.println("checkXOLAmtLimits result: "+params);
		params = this.getGiclReserveDsDAO().updateShrPctGICLS024(params);
		return params;
	}

	@Override
	public Map<String, Object> updateShrExpResGICLS024(
			HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", USER.getUserId());
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo")));
		params.put("perilCd", Integer.parseInt(request.getParameter("perilCd")));
		params.put("grpSeqNo", Integer.parseInt(request.getParameter("grpSeqNo")));
		params.put("clmDistNo", Integer.parseInt(request.getParameter("clmDistNo")));
		params.put("expenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("expenseReserve"))));
		params.put("totLossResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totLossResAmt"))));
		params.put("totExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("totExpResAmt"))));
		params.put("shrExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("shrExpResAmt"))));
		params.put("prevExpResAmt", new BigDecimal(Double.parseDouble(request.getParameter("prevExpResAmt"))));
		params.put("annTsiAmt", new BigDecimal(Double.parseDouble(request.getParameter("annTsiAmt"))));
		params.put("distributionDate", request.getParameter("distributionDate"));
		params.put("netRet", request.getParameter("netRet"));
		params.put("c022LossReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022LossReserve"))));
		params.put("c022ExpenseReserve", new BigDecimal(Double.parseDouble(request.getParameter("c022ExpenseReserve"))));
		params.put("remarks", request.getParameter("remarks"));
		params.put("bookingMonth", request.getParameter("bookingMonth"));
		params.put("bookingYear", request.getParameter("bookingYear"));
		System.out.println("checkXOLAmtLimits result: "+params);
		params = this.getGiclReserveDsDAO().updateShrExpResGICLS024(params);
		return params;
	}
}