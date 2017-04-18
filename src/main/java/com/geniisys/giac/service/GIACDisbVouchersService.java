/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.service
	File Name: GIACDisbVouchersService.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACDisbVouchers;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;

public interface GIACDisbVouchersService {
	
	GIACDisbVouchers getGiacs016GiacDisb(Integer gprqRefId) throws SQLException;	
	// for GIACS002
	GIACDisbVouchers getDisbVoucherInfo(Map<String, Object> params) throws SQLException, Exception;
	GIACDisbVouchers getDefaultVoucher(Map<String, Object> params) throws SQLException;
	public Map<String, Object> checkFundBranchFK(Map<String, Object> params) throws SQLException;
	String getPrintTagMean(String printTag) throws SQLException;
	Map<String, Object> validateAcctEntriesBeforeApproving(Map<String, Object> params) throws SQLException;
	Map<String, Object> approveValidatedDV(Map<String, Object> params) throws SQLException, Exception;
	GIACPaytReqDocs getPaytReqNumberingScheme(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> saveVocuher(Map<String, Object> params) throws SQLException, Exception;
	
	void validateGIACS002DocCd(Map<String, Object> params) throws SQLException;
	String checkIfOfppr(Integer gaccTranId) throws SQLException;
	Map<String, Object> verifyOfpprTrans(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkCollectionDtl(Map<String, Object> params) throws SQLException, Exception;
	void preCancelDV(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> cancelDV(Map<String, Object> params) throws SQLException, Exception;
	String validateIfReleasedCheck(Map<String, Object> params) throws SQLException;
	Integer getTranSeqNo(Integer gaccTranId) throws SQLException;
	String validateAcctgEntriesBeforePrint(Integer gaccTranId) throws SQLException, Exception;
	void deleteWorkflowRecords(Map<String, Object> params) throws SQLException;
	
	String getDefaultBranchCd(String userId) throws SQLException;
	List<GIACPaytRequests> getDocSeqNoList(Map<String, Object> params) throws SQLException;
}
