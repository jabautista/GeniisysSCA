/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.Map;


public interface GIACGlAccountTypesDAO {

	void valDelGlAcctType(String ledgerCd) throws SQLException;
	void valAddGlAcctType(Map<String, Object> params) throws SQLException;
	void valUpdGlAcctType(Map<String, Object> params) throws SQLException;
	void saveGiacs340(Map<String, Object> params) throws SQLException;
}
