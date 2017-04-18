package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIRefNoHistDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIRefNoHistDAOImpl implements GIPIRefNoHistDAO{

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public Map<String, Object> generateBankRefNo(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer noOfRefNo = Integer.parseInt(params.get("noOfRefNo").toString());
			
			for (Integer i = 1; i <= noOfRefNo; i++) {
				this.getSqlMapClient().update("giuts035GenerateBankRefNo", params);
				this.getSqlMapClient().executeBatch();
			}
			
			params.put("modNo", this.getSqlMapClient().queryForObject("getModNo", params));
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> generateCSV(Map<String, Object> params)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getUnusedRefNo", params);
	}
	
}
