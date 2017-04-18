package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISEventModuleDAO {
	
	String getGiiss168SelectedModules(String eventModCd) throws SQLException;
	void saveGiiss168(Map<String, Object> params) throws SQLException;
	String getGiiss168SelectedPassingUsers(Map<String, Object> params) throws SQLException;
	String getGiiss168SelectedReceivingUsers(Map<String, Object> params) throws SQLException;
	void saveGiiss168UserList(Map<String, Object> params) throws SQLException, Exception;
	void valDelGiiss168PassingUsers(Map<String, Object> params) throws SQLException;
}
