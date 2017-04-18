package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACApdcPaytDAO;
import com.geniisys.giac.entity.GIACApdcPayt;
import com.geniisys.giac.entity.GIACApdcPaytDtl;
import com.geniisys.giac.entity.GIACPdcPremColln;
import com.geniisys.giac.entity.GIACPdcReplace;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACApdcPaytDAOImpl implements GIACApdcPaytDAO{

	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GIACApdcPaytDAOImpl.class);
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACApdcPaytDAO#getApdcPaytListing(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACApdcPayt> getApdcPaytListing(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getApdcPaytListing", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACApdcPaytDAO#popApdc(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public Map<String, Object> popApdc(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForObject("popApdc", params);
	}
	
	public Integer generateApdcId() throws SQLException {
		return (Integer) this.sqlMapClient.queryForObject("generateApdcId");
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.dao.GIACApdcPaytDAO#saveAcknowledgmentReceipt(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	public void saveAcknowledgmentReceipt(Map<String, Object> allParams)
			throws Exception {
		GIACApdcPayt apdcPayt = (GIACApdcPayt) allParams.get("giacApdcPayt");
		List<GIACApdcPaytDtl> apdcPaytDtlList = (List<GIACApdcPaytDtl>) allParams.get("giacApdcPaytDtl"); 
		List<GIACPdcPremColln> insertedPdcPremCollnList = (List<GIACPdcPremColln>) allParams.get("giacInsertedPdcPremColln");
		List<Map<String, Object>> updatedPdcPremCollnList = (List<Map<String, Object>>) allParams.get("giacUpdatedPdcPremColln");
		
		String deletedApdcId = (String) allParams.get("delGiacApdcPayt");
		List<Map<String, Object>> deletedApdcPaytDtl = (List<Map<String, Object>>) allParams.get("delGiacApdcPaytDtl");
		List<Map<String, Object>> deletedPdcPremColln = (List<Map<String, Object>>) allParams.get("delGiacPdcPremColln");
		
		List<GIACPdcReplace> pdcReplaceList = (List<GIACPdcReplace>) allParams.get("pdcReplaceList");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//block for updating apdc_payt_dtl for cancelled apdc_payt
			if (apdcPaytDtlList != null){
				for (GIACApdcPaytDtl paymentDtl : apdcPaytDtlList){
					if ("C".equals(paymentDtl.getCheckFlag())){
						Map<String, Object> deleteParams = this.prepareChildPdcPremColln(paymentDtl.getPdcId());
						if (deleteParams != null){
							this.getSqlMapClient().delete("deletePdcPremColln", deleteParams);
						}
						this.getSqlMapClient().update("cancelApdcPaytDtl", paymentDtl.getPdcId());
					}
				}
			}
			
			//deletion
			if (deletedPdcPremColln != null){
				for (Map<String, Object> deletedPdcPremCollnParam : deletedPdcPremColln){
					log.info("Deleting PDC Premium Collections...");
					this.getSqlMapClient().delete("deletePdcPremColln", deletedPdcPremCollnParam);
				}
			}
			
			if (deletedApdcPaytDtl != null){
				for (Map<String, Object> deletedApdcPaytDtlParam : deletedApdcPaytDtl){
					Integer pdcId = (Integer) deletedApdcPaytDtlParam.get("pdcId");
					Map<String, Object> deleteParams = this.prepareChildPdcPremColln(pdcId);
					if (deleteParams != null){
						this.getSqlMapClient().delete("deletePdcPremColln", deleteParams);
					}
					
					log.info("Deleting APDC Payment Details...");
					this.getSqlMapClient().delete("deleteGiacApdcPaytDtl", pdcId);
				}
			}
			
			System.out.println("apdc id : " + "".equals(deletedApdcId));
			if (deletedApdcId != null && !("".equals(deletedApdcId))){
				List<Integer> deletedChildApdcPayt = this.getSqlMapClient().queryForList("getApdcPaytDtlListing", Integer.parseInt(deletedApdcId));
				for (Integer pdcId : deletedChildApdcPayt){
					Map<String, Object> deleteParams = this.prepareChildPdcPremColln(pdcId);
					if (deleteParams != null){
						log.info("Deleting child Pdc_Prem_Colln records...");
						this.getSqlMapClient().delete("deletePdcPremColln", deleteParams);
					}
					
					log.info("Deleting child Apdc_Payt_Dtl records for apdcId : " + deletedApdcId);
					this.getSqlMapClient().delete("deleteGiacApdcPaytDtl", pdcId);
				}
				
				log.info("Deleting APDC Payment...");
				Integer apdcId = Integer.parseInt(deletedApdcId);
				this.getSqlMapClient().delete("deleteGiacApdcPayt", apdcId);
			}
			
			//update for pdcPremColln
			if (updatedPdcPremCollnList != null){
				for (Map<String, Object> pdcPremColln : updatedPdcPremCollnList){
					log.info("Updating GIACPdcPremColln for pdcId : " + pdcPremColln.get("pdcId"));
					this.getSqlMapClient().update("updatePdcPremColln", pdcPremColln);
				}
			}
			
			//insertion
			if (apdcPayt != null){
				log.info("Inserting GIACApdcPayt apdcId : " + apdcPayt.getApdcId());
				this.getSqlMapClient().insert("setGiacApdcPayt", apdcPayt);
			}
			
			if (apdcPaytDtlList != null){
				for (GIACApdcPaytDtl apdcPaytDtl : apdcPaytDtlList){
					log.info("Inserting GIACApdcPaytDtl for pdcId : " + apdcPaytDtl.getPdcId());
					this.getSqlMapClient().insert("setGiacApdcPaytDtl", apdcPaytDtl);
				}
			}
			
			if (insertedPdcPremCollnList != null){
				for (GIACPdcPremColln pdcPremColln : insertedPdcPremCollnList){
					log.info("Inserting GIACPdcPremColln for pdcId : " + pdcPremColln.getPdcId());
					this.getSqlMapClient().insert("insertPdcPremColln", pdcPremColln);
				}
			}
			
			if (pdcReplaceList != null){
				for (GIACPdcReplace pdcRep : pdcReplaceList){
					log.info("Replacing GIACApdcPaytDtl pdcId : " + pdcRep.getPdcId());
					this.getSqlMapClient().insert("insertGiacPdcReplace", pdcRep);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	private Map<String, Object> prepareChildPdcPremColln(Integer pdcId) throws SQLException{
		Map<String, Object> deleteParams = new HashMap<String, Object>();
		List<GIACPdcPremColln> deletedPdcPremCollnByPdcId = this.getSqlMapClient().queryForList("getPdcPremCollnList", pdcId);
		if (deletedPdcPremCollnByPdcId != null){
			for (GIACPdcPremColln pdcPremColln : deletedPdcPremCollnByPdcId){
				deleteParams.put("pdcId", pdcPremColln.getPdcId());
				deleteParams.put("tranType", pdcPremColln.getTranType());
				deleteParams.put("issCd", pdcPremColln.getIssCd());
				deleteParams.put("premSeqNo", pdcPremColln.getPremSeqNo());
			}
			return deleteParams;
		} else {
			return null;
		}
		
	}
	
	public String verifyApdcNo(Map<String, Object> params) throws SQLException{
		return (String) this.sqlMapClient.queryForObject("verifyApdcNo", params);
	}
	
	public void getDocSeqNo(Map<String, Object> params) throws SQLException{
		this.sqlMapClient.update("getDocSeqNo", params);
	}
	
	public void savePrintChanges(Map<String, Object> params) throws Exception{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("savePrintChanges", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	public GIACApdcPayt getApdcPayt(Map<String, Object> params) throws SQLException{
		return (GIACApdcPayt) this.getSqlMapClient().queryForObject("getGIACApdcPayt", params);
	}

	@Override
	public void delGIACApdcPayt(Integer apdcId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.delete("deleteGiacApdcPayt", apdcId);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
	}

	@Override
	public void cancelGIACApdcPayt(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.sqlMapClient.update("cancelGIACApdcPayt", params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}		
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIACApdcPayt(Map<String, Object> params)
			throws SQLException {
		GIACApdcPayt apdcPayt = (GIACApdcPayt) params.get("setApdcPayt");
		List<GIACApdcPaytDtl> setApdcPaytDtls = (List<GIACApdcPaytDtl>) params.get("setApdcPaytDtls");
		List<GIACApdcPaytDtl> delApdcPaytDtls = (List<GIACApdcPaytDtl>) params.get("delApdcPaytDtls");
		List<GIACPdcPremColln> setPdcPremCollns = (List<GIACPdcPremColln>) params.get("setPdcPremCollns");		
		List<GIACPdcPremColln> delPdcPremCollns = (List<GIACPdcPremColln>) params.get("delPdcPremCollns");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer apdcId = null;
			// sets GIACApdcPayt record
			if (apdcPayt != null){
				apdcId = apdcPayt.getApdcId();
				log.info("Set GIACApdcPayt apdcId : " + apdcPayt.getApdcId());
				this.getSqlMapClient().insert("setGiacApdcPayt", apdcPayt);
				this.sqlMapClient.executeBatch();
			}
			
			// deletes GIACApdcPaytDtl records 
			for (GIACApdcPaytDtl apdcPaytDtl : delApdcPaytDtls){
				log.info("Deleting GIACApdcPaytDtl...");
				this.getSqlMapClient().delete("deleteGiacApdcPaytDtl", apdcPaytDtl.getPdcId());
			}			
			this.sqlMapClient.executeBatch();
			
			// sets GIACApdcPaytDtl records
			for (GIACApdcPaytDtl apdcPaytDtl : setApdcPaytDtls){
				log.info("Inserting/Updating GIACApdcPaytDtl...");
				if(apdcPaytDtl.getApdcId() == null){
					apdcPaytDtl.setApdcId(apdcId);
				}
				this.getSqlMapClient().update("setGiacApdcPaytDtl", apdcPaytDtl);
			}
			this.sqlMapClient.executeBatch();
			
			// deletes GIACPdcPremColln records 
			for (GIACPdcPremColln pdcPremColln : delPdcPremCollns){
				log.info("Deleting GIACPdcPremColln...");
				Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("pdcId", pdcPremColln.getPdcId());
				delParams.put("issCd", pdcPremColln.getIssCd());
				delParams.put("premSeqNo", pdcPremColln.getPremSeqNo());
				System.out.println(delParams);
				this.getSqlMapClient().delete("delPdcPremColln", delParams);
			}			
			this.sqlMapClient.executeBatch();
			
			// sets GIACPdcPremColln records
			for (GIACPdcPremColln pdcPremColln : setPdcPremCollns){
				log.info("Inserting/Updating GIACPdcPremColln...");
				this.getSqlMapClient().update("setPdcPremColln", pdcPremColln);
			}
			this.sqlMapClient.executeBatch();
			
			/*Map<String, Object> postParams = new HashMap<String, Object>();
			postParams.put("appUser", params.get("appUser"));
			postParams.put("apdcId", apdcId);
			this.getSqlMapClient().update("giacs090PostCommit", postParams);*/ //commented out by June Mark SR23314 [11.04.16] 
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public GIACApdcPayt getGIACApdcPayt(Integer apdcId) throws SQLException {
		return (GIACApdcPayt) this.getSqlMapClient().queryForObject("getGIACApdcPayt", apdcId);
	}

	@Override
	public void getBreakdownAmounts(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getBreakdownAmounts", params);
	}

	@Override
	public void valDelApdc(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("valDelApdc", params);
	}
}
