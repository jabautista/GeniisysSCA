/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.service
	File Name: GICLReplaceService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;

import com.geniisys.common.entity.GIISUser;

public interface GICLReplaceService {
	Map<String, Object> getMcEvalReplaceListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	Map<String, Object> validatePartType(Map<String, Object>params)throws SQLException;
	Map<String, Object> validatePartDesc(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateCompanyType(Map<String, Object>params)throws SQLException;
	Map<String, Object> validateCompanyDesc(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateBaseAmt(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateNoOfUnits(Map<String, Object>params) throws SQLException;
	public Integer countPrevPartListLOV(Map<String, Object> params)throws SQLException; 
	Map<String, Object>checkPartIfExistMaster(Map<String, Object>params) throws SQLException;
	Map<String, Object>copyMasterPart(Map<String, Object>params) throws SQLException;
	public Map<String, Object> getPayeeDetailsMap(Map<String, Object> params)throws SQLException;
	Map<String, Object> checkVatAndDeductibles(Map<String, Object>params)throws SQLException;
	public List<String> getWithVatList(Integer evalMasterId) throws SQLException;
	Map<String, Object>checkUpdateRepDtl(Map<String, Object>params)throws SQLException;
	public String finalCheckVat(Map<String, Object> params) throws SQLException;
	public String finalCheckDed(Map<String, Object> params) throws SQLException;
	void saveReplaceDetail(Map<String, Object>params) throws SQLException;
	void updateItemNo(String userId, Integer evalId)throws SQLException;
	void deleteReplaceDetail(Map<String, Object>params)throws SQLException;
	Map<String, Object> getReplacePayeeListing(HttpServletRequest request, GIISUser USER) throws SQLException, JSONException;
	void applyChangePayee(String strParameters, String userId)throws SQLException, JSONException;
}
