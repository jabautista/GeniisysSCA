/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao
	File Name: GIACChkDisbursementDAO.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACChkDisbursement;

public interface GIACChkDisbursementDAO {
	GIACChkDisbursement getGiacs016ChkDisbursement(Integer gaccTranId)throws SQLException;
	
	GIACChkDisbursement getGiacs002ChkDisbursement(Map<String, Object> params) throws SQLException;
	String saveCheckDisbursement(Map<String, Object> allParams) throws SQLException, Exception;
	Map<String, Object> spoilCheck(Map<String, Object> params) throws SQLException, Exception;
	Integer getCheckCount(Integer gaccTranId) throws SQLException;
	String validateCheckNo(Map<String, Object> params) throws SQLException, Exception;
	String validateBankCd(Map<String, Object> params) throws SQLException, Exception;
	List<String> getDBItemNoList(Map<String, Object> params) throws SQLException;
	void giacs052NewFormInstance(Map<String, Object> params) throws SQLException;
	void getGiacs052DefaultCheck(Map<String, Object> params) throws SQLException;
	void giacs052ProcessAfterPrinting(Map<String, Object> params) throws SQLException;
	void giacs052UpdateGiac(Map<String, Object> params) throws SQLException;
	void giacs052SpoilCheck(Map<String, Object> params) throws SQLException;
	void giacs052RestoreCheck(Map<String, Object> params) throws SQLException;
	void giacs052CheckDupOr(Map<String, Object> params) throws SQLException;
	Map<String, Object> setCmDmPrintBtn(Map<String, Object> params) throws SQLException, Exception;
	List<Map<String, Object>> getCmDmTranIdMemoStat(Integer gaccTranId) throws SQLException, Exception; /*ADDED by MarkS 5.24.2016 SR-5484*/
	Map<String, Object> generateCheck(Map<String, Object> params) throws SQLException; 
	void validateSpoilCheck(Map<String, Object> params) throws SQLException;
	void spoilCheckGIACS054(Map<String, Object> params) throws SQLException;
	Integer getCheckSeqNo(Map<String, Object> params) throws SQLException;
	void validateCheckSeqNo(Map<String, Object> params) throws SQLException;
	void processPrintedChecks(Map<String, Object> params) throws SQLException;
	void updatePrintedChecks(Map<String, Object> params) throws SQLException;
	String checkDVPrintColumn(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getCheckBatchListByParam(Map<String, Object> params) throws SQLException;
}
