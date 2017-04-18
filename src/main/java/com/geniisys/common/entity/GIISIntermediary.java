/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;
import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;



/**
 * The Class GIISIntermediary.
 */
public class GIISIntermediary extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -303593976475989859L;
	
	/** The intm name. */
	private String intmName;
	
	/** The parent intm no. */
	private Integer parentIntmNo;
	
	/** The parent intm name. */
	private String parentIntmName;
	
	/** The intm no. */
	private Integer intmNo;
	
	/** The default tax rate. */
	private BigDecimal defaultTaxRate;
	
	/** The intm type. */
	private String intmType;
	
	/** The ref intm cd. */
	private String refIntmCd;
	
	/** The mailAddr1. */
	private String mailAddr1;
	
	/** The mailAddr2. */
	private String mailAddr2;
	
	/** The mailAddr3. */
	private String mailAddr3;
	
	/** The payorType. */
	private String payorType;
	
	/** The TIN. */
	private String tin;
	
	/** The iss_cd. */
	private String issCd;
	
	/** The lic_tag. */
	private String licTag;
	
	/**	The Active Tag */
	private String activeTag;
	
	/** The Intm Desc */
	private String intmDesc;
	
	/** The Bus Intm No */
	private String busIntmNo;

	// added by irwin 7.17.2012
	private String parentIntmLicTag;	
	private String parentIntmSpecialRate;
	// added by bonok 8.23.2012
	private BigDecimal sharePercentage;
	// added by christian 8.25.2012
	private String specialRate;
	
	//added by shan  11.07.2013
	private String intmTypeDesc;	
	private String remarks;
	
	//added by shan 11.11.2013
	private String caNo;
	private Date caDate;
	private String designation;
	private String parentDesignation;
	private String issName;
	private String contactPerson;
	private String phoneNo;
	private Integer oldIntmNo;
	private Integer whtaxId;
	private Integer whtaxCode;
	private String whtaxDesc;
	private BigDecimal wtaxRate;
	private Date birthdate;
	private Integer masterIntmNo;
	private String coIntmType;
	private String coIntmTypeName;
	private String paytTerms;
	private String paytTermsDesc;
	private String billAddr1;
	private String billAddr2;
	private String billAddr3;
	private String prntIntmTinSw;
	private String corpTag;
	private String lfTag;
	private BigDecimal inputVatRate;
	private String nickname;
	private String emailAdd;
	private String faxNo;
	private String cpNo;
	private String sunNo;
	private String globeNo;
	private String smartNo;
	private String homeAdd;
	private String vIntmType;
	private String vWtaxRate;
	private String chgItem;
	private String caDateChar;
	private String birthdateChar;
	private String recordStatus;
	
	/**
	 * @return the parentIntmLicTag
	 */
	public String getParentIntmLicTag() {
		return parentIntmLicTag;
	}

	/**
	 * @param parentIntmLicTag the parentIntmLicTag to set
	 */
	public void setParentIntmLicTag(String parentIntmLicTag) {
		this.parentIntmLicTag = parentIntmLicTag;
	}

	/**
	 * @return the parentIntmSpecialRate
	 */
	public String getParentIntmSpecialRate() {
		return parentIntmSpecialRate;
	}

	/**
	 * @param parentIntmSpecialRate the parentIntmSpecialRate to set
	 */
	public void setParentIntmSpecialRate(String parentIntmSpecialRate) {
		this.parentIntmSpecialRate = parentIntmSpecialRate;
	}

	/**
	 * Gets the intm name.
	 * 
	 * @return the intm name
	 */
	public String getIntmName() {
		return intmName;
	}
	
	/**
	 * Sets the intm name.
	 * 
	 * @param intmName the new intm name
	 */
	public void setIntmName(String intmName) {
		this.intmName = intmName;
	}
	
	/**
	 * Gets the parent intm no.
	 * 
	 * @return the parent intm no
	 */
	public Integer getParentIntmNo() {
		return parentIntmNo;
	}
	
	/**
	 * Sets the parent intm no.
	 * 
	 * @param parentIntmNo the new parent intm no
	 */
	public void setParentIntmNo(Integer parentIntmNo) {
		this.parentIntmNo = parentIntmNo;
	}
	
	/**
	 * Gets the intm no.
	 * 
	 * @return the intm no
	 */
	public Integer getIntmNo() {
		return intmNo;
	}
	
	/**
	 * Sets the intm no.
	 * 
	 * @param intmNo the new intm no
	 */
	public void setIntmNo(Integer intmNo) {
		this.intmNo = intmNo;
	}
	
	/**
	 * Gets the intm type.
	 * 
	 * @return the intm type
	 */
	public String getIntmType() {
		return intmType;
	}
	
	/**
	 * Sets the intm type.
	 * 
	 * @param intmType the new intm type
	 */
	public void setIntmType(String intmType) {
		this.intmType = intmType;
	}
	
	/**
	 * Gets the ref intm cd.
	 * 
	 * @return the ref intm cd
	 */
	public String getRefIntmCd() {
		return refIntmCd;
	}
	
	/**
	 * Sets the ref intm cd.
	 * 
	 * @param refIntmCd the new ref intm cd
	 */
	public void setRefIntmCd(String refIntmCd) {
		this.refIntmCd = refIntmCd;
	}

	public void setParentIntmName(String parentIntmName) {
		this.parentIntmName = parentIntmName;
	}

	public String getParentIntmName() {
		return parentIntmName;
	}

	public void setDefaultTaxRate(BigDecimal defaultTaxRate) {
		this.defaultTaxRate = defaultTaxRate;
	}

	public BigDecimal getDefaultTaxRate() {
		return defaultTaxRate;
	}

	public String getMailAddr1() {
		return mailAddr1;
	}

	public void setMailAddr1(String mailAddr1) {
		this.mailAddr1 = mailAddr1;
	}

	public String getMailAddr2() {
		return mailAddr2;
	}

	public void setMailAddr2(String mailAddr2) {
		this.mailAddr2 = mailAddr2;
	}

	public String getMailAddr3() {
		return mailAddr3;
	}

	public void setMailAddr3(String mailAddr3) {
		this.mailAddr3 = mailAddr3;
	}

	public String getPayorType() {
		return payorType;
	}

	public void setPayorType(String payorType) {
		this.payorType = payorType;
	}

	public String getTin() {
		return tin;
	}

	public void setTin(String tin) {
		this.tin = tin;
	}

	public String getIssCd() {
		return issCd;
	}

	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	public String getLicTag() {
		return licTag;
	}

	public void setLicTag(String licTag) {
		this.licTag = licTag;
	}

	/**
	 * @param activeTag the activeTag to set
	 */
	public void setActiveTag(String activeTag) {
		this.activeTag = activeTag;
	}

	/**
	 * @return the activeTag
	 */
	public String getActiveTag() {
		return activeTag;
	}

	public void setIntmDesc(String intmDesc) {
		this.intmDesc = intmDesc;
	}

	public String getIntmDesc() {
		return intmDesc;
	}

	public void setBusIntmNo(String busIntmNo) {
		this.busIntmNo = busIntmNo;
	}

	public String getBusIntmNo() {
		return busIntmNo;
	}

	public BigDecimal getSharePercentage() {
		return sharePercentage;
	}

	public void setSharePercentage(BigDecimal sharePercentage) {
		this.sharePercentage = sharePercentage;
	}

	/**
	 * @return the specialRate
	 */
	public String getSpecialRate() {
		return specialRate;
	}

	/**
	 * @param specialRate the specialRate to set
	 */
	public void setSpecialRate(String specialRate) {
		this.specialRate = specialRate;
	}

	public String getIntmTypeDesc() {
		return intmTypeDesc;
	}

	public void setIntmTypeDesc(String intmTypeDesc) {
		this.intmTypeDesc = intmTypeDesc;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public String getCaNo() {
		return caNo;
	}

	public void setCaNo(String caNo) {
		this.caNo = caNo;
	}

	public Date getCaDate() {
		return caDate;
	}

	public void setCaDate(Date caDate) {
		this.caDate = caDate;
	}

	public String getDesignation() {
		return designation;
	}

	public void setDesignation(String designation) {
		this.designation = designation;
	}

	public String getParentDesignation() {
		return parentDesignation;
	}

	public void setParentDesignation(String parentDesignation) {
		this.parentDesignation = parentDesignation;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

	public String getContactPerson() {
		return contactPerson;
	}

	public void setContactPerson(String contactPerson) {
		this.contactPerson = contactPerson;
	}

	public String getPhoneNo() {
		return phoneNo;
	}

	public void setPhoneNo(String phoneNo) {
		this.phoneNo = phoneNo;
	}

	public Integer getOldIntmNo() {
		return oldIntmNo;
	}

	public void setOldIntmNo(Integer oldIntmNo) {
		this.oldIntmNo = oldIntmNo;
	}

	public Integer getWhtaxId() {
		return whtaxId;
	}

	public void setWhtaxId(Integer whtaxId) {
		this.whtaxId = whtaxId;
	}

	public Integer getWhtaxCode() {
		return whtaxCode;
	}

	public void setWhtaxCode(Integer whtaxCode) {
		this.whtaxCode = whtaxCode;
	}

	public String getWhtaxDesc() {
		return whtaxDesc;
	}

	public void setWhtaxDesc(String whtaxDesc) {
		this.whtaxDesc = whtaxDesc;
	}

	public BigDecimal getWtaxRate() {
		return wtaxRate;
	}

	public void setWtaxRate(BigDecimal wtaxRate) {
		this.wtaxRate = wtaxRate;
	}

	public Date getBirthdate() {
		return birthdate;
	}

	public void setBirthdate(Date birthdate) {
		this.birthdate = birthdate;
	}

	public Integer getMasterIntmNo() {
		return masterIntmNo;
	}

	public void setMasterIntmNo(Integer masterIntmNo) {
		this.masterIntmNo = masterIntmNo;
	}

	public String getCoIntmType() {
		return coIntmType;
	}

	public void setCoIntmType(String coIntmType) {
		this.coIntmType = coIntmType;
	}

	public String getCoIntmTypeName() {
		return coIntmTypeName;
	}

	public void setCoIntmTypeName(String coIntmTypeName) {
		this.coIntmTypeName = coIntmTypeName;
	}

	public String getPaytTerms() {
		return paytTerms;
	}

	public void setPaytTerms(String paytTerms) {
		this.paytTerms = paytTerms;
	}

	public String getPaytTermsDesc() {
		return paytTermsDesc;
	}

	public void setPaytTermsDesc(String paytTermsDesc) {
		this.paytTermsDesc = paytTermsDesc;
	}

	public String getBillAddr1() {
		return billAddr1;
	}

	public void setBillAddr1(String billAddr1) {
		this.billAddr1 = billAddr1;
	}

	public String getBillAddr2() {
		return billAddr2;
	}

	public void setBillAddr2(String billAddr2) {
		this.billAddr2 = billAddr2;
	}

	public String getBillAddr3() {
		return billAddr3;
	}

	public void setBillAddr3(String billAddr3) {
		this.billAddr3 = billAddr3;
	}

	public String getPrntIntmTinSw() {
		return prntIntmTinSw;
	}

	public void setPrntIntmTinSw(String prntIntmTinSw) {
		this.prntIntmTinSw = prntIntmTinSw;
	}

	public String getCorpTag() {
		return corpTag;
	}

	public void setCorpTag(String corpTag) {
		this.corpTag = corpTag;
	}

	public String getLfTag() {
		return lfTag;
	}

	public void setLfTag(String lfTag) {
		this.lfTag = lfTag;
	}

	public BigDecimal getInputVatRate() {
		return inputVatRate;
	}

	public void setInputVatRate(BigDecimal inputVatRate) {
		this.inputVatRate = inputVatRate;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getEmailAdd() {
		return emailAdd;
	}

	public void setEmailAdd(String emailAdd) {
		this.emailAdd = emailAdd;
	}

	public String getFaxNo() {
		return faxNo;
	}

	public void setFaxNo(String faxNo) {
		this.faxNo = faxNo;
	}

	public String getCpNo() {
		return cpNo;
	}

	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}

	public String getSunNo() {
		return sunNo;
	}

	public void setSunNo(String sunNo) {
		this.sunNo = sunNo;
	}

	public String getGlobeNo() {
		return globeNo;
	}

	public void setGlobeNo(String globeNo) {
		this.globeNo = globeNo;
	}

	public String getSmartNo() {
		return smartNo;
	}

	public void setSmartNo(String smartNo) {
		this.smartNo = smartNo;
	}

	public String getHomeAdd() {
		return homeAdd;
	}

	public void setHomeAdd(String homeAdd) {
		this.homeAdd = homeAdd;
	}

	public String getvIntmType() {
		return vIntmType;
	}

	public void setvIntmType(String vIntmType) {
		this.vIntmType = vIntmType;
	}

	public String getvWtaxRate() {
		return vWtaxRate;
	}

	public void setvWtaxRate(String vWtaxRate) {
		this.vWtaxRate = vWtaxRate;
	}

	public String getChgItem() {
		return chgItem;
	}

	public void setChgItem(String chgItem) {
		this.chgItem = chgItem;
	}

	public String getCaDateChar() {
		return caDateChar;
	}

	public void setCaDateChar(String caDateChar) {
		this.caDateChar = caDateChar;
	}

	public String getBirthdateChar() {
		return birthdateChar;
	}

	public void setBirthdateChar(String birthdateChar) {
		this.birthdateChar = birthdateChar;
	}

	public String getRecordStatus() {
		return recordStatus;
	}

	public void setRecordStatus(String recordStatus) {
		this.recordStatus = recordStatus;
	}	
	
}
