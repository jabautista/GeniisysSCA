/** 
 *  Created by   : Gzelle
 *  Date Created : 11-09-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACGlAcctRefNoDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACGlAcctRefNoDAOImpl implements GIACGlAcctRefNoDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> valGlAcctIdGiacs030(Integer glAcctId) throws SQLException{
		return this.sqlMapClient.queryForList("valGlAcctIdGiacs030", glAcctId);
	}

	@Override
	public String getOutstandingBal(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getOutstandingBalanceGiacs030", params);
	}

	@Override
	public void valAddGlAcctRefNo(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGlAcctRefNo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> valRemainingBalGiacs30(Map<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("valRemainingBalGiacs30", params);
	}
}
