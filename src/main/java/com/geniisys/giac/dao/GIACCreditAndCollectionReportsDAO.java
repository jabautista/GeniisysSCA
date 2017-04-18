package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.giac.entity.GIACSoaRepExt;
import com.geniisys.giac.entity.GIACSoaRepExtParam;

public interface GIACCreditAndCollectionReportsDAO {
	
	GIACSoaRepExtParam getDefualtSOAParams(Map<String, Object> params) throws SQLException, Exception;
	GIACSoaRepExtParam getExtractDate(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> getSOARepDtls(Map<String, Object> params) throws SQLException, Exception;
	String breakdownTaxPayments(Map<String, Object> params) throws SQLException, Exception;
	GIACSoaRepExtParam setDefaultDates(Map<String, Object> params) throws SQLException; // done after extraction.
	String getSOARemarks() throws SQLException;
	
	//String saveCollectionLetterParams(Map<String, Object> allParams) throws SQLException, Exception;
	List<GIACSoaRepExt> saveCollectionLetterParams(Map<String, Object> allParams) throws SQLException, Exception;
	List<GIACSoaRepExt> selectAllRecords(Map<String, Object> params) throws SQLException;
	
	String processIntmOrAssd(Map<String, Object> params) throws SQLException;
	/*List<GIACSoaRepExt> processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception;*/
	String processIntmOrAssd2(Map<String, Object> params) throws SQLException, Exception;
	
	List<GIACSoaRepExt> fetchParameters(Map<String, Object> allParams) throws SQLException;
	String checkUserDate(String userId) throws SQLException;
	
	
	
	//added by kenneth L. for aging of collections 07.02.2013
	String extractAgingOfCollections (String userId) throws SQLException;
	String inserToAgingExt (Map<String, Object> params) throws SQLException;

	String giacs329ValidateDateParams(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractGIACS329(Map<String, Object> params) throws SQLException, Exception;
	void checkExistingReport(String reportId) throws SQLException, Exception;
	String giacs480ValidateDateParams(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractGIACS480(Map<String, Object> params) throws SQLException, Exception;
	
	Map<String, Object> whenNewFormInstanceGIACS329(GIISUser userId) throws SQLException;

	Map<String, Object> getLastExtractParam(Map<String, Object> params) throws SQLException;

	Map<String, Object> whenNewFormInstanceGIACS480(GIISUser userId) throws SQLException;
	
	String checkUserChildRecords(Map<String, Object> params) throws SQLException;
	
	Integer addToCollection(Map<String, Object> params) throws SQLException;
	
	String getCollElement(Integer index) throws SQLException;
	
	void deleteCollElement(Integer index) throws SQLException;
}
