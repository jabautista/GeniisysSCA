/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLAviationDtlDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Oct 7, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GICLAviationDtlDAO {
	Map<String, Object> validateClmItemNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> saveClmItemAviation(Map<String, Object> params) throws SQLException;
}
