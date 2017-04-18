package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISSignatoryNamesDAO;
import com.geniisys.giis.entity.GIISSignatoryNames;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISSignatoryNamesDAOImpl implements GIISSignatoryNamesDAO{

	private Logger log = Logger.getLogger(GIISSignatoryNamesDAOImpl.class);
	private SqlMapClient sqlMapClient;
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@Override
	public Integer getSignatoryNamesNoSeq() throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("getSignatoryNamesNoSeq");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss071(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISSignatoryNames> delList = (List<GIISSignatoryNames>) params.get("delRows");
			for(GIISSignatoryNames d: delList){
				this.sqlMapClient.update("delSignatoryName", d.getSignatoryId());
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISSignatoryNames> setList = (List<GIISSignatoryNames>) params.get("setRows");
			for(GIISSignatoryNames s: setList){
				//if(s.getRecordStatus().equals(Integer.parseInt("0"))){
				if(s.getSignatoryId() == null){
					s.setSignatoryId(this.getSignatoryNamesNoSeq());
				}
				this.sqlMapClient.update("setSignatoryName", s);
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
	public void valDeleteRec(String signatoryId) throws SQLException {
		this.sqlMapClient.update("valDeleteSignatoryName", signatoryId);
	}

	@Override
	public void valAddRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddSignatoryName", params);		
	}
	
	@Override
	public void valUpdateRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valUpdateSignatoryName", params);		
	} 	
	
	@Override
	public void updateFilename(Map<String, Object> params) throws SQLException {
		log.info("Updating signatory names filename...");
		this.sqlMapClient.update("updateSignatoryNamesFilename", params);
	}
	
	public String getFilename(Integer signatoryId) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("getFilenameGiiss071", signatoryId);
	}
}
