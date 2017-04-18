package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACFileSourceDAO;
import com.geniisys.giac.entity.GIACFileSource;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACFileSourceDAOImpl implements GIACFileSourceDAO{
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveFileSource(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";

		List<GIACFileSource> setRows = (List<GIACFileSource>) allParams.get("setRows");
		List<GIACFileSource> delRows = (List<GIACFileSource>) allParams.get("delRows");

		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			for (GIACFileSource del : delRows) {
				this.getSqlMapClient().delete("deleteFileSource", del);
			}
			for (GIACFileSource set : setRows) {
				this.sqlMapClient.insert("setFileSource", set);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();

		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

}
