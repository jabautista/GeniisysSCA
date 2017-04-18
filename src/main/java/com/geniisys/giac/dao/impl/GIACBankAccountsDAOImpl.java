package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACBankAccountsDAO;
import com.geniisys.giac.entity.GIACBankAccounts;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACBankAccountsDAOImpl implements GIACBankAccountsDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The logger */
	
	private static Logger log = Logger.getLogger(GIACBankAccountsDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACBankAccountsDAO#getBankAcctNoLOV(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getBankAcctNoLOV(String keyword)
			throws SQLException {
		log.info("getBankAcctNoLOV");
		return this.getSqlMapClient().queryForList("getDCBBankAcctNoListing", keyword);
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteBankAccount", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddBankAccount", params);	
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs312(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACBankAccounts> delList = (List<GIACBankAccounts>) params.get("delRows");
			for(GIACBankAccounts d: delList){				
				this.sqlMapClient.update("delBankAccount", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACBankAccounts> setList = (List<GIACBankAccounts>) params.get("setRows");
			for(GIACBankAccounts s: setList){
				this.sqlMapClient.update("setBankAccount", s);
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
