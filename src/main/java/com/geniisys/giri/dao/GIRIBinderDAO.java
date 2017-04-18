package com.geniisys.giri.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giri.entity.GIRIBinder;

public interface GIRIBinderDAO {
	
	List<Map<String, Object>> getPostedDtls(Map<String, Object> params) throws SQLException;
	void updateGiriBinderGiris026(Map<String, Object> params) throws SQLException;
	String checkIfBinderExists(String parId) throws SQLException;
	void updateRevSwRevDate(String parId) throws SQLException, Exception;
	public List<GIRIBinder> getBinderDetails(Map<String, Object> params) throws SQLException;
	public void updateBinderPrintDateCnt(Integer fnlBinderId) throws SQLException;
	List<Integer> getFnlBinderId(Map<String, Object> params) throws SQLException;
	void updateAcceptanceInfo(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getBinders(Integer policyId) throws SQLException;
	HashMap<String, Object> updateBinderStatusGIUTS012(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> getPolicyFrps(Map<String, Object> params) throws SQLException;
	Map<String, Object> getBinder(Map<String, Object> params) throws SQLException;
	String checkBinderAccess(Map<String, Object> params) throws SQLException;
	void checkRIPlacementAccess(Map<String, Object> params) throws SQLException; //benjo 07.20.2015 UCPBGEN-SR-19626
}
