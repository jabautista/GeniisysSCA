package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.giac.entity.GIACApdcPaytDtl;

public interface GIACApdcPaytDtlDAO {

	List<GIACApdcPaytDtl> getApdcPaytDtlTableGrid(Map<String, Object> params) throws SQLException; 
	Map<String, Object> gpdcPremPostQuery(Map<String, Object> params) throws SQLException;
	String checkGeneratedOR(Integer apdcId) throws SQLException;
	Integer generatePdcId() throws SQLException;
	Integer getApdcSw(Integer tranId) throws SQLException;
	
	//dated check
	void saveGiacs091(Map<String, Object> params) throws SQLException;
	void saveOrParticulars(Map<String, Object> params) throws SQLException;
	Map<String, Object> multipleOR(Map<String, Object> params) throws SQLException;
	Map<String, Object> groupOr(Map<String, Object> params) throws SQLException, JSONException;
	Map<String, Object> validateDcbNo(Map<String, Object> params) throws SQLException;
	void createDbcNo(Map<String, Object> params) throws SQLException;
	Map<String, Object> giacs091DefaultBank(Map<String, Object> params) throws SQLException;
	List<Map <String, Object>> getGiacs091Funds(String userId) throws SQLException;
	String giacs091ValidateTransactionDate (Map<String ,Object> params) throws SQLException;
	String giacs091CheckSOABalance(Map<String, Object> params) throws SQLException; /*added by MarkS 12.13.2016 SR5881*/
}
