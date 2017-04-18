/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao
	File Name: GICLReplaceDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface GICLReplaceDAO {
	Map<String, Object> validatePartType(Map<String, Object>params) throws SQLException;
	Map<String, Object> validatePartDesc(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateCompanyType(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateCompanyDesc(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateBaseAmt(Map<String, Object>params) throws SQLException;
	Map<String, Object> validateNoOfUnits(Map<String, Object>params) throws SQLException;
	Integer countPrevPartListLOV(Map<String, Object>params) throws SQLException;
	Map<String, Object>checkPartIfExistMaster(Map<String, Object>params) throws SQLException;
	Map<String, Object>copyMasterPart(Map<String, Object>params) throws SQLException;
	Map<String, Object>getPayeeDetailsMap(Map<String, Object>params) throws SQLException;
	Map<String, Object> checkVatAndDeductibles(Map<String, Object>params)throws SQLException;
	List<String> getWithVatList(Integer evalMasterId) throws SQLException;
	Map<String, Object>checkUpdateRepDtl(Map<String, Object>params)throws SQLException;
	String finalCheckVat (Map<String, Object> params)throws SQLException;
	String finalCheckDed (Map<String, Object> params)throws SQLException;
	void saveReplaceDetail(Map<String, Object>params) throws SQLException;
	void updateItemNo(String userId, Integer evalId)throws SQLException; 
	void deleteReplaceDetail(Map<String, Object>params)throws SQLException;
	void applyChangePayee(Map<String, Object>params) throws SQLException;
}
