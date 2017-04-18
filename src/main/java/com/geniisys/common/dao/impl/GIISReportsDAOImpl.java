package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISReportsDAO;
import com.geniisys.common.entity.GIISReports;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISReportsDAOImpl implements GIISReportsDAO {

	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIISReportsDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public String getReportVersion(String reportId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getReportVersion", reportId);
	}

	public String getReportVersion(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getReportVersion2", params);
	}	
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReports> getReportsPerLineCd(String lineCd) throws SQLException {
		log.info("Getting reports listing...");
		return (List<GIISReports>) this.getSqlMapClient().queryForList("getReportsPerLineCd", lineCd);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReports> getReportsListing() throws SQLException {
		log.info("Getting reports listing...");
		return (List<GIISReports>) this.getSqlMapClient().queryForList("getReportsListing");
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReports> getReportsListing2(String lineCd)
			throws SQLException {
		log.info("Getting reports listing...");
		return this.getSqlMapClient().queryForList("getReportsListing2", lineCd);
	}

	@Override
	public String getReportDesname2(String reportId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getReportDesname2", reportId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISReports> getGicls201Reports() throws SQLException {
		log.info("Getting GICLS201 reports...");
		return (List<GIISReports>) this.getSqlMapClient().queryForList("getGicls201Reports");
	}

	@Override
	public String validateReportId(String reportId) throws SQLException {
		log.info("Validating reportId: "+reportId);
		return (String) this.getSqlMapClient().queryForObject("validateReportId", reportId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss090(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISReports> delList = (List<GIISReports>) params.get("delRows");
			for(GIISReports d: delList){
				this.sqlMapClient.update("delReport", d.getReportId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISReports> setList = (List<GIISReports>) params.get("setRows");
			for(GIISReports s: setList){
				this.sqlMapClient.update("setReport", s);
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
		this.sqlMapClient.update("valDeleteReport", recId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddReport", params);	
	}
	
}
