package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISTakeupTerm;
import com.geniisys.gipi.dao.GIPIPARListDAO;
import com.geniisys.gipi.dao.GIPIWBondBasicDAO;
import com.geniisys.gipi.dao.GIPIWCosignatoryDAO;
import com.geniisys.gipi.entity.GIPIWBondBasic;
import com.geniisys.gipi.entity.GIPIWCosignatory;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIWBondBasicDAOImpl implements GIPIWBondBasicDAO{
	
	private SqlMapClient sqlMapClient;
	private GIPIWCosignatoryDAO gipiWCosignatoryDAO;
	private GIPIPARListDAO gipiPARListDAO;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	private static Logger log = Logger.getLogger(GIPIWBondBasicDAOImpl.class);

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBondBasicDAO#getGIPIWBondBasic(java.lang.Integer)
	 */
	@Override
	public GIPIWBondBasic getGIPIWBondBasic(Integer parId) throws SQLException {
		log.info("Getting bond details...");
		GIPIWBondBasic bond = (GIPIWBondBasic) this.getSqlMapClient().queryForObject("getGIPIWBondBasic", parId);
		return bond;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBondBasicDAO#deleteBillRelatedTables(java.lang.Integer)
	 */
	@Override
	public void deleteBillRelatedTables(Integer parId) throws SQLException {
		log.info("Deleting bill related tables...");
		this.getSqlMapClient().queryForObject("deleteBillRelatedTables2", parId);
		log.info("Bill-related tables deleted.");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBondBasicDAO#insertGIPIWBondBasic(java.util.Map)
	 */
	@Override
	public void insertGIPIWBondBasic(Map<String, Object> wBondBasic)
			throws SQLException {
		log.info("Inserting bond basic details...");
		this.getSqlMapClient().insert("setGIPIWBondBasic", wBondBasic);
		log.info("Insert successful.");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWBondBasicDAO#saveBondPolicyData(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void saveBondPolicyData(Map<String, Object> params)
			throws SQLException {
		/*try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();*/
			
			log.info("Saving changes...");
			
			Integer parId = (Integer) params.get("parId");
			
			//UPDATES COSIGNATORY TABLE
			List<GIPIWCosignatory> cosignorListing = this.getGipiWCosignatoryDAO().getGIPIWCosignatory(parId);
			
			//temporarily deleting
			for (GIPIWCosignatory cos: cosignorListing){
				//this.deleteGIPIWCosignatory(cos.getParId(), cos.getCosignId());
				this.getGipiWCosignatoryDAO().deleteGIPIWCosignatory(cos.getParId(), cos.getCosignId());
			}
			
			String[] cosignIds = (String[]) params.get("cosignIds");
			
			if (cosignIds != null){
				for (int i=0; i<cosignIds.length; i++){
					Map<String, Object> cosignMap = (Map<String, Object>) params.get(cosignIds[i]);
					this.getGipiWCosignatoryDAO().insertGIPIWCosignatory(cosignMap);
				}
			}
			
			//DELETE_BILL_RELATED_TABLES
			String deleteBillsSw = (String) params.get("deleteBillsSw");
			//log.info("delete bills switch is: "+deleteBillsSw);
			if ("Y".equals(deleteBillsSw)){
				this.deleteBillRelatedTables(parId);
			}
			
			//iNSERT OR UPDATE CHANGES IN BOND BASIC
			Map<String, Object> wBondBasic = (Map<String, Object>) params.get("wBondBasic");
			this.insertGIPIWBondBasic(wBondBasic);
			
			//UPDATE PAR STATUS//edited by jcmbrigino 01102013 SR14676 - check if PAR already has a bill OR if there is in need to delete bill info (deleteBillsSw is Y)
			if(this.getGipiPARListDAO().getGIPIPARDetails(parId).getParStatus() != 6 || "Y".equals(deleteBillsSw))
				this.getGipiPARListDAO().updatePARStatus(parId, 5); //should set to 'with peril info' or revert to peril info from with bill 
			
			/*this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}*/
	}
	
	public void saveEndtBondPolicyData(Map<String, Object> params)
		throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer parId = (Integer) params.get("parId");
			log.info("INSERTING/UPDATING BOND POLICY DATA FOR PAR ID: "+parId);
			this.getSqlMapClient().insert("setGIPIWBondBasic1", params);
			
			//marco - delete bill when clause type is changed - 12.10.2013
			String deleteBillsSw = (String) params.get("deleteBillsSw");
			if ("Y".equals(deleteBillsSw)){
				this.deleteBillRelatedTables(parId);
				//Apollo 10.15.2014
				this.getSqlMapClient().update("deleteBondDist", parId);
			}
			
			log.info("UPDATING PAR STATUS OF PAR ID: "+parId);
			this.getGipiPARListDAO().updatePARStatus(parId, 6);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}	

	/**
	 * @param gipiWCosignatoryDAO the gipiWCosignatoryDAO to set
	 */
	public void setGipiWCosignatoryDAO(GIPIWCosignatoryDAO gipiWCosignatoryDAO) {
		this.gipiWCosignatoryDAO = gipiWCosignatoryDAO;
	}

	/**
	 * @return the gipiWCosignatoryDAO
	 */
	public GIPIWCosignatoryDAO getGipiWCosignatoryDAO() {
		return gipiWCosignatoryDAO;
	}

	/**
	 * @param gipiPARListDAO the gipiPARListDAO to set
	 */
	public void setGipiPARListDAO(GIPIPARListDAO gipiPARListDAO) {
		this.gipiPARListDAO = gipiPARListDAO;
	}

	/**
	 * @return the gipiPARListDAO
	 */
	public GIPIPARListDAO getGipiPARListDAO() {
		return gipiPARListDAO;
	}

	@Override
	public GIPIWBondBasic getBondBasicNewRecord(Integer parId)
			throws SQLException {
		log.info("Getting bond basic info for new record...");
		return (GIPIWBondBasic) this.getSqlMapClient().queryForObject("getBondBasicNewRecord", parId);
	}
	
	@SuppressWarnings("unchecked")
	public void saveLandCarrierDtl(Map<String, Object> params) throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
			
			List<Map<String, Object>> delList = (List<Map<String, Object>>) params.get("delRows");
			for(Map<String, Object> d: delList){
				this.sqlMapClient.update("delLandCarrierDtl", d);
			}
			this.sqlMapClient.executeBatch();
			
			List<Map<String, Object>> setList = (List<Map<String, Object>>) params.get("setRows");
			for(Map<String, Object> s: setList){
				this.sqlMapClient.update("setLandCarrierDtl", s);
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
	public void valAddLandCarrierDtl(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valAddLandCarrierDtl", params);		
	}
	
	public Integer getMaxItemNoLandCarrierDtl(Integer parId) throws SQLException{
		return (Integer) this.sqlMapClient.queryForObject("getMaxItemNoLandCarrierDtl", parId);
	}

}
