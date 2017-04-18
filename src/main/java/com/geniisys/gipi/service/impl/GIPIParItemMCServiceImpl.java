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
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.geniisys.gipi.dao.GIPIParItemMCDAO;
import com.geniisys.gipi.entity.GIPIItem;
import com.geniisys.gipi.entity.GIPIParItemMC;
import com.geniisys.gipi.service.GIPIParItemMCService;


/**
 * The Class GIPIParItemMCServiceImpl.
 */
public class GIPIParItemMCServiceImpl implements GIPIParItemMCService{

	/** The gipi par item mcdao. */
	private GIPIParItemMCDAO gipiParItemMCDAO;
	
	
	/**
	 * Gets the gipi par item mcdao.
	 * 
	 * @return the gipi par item mcdao
	 */
	public GIPIParItemMCDAO getGipiParItemMCDAO() {
		return gipiParItemMCDAO;
	}

	/**
	 * Sets the gipi par item mcdao.
	 * 
	 * @param gipiParItemMCDAO the new gipi par item mcdao
	 */
	public void setGipiParItemMCDAO(GIPIParItemMCDAO gipiParItemMCDAO) {
		this.gipiParItemMCDAO = gipiParItemMCDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#deleteGIPIParItemMC(int, int)
	 */
	@Override
	public void deleteGIPIParItemMC(int parId, int itemNo) throws SQLException {		
		this.getGipiParItemMCDAO().deleteGIPIParItemMC(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getGIPIParItemMC(int, int)
	 */
	@Override
	public GIPIParItemMC getGIPIParItemMC(int parId, int itemNo)
			throws SQLException {		
		return this.getGipiParItemMCDAO().getGIPIParItemMC(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getGIPIParItemMCs(int)
	 */
	@Override
	public List<GIPIParItemMC> getGIPIParItemMCs(int parId) throws SQLException {		
		return this.getGipiParItemMCDAO().getGIPIParItemMCs(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#saveGIPIParItemMC(com.geniisys.gipi.entity.GIPIItem)
	 */
	@Override
	public void saveGIPIParItemMC(GIPIItem itemMC) throws SQLException {
		this.getGipiParItemMCDAO().saveGIPIParItemMC(itemMC);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getGIPIItems(int)
	 */
	@Override
	public List<GIPIItem> getGIPIItems(int parId) throws SQLException {		
		return this.getGipiParItemMCDAO().getGIPIItems(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#checkForExistingDeductibles(int, int)
	 */
	@Override
	public String checkForExistingDeductibles(int parId, int itemNo)
			throws SQLException {
		
		return this.getGipiParItemMCDAO().checkForExistingDeductibles(parId, itemNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getParNo(int)
	 */
	@Override
	public String getParNo(int parId) throws SQLException {		
		return this.getGipiParItemMCDAO().getParNo(parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getAssuredName(java.lang.String)
	 */
	@Override
	public String getAssuredName(String assdNo) throws SQLException {		
		return this.getGipiParItemMCDAO().getAssuredName(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#saveGIPIWVehicle(com.geniisys.gipi.entity.GIPIParItemMC)
	 */
	@Override
	public void saveGIPIWVehicle(GIPIParItemMC parItemMC) throws SQLException {
		this.getGipiParItemMCDAO().saveGIPIWVehicle(parItemMC);		
	}	

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#saveGIPIParVehicle(java.util.Map)
	 */
	@Override
	public void saveGIPIParVehicle(Map<String, Object> vehicleParam)
			throws SQLException {
		
		String[] parIds				= (String[]) vehicleParam.get("parIds");
		String[] itemNos			= (String[]) vehicleParam.get("itemNos");
		String[] sublineCds			= (String[]) vehicleParam.get("sublineCds");
		String[] motorNos			= (String[]) vehicleParam.get("motorNos");
		String[] plateNos			= (String[]) vehicleParam.get("plateNos");
		String[] estValues			= (String[]) vehicleParam.get("estValues");
		String[] makes				= (String[]) vehicleParam.get("makes");
		String[] motorTypes			= (String[]) vehicleParam.get("motorTypes");
		String[] colors				= (String[]) vehicleParam.get("colors");
		String[] repairLims			= (String[]) vehicleParam.get("repairLims");
		String[] serialNos			= (String[]) vehicleParam.get("serialNos");
		String[] cocSeqNos			= (String[]) vehicleParam.get("cocSeqNos");
		String[] cocSerialNos		= (String[]) vehicleParam.get("cocSerialNos");
		String[] cocTypes			= (String[]) vehicleParam.get("cocTypes");
		String[] assignees			= (String[]) vehicleParam.get("assignees");
		String[] modelYears			= (String[]) vehicleParam.get("modelYears");
		@SuppressWarnings("unused")
		String[] cocIssueDates		= (String[]) vehicleParam.get("cocIssueDates");
		String[] cocYYs				= (String[]) vehicleParam.get("cocYYs");
		String[] towings			= (String[]) vehicleParam.get("towings");
		String[] sublineTypeCds		= (String[]) vehicleParam.get("sublineTypeCds");
		String[] noOfPasss			= (String[]) vehicleParam.get("noOfPasss");
		String[] tariffZones		= (String[]) vehicleParam.get("tariffZones");
		String[] mvFileNos			= (String[]) vehicleParam.get("mvFileNos");
		String[] acquiredFroms		= (String[]) vehicleParam.get("acquiredFroms");
		String[] ctvTags			= (String[]) vehicleParam.get("ctvTags");
		String[] carCompanyCds		= (String[]) vehicleParam.get("carCompanyCds");
			
		String[] typeOfBodyCds		= (String[]) vehicleParam.get("typeOfBodyCds");
		String[] unladenWts			= (String[]) vehicleParam.get("unladenWts");
		String[] makeCds			= (String[]) vehicleParam.get("makeCds");
		String[] seriesCds			= (String[]) vehicleParam.get("seriesCds");
		String[] basicColorCds		= (String[]) vehicleParam.get("basicColorCds");
		String[] colorCds			= (String[]) vehicleParam.get("colorCds");
		String[] origins			= (String[]) vehicleParam.get("origins");
		String[] destinations		= (String[]) vehicleParam.get("destinations");
		String[] cocAtcns			= (String[]) vehicleParam.get("cocAtcns");
		String[] motorCoverages		= (String[]) vehicleParam.get("motorCoverages");
		String[] cocSerialSws		= (String[]) vehicleParam.get("cocSerialSws");
		String[] deductibleAmounts	= (String[]) vehicleParam.get("deductibleAmounts");

		List<GIPIParItemMC> items = new ArrayList<GIPIParItemMC>();
		for(int i=0; i < itemNos.length; i++){			
			if(!(motorNos[i].trim().isEmpty())){
				items.add(new GIPIParItemMC(
						parIds[i] /*Integer.parseInt(parIds[i])*/,
						itemNos[i] /*Integer.parseInt(itemNos[i])*/,
						assignees[i],
						acquiredFroms[i],
						motorNos[i],
						origins[i],
						destinations[i],
						typeOfBodyCds[i],
						plateNos[i],
						modelYears[i],
						carCompanyCds[i] /*Integer.parseInt(carCompanyCds[i])*/,
						mvFileNos[i],
						noOfPasss[i] /*Integer.parseInt(noOfPasss[i])*/,
						makeCds[i] /*Integer.parseInt(makeCds[i])*/,
						basicColorCds[i],
						colorCds[i] /*Integer.parseInt(colorCds[i])*/,
						seriesCds[i] /*Integer.parseInt(seriesCds[i] == null || seriesCds[i] == "" ? "0" : seriesCds[i])*/,
						motorTypes[i] /*Integer.parseInt(motorTypes[i])*/,
						unladenWts[i],
						new BigDecimal(towings[i].replaceAll(",", "")),
						serialNos[i],
						sublineTypeCds[i],
						new BigDecimal(deductibleAmounts[i].replaceAll(",", "")),
						cocSerialNos[i] /*Integer.parseInt(cocSerialNos[i])*/,
						ctvTags[i],
						new BigDecimal(repairLims[i].replaceAll(",", "")),
						new BigDecimal(estValues[i]),
						colors[i],
						cocSeqNos[i] /*Integer.parseInt(cocSeqNos[i] == null ? "0" : cocSeqNos[i])*/,
						cocTypes[i],
						null,
						cocYYs[i] /*Integer.parseInt(cocYYs[i])*/,
						cocSerialSws[i],
						cocAtcns[i],
						sublineCds[i],
						tariffZones[i],
						makes[i],
						motorCoverages[i]));				
			}					
		}
		this.getGipiParItemMCDAO().setGIPIWVehicle(items);		
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#checkCOCSerialNoInPar(int, int, int, java.lang.String)
	 */
	@Override
	public String checkCOCSerialNoInPar(int parId, int itemNo, int cocSerialNo,
			String cocType) throws SQLException {		
		return this.getGipiParItemMCDAO().checkCOCSerialNoInPar(parId, itemNo, cocSerialNo, cocType);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#checkCOCSerialNoInPolicy(int)
	 */
	@Override
	public String checkCOCSerialNoInPolicy(int cocSerialNo) throws SQLException {		
		return this.getGipiParItemMCDAO().checkCOCSerialNoInPolicy(cocSerialNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#validateOtherInfo(int)
	 */
	@Override
	public String validateOtherInfo(int parId) throws SQLException {		
		return this.getGipiParItemMCDAO().validateOtherInfo(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#getEndtTax(int)
	 */
	@Override
	public String getEndtTax(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().getEndtTax(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#checkIfDiscountExists(int)
	 */
	@Override
	public String checkIfDiscountExists(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().checkIfDiscountExists(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIEndtParItemMCService#deleteItem(int, int[], int)
	 */
	@Override
	public boolean deleteEndtItem(int parId, int[] itemNo, int currentItemNo)
			throws SQLException {
		return this.getGipiParItemMCDAO().deleteEndtItem(parId, itemNo, currentItemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#addEndtItem(int, int[])
	 */
	@Override
	public String addEndtItem(int parId, int[] itemNo) throws SQLException {
		return this.getGipiParItemMCDAO().addEndtItem(parId, itemNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#checkAddtlInfo(int)
	 */
	@Override
	public String checkAddtlInfo(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().checkAddtlInfo(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#populateOrigItmperil(int)
	 */
	@Override
	public String populateOrigItmperil(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().populateOrigItmperil(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#getDistNo(int)
	 */
	@Override
	public int getDistNo(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().getDistNo(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#deleteDistribution(int, int)
	 */
	@Override
	public String deleteDistribution(int parId, int distNo) throws SQLException {
		return this.getGipiParItemMCDAO().deleteDistribution(parId, distNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#deleteWinvRecords(int)
	 */
	@Override
	public boolean deleteWinvRecords(int parId) throws SQLException {
		return this.getGipiParItemMCDAO().deleteWinvRecords(parId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#validateEndtParMCItemNo(int, int, java.lang.String, java.util.Date)
	 */
	@Override
	public String validateEndtParMCItemNo(int parId, int itemNo,
			String dfltCoverage, String expiryDate) throws SQLException {
		return this.getGipiParItemMCDAO().validateEndtParMCItemNo(parId, itemNo, dfltCoverage, expiryDate);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.gipi.service.GIPIParItemMCService#validateEndtMotorItemAddtlInfo(int, int, java.math.BigDecimal, java.lang.String, java.lang.String)
	 */
	@Override
	public void validateEndtMotorItemAddtlInfo(int parId, int itemNo,
			BigDecimal towing, String cocType, String plateNo)
			throws SQLException {
		this.getGipiParItemMCDAO().validateEndtMotorItemAddtlInfo(parId, itemNo, towing, cocType, plateNo);
	}

	@Override
	public Map<String, Object> gipis010NewFormInstance(
			Map<String, Object> params) throws SQLException {		
		return this.getGipiParItemMCDAO().gipis010NewFormInstance(params);
	}

	@Override
	public boolean saveItemMotorCar(Map<String, Object> params)
			throws SQLException {		
		return this.getGipiParItemMCDAO().saveItemMotorCar(params);
	}

	@Override
	public Map<String, Object> preFormsCommit(Map<String, Object> params)
			throws SQLException {
		return this.getGipiParItemMCDAO().preFormsCommit(params);
	}
}
