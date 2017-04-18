/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLRepairHdrDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 27, 2012
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.gicl.dao.GICLRepairHdrDAO;
import com.geniisys.gicl.entity.GICLRepairHdr;
import com.geniisys.gicl.entity.GICLRepairLpsDtl;
import com.geniisys.gicl.entity.GICLRepairOtherDtl;

public class GICLRepairHdrDAOImpl extends DAOImpl implements GICLRepairHdrDAO{
	private static Logger log = Logger.getLogger(GICLRepairHdrDAO.class);
	@Override
	public GICLRepairHdr getRepairDtl(Integer evalId) throws SQLException {
		log.info("GETTING GICL_REPAIR_HDR DTL FOR EVAL ID: "+evalId);
		return (GICLRepairHdr) getSqlMapClient().queryForObject("getRepairDtl",evalId);
	}
	@Override
	public String getTinsmithAmount(Map<String, Object> params)
			throws SQLException {
		log.info("GETTING TINSMITH AMOUNT, PARAMS: "+params);
		return (String) getSqlMapClient().queryForObject("getTinsmithAmount",params);
	}
	@Override
	public String getPaintingsAmount(String lossExpCd)
			throws SQLException {
		log.info("GETTING PAINTINGS AMOUNT, lossExpCd: "+lossExpCd);
		return (String) getSqlMapClient().queryForObject("getPaintingsAmount",lossExpCd);
	}
	@Override
	public String validateBeforeSave(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING BEFORE SAVE PARAMS: "+params);
		return (String) getSqlMapClient().queryForObject("validateRepairBeforeSave",params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public void saveRepairDet(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GICLRepairHdr giclRepairHdr = (GICLRepairHdr) params.get("giclRepairHdr");
			List<GICLRepairLpsDtl>setRows = (List<GICLRepairLpsDtl>) params.get("setRows");
			//List<GICLRepairLpsDtl>modifiedRows = (List<GICLRepairLpsDtl>) params.get("modifiedRows");
			List<GICLRepairLpsDtl>deletedRows = (List<GICLRepairLpsDtl>) params.get("deletedRows");
			Integer evalId = (Integer) params.get("evalId");
			Integer evalMasterId = (Integer) params.get("evalMasterId");
			//setRows.addAll(modifiedRows);
			
			// get the master_report_type
			Map<String, Object> tempParams = new HashMap<String, Object>();
			
			getSqlMapClient().update("checkUpdateRepDtl",tempParams);
			log.info("MASTER EVAL REPORT TYPE: "+tempParams.get("masterReportType"));
			
			log.info("INSERTING/UPDATING MAIN GICLRepairHdr record");
			getSqlMapClient().update("saveGiclRepairHdr",giclRepairHdr);
			getSqlMapClient().executeBatch();

			//proceed deleting of gicl_repair_lps_dtl
			for (GICLRepairLpsDtl row : deletedRows) {
				log.info("deleting loss exp cd :" +row.getLossExpCd());
				getSqlMapClient().update("deleteGiclRepairLpsDtl",row);
			}
			
			log.info("INSERT GICL_REPAIR_LPS_DTL");
			for (GICLRepairLpsDtl setRow : setRows) {
				setRow.setEvalId(evalId);
				setRow.setEvalMasterId(evalMasterId);
				setRow.setMasterReportType((String) tempParams.get("masterReportType"));
				log.info("LOSS EXP CD: "+setRow.getLossExpCd());
				//SPLITTING RECORD FOR TINSMITH AMOUNT AND PAINTINGS AMOUNT
				if (setRow.getTinsmithRepairCd().equals("Y")) {
					log.info("adding tinsmith amount");
					setRow.setRepairCd("T"); //Sets the repair cd first and the amount
					setRow.setAmount(setRow.getTinsmithAmount());
					
					this.getSqlMapClient().update("saveGiclRepairLpsDtl",setRow);
				}else{ // deletes its seperate record if null
					log.info("deleting tinsmith if existing");
					setRow.setRepairCd("T");
					getSqlMapClient().update("deleteByRepCd",setRow);
				}
				this.getSqlMapClient().executeBatch();
				
				if (setRow.getPaintingsRepairCd().equals("Y")) {
					log.info("adding paintings amount");
					setRow.setRepairCd("P"); //Sets the repair cd first and the amount
					setRow.setAmount(setRow.getPaintingsAmount());
					this.getSqlMapClient().update("saveGiclRepairLpsDtl",setRow);
				}else{
					log.info("deleting paintings if existing");
					setRow.setRepairCd("P");
					getSqlMapClient().update("deleteByRepCd",setRow);
				}
				this.getSqlMapClient().executeBatch();
			}
			log.info("UPDATING GICL_REPAIR_HDR DETAILS");
			tempParams.clear();
			tempParams.put("evalId", giclRepairHdr.getEvalId());
			tempParams.put("actualTotalAmt", giclRepairHdr.getActualTotalAmt());
			tempParams.put("payeeTypeCd", giclRepairHdr.getPayeeTypeCd());
			tempParams.put("payeeCd", giclRepairHdr.getPayeeCd());
			tempParams.put("dspTotalLabor", giclRepairHdr.getDspTotalLabor());
			tempParams.put("userId", giclRepairHdr.getUserId());
			getSqlMapClient().update("updateGiclRepairDtls", tempParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
		
	
	}
	@Override
	public Map<String, Object> validateBeforeSaveOther(
			Map<String, Object> params) throws SQLException {
		getSqlMapClient().update("validateBeforeSaveOther", params);
		return params;
	}
	@SuppressWarnings("unchecked")
	@Override
	public void saveOtherLabor(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			GICLRepairHdr giclRepairObj = (GICLRepairHdr) params.get("giclRepairObj");
			List<GICLRepairOtherDtl>setRows = (List<GICLRepairOtherDtl>) params.get("setRows");
			List<GICLRepairOtherDtl>delRows = (List<GICLRepairOtherDtl>) params.get("deletedRows");
			Map<String, Object> genericMap = new HashMap<String, Object>();
			log.info("DELETING DETAILS");
			genericMap.put("evalId", giclRepairObj.getEvalId());
			genericMap.put("payeeTypeCd", giclRepairObj.getPayeeTypeCd());
			genericMap.put("payeeCd", giclRepairObj.getPayeeCd());
			genericMap.put("vatExist", params.get("vatExist"));
			genericMap.put("dedExist", params.get("dedExist"));
			genericMap.put("evalMasterId", params.get("evalMasterId"));
			genericMap.put("masterReportType", params.get("masterReportType"));
			genericMap.put("userId", giclRepairObj.getUserId());
			genericMap.put("dspTotalLabor", params.get("dspTotalLabor"));
			getSqlMapClient().update("deleteDetailsLabor",genericMap);
			getSqlMapClient().executeBatch();
			
			log.info("DELETE OTHER LABOR DTL");
			for (GICLRepairOtherDtl delRow : delRows) {
				genericMap.put("itemNo", delRow.getItemNo());
				genericMap.put("repairCd", delRow.getRepairCd());
				getSqlMapClient().delete("deleteOtherRepairDtl",genericMap);
			}
			getSqlMapClient().executeBatch();
			
			log.info("INSERT/UPDATE OTHER LABOR DTL");
			for (GICLRepairOtherDtl setRow : setRows) {
				genericMap.put("itemNo", setRow.getItemNo());
				genericMap.put("repairCd", setRow.getRepairCd());
				genericMap.put("amount", setRow.getAmount());
				genericMap.put("repairCd", setRow.getRepairCd());
				
				getSqlMapClient().update("saveGiclRepairOtherDtl",genericMap);
			}
			getSqlMapClient().executeBatch();
			
			System.out.println(genericMap);
			log.info("UPDATING REPAIR DETAILS AND ITEM NO");
			getSqlMapClient().update("updateOtherLaborDetails",genericMap);
			//getSqlMapClient().update("updateOtherDetails",genericMap);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
}
