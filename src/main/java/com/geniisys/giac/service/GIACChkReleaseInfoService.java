/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service
	File Name: GIACChkReleaseInfoService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 20, 2012
	Description: 
*/


package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.giac.entity.GIACChkReleaseInfo;

public interface GIACChkReleaseInfoService {
	public GIACChkReleaseInfo getgiacs016ChkReleaseInfo(Integer gaccTranId, Integer itemNo) throws SQLException;
	String saveCheckReleaseInfo(HttpServletRequest request, String userId) throws SQLException;
	GIACChkReleaseInfo getGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException;
	String saveGIACS002ChkReleaseInfo(Map<String, Object> params) throws SQLException, Exception;
}
