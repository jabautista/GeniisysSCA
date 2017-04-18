package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.fire.entity.GIISFIItemType;
import com.geniisys.giis.dao.GIISFiItemTypeDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISFiItemTypeDAOImpl implements GIISFiItemTypeDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void giiss012ValAddRec(String frItemType) throws SQLException {
		this.sqlMapClient.update("giiss012ValAddRec", frItemType);
	}

	@Override
	public void giiss012ValDelRec(String frItemType) throws SQLException {
		this.sqlMapClient.update("giiss012ValDelRec", frItemType);
	}

	@Override
	public void saveGiiss012(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss012");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISFIItemType> delList = (List<GIISFIItemType>) params.get("delRows");
			for(GIISFIItemType d: delList){
				this.sqlMapClient.update("giiss012DelRec", String.valueOf(d.getFrItemType()));
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISFIItemType> setList = (List<GIISFIItemType>) params.get("setRows");
			for(GIISFIItemType s: setList){
				this.sqlMapClient.update("giiss012SetRec", s);
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
