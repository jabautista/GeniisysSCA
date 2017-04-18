package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISMCCarCompany;
import com.geniisys.giis.dao.GIISMcCarCompanyDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMcCarCompanyDAOImpl implements GIISMcCarCompanyDAO{

	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	@Override
	public void valAddRec(Map<String, Object> params) // carlo  - 08052015 - SR 19241
			throws SQLException {
		this.sqlMapClient.update("valAddCarCompany", params);	
		System.out.println(params.get("pAction"));
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss115(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISMCCarCompany> delList = (List<GIISMCCarCompany>) params.get("delRows");
			for(GIISMCCarCompany d: delList){
				this.sqlMapClient.update("delCarCompany", d.getCarCompanyCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISMCCarCompany> setList = (List<GIISMCCarCompany>) params.get("setRows");
			for(GIISMCCarCompany s: setList){
				this.sqlMapClient.update("setCarCompany", s);
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
	public void valDeleteRec(Integer recId) throws SQLException {
		this.sqlMapClient.update("valDeleteCarCompany", recId);
	}

	
	
}
