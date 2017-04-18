/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLReplaceDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Mar 5, 2012
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jfree.util.Log;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.gicl.dao.GICLReplaceDAO;
import com.geniisys.gicl.entity.GICLEvalVat;

public class GICLReplaceDAOImpl extends DAOImpl implements GICLReplaceDAO{
	private static Logger log = Logger.getLogger(GICLReplaceDAO.class);

	@Override
	public Map<String, Object> validatePartType(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING PART TYPE: PARAMS: "+params);
		getSqlMapClient().update("validatePartType",params);
		return params;
	}

	@Override
	public Integer countPrevPartListLOV(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("countPrevPartListLOV", params);
	}

	@Override
	public Map<String, Object> checkPartIfExistMaster(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkPartIfExistMaster",params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> copyMasterPart(Map<String, Object> params)
			throws SQLException {
		log.info("COPYING MASTER PART DETAILS..");
		params = (Map<String, Object>) this.getSqlMapClient().queryForObject("copyMasterPart", params);
		return params;
	}

	@Override
	public Map<String, Object> validatePartDesc(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING PART DESC: PARAMS: "+params);
		getSqlMapClient().update("validatePartDesc", params);
		return params;
	}

	@Override
	public Map<String, Object> validateCompanyType(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING COMPANY TYPE: PARAMS: "+params);
		getSqlMapClient().update("validateCompanyType", params);
		return params;
	}

	@Override
	public Map<String, Object> getPayeeDetailsMap(Map<String, Object> params)
			throws SQLException {
		log.info("GETTING PAYEE DETAILS, PARAMS: "+params);
		this.getSqlMapClient().update("getPayeeDetailsMap",params);
		return params;
	}

	@Override
	public Map<String, Object> validateCompanyDesc(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING COMPANY DESC: PARAMS: "+params);
		getSqlMapClient().update("validateCompanyDesc", params);
		return params;
	}

	@Override
	public Map<String, Object> checkVatAndDeductibles(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING VAT AND DEDUCTIBLES: "+params);
		this.getSqlMapClient().update("checkVatAndDeductibles",params);
		return params;
	}

	@Override
	public Map<String, Object> validateBaseAmt(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING BASE AMT: PARAMS: "+params);
		getSqlMapClient().update("validateBaseAmt", params);
		return params;
	}

	@Override
	public Map<String, Object> validateNoOfUnits(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING NO OF UNITS: PARAMS: "+params);
		getSqlMapClient().update("validateNoOfUnits", params);
		return params;
	}

	@Override
	public List<String> getWithVatList(Integer evalMasterId) throws SQLException {
		@SuppressWarnings("unchecked")
		List<String> list = getSqlMapClient().queryForList("getWithVatList", evalMasterId);
		return list;
	}

	@Override
	public Map<String, Object> checkUpdateRepDtl(Map<String, Object> params)
			throws SQLException {
		log.info("CHECK UPDATE REP DTL");
		getSqlMapClient().update("checkUpdateRepDtl",params);
		return params;
	}

	@Override
	public String finalCheckVat(Map<String, Object> params) throws SQLException {
		log.info("FINAL CHECKING OF VAT");
		return (String) getSqlMapClient().queryForObject("finalCheckVat",params);
	}

	@Override
	public String finalCheckDed(Map<String, Object> params) throws SQLException {
		log.info("FINAL CHECKING OF DEDUCTIBLES");
		return (String) getSqlMapClient().queryForObject("finalCheckDed",params);
	}

	@Override
	public void saveReplaceDetail(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("NEW RECORD: "+params.get("newRecord"));
			
			Map<String, Object>genericMap = new HashMap<String, Object>();
			System.out.println(params);
			
			if (params.get("deleteOldDepreciationValidate").equals("Y")) {
				log.info("DELETING DEPRECIATION RECORD OF OLD LOSS EXP CD: "+params.get("oldLossExpCd"));
				genericMap.put("evalId", params.get("evalId"));
				genericMap.put("lossExpCd", params.get("oldLossExpCd"));
				getSqlMapClient().delete("delEvalDepDtl",genericMap);
			}
			
			if(params.get("updateOldEvalVat").equals("Y")){
				genericMap.clear();
				genericMap.put("payeeTypeCd", (params.get("paytPayeeTypeCd").equals("") ? params.get("payeeTypeCd"): params.get("paytPayeeTypeCd")));
				genericMap.put("payeeCd", (params.get("paytPayeeCd").equals("") ? params.get("payeeCd"): params.get("paytPayeeCd")));
				genericMap.put("varPayeeTypeCd", params.get("varPayeeTypeCd"));
				genericMap.put("varPayeeCd", params.get("varPayeeCd"));
				genericMap.put("evalId", params.get("evalId"));
				log.info("UPDATE VAT FOR OLD PAYEE, PARAMS: "+genericMap);
				this.getSqlMapClient().update("updateOldEvalVat",genericMap);
			}
			
			if(params.get("updateDeductibles").equals("Y")){
				genericMap.clear();
				genericMap.put("varPaytPayeeTypeCd", (params.get("varPaytPayeeTypeCd").equals("") ? params.get("varPayeeTypeCd"): params.get("varPaytPayeeTypeCd")));
				genericMap.put("varPaytPayeeCd", (params.get("varPaytPayeeCd").equals("") ? params.get("varPayeeCd"): params.get("varPaytPayeeCd")));
				genericMap.put("payeeTypeCd", params.get("payeeTypeCd"));
				genericMap.put("payeeCd", params.get("payeeCd"));
				genericMap.put("evalId", params.get("evalId"));
				Log.info("UPDATE old DEDUCTIBLES FOR PAYEE:"+genericMap);
				this.getSqlMapClient().update("updateOldDeductibles",genericMap);
			}
			
			if (params.get("deleteOldDepreciation").equals("Y")) {
				log.info("DELETING DEPRECIATION RECORD OF OLD PAYEE: "+params.get("oldLossExpCd"));
				genericMap.clear();
				genericMap.put("payeeTypeCd", (params.get("varPaytPayeeTypeCd").equals("") ? params.get("varPayeeTypeCd"): params.get("varPaytPayeeTypeCd")));
				genericMap.put("payeeCd", (params.get("varPaytPayeeCd").equals("") ? params.get("varPayeeCd"): params.get("varPaytPayeeCd")));
				genericMap.put("evalId", params.get("evalId"));
				getSqlMapClient().delete("delEvalDepDtl2",genericMap);
			}
			getSqlMapClient().executeBatch();
			
			//delete vat detals
			log.info("DELETE EVAL DATAILS");
			getSqlMapClient().update("deleteEvalVat",params);
			getSqlMapClient().executeBatch();
			
			log.info("DELETE DEDUCTIBLES");
			getSqlMapClient().update("deleteEvalDeductible",params);
			getSqlMapClient().executeBatch();
			
			log.info("DELETE EVAL DEP");
			getSqlMapClient().delete("delEvalDepDtl",params);
			getSqlMapClient().executeBatch();
			
			// save the replace details
			getSqlMapClient().update("saveReplaceDtls",params);
			
			getSqlMapClient().executeBatch();
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
	public void updateItemNo(String userId, Integer evalId) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("update item no, evalId: "+evalId);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("userId", userId);
			params.put("evalId", evalId);
			getSqlMapClient().update("updateItemNo",params);
			getSqlMapClient().executeBatch();
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
	public void deleteReplaceDetail(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//delete vat detals
			log.info("DELETE EVAL VAT DETAILS");
			getSqlMapClient().update("deleteEvalVat",params);
			getSqlMapClient().executeBatch();
			
			log.info("DELETE DEDUCTIBLES");
			getSqlMapClient().update("deleteEvalDeductible",params);
			getSqlMapClient().executeBatch();
			
			log.info("DELETE EVAL DEP");
			getSqlMapClient().delete("delEvalDepDtl",params);
			getSqlMapClient().executeBatch();
			
			log.info("DELETING REPLACE DETAILS");
			getSqlMapClient().update("deleteReplaceDetail",params);
			
			getSqlMapClient().executeBatch();
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

	@SuppressWarnings("unchecked")
	@Override
	public void applyChangePayee(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>>setRows = (List<Map<String, Object>>) params.get("setRows");
			Integer evalId = (Integer) params.get("evalId");
			Integer paytPayeeCdMan = (Integer) params.get("paytPayeeCdMan");
			String paytPayeeTypeCdMan = (String) params.get("paytPayeeTypeCdMan");
			String prevPaytPayeeTypeCd = null;
			Integer prevPaytPayeeCd = null;
			String vTag = "N";
			log.info("changing payees");
			for (Map<String, Object> map : setRows) {
				if (map.get("paytImpTag").equals("Y")) {
					System.out.println(map);
					prevPaytPayeeTypeCd = (String) map.get("paytPayeeTypeCd");
					prevPaytPayeeCd = Integer.parseInt( (String) map.get("paytPayeeCd"));
					map.put("paytPayeeCdMan",paytPayeeCdMan);
					map.put("paytPayeeTypeCdMan",paytPayeeTypeCdMan);
					map.put("userId", params.get("userId"));
					getSqlMapClient().update("changeReplacePayee",map);
					
					vTag = "Y";
				}
			}
			getSqlMapClient().executeBatch();
			
			//updates deducitbles/vats
			if (vTag.equals("Y")) {
				Map<String, Object>genericMap = new HashMap<String, Object>();
				genericMap.put("paytPayeeCdMan",paytPayeeCdMan);
				genericMap.put("paytPayeeTypeCdMan",paytPayeeTypeCdMan);
				genericMap.put("prevPaytPayeeTypeCd",prevPaytPayeeTypeCd);
				genericMap.put("prevPaytPayeeCd",prevPaytPayeeCd);
				genericMap.put("userId", params.get("userId"));
				genericMap.put("evalId", evalId);
				
				System.out.println(genericMap);
				getSqlMapClient().update("updateChangePayee", genericMap);
				getSqlMapClient().executeBatch();
				
				log.info("CREATING VAT DETAILS...");
				
				genericMap = new HashMap<String, Object>();
				
				log.info("CREATING VAT DETAILS FOR EVAL ID: "+params.get("evalId"));
				genericMap.put("evalId", evalId);
				genericMap.put("userId", params.get("userId"));
				log.info("EXECUTING CREATE_VAT_DETAILS");
				getSqlMapClient().update("createVatDetails", genericMap);
				getSqlMapClient().executeBatch();
				
				log.info("RETRIEVING ALL MC EVAL vat RECS");
				List<GICLEvalVat> allVatRecs = getSqlMapClient().queryForList("getAllMcEvalListing", evalId);
				
				log.info("EXECUTING CREATE_VAT_DETAILS2");
				for (GICLEvalVat giclEvalVat : allVatRecs) {
					getSqlMapClient().update("createVatDetails2", giclEvalVat);
				}
				getSqlMapClient().executeBatch();
				
				log.info("EXECUTING CREATE_VAT_DETAILS3");
				getSqlMapClient().update("createVatDetails3", genericMap);
				getSqlMapClient().executeBatch();
			}
		
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

