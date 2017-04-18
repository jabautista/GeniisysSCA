package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIPolwcDAO;
import com.geniisys.gipi.entity.GIPIPolwc;
import com.geniisys.gipi.service.GIPIPolwcService;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIPolwcDAOImpl implements GIPIPolwcDAO{
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	private static Logger log = Logger.getLogger(GIPIPolwcService.class);
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPolwc> getRelatedWcInfo(Map<String, Object> params) throws SQLException {
		return this.getSqlMapClient().queryForList("getRelatedWcInfo",params);
	}
	
	@Override
	public String validateWarrCla(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateWarrCla", params);
	}

	@SuppressWarnings({ "unchecked" })
	@Override
	public void saveGIPIPolWCTableGrid(Map<String, Object> params)
			throws SQLException {
		try {
			List<GIPIPolwc> setWarrClauses = (List<GIPIPolwc>) params.get("setWarrCla");
			List<GIPIPolwc> delWarrClauses = (List<GIPIPolwc>) params.get("delWarrCla");
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);					
			this.sqlMapClient.startBatch();
			
			if(delWarrClauses != null){
				log.info("Saving GIPIPolWc...");
				for(GIPIPolwc warrCla : delWarrClauses){
					this.sqlMapClient.delete("deletePolWC", warrCla);
				}
				log.info(delWarrClauses.size() + " GIPIPolWc deleted.");
			}
			
			if(setWarrClauses != null){
				for(GIPIPolwc warrCla : setWarrClauses){
					if("N".equals(warrCla.getChangeTag()) || "".equals(warrCla.getChangeTag())){
						warrCla.setWcText01(""); 
						warrCla.setWcText02("");
						warrCla.setWcText03("");
						warrCla.setWcText04("");
						warrCla.setWcText05("");
						warrCla.setWcText06("");
						warrCla.setWcText07("");
						warrCla.setWcText08("");
						warrCla.setWcText09("");
						warrCla.setWcText10("");
						warrCla.setWcText11("");
						warrCla.setWcText12("");
						warrCla.setWcText13("");
						warrCla.setWcText14("");
						warrCla.setWcText15("");
						warrCla.setWcText16("");
						warrCla.setWcText17("");
					}
					this.sqlMapClient.insert("savePolWC", warrCla);
				}
				log.info(setWarrClauses.size() + " GIPIPolWc inserted.");
			}
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		} catch (SQLException e){
			this.sqlMapClient.getCurrentConnection().rollback();
			throw e;
		} finally {
			this.sqlMapClient.endTransaction();
		}
	}

	@Override
	public void deleteGIPIPolWCTableGrid(Map<String, Object> parameters)
			throws SQLException {
		log.info("DAO: Deleting Policy Warranty Clause/s...");
		System.out.println(parameters.toString());
		this.getSqlMapClient().delete("deletePolWC", parameters);		
	}
}
