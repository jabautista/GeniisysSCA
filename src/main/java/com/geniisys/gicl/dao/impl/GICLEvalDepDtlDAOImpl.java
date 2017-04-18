/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLEvalDepDtlDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 10, 2012
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.gicl.dao.GICLEvalDepDtlDAO;

public class GICLEvalDepDtlDAOImpl extends DAOImpl implements GICLEvalDepDtlDAO {
	private static Logger log = Logger.getLogger(GICLEvalDepDtlDAOImpl.class);
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDepPayeeDtls(Integer evalId)
			throws SQLException {
		log.info("GETTING DEPRECIATION DETAILS PAYEE INFORMATION EVAL ID: "+evalId);
		Map<String, Object> initialDepPayeeDetails = (Map<String, Object>) this.getSqlMapClient().queryForObject("getInitialDepPayeeDtls", evalId);
		Map<String, Object> depPayeeDetails = (Map<String, Object>) this.getSqlMapClient().queryForObject("getDepPayeeDtls", evalId);
		Map<String, Object> returnMap = new HashMap<String, Object>();
		returnMap.put("initialDepPayeeDetails", initialDepPayeeDetails);
		returnMap.put("depPayeeDetails", depPayeeDetails);
		return returnMap;
	}
	@Override
	public Map<String, Object> checkDepVat(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING IF VAT EXIST, PARAMS: "+params);
		getSqlMapClient().update("checkDepVat",params);
		return params;
	}
	@Override
	public void saveRepairDet(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object>>setRows = (List<Map<String, Object>>) params.get("setRows");
			Map<String, Object>genericMap = new HashMap<String, Object>();
			
			for (Map<String, Object> map : setRows) {
				log.info("UPDATING LOSS EXP CD:"+map.get("lossExpCd"));
				System.out.println(map);
				// delete the vat if exist
				if (map.get("vatExist").equals("Y")) {
					Map<String, Object>delVatMap = new HashMap<String, Object>();
					delVatMap.put("payeeTypeCd", map.get("payeeTypeCdOld"));
					delVatMap.put("payeeCd", map.get("payeeCdOld"));
					delVatMap.put("evalId", map.get("evalId"));
					log.info("deleting vat of old payee");
					getSqlMapClient().delete("deleteEvalVat", delVatMap);
					
					getSqlMapClient().executeBatch();
				}
				
				log.info("deleting dep record");
				genericMap.put("evalId", map.get("evalId"));
				genericMap.put("lossExpCd", map.get("lossExpCd"));
				getSqlMapClient().update("deleteEvalDep", genericMap);
				getSqlMapClient().executeBatch();
				String tempDedRt = (String) (map.get("dedRt") == null ? "" : map.get("dedRt"));
				BigDecimal dedRt = new BigDecimal(tempDedRt.equals("") ? "0": tempDedRt);
				
				//only inserts to gicl_eval_dep_dtl table when the rate is greater than 0
				if ((dedRt.compareTo(new BigDecimal("0"))) == 1) { // returns 1 when greater than 0
					genericMap.clear();
					log.info("inserting loss exp cd :"+map.get("lossExpCd"));
					String tempDedAmt =  (String) map.get("dedAmt").toString();
					BigDecimal dedAmt = new BigDecimal(tempDedAmt);
					genericMap.put("evalId", map.get("evalId"));
					genericMap.put("dedAmt", dedAmt );
					genericMap.put("dedRt", dedRt);
					genericMap.put("payeeTypeCd", map.get("payeeTypeCd"));
					genericMap.put("payeeCd", map.get("payeeCd"));
					genericMap.put("itemNo", map.get("itemNo"));
					genericMap.put("lossExpCd", map.get("lossExpCd"));
					System.out.println(genericMap);
					getSqlMapClient().insert("setEvalDep",genericMap); 
					getSqlMapClient().executeBatch();
				}
			}
			
			genericMap.clear();
			genericMap.put("evalId", params.get("evalId"));
			genericMap.put("total", params.get("total"));
			getSqlMapClient().update("updateMcEvalDep", genericMap);
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
	public String applyDepreciation(Map<String, Object> params)
			throws SQLException {
		log.info("APPLYING DEPRECIATION, PARAMS: "+params);
		return (String) getSqlMapClient().queryForObject("applyDepreciation", params);
	}
}
