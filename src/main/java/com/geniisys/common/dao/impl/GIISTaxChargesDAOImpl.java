package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTaxChargesDAO;
import com.geniisys.common.entity.GIISTaxCharges;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTaxChargesDAOImpl implements GIISTaxChargesDAO{
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss028(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTaxCharges> delList = (List<GIISTaxCharges>) params.get("delRows");
			for(GIISTaxCharges d: delList){
				this.sqlMapClient.update("delTaxCharges", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTaxCharges> setList = (List<GIISTaxCharges>) params.get("setRows");
			for(GIISTaxCharges s: setList){
				s.setUserId(params.get("appUser").toString()); //added by robert SR 21845 03.28.16
				this.sqlMapClient.update("setTaxCharges", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDeleteTaxCharges", params);
	}

	@Override
	public String valAddRec(Map<String, Object> params) throws SQLException {
		return (String) sqlMapClient.queryForObject("checkIfHasRecord", params);
		
	}

	@Override
	public String valDateOnAdd(Map<String, Object> params) throws SQLException {
		return (String) sqlMapClient.queryForObject("valDateOnAdd", params);
	}

	@Override
	public void valSeqOnAdd(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valSeqOnAdd", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISTaxCharges> getGiisTaxCharges(Map<String, Object> params) throws SQLException {
		List<GIISTaxCharges> giisTaxCharges = getSqlMapClient().queryForList("getGiisTaxCharges", params);
		return giisTaxCharges;	//Gzelle 10282014
	}

}
