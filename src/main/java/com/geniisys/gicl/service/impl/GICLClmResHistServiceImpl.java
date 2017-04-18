package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
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
import com.geniisys.gicl.dao.GICLClmResHistDAO;
import com.geniisys.gicl.entity.GICLClmResHist;
import com.geniisys.gicl.service.GICLClmResHistService;
import com.seer.framework.util.StringFormatter;

public class GICLClmResHistServiceImpl implements GICLClmResHistService{

	private GICLClmResHistDAO giclClmResHistDAO;

	private static Logger log = Logger.getLogger(GICLClmResHistServiceImpl.class);
	
	public GICLClmResHistDAO getGiclClmResHistDAO() {
		return giclClmResHistDAO;
	}

	public void setGiclClmResHistDAO(GICLClmResHistDAO giclClmResHistDAO) {
		this.giclClmResHistDAO = giclClmResHistDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#getGiclClmResHistGrid(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmResHistGrid(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("ACTION", "getGiclClmResHistGrid");
		params.put("pageSize", 3);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("reserveDetailsTG", grid);
		request.setAttribute("object", grid);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#getLossExpenseReserve(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public Map<String, Object> getLossExpenseReserve(
			HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId") == null || "".equals(request.getParameter("claimId"))? "0" : request.getParameter("claimId")));
		params.put("itemNo", Integer.parseInt(request.getParameter("itemNo") == null || "".equals(request.getParameter("itemNo"))? "0" : request.getParameter("itemNo")));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		return this.getGiclClmResHistDAO().getLossExpenseReserve(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#getGiclClmResHistGrid3(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmResHistGridByItem(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("ACTION", "getGiclClmResHistGridByItem");
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclClaimReserveHistTG", grid);
		request.setAttribute("object", grid);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#getGiclClmResHistGridByItem(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void getGiclClmResHistGrid3(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		log.info("getGiclClmResHistGrid(claimId=" + request.getParameter("claimId") + 
							",itemNo=" + request.getParameter("itemNo") +
							",perilCd=" + request.getParameter("perilCd") + ")");
		Map<String, Object> params = new HashMap<String, Object>();
		
		params.put("claimId", request.getParameter("claimId"));
		params.put("itemNo", request.getParameter("itemNo"));
		params.put("perilCd", request.getParameter("perilCd"));
		params.put("ACTION", "getGiclClmResHistGrid3");
		params.put("pageSize", 5);
		params = TableGridUtil.getTableGrid(request, params);
		String grid = new JSONObject((HashMap<String, Object>) StringFormatter.replaceQuotesInMap(params)).toString();
		request.setAttribute("giclClaimReserveHistTG", grid);
		request.setAttribute("object", grid);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#setPaytHistoryRemarks(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void setPaytHistoryRemarks(HttpServletRequest request, GIISUser USER)
			throws SQLException, JSONException {
		log.info("Preparing records for update...");
		JSONObject paramsObj = new JSONObject(request.getParameter("parameters"));
		List<GICLClmResHist> paytHistRecordList = new ArrayList<GICLClmResHist>();
		JSONArray params = new JSONArray(paramsObj.getString("parameters"));
		log.info("Record/s to be updated:");
		for (int i = 0; i < params.length(); i++) {
			paytHistRecordList.add(new GICLClmResHist(params.getJSONObject(i).getInt("claimId"),
					params.getJSONObject(i).getInt("clmResHistId"), params.getJSONObject(i).getString("remarks"), USER.getUserId()));
			log.info(params.getJSONObject(i));
		}
		this.giclClmResHistDAO.setPaytHistoryRemarks(paytHistRecordList);
	}

	@Override
	public boolean isPaytHistoryExists(GICLClmResHist param)
			throws SQLException {
		if ("Y".equals(this.giclClmResHistDAO.checkPaytHistory(param))){
			return true;
		}
		return false;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#updateClaimResHistRemarks(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public void updateClaimResHistRemarks(HttpServletRequest request,
			GIISUser USER) throws SQLException, JSONException {
		log.info("updating claim res hist remarks(claimId=" +request.getParameter("claimId") + 
				", clmResHistId=" + request.getParameter("clmResHistId") + ")");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", Integer.parseInt(request.getParameter("claimId")));
		params.put("remarks", request.getParameter("remarks"));
		System.out.println("remarks = " + request.getParameter("remarks"));
		params.put("clmResHistId", Integer.parseInt(request.getParameter("clmResHistId")));
		this.getGiclClmResHistDAO().updateClaimResHistRemarks(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.service.GICLClmResHistService#getLatestClmResHist(javax.servlet.http.HttpServletRequest, com.geniisys.common.entity.GIISUser)
	 */
	@Override
	public GICLClmResHist getLatestClmResHist(HttpServletRequest request,
			GIISUser USER) throws SQLException {
		log.info("get last clm res hist");
		Integer claimId = Integer.parseInt(request.getParameter("claimId"));
		Integer itemNo = Integer.parseInt(request.getParameter("itemNo"));
		Integer perilCd = Integer.parseInt(request.getParameter("perilCd"));
		
		System.out.println("claimId = " + claimId);
		System.out.println("itemNo = " + itemNo);
		System.out.println("perilCd = " + perilCd);
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("claimId", claimId);
		params.put("itemNo", itemNo);
		params.put("perilCd", perilCd);
		
		GICLClmResHist clmResHist = this.giclClmResHistDAO.getLatestClmResHist(params);
		
		if(clmResHist == null){
			System.out.println("phenome null null");
		}else{
			System.out.println("naturalral~");
			System.out.println(clmResHist.getBookingMonth() + " - " + clmResHist.getBookingYear());
		}
		
		return clmResHist;
	}
}