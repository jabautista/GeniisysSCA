/** 
 *  Created by   : Gzelle
 *  Date Created : 10-29-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface GIACGlSubAccountTypesDAO {

	void valDelGlSubAcctType(Map<String, Object> params) throws SQLException;
	void valAddGlSubAcctType(Map<String, Object> params) throws SQLException;
	void valUpdGlSubAcctType(Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> getAllGlAcctIdGiacs341() throws SQLException;
	void saveGiacs341(Map<String, Object> params) throws SQLException;
	/*giac_gl_transaction_types*/
	void valDelGlTransactionType(Map<String, Object> params) throws SQLException;
	void valAddGlTransactionType(Map<String, Object> params) throws SQLException;
	void valUpdGlTransactionType(Map<String, Object> params) throws SQLException;
	void saveGlTransactionType(Map<String, Object> params) throws SQLException;
}
