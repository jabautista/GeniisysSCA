package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLAccidentDtlDAO {
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemAccident(Map<String, Object> params) throws SQLException;
	String getGroupedItemTitle(Map<String, Integer> params) throws SQLException;
	//String getAcBaseAmount(Integer param) throws SQLException;	//changed by kenneth SR20950 11.12.2015
	String getAcBaseAmount(Map<String, Object> params) throws SQLException;
}
