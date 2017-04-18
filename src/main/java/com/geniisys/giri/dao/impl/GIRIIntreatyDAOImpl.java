package com.geniisys.giri.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISDistShare;
import com.geniisys.giri.dao.GIRIIntreatyDAO;
import com.geniisys.giri.entity.GIRIInchargesTax;
import com.geniisys.giri.entity.GIRIIntreaty;
import com.geniisys.giri.entity.GIRIIntreatyCharges;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIRIIntreatyDAOImpl implements GIRIIntreatyDAO{

	private Logger log = Logger.getLogger(GIRIIntreatyDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@Override
	public String copyIntreaty(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("copyIntreaty", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		return (String) params.get("intrtyNo");
	}
	
	@Override
	public void approveIntreaty(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("approveIntreaty", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void cancelIntreaty(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("cancelIntreaty", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGIISDistShare(Map<String, Object> params) throws SQLException, Exception {
		log.info("Getting dist share...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGIISDistShare", params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getTranTypeList() throws SQLException, Exception {
		log.info("Getting tran type list...");
		return this.getSqlMapClient().queryForList("getTranTypeList");
	}
	
	@Override
	public Map<String, Object> getDfltBookingMonth(Map<String, Object> params) throws SQLException, Exception {
		log.info("Getting default booking month...");
		this.getSqlMapClient().update("getDfltBookingMonth", params);
		return params;
	}
	
	@Override
	public GIRIIntreaty getGIRIIntreaty(Integer intreatyId) throws SQLException, Exception {
		log.info("Getting intreaty for intreaty id: "+intreatyId);
		GIRIIntreaty giriIntreaty = (GIRIIntreaty) this.getSqlMapClient().queryForObject("getGIRIIntreaty", intreatyId);
		return giriIntreaty;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIIntreatyCharges> getGIRIIntreatyCharges(Integer intreatyId) throws SQLException, Exception {
		log.info("Getting intreaty charges for intreaty id: "+intreatyId);
		List<GIRIIntreatyCharges> giriIntreatyCharges = this.getSqlMapClient().queryForList("getGIRIIntreatyCharges", intreatyId);
		return giriIntreatyCharges;
	}
	
	@Override
	public Integer getIntreatyId() throws SQLException, Exception {
		log.info("Getting Intreaty Id...");
		return (Integer) this.getSqlMapClient().queryForObject("getIntreatyId");
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Integer saveIntreaty(Map<String, Object> params) throws SQLException, Exception {
		try{
			String userId = (String) params.get("userId");
			GIRIIntreaty giriIntreaty = (GIRIIntreaty) params.get("giriIntreaty");
			Integer intreatyId = giriIntreaty.getIntreatyId() == 0 ? this.getIntreatyId() : giriIntreaty.getIntreatyId();
			List<GIRIIntreatyCharges> delIntreatyCharges = (List<GIRIIntreatyCharges>) params.get("delIntreatyCharges");
			List<GIRIIntreatyCharges> addIntreatyCharges = (List<GIRIIntreatyCharges>) params.get("addIntreatyCharges");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving intreaty...");
			giriIntreaty.setIntreatyId(intreatyId);
			giriIntreaty.setUserId(userId);
			this.getSqlMapClient().insert("saveGIRIIntreaty", giriIntreaty);
			this.getSqlMapClient().executeBatch();
			
			log.info("Deleting intreaty charges...");
			for(GIRIIntreatyCharges charges : delIntreatyCharges){
				charges.setIntreatyId(intreatyId);
				charges.setUserId(userId);
				log.info("Deleting "+charges);
				this.getSqlMapClient().delete("delGIRIIntreatyCharges", charges);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting/Updating intreaty charges...");
			for(GIRIIntreatyCharges charges : addIntreatyCharges){
				charges.setIntreatyId(intreatyId);
				charges.setUserId(userId);
				this.getSqlMapClient().delete("addGIRIIntreatyCharges", charges);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			
			return intreatyId;
		}catch(SQLException e){
			e.printStackTrace();	
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause() + "\nRollback...");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIRIInchargesTax> getGIRIInchargesTax(Map<String, Object> params) throws SQLException, Exception {
		log.info("Getting incharges tax...");
		List<GIRIInchargesTax> giriInchargesTax = this.getSqlMapClient().queryForList("getGIRIInchargesTax", params);
		return giriInchargesTax;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveInchargesTax(Map<String, Object> params) throws SQLException, Exception {
		try{
			String userId = (String) params.get("userId");
			List<GIRIInchargesTax> delInchargesTax = (List<GIRIInchargesTax>) params.get("delInchargesTax");
			List<GIRIInchargesTax> addInchargesTax = (List<GIRIInchargesTax>) params.get("addInchargesTax");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Deleting incharges tax...");
			for(GIRIInchargesTax tax : delInchargesTax){
				tax.setUserId(userId);
				this.getSqlMapClient().delete("delGIRIInchargesTax", tax);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("Inserting/Updating intreaty charges...");
			for(GIRIInchargesTax tax : addInchargesTax){
				tax.setUserId(userId);
				this.getSqlMapClient().delete("addGIRIInchargesTax", tax);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();	
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause() + "\nRollback...");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void updateIntreatyCharges(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating intreaty charges...");
			this.getSqlMapClient().update("updateIntreatyCharges", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();	
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause() + "\nRollback...");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public void updateChargeAmount(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating charge amount...");
			this.getSqlMapClient().update("updateChargeAmount", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();	
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause() + "\nRollback...");
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@Override
	public Integer getIntreatyId2(Map<String, Object> params) throws SQLException, Exception {
		log.info("Getting Intreaty Id...");
		return (Integer) this.getSqlMapClient().queryForObject("getIntreatyId2", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getViewIntreaty(Integer intreatyId) throws SQLException, Exception {
		log.info("Getting view intreaty...");
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getViewIntreaty", intreatyId);
	}
}
