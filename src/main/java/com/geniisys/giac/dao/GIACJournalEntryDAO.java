package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACJournalEntry;

/**
 * @author steven
 * @date 03.18.2013
 */
public interface GIACJournalEntryDAO {

	List<GIACJournalEntry> getJournalEntries(Map<String, Object> params) throws SQLException;

	Object getNewJournalEntries(Map<String, Object> params) throws SQLException;

	String checkORInfo(String tranId)throws SQLException;

	String getGIACParamValue(String paramName)throws SQLException;
	
	String getPbranchCd(String userId)throws SQLException;

	List<Map<String, Object>> setGiacAcctrans(Map<String, Object> params)throws SQLException,Exception;

	List<Map<String, Object>> getJVTranType(String jvTranTag)throws SQLException;

	String validateTranDate(Map<String, Object> params)throws SQLException;

	Object printOpt(Integer tranId)throws SQLException;

	String checkUserPerIssCdAcctg(Map<String, Object> params)throws SQLException;

	String checkCommPayts(String tranId)throws SQLException;

	List<Map<String, Object>> saveCancelOpt(Map<String, Object> cancelOptParams)throws SQLException, Exception;

	String getDetailModule(String tranId)throws SQLException;

	List<Map<String, Object>> showDVInfo(Map<String, Object> dvInfoParams)throws SQLException, Exception;
	
	String validateJVCancel(String tranId) throws SQLException, Exception;
}
