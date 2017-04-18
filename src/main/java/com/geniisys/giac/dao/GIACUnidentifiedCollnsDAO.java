/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACUnidentifiedCollns;

public interface GIACUnidentifiedCollnsDAO {
	
	List<Map<String, Object>> getOldItemList(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> searchOldItemList(Map<String, Object> params) throws SQLException;
	public List<GIACUnidentifiedCollns> getUnidentifiedCollnsListing(Map<String, Object> params) throws SQLException;
	public void saveUnidentifiedCollnsDtls(Map<String, Object> parameters) throws Exception;
	public String validateItemNo(Map<String, Object> parameters) throws SQLException;
	public String validateOldTranNo(Map<String, Object> params) throws SQLException;
	public String validateOldItemNo(Map<String, Object> params) throws SQLException;
	public void validateDelRec(Map<String, Object> params) throws SQLException;	//shan 10.30.2013
}
