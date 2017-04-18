package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISReportsAgingDAO;
import com.geniisys.common.entity.GIISReportsAging;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISReportsAgingDAOImpl implements GIISReportsAgingDAO {

private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIISReportsAgingDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss090Aging(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISReportsAging> delList = (List<GIISReportsAging>) params.get("delRows");
			for(GIISReportsAging d: delList){
				log.info("Deleting record "+d.getReportId()+"\t"+d.getBranchCd()+"\t"+d.getColumnNo());
				this.sqlMapClient.update("delReportAging", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISReportsAging> setList = (List<GIISReportsAging>) params.get("setRows");
			for(GIISReportsAging s: setList){
				log.info("Insertint record "+s.getReportId()+"\t"+s.getBranchCd()+"\t"+s.getColumnNo());
				this.sqlMapClient.update("setReportAging", s);
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
		this.sqlMapClient.update("valDeleteReportAging", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddReportAging", params);	
	}

}
