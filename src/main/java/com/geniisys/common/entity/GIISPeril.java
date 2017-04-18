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

import com.geniisys.framework.util.BaseEntity;


/**
 * The Class GIISPeril.
 */
public class GIISPeril extends BaseEntity {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	/** The line cd. */
	private String lineCd;                                          
	
	/** The peril cd. */
	private Integer perilCd;                                           
	
	/** The peril sname. */
	private String perilSname;
	
	/** The basic peril. */
	private String basicPeril;
	
	/**The basic peril name */
	private String basicPerilName;
	
	/** The peril name. */
	private String perilName;                                             
	
	/** The peril type. */
	private String perilType;                                          
	
	/** The ri comm rt. */
	private BigDecimal riCommRt;                                          
	
	/** The peril lname. */
	private String perilLname;                                     
	
	/** The basc line cd. */
	private String bascLineCd;                                     
	
	/** The basc perl cd. */
	private Integer bascPerlCd;                                      
	
	/** The Intm comm rt. */
	private BigDecimal intmCommRt;                              
	
	/** The prt flag. */
	private String prtFlag;                                  
	
	/** The peril class. */
	private String perilClass;                                  
	
	/** The subline cd. */
	private String sublineCd;                                         
	
	/** The default tag. */
	private String defaultTag;                    
	
	/** The default rate. */
	private BigDecimal defaultRate;                 
	
	/** The default tsi. */
	private BigDecimal defaultTsi;                           
	
	/** The remarks. */
	private String remarks;                           
	
	/** The cpi rec no. */
	private Integer cpiRecNo;                                    
	
	/** The cpi branch cd. */
	private String cpiBranchCd;                                  
	
	/** The zone type. */
	private String zoneType;                                            
	
	/** The benefit cd. */
	private String benefitCd;                             
	
	/** The dflt rate. */
	private BigDecimal dfltRate;                                       
	
	/** The dflt tag. */
	private String dfltTag;                              
	
	/** The dflt tsi. */
	private BigDecimal dfltTsi;                         
	
	/** The mi basis. */
	private String miBasis;                         
	
	/** The ref peril cd. */
	private Integer refPerilCd;                                   
	
	/** The sequence. */
	private Integer sequence;                             
	
	/** The expiry print tag. */
	private String expiryPrintTag;                 
	
	/** The prof comm tag. */
	private String profCommTag;                          
	
	/** The special risk tag. */
	private String specialRiskTag;                      
	
	/** The eval sw. */
	private String evalSw;  
	
	/** The wc sw. */
	private String wcSw;
	
	private String tarfCd;
		
	/**
	 * Gets the line cd.
	 * 
	 * @return the line cd
	 */
	public String getLineCd() {
		return lineCd;
	}

	/**
	 * Sets the line cd.
	 * 
	 * @param lineCd the new line cd
	 */
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}

	/**
	 * Gets the peril cd.
	 * 
	 * @return the peril cd
	 */
	public Integer getPerilCd() {
		return perilCd;
	}

	/**
	 * Sets the peril cd.
	 * 
	 * @param perilCd the new peril cd
	 */
	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}

	/**
	 * Gets the peril sname.
	 * 
	 * @return the peril sname
	 */
	public String getPerilSname() {
		return perilSname;
	}

	/**
	 * Sets the peril sname.
	 * 
	 * @param perilSname the new peril sname
	 */
	public void setPerilSname(String perilSname) {
		this.perilSname = perilSname;
	}

	/**
	 * Gets the peril name.
	 * 
	 * @return the peril name
	 */
	public String getPerilName() {
		return perilName;
	}

	/**
	 * Sets the peril name.
	 * 
	 * @param perilName the new peril name
	 */
	public void setPerilName(String perilName) {
		this.perilName = perilName;
	}

	/**
	 * Gets the peril type.
	 * 
	 * @return the peril type
	 */
	public String getPerilType() {
		return perilType;
	}

	/**
	 * Sets the peril type.
	 * 
	 * @param perilType the new peril type
	 */
	public void setPerilType(String perilType) {
		this.perilType = perilType;
	}

	/**
	 * Gets the peril lname.
	 * 
	 * @return the peril lname
	 */
	public String getPerilLname() {
		return perilLname;
	}

	/**
	 * Sets the peril lname.
	 * 
	 * @param perilLname the new peril lname
	 */
	public void setPerilLname(String perilLname) {
		this.perilLname = perilLname;
	}

	/**
	 * Gets the basc line cd.
	 * 
	 * @return the basc line cd
	 */
	public String getBascLineCd() {
		return bascLineCd;
	}

	/**
	 * Sets the basc line cd.
	 * 
	 * @param bascLineCd the new basc line cd
	 */
	public void setBascLineCd(String bascLineCd) {
		this.bascLineCd = bascLineCd;
	}

	/**
	 * Gets the basc perl cd.
	 * 
	 * @return the basc perl cd
	 */
	public Integer getBascPerlCd() {
		return bascPerlCd;
	}

	/**
	 * Sets the basc perl cd.
	 * 
	 * @param bascPerlCd the new basc perl cd
	 */
	public void setBascPerlCd(Integer bascPerlCd) {
		this.bascPerlCd = bascPerlCd;
	}

	public BigDecimal getIntmCommRt() {
		return intmCommRt;
	}

	public void setIntmCommRt(BigDecimal intmCommRt) {
		this.intmCommRt = intmCommRt;
	}

	/**
	 * Gets the prt flag.
	 * 
	 * @return the prt flag
	 */
	public String getPrtFlag() {
		return prtFlag;
	}

	/**
	 * Sets the prt flag.
	 * 
	 * @param prtFlag the new prt flag
	 */
	public void setPrtFlag(String prtFlag) {
		this.prtFlag = prtFlag;
	}

	/**
	 * Gets the peril class.
	 * 
	 * @return the peril class
	 */
	public String getPerilClass() {
		return perilClass;
	}

	/**
	 * Sets the peril class.
	 * 
	 * @param perilClass the new peril class
	 */
	public void setPerilClass(String perilClass) {
		this.perilClass = perilClass;
	}

	/**
	 * Gets the subline cd.
	 * 
	 * @return the subline cd
	 */
	public String getSublineCd() {
		return sublineCd;
	}

	/**
	 * Sets the subline cd.
	 * 
	 * @param sublineCd the new subline cd
	 */
	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	/**
	 * Gets the default tag.
	 * 
	 * @return the default tag
	 */
	public String getDefaultTag() {
		return defaultTag;
	}

	/**
	 * Sets the default tag.
	 * 
	 * @param defaultTag the new default tag
	 */
	public void setDefaultTag(String defaultTag) {
		this.defaultTag = defaultTag;
	}

	/**
	 * Gets the default rate.
	 * 
	 * @return the default rate
	 */
	public BigDecimal getDefaultRate() {
		return defaultRate;
	}

	/**
	 * Sets the default rate.
	 * 
	 * @param defaultRate the new default rate
	 */
	public void setDefaultRate(BigDecimal defaultRate) {
		this.defaultRate = defaultRate;
	}

	/**
	 * Gets the default tsi.
	 * 
	 * @return the default tsi
	 */
	public BigDecimal getDefaultTsi() {
		return defaultTsi;
	}

	/**
	 * Sets the default tsi.
	 * 
	 * @param defaultTsi the new default tsi
	 */
	public void setDefaultTsi(BigDecimal defaultTsi) {
		this.defaultTsi = defaultTsi;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return remarks;
	}

	/**
	 * Sets the remarks.
	 * 
	 * @param remarks the new remarks
	 */
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	/**
	 * Gets the cpi rec no.
	 * 
	 * @return the cpi rec no
	 */
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}

	/**
	 * Sets the cpi rec no.
	 * 
	 * @param cpiRecNo the new cpi rec no
	 */
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}

	/**
	 * Gets the cpi branch cd.
	 * 
	 * @return the cpi branch cd
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}

	/**
	 * Sets the cpi branch cd.
	 * 
	 * @param cpiBranchCd the new cpi branch cd
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}

	/**
	 * Gets the zone type.
	 * 
	 * @return the zone type
	 */
	public String getZoneType() {
		return zoneType;
	}

	/**
	 * Sets the zone type.
	 * 
	 * @param zoneType the new zone type
	 */
	public void setZoneType(String zoneType) {
		this.zoneType = zoneType;
	}

	/**
	 * Gets the benefit cd.
	 * 
	 * @return the benefit cd
	 */
	public String getBenefitCd() {
		return benefitCd;
	}

	/**
	 * Sets the benefit cd.
	 * 
	 * @param benefitCd the new benefit cd
	 */
	public void setBenefitCd(String benefitCd) {
		this.benefitCd = benefitCd;
	}

	/**
	 * Gets the dflt rate.
	 * 
	 * @return the dflt rate
	 */
	public BigDecimal getDfltRate() {
		return dfltRate;
	}

	/**
	 * Sets the dflt rate.
	 * 
	 * @param dfltRate the new dflt rate
	 */
	public void setDfltRate(BigDecimal dfltRate) {
		this.dfltRate = dfltRate;
	}

	/**
	 * Gets the dflt tag.
	 * 
	 * @return the dflt tag
	 */
	public String getDfltTag() {
		return dfltTag;
	}

	/**
	 * Sets the dflt tag.
	 * 
	 * @param dfltTag the new dflt tag
	 */
	public void setDfltTag(String dfltTag) {
		this.dfltTag = dfltTag;
	}

	/**
	 * Gets the dflt tsi.
	 * 
	 * @return the dflt tsi
	 */
	public BigDecimal getDfltTsi() {
		return dfltTsi;
	}

	/**
	 * Sets the dflt tsi.
	 * 
	 * @param dfltTsi the new dflt tsi
	 */
	public void setDfltTsi(BigDecimal dfltTsi) {
		this.dfltTsi = dfltTsi;
	}

	/**
	 * Gets the mi basis.
	 * 
	 * @return the mi basis
	 */
	public String getMiBasis() {
		return miBasis;
	}

	/**
	 * Sets the mi basis.
	 * 
	 * @param miBasis the new mi basis
	 */
	public void setMiBasis(String miBasis) {
		this.miBasis = miBasis;
	}

	/**
	 * Gets the ref peril cd.
	 * 
	 * @return the ref peril cd
	 */
	public Integer getRefPerilCd() {
		return refPerilCd;
	}

	/**
	 * Sets the ref peril cd.
	 * 
	 * @param refPerilCd the new ref peril cd
	 */
	public void setRefPerilCd(Integer refPerilCd) {
		this.refPerilCd = refPerilCd;
	}

	/**
	 * Gets the sequence.
	 * 
	 * @return the sequence
	 */
	public Integer getSequence() {
		return sequence;
	}

	/**
	 * Sets the sequence.
	 * 
	 * @param sequence the new sequence
	 */
	public void setSequence(Integer sequence) {
		this.sequence = sequence;
	}

	/**
	 * Gets the expiry print tag.
	 * 
	 * @return the expiry print tag
	 */
	public String getExpiryPrintTag() {
		return expiryPrintTag;
	}

	/**
	 * Sets the expiry print tag.
	 * 
	 * @param expiryPrintTag the new expiry print tag
	 */
	public void setExpiryPrintTag(String expiryPrintTag) {
		this.expiryPrintTag = expiryPrintTag;
	}

	/**
	 * Gets the prof comm tag.
	 * 
	 * @return the prof comm tag
	 */
	public String getProfCommTag() {
		return profCommTag;
	}

	/**
	 * Sets the prof comm tag.
	 * 
	 * @param profCommTag the new prof comm tag
	 */
	public void setProfCommTag(String profCommTag) {
		this.profCommTag = profCommTag;
	}

	/**
	 * Gets the special risk tag.
	 * 
	 * @return the special risk tag
	 */
	public String getSpecialRiskTag() {
		return specialRiskTag;
	}

	/**
	 * Sets the special risk tag.
	 * 
	 * @param specialRiskTag the new special risk tag
	 */
	public void setSpecialRiskTag(String specialRiskTag) {
		this.specialRiskTag = specialRiskTag;
	}

	/**
	 * Gets the eval sw.
	 * 
	 * @return the eval sw
	 */
	public String getEvalSw() {
		return evalSw;
	}

	/**
	 * Sets the eval sw.
	 * 
	 * @param evalSw the new eval sw
	 */
	public void setEvalSw(String evalSw) {
		this.evalSw = evalSw;
	}

	/**
	 * Sets the basic peril.
	 * 
	 * @param basicPeril the new basic peril
	 */
	public void setBasicPeril(String basicPeril) {
		this.basicPeril = basicPeril;
	}

	/**
	 * Gets the basic peril.
	 * 
	 * @return the basic peril
	 */
	public String getBasicPeril() {
		return basicPeril;
	}

	public void setBasicPerilName(String basicPerilName) {
		this.basicPerilName = basicPerilName;
	}

	public String getBasicPerilName() {
		return basicPerilName;
	}

	/**
	 * Sets the ri comm rt.
	 * 
	 * @param riCommRt the new ri comm rt
	 */
	public void setRiCommRt(BigDecimal riCommRt) {
		this.riCommRt = riCommRt;
	}

	/**
	 * Gets the ri comm rt.
	 * 
	 * @return the ri comm rt
	 */
	public BigDecimal getRiCommRt() {
		return riCommRt;
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
	 * @param tarfCd the tarfCd to set
	 */
	public void setTarfCd(String tarfCd) {
		this.tarfCd = tarfCd;
	}

	/**
	 * @return the tarfCd
	 */
	public String getTarfCd() {
		return tarfCd;
	}
}
