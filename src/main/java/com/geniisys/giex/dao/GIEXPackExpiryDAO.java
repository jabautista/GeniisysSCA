package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIEXPackExpiryDAO {

	String checkPackPolicyIdGiexs006(Integer packPolicyId) throws SQLException;
	List<Integer> getPackPolicyId(Map<String, Object> params) throws SQLException;
	String checkPackRecordUser(Map<String, Object> params) throws SQLException;
	
}
