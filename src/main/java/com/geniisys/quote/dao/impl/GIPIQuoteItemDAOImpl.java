package com.geniisys.quote.dao.impl;

import java.math.BigDecimal;
import java.math.MathContext;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.entity.GIPIQuoteDeductibles;
import com.geniisys.quote.dao.GIPIQuoteItemDAO;
import com.geniisys.quote.entity.GIPIDeductibles;
import com.geniisys.quote.entity.GIPIQuoteACItem;
import com.geniisys.quote.entity.GIPIQuoteAVItem;
import com.geniisys.quote.entity.GIPIQuoteCAItem;
import com.geniisys.quote.entity.GIPIQuoteCargo;
import com.geniisys.quote.entity.GIPIQuoteENItem;
import com.geniisys.quote.entity.GIPIQuoteFIItem;
import com.geniisys.quote.entity.GIPIQuoteItem;
import com.geniisys.quote.entity.GIPIQuoteItemMC;
import com.geniisys.quote.entity.GIPIQuoteItmmortgagee;
import com.geniisys.quote.entity.GIPIQuoteItmperil;
import com.geniisys.quote.entity.GIPIQuoteMHItem;
import com.geniisys.quote.entity.GIPIQuoteWc;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIPIQuoteItemDAOImpl implements GIPIQuoteItemDAO{
	
private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIQuoteItemDAOImpl.class);

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveAllQuotationInformation(Map<String, Object> params)
			throws SQLException {
		List<GIPIQuoteItem> setItemRows = (List<GIPIQuoteItem>) params.get("setItemRows");
		List<GIPIQuoteItem> newItemRows = (List<GIPIQuoteItem>) params.get("newItemRows");
		List<GIPIQuoteItem> delItemRows = (List<GIPIQuoteItem>) params.get("delItemRows");
		List<GIPIQuoteItmperil> setPerilRows = (List<GIPIQuoteItmperil>) params.get("setPerilRows");
		List<GIPIQuoteItmperil> delPerilRows = (List<GIPIQuoteItmperil>) params.get("delPerilRows");

		List<GIPIQuoteItmmortgagee> setMortgageeRows = (List<GIPIQuoteItmmortgagee>) params.get("setMortgageeRows");		
		List<GIPIQuoteItmmortgagee> delMortgageeRows = (List<GIPIQuoteItmmortgagee>) params.get("delMortgageeRows");
		
		List<GIPIQuoteWc> setWarrantyRows = (List<GIPIQuoteWc>) params.get("setWarrantyRows");
		List<GIPIDeductibles> setDeductibleRows = (List<GIPIDeductibles>) params.get("setDeductibleRows");
		List<GIPIDeductibles> delDeductibleRows = (List<GIPIDeductibles>) params.get("delDeductibleRows");
		
		//item deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		List<GIPIQuoteDeductibles> setItemDeductibleRows = (List<GIPIQuoteDeductibles>) params.get("setItemDeductibleRows");
		List<GIPIQuoteDeductibles> delItemDeductibleRows = (List<GIPIQuoteDeductibles>) params.get("delItemDeductibleRows");
		List<GIPIQuoteDeductibles> setPerilDeductibleRows = (List<GIPIQuoteDeductibles>) params.get("setPerilDeductibleRows");
		List<GIPIQuoteDeductibles> delPerilDeductibleRows = (List<GIPIQuoteDeductibles>) params.get("delPerilDeductibleRows");
		
		String lineCd = (String) params.get("lineCd");
		String addtlInfo = (String) params.get("addtlInfo"); //robert 9.28.2012
		
		String delPolicyLevel = (String) params.get("delPolicyLevel"); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		Integer quoteId = (Integer) params.get("quoteId"); //nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			for (GIPIQuoteItem quoteItem : delItemRows){
				log.info("Deleting GIPIQuoteItem...");
				Map<String, Object> params2 = new HashMap<String, Object>();
				params2.put("quoteId", quoteItem.getQuoteId());
				params2.put("itemNo", quoteItem.getItemNo());
				params2.put("currencyCd", quoteItem.getCurrencyCd() );
				this.getSqlMapClient().delete("deleteQuoteItemAddl", params2);
			}			
			this.sqlMapClient.executeBatch();
			
			for (GIPIQuoteItem quoteItem : setItemRows){
				log.info("Inserting/Updating GIPIQuoteItem...");
				this.getSqlMapClient().insert("setGipiQuoteItem3", quoteItem);
			}
			this.sqlMapClient.executeBatch();
			
			for (GIPIQuoteItmperil del:delPerilRows){
				log.info("DELETING: "+ del);
				this.getSqlMapClient().delete("deleteGIIMM002PerilInfo", del);
			}
			this.sqlMapClient.executeBatch();
			
			for (GIPIQuoteItmperil set:setPerilRows){
				log.info("INSERTING: "+ set);
				if(set.getPerilPremRt().signum() == 0){ //robert 11.11.2013
					set.setPerilPremRt(new BigDecimal(0));
				}
				this.getSqlMapClient().insert("setGIIMM002PerilInfo", set);
			}
			this.sqlMapClient.executeBatch();
			
			for(GIPIQuoteItmmortgagee set:setMortgageeRows){
				log.info("INSERTING: "+ set);
				this.getSqlMapClient().insert("setMortgagee", set);
			} 
			
			for (GIPIQuoteWc set:setWarrantyRows){
				log.info("INSERTING: "+ set);
				this.getSqlMapClient().insert("setGIIMM002Warranties", set);
			}
			this.sqlMapClient.executeBatch();
			
			for (GIPIQuoteItem quoteItem : setItemRows){
				log.info("Post Commit GIPIQuoteItem...");
				this.getSqlMapClient().insert("postCommitQuoteItem", quoteItem);
				this.getSqlMapClient().insert("setGiimm002Invoice", quoteItem);
			}
			this.sqlMapClient.executeBatch();
			
			for(GIPIQuoteItmmortgagee del: delMortgageeRows){
				log.info("DELETING: "+del);
				this.getSqlMapClient().delete("deleteMortgagee",del);
			}
			this.sqlMapClient.executeBatch();
			
			for(GIPIDeductibles del:delDeductibleRows){
				log.info("DELETING: "+del);
				this.getSqlMapClient().delete("deleteDeductibleInfoGIIMM002", del);
			}

			for(GIPIDeductibles set:setDeductibleRows){
				log.info("INSERTING: "+set);
				BigDecimal bdDedRate = set.getDeductibleRt(); //Added by Jerome 11.18.2016 SR 5737
				
				if (bdDedRate != null) {
					Double doubleDedRate = bdDedRate.doubleValue();
					BigDecimal newDedRate = new BigDecimal(doubleDedRate, MathContext.DECIMAL64);
	
					set.setDeductibleRt(newDedRate);
				}
				this.getSqlMapClient().insert("setDeductibleInfoGIIMM002", set);
			}
			
			//item deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			for(GIPIQuoteDeductibles del:delItemDeductibleRows){
				log.info("DELETING: "+del);
				this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles3", del);
			}
			
			//item deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			for(GIPIQuoteDeductibles set:setItemDeductibleRows){
				log.info("INSERTING: "+set);
				BigDecimal bdDedRate = set.getDeductibleRate(); //Added by Jerome 11.18.2016 SR 5737
				
				if (bdDedRate != null){
				Double doubleDedRate = bdDedRate.doubleValue();
				BigDecimal newDedRate = new BigDecimal(doubleDedRate, MathContext.DECIMAL64);

				set.setDeductibleRate(newDedRate);
				}
				this.getSqlMapClient().insert("saveGIPIQuoteDeductibles", set);
			}
			
			//peril deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			for(GIPIQuoteDeductibles del:delPerilDeductibleRows){
				log.info("DELETING: "+del);
				this.getSqlMapClient().delete("deleteGIPIQuoteDeductibles3", del);
			}
			
			//peril deductible - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			for(GIPIQuoteDeductibles set:setPerilDeductibleRows){
				log.info("INSERTING: "+set);
				BigDecimal bdDedRate = set.getDeductibleRate(); //Added by Jerome 11.07.2016 SR 5737
				
				if (bdDedRate != null){ //benjo 01.13.2017 SR-23620
					Double doubleDedRate = bdDedRate.doubleValue();
					BigDecimal newDedRate = new BigDecimal(doubleDedRate, MathContext.DECIMAL64);
	
					set.setDeductibleRate(newDedRate);
				}
				this.getSqlMapClient().insert("saveGIPIQuoteDeductibles", set);
			}
			
			this.sqlMapClient.executeBatch();
			
			//delete policy level deductibles - nieko 02172016 UW-SPECS-2015-086 Quotation Deductibles
			if(delPolicyLevel.equals("Y")){
				this.getSqlMapClient().delete("deleteQuoteDeductiblesBaseTSI", quoteId);
			}
			
			if(addtlInfo.equals("Y")){ //robert 9.28.2012
				insertAdditionalInformation(params.get("setAIRows"), lineCd);
			}
			this.sqlMapClient.executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	private void insertAdditionalInformation(Object setRows, String lineCd) throws SQLException{
		log.info("Insert Additional Information...");
		if("AV".equals(lineCd)){
			List<GIPIQuoteAVItem> setList = (List<GIPIQuoteAVItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR AVIATION LINE...");
			for(GIPIQuoteAVItem av: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteAVItem", av);
			}
		}else if("CA".equals(lineCd)){
			List<GIPIQuoteCAItem> setList = (List<GIPIQuoteCAItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR CASUALTY LINE...");
			for(GIPIQuoteCAItem ca: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteCAItem", ca);
			}
		}else if("EN".equals(lineCd)){
			List<GIPIQuoteENItem> setList = (List<GIPIQuoteENItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR ENGINEERING LINE...");
			for(GIPIQuoteENItem en: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteENItem", en);
			}
		}else if("MH".equals(lineCd)){
			List<GIPIQuoteMHItem> setList = (List<GIPIQuoteMHItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MARINE HULL LINE...");
			for(GIPIQuoteMHItem mh: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteMHItem", mh);
			}
		}else if("MN".equals(lineCd)){
			List<GIPIQuoteCargo> setList = (List<GIPIQuoteCargo>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MARINE CARGO LINE...");
			for(GIPIQuoteCargo mn: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteMNItem", mn);
			}
		}else if("AC".equals(lineCd) || "PA".equals(lineCd)){
			List<GIPIQuoteACItem> setList = (List<GIPIQuoteACItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR ACCIDENT LINE...");
			for(GIPIQuoteACItem ac: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteACItem", ac);
			}
		}else if("MC".equals(lineCd)){
			List<GIPIQuoteItemMC> setList = (List<GIPIQuoteItemMC>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR MOTOR CAR LINE...");
			for(GIPIQuoteItemMC mc: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteMCItem", mc);
			}
		}else if("FI".equals(lineCd)){
			List<GIPIQuoteFIItem> setList = (List<GIPIQuoteFIItem>) setRows;
			log.info("INSERTING ADDITIONAL INFO FOR FIRE LINE...");
			for(GIPIQuoteFIItem fi: setList){
				this.getSqlMapClient().insert("saveGIPIQuoteFIItem", fi);
			}
		}
	}

	@Override
	public Integer getMaxQuoteItemNo(Integer quoteId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getMaxQuoteItemNo", quoteId);
	}

}
