package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACGeneralDisbReportDAO {

	public String getGIACS273InitialFundCd() throws SQLException;
	public String validateGIACS273DocCd(Map<String, Object> params) throws SQLException;
		
	String getGiacs512CutOffDate(String extractYear) throws SQLException;
	String validateGiacs512BeforeExtract(Map<String, Object> params) throws SQLException;
	String validateGiacs512BeforePrint(Map<String, Object> params) throws SQLException;
	Map<String, Object> cpcExtractPremComm(Map<String, Object> params) throws SQLException;
	Map<String, Object> cpcExtractOsDtl(Map<String, Object> params) throws SQLException;
	Map<String, Object> cpcExtractLossPaid(Map<String, Object> params) throws SQLException;	

	//GIACS149
	String giacs149WhenNewFormInstance(String vUpdate) throws SQLException;
	Integer countTaggedVouchers (String intmNo) throws SQLException;
	Map<String, Object> computeGIACS149Totals(Map<String, Object> params) throws SQLException;
	String updateCommVoucherAmount(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> updateCommVoucherPrintTag(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCvPrefGIACS149(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkCvSeqGIACS149(Map<String, Object> params) throws SQLException;
	String updateVatGIACS149(Map<String, Object> params) throws SQLException;
	Map<String, Object> populateCvSeqGIACS149(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> gpcvGetGIACS149(Integer intmNo) throws SQLException;
	void updateGpcvGIACS169(Map<String, Object> params) throws SQLException;
	void delWorkflowRec(Map<String, Object> params) throws SQLException;
	void gpcvRestore(Map<String, Object> params) throws SQLException;
	String updateUnprintedVoucher(Map<String, Object> params) throws SQLException;
	String updateDocSeqGIACS149(Map<String, Object> params) throws SQLException;
	String getGiacs190SlTypeCd() throws SQLException;
	
	//GIACS158
	String checkViewRecords (Map<String, Object> params) throws SQLException;
	void invalidateBankFile (Map<String, Object> params) throws SQLException;
	void processViewRecords (Map<String, Object> params) throws SQLException;
	String generateBankFile (Map<String, Object> params) throws SQLException;
	Map<String, Object> getDetailsTotalViaRecords (Map<String, Object> params) throws SQLException;
	Map<String, Object> getDetailsTotalViaBankFiles (Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getSummaryForBank(Map<String, Object> params) throws SQLException;
	String getCompanyCode() throws SQLException;
	void updateFileName (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalViaBankFile (Map<String, Object> params) throws SQLException;
	Map<String, Object> getTotalViaRecords (Map<String, Object> params) throws SQLException;
}
