package com.geniisys.common.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISLostBid;

public interface GIISLostBidService {
	
	/**
	 * Gets the lost bid reason list.
	 * 
	 * @return the lost bid reason list
	 * @throws SQLException 
	 */
	public List<GIISLostBid> getLostBidReasonList(String userId) throws SQLException;
	
	public Integer generateReasonCd() throws SQLException;
	
	public Integer generateReasonCd2() throws SQLException;
	
	//public void saveLostBidReason(GIISLostBid lostBid) throws SQLException;
	public boolean saveLostBidReason(Map<String, Object> allParameters) throws Exception;
	
	public boolean deleteLostBidReason(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> valUpdateRec(HttpServletRequest request) throws SQLException;
	void valDeleteRec(HttpServletRequest request) throws SQLException;
	void saveGiiss204(HttpServletRequest request, String userId) throws SQLException, JSONException;
	void valAddRec(HttpServletRequest request) throws SQLException;
}
