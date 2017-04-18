package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClmResHist;

public interface GICLClmResHistDAO {
	Map<String, Object> getLossExpenseReserve(Map<String, Object> params) throws SQLException;
	void setPaytHistoryRemarks(List<GICLClmResHist> params) throws SQLException;
	String checkPaytHistory(GICLClmResHist param) throws SQLException;
	void updateClaimResHistRemarks(Map<String, Object> params) throws SQLException;
	
	/**
	 * Get latest claim reserve history
	 * @param params
	 * @return GICLClmResHist Object
	 * @throws SQLException
	 */
	GICLClmResHist getLatestClmResHist(Map<String, Object> params) throws SQLException;
}
