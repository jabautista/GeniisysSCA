package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLLossExpSettlementDAO;
import com.geniisys.gicl.entity.GICLLeStat;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLLossExpSettlementDAOImpl implements GICLLossExpSettlementDAO {
	
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
	public void saveGicls060(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLLeStat> delList = (List<GICLLeStat>) params.get("delRows");
			for(GICLLeStat d: delList){
				this.sqlMapClient.update("delLossExpSettlement", StringFormatter.unescapeHTML2(d.getLeStatCd()));
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLLeStat> setList = (List<GICLLeStat>) params.get("setRows");
			for(GICLLeStat s: setList){
				this.sqlMapClient.update("setLossExpSettlement", s);
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
	public String valDeleteRec(String leStatCd) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("valDeleteLossExpSettlement", leStatCd);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddLossExpSettlement", recId);		
	}
}
