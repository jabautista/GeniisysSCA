package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giis.dao.GIISPayTermDAO;
import com.geniisys.giis.entity.GIISPayTerm;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPayTermDAOImpl implements GIISPayTermDAO {
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISPayTerm> getPaymentTerm() throws SQLException {
		return this.getSqlMapClient().queryForList("getPaymentTerm");
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePayTerm(Map<String, Object> allParams)throws SQLException {
		String message = "SUCCESS";

		List<GIISPayTerm> setRows = (List<GIISPayTerm>) allParams.get("setRows");
		List<GIISPayTerm> delRows = (List<GIISPayTerm>) allParams.get("delRows");

		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			for (GIISPayTerm del : delRows) {
				this.getSqlMapClient().delete("deletePaytTermRow", del);
			}
			for (GIISPayTerm set : setRows) {
				this.sqlMapClient.insert("setPaytTermRow", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();

		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String validateDeletePaytTerm(String paytTermToDelete)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateDeletePaytTerm", paytTermToDelete);
	}

	@Override
	public String validateAddPaytTerm(String paytTermToAdd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateAddPaytTerm", paytTermToAdd);
	}

	@Override
	public String validateAddPaytTermDesc(Map<String, Object> valParams)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateAddPaytTermDesc", valParams);
	}



}
