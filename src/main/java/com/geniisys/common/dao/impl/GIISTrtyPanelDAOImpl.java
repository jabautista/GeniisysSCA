package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISTrtyPanelDAO;
import com.geniisys.common.entity.GIISTrtyPanel;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTrtyPanelDAOImpl implements GIISTrtyPanelDAO {
	
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
	public void saveGiiss031(Map<String, Object> params, Map<String, Object> paramsRecompute) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTrtyPanel> delList = (List<GIISTrtyPanel>) params.get("delRows");
			for(GIISTrtyPanel d: delList){
				this.sqlMapClient.update("delTrtyPanel", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTrtyPanel> setList = (List<GIISTrtyPanel>) params.get("setRows");
			for(GIISTrtyPanel s: setList){
				this.sqlMapClient.update("setTrtyPanel", s);
			}
			
			this.sqlMapClient.update("recomputeTrtyPanel", paramsRecompute);
			
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
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddTrtyPanel", params);		
	}
	
	public Map<String, Object> validateGiiss031Reinsurer(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss031Reinsurer", params);
		return params;
	}
	
	public Map<String, Object> validateGiiss031ParentRi(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss031ParentRi", params);
		return params;
	}
	
	@Override
	public void valAddNpRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddNpRec", params);		
	}
	
	@SuppressWarnings("unchecked")
	public void saveGiiss031Np(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISTrtyPanel> delList = (List<GIISTrtyPanel>) params.get("delRows");
			for(GIISTrtyPanel d: delList){
				this.sqlMapClient.update("delTrtyPanel", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISTrtyPanel> setList = (List<GIISTrtyPanel>) params.get("setRows");
			for(GIISTrtyPanel s: setList){
				if (s.getRiCommRt() != null) {
					s.setStrRiCommRt(s.getRiCommRt().toPlainString());
				}
				if (s.getFundsHeldPct() != null) {
					s.setStrFundsHeldPct(s.getFundsHeldPct().toPlainString());
				}	
				this.sqlMapClient.update("setNpTrtyPanel", s);
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
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.queryForObject("valDeleteRecPTreaty", params);
	}
}
