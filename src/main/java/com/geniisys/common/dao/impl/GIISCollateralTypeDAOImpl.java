package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISCollateralTypeDAO;
import com.geniisys.common.entity.GIISCollateralType;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISCollateralTypeDAOImpl implements GIISCollateralTypeDAO{

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
	public void saveGiiss102(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISCollateralType> delList = (List<GIISCollateralType>) params.get("delRows");
			for(GIISCollateralType d: delList){
				this.sqlMapClient.update("delCollateralType", d.getCollType());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISCollateralType> setList = (List<GIISCollateralType>) params.get("setRows");
			for(GIISCollateralType s: setList){
				this.sqlMapClient.update("setCollateralType", s);
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
	public void valDeleteRec(String recId) throws SQLException {
		this.sqlMapClient.update("valDeleteCollateralType", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddCollateralType", recId);		
	}
}
