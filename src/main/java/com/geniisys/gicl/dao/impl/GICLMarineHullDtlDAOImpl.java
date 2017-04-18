package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jfree.util.Log;

import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMarineHullDtlDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLMarineHullDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMarineHullDtlDAOImpl implements GICLMarineHullDtlDAO{
	
	private Logger log = Logger.getLogger(GICLMarineHullDtlDAOImpl.class);
	private SqlMapClient sqlMapClient;
	private GICLClaimsDAO giclClaimsDAO;
	private GICLClmItemDAO giclClmItemDAO;
	private GICLMortgageeDAO giclMortgageeDAO;
	private GICLItemPerilDAO giclItemPerilDAO;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLMarineHullDtl> getMarineHullDtlList(
			HashMap<String, Object> params) throws SQLException {
		Log.info("Getting Marine Hull Detail..."); 
		return this.sqlMapClient.queryForList("getGiclMarineHullDtlGrid", params);
	}
	public GICLClaimsDAO getGiclClaimsDAO() {
		return giclClaimsDAO;
	}
	public void setGiclClaimsDAO(GICLClaimsDAO giclClaimsDAO) {
		this.giclClaimsDAO = giclClaimsDAO;
	}
	
	public GICLClmItemDAO getGiclClmItemDAO() {
		return giclClmItemDAO;
	}
	public void setGiclClmItemDAO(GICLClmItemDAO giclClmItemDAO) {
		this.giclClmItemDAO = giclClmItemDAO;
	}
	
	public GICLMortgageeDAO getGiclMortgageeDAO() {
		return giclMortgageeDAO;
	}
	public void setGiclMortgageeDAO(GICLMortgageeDAO giclMortgageeDAO) {
		this.giclMortgageeDAO = giclMortgageeDAO;
	}
	
	public GICLItemPerilDAO getGiclItemPerilDAO() {
		return giclItemPerilDAO;
	}
	public void setGiclItemPerilDAO(GICLItemPerilDAO giclItemPerilDAO) {
		this.giclItemPerilDAO = giclItemPerilDAO;
	}
	
	@Override
	public Map<String, Object> validateClmItemNo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateClmItemNoMarineHull", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemMarineHull(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Marine Hull Item information.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLMarineHullDtl> giclMarineHullDtlSetRows = (List<GICLMarineHullDtl>) params.get("giclMarineHullDtlSetRows");
			List<GICLMarineHullDtl> giclMarineHullDtlDelRows = (List<GICLMarineHullDtl>) params.get("giclMarineHullDtlDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLMarineHullDtl marineHull:giclMarineHullDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", marineHull.getClaimId());
				mParams.put("itemNo", marineHull.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("claimId",marineHull.getClaimId());
				params.put("itemNo", marineHull.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+marineHull.getItemNo()+" - "+marineHull.getItemTitle());
				this.sqlMapClient.delete("delGiclMarineHullDtl", params);
				
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLMarineHullDtl marineHull:giclMarineHullDtlSetRows){
				log.info("Inserting item :"+marineHull.getItemNo()+" - "+marineHull.getItemTitle());
				this.sqlMapClient.insert("setGiclMarineHullDtl", marineHull);
				params.put("claimId",marineHull.getClaimId());
				params.put("itemNo", marineHull.getItemNo());
				params.put("itemDesc", marineHull.getItemDesc());
				params.put("itemDesc2", marineHull.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			
			//for mortgagee info
			this.getSqlMapClient().executeBatch();
			this.giclMortgageeDAO.setClmItemMortgagee(params);
			
			//post-form-commit
			this.getSqlMapClient().executeBatch();
			this.giclClaimsDAO.clmItemPostFormCommit(params);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
		}catch (Exception e) {
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving Marine Hull Item information.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
}
