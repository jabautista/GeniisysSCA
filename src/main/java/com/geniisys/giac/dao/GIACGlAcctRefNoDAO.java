/** 
 *  Created by   : Gzelle
 *  Date Created : 11-09-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;


public interface GIACGlAcctRefNoDAO {

	List<Map<String, Object>> valGlAcctIdGiacs030 (Integer glAcctId) throws SQLException;
	String getOutstandingBal (Map<String, Object> params) throws SQLException;
	void valAddGlAcctRefNo (Map<String, Object> params) throws SQLException;
	List<Map<String, Object>> valRemainingBalGiacs30 (Map<String, Object> params) throws SQLException;
}
