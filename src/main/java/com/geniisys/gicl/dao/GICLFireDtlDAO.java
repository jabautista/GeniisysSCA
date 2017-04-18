package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLFireDtlDAO {

	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemFire(Map<String, Object> params) throws SQLException;
	String getGiclFireDtlExist(String claimId) throws SQLException;
}
