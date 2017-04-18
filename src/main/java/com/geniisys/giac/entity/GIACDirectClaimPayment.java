/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GIACS017
 * Create Date	:	October 6, 2010
 ***************************************************/
package com.geniisys.giac.entity;

import java.math.BigDecimal;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.gicl.entity.GICLAdvice;
import com.geniisys.gicl.entity.GICLClaimLossExpense;
import com.geniisys.gicl.entity.GICLClaims;
import com.seer.framework.util.StringFormatter;

/**
 * Java object counterpart of giac_direct_claim_payts (accessed through giac_direct_claim_payts_pkg)
 * @author rencela
 */
public class GIACDirectClaimPayment extends BaseEntity{
	
	// LOADED FROM DATABASE - DEFAULT STATUS - IF NOT UPDATED, NO ACTION NECESSARY
	public static final int ENTRY_NOT_MODIFIED 	= 0; 
	// NON EXISTENT IN DATABASE - TO BE SAVED
	public static final int ENTRY_NEWLY_ADDED 	= 1;
	// FOR INSERT/UPDATE 
	public static final int ENTRY_UPDATED	= 2;
	// PRE-EXISTING - TO BE DELETED
	public static final int ENTRY_DELETED	= -1; 
	
	private Integer 	adviceId;
	/** Concatenated LineCd-IssueCode-adviceYear-adviceId */
	private String		adviceSequenceNumber;
	private String		cpiBranchCd;
	private Integer 	claimId;
	private Integer 	claimLossId;
	private BigDecimal	convertRate;
	private Integer 	cpiRecNo;
	private Integer		currencyCode;
	private BigDecimal	disbursementAmount;
	private BigDecimal	foreignCurrencyAmount;
	private Integer 	gaccTranId;
	private BigDecimal	inputVatAmount;
	private BigDecimal	netDisbursementAmount;
	private String		orPrintTag;
	private Integer		originalCurrencyCode;
	private BigDecimal	originalCurrencyRate;
	private String		payeeType;
	private String		payeeClassCd;
	private Integer		payeeCd;
	private String		remarks;
	private Integer		transactionType;
	private BigDecimal	withholdingTaxAmount;
	private Integer 	perilCd;
	
	// properties not included in table
	
	private GICLClaims 	giclClaims;
	private GICLAdvice  giclAdvice;
	private GICLClaimLossExpense giclClaimLossExpense;
	private String claimSequence;
	private String policySequence;
	private String adviceLineCd;
	private String assuredName;
	
	//  
	private Integer entryStatus = ENTRY_NOT_MODIFIED;
	
	public String getClaimSequence() {
		return claimSequence;
	}

	public void setClaimSequence(String claimSequence) {
		this.claimSequence = claimSequence;
	}

	public String getPolicySequence() {
		return policySequence;
	}

	public void setPolicySequence(String policySequence) {
		this.policySequence = policySequence;
	}
	
	/**
	 * Displays all the objects values on console
	 * @author rencela
	 */
	public void displayDetailsInConsole(){
		System.out.println("adviceId              - " + adviceId);
		System.out.println("adviceSequenceNumber  - " + adviceSequenceNumber);
		System.out.println("cpiBranchId			  - " + cpiBranchCd);
		System.out.println("claimId				  - " + claimId) ;
		System.out.println("claimLossId			  - " + claimLossId);
		System.out.println("convertRate			  - " + convertRate);
		System.out.println("cpiRecNo			  - " + cpiRecNo);
		System.out.println("currencyCode		  - " + currencyCode);
		System.out.println("disbursementAmount	  - " + disbursementAmount);
		System.out.println("foreignCurrencyAmount - " + foreignCurrencyAmount);
		System.out.println("gaccTranId			  - " + gaccTranId);
		System.out.println("inputVatAmount		  - " + inputVatAmount);
		System.out.println("netDisbursementAmount - " + netDisbursementAmount);
		System.out.println("orPrintTag			  - " + orPrintTag);
		System.out.println("originalCurrencyCode  - " + originalCurrencyCode);
		System.out.println("originalCurrencyRate  - " + originalCurrencyRate);
		System.out.println("payeeType			  - " + payeeType);
		System.out.println("payeeClassCd		  - " + payeeClassCd);
		System.out.println("payeeCd				  - " + payeeCd);
		System.out.println("remarks				  - " + remarks);
		System.out.println("transactionType		  - " + transactionType);
		System.out.println("withholdingTaxAmount  - " + withholdingTaxAmount);
		System.out.println("giclClaims			  - " + giclClaims);
		System.out.println("giclAdvice			  - " + giclAdvice);
		
		if(giclAdvice != null){
			setAdviceSequenceNumber(this.giclAdvice.getAdviceNo());
		}
		if(giclClaims != null){
			System.out.println("GET ASSURED NAME : " + giclClaims.getAssuredName());
			System.out.println("get assured name2: " + giclClaims.getAssuredName2());
			System.out.println("peril cd         : " + giclClaims.getPerilCd());
		}
	}
	
	/**
	 * Get Advice Id
	 * @return int advice ID
	 */
	public Integer getAdviceId(){
		return adviceId;
	}
	
	/**
	 * Set Advice ID
	 * @param adviceId
	 */
	public void setAdviceId(Integer adviceId) {
		this.adviceId = adviceId;
	}
	
	/**
	 * Get Claim ID
	 * @return
	 */
	public Integer getClaimId() {
		return claimId;
	}
	
	/**
	 * Set Claim ID
	 * @param claimId
	 */
	public void setClaimId(Integer claimId) {
		this.claimId = claimId;
	}
	
	/**
	 * Get Claim Loss ID
	 * @return
	 */
	public Integer getClaimLossId() {
		return claimLossId;
	}
	
	/**
	 * 
	 * @param claimLossId
	 */
	public void setClaimLossId(Integer claimLossId) {
		this.claimLossId = claimLossId;
	}
	
	/**
	 * 
	 * @return
	 */
	public BigDecimal getConvertRate() {
		return convertRate;
	}
	
	/**
	 * 
	 * @param convertRate
	 */
	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}
	
	/**
	 * 
	 * @return
	 */
	public String getCpiBranchCd() {
		return cpiBranchCd;
	}
	
	/**
	 * 
	 * @param cpiBranchId
	 */
	public void setCpiBranchCd(String cpiBranchCd) {
		this.cpiBranchCd = cpiBranchCd;
	}
	
	public Integer getCpiRecNo() {
		return cpiRecNo;
	}
	
	public void setCpiRecNo(Integer cpiRecNo) {
		this.cpiRecNo = cpiRecNo;
	}
	
	public Integer getCurrencyCode() {
		return currencyCode;
	}
	
	public void setCurrencyCode(Integer currencyCode) {
		this.currencyCode = currencyCode;
	}
	
	public BigDecimal getDisbursementAmount() {
		return disbursementAmount;
	}
	
	public void setDisbursementAmount(BigDecimal disbursementAmount) {
		this.disbursementAmount = disbursementAmount;
	}
	
	public BigDecimal getForeignCurrencyAmount() {
		return foreignCurrencyAmount;
	}
	
	public void setForeignCurrencyAmount(BigDecimal foreignCurrencyAmount) {
		this.foreignCurrencyAmount = foreignCurrencyAmount;
	}
	
	public Integer getGaccTranId() {
		return gaccTranId;
	}
	
	public void setGaccTranId(Integer gaccTranId) {
		this.gaccTranId = gaccTranId;
	}
	
	public BigDecimal getInputVatAmount() {
		return inputVatAmount;
	}
	
	public void setInputVatAmount(BigDecimal inputVatAmount) {
		this.inputVatAmount = inputVatAmount;
	}
	
	public BigDecimal getNetDisbursementAmount() {
		return netDisbursementAmount;
	}
	
	public void setNetDisbursementAmount(BigDecimal netDisbursementAmount) {
		this.netDisbursementAmount = netDisbursementAmount;
	}
	
	public Integer getOriginalCurrencyCode() {
		return originalCurrencyCode;
	}
	
	public void setOriginalCurrencyCode(Integer originalCurrencyCode) {
		this.originalCurrencyCode = originalCurrencyCode;
	}
	
	public BigDecimal getOriginalCurrencyRate() {
		return originalCurrencyRate;
	}
	
	public void setOriginalCurrencyRate(BigDecimal originalCurrencyRate) {
		this.originalCurrencyRate = originalCurrencyRate;
	}
	
	public String getOrPrintTag() {
		return orPrintTag;
	}
	
	public void setOrPrintTag(String orPrintTag) {
		this.orPrintTag = orPrintTag;
	}
	
	public Integer getPayeeCd() {
		return payeeCd;
	}
	
	public void setPayeeCd(Integer payeeCd) {
		this.payeeCd = payeeCd;
	}
	
	public String getPayeeClassCd() {
		return payeeClassCd;
	}
	
	public void setPayeeClassCd(String payeeClassCd) {
		this.payeeClassCd = payeeClassCd;
	}
	
	public String getPayeeType() {
		return payeeType;
	}
	
	public void setPayeeType(String payeeType) {
		this.payeeType = payeeType;
	}
	
	public String getRemarks() {
		if(remarks==null){
			remarks = "";
		}
		return remarks;
	}
	
	public void setRemarks(String remarks) {
		if(remarks==null){
			remarks = "";
		}
		this.remarks = remarks;
	}
	
	public Integer getTransactionType() {
		return transactionType;
	}
	
	/**
	 * 
	 * @param transactionType
	 */
	public void setTransactionType(Integer transactionType) {
		this.transactionType = transactionType;
	}
	
	/**
	 * 
	 * @return
	 */
	public BigDecimal getWithholdingTaxAmount() {
		return withholdingTaxAmount;
	}
	
	/**
	 * 
	 * @param withholdingTaxAmount
	 */
	public void setWithholdingTaxAmount(BigDecimal withholdingTaxAmount) {
		this.withholdingTaxAmount = withholdingTaxAmount;
	}

	/**
	 * @param adviceSequenceNumber the adviceSequenceNumber to set
	 */
	public void setAdviceSequenceNumber(String adviceSequenceNumber) {
		this.adviceSequenceNumber = adviceSequenceNumber;
	}

	/**
	 * @return the adviceSequenceNumber
	 */
	public String getAdviceSequenceNumber() {
		return adviceSequenceNumber;
	}

	/**
	 * @param entryStatus the entryStatus to set
	 */
	public void setEntryStatus(Integer entryStatus) {
		this.entryStatus = entryStatus;
	}

	/**
	 * @return the entryStatus
	 */
	public Integer getEntryStatus() {
		return entryStatus;
	}

	/**
	 * @param giclClaims the giclClaims to set
	 */
	public void setGiclClaims(GICLClaims giclClaims) {
		this.giclClaims = giclClaims;	
		if(giclClaims!=null){
			String claimSequence = 	giclClaims.getLineCode()  + "-" + 
									giclClaims.getSublineCd() + "-" + 
									giclClaims.getIssCd() + "-" +
									StringFormatter.zeroPad(giclClaims.getClaimYy(), 2) + "-" + 
									StringFormatter.zeroPad(giclClaims.getClaimSequenceNo(), 7);
			
			String policySequence = giclClaims.getLineCode()  + "-" + 
									giclClaims.getSublineCd() + "-" + 
									giclClaims.getIssCd() + "-" + 
									StringFormatter.zeroPad(giclClaims.getClaimYy(),2) + "-" + 
									StringFormatter.zeroPad(giclClaims.getPolicySequenceNo(),7) + "-" + 
									StringFormatter.zeroPad(giclClaims.getRenewNo(),2);
			this.setClaimSequence(claimSequence);
			this.setPolicySequence(policySequence);	
		}
	}

	/**
	 * @return the giclClaims
	 */
	public GICLClaims getGiclClaims() {
		return giclClaims;
	}

	/**
	 * @param giclAdvice the giclAdvice to set
	 */
	public void setGiclAdvice(GICLAdvice giclAdvice) {
		this.giclAdvice = giclAdvice;
		if(giclAdvice!=null){
			String adviceSeq	= 	giclAdvice.getLineCode() 	+ "-" +
									giclAdvice.getIssueCode() 	+ "-" +
									giclAdvice.getAdviceYear() 	+ "-" +
									StringFormatter.zeroPad(adviceId,6);	
			giclAdvice.setAdviceNo(adviceSeq);
			this.setAdviceLineCd(giclAdvice.getLineCode());
		}
	}

	/**
	 * @return the giclAdvice
	 */
	public GICLAdvice getGiclAdvice() {
		return giclAdvice;
	}

	/**
	 * @param giclClaimLossExpense the giclClaimLossExpense to set
	 */
	public void setGiclClaimLossExpense(GICLClaimLossExpense giclClaimLossExpense) {
		this.giclClaimLossExpense = giclClaimLossExpense;
	}

	/**
	 * @return the giclClaimLossExpense
	 */
	public GICLClaimLossExpense getGiclClaimLossExpense() {
		return giclClaimLossExpense;
	}

	/**
	 * @param adviceLineCd the adviceLineCd to set
	 */
	public void setAdviceLineCd(String adviceLineCd) {
		this.adviceLineCd = adviceLineCd;
	}

	/**
	 * @return the adviceLineCd
	 */
	public String getAdviceLineCd() {
		return adviceLineCd;
	}

	/**
	 * Set assuredName of String type
	 * @param assuredName the assuredName to set
	 */
	public void setAssuredName(String assuredName) {
		this.assuredName = assuredName;
	}

	/**
	 * Get String assuredName
	 * @return the assuredName
	 */
	public String getAssuredName() {
		return assuredName;
	}

	public Integer getPerilCd() {
		return perilCd;
	}

	public void setPerilCd(Integer perilCd) {
		this.perilCd = perilCd;
	}
	
}