package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLClmRecoveryDAO;
import com.geniisys.gicl.entity.GICLClmRecovery;
import com.geniisys.gicl.entity.GICLRecHist;
import com.geniisys.gicl.entity.GICLRecoveryPayor;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLClmRecoveryDAOImpl implements GICLClmRecoveryDAO{
	
	private Logger log = Logger.getLogger(GICLClmRecoveryDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLClmRecovery> getGiclClmRecovery(
			HashMap<String, Object> params) throws SQLException {
		return this.sqlMapClient.queryForList("getGiclClmRecovery", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveRecoveryInfo(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Recovery Information.");
		String message = "SUCCESS";
		Integer recoveryId = null;	//added by Gzelle 06.14.2013
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLClmRecovery> setRecovs = (List<GICLClmRecovery>) params.get("setRecovs");
			List<GICLClmRecovery> delRecovs = (List<GICLClmRecovery>) params.get("delRecovs");
			List<Map<String, Object>> recoverable = (List<Map<String, Object>>) params.get("recoverable");
			
			List<GICLRecoveryPayor> setPayors = (List<GICLRecoveryPayor>) params.get("setPayors");
			List<GICLRecoveryPayor> delPayors = (List<GICLRecoveryPayor>) params.get("delPayors");
			
			List<GICLRecHist> setHist = (List<GICLRecHist>) params.get("setHist");
			List<GICLRecHist> delHist = (List<GICLRecHist>) params.get("delHist");
			
			for (GICLClmRecovery del: delRecovs){
				log.info("Deleting recovery :: claimId = "+del.getClaimId()+" , recoveryId = "+del.getRecoveryId());
				
			}
			
			for (GICLClmRecovery set: setRecovs){
				//Checking first if recovery id is null
				if (set.getRecoveryId() == null || StringUtils.isEmpty(set.getRecoveryId().toString())){
					Map<String, Object> saveRec = new HashMap<String, Object>();
					saveRec.put("userId", params.get("userId"));
					saveRec.put("lineCd", set.getLineCd());
					saveRec.put("issCd", set.getIssCd());
					this.sqlMapClient.update("saveClmRecoverable", saveRec);
					log.info("saveClmRecoverable params :: "+saveRec);
					set.setRecYear((Integer) saveRec.get("recYear"));
					set.setRecSeqNo((Integer) saveRec.get("recSeqNo"));
					set.setRecoveryId((Integer) saveRec.get("recoveryId"));
					set.setRecFileDate((Date) saveRec.get("recFileDate"));
				}
				log.info("Insert/update recovery :: claimId = "+set.getClaimId()+" , recoveryId = "+set.getRecoveryId());
				recoveryId = set.getRecoveryId();	//added by Gzelle 06.14.2013
				//For recoverable
				BigDecimal recAmt = set.getRecoverableAmt();
				for (Map<String, Object> recov: recoverable){
					recov.put("claimId", params.get("claimId"));
					log.info("Insert/update recoverable :: itemNo = "+recov.get("itemNo") +" , perilCd ="+recov.get("perilCd"));
					Map<String, Object> saveRec2 = new HashMap<String, Object>();
					//saveRec2.putAll(recov); replaced code by robert 05.27.2013 sr 13135
					saveRec2.put("chkChoose", recov.get("chkChoose"));
					saveRec2.put("itemNo", recov.get("itemNo"));
					saveRec2.put("perilCd", recov.get("perilCd"));
					saveRec2.put("nbtPaidAmt", recov.get("nbtPaidAmt"));
					saveRec2.put("clmLossId", recov.get("clmLossId"));
					saveRec2.put("recAmt", recov.get("nbtPaidAmt"));
					
					saveRec2.put("userId", params.get("userId"));
					saveRec2.put("recoveryId", set.getRecoveryId());
					saveRec2.put("claimId", set.getClaimId());
					
					System.out.println(saveRec2.toString());
					//saveRec2.put("recAmt", recAmt); commented out by robert 05.27.2013 sr 13135
					this.sqlMapClient.update("saveClmRecoverable2", saveRec2);
					//recAmt = (BigDecimal) saveRec2.get("recAmt"); commented out by robert 05.27.2013 sr 13135
					this.getSqlMapClient().executeBatch();
				}
				set.setRecoverableAmt(recAmt);
				this.sqlMapClient.insert("setGiclClmRecovery", set);
			}
			this.getSqlMapClient().executeBatch();
			
			//Deleting Payor details
			for (GICLRecoveryPayor del: delPayors){
				log.info("Deleting payor :: payor class cd = "+del.getPayorClassCd()+" , payorCd = "+del.getPayorCd());
				this.sqlMapClient.delete("delGiclRecoveryPayor", del);
			}
			this.getSqlMapClient().executeBatch();
			
			//Inserting/updating Payor details
			for (GICLRecoveryPayor set: setPayors){
				log.info("Insert/Update payor :: payor class cd = "+set.getPayorClassCd()+" , payorCd = "+set.getPayorCd());
				if (set.getRecoveryId() == null || StringUtils.isEmpty(set.getRecoveryId().toString())) {
					set.setRecoveryId(recoveryId);	//added by Gzelle 06.14.2013 causes SQL exception: recoveryid is null
				}
				this.sqlMapClient.insert("setGiclRecoveryPayor", set);
			}
			this.getSqlMapClient().executeBatch();
			
			//Deleting History details
			for (GICLRecHist del: delHist){
				log.info("Deleting history :: recovery id = "+del.getRecoveryId()+" , rec hist no = "+del.getRecHistNo());
				this.sqlMapClient.delete("delGiclRecHist", del);
			}
			this.getSqlMapClient().executeBatch();
			
			//Inserting/updating Payor details
			for (GICLRecHist set: setHist){
				log.info("Insert/Update history :: recovery id = "+set.getRecoveryId()+" , rec hist no = "+set.getRecHistNo());
				if (set.getRecoveryId() == null || StringUtils.isEmpty(set.getRecoveryId().toString())) {
					set.setRecoveryId(recoveryId);	//added by Gzelle 06.14.2013 causes SQL exception: recoveryid is null
				}
				this.sqlMapClient.insert("setGiclRecHist", set);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			message = ExceptionHandler.handleException(e, (GIISUser) params.get("USER"));
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Recovery Information.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@Override
	public String genRecHistNo(Map<String, Object> params) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("genRecHistNo", params);
	}
	
	@Override
	public Map<String, Object> checkRecoveredAmtPerRecovery(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.queryForObject("checkRecoveredAmtPerRecovery", params);
		return params;
	}

	@Override
	public void writeOffRecovery(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("writeOffRecovery", params);
	}

	@Override
	public void cancelRecovery(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("cancelRecovery", params);
	}
	
	@Override
	public void closeRecovery(Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("closeRecovery", params);
	}
	
	@Override
	public void validatePrint(Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("valPrint", params);
	}

	@Override
	public void updateDemandLetterDates(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("updateDemandLetterDates", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGicls025Variables(Integer claimId)
			throws SQLException {
		return (Map<String, Object>) getSqlMapClient().queryForObject("getGicls025Variables", claimId);
	}
}
