/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLMotorCarDtlDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 24, 2011
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.dao.GICLMotorCarDtlDAO;
import com.geniisys.gicl.entity.GICLMcTpDtl;
import com.geniisys.gicl.entity.GICLMotorCarDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLMotorCarDtlDAOImpl implements GICLMotorCarDtlDAO{
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLMotorCarDtlDAOImpl.class);
	private GICLClaimsDAO giclClaimsDAO;
	private GICLClmItemDAO giclClmItemDAO;
	private GICLMortgageeDAO giclMortgageeDAO;
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

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveMcTpDtl(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Integer claimId = Integer.parseInt((String) params.get("claimId"));
			Integer itemNo = Integer.parseInt((String) params.get("itemNo"));
			List<GICLMcTpDtl>setRows  = (List<GICLMcTpDtl>) params.get("setRows");
			List<GICLMcTpDtl>delRows = (List<GICLMcTpDtl>) params.get("delRows");
			List<GICLMcTpDtl>modRows = (List<GICLMcTpDtl>) params.get("modRows");
			
			log.info("PROCESSING McTpDTL for Claim Id "+claimId );
			log.info("Item No: "+itemNo);
			System.out.println(delRows.size());
			System.out.println(setRows.size());
			log.info("Deleting records.");
			for (GICLMcTpDtl giclMcTpDtl : delRows) {
				giclMcTpDtl.setItemNo(itemNo);
				giclMcTpDtl.setClaimId(claimId);
				System.out.println(giclMcTpDtl.getPayeeNo());
				System.out.println(giclMcTpDtl.getPayeeClassCd());
				this.getSqlMapClient().delete("deleteMcTpDtl", giclMcTpDtl);
			}
			
			log.info("updating records");
			
			for (GICLMcTpDtl giclMcTpDtl : modRows) {
				giclMcTpDtl.setItemNo(itemNo);
				giclMcTpDtl.setClaimId(claimId);
				System.out.println("old class cd: "+giclMcTpDtl.getPayeeClassCd());
				System.out.println("new class cd: "+giclMcTpDtl.getNewPayeeClassCd());
				System.out.println("old: "+giclMcTpDtl.getPayeeNo());
				System.out.println("new: "+giclMcTpDtl.getNewPayeeNo());
				this.getSqlMapClient().update("updateMcTpDtl", giclMcTpDtl);
			}
			
			log.info("INSERTING records.");
			for (GICLMcTpDtl giclMcTpDtl : setRows) {
				giclMcTpDtl.setItemNo(itemNo);
				giclMcTpDtl.setClaimId(claimId);
				this.getSqlMapClient().delete("saveMcTpDtl", giclMcTpDtl);
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public Map<String, Object> validateClmItemNo(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateClmItemNoMotorCar", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemMotorCar(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Saving motor car item info claim id:"+params.get("claimId"));
			Integer claimId = Integer.parseInt((String) params.get("claimId"));
			List<GICLMotorCarDtl> giclMotorCarDtlSetRows = (List<GICLMotorCarDtl>) params.get("giclMotorCarDtlSetRows");
			List<GICLMotorCarDtl> giclMotorCarDtlDelRows = (List<GICLMotorCarDtl>) params.get("giclMotorCarDtlDelRows");
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLMotorCarDtl mc:giclMotorCarDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", mc.getClaimId());
				mParams.put("itemNo", mc.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("itemNo", mc.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+mc.getItemNo()+" - "+mc.getItemTitle());
				this.sqlMapClient.delete("delGiclMotorCarDtl", params);
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLMotorCarDtl mc : giclMotorCarDtlSetRows) {
				log.info("Inserting item :"+mc.getItemNo()+" - "+mc.getItemTitle());
				mc.setClaimId(claimId);
				this.sqlMapClient.insert("setGiclMotorCarDtl", mc);
				params.put("itemNo", mc.getItemNo());
				params.put("itemDesc", mc.getItemDesc());
				params.put("itemDesc2", mc.getItemDesc2());
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			//inserting peril info
			this.getSqlMapClient().executeBatch();
			this.giclItemPerilDAO.setGiclItemPeril(params);
			
			//for mortgagee info
			this.getSqlMapClient().executeBatch();
			//this.giclMortgageeDAO.setClmItemMortgagee(params);
			/*giclMotorCarDtlDelRows.addAll(giclMotorCarDtlSetRows);
			for (GICLMotorCarDtl mort : giclMotorCarDtlDelRows) {
				params.put("itemNo", mort.getItemNo());
				this.sqlMapClient.delete("delGiclMortgagee", params);
				this.sqlMapClient.insert("insertClaimMortgagee", params);
			}*/
			
			for (GICLMotorCarDtl mort : giclMotorCarDtlSetRows) {
				params.put("itemNo", mort.getItemNo());
				log.info("Deleting/Inserting mortgagee : "+params);
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

	@Override
	public String getTowAmount(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getTowAmount", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getGICLS268MotorCarDetail(Map<String, String> params)
			throws SQLException {
		
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getGICLS268VehicleInfo", params);
		//return null;
	}

	@Override
	public GICLMcTpDtl getGICLS260McTpOtherDtls(Map<String, Object> params)
			throws SQLException {
		return (GICLMcTpDtl) this.getSqlMapClient().queryForObject("getGICLS260McTpOtherDtls", params);
	}
}
