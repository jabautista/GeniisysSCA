package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACLossRecoveries;

public interface GIACLossRecoveriesDAO {

	List<GIACLossRecoveries> getGIACLossRecoveries(Integer gaccTranId) throws SQLException;
	List<Map<String, Object>> getRecoveryNoList(HashMap<String, Object> params) throws SQLException;
	Map<String, Object> getSumCollnAmtLossRec(Map<String, Object> params) throws SQLException;
	Map<String, Object> getCurrency(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateCurrencyCode(Map<String, Object> params) throws SQLException;
	String validateDeleteLossRec(Map<String, Object> params) throws SQLException;
	String getTranFlag(Integer gaccTranId) throws SQLException;
	String saveLossRec(Map<String, Object> params) throws SQLException;
	List<String> getManualRecoveryList(Map<String, Object> params) throws SQLException;
	List<String> checkPayorNameExist(Map<String, Object> params) throws SQLException;
	String checkCollectionAmt(Map<String, Object> params) throws SQLException;
}
