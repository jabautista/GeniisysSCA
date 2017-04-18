package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.dao.GIISIntmdryTypeRtDAO;
import com.geniisys.common.entity.GIISIntmdryTypeRt;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISIntmdryTypeRtDAOImpl implements GIISIntmdryTypeRtDAO{

private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss201(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISIntmdryTypeRt> delList = (List<GIISIntmdryTypeRt>) params.get("delRows");
			for(GIISIntmdryTypeRt d: delList){
				this.getSqlMapClient().update("delGiisIntmdryTypeRt", d);
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISIntmdryTypeRt> setList = (List<GIISIntmdryTypeRt>) params.get("setRows");
			for(GIISIntmdryTypeRt s: setList){
				this.getSqlMapClient().update("setGiisIntmdryTypeRt", s);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void valDeleteRec(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valDeleteGiisIntmdryTypeRt", params);
	}
	
}
