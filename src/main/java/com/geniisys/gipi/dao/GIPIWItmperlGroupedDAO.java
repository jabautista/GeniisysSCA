package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.gipi.entity.GIPIWItmperlGrouped;

public interface GIPIWItmperlGroupedDAO {

	List<GIPIWItmperlGrouped> getGipiWItmperlGrouped(Integer parId, Integer itemNo) throws SQLException;
	List<GIPIWItmperlGrouped> getGipiWItmperlGrouped2(Integer parId) throws SQLException;
	String isExist(Integer parId, Integer itemNo) throws SQLException;
	Map<String, Object> negateDeleteItemGroup(Map<String, Object> params) throws SQLException;
	Map<String, Object> negateDeleteItemGroupNew(Map<String, Object> params) throws SQLException;
	void untagDeleteItemGroup(Map<String, Object> params) throws SQLException;
	String checkIfBackEndt(Map<String, Object> params) throws SQLException;
	void getEndtCoveragePerilAmounts(Map<String, Object> params) throws SQLException;

	void deleteWItmperlGrouped(Map<String, Object> params) throws SQLException, JSONException;
	HashMap<String, Object> getCoverageVars(Map<String, Object> params) throws SQLException;
	Map<String, Object> deleteItmperl(Map<String, Object> params) throws SQLException;
	String checkOpenAlliedPeril(Map<String, Object> params) throws SQLException;
	void saveCoverage(Map<String, Object> params, String userId) throws SQLException;
	Map<String, Object> computeTsi(Map<String, Object> params) throws SQLException;
	Map<String, Object> computePremium(Map<String, Object> params) throws SQLException;
	Map<String, Object> autoComputePremRt(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateAllied(Map<String, Object> params) throws SQLException;

	int checkDuration(String date1, String date2) throws SQLException;
}
