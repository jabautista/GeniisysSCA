package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.framework.util.BaseEntity;

public class GICLItemPeril extends BaseEntity{
	
	private Integer claimId;
	private Integer itemNo;
	private Integer perilCd;
	private BigDecimal annTsiAmt;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private String motshopTag;
	private String lossCatCd;
	private String lineCd;
	private Date closeDate;
	private String closeFlag;
	private String closeFlag2;
	private Date closeDate2;
	private String aggregateSw;
	private Integer groupedItemNo;
	private BigDecimal allowTsiAmt;
	private BigDecimal baseAmt;
	private Integer noOfDays;
	private Integer allowNoOfDays;
	
	private String histIndicator;
	private String dspLossCatDes;
	private String dspPerilName;
	private String nbtCloseFlag;
	private String nbtCloseFlag2;
	private String tlossFl;
	
	private String  dspItemNo;
	private String  dspItemTitle;
	private Integer dspPerilCd;
	private String  dspCurrDesc;
	private Integer	currencyCd;
	private String dspGroupedItemTitle;
	
	private String aggPeril;
	
	private BigDecimal annTsiAmt2;
	private BigDecimal reserveAmt;
	private BigDecimal shrTsiPct;
	private BigDecimal shrPct;
	private BigDecimal trtyTsi;
	private BigDecimal trtyReserve;
	private Integer shareCd;
	private String tsiTrty;
	private String resTrty;
	
	// non-row properties
	private String lossStat;
	private String expStat;
	
	private String color;
	private String modelYear;        
	private String serialNo;         
	private String motorNo;          
	private String plateNo;          
	private String mvFileNo;        
	private String drvrName;         
	private String dspMake;          
	private String dspSublineType;  
	private String reserveDtlExist;
	private String paymentDtlExist;
	
	private GICLClaimReserve giclClaimReserve;
	private GICLClmResHist giclClmResHist;
	
	
	/**
	 * @return the reserveDtlExist
	 */
	public String getReserveDtlExist() {
		return reserveDtlExist;
	}
	/**
	 * @param reserveDtlExist the reserveDtlExist to set
	 */
	public void setReserveDtlExist(String reserveDtlExist) {
		this.reserveDtlExist = reserveDtlExist;
	}
	/**
	 * @return the paymentDtlExist
	 */
	public String getPaymentDtlExist() {
		return paymentDtlExist;
	}
	/**
	 * @param paymentDtlExist the paymentDtlExist to set
	 */
	public void setPaymentDtlExist(String paymentDtlExist) {
		this.paymentDtlExist = paymentDtlExist;
	}
	public String getColor() {
		return color;
	}
	public void setColor(String color) {
		this.color = color;
	}
	public String getModelYear() {
		return modelYear;
	}
	public void setModelYear(String modelYear) {
		this.modelYear = modelYear;
	}
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getMotorNo() {
		return motorNo;
	}
	public void setMotorNo(String motorNo) {
		this.motorNo = motorNo;
	}
	public String getPlateNo() {
		return plateNo;
	}
	public void setPlateNo(String plateNo) {
		this.plateNo = plateNo;
	}
	public String getMvFileNo() {
		return mvFileNo;
	}
	public void setMvFileNo(String mvFileNo) {
		this.mvFileNo = mvFileNo;
	}
	public String getDrvrName() {
		return drvrName;
	}
	public void setDrvrName(String drvrName) {
		this.drvrName = drvrName;
	}
	public String getDspMake() {
		return dspMake;
	}
	public void setDspMake(String dspMake) {
		this.dspMake = dspMake;
	}
	public String getDspSublineType() {
		return dspSublineType;
	}
	public void setDspSublineType(String dspSublineType) {
		this.dspSublineType = dspSublineType;
	}
	public Integer getClaimId() {
		return claimId;
	}
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	public Integer getItemNo() {
		return itemNo;
	}
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	public Integer getPerilCd() {
		return perilCd;
	}
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	public String getMotshopTag() {
		return motshopTag;
	}
	public void setMotshopTag(String motshopTag) {
		this.motshopTag = motshopTag;
	}
	public String getLossCatCd() {
		return lossCatCd;
	}
	public void setLossCatCd(String lossCatCd) {
		this.lossCatCd = lossCatCd;
	}
	public String getLineCd() {
		return lineCd;
	}
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	public Date getCloseDate() {
		return closeDate;
	}
	public void setCloseDate(Date closeDate) {
		this.closeDate = closeDate;
		
	}
	public String getCloseFlag() {
		return closeFlag;
	}
	public void setCloseFlag(String closeFlag) {
		this.closeFlag = closeFlag;
		setStatuses();
	}
	public String getCloseFlag2() {
		return closeFlag2;
	}
	public void setCloseFlag2(String closeFlag2) {
		this.closeFlag2 = closeFlag2;
		setStatuses();
	}
	public Date getCloseDate2() {
		return closeDate2;
	}
	public void setCloseDate2(Date closeDate2) {
		this.closeDate2 = closeDate2;
	}
	public String getAggregateSw() {
		return aggregateSw;
	}
	public void setAggregateSw(String aggregateSw) {
		this.aggregateSw = aggregateSw;
	}
	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}
	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}
	public BigDecimal getAllowTsiAmt() {
		return allowTsiAmt;
	}
	public void setAllowTsiAmt(BigDecimal allowTsiAmt) {
		this.allowTsiAmt = allowTsiAmt;
	}
	public BigDecimal getBaseAmt() {
		return baseAmt;
	}
	public void setBaseAmt(BigDecimal baseAmt) {
		this.baseAmt = baseAmt;
	}
	public Integer getNoOfDays() {
		return noOfDays;
	}
	public void setNoOfDays(Integer noOfDays) {
		this.noOfDays = noOfDays;
	}
	public Integer getAllowNoOfDays() {
		return allowNoOfDays;
	}
	public void setAllowNoOfDays(Integer allowNoOfDays) {
		this.allowNoOfDays = allowNoOfDays;
	}
	public String getHistIndicator() {
		return histIndicator;
	}
	public void setHistIndicator(String histIndicator) {
		this.histIndicator = histIndicator;
	}
	public String getDspLossCatDes() {
		return dspLossCatDes;
	}
	public void setDspLossCatDes(String dspLossCatDes) {
		this.dspLossCatDes = dspLossCatDes;
	}
	public String getDspPerilName() {
		return dspPerilName;
	}
	public void setDspPerilName(String dspPerilName) {
		this.dspPerilName = dspPerilName;
	}
	public String getNbtCloseFlag() {
		return nbtCloseFlag;
	}
	public void setNbtCloseFlag(String nbtCloseFlag) {
		this.nbtCloseFlag = nbtCloseFlag;
	}
	public String getNbtCloseFlag2() {
		return nbtCloseFlag2;
	}
	public void setNbtCloseFlag2(String nbtCloseFlag2) {
		this.nbtCloseFlag2 = nbtCloseFlag2;
	}
	public String getTlossFl() {
		return tlossFl;
	}
	public void setTlossFl(String tlossFl) {
		this.tlossFl = tlossFl;
	}
	public void setDspItemNo(String dspItemNo) {
		this.dspItemNo = dspItemNo;
	}
	public String getDspItemNo() {
		return dspItemNo;
	}
	public void setDspItemTitle(String dspItemTitle) {
		this.dspItemTitle = dspItemTitle;
	}
	public String getDspItemTitle() {
		return dspItemTitle;
	}
	public void setDspPerilCd(Integer dspPerilCd) {
		this.dspPerilCd = dspPerilCd;
	}
	public Integer getDspPerilCd() {
		return dspPerilCd;
	}
	public void setDspCurrDesc(String dspCurrDesc) {
		this.dspCurrDesc = dspCurrDesc;
	}
	public String getDspCurrDesc() {
		return dspCurrDesc;
	}
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	public void setDspGroupedItemTitle(String dspGroupedItemTitle) {
		this.dspGroupedItemTitle = dspGroupedItemTitle;
	}
	public String getDspGroupedItemTitle() {
		return dspGroupedItemTitle;
	}
	public String getAggPeril() {
			return aggPeril;
	}
	public void setAggPeril(String aggPeril) {
		this.aggPeril = aggPeril;
	}
	public BigDecimal getAnnTsiAmt2() {
		return annTsiAmt2;
	}
	public void setAnnTsiAmt2(BigDecimal annTsiAmt2) {
		this.annTsiAmt2 = annTsiAmt2;
	}
	public BigDecimal getReserveAmt() {
		return reserveAmt;
	}
	public void setReserveAmt(BigDecimal reserveAmt) {
		this.reserveAmt = reserveAmt;
	}
	public BigDecimal getShrTsiPct() {
		return shrTsiPct;
	}
	public void setShrTsiPct(BigDecimal shrTsiPct) {
		this.shrTsiPct = shrTsiPct;
	}
	public BigDecimal getShrPct() {
		return shrPct;
	}
	public void setShrPct(BigDecimal shrPct) {
		this.shrPct = shrPct;
	}
	public BigDecimal getTrtyTsi() {
		return trtyTsi;
	}
	public void setTrtyTsi(BigDecimal trtyTsi) {
		this.trtyTsi = trtyTsi;
	}
	public BigDecimal getTrtyReserve() {
		return trtyReserve;
	}
	public void setTrtyReserve(BigDecimal trtyReserve) {
		this.trtyReserve = trtyReserve;
	}
	public Integer getShareCd() {
		return shareCd;
	}
	public void setShareCd(Integer shareCd) {
		this.shareCd = shareCd;
	}
	public String getTsiTrty() {
		return tsiTrty;
	}
	public void setTsiTrty(String tsiTrty) {
		this.tsiTrty = tsiTrty;
	}
	public String getResTrty() {
		return resTrty;
	}
	public void setResTrty(String resTrty) {
		this.resTrty = resTrty;
	}
	public void setExpStat(String expStat) {
		this.expStat = expStat;
	}
	public String getExpStat() {
		return expStat;
	}
	public void setLossStat(String lossStat) {
		this.lossStat = lossStat;
	}
	public String getLossStat() {
		return lossStat;
	}
	
	private void setStatuses(){
		String closeFlag1 = this.closeFlag == null ? "" : this.closeFlag;
		String closeFlag2 = this.closeFlag2 == null ? "" : this.closeFlag2;

		// FOR LOSS STAT
		try{
			if(closeFlag1.equals("")){
				closeFlag1  = "AP";
			}
			this.setLossStat(this.decodeFlag(closeFlag1));
		}catch(Exception e){
			System.out.println(e.getMessage());
		}
		
		// FOR EXP STAT
		try{
			if(closeFlag2.equals("")){
				if(closeFlag1.equals("")){
					closeFlag2 = "AP";
				}
			}
			
			this.setExpStat(this.decodeFlag(closeFlag2));
		}catch (Exception e) {
			System.out.println(e.getMessage());
			e.printStackTrace();
		}
	}
		
	private String decodeFlag(String flag){
		if(flag.equalsIgnoreCase("AP")){
			return "OPEN";
		}else if(flag.equalsIgnoreCase("CP")){
			return "CLOSE";
		}else if(flag.equalsIgnoreCase("DN")){
			return "DENIED";
		}else if(flag.equalsIgnoreCase("WD")){
			return "WITHDRAWN";
		}else if(flag.equalsIgnoreCase("CC")){
			return "CLOSED";
		}else if(flag.equalsIgnoreCase("DC")){
			return "DENIED";
		}else{
			return "";
		}
	}
	public GICLClaimReserve getGiclClaimReserve() {
		return giclClaimReserve;
	}
	public void setGiclClaimReserve(GICLClaimReserve giclClaimReserve) {
		this.giclClaimReserve = giclClaimReserve;
	}
	public GICLClmResHist getGiclClmResHist() {
		return giclClmResHist;
	}
	public void setGiclClmResHist(GICLClmResHist giclClmResHist) {
		this.giclClmResHist = giclClmResHist;
	}	
}