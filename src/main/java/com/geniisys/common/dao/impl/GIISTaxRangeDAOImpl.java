package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTaxRangeDAO;
import com.geniisys.common.entity.GIISTaxRange;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTaxRangeDAOImpl implements GIISTaxRangeDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss028TaxRange(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTaxRange> delList = (List<GIISTaxRange>) params.get("delRows");
			for(GIISTaxRange d: delList){
				this.sqlMapClient.update("delTaxRange", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTaxRange> setList = (List<GIISTaxRange>) params.get("setRows");
			for(GIISTaxRange s: setList){
				this.sqlMapClient.update("setTaxRange", s);
			}
			
			System.out.println(params);
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
