/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIWItem.
 */
public class GIPIWItem extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIWItem.class);
	
	/** The par id. */
	private Integer parId;
	
	/** The item no. */
	private Integer itemNo;
	
	/** The item title. */
	private String itemTitle;
	
	/** The item desc. */
	private String itemDesc;
	
	/** The item desc2. */
	private String itemDesc2;
	
	/** The tsi amt. */
	private BigDecimal tsiAmt;
	
	/** The prem amt. */
	private BigDecimal premAmt;
	
	/** The ann prem amt. */
	private BigDecimal annPremAmt;
	
	/** The ann tsi amt. */
	private BigDecimal annTsiAmt;
	
	/** The currency cd. */
	private Integer currencyCd;
	
	/** The currency rate. */
	private BigDecimal currencyRate;
	
	/** The from date. */
	private Date fromDate;
	
	/** The to date. */
	private Date toDate;
	
	/** The pack line cd. */
	private String packLineCd;
	
	/** The pack subline cd. */
	private String packSublineCd;
	
	/** The coverage cd. */
	private Integer coverageCd;
	
	/** The changed tag. */
	private String changedTag;
	
	/** The prorate flag. */
	private String prorateFlag;
	
	/** The comp sw. */
	private String compSw;
	
	/** The short rt percent. */
	private BigDecimal shortRtPercent;
	
	/** The pack ben cd. */
	private Integer packBenCd;
	
	/** The currency desc. */
	private String currencyDesc;
	
	/** The coverage desc. */
	private String coverageDesc;
	
	/** The package cd. */
	private String packageCd;
	
	/** The dsp package cd. */
	private String dspPackageCd;
	
	/** The wc sw. */
	private String wcSw;
	
	private String itmperlGroupedExists;		

	private Integer regionCd;
	
	private Integer itemGrp;
	
	private String recFlag;
	
	private BigDecimal currencyRt;
	
	private Integer groupCd;
	
	private String discountSw;
	
	private String otherInfo;
	
	private String surchargeSw;
	
	private String paytTerms;
	
	private Integer riskNo;
	
	private Integer riskItemNo;
	
	private String strFromDate;	//added by steven 9/5/2012
	private String strToDate;	//added by steven 9/5/2012
	
	private GIPIWItemPeril gipiWItemPeril;
	private List<GIPIWItemPeril> gipiWItemPerilListing;	
	private List<GIPIWDeductible> gipiWDeductible;
	
	private GIPIWFireItm gipiWFireItm;
	
	private GIPIWAviationItem gipiWAviationItem;
	
	private GIPIWItemVes gipiWItemVes; //replaced list to object
	
	private GIPIWCasualtyItem gipiWCasualtyItem;
	
	private List<GIPIWCasualtyPersonnel> gipiWCasualtyPersonnel;
	
	private List<GIPIWGroupedItems> gipiWGroupedItems;
	
	private GIPIWLocation gipiWLocation;
	
	private GIPIWAccidentItem gipiWAccidentItem;
	
	private GIPIWCargo gipiWCargo;
	
	private GIPIWVehicle gipiWVehicle;
	
	private List<GIPIWMcAcc> gipiWMcAcc;	
	
	public GIPIWItem (final int parId, final int itemNo, final String itemTitle, final Integer itemGrp,
			final String itemDesc, final String itemDesc2, final BigDecimal tsiAmt, final BigDecimal premAmt,
			final BigDecimal annPremAmt, final BigDecimal annTsiAmt, final String recFlag, final Integer currencyCd,
			final BigDecimal currencyRt, final Integer groupCd, final Date fromDate, final Date toDate,
			final String packLineCd, final String packSublineCd, final String discountSw, final Integer coverageCd,
			final String otherInfo, final String surchargeSw, final Integer regionCd, final String changedTag,
			final String prorateFlag, final String compSw, final BigDecimal shortRtPercent, final Integer packBenCd,
			final String paytTerms, final Integer riskNo, final Integer riskItemNo){
		this.parId = parId;
		this.itemNo = itemNo; 
		this.itemTitle = itemTitle; 
		this.setItemGrp(itemGrp);
		this.itemDesc = itemDesc; 
		this.itemDesc2 = itemDesc2; 
		this.tsiAmt = tsiAmt; 
		this.premAmt = premAmt;
		this.annPremAmt = annPremAmt; 
		this.annTsiAmt = annTsiAmt; 
		this.setRecFlag(recFlag); 
		this.currencyCd = currencyCd;
		this.setCurrencyRt(currencyRt); 
		this.setGroupCd(groupCd); 
		this.fromDate = fromDate; 
		this.toDate = toDate;
		this.packLineCd = packLineCd; 
		this.packSublineCd = packSublineCd; 
		this.setDiscountSw(discountSw); 
		this.coverageCd = coverageCd;
		this.setOtherInfo(otherInfo); 
		this.setSurchargeSw(surchargeSw); 
		this.regionCd = regionCd; 
		this.changedTag = changedTag;
		this.prorateFlag = prorateFlag; 
		this.compSw = compSw; 
		this.shortRtPercent = shortRtPercent; 
		this.packBenCd = packBenCd;
		this.setPaytTerms(paytTerms); 
		this.setRiskNo(riskNo); 
		this.setRiskItemNo(riskItemNo);
	}
	
	public GIPIWItem() {
		//
	}

	/**
	 * Gets the dsp package cd.
	 * 
	 * @return the dsp package cd
	 */
	public String getDspPackageCd() {
		return dspPackageCd;
	}
	
	/**
	 * Sets the dsp package cd.
	 * 
	 * @param dspPackageCd the new dsp package cd
	 */
	public void setDspPackageCd(String dspPackageCd) {
		this.dspPackageCd = dspPackageCd;
	}
	
	/**
	 * Gets the par id.
	 * 
	 * @return the par id
	 */
	public Integer getParId() {
		return parId;
	}
	
	/**
	 * Sets the par id.
	 * 
	 * @param parId the new par id
	 */
	public void setParId(Integer parId) {
		this.parId = parId;
	}
	
	/**
	 * Gets the item no.
	 * 
	 * @return the item no
	 */
	public Integer getItemNo() {
		return itemNo;
	}
	
	/**
	 * Sets the item no.
	 * 
	 * @param itemNo the new item no
	 */
	public void setItemNo(Integer itemNo) {
		this.itemNo = itemNo;
	}
	
	/**
	 * Gets the item title.
	 * 
	 * @return the item title
	 */
	public String getItemTitle() {
		return itemTitle;
	}
	
	/**
	 * Sets the item title.
	 * 
	 * @param itemTitle the new item title
	 */
	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}
	
	/**
	 * Gets the item desc.
	 * 
	 * @return the item desc
	 */
	public String getItemDesc() {
		return itemDesc;
	}
	
	/**
	 * Sets the item desc.
	 * 
	 * @param itemDesc the new item desc
	 */
	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}
	
	/**
	 * Gets the item desc2.
	 * 
	 * @return the item desc2
	 */
	public String getItemDesc2() {
		return itemDesc2;
	}
	
	/**
	 * Sets the item desc2.
	 * 
	 * @param itemDesc2 the new item desc2
	 */
	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}
	
	/**
	 * Gets the tsi amt.
	 * 
	 * @return the tsi amt
	 */
	public BigDecimal getTsiAmt() {
		return tsiAmt;
	}
	
	/**
	 * Sets the tsi amt.
	 * 
	 * @param tsiAmt the new tsi amt
	 */
	public void setTsiAmt(BigDecimal tsiAmt) {
		this.tsiAmt = tsiAmt;
	}
	
	/**
	 * Gets the prem amt.
	 * 
	 * @return the prem amt
	 */
	public BigDecimal getPremAmt() {
		return premAmt;
	}
	
	/**
	 * Sets the prem amt.
	 * 
	 * @param premAmt the new prem amt
	 */
	public void setPremAmt(BigDecimal premAmt) {
		this.premAmt = premAmt;
	}
	
	/**
	 * Gets the ann prem amt.
	 * 
	 * @return the ann prem amt
	 */
	public BigDecimal getAnnPremAmt() {
		return annPremAmt;
	}
	
	/**
	 * Sets the ann prem amt.
	 * 
	 * @param annPremAmt the new ann prem amt
	 */
	public void setAnnPremAmt(BigDecimal annPremAmt) {
		this.annPremAmt = annPremAmt;
	}
	
	/**
	 * Gets the ann tsi amt.
	 * 
	 * @return the ann tsi amt
	 */
	public BigDecimal getAnnTsiAmt() {
		return annTsiAmt;
	}
	
	/**
	 * Sets the ann tsi amt.
	 * 
	 * @param annTsiAmt the new ann tsi amt
	 */
	public void setAnnTsiAmt(BigDecimal annTsiAmt) {
		this.annTsiAmt = annTsiAmt;
	}
	
	/**
	 * Gets the currency cd.
	 * 
	 * @return the currency cd
	 */
	public Integer getCurrencyCd() {
		return currencyCd;
	}
	
	/**
	 * Sets the currency cd.
	 * 
	 * @param currencyCd the new currency cd
	 */
	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}
	
	/**
	 * Gets the currency rate.
	 * 
	 * @return the currency rate
	 */
	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}
	
	/**
	 * Sets the currency rate.
	 * 
	 * @param currencyRate the new currency rate
	 */
	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}
	
	/**
	 * Gets the from date.
	 * 
	 * @return the from date
	 */
	public Date getFromDate() {
		return fromDate;
	}
	
	/**
	 * Sets the from date.
	 * 
	 * @param fromDate the new from date
	 */
	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}
	
	/**
	 * Gets the to date.
	 * 
	 * @return the to date
	 */
	public Date getToDate() {
		return toDate;
	}
	
	/**
	 * Sets the to date.
	 * 
	 * @param toDate the new to date
	 */
	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}
	
	/**
	 * Gets the pack line cd.
	 * 
	 * @return the pack line cd
	 */
	public String getPackLineCd() {
		return packLineCd;
	}
	
	/**
	 * Sets the pack line cd.
	 * 
	 * @param packLineCd the new pack line cd
	 */
	public void setPackLineCd(String packLineCd) {
		this.packLineCd = packLineCd;
	}
	
	/**
	 * Gets the pack subline cd.
	 * 
	 * @return the pack subline cd
	 */
	public String getPackSublineCd() {
		return packSublineCd;
	}
	
	/**
	 * Sets the pack subline cd.
	 * 
	 * @param packSublineCd the new pack subline cd
	 */
	public void setPackSublineCd(String packSublineCd) {
		this.packSublineCd = packSublineCd;
	}
	
	/**
	 * Gets the coverage cd.
	 * 
	 * @return the coverage cd
	 */
	public Integer getCoverageCd() {
		return coverageCd;
	}
	
	/**
	 * Sets the coverage cd.
	 * 
	 * @param coverageCd the new coverage cd
	 */
	public void setCoverageCd(Integer coverageCd) {
		this.coverageCd = coverageCd;
	}
	
	/**
	 * Gets the changed tag.
	 * 
	 * @return the changed tag
	 */
	public String getChangedTag() {
		return changedTag;
	}
	
	/**
	 * Sets the changed tag.
	 * 
	 * @param changedTag the new changed tag
	 */
	public void setChangedTag(String changedTag) {
		this.changedTag = changedTag;
	}
	
	/**
	 * Gets the prorate flag.
	 * 
	 * @return the prorate flag
	 */
	public String getProrateFlag() {
		return prorateFlag;
	}
	
	/**
	 * Sets the prorate flag.
	 * 
	 * @param prorateFlag the new prorate flag
	 */
	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}
	
	/**
	 * Gets the comp sw.
	 * 
	 * @return the comp sw
	 */
	public String getCompSw() {
		return compSw;
	}
	
	/**
	 * Sets the comp sw.
	 * 
	 * @param compSw the new comp sw
	 */
	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}
	
	/**
	 * Gets the short rt percent.
	 * 
	 * @return the short rt percent
	 */
	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}
	
	/**
	 * Sets the short rt percent.
	 * 
	 * @param shortRtPercent the new short rt percent
	 */
	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}
	
	/**
	 * Gets the pack ben cd.
	 * 
	 * @return the pack ben cd
	 */
	public Integer getPackBenCd() {
		return packBenCd;
	}
	
	/**
	 * Sets the pack ben cd.
	 * 
	 * @param packBenCd the new pack ben cd
	 */
	public void setPackBenCd(Integer packBenCd) {
		this.packBenCd = packBenCd;
	}
	
	/**
	 * Gets the currency desc.
	 * 
	 * @return the currency desc
	 */
	public String getCurrencyDesc() {
		return currencyDesc;
	}
	
	/**
	 * Sets the currency desc.
	 * 
	 * @param currencyDesc the new currency desc
	 */
	public void setCurrencyDesc(String currencyDesc) {
		this.currencyDesc = currencyDesc;
	}
	
	/**
	 * Gets the coverage desc.
	 * 
	 * @return the coverage desc
	 */
	public String getCoverageDesc() {
		return coverageDesc;
	}
	
	/**
	 * Sets the coverage desc.
	 * 
	 * @param coverageDesc the new coverage desc
	 */
	public void setCoverageDesc(String coverageDesc) {
		this.coverageDesc = coverageDesc;
	}
	
	/**
	 * Gets the package cd.
	 * 
	 * @return the package cd
	 */
	public String getPackageCd() {
		return packageCd;
	}
	
	/**
	 * Sets the package cd.
	 * 
	 * @param packageCd the new package cd
	 */
	public void setPackageCd(String packageCd) {
		this.packageCd = packageCd;
	}
	
	/**
	 * Sets the wc sw.
	 * 
	 * @param wcSw the new wc sw
	 */
	public void setWcSw(String wcSw) {
		this.wcSw = wcSw;
	}
	
	/**
	 * Gets the wc sw.
	 * 
	 * @return the wc sw
	 */
	public String getWcSw() {
		return wcSw;
	}

	/**
	 * @param itmperlGroupedExists the itmperlGroupedExists to set
	 */
	public void setItmperlGroupedExists(String itmperlGroupedExists) {
		this.itmperlGroupedExists = itmperlGroupedExists;
	}

	/**
	 * @return the itmperlGroupedExists
	 */
	public String getItmperlGroupedExists() {
		return itmperlGroupedExists;
	}	

	public String getRecFlag() {
		return recFlag;
	}

	public void setRecFlag(String recFlag) {
		this.recFlag = recFlag;
	}

	public BigDecimal getCurrencyRt() {
		return currencyRt;
	}

	public void setCurrencyRt(BigDecimal currencyRt) {
		this.currencyRt = currencyRt;
	}	

	public String getDiscountSw() {
		return discountSw;
	}

	public void setDiscountSw(String discountSw) {
		this.discountSw = discountSw;
	}

	public String getOtherInfo() {
		return otherInfo;
	}

	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	public String getSurchargeSw() {
		return surchargeSw;
	}

	public void setSurchargeSw(String surchargeSw) {
		this.surchargeSw = surchargeSw;
	}	

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}		

	/**
	 * @param regionCd the regionCd to set
	 */
	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	/**
	 * @param itemGrp the itemGrp to set
	 */
	public void setItemGrp(Integer itemGrp) {
		this.itemGrp = itemGrp;
	}	

	/**
	 * @param groupCd the groupCd to set
	 */
	public void setGroupCd(Integer groupCd) {
		this.groupCd = groupCd;
	}

	public Integer getRiskNo() {
		return riskNo;
	}

	public void setRiskNo(Integer riskNo) {
		this.riskNo = riskNo;
	}

	public Integer getRiskItemNo() {
		return riskItemNo;
	}

	public void setRiskItemNo(Integer riskItemNo) {
		this.riskItemNo = riskItemNo;
	}

	public Integer getRegionCd() {
		return regionCd;
	}

	public Integer getItemGrp() {
		return itemGrp;
	}

	public Integer getGroupCd() {
		return groupCd;
	}

	public void setGipiWCargo(GIPIWCargo gipiWCargo) {
		this.gipiWCargo = gipiWCargo;
	}

	public GIPIWCargo getGipiWCargo() {
		//return (GIPIWCargo) StringFormatter.escapeHTMLInObject2(gipiWCargo);
		return gipiWCargo; //replaced by: Mark C. 04162015 SR4302
	}

	public GIPIWVehicle getGipiWVehicle() {
		//return (GIPIWVehicle) StringFormatter.escapeHTMLInObject2(gipiWVehicle);
		return gipiWVehicle; //replaced by: Mark C. 04162015 SR4302		
	}

	public void setGipiWVehicle(GIPIWVehicle gipiWVehicle) {
		this.gipiWVehicle = gipiWVehicle;
	}

	public GIPIWFireItm getGipiWFireItm() {
		//return (GIPIWFireItm) StringFormatter.escapeHTMLInObject2(gipiWFireItm);
		return gipiWFireItm; //replaced by: Mark C. 04162015  SR4302
	}

	public void setGipiWFireItm(GIPIWFireItm gipiWFireItm) {
		this.gipiWFireItm = gipiWFireItm;
	}

	public GIPIWAccidentItem getGipiWAccidentItem() {
		//return (GIPIWAccidentItem) StringFormatter.escapeHTMLInObject2(gipiWAccidentItem);
		return gipiWAccidentItem;  //replaced by: Mark C. 04152015 SR4302
	}

	public void setGipiWAccidentItem(GIPIWAccidentItem gipiWAccidentItem) {
		this.gipiWAccidentItem = gipiWAccidentItem;
	}

	public GIPIWCasualtyItem getGipiWCasualtyItem() {
		//return (GIPIWCasualtyItem) StringFormatter.escapeHTMLInObject2(gipiWCasualtyItem);
		return gipiWCasualtyItem; //replaced by: Mark C. 04162015 SR4302
	}

	public void setGipiWCasualtyItem(GIPIWCasualtyItem gipiWCasualtyItem) {
		this.gipiWCasualtyItem = gipiWCasualtyItem;
	}

	public GIPIWAviationItem getGipiWAviationItem() {
		//return (GIPIWAviationItem) StringFormatter.escapeHTMLInObject2(gipiWAviationItem);
		return gipiWAviationItem;  //replaced by: Mark C. 04152015 SR4302
	}

	public void setGipiWAviationItem(GIPIWAviationItem gipiWAviationItem) {
		this.gipiWAviationItem = gipiWAviationItem;
	}

	public GIPIWItemVes getGipiWItemVes() {
		//return (GIPIWItemVes) StringFormatter.escapeHTMLInObject2(gipiWItemVes);
		return gipiWItemVes; //replaced by: Mark C. 04162015 SR4302
	}

	public void setGipiWItemVes(GIPIWItemVes gipiWItemVes) {
		this.gipiWItemVes = gipiWItemVes;
	}

	public void setGipiWItemPeril(GIPIWItemPeril gipiWItemPeril) {
		this.gipiWItemPeril = gipiWItemPeril;
	}

	public GIPIWItemPeril getGipiWItemPeril() {
		return gipiWItemPeril;
	}

	public List<GIPIWDeductible> getGipiWDeductible() {
		return gipiWDeductible;
	}

	public void setGipiWDeductible(List<GIPIWDeductible> gipiWDeductible) {
		this.gipiWDeductible = gipiWDeductible;
	}

	public List<GIPIWCasualtyPersonnel> getGipiWCasualtyPersonnel() {
		return gipiWCasualtyPersonnel;
	}

	public void setGipiWCasualtyPersonnel(List<GIPIWCasualtyPersonnel> gipiWCasualtyPersonnel) {
		this.gipiWCasualtyPersonnel = gipiWCasualtyPersonnel;
	}

	public List<GIPIWGroupedItems> getGipiWGroupedItems() {
		return gipiWGroupedItems;
	}

	public void setGipiWGroupedItems(List<GIPIWGroupedItems> gipiWGroupedItems) {
		this.gipiWGroupedItems = gipiWGroupedItems;
	}

	public GIPIWLocation getGipiWLocation() {
		return gipiWLocation;
	}

	public void setGipiWLocation(GIPIWLocation gipiWLocation) {
		this.gipiWLocation = gipiWLocation;
	}

	public List<GIPIWMcAcc> getGipiWMcAcc() {
		return gipiWMcAcc;
	}

	public void setGipiWMcAcc(List<GIPIWMcAcc> gipiWMcAcc) {
		this.gipiWMcAcc = gipiWMcAcc;
	}

	public void setGipiWItemPerilListing(List<GIPIWItemPeril> gipiWItemPerilListing) {
		this.gipiWItemPerilListing = gipiWItemPerilListing;
	}

	public List<GIPIWItemPeril> getGipiWItemPerilListing() {
		return gipiWItemPerilListing;
	}
	
	public GIPIWItem(JSONObject obj){
		try{
			SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
			
			this.parId			= obj.isNull("parId") ? null : obj.getInt("parId");
			this.itemNo			= obj.isNull("itemNo") ? null : obj.getInt("itemNo");
			this.itemTitle		= obj.isNull("itemTitle") ? null : obj.getString("itemTitle");
			this.itemGrp		= obj.isNull("itemGrp") ? null : obj.getInt("itemGrp");
			this.itemDesc		= obj.isNull("itemDesc") ? null : obj.getString("itemDesc");
			this.itemDesc2		= obj.isNull("itemDesc2") ? null : obj.getString("itemDesc2");
			this.tsiAmt			= obj.isNull("tsiAmt") ? null : new BigDecimal(obj.getString("tsiAmt").replaceAll(",", ""));
			this.premAmt		= obj.isNull("premAmt") ? null : new BigDecimal(obj.getString("premAmt").replaceAll(",", ""));
			this.annPremAmt		= obj.isNull("annPremAmt") ? null : new BigDecimal(obj.getString("annPremAmt").replaceAll(",", ""));
			this.annTsiAmt		= obj.isNull("annTsiAmt") ? null : new BigDecimal(obj.getString("annTsiAmt").replaceAll(",", ""));
			this.recFlag		= obj.isNull("recFlag") ? null : obj.getString("recFlag");
			this.currencyCd		= obj.isNull("currencyCd") ? null : obj.getInt("currencyCd");
			this.currencyRt		= obj.isNull("currencyRt") ? null : new BigDecimal(obj.getString("currencyRt").replaceAll(",", ""));
			this.groupCd		= obj.isNull("groupCd") ? null : obj.getInt("groupCd");
			this.fromDate		= obj.isNull("fromDate") ? null : sdf.parse(obj.getString("fromDate"));
			this.toDate			= obj.isNull("toDate") ? null : sdf.parse(obj.getString("toDate"));
			this.packLineCd		= obj.isNull("packLineCd") ? null : obj.getString("packLineCd");
			this.packSublineCd	= obj.isNull("packSublineCd") ? null : obj.getString("packSublineCd");
			this.discountSw		= obj.isNull("discountSw") ? null : obj.getString("discountSw");
			this.coverageCd		= obj.isNull("coverageCd") ? null : obj.getInt("coverageCd");
			this.otherInfo		= obj.isNull("otherInfo") ? null : obj.getString("otherInfo");
			this.surchargeSw	= obj.isNull("surchargeSw") ? null : obj.getString("surchargeSw");
			this.regionCd		= obj.isNull("regionCd") ? null : obj.getInt("regionCd");
			this.changedTag		= obj.isNull("changedTag") ? null : obj.getString("changedTag");
			this.compSw			= obj.isNull("compSw") ? null : obj.getString("compSw");
			this.prorateFlag	= obj.isNull("prorateFlag") ? null : obj.getString("prorateFlag");
			this.shortRtPercent	= obj.isNull("shortRtPercent") ? null : new BigDecimal(obj.getString("shortRtPercent").replaceAll(",", ""));
			this.packBenCd		= obj.isNull("packBenCd") ? null : obj.getInt("packBenCd");
			this.paytTerms		= obj.isNull("paytTerms") ? null : obj.getString("paytTerms");
			this.riskNo			= obj.isNull("riskNo") ? null : obj.getInt("riskNo");
			this.riskItemNo		= obj.isNull("riskItemNo") ? null : obj.getInt("riskItemNo");
		}catch(JSONException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}catch(ParseException e) {			
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}

	/**
	 * @return the strFromDate
	 */
	public String getStrFromDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.fromDate != null){
			return sdf.format(fromDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strFromDate the strFromDate to set
	 */
	public void setStrFromDate(String strFromDate) {
		this.strFromDate = strFromDate;
	}

	/**
	 * @return the strToDate
	 */
	public String getStrToDate() {
		SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		if(this.toDate != null){
			return sdf.format(toDate);
		} else {
			return null;
		}
	}

	/**
	 * @param strToDate the strToDate to set
	 */
	public void setStrToDate(String strToDate) {
		this.strToDate = strToDate;
	}
}
