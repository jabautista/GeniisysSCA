/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao.impl
	File Name: GIACReplenishDAIImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Nov 8, 2012
	Description: 
*/


package com.geniisys.giac.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.DAOImpl;
import com.geniisys.giac.dao.GIACReplenishDvDAO;
import com.geniisys.giac.entity.GIACReplenishDv;

public class GIACReplenishDvDAOImpl extends DAOImpl implements GIACReplenishDvDAO {
	private Logger log = Logger.getLogger(GIACReplenishDvDAOImpl.class);
	@Override
	public Map<String, Object> getRfDetailAmounts(Map<String, Object> params)
			throws SQLException {
		log.info("Getting RF amounts for replenish id "+ params.get("replenishId"));
		getSqlMapClient().queryForObject("getRfDetailAmounts", params);
		return params;
	}
	@Override
	public void saveRfDetail(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Updating include tags.."+ params.get("replenishId"));
			
			@SuppressWarnings("unchecked")
			List<Map<String, Object> > setRows = (List<Map<String, Object>>) params.get("setRows"); 
			
			for (Map<String, Object> map : setRows) {
				log.info("Dv Tran Id: "+map.get("dvTranId") + "\t Check Item No: "+map.get("checkItemNo"));
				map.put("replenishId", params.get("replenishId"));
				getSqlMapClient().update("updateIncludeTag", map);
			}
			
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
	public Map<String, Object> getGIACS016AcctEntPostQuery(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("getGIACS016AcctEntPostQuery", params);
		return params ;
	}
	
	@Override
	public void saveReplenishmentMasterRecord(Map<String, Object> params) throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			String isExisting = (String) params.get("exist");
			
			if (isExisting.equals("N")) {
				Map<String, Object> masterParams = new HashMap<String, Object>();
				masterParams.put("branchCd", params.get("branchCd"));
				masterParams.put("revolvingFund", params.get("revolvingFund"));
				masterParams.put("totalTagged", params.get("totalTagged"));
				masterParams.put("appUser", params.get("appUser"));

				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveReplenishmentMasterRecord", masterParams);	
				this.getSqlMapClient().executeBatch();
			}else {
				Map<String, Object> revParams = new HashMap<String, Object>();
				revParams.put("replenishId", params.get("replenishId"));
				revParams.put("revolvingFund", params.get("revolvingFund"));
				
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("updateRevolvingFund", revParams);	
				this.getSqlMapClient().executeBatch();
			}
			
				this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveReplenishment(Map<String, Object> params) throws SQLException {
		try {
			List<GIACReplenishDv> setRows = (List<GIACReplenishDv>) params.get("setRows");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			Map<String, Object> repParams = new HashMap<String, Object>();
			repParams.put("replenishId", params.get("replenishId"));
			repParams.put("revolvingFund", params.get("revolvingFund"));
			repParams.put("totalTagged", params.get("totalTagged"));
			repParams.put("appUser", params.get("appUser"));
			
			log.info("INSERTING: "+ repParams);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().insert("saveReplenishment", repParams);		
			this.getSqlMapClient().executeBatch();
			
			for (GIACReplenishDv set : setRows) {
				Map<String, Object> reParams = new HashMap<String, Object>();
				log.info("INSERTING: "+ reParams);
				reParams.put("replenishId", params.get("replenishId"));
				reParams.put("tranId", set.getDvTranId());
				reParams.put("itemNo", set.getItemNo());
				reParams.put("amount", set.getAmount());
			
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("saveReplenishmentDetail", reParams);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public Map<String, Object> getCurrReplenishmentId(Map<String, Object> params) throws SQLException {
		log.info("Getting Current Replenishment Id...");
		List<?> list = this.getSqlMapClient().queryForList("getCurrReplenishmentId", params);
		params.put("list", list);
		return params;
	}
	
	public String checkReplenishmentPaytReq(Map<String, Object> params) throws SQLException{
		log.info("checkReplenishmentPaytReq : " + params.toString());
		return (String) this.getSqlMapClient().queryForObject("checkReplenishmentPaytReq", params);
	}
	
	public BigDecimal getRevolvingFund(Map<String, Object> params) throws SQLException{
		log.info("getRevolvingFund : " + params.toString());
		return (BigDecimal) this.getSqlMapClient().queryForObject("getRevolvingFund", params);
	}
}
