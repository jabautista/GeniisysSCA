package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISMortgageeDAO;
import com.geniisys.giis.entity.GIISMortgagee;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISMortgageeDAOImpl implements GIISMortgageeDAO {
	
	private Logger log = Logger.getLogger(GIISMortgageeDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String validateAddMortgageeCd(Map<String, Object> params) throws SQLException {
		log.info("validating mortgagee code...");
		return (String) this.getSqlMapClient().queryForObject("validateAddMortgageeCd", params);
	}

	@Override
	public String validateAddMortgageeName(Map<String, Object> params) throws SQLException {
		log.info("validating mortgagee name...");
		return (String) this.getSqlMapClient().queryForObject("validateAddMortgageeName", params);
	}

	@Override
	public String validateDeleteMortgagee(Map<String, Object> params) throws SQLException {
		log.info("validating mortgagee...");
		return (String) this.getSqlMapClient().queryForObject("validateDeleteMortgagee", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveMortgagee(Map<String, Object> allParams) throws SQLException {
		String message = "SUCCESS";
		List<GIISMortgagee> setRows = (List<GIISMortgagee>) allParams.get("setRows");
		List<GIISMortgagee> delRows= (List<GIISMortgagee>) allParams.get("delRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);					
			this.getSqlMapClient().startBatch();
			log.info("Saving GIIS Mortgagee...");
			for(GIISMortgagee del : delRows){
				this.getSqlMapClient().delete("deleteGiisMortgagee", del);
			}
			log.info(delRows.size() + " GIIS Mortgagee/s deleted.");
			for(GIISMortgagee set : setRows){
				this.sqlMapClient.insert("setGiisMortgagee", set);
				this.getSqlMapClient().executeBatch();
			}
			log.info(setRows.size() + " GIIS Mortgagee/s inserted/updated.");			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

}
