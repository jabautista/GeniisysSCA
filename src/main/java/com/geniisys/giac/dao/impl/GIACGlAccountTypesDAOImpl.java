/** 
 *  Created by   : Gzelle
 *  Date Created : 10-27-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACGlAccountTypesDAO;
import com.geniisys.giac.entity.GIACGlAccountTypes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACGlAccountTypesDAOImpl implements GIACGlAccountTypesDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valDelGlAcctType(String ledgerCd) throws SQLException {
		this.sqlMapClient.update("valDelGlAcctTypes", ledgerCd);
	}

	@Override
	public void valAddGlAcctType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGlAcctTypes", params);
	}

	@Override
	public void valUpdGlAcctType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valUpdGlAcctTypes", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs340(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACGlAccountTypes> delList = (List<GIACGlAccountTypes>) params.get("delRows");
			for(GIACGlAccountTypes d: delList){
				this.sqlMapClient.update("delGlAcctTypes", d.getLedgerCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACGlAccountTypes> setList = (List<GIACGlAccountTypes>) params.get("setRows");
			for(GIACGlAccountTypes s: setList){
				Map<String, Object> setParams = new HashMap<String, Object>();
				setParams.put("origLedgerCd", params.get("origLedgerCd"));
				setParams.put("ledgerCd", s.getLedgerCd());
				setParams.put("ledgerDesc", s.getLedgerDesc());
				setParams.put("activeTag", s.getActiveTag());
				setParams.put("remarks", s.getRemarks());
				setParams.put("userId", params.get("appUser"));
				setParams.put("btnVal", params.get("btnVal"));
				this.sqlMapClient.update("setGlAcctTypes", setParams);
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch(SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}
}
