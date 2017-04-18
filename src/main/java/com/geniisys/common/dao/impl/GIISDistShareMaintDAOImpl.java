package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISDistShareMaintDAO;
import com.geniisys.common.entity.GIISDistShare;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISDistShareMaintDAOImpl implements GIISDistShareMaintDAO {
	
	private Logger log = Logger.getLogger(GIISDistShareMaintDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String saveDistShare(Map<String, Object> allParams) throws SQLException {
	
		String message = "SUCCESS";
		
		List<GIISDistShare> delRows = (List<GIISDistShare>) allParams.get("delRows");
		List<GIISDistShare> setRows = (List<GIISDistShare>) allParams.get("setRows");
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving Distribution Share...");
			
			for (GIISDistShare del : delRows) {
				log.info("DELETING: "+ del);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", allParams.get("lineCd"));
				params.put("shareType", allParams.get("shareType"));
				params.put("shareCd", del.getShareCd());
				this.getSqlMapClient().delete("deleteDistShareMaintRow", params);
			}
			
			for (GIISDistShare set : setRows) {
				log.info("INSERTING: "+ set);
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("lineCd", allParams.get("lineCd"));
				params.put("shareType", allParams.get("shareType"));
				params.put("shareCd", set.getShareCd());
				params.put("trtyName", set.getTrtyName());
				params.put("remarks", set.getRemarks());
				params.put("lastUpdate", set.getStrLastUpdate());
				params.put("userId", allParams.get("userId"));
				params.put("trtyYy", set.getTrtyYy());
				params.put("trtySw", set.getTrtySw());
				this.sqlMapClient.insert("setDistShareMaintRow", params);
			}
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
			
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("End of saving Distribution Share.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	public String valDeleteDistShare(Map<String, Object> params) throws SQLException {
		log.info("start of validating deletion of share code");
		return (String) this.getSqlMapClient().queryForObject("valDeleteShareCd", params);
	}
	
	public Map<String, Object> valAddDistShare(Map<String, Object> params) throws SQLException {
		log.info("start of validating insert of distribution share");
		this.getSqlMapClient().update("validateAddDistShare", params);
		return params;
	}
	
	public Map<String, Object> validateUpdateDistShare(Map<String, Object> params) throws SQLException{
		log.info("start of validating update of distribution share");
		this.getSqlMapClient().update("validateUpdateDistShare", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showProportionalTreatyInfo(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("showProportionalTreatyInfo", params);
	}
	
	@Override
	public void giiss031UpdateTreaty(Map<String, Object> params)
			throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.getSqlMapClient().insert("giiss031UpdateTreaty", params);
			log.info("Updated.");
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
		
	}
	
	public Map<String, Object> validateAcctTrtyType(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateAcctTrtyType", params);
		return params;
	}
	
	public Map<String, Object> validateProfComm(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateProfComm", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> showNonProportionalTreatyInfo(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("showNonProportionalTreatyInfo", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveGiiss031(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<GIISDistShare> delList = (List<GIISDistShare>) params.get("delRows");
			for(GIISDistShare d: delList){
				this.sqlMapClient.update("delNpTreaty", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<GIISDistShare> setList = (List<GIISDistShare>) params.get("setRows");
			for(GIISDistShare s: setList){
				this.sqlMapClient.update("setNpTreaty", s);
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
	
	public void validateGiiss031TrtyName(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss031TrtyName", params);
	}
	
	public void validateGiiss031OldTrtySeq(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateGiiss031OldTrtySeq", params);
	}
	
	@Override
	public void valDeleteParentRec(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.queryForObject("valDeleteParentRecNp", params);
	}

}
