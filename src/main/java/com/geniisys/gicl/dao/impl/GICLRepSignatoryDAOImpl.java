package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLRepSignatoryDAO;
import com.geniisys.gicl.entity.GICLRepSignatory;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLRepSignatoryDAOImpl implements GICLRepSignatoryDAO {
	
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
	public void saveGicls181(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLRepSignatory> delList = (List<GICLRepSignatory>) params.get("delRows");
			for(GICLRepSignatory d: delList){
				d.setReportId(StringFormatter.unescapeHTML2(d.getReportId()));
				this.sqlMapClient.update("delRepSignatoryGicls181", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLRepSignatory> setList = (List<GICLRepSignatory>) params.get("setRows");
			for(GICLRepSignatory s: setList){
				this.sqlMapClient.update("setRepSignatoryGicls181", s);
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
	public void valDeleteRec(String reportId) throws SQLException {
		this.sqlMapClient.update("valDeleteRepSignatory", reportId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddRepSignatoryGicls181", params);
	}
}
