package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACSoaTitleDAO;
import com.geniisys.giac.entity.GIACSoaTitle;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACSoaTitleDAOImpl implements GIACSoaTitleDAO {
	
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
	public void saveGiacs335(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIACSoaTitle> delList = (List<GIACSoaTitle>) params.get("delRows");
			for(GIACSoaTitle d: delList){
				this.sqlMapClient.update("delSoaTitle", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIACSoaTitle> setList = (List<GIACSoaTitle>) params.get("setRows");
			for(GIACSoaTitle s: setList){
				this.sqlMapClient.update("setSoaTitle", s);
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
	public String valDeleteRec(String repCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteSoaTitle", repCd);
	}

	@Override
	public String valAddRec(Map<String, Object> params) throws SQLException {
		System.out.println(params.get("repCd")+ " "+params.get("colNo"));
		//this.sqlMapClient.update("valAddSoaTitle", params);
		return (String) this.sqlMapClient.queryForObject("valAddSoaTitle", params);
	}

	@Override
	public Map<String, Object> validateRepCd(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateRepCd", params);
		return params;
	}
}
