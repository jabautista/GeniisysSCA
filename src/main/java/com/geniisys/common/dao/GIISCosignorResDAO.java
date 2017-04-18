/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.dao
	File Name: GIISCosignorResDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 25, 2011
	Description: 
*/


package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;

public interface GIISCosignorResDAO {
//	List<GIISCosignorRes> getCosignorRes(Map<String, Object>params)throws SQLException;
	List<Integer> getCoSignatoryIDList(Integer assdNo) throws SQLException;
}
