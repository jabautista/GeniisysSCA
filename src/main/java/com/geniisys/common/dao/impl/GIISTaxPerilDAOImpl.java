/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTaxPerilDAO;
import com.geniisys.common.entity.GIISTaxPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTaxPerilDAOImpl implements GIISTaxPerilDAO{

	private SqlMapClient sqlMapClient;
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISTaxPerilDAO#getRequiredTaxPerils(java.lang.String, java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISTaxPeril> getRequiredTaxPerils(String issCd, String lineCd)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("issCd", issCd);
		params.put("lineCd", lineCd);
		return (List<GIISTaxPeril>)this.getSqlMapClient().queryForList("getRequiredTaxPerilListing", params);
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss028TaxPeril(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTaxPeril> delList = (List<GIISTaxPeril>) params.get("delRows");
			for(GIISTaxPeril d: delList){
				this.sqlMapClient.update("delTaxPeril", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTaxPeril> setList = (List<GIISTaxPeril>) params.get("setRows");
			for(GIISTaxPeril s: setList){
				this.sqlMapClient.update("setTaxPeril", s);
				System.out.println(s.getPerilCd());
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
