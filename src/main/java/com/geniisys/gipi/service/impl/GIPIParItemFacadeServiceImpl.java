/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIParItemDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.service.GIPIParItemFacadeService;


/**
 * The Class GIPIParItemFacadeServiceImpl.
 */
public class GIPIParItemFacadeServiceImpl implements GIPIParItemFacadeService {

	/** The gipi par item dao. */
	private GIPIParItemDAO gipiParItemDAO;
	private static Logger log = Logger.getLogger(GIPIParItemFacadeServiceImpl.class);
	
	/**
	 * Gets the gipi par item dao.
	 * 
	 * @return the gipi par item dao
	 */
	public GIPIParItemDAO getGipiParItemDAO() {
		return gipiParItemDAO;
	}

	/**
	 * Sets the gipi par item dao.
	 * 
	 * @param gipiParItemDAO the new gipi par item dao
	 */
	public void setGipiParItemDAO(GIPIParItemDAO gipiParItemDAO) {
		this.gipiParItemDAO = gipiParItemDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteAllGIPIParItem(int)
	 */
	@Override
	public void deleteAllGIPIParItem(int parId) throws SQLException {
		this.getGipiParItemDAO().deleteAllGIPIParItem(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteGIPIParItem(int, int)
	 */
	@Override
	public void deleteGIPIParItem(int parId, int itemNo) throws SQLException {
		this.getGipiParItemDAO().deleteGIPIParItem(parId, itemNo);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteGIPIEndtParItem(int, int)
	 */
	@Override
	public void deleteGIPIEndtParItem(int parId, int itemNo) throws SQLException {
		this.getGipiParItemDAO().deleteGIPIEndtParItem(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#saveGIPIParItem(com.geniisys.gipi.entity.GIPIItem)
	 */
	@Override
	public void saveGIPIParItem(GIPIItem parItem) throws SQLException {
		this.getGipiParItemDAO().saveGIPIParItem(parItem);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#saveGIPIParItem(java.util.Map)
	 */
	@Override
	public void saveGIPIParItem(Map<String, Object> itemParam)
			throws SQLException {		
		//String[] lineCds			= (String[]) itemParam.get("lineCds");
		//String[] sublineCds			= (String[]) itemParam.get("sublineCds");
		String[] parIds				= (String[]) itemParam.get("parIds");
		String[] itemNos			= (String[]) itemParam.get("itemNos");
		String[] itemTitles			= (String[]) itemParam.get("itemTitles");
		String[] itemGrps			= (String[]) itemParam.get("itemGrps");
		String[] itemDescs			= (String[]) itemParam.get("itemDescs");
		String[] itemDesc2s			= (String[]) itemParam.get("itemDesc2s");
		String[] tsiAmts			= (String[]) itemParam.get("tsiAmts");
		String[] premAmts			= (String[]) itemParam.get("premAmts");
		String[] annPremAmts		= (String[]) itemParam.get("annPremAmts");
		String[] annTsiAmts			= (String[]) itemParam.get("annTsiAmts");
		String[] recFlags			= (String[]) itemParam.get("recFlags");
		String[] currencyCds		= (String[]) itemParam.get("currencyCds");
		String[] currencyRts		= (String[]) itemParam.get("currencyRts");
		String[] groupCds			= (String[]) itemParam.get("groupCds");
		String[] fromDates			= (String[]) itemParam.get("fromDates");
		String[] toDates			= (String[]) itemParam.get("toDates");
		String[] packLineCds		= (String[]) itemParam.get("packLineCds");
		String[] packSublineCds		= (String[]) itemParam.get("packSublineCds");
		String[] discountSws		= (String[]) itemParam.get("discountSws");
		String[] coverageCds		= (String[]) itemParam.get("coverageCds");
		String[] otherInfos			= (String[]) itemParam.get("otherInfos");
		String[] surchargeSws		= (String[]) itemParam.get("surchargeSws");
		String[] regionCds			= (String[]) itemParam.get("regionCds");
		String[] changedTags		= (String[]) itemParam.get("changedTags");
		String[] prorateFlags		= (String[]) itemParam.get("prorateFlags");
		String[] compSws			= (String[]) itemParam.get("compSws");
		String[] shortRtPercents	= (String[]) itemParam.get("shortRtPercents");
		String[] packBenCds			= (String[]) itemParam.get("packBenCds");
		String[] paytTermss			= (String[]) itemParam.get("paytTermss");
		String[] riskNos			= (String[]) itemParam.get("riskNos");
		String[] riskItemNos		= (String[]) itemParam.get("riskItemNos");

		// delete all items
		// this.getGipiParItemDAO().deleteAllGIPIParItem(Integer.parseInt(parIds[0]));

		// save items
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		List<GIPIItem> items = new ArrayList<GIPIItem>();
		for (int i = 0; i < itemNos.length; i++) {
			// pre-insert in forms has been moved to the database			
			try{
				//System.out.println("Item Nos:" + itemNos.length);
				items.add(new GIPIItem(
						Integer.parseInt(parIds[i]), 
						Integer.parseInt(itemNos[i]),
						itemTitles[i], 
						itemGrps == null ? null : itemGrps[i],
						itemDescs[i], 
						itemDesc2s[i],
						tsiAmts == null ? null :  new BigDecimal(tsiAmts[i])/*tsiAmt*/,
						premAmts == null ? null : new BigDecimal(premAmts[i]) /*premAmt*/,
						annPremAmts == null ? null : new BigDecimal(annPremAmts[i])/*annPremAmt*/,
						annTsiAmts == null ? null : new BigDecimal(annTsiAmts[i])/*annTsiAmt*/,
						recFlags[i],						
						Integer.parseInt(currencyCds[i]),						
						new BigDecimal(currencyRts[i]), 
						groupCds == null ? null : groupCds[i]/*groupCd*/,
						(fromDates[i] == null || fromDates[i] == "" ? null :sdf.parse(fromDates[i])),//sdf.parse(fromDates[i]),
						(toDates[i] == null || toDates[i] == "" ? null :sdf.parse(toDates[i])),//sdf.parse(toDates[i]),
						packLineCds == null ? null : packLineCds[i], 
						packSublineCds == null ? null : packSublineCds[i],
						discountSws[i] == null || discountSws[i] == "" ? "N" : discountSws[i]/*discountSw*/,
						coverageCds[i],
						otherInfos == null ? null : otherInfos[i]/*otherInfo*/,
						surchargeSws[i] == null || surchargeSws[i] == "" ? "N" : surchargeSws[i]/*surchargeSw*/,
						regionCds[i],
						changedTags == null ? null : changedTags[i]/*changedTag*/,
						prorateFlags == null ? null : prorateFlags[i]/*prorateFlag*/,
						compSws == null ? null : compSws[i]/*compSw*/,
						(shortRtPercents[i] == "" || shortRtPercents[i] == null || shortRtPercents[i].equals("") || shortRtPercents[i].equals(null))? null : new BigDecimal(shortRtPercents[i])/*shortRtPercent*/,
						packBenCds == null ? null : packBenCds[i]/*packBenCd*/,
						paytTermss == null ? null : paytTermss[i]/*paytTerms*/,
						riskNos[i],
						riskItemNos[i]));				
			} catch(ParseException e){
				e.printStackTrace();
				log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			}			
		}
		this.getGipiParItemDAO().setGIPIParItem(items);
		// call post delete based on oracle forms firing sequence
		this.getGipiParItemDAO().postDeleteGIPIWItem(Integer.parseInt(parIds[0]), (String)itemParam.get("lineCd")/*lineCds[0]*/, (String)itemParam.get("sublineCd")/*sublineCds[0]*/);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteGIPIParItem(java.util.Map)
	 */
	@Override
	public void deleteGIPIParItem(Map<String, Object> itemParam)
			throws SQLException {
		String[] parIds = (String[]) itemParam.get("parIds");
		String[] itemNos = (String[]) itemParam.get("itemNos");
		
		List<GIPIItem> items = new ArrayList<GIPIItem>();
		for (int i = 0; i < itemNos.length; i++) {			
			items.add(new GIPIItem(
					Integer.parseInt(parIds[i]),
					Integer.parseInt(itemNos[i]),
					null,
					null, null, null, null,
					null, null, null, null,
					0, null, null, null,
					null, null, null, null,
					null, null, null, null,
					null, null, null, null,
					null, null, null, null));			
		}
		this.getGipiParItemDAO().delGIPIParItem(items);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteGIPIEndtParItem(java.util.Map)
	 */
	@Override
	public void deleteGIPIEndtParItem(Map<String, Object> itemParam)
			throws SQLException {
		String[] parIds = (String[]) itemParam.get("parIds");
		String[] itemNos = (String[]) itemParam.get("itemNos");
		
		List<GIPIItem> items = new ArrayList<GIPIItem>();
		for (int i = 0; i < itemNos.length; i++) {			
			items.add(new GIPIItem(
					Integer.parseInt(parIds[i]),
					Integer.parseInt(itemNos[i]),
					null,
					null, null, null, null,
					null, null, null, null,
					0, null, null, null,
					null, null, null, null,
					null, null, null, null,
					null, null, null, null,
					null, null, null, null));			
		}
		this.getGipiParItemDAO().delGIPIEndtParItem(items);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#confirmCopyItemPerilInfo(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyItemPerilInfo(Integer parId, String lineCd,
			String sublineCd) throws SQLException {
		return this.getGipiParItemDAO().confirmCopyItemPerilInfo(parId, lineCd,
				sublineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deletePolDeductibles(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public void deletePolDeductibles(Integer parId, String lineCd,
			String sublineCd) throws SQLException {
		this.getGipiParItemDAO().deletePolDeductibles(parId, lineCd, sublineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#confirmRenumber(int)
	 */
	@Override
	public String confirmRenumber(int parId) throws SQLException {
		return this.getGipiParItemDAO().confirmRenumber(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#renumber(int)
	 */
	@Override
	public void renumber(int parId) throws SQLException {
		this.getGipiParItemDAO().renumber(parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#confirmAssignDeductibles(int, int)
	 */
	@Override
	public String confirmAssignDeductibles(int parId, int itemNo)
			throws SQLException {		
		return this.getGipiParItemDAO().confirmAssignDeductibles(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#assignDeductibles(int, int)
	 */
	@Override
	public void assignDeductibles(int parId, int itemNo) throws SQLException {		
		this.getGipiParItemDAO().assignDeductibles(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#confirmCopyItem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyItem(Integer parId, String lineCd, String sublineCd)
			throws SQLException {		
		return this.getGipiParItemDAO().confirmCopyItem(parId, lineCd, sublineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#checkIfDiscountExists(int)
	 */
	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {		
		return this.getGipiParItemDAO().checkIfDiscountExists(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#getMaxWItemNo(int)
	 */
	@Override
	public int getMaxWItemNo(int parId) throws SQLException {		
		return this.getGipiParItemDAO().getMaxWItemNo(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#copyItem(int, int, int)
	 */
	@Override
	public void copyItem(int parId, int itemNo, int newItemNo) throws SQLException {		
		this.getGipiParItemDAO().copyItem(parId, itemNo, newItemNo);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#copyAdditionalInfoMC(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoMC(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		this.getGipiParItemDAO().copyAdditionalInfoMC(parId, itemNo, newItemNo, lineCd, sublineCd);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteItemDeductible(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void deleteItemDeductible(int parId, int itemNo, String lineCd,
			String sublineCd) throws SQLException {
		this.getGipiParItemDAO().deleteItemDeductible(parId, itemNo, lineCd, sublineCd);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#copyItemPeril(int, int, int)
	 */
	@Override
	public void copyItemPeril(int parId, int itemNo, int newItemNo)
			throws SQLException {
		this.getGipiParItemDAO().copyItemPeril(parId, itemNo, newItemNo);
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#checkGIPIWItem(int, int, int)
	 */
	@Override
	public String checkGIPIWItem(int checkBoth, int parId, int itemNo)
			throws SQLException {		
		return this.getGipiParItemDAO().checkGIPIWItem(checkBoth, parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#insertParhist(int, java.lang.String)
	 */
	@Override
	public void insertParhist(int parId, String userName) throws SQLException {
		this.getGipiParItemDAO().insertParhist(parId, userName);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteDiscount(int)
	 */
	@Override
	public void deleteDiscount(int parId) throws SQLException {
		this.getGipiParItemDAO().deleteDiscount(parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#updateGIPIWPackLineSubline(int, java.lang.String, java.lang.String)
	 */
	@Override
	public void updateGIPIWPackLineSubline(int parId, String packLineCd,
			String packSublineCd) throws SQLException {		
		this.getGipiParItemDAO().updateGIPIWPackLineSubline(parId, packLineCd, packSublineCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteCoInsurer(int)
	 */
	@Override
	public void deleteCoInsurer(int parId) throws SQLException {
		this.getGipiParItemDAO().deleteCoInsurer(parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteBill(int)
	 */
	@Override
	public void deleteBill(int parId) throws SQLException {
		this.getGipiParItemDAO().deleteBill(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#changeItemGroup(int, java.lang.String)
	 */
	@Override
	public void changeItemGroup(int parId, String packPolFlag)
			throws SQLException {
		this.getGipiParItemDAO().changeItemGroup(parId, packPolFlag);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#addParStatusNo(int, java.lang.String, int, java.lang.String, java.lang.String)
	 */
	@Override
	public Map<String, Object> addParStatusNo(int parId, String lineCd, int parStatus,
			String invoiceSw, String issCd) throws SQLException {		
		return this.getGipiParItemDAO().addParStatusNo(parId, lineCd, parStatus, invoiceSw, issCd);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#updateGipiWPolbasNoOfItem(int)
	 */
	@Override
	public void updateGipiWPolbasNoOfItem(int parId) throws SQLException {		
		this.getGipiParItemDAO().updateGipiWPolbasNoOfItem(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#checkAdditionalInfoMC(int)
	 */
	@Override
	public String checkAdditionalInfoMC(int parId) throws SQLException {		
		return this.getGipiParItemDAO().checkAdditionalInfoMC(parId);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#checkAdditionalInfoFI(int)
	 */
	@Override
	public String checkAdditionalInfoFI(int parId) throws SQLException {		
		return this.getGipiParItemDAO().checkAdditionalInfoFI(parId);
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#getMaxRiskItemNo(int, int)
	 */
	@Override
	public int getMaxRiskItemNo(int parId, int riskNo) throws SQLException {		
		return this.getGipiParItemDAO().getMaxRiskItemNo(parId, riskNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#getMaxEndtParItemNo(int)
	 */
	@Override
	public int getMaxEndtParItemNo(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().getMaxEndtParItemNo(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#confirmCopyEndtParItem(java.lang.Integer, java.lang.String, java.lang.String)
	 */
	@Override
	public String confirmCopyEndtParItem(Integer parId, String lineCd,
			String sublineCd) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().confirmCopyEndtParItem(parId, lineCd, sublineCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#copyAdditionalInfoMCEndt(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoMCEndt(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		// TODO Auto-generated method stub
		this.getGipiParItemDAO().copyAdditionalInfoMCEndt(parId, itemNo, newItemNo, lineCd, sublineCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#validateNegateItem(int, int)
	 */
	@Override
	public String validateNegateItem(int parId, int itemNo) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().validateNegateItem(parId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#checkBackEndtBeforeDelete(int, int)
	 */
	@Override
	public String checkBackEndtBeforeDelete(int parId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().checkBackEndtBeforeDelete(parId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#extractExpiry(int)
	 */
	@Override
	public Date extractExpiry(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().extractExpiry(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#deleteDiscount2(int)
	 */
	@Override
	public void deleteDiscount2(int parId) throws SQLException {
		// TODO Auto-generated method stub
		this.getGipiParItemDAO().deleteDiscount2(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#negateItem(int, int)
	 */
	@Override
	public Map<String, Object> negateItem(int parId, int itemNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().negateItem(parId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#createEndtParDistribution1(int, int)
	 */
	@Override
	public String createEndtParDistribution1(int parId, int distNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().createEndtParDistribution1(parId, distNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#createEndtParDistribution2(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public String createEndtParDistribution2(int parId, int distNo,
			String recExistsAlert, String distributionAlert) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().createEndtParDistribution2(parId, distNo, recExistsAlert, distributionAlert);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#createInvoiceItem(int)
	 */
	@Override
	public String createEndtInvoiceItem(int parId) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().createEndtInvoiceItem(parId);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#createEndtParDistribution1(int, int)
	 */
	@Override
	public String createEndtDistributionItem1(int parId, int distNo)
			throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().createEndtDistributionItem1(parId, distNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#createEndtParDistribution2(int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public String createEndtDistributionItem2(int parId, int distNo,
			String recExistsAlert, String distributionAlert) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().createEndtDistributionItem2(parId, distNo, recExistsAlert, distributionAlert);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#addEndtParStatusNo(java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.math.BigDecimal, java.lang.String)
	 */
	@Override
	public String addEndtParStatusNo(int parId, String lineCd, String issCd,
			String endtTaxSw, String coInsSw, String negateItem,
			String prorateFlag, String compSw, String endtExpiryDate,
			String effDate, BigDecimal shortRtPercent, String expiryDate)
			throws SQLException {
		return this.getGipiParItemDAO().addEndtParStatusNo(parId, lineCd, issCd, endtTaxSw, coInsSw, negateItem, prorateFlag, compSw, endtExpiryDate, effDate, shortRtPercent, expiryDate);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#setPackageMenu(int, int)
	 */
	@Override
	public boolean setPackageMenu(int parId, int packParId) throws SQLException {
		return this.getGipiParItemDAO().setPackageMenu(parId, packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#updateEndtGipiWpackLineSubline(int, java.lang.String, java.lang.String)
	 */
	@Override
	public boolean updateEndtGipiWpackLineSubline(int parId, String packLineCd,
			String packSublineCd) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().updateEndtGipiWpackLineSubline(parId, packLineCd, packSublineCd);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#endtParValidateOtherInfo(int, int, java.lang.String)
	 */
	@Override
	public String endtParValidateOtherInfo(int parId, int funcPart,
			String alertConfirm) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGipiParItemDAO().endtParValidateOtherInfo(parId, funcPart, alertConfirm);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemFacadeService#copyAdditionalInfoFIEndt(int, int, int, java.lang.String, java.lang.String)
	 */
	@Override
	public void copyAdditionalInfoFIEndt(int parId, int itemNo, int newItemNo,
			String lineCd, String sublineCd) throws SQLException {
		this.getGipiParItemDAO().copyAdditionalInfoFIEndt(parId, itemNo, newItemNo, lineCd, sublineCd);
	}
}
