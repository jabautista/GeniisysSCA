/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.dao
	File Name: GIISPrincipalSignatoryDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 24, 2011
	Description: 
*/


package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISPrincipalRes;

public interface GIISPrincipalSignatoryDAO {
//	List<GIISPrincipalSignatory> getPrincipalSignatories(Map<String, Object>params) throws SQLException; 
	GIISPrincipalRes getAssuredPrincipalResInfo(int assdNo)throws SQLException;
	String validatePrincipalORCoSignorId(Map<String, Object>params) throws SQLException;
	String validateCTCNo(String ctcNo) throws SQLException;
	String validateCTCNo2(Map<String, Object> params) throws SQLException;
	void savePrincipalSignatory(Map<String, Object>params) throws SQLException , JSONException;
	GIISAssured getInitialAssdNo() throws SQLException;
	List<Integer> getPrinSignatoryIDList(Integer assdNo) throws SQLException;
}
