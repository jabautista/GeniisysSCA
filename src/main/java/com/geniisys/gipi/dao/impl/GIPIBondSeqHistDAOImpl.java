package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIBondSeqHistDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIBondSeqHistDAOImpl implements GIPIBondSeqHistDAO {

	private Logger log = Logger.getLogger(GIPIBondSeqHistDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getBondSeqNoList(Map<String, Object> param)
			throws SQLException {
		return (List<Integer>) sqlMapClient.queryForList("getBondSeqNoList", param);
	}

	@Override
	public void updBondSeqHist(Map<String, Object> param) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			sqlMapClient.update("updBondSeqHist", param);
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Integer validateBondSeq(Map<String, Object> param)
			throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("validateBondSeq", param);
	}

}
