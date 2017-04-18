/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLCargoDtlDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 28, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLCargoDtlDAO {
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemMarineCargo(Map<String, Object> params) throws SQLException;
}
