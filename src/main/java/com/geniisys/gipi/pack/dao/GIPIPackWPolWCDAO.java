package com.geniisys.gipi.pack.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;

public interface GIPIPackWPolWCDAO {
	void saveGIPIPackWPolWC (List<GIPIWPolicyWarrantyAndClause> setRows,
							 List<GIPIWPolicyWarrantyAndClause> delRows) 
							 throws SQLException, Exception;
	public void saveGIPIPackWPolWC2(Map<String, Object> parameters) throws Exception;
	Map<String,Object> checkExistWPolwcPolWc(Map<String, Object> params) throws SQLException; 
	//void copyPackPolWCGiuts008a(Map<String, Object> params) throws SQLException;
	
}
