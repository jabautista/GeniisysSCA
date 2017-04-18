package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;

public interface GIUTS008CopyPolicyDAO {
	String validateLineCd(String lineCd) throws SQLException;
	String validateGIUTS008LineCd(Map<String, Object> params) throws SQLException, Exception;
	String validateOpFlag(HashMap<String, Object> params) throws SQLException;
	Integer validateUserPackIssCd(HashMap<String, Object> params) throws SQLException;
	Integer getPolicyId(HashMap<String, Object> params) throws SQLException;
	String copyMainQuery(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> copyPARPolicyMainQuery(HashMap<String, Object> params)throws SQLException, Exception,JSONException;
	Map<String, Object> copyPolicyEndtToPAR(Map<String, Object> params) throws SQLException, Exception;
}
