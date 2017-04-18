package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIPIGenerateStatisticalReportsDAO {

	Map<String, Object> getLineCds() throws SQLException;
	Map<String, Object> getRecCntStatTab(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractRecordsMotorStat(Map<String, Object> params) throws SQLException;
	String chkExistingRecordMotorStat(Map<String, Object> params) throws SQLException;
	Map<String, Object> extractFireStat(Map<String, Object> params) throws SQLException;
	Map<String, Object> computeFireTariffTotals(Map<String, Object> params) throws SQLException;
	String getTrtyTypeCd(String commitAccumDistShare) throws SQLException;
	Map<String, Object> computeFireZoneMasterTotals(Map<String, Object> params) throws SQLException;
	Map<String, Object> computeFireZoneDetailTotals(Map<String, Object> params) throws SQLException;
	String getTrtyName(String commitAccumDistShare) throws SQLException;
	Map<String, Object> computeFireCATotals(Map<String, Object> params) throws SQLException;
	Integer countFireStatExt(Map<String, Object> params) throws SQLException;
	String chkRiskExtRecords(Map<String, Object> params) throws SQLException;
	Integer getTreatyCount(Map<String, Object> params) throws SQLException;
	String extractRiskProfile(Map<String, Object> params) throws SQLException;
	String saveRiskProfile(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkFireStat(Map<String, Object> params) throws SQLException;
	Map<String, Object> valBeforeSave(Map<String, Object> params) throws SQLException;	//Gzelle 03262015
	Map<String, Object> valAddUpdRec(Map<String, Object> params) throws SQLException;	//Gzelle 04072015
	Map<String, Object> validateBeforeExtract(Map<String, Object> params) throws SQLException; //edgar 04/27/2015 FULL WEB SR 4322
}
