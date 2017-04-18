package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACAmlaCoveredTransactionDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACAmlaCoveredTransactionDAOImpl implements
		GIACAmlaCoveredTransactionDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAmlaBranch(String userId) throws SQLException {
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getAmlabranch", userId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAmlaRecords(Map<String, Object> params) throws SQLException {
		return (List<Map<String, Object>>) this.getSqlMapClient().queryForList("getAmlaRecords", params);
	}

	@Override
	public Map<String, Object> insertAmlaRecord(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.getSqlMapClient().update("insertAmlaExt", params);

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String deleteAmlaRecord(String userId) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.getSqlMapClient().delete("deleteAmlaExt", userId);

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return userId;
	}

}
