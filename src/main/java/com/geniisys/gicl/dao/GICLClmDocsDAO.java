/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLClmDocsDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 9, 2011
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClmDocs;

public interface GICLClmDocsDAO {
	List<GICLClmDocs> getClmDocsList(Map<String, Object>params) throws SQLException;
	void saveGicls181(Map<String, Object> params) throws SQLException;
	void valDeleteRec(Map<String, Object> params) throws SQLException;
}
