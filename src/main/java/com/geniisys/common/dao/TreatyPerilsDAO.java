package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface TreatyPerilsDAO {
	void valAddA6401Rec(Map<String, Object> params) throws SQLException;
	void saveA6401(Map<String, Object> params) throws SQLException;
	void valAddTrtyPerilXolRec(Map<String, Object> params) throws SQLException;
	void saveTrtyPerilXol(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getAllPerils(Map<String, Object> params) throws SQLException;
}
