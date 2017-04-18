package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public interface GIACGeneralLedgerReportDAO {

	Map<String, Object> getGiacs503NewFormInstance() throws SQLException;
	Map<String, Object> postGiacs503SL(Map<String, Object> params) throws SQLException, Exception;
	Integer validateGiacs503BeforePrint(Map<String, Object> params) throws SQLException;
	String extractGiacs501(Map<String, Object> params) throws SQLException;
	String validatePayeeCdGiacs110(String payeeCd) throws SQLException;
	String validateTaxCdGiacs110(Integer whtaxId) throws SQLException;
	String validatePayeeNoGiacs110(Map<String, Object> params) throws SQLException;
	String extractMotherAccounts(Map<String, Object> params) throws SQLException;
	String extractMotherAccountsDetail(Map<String, Object> params) throws SQLException;
	String checkExtractGIACS115(Map<String, Object> params) throws SQLException;
	String extractGIACS115(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateCSVGIACS115(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateSAWTCSVGIACS115(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateDATMAPRows(Map<String, Object> params) throws SQLException;
	Map<String, Object> generateDATMAPDetails(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateDATMAPAnnualRows(Map<String, Object> params) throws SQLException;
	Map<String, Object> generateDATMAPAnnualDetails(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateDATSAWTRows(Map<String, Object> params) throws SQLException;
	Map<String, Object> generateDATSAWTDetails(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> generateCSVRLFSLS(Map<String, Object> params) throws SQLException; //added by robert SR 5473 03.14.16
	List<Map<String, Object>> generateDATRLFSLSRows(Map<String, Object> params) throws SQLException; //added by robert SR 5473 03.14.16
	Map<String, Object> generateDATRLFSLSDetails(Map<String, Object> params) throws SQLException; //added by robert SR 5473 03.14.16
}
