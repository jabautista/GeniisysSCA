/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	GICLS024
 * Created By	:	rencela
 * Create Date	:	Jan 26, 2012
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;

import com.geniisys.framework.util.BaseEntity;

public class GICLClaimReserve extends BaseEntity{
	
	private Integer claimId;
	private Integer itemNo;
	private Integer perilCd;
	private BigDecimal lossReserve;
	private BigDecimal lossesPaid;
	private BigDecimal expenseReserve;
	private BigDecimal expensesPaid;
	private Integer cpiRecNo;
	private String cpiBranchCd;
	private Integer currencyCd;
	private BigDecimal convertRate;
	private BigDecimal netPdLoss;
	private BigDecimal netPdExp;
	private Integer groupedItemNo;
	private String redistSw;
	
	private BigDecimal totalReserveAmount;
	
	private BigDecimal dspTotalResAmount;
	private BigDecimal dspTotalPaid;
	
	public GICLClaimReserve(){
	}
	
	public GICLClaimReserve(HashMap<String, Object> properties){
		Iterator<String> keys = properties.keySet().iterator();
		String key = "";
		while(keys.hasNext()){
			key = keys.next();
			try{
				if("claimId".equals(key)){
					this.claimId = Integer.parseInt(properties.get(key).toString());
				}else if("itemNo".equals(key)){
					this.itemNo = Integer.parseInt(properties.get(key).toString());
				}else if("perilCd".equals(key)){	
					this.perilCd = Integer.parseInt(properties.get(key).toString());
				}else if("lossReserve".equals(key)){	
					this.lossReserve = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("lossesPaid".equals(key)){	
					this.lossesPaid = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("expenseReserve".equals(key)){
					this.expenseReserve = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("expensesPaid".equals(key)){
					this.expensesPaid = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("cpiRecNo".equals(key)){	
					this.cpiRecNo = Integer.parseInt(properties.get(key).toString());
				}else if("cpiBranchCd".equals(key)){	
					this.cpiBranchCd = properties.get(key).toString();
				}else if("currencyCd".equals(key)){	
					this.currencyCd = Integer.parseInt(properties.get(key).toString());
				}else if("convertRate".equals(key)){	
					this.convertRate = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("netPdLoss".equals(key)){	
					this.netPdLoss = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("netPdExp".equals(key)){	
					this.netPdExp = new BigDecimal(Double.parseDouble(properties.get(key).toString()));
				}else if("groupedItemNo".equals(key)){	
					this.groupedItemNo = Integer.parseInt(properties.get(key).toString());
				}else if("redistSw".equals(key)){	
					this.redistSw = properties.get(key).toString();
				}
			}catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
	}
	
	public Integer getClaimId(){
		return claimId;
	}

	public void setClaimId(Integer claimId){
		this.claimId = claimId;
	}

	public Integer getItemNo(){
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

	public BigDecimal getLossReserve() {
		return lossReserve;
	}

	public void setLossReserve(BigDecimal lossReserve) {
		this.lossReserve = lossReserve;
	}

	public BigDecimal getLossesPaid() {
		return lossesPaid;
	}

	public void setLossesPaid(BigDecimal lossesPaid) {
		this.lossesPaid = lossesPaid;
	}

	public BigDecimal getExpenseReserve() {
		return expenseReserve;
	}

	public void setExpenseReserve(BigDecimal expenseReserve) {
		this.expenseReserve = expenseReserve;
	}

	public BigDecimal getExpensesPaid() {
		return expensesPaid;
	}

	public void setExpensesPaid(BigDecimal expensesPaid) {
		this.expensesPaid = expensesPaid;
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

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public BigDecimal getConvertRate() {
		return convertRate;
	}

	public void setConvertRate(BigDecimal convertRate) {
		this.convertRate = convertRate;
	}

	public BigDecimal getNetPdLoss() {
		return netPdLoss;
	}

	public void setNetPdLoss(BigDecimal netPdLoss) {
		this.netPdLoss = netPdLoss;
	}

	public BigDecimal getNetPdExp() {
		return netPdExp;
	}

	public void setNetPdExp(BigDecimal netPdExp) {
		this.netPdExp = netPdExp;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}

	public String getRedistSw() {
		return redistSw;
	}

	public void setRedistSw(String redistSw) {
		this.redistSw = redistSw;
	}

	public void setTotalReserveAmount(BigDecimal totalReserveAmount) {
		this.totalReserveAmount = totalReserveAmount;
	}

	public BigDecimal getTotalReserveAmount() {
		return totalReserveAmount;
	}

	public BigDecimal getDspTotalResAmount() {
		return this.getLossReserve().add(this.getExpenseReserve());
	}

	public void setDspTotalResAmount(BigDecimal dspTotalResAmount) {
		this.dspTotalResAmount = dspTotalResAmount;
	}

	public BigDecimal getDspTotalPaid() {
		return this.getLossesPaid().add(this.getExpensesPaid());
	}

	public void setDspTotalPaid(BigDecimal dspTotalPaid) {
		this.dspTotalPaid = dspTotalPaid;
	}
	
}