package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLClmResHist;

public interface GICLClmResHistService {

	void getGiclClmResHistGrid(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClmResHistGridByItem(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void getGiclClmResHistGrid3(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> getLossExpenseReserve(HttpServletRequest request, GIISUser USER) throws SQLException;
	void setPaytHistoryRemarks(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	boolean isPaytHistoryExists(GICLClmResHist param) throws SQLException;
	void updateClaimResHistRemarks(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	/**
	 * Get latest claim reserve history
	 * @param request
	 * @param USER
	 * @return GICLClmResHist Object
	 * @throws SQLException
	 */
	GICLClmResHist getLatestClmResHist(HttpServletRequest request, GIISUser USER) throws SQLException; 
	
}
