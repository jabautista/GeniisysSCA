package com.geniisys.giex.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giex.dao.GIEXNewGroupTaxDAO;
import com.geniisys.giex.entity.GIEXNewGroupTax;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIEXNewGroupTaxDAOImpl implements GIEXNewGroupTaxDAO{
	
	private SqlMapClient sqlMapClient;
	private Logger log = Logger.getLogger(GIEXNewGroupTaxDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIEXNewGroupTax(Map<String, Object> params)
			throws SQLException {
		List<GIEXNewGroupTax> addNewGroupTax = (List<GIEXNewGroupTax>) params.get("addNewGroupTaxObj");
		List<GIEXNewGroupTax> delNewGroupTax = (List<GIEXNewGroupTax>) params.get("delNewGroupTaxObj");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIEXNewGroupTax newGroupTax : delNewGroupTax){
				log.info("Deleting GIEXNewGroupTax...");
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("policyId", newGroupTax.getPolicyId());
				params2.put("taxCd", newGroupTax.getTaxCd());
				this.getSqlMapClient().delete("deleteNewGroupTax", params2);
			}			
			this.sqlMapClient.executeBatch();
			
			for (GIEXNewGroupTax newGroupTax : addNewGroupTax){
				log.info("Inserting GIEXNewGroupTax...");
				this.getSqlMapClient().insert("setB880Dtls", newGroupTax);
			}
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void deleteModNewGroupTax(Map<String, Object> params)
			throws SQLException {
		log.info("Delete New Group Tax");
		this.getSqlMapClient().delete("deleteNewGroupTax", params);
	}
	
	@Override
	public String computeNewTaxAmt(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("computeNewTaxAmt", params);
	}
}
