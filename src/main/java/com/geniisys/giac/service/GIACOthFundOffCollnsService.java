package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

import com.geniisys.framework.util.PaginatedList;
import com.geniisys.giac.entity.GIACOthFundOffCollns;

public interface GIACOthFundOffCollnsService {
	
	List<GIACOthFundOffCollns> getGIACOthFundOffCollns(Integer gaccTranId) throws SQLException;
	PaginatedList getTransactionNoListing(String keyword, Integer pageNo) throws SQLException;
	Map<String, Object> checkOldItemNo (Map<String, Object> params) throws SQLException;
	Map<String, Object> getDefaultAmount (Map<String, Object> params) throws SQLException;
	Map<String, Object> chkGiacOthFundOffCol(Map<String, Object> params) throws SQLException;
	String saveGIACOthFundOffCollns(JSONArray setRows, JSONArray delRows, Map<String, Object> params)
									throws SQLException, JSONException;
	List<Integer> getItemNoList(int tranId) throws SQLException;
}
