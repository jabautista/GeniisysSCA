/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLAviationDtlDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Oct 7, 2011
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLAviationDtlDAO;
import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLAviationDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLAviationDtlDAOImpl implements GICLAviationDtlDAO{
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLAviationDtlDAO.class);
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
		System.out.println(params);
		log.info("validating item no");
		this.sqlMapClient.update("validateClmItemNoAviation", params);
		System.out.println(params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemAviation(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving aviation item info claim id:"+params.get("claimId"));
			Integer claimId = Integer.parseInt((String) params.get("claimId"));
			List<GICLAviationDtl> giclAviationDtlSetRows = (List<GICLAviationDtl>) params.get("giclAviationDtlSetRows");
			List<GICLAviationDtl> giclAviationDtlDelRows = (List<GICLAviationDtl>) params.get("giclAviationDtlDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLAviationDtl av:giclAviationDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", av.getClaimId());
				mParams.put("itemNo", av.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", av.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+av.getItemNo()+" - "+av.getItemTitle());
				this.sqlMapClient.delete("delGiclAviationDtl", params);
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLAviationDtl av : giclAviationDtlSetRows) {
				log.info("Inserting item :"+av.getItemNo()+" - "+av.getItemTitle());
				av.setClaimId(claimId);
				System.out.println(av.getCpiBranchCd());
				this.sqlMapClient.insert("setGiclAviationDtl", av);
				params.put("itemNo", av.getItemNo());
				params.put("itemDesc", av.getItemDesc());
				params.put("itemDesc2", av.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			this.getSqlMapClient().executeBatch();
			
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
