package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACOtherCollnsDAO;
import com.geniisys.giac.entity.GIACOtherCollns;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACOtherCollnsDAOImpl implements GIACOtherCollnsDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String setOtherCollnsDtls(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";

		List<GIACOtherCollns> setRows = (List<GIACOtherCollns>) allParams.get("setRows");
		List<GIACOtherCollns> delRows = (List<GIACOtherCollns>) allParams.get("delRows");
		try {
			Map<String, Object> postFormsParams = new HashMap<String, Object>();
			postFormsParams.put("gaccTranId", allParams.get("gaccTranId"));
			postFormsParams.put("fundCd", allParams.get("fundCd"));
			postFormsParams.put("branchCd", allParams.get("branchCd"));
			postFormsParams.put("user", allParams.get("user"));
			postFormsParams.put("moduleName", allParams.get("moduleName"));
			postFormsParams.put("orFlag", allParams.get("orFlag"));
			postFormsParams.put("tranSource", allParams.get("tranSource"));
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			for (GIACOtherCollns del : delRows) {
				this.sqlMapClient.delete("deleteOtherCollnsDtls", del);
				this.sqlMapClient.executeBatch();
			}
			
			for (GIACOtherCollns set : setRows) {
				this.sqlMapClient.insert("setOtherCollnsDtls", set);
				this.sqlMapClient.executeBatch();
			}
			
			this.getSqlMapClient().insert("postFormsCommitGiacs015", postFormsParams);
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
	public String validateOldTranNoGIACS015(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOldTranNoGIACS015", params);
	}

	@Override
	public String validateOldItemNoGIACS015(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateOldItemNoGIACS015", params);
	}

	@Override
	public String validateItemNoGIACS015(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateItemNoGIACS015", params);
	}

	@Override
	public String validateDeleteGiacs015(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateDeleteGiacs015", params);
	}

	@Override
	public String checkSLCode(Map<String, Object> params) throws SQLException, Exception {
		return (String) sqlMapClient.queryForObject("checkSLCode", params);
	}
}
