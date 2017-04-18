package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.dao.GIACUpdateCheckStatusDAO;
import com.geniisys.giac.entity.GIACUpdateCheckStatus;
import com.ibatis.sqlmap.client.SqlMapClient;

import common.Logger;

public class GIACUpdateCheckStatusDAOImpl implements GIACUpdateCheckStatusDAO{
	private static Logger log = Logger.getLogger(GIACUpdateCheckStatusDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	@SuppressWarnings("unchecked")
	public void saveChkDisbursement(Map<String, Object> params)
			throws SQLException, Exception {
		List<GIACUpdateCheckStatus> insParams = (List<GIACUpdateCheckStatus>) params.get("setClearingDate");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			if(insParams != null){
				for(GIACUpdateCheckStatus checkStatus: insParams){
					System.out.println("Clearing Date: "+ checkStatus.getClearingDate());
					System.out.println("Check Release Date: "+checkStatus.getCheckReleaseDate());
					System.out.println("Tran ID: "+checkStatus.getGaccTranId());
					this.getSqlMapClient().insert("updateClearingDate", checkStatus);
					System.out.println("finished...");
				}
				log.info("Clearing Date has been updated");
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			log.info(e.getMessage());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
}
