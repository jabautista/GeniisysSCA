package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.giac.entity.GIACPaytReqDocs;
import com.geniisys.giac.entity.GIACPaytRequests;

public interface GIACPaytRequestsDAO {

	Object getGiacPaytRequests(Map<String, Object> params) throws SQLException;
	void saveDisbursmentRequest(Map<String, Object> params) throws SQLException;
	
	/**
	 * @getClosedTag
	 * @GIACS016
	 * @author Irwin Tabisora
	 * */
	String getClosedTag(Map<String, Object>params )throws SQLException;
	Map<String, Object> getFundBranchDesc(Map<String, Object>params) throws SQLException;
	void valAmtBeforeClosing(Map<String, Object> params) throws SQLException;
	Map<String, Object> populateChkTags(Map<String, Object>params) throws SQLException;
	void closeRequest(Map<String, Object> params) throws SQLException;
	void cancelPaymentRequest(Map<String, Object>params) throws SQLException;
	
	List<GIISLine> getPaymentLinesList(Map<String, Object> params) throws SQLException;
	List<GIACPaytRequests> getPaymentDocYear(Map<String, Object> params) throws SQLException;
	List<GIACPaytRequests> getPaymentDocMm(Map<String, Object> params) throws SQLException;
	GIACPaytRequests validateDocSeqNo(Map<String, Object> params) throws SQLException;
	void validatePaytLineCd(Map<String, Object> params) throws SQLException;
	void validatePaytDocYear(Map<String, Object> params) throws SQLException;
	void validatePaytDocMm(Map<String, Object> params) throws SQLException;
	void getGIACS016PaytReqOtherDetails(Map<String, Object> params) throws SQLException;
	List<GIACPaytReqDocs> getGIACPaytReqDocsList(Map<String, Object>params) throws SQLException;
	void extractCommFund(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkCommFundSlip(Map<String, Object> params) throws SQLException;
	void processAfterPrinting(Map<String, Object> params) throws SQLException;//added by reymon 06182013
	
}
