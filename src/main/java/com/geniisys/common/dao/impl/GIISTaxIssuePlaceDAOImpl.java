package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTaxIssuePlaceDAO;
import com.geniisys.common.entity.GIISTaxIssuePlace;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTaxIssuePlaceDAOImpl implements GIISTaxIssuePlaceDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss028TaxPlace(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTaxIssuePlace> delList = (List<GIISTaxIssuePlace>) params.get("delRows");
			for(GIISTaxIssuePlace d: delList){
				this.sqlMapClient.update("delTaxPlace", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTaxIssuePlace> setList = (List<GIISTaxIssuePlace>) params.get("setRows");
			for(GIISTaxIssuePlace s: setList){
				this.sqlMapClient.update("setTaxPlace", s);
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

	@Override
	public void valDeleteTaxPlaceRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteTaxPlace", params);
	}

}
