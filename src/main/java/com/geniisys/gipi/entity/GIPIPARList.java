/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.entity;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.framework.util.DateUtil;


/**
 * The Class GIPIPARList.
 */
public class GIPIPARList extends BaseEntity {	

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = 1L;
	
	private static Logger log = Logger.getLogger(GIPIPARList.class);
	
	/** The par id. */
	private Integer parId;
	
	/** The line cd. */
	private String lineCd;
	
	/** The line cd. */
	private String lineName;
	
	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}

	/** The iss cd. */
	private String issCd;
	
	/** The par yy. */
	private Integer parYy;
	
	/** The quote seq no. */
	private Integer quoteSeqNo;
	
	/** The par type. */
	private String parType;
	
	/** Check if under a package. 
	 * jeffdojello 04.24.2013 */
	private String isPack;	

	/** The assign sw. */
	private String assignSw;
	
	/** The par status. */
	private Integer parStatus;
	
	/** The assd no. */
	private Integer assdNo;
	
	/** The remarks. */
	private String remarks;
	
	/** The assd name. */
	private String assdName;
	
	/** The underwriter. */
	private String underwriter;
	
	/** The quote id. */
	private Integer quoteId;
	
	/** The par seq no. */
	private Integer parSeqNo;
	
	/** The par no. */
	private String parNo;
	
	/** The pack par id. */
	private Integer	packParId;
	
	/** The pack par no. */
	private String packParNo;
	
	/** The subline name. */
	private String sublineName;
	
	/** The pack pol flag. */
	private String packPolFlag;
	
	/** The renew no. */
	private Integer renewNo;
	
	/** The par seq no c. */
	private String parSeqNoC;
	
	/** The status. */
	private String status;
	
	/** The disc exists. */
	private String discExists;
	
	/** The pol flag. */
	private String polFlag;
	private String sublineCd;
	private Integer polSeqNo;
	private Integer issueYy;
	private String opFlag;
	private String address1;
	private String address2;
	private String address3;
	private Integer endtPolicyId;
	private String endtPolicyNo;
	private Date inceptDate;
	private Date expiryDate;
	private Date effDate;
	private Date endtExpiryDate;	
	private BigDecimal shortRtPercent;
	private BigDecimal provPremPct;
	private String provPremTag;
	private String prorateFlag;
	private String compSw;
	private String withTariffSw;
	private Integer ctplCd;
	private String lineMotor;
	private String lineFire;
	private String backEndt;
	private String endtTax;
	private Integer distNo;
	private Integer gipiWInvoiceExist;
	private Integer gipiWInvTaxExist;
	private String parMessage;
	private String bankRefNo;
	private String cnDatePrinted;
	private Integer regionCd;
	private String menuLineCd;
	private String loadTag;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer oldParStatus;
	private Integer inspNo;
	private Integer uploadNo;
	private String arcExtData;
	private String binderExist;
	private String strInceptDate;
	private String strExpiryDate;

	
	/**
	 * @return the strInceptDate
	 */
	public String getStrInceptDate() {
		return strInceptDate;
	}

	/**
	 * @param strInceptDate the strInceptDate to set
	 */
	public void setStrInceptDate(String strInceptDate) {
		this.strInceptDate = strInceptDate;
	}

	/**
	 * @return the strExpiryDate
	 */
	public String getStrExpiryDate() {
		return strExpiryDate;
	}

	/**
	 * @param strExpiryDate the strExpiryDate to set
	 */
	public void setStrExpiryDate(String strExpiryDate) {
		this.strExpiryDate = strExpiryDate;
	}

	public String getBinderExist() {
		return binderExist;
	}

	public void setBinderExist(String binderExist) {
		this.binderExist = binderExist;
	}

	public String getAddress1() {
		return address1;
	}

	public void setAddress1(String address1) {
		this.address1 = address1;
	}

	public String getAddress2() {
		return address2;
	}

	public void setAddress2(String address2) {
		this.address2 = address2;
	}

	public String getAddress3() {
		return address3;
	}

	public void setAddress3(String address3) {
		this.address3 = address3;
	}
	
	/**
	 * Gets the pol flag.
	 * 
	 * @return the pol flag
	 */
	public String getPolFlag() {
		return polFlag;
	}
	
	/**
	 * Sets the pol flag.
	 * 
	 * @param polFlag the new pol flag
	 */
	public void setPolFlag(String polFlag) {
		this.polFlag = polFlag;
	}
	
	/**
	 * Gets the status.
	 * 
	 * @return the status
	 */
	public String getStatus() {
		return status;
	}
	
	/**
	 * Sets the status.
	 * 
	 * @param status the new status
	 */
	public void setStatus(String status) {
		this.status = status;
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
	 * Gets the iss cd.
	 * 
	 * @return the iss cd
	 */
	public String getIssCd() {
		return issCd;
	}
	
	/**
	 * Sets the iss cd.
	 * 
	 * @param issCd the new iss cd
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	/**
	 * Gets the par yy.
	 * 
	 * @return the par yy
	 */
	public Integer getParYy() {
		return parYy;
	}
	
	/**
	 * Sets the par yy.
	 * 
	 * @param parYy the new par yy
	 */
	public void setParYy(Integer parYy) {
		this.parYy = parYy;
	}
	
	/**
	 * Gets the quote seq no.
	 * 
	 * @return the quote seq no
	 */
	public Integer getQuoteSeqNo() {
		return quoteSeqNo;
	}
	
	/**
	 * Sets the quote seq no.
	 * 
	 * @param quoteSeqNo the new quote seq no
	 */
	public void setQuoteSeqNo(Integer quoteSeqNo) {
		this.quoteSeqNo = quoteSeqNo;
	}
	
	/**
	 * Gets the par type.
	 * 
	 * @return the par type
	 */
	public String getParType() {
		return parType;
	}
	
	/**
	 * Sets the par type.
	 * 
	 * @param parType the new par type
	 */
	public void setParType(String parType) {
		this.parType = parType;
	}
	
	/**
	 * Gets the package switch.
	 * 
	 * @param parType the new par type
	 * jeffdojello 04.24.2013
	 */
	public String getIsPack() {
		return isPack;
	}
	
	/**
	 * Sets the package switch.
	 * 
	 * @param parType the new par type
	 * jeffdojello 04.24.2013
	 */
	public void setIsPack(String isPack) {
		this.isPack = isPack;
	}
	
	/**
	 * Gets the assign sw.
	 * 
	 * @return the assign sw
	 */
	public String getAssignSw() {
		return assignSw;
	}
	
	/**
	 * Sets the assign sw.
	 * 
	 * @param assignSw the new assign sw
	 */
	public void setAssignSw(String assignSw) {
		this.assignSw = assignSw;
	}
	
	/**
	 * Gets the par status.
	 * 
	 * @return the par status
	 */
	public Integer getParStatus() {
		return parStatus;
	}
	
	/**
	 * Sets the par status.
	 * 
	 * @param parStatus the new par status
	 */
	public void setParStatus(Integer parStatus) {
		this.parStatus = parStatus;
	}
	
	/**
	 * Gets the assd no.
	 * 
	 * @return the assd no
	 */
	public Integer getAssdNo() {
		return assdNo;
	}
	
	/**
	 * Sets the assd no.
	 * 
	 * @param assdNo the new assd no
	 */
	public void setAssdNo(Integer assdNo) {
		this.assdNo = assdNo;
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
	 * Gets the assd name.
	 * 
	 * @return the assd name
	 */
	public String getAssdName() {
		return assdName;
	}
	
	/**
	 * Sets the assd name.
	 * 
	 * @param assdName the new assd name
	 */
	public void setAssdName(String assdName) {
		this.assdName = assdName;
	}
	
	/**
	 * Gets the underwriter.
	 * 
	 * @return the underwriter
	 */
	public String getUnderwriter() {
		return underwriter;
	}
	
	/**
	 * Sets the underwriter.
	 * 
	 * @param underwriter the new underwriter
	 */
	public void setUnderwriter(String underwriter) {
		this.underwriter = underwriter;
	}
	
	/**
	 * Gets the quote id.
	 * 
	 * @return the quote id
	 */
	public Integer getQuoteId() {
		return quoteId;
	}
	
	/**
	 * Sets the quote id.
	 * 
	 * @param quoteId the new quote id
	 */
	public void setQuoteId(Integer quoteId) {
		this.quoteId = quoteId;
	}
	
	/**
	 * Gets the par seq no.
	 * 
	 * @return the par seq no
	 */
	public Integer getParSeqNo() {
		return parSeqNo;
	}
	
	/**
	 * Sets the par seq no.
	 * 
	 * @param parSeqNo the new par seq no
	 */
	public void setParSeqNo(Integer parSeqNo) {
		this.parSeqNo = parSeqNo;
	}
	
	/**
	 * Gets the par no.
	 * 
	 * @return the par no
	 */
	public String getParNo() {
		return parNo;
	}
	
	/**
	 * Sets the par no.
	 * 
	 * @param parNo the new par no
	 */
	public void setParNo(String parNo) {
		this.parNo = parNo;
	}
	
	/**
	 * Gets the pack par id.
	 * 
	 * @return the pack par id
	 */
	public Integer getPackParId() {
		return packParId;
	}
	
	/**
	 * Sets the pack par id.
	 * 
	 * @param packParId the new pack par id
	 */
	public void setPackParId(Integer packParId) {
		this.packParId = packParId;
	}
	
	/**
	 * Gets the pack par no.
	 * 
	 * @return the pack par no
	 */
	public String getPackParNo() {
		return packParNo;
	}
	
	/**
	 * Sets the pack par no.
	 * 
	 * @param packParNo the new pack par no
	 */
	public void setPackParNo(String packParNo) {
		this.packParNo = packParNo;
	}
	
	/**
	 * Gets the subline name.
	 * 
	 * @return the subline name
	 */
	public String getSublineName() {
		return sublineName;
	}
	
	/**
	 * Sets the subline name.
	 * 
	 * @param sublineName the new subline name
	 */
	public void setSublineName(String sublineName) {
		this.sublineName = sublineName;
	}
	
	/**
	 * Gets the pack pol flag.
	 * 
	 * @return the pack pol flag
	 */
	public String getPackPolFlag() {
		return packPolFlag;
	}
	
	/**
	 * Sets the pack pol flag.
	 * 
	 * @param packPolFlag the new pack pol flag
	 */
	public void setPackPolFlag(String packPolFlag) {
		this.packPolFlag = packPolFlag;
	}
	
	/**
	 * Gets the renew no.
	 * 
	 * @return the renew no
	 */
	public Integer getRenewNo() {
		return renewNo;
	}
	
	/**
	 * Sets the renew no.
	 * 
	 * @param renewNo the new renew no
	 */
	public void setRenewNo(Integer renewNo) {
		this.renewNo = renewNo;
	}
	
	/**
	 * Gets the par seq no c.
	 * 
	 * @return the par seq no c
	 */
	public String getParSeqNoC() {
		return parSeqNoC;
	}
	
	/**
	 * Sets the par seq no c.
	 * 
	 * @param parSeqNoC the new par seq no c
	 */
	public void setParSeqNoC(String parSeqNoC) {
		this.parSeqNoC = parSeqNoC;
	}
	
	/**
	 * Sets the disc exists.
	 * 
	 * @param discExists the new disc exists
	 */
	public void setDiscExists(String discExists) {
		this.discExists = discExists;
	}
	
	/**
	 * Gets the disc exists.
	 * 
	 * @return the disc exists
	 */
	public String getDiscExists() {
		return discExists;
	}

	public void setSublineCd(String sublineCd) {
		this.sublineCd = sublineCd;
	}

	public String getSublineCd() {
		return sublineCd;
	}

	public void setPolSeqNo(Integer polSeqNo) {
		this.polSeqNo = polSeqNo;
	}

	public Integer getPolSeqNo() {
		return polSeqNo;
	}

	public void setIssueYy(Integer issueYy) {
		this.issueYy = issueYy;
	}

	public Integer getIssueYy() {
		return issueYy;
	}

	public void setOpFlag(String opFlag) {
		this.opFlag = opFlag;
	}

	public String getOpFlag() {
		return opFlag;
	}

	public void setEndtPolicyId(Integer endtPolicyId) {
		this.endtPolicyId = endtPolicyId;
	}

	public Integer getEndtPolicyId() {
		return endtPolicyId;
	}

	public void setEndtPolicyNo(String endtPolicyNo) {
		this.endtPolicyNo = endtPolicyNo;
	}

	public String getEndtPolicyNo() {
		return endtPolicyNo;
	}

	public void setInceptDate(Date inceptDate) {
		
		this.inceptDate = inceptDate;
	}

	public Date getInceptDate() {
		return inceptDate;
	}

	public void setExpiryDate(Date expiryDate) {
		this.expiryDate = expiryDate;
	}

	public Date getExpiryDate() {
		return expiryDate;
	}

	public void setEffDate(Date effDate) {
		this.effDate = effDate;
	}

	public Date getEffDate() {
		return effDate;
	}

	public void setEndtExpiryDate(Date endtExpiryDate) {
		this.endtExpiryDate = endtExpiryDate;
	}

	public Date getEndtExpiryDate() {
		return endtExpiryDate;
	}

	public void setShortRtPercent(BigDecimal shortRtPercent) {
		this.shortRtPercent = shortRtPercent;
	}

	public BigDecimal getShortRtPercent() {
		return shortRtPercent;
	}

	public void setProvPremPct(BigDecimal provPremPct) {
		this.provPremPct = provPremPct;
	}

	public BigDecimal getProvPremPct() {
		return provPremPct;
	}

	public void setCompSw(String compSw) {
		this.compSw = compSw;
	}

	public String getCompSw() {
		return compSw;
	}

	public void setProvPremTag(String provPremTag) {
		this.provPremTag = provPremTag;
	}

	public String getProvPremTag() {
		return provPremTag;
	}

	public void setProrateFlag(String prorateFlag) {
		this.prorateFlag = prorateFlag;
	}

	public String getProrateFlag() {
		return prorateFlag;
	}

	public void setCtplCd(Integer ctplCd) {
		this.ctplCd = ctplCd;
	}

	public Integer getCtplCd() {
		return ctplCd;
	}

	public void setLineMotor(String lineMotor) {
		this.lineMotor = lineMotor;
	}

	public String getLineMotor() {
		return lineMotor;
	}

	public void setLineFire(String lineFire) {
		this.lineFire = lineFire;
	}

	public String getLineFire() {
		return lineFire;
	}

	public void setWithTariffSw(String withTariffSw) {
		this.withTariffSw = withTariffSw;
	}

	public String getWithTariffSw() {
		return withTariffSw;
	}

	public void setBackEndt(String backEndt) {
		this.backEndt = backEndt;
	}

	public String getBackEndt() {
		return backEndt;
	}

	public void setEndtTax(String endtTax) {
		this.endtTax = endtTax;
	}

	public String getEndtTax() {
		return endtTax;
	}

	/**
	 * @param distNo the distNo to set
	 */
	public void setDistNo(Integer distNo) {
		this.distNo = distNo;
	}

	/**
	 * @return the distNo
	 */
	public Integer getDistNo() {
		return distNo;
	}

	/**
	 * @param gipiWInvoiceExist the gipiWInvoiceExist to set
	 */
	public void setGipiWInvoiceExist(Integer gipiWInvoiceExist) {
		this.gipiWInvoiceExist = gipiWInvoiceExist;
	}

	/**
	 * @return the gipiWInvoiceExist
	 */
	public Integer getGipiWInvoiceExist() {
		return gipiWInvoiceExist;
	}

	/**
	 * @param gipiWInvTaxExist the gipiWInvTaxExist to set
	 */
	public void setGipiWInvTaxExist(Integer gipiWInvTaxExist) {
		this.gipiWInvTaxExist = gipiWInvTaxExist;
	}

	/**
	 * @return the gipiWInvTaxExist
	 */
	public Integer getGipiWInvTaxExist() {
		return gipiWInvTaxExist;
	}

	/**
	 * @param parMessage the parMessage to set
	 */
	public void setParMessage(String parMessage) {
		this.parMessage = parMessage;
	}

	/**
	 * @return the parMessage
	 */
	public String getParMessage() {
		return parMessage;
	}

	public void setBankRefNo(String bankRefNo) {
		this.bankRefNo = bankRefNo;
	}

	public String getBankRefNo() {
		return bankRefNo;
	}

	public void setCnDatePrinted(String cnDatePrinted) {
		this.cnDatePrinted = cnDatePrinted;
	}

	public String getCnDatePrinted() {
		return cnDatePrinted;
	}

	public Integer getRegionCd() {
		return regionCd;
	}

	public void setRegionCd(Integer regionCd) {
		this.regionCd = regionCd;
	}

	public String getMenuLineCd() {
		return menuLineCd;
	}

	public void setMenuLineCd(String menuLineCd) {
		this.menuLineCd = menuLineCd;
	}	
	
	public String getLoadTag() {
		return loadTag;
	}

	public void setLoadTag(String loadTag) {
		this.loadTag = loadTag;
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

	public Integer getOldParStatus() {
		return oldParStatus;
	}

	public void setOldParStatus(Integer oldParStatus) {
		this.oldParStatus = oldParStatus;
	}

	public Integer getInspNo() {
		return inspNo;
	}

	public void setInspNo(Integer inspNo) {
		this.inspNo = inspNo;
	}

	public Integer getUploadNo() {
		return uploadNo;
	}

	public void setUploadNo(Integer uploadNo) {
		this.uploadNo = uploadNo;
	}

	public String getArcExtData() {
		return arcExtData;
	}

	public void setArcExtData(String arcExtData) {
		this.arcExtData = arcExtData;
	}
	
	public GIPIPARList(){
		
	}

	public GIPIPARList(JSONObject obj){
		try{
			this.parId			= obj.isNull("parId") ? null : obj.getInt("parId");
			this.lineCd			= obj.isNull("lineCd") ? null : obj.getString("lineCd");
			this.issCd			= obj.isNull("issCd") ? null : obj.getString("issCd");
			this.parYy			= obj.isNull("parYy") ? null : obj.getInt("parYy");
			this.parSeqNo		= obj.isNull("parSeqNo") ? null : obj.getInt("parSeqNo");
			this.quoteSeqNo		= obj.isNull("quoteSeqNo") ? null : obj.getInt("quoteSeqNo");
			this.parType		= obj.isNull("parType") ? null : obj.getString("parType");
			this.assignSw		= obj.isNull("assignSw") ? null : obj.getString("assignSw");
			this.parStatus		= obj.isNull("parStatus") ? null : obj.getInt("parStatus");
			this.quoteId		= obj.isNull("quoteId") ? null : obj.getInt("quoteId");
			this.assdNo			= obj.isNull("assdNo") ? null : obj.getInt("assdNo");
			this.underwriter	= obj.isNull("underwriter") ? null : obj.getString("underwriter");
			this.remarks		= obj.isNull("remarks") ? null : obj.getString("remarks");
			this.address1		= obj.isNull("address1") ? null : obj.getString("address1");
			this.address2		= obj.isNull("address2") ? null : obj.getString("address2");
			this.address3		= obj.isNull("address3") ? null : obj.getString("address3");
			this.loadTag		= obj.isNull("loadTag") ? null : obj.getString("loadTag");
			this.cpiRecNo		= obj.isNull("cpiRecNo") ? null : obj.getInt("cpiRecNo");
			this.cpiBranchCd	= obj.isNull("cpiBranchCd") ? null : obj.getString("cpiBranchCd");
			this.oldParStatus	= obj.isNull("oldParStatus") ? null : obj.getInt("oldParStatus");
			this.inspNo			= obj.isNull("inspNo") ? null : obj.getInt("inspNo");
			this.uploadNo		= obj.isNull("uploadNo") ? null : obj.getInt("uploadNo");
			this.packParId		= obj.isNull("packParId") ? null : obj.getInt("packParId");
			this.arcExtData		= obj.isNull("arcExtData") ? null : obj.getString("arcExtData");
		}catch(JSONException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}
	}
}
