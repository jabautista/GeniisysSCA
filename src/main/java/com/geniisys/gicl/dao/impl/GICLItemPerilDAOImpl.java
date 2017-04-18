package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gicl.dao.GICLItemPerilDAO;
import com.geniisys.gicl.entity.GICLItemPeril;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLItemPerilDAOImpl implements GICLItemPerilDAO{

	private Logger log = Logger.getLogger(GICLItemPerilDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient){
		this.sqlMapClient = sqlMapClient;
	}
	
	public SqlMapClient getSqlMapClient(){
		return this.sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GICLItemPeril> getGiclItemPerilGrid(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getGiclItemPerilGrid", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GICLItemPeril> getGiclItemPerilGrid2(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("getGiclItemPerilGrid2", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void setGiclItemPeril(Map<String, Object> params)
			throws SQLException {
		List<GICLItemPeril> giclItemPerilSetRows = (List<GICLItemPeril>) params.get("giclItemPerilSetRows");
		for (GICLItemPeril peril:giclItemPerilSetRows){
			log.info("Inserting peril :"+peril.getItemNo()+" - "+peril.getPerilCd()+" - "+peril.getDspPerilName()+" - "+peril.getGroupedItemNo());
			//this.sqlMapClient.insert("setGiclItemPeril", peril);					
			params.put("claimId", peril.getClaimId());
			params.put("itemNo", peril.getItemNo());
			params.put("perilCd", peril.getPerilCd());
			params.put("annTsiAmt", peril.getAnnTsiAmt());
			params.put("cpiRecNo", peril.getCpiRecNo());
			params.put("cpiBranchCd", peril.getCpiBranchCd());
			params.put("motshopTag", peril.getMotshopTag());
			params.put("lossCatCd", peril.getLossCatCd());
			params.put("lineCd", params.get("lineCd")); //changed by robert 10.01.2013 from peril.getLineCd());
			params.put("closeDate", peril.getCloseDate());
			params.put("closeFlag", peril.getCloseFlag());
			params.put("closeFlag2", peril.getCloseFlag2());
			params.put("closeDate2", peril.getCloseDate2());
			params.put("aggregateSw", peril.getAggregateSw());
			params.put("allowTsiAmt", peril.getAllowTsiAmt());
			params.put("baseAmt", peril.getBaseAmt());
			params.put("noOfDays", peril.getNoOfDays());
			params.put("allowNoOfDays", peril.getAllowNoOfDays());

			//params.put("groupedItemNo", params.get("groupedItemNo")); comment out by Gzelle 05.21.2013 - replaced with codes below
			/*comment out and replaced by the below codes by MAC 11/07/2013.
			if (params.get("lineCd").equals("MC") || params.get("lineCd").equals("CA")) { //added CA by robert 10.01.2013	
				log.info("LINE CD: " + params.get("lineCd") + " with GRP ITEM NO: " + peril.getGroupedItemNo());
				params.put("groupedItemNo", peril.getGroupedItemNo());
			} else {
				System.out.println("LINE CD: " + params.get("lineCd") + " with GRP ITEM NO: " + params.get("groupedItemNo"));
				params.put("groupedItemNo", params.get("groupedItemNo"));
			}*/
			//use peril.getGroupedItemNo() in getting Grouped Item Number for all lines to prevent ORA-01407 when saving peril info with null Grouped Item Number by MAC 11/07/2013.
			log.info("LINE CD: " + params.get("lineCd") + " with GRP ITEM NO: " + peril.getGroupedItemNo());
			params.put("groupedItemNo", peril.getGroupedItemNo());

			System.out.println("setGiclItemPeril params: "+params);
			this.sqlMapClient.insert("setGiclItemPeril", params);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public void delGiclItemPeril(Map<String, Object> params)
			throws SQLException {
		List<GICLItemPeril> giclItemPerilDelRows = (List<GICLItemPeril>) params.get("giclItemPerilDelRows");
		for (GICLItemPeril peril:giclItemPerilDelRows){
			params.put("itemNo", peril.getItemNo());
			params.put("perilCd", peril.getPerilCd());
			log.info("Deleting peril :"+peril.getItemNo()+" - "+peril.getPerilCd()+" - "+peril.getDspPerilName());
			this.sqlMapClient.delete("delGiclItemPeril2", params);
		}
	}

	@Override
	public Map<String, Object> checkAggPeril(Map<String, Object> params)
			throws SQLException {
		System.out.println(params);
		log.info("validating peril...");
		this.sqlMapClient.update("checkAggPeril", params);
		System.out.println(params);
		return params;
	}

	@Override
	public String getGiclItemPerilDfltPayee(Map<String, Object> params)
			throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getGiclItemPerilDfltPayee", params);
	}

	@Override
	public Map<String, Object> checkPerilStatus(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkPerilStatusGICLS024", params);
		System.out.println("checkPerilStatus result: "+params);
		return params;
	}

	@Override
	public GICLItemPeril getGICLS024ItemPeril(Integer claimId)
			throws SQLException {
		return (GICLItemPeril) this.getSqlMapClient().queryForObject("getGICLS024ItemPeril", claimId);
	}

	@Override
	public Integer checkIfGroupGICLS024(Integer claimId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("checkIfGroupGICLS024",claimId);
	}



}
