/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLEvalVatDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Apr 12, 2012
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
import com.geniisys.gicl.dao.GICLEvalVatDAO;
import com.geniisys.gicl.entity.GICLEvalVat;

public class GICLEvalVatDAOImpl extends DAOImpl implements GICLEvalVatDAO{
	private static Logger log = Logger.getLogger(GICLEvalVatDAOImpl.class);
	@Override
	public Map<String, Object> validateEvalCom(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING VAT COM, PARAMS: "+params);
		getSqlMapClient().update("validateEvalCom",params);
		return params;
	}
	@Override
	public Map<String, Object> validateEvalPartLabor(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING LABOR PART, PARAMS: "+params);
		getSqlMapClient().update("validateEvalPartLabor",params);
		return params;
	}
	@Override
	public Map<String, Object> validateLessDepreciation(
			Map<String, Object> params) throws SQLException {
		log.info("VALIDATING LABOR DEPRECIATION, PARAMS: "+params);
		getSqlMapClient().update("validateLessDepreciation",params);
		return params;
	}
	@Override
	public Map<String, Object> validateLessDeductibles(
			Map<String, Object> params) throws SQLException {
		log.info("VALIDATING LABOR DEDUCTIBLES, PARAMS: "+params);
		getSqlMapClient().update("validateLessDeductibles",params);
		return params;
	}
	@Override
	public String checkEnableCreateVat(Integer evalId) throws SQLException {
		log.info("CHECKING EVAL ID "+evalId);
		return (String) getSqlMapClient().queryForObject("checkEnableCreateVat", evalId);
	}
	@SuppressWarnings("unchecked")
	@Override
	public void saveVatDetail(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLEvalVat> setRows = (List<GICLEvalVat>) params.get("setRows"); 
			List<GICLEvalVat>deletedRows = (List<GICLEvalVat>) params.get("deletedRows");
			
			log.info("DELETING EVAL VAT DETAILS..");
			for (GICLEvalVat del : deletedRows) {
				getSqlMapClient().delete("delEvalVatDetail", del );
			}
			
			log.info("INSERTING/UPDATING EVAL VAT DETAILS..");
			
			for (GICLEvalVat set : setRows) {
				getSqlMapClient().update("setEvalVatDetail", set );
			}
			getSqlMapClient().executeBatch();
			log.info("UPDATING MAIN MC EVAL DETAILS");
			Map<String, Object>genericParams = new HashMap<String, Object>();
			genericParams.put("evalId", params.get("evalId"));
			genericParams.put("userId", params.get("userId"));
			
			getSqlMapClient().update("getReplaceAmt",genericParams);
			getSqlMapClient().executeBatch();
			
			getSqlMapClient().update("getRepairAmt",genericParams);
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
	public BigDecimal createVatDetails(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Map<String, Object> genericMap = new HashMap<String, Object>();
			//List<GICLEvalVat> setRows = (List<GICLEvalVat>) params.get("setRows"); commented out because all records of vat is needed.
			
			log.info("CREATING VAT DETAILS FOR EVAL ID: "+params.get("evalId"));
			genericMap.put("evalId", Integer.parseInt((String) params.get("evalId")));
			genericMap.put("userId", params.get("userId"));
			log.info("EXECUTING CREATE_VAT_DETAILS");
			getSqlMapClient().update("createVatDetails", genericMap);
			getSqlMapClient().executeBatch();
			
			// count eval vat 
			//Integer vMaxRecs = (Integer) getSqlMapClient().queryForObject("countEvalVat",Integer.parseInt((String) params.get("evalId")));
			//log.info("vMaxRecs: "+vMaxRecs);
			log.info("RETRIEVING ALL MC EVAL vat RECS");
			List<GICLEvalVat> allVatRecs = getSqlMapClient().queryForList("getAllMcEvalListing", Integer.parseInt((String) params.get("evalId")));
			log.info("TOTAL NUMBER OF VAT INSERTED: "+allVatRecs.size());
			
			log.info("EXECUTING CREATE_VAT_DETAILS2");
			//Map<String, Object>vatDet2Map = null;
			for (GICLEvalVat giclEvalVat : allVatRecs) {
				/*vatDet2Map = new HashMap<String, Object>();
				vatDet2Map.put("evalId", giclEvalVat.getEvalId());
				vatDet2Map.put("payeeTypeCd", giclEvalVat.getPayeeTypeCd());
				vatDet2Map.put("payeeCd",giclEvalVat.getPayeeCd() );
				vatDet2Map.put("applyTo", giclEvalVat.getApplyTo());
				vatDet2Map.put("lessDed", giclEvalVat.getLessDed());
				vatDet2Map.put("lessDep", giclEvalVat.getLessDep());
				vatDet2Map.put("vMaxRecs", vMaxRecs);*/
				getSqlMapClient().update("createVatDetails2", giclEvalVat);
			}
			getSqlMapClient().executeBatch();
			
			log.info("EXECUTING CREATE_VAT_DETAILS3");
			getSqlMapClient().update("createVatDetails3", genericMap);
			getSqlMapClient().executeBatch();
			
			getSqlMapClient().getCurrentConnection().commit();
			return (BigDecimal) genericMap.get("vTotalVat");
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
	public String checkGiclEvalVatExist(Map<String, Object> params)
			throws SQLException, Exception {
		return this.getSqlMapClient().queryForObject("checkGiclEvalVatExist", params).toString();
	}

}
