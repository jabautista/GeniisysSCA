package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.jfree.util.Log;

import com.geniisys.gicl.dao.GICLCasualtyDtlDAO;
import com.geniisys.gicl.dao.GICLClaimsDAO;
import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.dao.GICLMortgageeDAO;
import com.geniisys.gicl.entity.GICLCasualtyDtl;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;

public class GICLCasualtyDtlDAOImpl implements GICLCasualtyDtlDAO{
	
	private Logger log = Logger.getLogger(GICLCasualtyDtlDAOImpl.class);
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
	/**
	 * @author rey
	 * @date 09.01.2011
	 * casualty item info
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLCasualtyDtl> getCasualtyDtlList(
			HashMap<String, Object> params) throws SQLException {
		Log.info("Getting Casualty Detail..."); 
		return this.sqlMapClient.queryForList("getGiclCasualtyDtlGrid", params);
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
		this.sqlMapClient.update("validateClmItemNoCasualty", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveClmItemCasualty(Map<String, Object> params)
			throws SQLException {
		log.info("Start of saving Casualty Item information.");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<GICLCasualtyDtl> giclCasualtyDtlSetRows = (List<GICLCasualtyDtl>) params.get("giclCasualtyDtlSetRows");
			List<GICLCasualtyDtl> giclCasualtyDtlDelRows = (List<GICLCasualtyDtl>) params.get("giclCasualtyDtlDelRows");
			List<Map<String, Object>> giclPersonnelSetRow = (List<Map<String, Object>>) params.get("giclPersonnelSetRows");
			List<Map<String, Object>> giclPersonnelDelRows = (List<Map<String, Object>>) params.get("giclPersonnelDelRows");
			
			//deleting peril info
			this.giclItemPerilDAO.delGiclItemPeril(params);
			
			//deleting item info
			this.getSqlMapClient().executeBatch();
			for (GICLCasualtyDtl casualty:giclCasualtyDtlDelRows){
				
				// get attachments
				Map<String, Object> mParams = new HashMap<String, Object>();
				mParams.put("claimId", casualty.getClaimId());
				mParams.put("itemNo", casualty.getItemNo());
				List<String> attachments = this.giclClaimsDAO.getClaimItemAttachments(mParams);
				
				// delete attachments record
				this.giclClaimsDAO.deleteClaimItemAttachments(mParams);
				
				// delete file
				FileUtil.deleteFiles(attachments);
				
				params.put("claimId",casualty.getClaimId());
				params.put("itemNo", casualty.getItemNo());
				this.giclClaimsDAO.clmItemPreDelete(params);
				log.info("Deleting item :"+casualty.getItemNo()+" - "+casualty.getItemTitle());
				this.sqlMapClient.delete("delGiclCasualtyPersonnel",params);
				this.sqlMapClient.delete("delGiclCasualtyDtl", params);
				
			}
			
			//inserting item info
			this.getSqlMapClient().executeBatch();
			for (GICLCasualtyDtl casualty:giclCasualtyDtlSetRows){
				log.info("Inserting item :"+casualty.getItemNo()+" - "+casualty.getItemTitle());
				this.sqlMapClient.insert("setGiclCasualtyDtl", casualty);
				params.put("claimId",casualty.getClaimId());
				params.put("itemNo", casualty.getItemNo());
				params.put("itemDesc", StringFormatter.unescapeHtmlJava(casualty.getItemDesc()));  //added by steven 12/03/2012 -to unescape the special characters
				params.put("itemDesc2", StringFormatter.unescapeHtmlJava(casualty.getItemDesc2()));  //added by steven 12/03/2012 -to unescape the special characters
				//updating claim item
				this.giclClmItemDAO.updGiclClmItem(params);
			}
			
			// insert personnel
			this.getSqlMapClient().executeBatch();
			for (Map<String, Object> personnel:giclPersonnelSetRow){
				personnel.put("userId",params.get("userId"));
				//this.sqlMapClient.insert("setPersonnel",personnel);
				this.giclClmItemDAO.addPersonnel(personnel);
			}
			
			//delete personnel
			this.getSqlMapClient().executeBatch();
			for (Map<String, Object> personnel:giclPersonnelDelRows){
				personnel.put("userId",params.get("userId"));
				this.sqlMapClient.delete("deletePersonnel",personnel);
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
			log.info("End of saving Casualty Item information.");
			this.getSqlMapClient().endTransaction();
		}
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLCasualtyDtl> getPersonnelList(HashMap<String, Object> params)
			throws SQLException {
		Log.info("Getting Personnel List..."); 
		return this.sqlMapClient.queryForList("getPersonnelList", params);
	}

	@Override
	public String getCasualtyGroupedItemTitle(Map<String, Integer> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("getCasualtyGroupedItemTitle", params);
	}

	@Override
	public Map<String, Object> validateGroupItemNo(Map<String, Object> params)
			throws SQLException {
		
		log.info("validating group item number ");
		getSqlMapClient().update("validateGroupItemNo",params);
		
		return params;
	}

	@Override
	public Map<String, Object> validatePersonnelNo(Map<String, Object> params)
			throws SQLException {
		try{
			log.info("validating personnel no.");
			getSqlMapClient().update("validatePersonnelNo",params);
			
		}catch(SQLException e){
			throw e;
		}
		return params;
	}

/*	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePersonnel(Map<String, Object> params)
			throws SQLException {
		return (Map<String, Object>) this.sqlMapClient.queryForList("setPersonnel",params);		
	}*/
}
