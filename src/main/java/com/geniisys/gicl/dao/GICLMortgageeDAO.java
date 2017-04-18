package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLMortgageeDAO {

	void setClmItemMortgagee(Map<String, Object> params) throws SQLException;
	String checkIfGiclMortgageeExist(Map<String, Object> params) throws SQLException;
}
