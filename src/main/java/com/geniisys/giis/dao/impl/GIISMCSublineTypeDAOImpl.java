package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISMCSublineType;
import com.geniisys.common.entity.GIISMCSublineType;
import com.geniisys.giis.dao.GIISMCSublineTypeDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMCSublineTypeDAOImpl implements GIISMCSublineTypeDAO{
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@Override
	public void giiss056ValAddRec(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("giiss056ValSublineTypeCd", params);		
	}

	@Override
	public void saveGiiss056(Map<String, Object> params) throws SQLException {
		System.out.println("DAO - saveGiiss056");
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISMCSublineType> delList = (List<GIISMCSublineType>) params.get("delRows");
			for(GIISMCSublineType d: delList){
				Map <String, Object> m = new HashMap<String, Object>();
				m.put("sublineCd", d.getSublineCd());
				m.put("sublineTypeCd", d.getSublineTypeCd());
				this.sqlMapClient.update("giiss056DelRec", m);
			}
			this.sqlMapClient.executeBatch();
			
			@SuppressWarnings("unchecked")
			List<GIISMCSublineType> setList = (List<GIISMCSublineType>) params.get("setRows");
			for(GIISMCSublineType s: setList){
				this.sqlMapClient.update("giiss056SaveRec", s);
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
	public void giiss056ValDelRec(String sublineTypeCd) throws SQLException {
		System.out.println("giiss056ValDelRec");
		this.getSqlMapClient().update("giiss056ValDelRec", sublineTypeCd);
	}

}
