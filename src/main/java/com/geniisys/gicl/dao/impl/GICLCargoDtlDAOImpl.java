/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLCargoDtlDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Sep 28, 2011
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLCargoDtlDAO;
import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLCargoDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLCargoDtlDAOImpl implements GICLCargoDtlDAO{
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLCargoDtlDAOImpl.class);
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
		this.sqlMapClient.update("validateClmItemNoCargo", params);
		return params;
	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemMarineCargo(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving motor car item info claim id:"+params.get("claimId"));
			Integer claimId = Integer.parseInt((String) params.get("claimId"));
			List<GICLCargoDtl> giclCargoDtlSetRows = (List<GICLCargoDtl>) params.get("giclCargoDtlSetRows");
			List<GICLCargoDtl> giclCargoDtlDelRows = (List<GICLCargoDtl>) params.get("giclCargoDtlDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLCargoDtl c : giclCargoDtlDelRows) {
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", c.getClaimId());
				mParams.put("itemNo", c.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", c.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+c.getItemNo()+" - "+c.getItemTitle());
				this.sqlMapClient.delete("delGiclCargoDtl", params);
			}
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLCargoDtl giclCargoDtl : giclCargoDtlSetRows) {
				log.info("Inserting item :"+giclCargoDtl.getItemNo()+" - "+giclCargoDtl.getItemTitle());
				giclCargoDtl.setClaimId(claimId);
				this.sqlMapClient.insert("setGiclCargoDtl", giclCargoDtl);
				params.put("itemNo", giclCargoDtl.getItemNo());
				params.put("itemDesc", giclCargoDtl.getItemDesc());
				params.put("itemDesc2", giclCargoDtl.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			
			//for mortgagee info
			this.getSqlMapClient().executeBatch();
			//this.giclMortgageeDAO.setClmItemMortgagee(params);
			giclCargoDtlDelRows.addAll(giclCargoDtlSetRows);
			for (GICLCargoDtl mort : giclCargoDtlDelRows) {
				params.put("itemNo", mort.getItemNo());
				this.sqlMapClient.delete("delGiclMortgagee", params);
				this.sqlMapClient.insert("insertClaimMortgagee", params);
			}
			
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
			log.info("Saving successful.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	
}
