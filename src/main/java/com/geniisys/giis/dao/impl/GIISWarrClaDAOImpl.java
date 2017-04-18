package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISLine;
import com.geniisys.giis.dao.GIISWarrClaDAO;
import com.geniisys.giis.entity.GIISWarrCla;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISWarrClaDAOImpl implements GIISWarrClaDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getGIISLine() throws SQLException {
		return this.sqlMapClient.queryForList("getGIISLine");
	}

	@Override
	public  String validateDeleteWarrCla(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateDeleteWarrCla", params);
	}

	@Override
	public String validateAddWarrCla(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateAddWarrCla", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveWarrCla(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIISWarrCla> setRows = (List<GIISWarrCla>) allParams.get("setRows");
		List<GIISWarrCla> delRows = (List<GIISWarrCla>) allParams.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			for (GIISWarrCla del : delRows) {
				this.getSqlMapClient().delete("deleteWarrClaMaintenanceRow", del);
			}
			for (GIISWarrCla set : setRows) {
				this.sqlMapClient.insert("setWarrClaMaintenance", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
}
