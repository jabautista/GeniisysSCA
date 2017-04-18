package com.geniisys.giis.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISPostingLimitDAO {
	
	String validateCopyUser (Map<String, Object> params) throws SQLException;
	String validateCopyBranch (Map<String, Object> params) throws SQLException;
	String validateLineName (Map<String, Object> params) throws SQLException;
	void savePostingLimits(Map<String, Object> params) throws SQLException;
	void saveCopyToAnotherUser(Map<String, Object> params) throws SQLException;
}
