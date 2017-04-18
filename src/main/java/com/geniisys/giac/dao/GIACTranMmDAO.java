package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACTranMm;

public interface GIACTranMmDAO {
	
	List<GIACTranMm> getClosedTransactionMonthYear(Map<String, Object> params) throws SQLException;
	String checkBookingDate(Map<String, Object> params) throws SQLException;
	String getClosedTag(Map<String, Object> params) throws SQLException;
	
	// shan 12.13.2013
	String checkFunctionGiacs038(Map<String, Object> params) throws SQLException;
	Integer getNextTranYrGiacs038(Map<String, Object> params) throws SQLException;
	Integer checkTranYrGiacs038(Map<String, Object> params) throws SQLException;
	String generateTranMmGiacs038(Map<String, Object> params) throws SQLException;
	void saveGiacs038(Map<String, Object> params) throws SQLException;
}
