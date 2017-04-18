/**
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

/**
 * @author steven
 *
 */
public interface GIACCreditAndCollectionUtilitiesDAO {

	List<Map<String, Object>> getAllCancelledPol(Map<String, Object> params)throws SQLException, Exception;

	void processCancelledPol(Map<String, Object> params)throws SQLException, Exception;

	void ageBills(Map<String, Object> params) throws SQLException, Exception;
	
	List<Map<String, Object>> getPoliciesForReverseByParam(Map<String, Object> params) throws SQLException;	// FGIC SR-4266 : shan 05.21.2015
	
	void reverseProcessedPolicies(Map<String, Object> params) throws SQLException, Exception;	// FGIC SR-4266 : shan 05.21.2015

}
