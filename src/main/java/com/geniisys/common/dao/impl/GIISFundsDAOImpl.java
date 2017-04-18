package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISFundsDAO;
import com.geniisys.common.entity.GIISFunds;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISFundsDAOImpl implements GIISFundsDAO {
	
	/** The SQL Map Client */
	private SqlMapClient sqlMapClient;
	
	/** The logger */
	private static Logger log = Logger.getLogger(GIISFundsDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getFundCdLOVList(String keyword)
			throws SQLException {
		log.info("getFundCdLOVList");
		return this.getSqlMapClient().queryForList("getFundCdLOV", keyword);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiacs302(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISFunds> delList = (List<GIISFunds>) params.get("delRows");
			for(GIISFunds d: delList){
				this.sqlMapClient.update("delGIISFund", d.getFundCd());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISFunds> setList = (List<GIISFunds>) params.get("setRows");
			for(GIISFunds s: setList){
				this.sqlMapClient.update("setGIISFund", s);
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
		this.sqlMapClient.update("valDeleteGIISFund", recId);
	}

	@Override
	public void valAddRec(String recId) throws SQLException {
		this.sqlMapClient.update("valAddGIISFund", recId);		
	}
}
