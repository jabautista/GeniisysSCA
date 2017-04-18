package com.geniisys.giex.dao.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giex.dao.GIEXPerilDepreciationDAO;
import com.geniisys.giex.entity.GIEXLine;
import com.geniisys.giex.entity.GIEXPerilDepreciation;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXPerilDepreciationDAOImpl implements GIEXPerilDepreciationDAO {

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIEXLine> getLineList() throws SQLException, IOException {
		return this.getSqlMapClient().queryForList("showPerilDepreciationMaintenance");
	}

	@SuppressWarnings("unchecked")
	@Override
	public String savePerilDepreciation(Map<String, Object> allParams)throws SQLException {
		String message = "SUCCESS";

		List<GIEXPerilDepreciation> setRows = (List<GIEXPerilDepreciation>) allParams.get("setRows");
		List<GIEXPerilDepreciation> delRows = (List<GIEXPerilDepreciation>) allParams.get("delRows");

		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			for (GIEXPerilDepreciation del : delRows) {
				this.sqlMapClient.delete("delPerilDepreciationRow", del);
			}
			
			for (GIEXPerilDepreciation set : setRows) {
				this.sqlMapClient.insert("setPerilDepreciationRow", set);
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

	@Override
	public String validateAddPerilCd(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateAddPerilCd", params);
	}

}
