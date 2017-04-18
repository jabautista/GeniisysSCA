package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACCashReceiptsReportDAO {

	// GIACS093
	public String validateGIACS093BranchCd(Map<String, Object> params) throws SQLException;
	public Map<String, Object> populateGiacPdc(Map<String, Object> params) throws SQLException;
	String validateGIACS281BankAcctCd(String bankAcctCd) throws SQLException;
	Map<String, Object> getLastExtractParam(Map<String, Object> params) throws SQLException; //john 10.9.2014
		
	
	// GIACS078
	public Map<String, Object> getGIACS078OInitialValues(Map<String, Object> params) throws SQLException;
	public Map<String, Object> validateIntmNo(Integer intmNo) throws SQLException;
	public Map<String, Object> extractGiacs078Records(Map<String, Object> params) throws SQLException;
	public Integer countGiacs078ExtractedRecords(Map<String, Object> params) throws SQLException;
}
