package com.geniisys.giex.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIEXItmperilGroupedDAO {
	
	Map<String, Object> deletePerilGrpGIEXS007(Map<String, Object> params) throws SQLException;
	Map<String, Object> createPerilGrpGIEXS007(Map<String, Object> params) throws SQLException;
	void saveGIEXItmperilGrouped(Map<String, Object> params) throws SQLException;
	Map<String, Object> updateWitemGrpGIEXS007(Map<String, Object> params) throws SQLException;
	public void deleteOldPErilGrp(Map<String, Object> params) throws SQLException;

}
