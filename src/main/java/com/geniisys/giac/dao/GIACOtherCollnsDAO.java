package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACOtherCollnsDAO {
	String setOtherCollnsDtls(Map<String, Object> allParams) throws SQLException;
	public String validateOldTranNoGIACS015(Map<String, Object> params) throws SQLException;
	public String validateOldItemNoGIACS015(Map<String, Object> params) throws SQLException;
	public String validateItemNoGIACS015(Map<String, Object> params) throws SQLException;
	public String validateDeleteGiacs015(Map<String, Object> params) throws SQLException;
	String checkSLCode(Map<String, Object> params) throws SQLException, Exception; //added by John Daniel SR-5056
}
