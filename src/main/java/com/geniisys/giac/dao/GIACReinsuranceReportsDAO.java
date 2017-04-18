package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIACReinsuranceReportsDAO {

	//GIACS171
	Map<String, Object> getDates(String userId) throws SQLException;
	String extractToTable(Map<String, Object> params) throws SQLException;
	String giacs181ValidateBeforeExtract(Map<String, Object> params) throws SQLException;
	String giacs182ValidateDateParams(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs181ExtractToTable(Map<String, Object> params) throws SQLException, Exception;

	Map<String, Object> extractGIACS182(Map<String, Object> params) throws SQLException, Exception;

	String giacs183ValidateBeforeExtract(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs183GetDate(String userId)throws SQLException;
	Map<String, Object> giacs183ExtractToTable(Map<String, Object> params) throws SQLException, Exception;
	
	//GIACS136
	String validateIfExisting(Map<String, Object> params) throws SQLException;
	String validateBeforeExtract(Map<String, Object> params) throws SQLException;
	void deletePrevExtractedRecords(Map<String, Object> params) throws SQLException;
	String extractRecordsToTable(Map<String, Object> params) throws SQLException;
	Map<String, Object> getPrevParams(String userId) throws SQLException;
	
	//GIACS296
	Map <String, Object> extractGIACS296(Map <String, Object> params) throws SQLException;
	// SR-3876, 3879 : shan 08.27.2015
	Map<String, Object> getExtractDateGIACS296(String userId) throws SQLException;
	Integer getExtractCountGIACS296(String userId) throws SQLException;
	
	//GIACS279
	Map<String, Object> getGIACS279InitialValues(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs279ExtractTable(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkGIACS279Dates(String btn, String userId) throws SQLException;
	
	//GIACS274
	Map<String, Object> checkGiacs274PrevExt(Map<String, Object> params) throws SQLException;
	String validateGiacs274BranchCd(String branchCd) throws SQLException;
	Map<String, Object> extractGiacs274(Map<String, Object> params) throws SQLException;
	
	//GIACS121
	Map<String, Object> getLastExtractSOAFaculRi(String userId) throws SQLException;
	String extractSOAFaculRi(Map<String, Object> params) throws SQLException;
	
	//GIACS276
	Map<String, Object> extractGiacs276(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGiacs276InitialValues(Map<String, Object> params) throws SQLException; /*Gzelle 09222015 SR18792*/ 
	Map<String, Object> valExtractPrint(Map<String, Object> params) throws SQLException; /*Gzelle 09232015 SR18792*/ 
	
	//GIACS220
	Map<String, Object> checkForPrevExtract(Map<String, Object> params) throws SQLException;
	Map<String, Object> deleteAndExtract(Map<String, Object> params) throws SQLException;
	String computeTaggedRecords(Map<String, Object> allParams) throws SQLException;
	String postTaggedRecords(Map<String, Object> allParams) throws SQLException, Exception;
	Map<String, Object> checkBeforeView(Map<String, Object> params) throws SQLException;
	Map<String, Object> getTreatyQuarterSummary(Map<String, Object> params) throws SQLException;
	Map<String, Object> getTreatyCashAcct(Map<String, Object> params) throws SQLException;
	String saveTreatyStatement(Map<String, Object> params) throws SQLException;
	String saveTreatyCashAcct(Map<String, Object> params) throws SQLException;
	
	Map<String, Object> getGIACS182Variables(String userId) throws SQLException;
}

