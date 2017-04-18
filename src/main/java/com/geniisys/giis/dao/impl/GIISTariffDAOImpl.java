package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.json.JSONException;

import com.geniisys.common.entity.GIISTariff;
import com.geniisys.giis.dao.GIISTariffDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISTariffDAOImpl implements GIISTariffDAO{

	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIISS005(Map<String, Object> params) throws SQLException,
			JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GIISTariff> delList = (List<GIISTariff>) params.get("delRows");
			for(GIISTariff d: delList){
				this.getSqlMapClient().update("delGIISS005Tariff", d.getTariffCd());
			}
			this.getSqlMapClient().executeBatch();
			
			List<GIISTariff> setList = (List<GIISTariff>) params.get("setRows");
			for(GIISTariff s: setList){
				this.getSqlMapClient().update("setGIISS005Tariff", s);
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
	public void valAddRec(String tariffCd) throws SQLException {
		this.getSqlMapClient().update("valAddTariff", tariffCd);
	}

	@Override
	public void valDeleteRec(String tariffCd) throws SQLException {
		this.getSqlMapClient().update("valDeleteTariff", tariffCd);
	}
	
}
