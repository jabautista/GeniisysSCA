/** 
 *  Created by   : Gzelle
 *  Date Created : 10-29-2015
 *  Remarks      : KB#132 - Accounting - AP/AR Enhancement
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACGlSubAccountTypesDAO;
import com.geniisys.giac.entity.GIACGlSubAccountTypes;
import com.geniisys.giac.entity.GIACGlTransactionTypes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACGlSubAccountTypesDAOImpl implements GIACGlSubAccountTypesDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public void valDelGlSubAcctType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelGlSubAcctTypes", params);
	}
	
	@Override
	public void valAddGlSubAcctType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGlSubAcctTypes", params);
	}
	
	@Override
	public void valUpdGlSubAcctType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valUpdGlSubAcctTypes", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getAllGlAcctIdGiacs341() throws SQLException{
		return this.sqlMapClient.queryForList("getAllGlAcctIdGiacs341");
	}	

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs341(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACGlSubAccountTypes> delList = (List<GIACGlSubAccountTypes>) params.get("delRows");
			for(GIACGlSubAccountTypes d: delList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("ledgerCd", d.getLedgerCd());
				delParams.put("subLedgerCd", d.getSubLedgerCd());
				this.sqlMapClient.update("delGlSubAcctTypes", delParams);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACGlSubAccountTypes> setList = (List<GIACGlSubAccountTypes>) params.get("setRows");
			for(GIACGlSubAccountTypes s: setList){
				Map<String, Object> setParams = new HashMap<String, Object>();
				setParams.put("origSubLedgerCd", params.get("origSubLedgerCd"));
				setParams.put("ledgerCd", s.getLedgerCd());
				setParams.put("subLedgerCd", s.getSubLedgerCd());
				setParams.put("subLedgerDesc", s.getSubLedgerDesc());
				setParams.put("glAcctId", s.getGlAcctId());
				setParams.put("activeTag", s.getActiveTag());
				setParams.put("remarks", s.getRemarks());
				setParams.put("userId", params.get("appUser"));
				setParams.put("btnVal", params.get("btnVal"));
				this.sqlMapClient.update("setGlSubAcctTypes", setParams);
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

	/*giac_gl_transaction_types*/
	@Override
	public void valDelGlTransactionType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelGlTransactionTypes", params);
		
	}
	
	@Override
	public void valAddGlTransactionType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddGlTransactionTypes", params);
	}	
	
	@Override
	public void valUpdGlTransactionType(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valUpdGlTransactionTypes", params);
	}	

	@SuppressWarnings("unchecked")
	@Override
	public void saveGlTransactionType(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACGlTransactionTypes> delList = (List<GIACGlTransactionTypes>) params.get("delRows");
			for(GIACGlTransactionTypes d: delList){
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("ledgerCd", d.getLedgerCd());
				delParams.put("subLedgerCd", d.getSubLedgerCd());
				delParams.put("transactionCd", d.getTransactionCd());
				this.sqlMapClient.update("delGlTransactionTypes", delParams);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACGlTransactionTypes> setList = (List<GIACGlTransactionTypes>) params.get("setRows");
			for(GIACGlTransactionTypes s: setList){
				Map<String, Object> setParams = new HashMap<String, Object>();
				setParams.put("origTransactionCd", params.get("origTransactionCd"));
				setParams.put("ledgerCd", s.getLedgerCd());
				setParams.put("subLedgerCd", s.getSubLedgerCd());
				setParams.put("transactionCd", s.getTransactionCd());
				setParams.put("transactionDesc", s.getTransactionDesc());
				setParams.put("activeTag", s.getActiveTag());
				setParams.put("remarks", s.getRemarks());
				setParams.put("userId", params.get("appUser"));
				setParams.put("btnVal", params.get("btnVal"));
				this.sqlMapClient.update("setGlTransactionTypes", setParams);
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
