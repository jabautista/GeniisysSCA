package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISLossExpDAO;
import com.geniisys.common.entity.GIISLossExp;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISLossExpDAOImpl implements GIISLossExpDAO {
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGicls104(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISLossExp> delList = (List<GIISLossExp>) params.get("delRows");
			for(GIISLossExp d: delList){
				this.sqlMapClient.update("delLossExp", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISLossExp> setList = (List<GIISLossExp>) params.get("setRows");
			for(GIISLossExp s: setList){
				System.out.println("set: " + s.getLossExpCd()+"\t" + s.getLossExpType()+"\t"+s.getPartSw());
				this.sqlMapClient.update("setLossExp", s);
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
		this.sqlMapClient.update("valDeleteLossExp", params);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddLossExp", params);
	}

	@Override
	public Map<String, Object> valPartSw(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valPartSw", params);
		return params;
	}

	@Override
	public String valLpsSw(String lossExpCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valLpsSw", lossExpCd);
	}

	@Override
	public Map<String, Object> valCompSw(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valCompSw", params);
		return params;
	}

	@Override
	public String valLossExpType(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valLossExpType", params);
	}

	@Override
	public Map<String, Object> getOrigSurplusAmt(Map<String, Object> params) //Added by Kenneth L. 06.11.2015 SR 3626 @lines 85 - 91
			throws SQLException {			
		this.sqlMapClient.update("getOrigSurplusAmt", params);
		return params;
	}

}
