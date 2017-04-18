/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao
	File Name: GIACChkReleaseInfo.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 20, 2012
	Description: 
*/


package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

import com.geniisys.giac.entity.GIACChkReleaseInfo;

public interface GIACChkReleaseInfoDAO {
	GIACChkReleaseInfo getgiacs016ChkReleaseInfo(Integer gaccTranId, Integer itemNo) throws SQLException;
	String saveCheckReleaseInfo(Map<String, Object> params) throws SQLException;
	
	GIACChkReleaseInfo getGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException;
	String saveGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException, Exception;
}
