package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gicl.dao.GICLAccidentDtlDAO;
import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLAccidentDtl;
import com.geniisys.gicl.entity.GICLBeneficiary;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;


public class GICLAccidentDtlDAOImpl implements GICLAccidentDtlDAO {
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLAccidentDtlDAO.class);
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

	public Map<String, Object> validateClmItemNo(Map<String, Object> params)
			throws SQLException {
		System.out.println(params);
		log.info("validating item no");
		this.sqlMapClient.update("validateClmItemNoAccident", params);
		System.out.println(params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemAccident(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving accident item info claim id:"+params.get("claimId"));
			Integer claimId = Integer.parseInt((String) params.get("claimId"));
			List<GICLAccidentDtl> giclAccidentDtlSetRows = (List<GICLAccidentDtl>) params.get("giclAccidentDtlSetRows");
			List<GICLAccidentDtl> giclAccidentDtlDelRows = (List<GICLAccidentDtl>) params.get("giclAccidentDtlDelRows");
			
			List<GICLBeneficiary> giclItemBenSetRows = (List<GICLBeneficiary>) params.get("giclItemBenSetRows");
			List<GICLBeneficiary> giclItemBenDelRows = (List<GICLBeneficiary>) params.get("giclItemBenDelRows");
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLAccidentDtl pa :giclAccidentDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", pa.getClaimId());
				mParams.put("itemNo", pa.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", pa.getItemNo());
				params.put("groupedItemNo", pa.getGroupedItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+pa.getItemNo()+" - "+pa.getItemTitle());
				this.sqlMapClient.delete("delGiclAccidentDtl", params);
			}
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting beneficiary info
			this.getSqlMapClient().executeBatch();
			for (GICLBeneficiary ben :giclItemBenDelRows){
				log.info("Deleting beneficiary :"+ben.getBeneficiaryNo()+" - "+ben.getBeneficiaryName());
				params.put("itemNo", ben.getItemNo());
				params.put("groupedItemNo", ben.getGroupedItemNo());
				params.put("beneficiaryNo", ben.getBeneficiaryNo());
				this.sqlMapClient.delete("delGiclBeneficiaryDtl", params);
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLAccidentDtl pa : giclAccidentDtlSetRows) {
				log.info("Inserting item :"+pa.getItemNo()+" - "+pa.getItemTitle() );
				pa.setClaimId(claimId);
				//System.out.println(pa.getCpiBranchCd());
				this.sqlMapClient.insert("setGiclAccidentDtl", pa);
				params.put("itemNo", pa.getItemNo());
				params.put("itemDesc", pa.getItemDesc());
				params.put("itemDesc2", pa.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
					
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			this.getSqlMapClient().executeBatch();
			
			//inserting beneficiary info
			this.getSqlMapClient().executeBatch();
			for (GICLBeneficiary ben : giclItemBenSetRows) {
				log.info("Inserting beneficiary :"+ben.getBeneficiaryNo()+" - " +ben.getBeneficiaryName() );
				ben.setClaimId(claimId);
				this.sqlMapClient.insert("setGiclBeneficiaryDtl", ben);
			}

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("message", "SUCCESS");
		}catch (SQLException e) {
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			ExceptionHandler.logException(e);
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("Saving successful.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@Override
	public String getGroupedItemTitle(Map<String, Integer> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getGroupedItemTitle", params);
	}

	@Override
	//modified by kenneth SR20950 11.12.2015
	public String getAcBaseAmount(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getLossExpAcBaseAmount", params);
	}

}
