package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISLossTaxesDAO;
import com.geniisys.common.entity.GIISLossTaxLine;
import com.geniisys.common.entity.GIISLossTaxes;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISLossTaxesDAOImpl implements GIISLossTaxesDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls106(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLossTaxes> delList = (List<GIISLossTaxes>) params.get("delRows");
			for(GIISLossTaxes d: delList){
				this.sqlMapClient.update("delLossExpTaxes", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISLossTaxes> setList = (List<GIISLossTaxes>) params.get("setRows");
			for(GIISLossTaxes s: setList){
				this.sqlMapClient.update("setLossExpTaxes", s);
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

	@Override
	public String valDeleteRec(String airTypeCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteAirType", airTypeCd);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddAirType", recId);		
	}
	
	public Map<String, Object> validateGicls106Tax(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls106Tax", params);
		return params;
	}
	
	@Override
	public void copyTaxToIssuingSource(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.insert("copyTaxToIssuingSource", params);
	}
	
	public Map<String, Object> validateGicls106Branch(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls106Branch", params);
		return params;
	}
	
	public Map<String, Object> validateGicls106LossTaxes(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls106LossTaxes", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public void saveLineLossExp(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLossTaxLine> setList = (List<GIISLossTaxLine>) params.get("setRows");
			for(GIISLossTaxLine s: setList){
				this.sqlMapClient.update("saveLineLossExp", s);
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
	
	public String valLineLossExp(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valLineLossExp", params);
	}
	
	public Map<String, Object> validateGicls106Line(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls106Line", params);
		return params;
	}
	
	public Map<String, Object> validateGicls106LossExp(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGicls106LossExp", params);
		return params;
	}
	
	@Override
	public void copyTaxToIssuingSourceAndTaxLine(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.insert("copyTaxToIssuingSourceAndTaxLine", params);
	}
	
	public Map<String, Object> checkCopyTaxLineBtn(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkCopyTaxLineBtn", params);
		return params;
	}
	
}
