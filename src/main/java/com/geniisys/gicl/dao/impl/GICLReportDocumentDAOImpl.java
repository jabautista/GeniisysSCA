package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.gicl.dao.GICLReportDocumentDAO;
import com.geniisys.gicl.entity.GICLRepairType;
import com.geniisys.gicl.entity.GICLReportDocument;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReportDocumentDAOImpl implements GICLReportDocumentDAO {
	
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
	public void saveGICLS180(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GICLReportDocument> delList = (List<GICLReportDocument>) params.get("delRows");
			for(GICLReportDocument d: delList){
				this.sqlMapClient.update("delReportDocument", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GICLReportDocument> setList = (List<GICLReportDocument>) params.get("setRows");
			for(GICLReportDocument s: setList){
				this.sqlMapClient.update("setReportDocument", s);
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
		this.sqlMapClient.update("valDeleteReportDocument", reportId);
	}
}
