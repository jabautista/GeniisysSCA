package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLEngineeringDtlDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.entity.GICLEngineeringDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLEngineeringDtlDAOImpl implements GICLEngineeringDtlDAO {
	
	/** The SQL Map Client **/
	private SqlMapClient sqlMapClient;
	
	/** The Logger **/
	private Logger log = Logger.getLogger(GICLEngineeringDtlDAOImpl.class);
	
	/** Other DAO's **/
	
	private GICLClaimsDAO giclClaimsDAO;
	private GICLClmItemDAO giclClmItemDAO;
	private GICLItemPerilDAO giclItemPerilDAO;

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

	public GICLItemPerilDAO getGiclItemPerilDAO() {
		return giclItemPerilDAO;
	}

	public void setGiclItemPerilDAO(GICLItemPerilDAO giclItemPerilDAO) {
		this.giclItemPerilDAO = giclItemPerilDAO;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLEngineeringDtlDAO#loadEngineeringItemInfoItems(java.util.Map)
	 */
	@Override
	public void loadEngineeringItemInfoItems(Map<String, Object> params)
			throws SQLException {
		log.info("loadEngineeringItemInfoItems");
		this.getSqlMapClient().update("loadEngineeringItemInfoItems", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLEngineeringDtlDAO#saveClmItemEngineering(java.util.Map)
	 */
	@SuppressWarnings({ "unchecked"})
	@Override
	public Map<String, Object> saveClmItemEngineering(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Engineering Item information.");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLEngineeringDtl> giclEngineeringDtlSetRows = (List<GICLEngineeringDtl>) params.get("giclEngineeringDtlSetRows");
			List<GICLEngineeringDtl> giclEngineeringDtlDelRows = (List<GICLEngineeringDtl>) params.get("giclEngineeringDtlDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLEngineeringDtl engineering: giclEngineeringDtlDelRows) {
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", engineering.getClaimId());
				mParams.put("itemNo", engineering.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", engineering.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+engineering.getItemNo()+" - "+engineering.getItemTitle());
				this.sqlMapClient.delete("delGiclEngineeringDtl", params); //emman
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLEngineeringDtl engineering: giclEngineeringDtlSetRows) {
				log.info("Inserting item :"+engineering.getItemNo()+" - "+engineering.getItemTitle());
				this.sqlMapClient.insert("setGiclEngineeringDtl", engineering); //emman
				params.put("itemNo", engineering.getItemNo());
				params.put("itemDesc", engineering.getItemDesc());
				params.put("itemDesc2", engineering.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			
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
			log.info("End of saving Engineering Item information.");
			this.getSqlMapClient().endTransaction();
		}
		
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gicl.dao.GICLEngineeringDtlDAO#validateClmItemNo(java.util.Map)
	 */
	@Override
	public Map<String, Object> validateClmItemNo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateClmItemNoEngineering", params);
		return params;
	}
}
