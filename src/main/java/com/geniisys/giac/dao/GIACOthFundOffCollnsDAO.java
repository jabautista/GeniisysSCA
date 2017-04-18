package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACOthFundOffCollns;

public interface GIACOthFundOffCollnsDAO {
	
	List<GIACOthFundOffCollns> getGIACOthFundOffCollns(Integer gaccTranId) throws SQLException;
	List<Map<String,Object>> getTransactionNoListing(String keyword) throws SQLException;
	Map<String, Object> checkOldItem(Map<String, Object> params) throws SQLException;
	Map<String, Object> getDefaultAmount (Map<String, Object> params) throws SQLException;
	Map<String, Object> chkGiacOthFundOffCol(Map<String, Object> params) throws SQLException;
	String saveGIACOthFundOffCollns(List<GIACOthFundOffCollns> setRows, 
									List<GIACOthFundOffCollns> delRows,
									Map<String, Object> params) throws SQLException;
	List<Integer> getItemNoList (int tranId) throws SQLException;
}
