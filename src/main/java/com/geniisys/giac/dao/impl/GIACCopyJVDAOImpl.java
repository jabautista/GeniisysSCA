package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACCopyJVDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACCopyJVDAOImpl implements GIACCopyJVDAO{
	private SqlMapClient sqlMapClient;
	@SuppressWarnings("unused")
	private Logger log = Logger.getLogger(GIACCopyJVDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@Override
	public String giacs051CheckCreateTransaction(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs051CheckCreateTransaction", params);
	}
	@Override
	public Map<String, Object> giacs051CopyJV(Map<String, Object> params) throws SQLException {
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			
			this.getSqlMapClient().update("giacs051InsertIntoAcctrans", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().update("giacs051CopyJVLooper", params);
			this.getSqlMapClient().executeBatch();
			
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return params;
			
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public String giacs051ValidateBranchCdFrom(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs051ValidateBranchCdFrom", params);
	}
	@Override
	public String giacs051ValidateDocYear(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs051ValidateDocYear", params);
	}
	@Override
	public String giacs051ValidateDocMm(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs051ValidateDocMm", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> giacs051ValidateDocSeqNo(
			Map<String, Object> params) throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("giacs051ValidateDocSeqNo", params);
	}
	@Override
	public String giacs051ValidateBranchCdTo(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("giacs051ValidateBranchCdTo", params);
	}

}
