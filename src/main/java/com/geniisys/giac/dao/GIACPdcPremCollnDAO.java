/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.giac.entity.GIACPdcPremColln;

/**
 * The Interface GIACPdcPremCollnDAO.
 */
public interface GIACPdcPremCollnDAO {
	
	/**
	 * Gets dated check details.
	 * 
	 * @param gaccTranId
	 * @return List<GIACPdcPremColln>
	 * @throws SQLException the sQL exception
	 */
	List<GIACPdcPremColln> getDatedChkDtls(Integer gaccTranId) throws SQLException;

	List<GIACPdcPremColln> getPostDatedCheckDtls(HashMap<String, Object> params) throws SQLException;
	
	HashMap<String, Object> validatePremSeqNo(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> getPdcPremCollnDtls(Map<String, Object> params) throws SQLException;
	
	HashMap<String, Object> fetchPremCollnUpdateValues(Map<String, Object> params) throws SQLException;
	
	String getParticulars(Map<String, Object> params) throws SQLException;
	
	String getParticulars2(Map<String, Object> params) throws SQLException;
	void getPremCollnUpdateValues(Map<String, Object> params) throws SQLException;
	
	/* benjo 11.08.2016 SR-5802 */
	String getRefPolNo(Map<String, Object> params) throws SQLException;
	String validatePolicy(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getPolicyInvoices(Map<String, Object> params) throws SQLException;
	/* end SR-5802 */
}
