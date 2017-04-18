package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIPIReassignParEndtDAO {

	String checkUser(Map<String, Object> params) throws SQLException;

	List<Map<String, Object>> saveReassignParEndt(Map<String, Object> params)throws SQLException;

}
