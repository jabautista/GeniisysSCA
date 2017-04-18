package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLAdvLineAmtDAO;
import com.geniisys.gicl.entity.GICLAdvLineAmt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLAdvLineAmtDAOImpl implements GICLAdvLineAmtDAO {

	private SqlMapClient sqlMapClient;
	
	@Override
	public BigDecimal getRangeTo(Map<String, Object> params)
			throws SQLException {		
		return (BigDecimal) this.sqlMapClient.queryForObject("getRangeTo", params);
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	public void saveGicls182(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLAdvLineAmt> setList = (List<GICLAdvLineAmt>) params.get("setRows");
			for(GICLAdvLineAmt s: setList){
				this.sqlMapClient.update("setAdvLineAmt", s);
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
