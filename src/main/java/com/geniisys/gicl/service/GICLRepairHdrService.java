/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.service
	File Name: GICLRepairHdrService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.gicl.entity.GICLRepairHdr;

public interface GICLRepairHdrService {
	GICLRepairHdr getRepairDtl(Integer evalId)throws SQLException;
	Map<String, Object> getGicls070LpsRepairDetailsList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	String getTinsmithAmount(Map<String, Object>params)throws SQLException;
	String getPaintingsAmount(String lossExpCd)throws SQLException;
	String validateBeforeSave(Map<String, Object>params) throws SQLException;
	void saveRepairDet(String strParameters, GIISUser USER)throws SQLException,JSONException;
	Map<String, Object>getGiclRepairOtherDtlList(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object>validateBeforeSaveOther(Map<String, Object> params)throws SQLException;
	void saveOtherLabor(String strParameters, GIISUser USER)throws SQLException,JSONException;
}
