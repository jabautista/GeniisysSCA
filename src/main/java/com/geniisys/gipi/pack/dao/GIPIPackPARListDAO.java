package com.geniisys.gipi.pack.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.pack.entity.GIPIPackPARList;

public interface GIPIPackPARListDAO {
	List<GIPIPackPARList> getGipiPackParList (String lineCd, String keyword, String userId) throws SQLException;
	List<GIPIPackPARList> getGipiEndtPackParList (String lineCd, String keyword, String userId) throws SQLException;
	Map<String, Object> checkRITablesBeforeDeletion (Integer packParId) throws SQLException;
	void updatePackParRemarks(List<GIPIPackPARList> updatedRow) throws SQLException;
	void deletePackPar(Map<String, Object> params) throws SQLException, Exception;
	void cancelPackPar(Map<String, Object> params) throws SQLException, Exception;
	void saveGipiPackPAR(GIPIPackPARList gipipackpar) throws SQLException;
	GIPIPackPARList saveGipiPackPAR(Map<String, Object> params) throws SQLException;
	Integer getNewPackParId() throws SQLException;
	GIPIPackPARList getGIPIPackParDetails(Integer packParId) throws SQLException;
	void updatePackStatusFromQuote(Integer quoteId, Integer parStatus) throws SQLException;
	String checkPackParQuote(Integer packParId) throws SQLException;
	Map<String, Object> checkIfLineSublineExist(Map<String, Object> params) throws SQLException;
	void createParListWPack(Map<String, Object> params) throws SQLException;
	
	List<GIPIPackPARList> getGipiPackParListing (HashMap<String, Object> params) throws SQLException;
	Map<String, Object> savePackInitialAcceptance(Map<String, Object> params) throws SQLException;
	Integer generatePackParIdGiuts008a() throws SQLException;
	Map<String, Object> getPackParListGiuts008a(Integer packPolicyId) throws SQLException;
	void insertPackParListGiuts008a(Map<String, Object> params) throws SQLException;
	void insertParHistGiuts008a(Map<String, Object> params) throws SQLException;
	String getPackSharePercentage(Integer packParId) throws SQLException;
	String checkGipis095PackPeril(Map<String, Object> params) throws SQLException;
}
