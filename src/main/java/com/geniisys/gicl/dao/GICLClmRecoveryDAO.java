package com.geniisys.gicl.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.entity.GICLClmRecovery;

public interface GICLClmRecoveryDAO {

	List<GICLClmRecovery> getGiclClmRecovery(HashMap<String, Object> params) throws SQLException;
	String saveRecoveryInfo(Map<String, Object> params) throws SQLException;
	String genRecHistNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> checkRecoveredAmtPerRecovery(Map<String, Object> params) throws SQLException;
	void writeOffRecovery(Map<String, Object> params) throws SQLException;
	void cancelRecovery(Map<String, Object> params) throws SQLException;
	void closeRecovery(Map<String, Object> params) throws SQLException;
	void validatePrint(Map<String, Object> params) throws SQLException;
	void updateDemandLetterDates(Map<String, Object> params) throws SQLException;
	Map<String, Object> getGicls025Variables(Integer claimId) throws SQLException;	
	
}
