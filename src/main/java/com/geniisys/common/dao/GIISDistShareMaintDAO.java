package com.geniisys.common.dao;

import java.sql.SQLException;
import java.util.Map;

public interface GIISDistShareMaintDAO {
		
	String saveDistShare(Map<String, Object> allParams) throws SQLException;
	String valDeleteDistShare(Map<String, Object> params) throws SQLException;
	Map<String, Object> valAddDistShare(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateUpdateDistShare(Map<String, Object> params) throws SQLException;
	
	//added by john dolon 12.13.2013
	Map<String, Object> showProportionalTreatyInfo(Map<String, Object> params) throws SQLException;
	void giiss031UpdateTreaty(Map<String, Object> params) throws SQLException, Exception;
	Map<String, Object> validateAcctTrtyType(Map<String, Object> params) throws SQLException;
	Map<String, Object> validateProfComm(Map<String, Object> params) throws SQLException;
	Map<String, Object> showNonProportionalTreatyInfo(Map<String, Object> params) throws SQLException;
	void saveGiiss031(Map<String, Object> params) throws SQLException;
	void validateGiiss031TrtyName(Map<String, Object> params) throws SQLException;
	void validateGiiss031OldTrtySeq(Map<String, Object> params) throws SQLException;
	void valDeleteParentRec(Map<String, Object> params) throws SQLException;
	
}
