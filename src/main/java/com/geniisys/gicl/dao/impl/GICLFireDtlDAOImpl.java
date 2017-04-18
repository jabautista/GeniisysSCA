package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLFireDtlDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLFireDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLFireDtlDAOImpl implements GICLFireDtlDAO{

	private Logger log = Logger.getLogger(GICLFireDtlDAOImpl.class);
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
		this.sqlMapClient.update("validateClmItemNoFire", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemFire(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Fire Item information.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLFireDtl> giclFireDtlSetRows = (List<GICLFireDtl>) params.get("giclFireDtlSetRows");
			List<GICLFireDtl> giclFireDtlDelRows = (List<GICLFireDtl>) params.get("giclFireDtlDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLFireDtl fire:giclFireDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", fire.getClaimId());
				mParams.put("itemNo", fire.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", fire.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+fire.getItemNo()+" - "+fire.getItemTitle());
				this.sqlMapClient.delete("delGiclFireDtl", params);
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLFireDtl fire:giclFireDtlSetRows){
				log.info("Inserting item :"+fire.getItemNo()+" - "+fire.getItemTitle());
				this.sqlMapClient.insert("setGiclFireDtl", fire);
				params.put("itemNo", fire.getItemNo());
				params.put("itemDesc", fire.getItemDesc());
				params.put("itemDesc2", fire.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			
			//for mortgagee info
			this.getSqlMapClient().executeBatch();
			//this.giclMortgageeDAO.setClmItemMortgagee(params);
			//giclFireDtlDelRows.addAll(giclFireDtlSetRows);
			//for (GICLFireDtl mort:giclFireDtlDelRows){
			for (GICLFireDtl mort:giclFireDtlSetRows){
				params.put("itemNo", mort.getItemNo());
				log.info("Deleting/Inserting mortgagee : "+params);
				this.sqlMapClient.delete("delGiclMortgagee", params);
				this.sqlMapClient.insert("insertClaimMortgagee", params);
			}
			
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
			log.info("End of saving Fire Item information.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}
	
	@Override
	public String getGiclFireDtlExist(String claimId) throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getGiclFireDtlExist", claimId);
	}
	
}
