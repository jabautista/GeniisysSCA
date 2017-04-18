package com.geniisys.gipi.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIGenerateStatisticalReportsDAO;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIGenerateStatisticalReportsDAOImpl implements GIPIGenerateStatisticalReportsDAO{
	
	private Logger log = Logger.getLogger(GIPIGenerateStatisticalReportsDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getLineCds() throws SQLException{
		return (Map<String, Object>) this.sqlMapClient.queryForObject("getGIPIS901lineCds");
	}
	
	public Map<String, Object> getRecCntStatTab(Map<String, Object> params) throws SQLException{
		log.info("GIPIS901 Statistical tab before printing...");
		this.sqlMapClient.update("getRecCountStatTab", params);
		return params;
	}
	
	public Map<String, Object> extractRecordsMotorStat(Map<String, Object> params) throws SQLException{
		log.info("Extracting Motor Stat Records...");
		this.sqlMapClient.update("extractRecordsMotorStat", params);
		return params;
	}
	
	public String chkExistingRecordMotorStat(Map<String, Object> params) throws SQLException{
		log.info("Checking if records exists... PARAMS: "+params.toString());
		
		return (String) this.sqlMapClient.queryForObject("chkExistingRecMotorStat", params);
	}
	
	public Map<String, Object> extractFireStat(Map<String, Object> params) throws SQLException{
		log.info("Extracting records for Fire Stat..."+ params.toString());
		this.sqlMapClient.update("extractFireStat", params);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> computeFireTariffTotals(Map<String, Object> params) throws SQLException{
		log.info("Computing Fire Tariff Totals..");
		return (Map<String, Object>) this.sqlMapClient.queryForObject("computeFireTariffTotals", params);
	}
	
	public String getTrtyTypeCd(String commitAccumDistShare) throws SQLException{
		log.info("Retrieving trty_type_cd for distShare "+commitAccumDistShare);
		return (String) this.sqlMapClient.queryForObject("getTrtyTypeCdGipis901", commitAccumDistShare);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> computeFireZoneMasterTotals(Map<String, Object> params) throws SQLException{
		log.info("Computing Fire Zone Master Totals..");
		return (Map<String, Object>) this.sqlMapClient.queryForObject("computeFireZoneMasterTotals", params);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> computeFireZoneDetailTotals(Map<String, Object> params) throws SQLException{
		log.info("Computing Fire Zone Detail Totals..");
		return (Map<String, Object>) this.sqlMapClient.queryForObject("computeFireZoneDetailTotals", params);
	}
	
	public String getTrtyName(String commitAccumDistShare) throws SQLException{
		log.info("Retrieving trty_name for distShare "+commitAccumDistShare);
		return (String) this.sqlMapClient.queryForObject("getTrtyNameGipis901", commitAccumDistShare);
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> computeFireCATotals(Map<String, Object> params) throws SQLException{
		log.info("Computing Fire Comm Accum Totals..");
		return (Map<String, Object>) this.sqlMapClient.queryForObject("computeFireCommAccumTotals", params);
	}
	
	public Integer countFireStatExt(Map<String, Object> params) throws SQLException{
		log.info("Counting Fire Stat from table .." + params.toString());
		return (Integer) this.sqlMapClient.queryForObject("countFireStatExt", params);
	}
	
	public String chkRiskExtRecords(Map<String, Object> params) throws SQLException{
		log.info("Checking Risk Profile Extracted Records .." + params.toString());
		return (String) this.sqlMapClient.queryForObject("chkRiskExtRecords", params);
	}
	
	public Integer getTreatyCount(Map<String, Object> params) throws SQLException{
		log.info("GET TREATY COUNT "+params.toString());
		return (Integer) this.sqlMapClient.queryForObject("getTreatyCountGipis901", params);
	}
	
	public String extractRiskProfile(Map<String, Object> params) throws SQLException{
		String msg = "";
		try {			
			log.info("Extract Risk Profile records..."+params.toString());
			this.getSqlMapClient().queryForObject("extractRiskProfile", params);
			msg = "SUCCESS";
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}finally{
			log.info("Extracting Risk Profile done.");
			this.getSqlMapClient().endTransaction();
		}	
		
		return msg;
	}
	
	@SuppressWarnings("unchecked")
	public String saveRiskProfile(Map<String, Object> params) throws SQLException{
		String msg = "";
		int ctr = 0;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> setRows = (List<Map<String, Object>>) params.get("setRows");
			List<Map<String, Object>> delRows = (List<Map<String, Object>>) params.get("delRows");
			String detailSw = params.get("detailSw").toString();
			
			//List<Map<String, Object>> riskRows = (List<Map<String, Object>>) params.get("riskRows");
			System.out.println("userResponse before delete: " + params.get("userResponse"));
			// Apollo Cruz 10.21.2014 
			// transfered deleting of previous reocords to allow inserting of range for newly added risk
			if(setRows.size() > 0){
				System.out.println("res inside setrows: " + params.get("userResponse") + "setRows.size(): "+setRows.size()+
						" setRows.get(0).get(lineCd): "+setRows.get(0).get("lineCd"));
				if(setRows.get(0).get("lineCd") == null && params.get("userResponse").equals("Update") && params.get("isAddFromUpdate").equals("N")){
					setRows.get(0).put("userId", params.get("userId"));
					System.out.println("deleting records for update original!!!!!");
					this.getSqlMapClient().delete("deleteRiskProfilePrevRecs", setRows.get(0));
					this.getSqlMapClient().executeBatch();
				}
			}
			
			for(Map<String, Object> r: setRows){
				r.put("userId", params.get("userId"));
				r.put("userResponse", params.get("userResponse"));	//Gzelle 04012015
				r.put("isAddFromUpdate", params.get("isAddFromUpdate"));	//Gzelle 04072015
				System.out.println("userResponse : " + params.get("userResponse"));
				
				if (r.get("rangeFrom") != null) r.put("rangeFrom", new BigDecimal(r.get("rangeFrom").toString()));
				if (r.get("rangeTo") != null)  r.put("rangeTo", new BigDecimal(r.get("rangeTo").toString()));				
				
				if(detailSw.equals("N")){	// for parent table grid
					System.out.println(detailSw);
					if (ctr == 0){
						r.put("recordStatus", null);
					}					
				}else if(detailSw.equals("Y")){
					r.put("cond", "AND range_from IS NULL AND range_to IS NULL");
					
					if(r.get("sublineCd") == null){
						this.getSqlMapClient().delete("deleteRiskProfile1", r);
					} else if(r.get("sublineCd") != null){ 
						System.out.println(r.get("sublineCd"));
						this.getSqlMapClient().delete("deleteRiskProfile2", r);
					}
				}
				
				/*if(ctr == 0){
					if(r.get("recordStatus") == null && !r.get("lineCd").equals(r.get("prevLineCd"))){
						System.out.println(r.get("prevLineCd") + " ----");	
						
						if(r.get("prevSublineCd") == null){
							this.getSqlMapClient().delete("deleteRiskProfile1", r);
						} else if(r.get("prevSublineCd") != null){ 
							System.out.println(r.get("prevSublineCd"));
							this.getSqlMapClient().delete("deleteRiskProfile2", r);
						}
					}
				}else{
					r.put("recordStatus", 1);
				}*/
				
				log.info("Saving Risk Profile...."+r.toString());
				this.getSqlMapClient().insert("saveRiskProfileGipis901", r);
				ctr++;
			}					
			this.getSqlMapClient().executeBatch();	//Gzelle 042015 SR4136,4196,4285,4271
			
			for(Map<String, Object> r: delRows){
				r.put("userId", params.get("userId"));					
				if (r.get("prevLineCd") == null) r.put("prevLineCd", r.get("lineCd"));			
				if (r.get("prevSublineCd") == null) r.put("prevSublineCd", r.get("sublineCd"));

				if(detailSw.equals("N")){	
					log.info("Deleting Risk Profile 'Parent'...."+r.toString());		
					if(r.get("sublineCd") == null){
						this.getSqlMapClient().delete("deleteRiskProfile1", r);
					} else if(r.get("sublineCd") != null){ 
						System.out.println(r.get("sublineCd"));
						this.getSqlMapClient().delete("deleteRiskProfile2", r);
					}	
					this.getSqlMapClient().delete("deleteRelatedTableItem", r); //Gzelle 04012015
					this.getSqlMapClient().delete("deleteRelatedTableDtl", r); //Gzelle 04012015
				}else if(detailSw.equals("Y")){
					log.info("Deleting Risk Profile 'Range'...."+r.toString());	
					this.getSqlMapClient().delete("deleteRiskProfileRange", r);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			msg = "SUCCESS";
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			params.put("message", "ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("Saving Risk Profile done.");
			this.getSqlMapClient().endTransaction();
		}
		
		return msg;
	}
	@Override
	public Map<String, Object> checkFireStat(Map<String, Object> params)
			throws SQLException {
		log.info("Checking records for Fire Stat..."+ params.toString());
		this.sqlMapClient.update("checkFireStat", params);
		return params;
	}
	
	@Override	//Gzelle 03262015
	public Map<String, Object> valBeforeSave(Map<String, Object> params) throws SQLException {
		log.info("Checking exisiting records..."+ params.toString());
		this.getSqlMapClient().update("valBeforeSave", params);
		return params ;
	}
	
	@Override	//Gzelle 04072015
	public Map<String, Object> valAddUpdRec(Map<String, Object> params) throws SQLException {
		log.info("Checking exisiting records..."+ params.toString());
		this.getSqlMapClient().update("valAddUpdRec", params);
		return params ;
	}
	@Override
	public Map<String, Object> validateBeforeExtract(Map<String, Object> params) throws SQLException {//edgar 04/27/2015 FULL WEB SR 4322
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Validating records for Fire Stat..."+ params.toString());
			this.sqlMapClient.update("validateBeforeExtract", params);
			log.info("Validating records for Fire Stat after..."+ params.toString());
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();			
		}
		
		return params;
	}
}
