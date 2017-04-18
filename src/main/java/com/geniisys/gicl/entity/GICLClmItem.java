/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	rencela
 * Create Date	:	Mar 6, 2012
 ***************************************************/
package com.geniisys.gicl.entity;

import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.geniisys.framework.util.BaseEntity;

public class GICLClmItem extends BaseEntity {
	private Integer	claimId;
	private Integer itemNo;
	private Integer currencyCd;
	private String	itemTitle;
	private Date	lossDate;
	private Integer	cpiRecNo;
	private String	cpiBranchCd;
	private String	otherInfo;
	private BigDecimal	currencyRate;
	private Integer		clmCurrencyCd;
	private BigDecimal	clmCurrencyRate;
	private Integer	groupedItemNo;
	private String	itemDesc;
	private String	itemDesc2;
	
	public GICLClmItem() {
		// empty constructor
	}
	
	/**
	 * Creates a GICLClmItem object from :clmItemMap
	 * @param clmItemMap
	 * @return
	 */
	public static GICLClmItem makeGICLClaimItem(Map<String, Object> clmItemMap){
		GICLClmItem i = new GICLClmItem();
		Iterator<String> iter = clmItemMap.keySet().iterator();
		String k = "";
		while(iter.hasNext()){
			k = iter.next();
			try{
				if(k.equals("claimId")){				i.setClaimId(Integer.parseInt(clmItemMap.get(k).toString()));
				}else if(k.equals("itemNo")){			i.setItemNo(Integer.parseInt(clmItemMap.get(k).toString()));
				}else if(k.equals("currencyCd")){		i.setCurrencyCd(Integer.parseInt(clmItemMap.get(k).toString()));
				}else if(k.equals("itemTitle")){		i.setItemTitle(clmItemMap.get(k).toString());
				}else if(k.equals("lossDate")){			i.setLossDate((Date)clmItemMap.get(k));
				}else if(k.equals("cpiRecNo")){			i.setCpiRecNo(Integer.parseInt(clmItemMap.get(k).toString()));
				}else if(k.equals("cpiBranchCd")){		i.setCpiBranchCd(clmItemMap.get(k).toString());
				}else if(k.equals("otherInfo")){		i.setOtherInfo(clmItemMap.get(k).toString());
				}else if(k.equals("currencyRate")){		i.setCurrencyRate(new BigDecimal(Double.parseDouble(clmItemMap.get(k).toString())));
				}else if(k.equals("clmCurrencyCd")){	i.setClmCurrencyCd(Integer.parseInt(clmItemMap.toString()));
				}else if(k.equals("clmCurrencyRate")){	i.setClmCurrencyRate(new BigDecimal(clmItemMap.get(k).toString()));
				}else if(k.equals("groupedItemNo")){	i.setGroupedItemNo(Integer.parseInt(clmItemMap.get(k).toString()));
				}else if(k.equals("itemDesc")){			i.setItemDesc(clmItemMap.get(k).toString());
				}else if(k.equals("itemDesc2")){		i.setItemDesc2(clmItemMap.get(k).toString());
				}
			}catch (Exception e) {
				System.out.println(e.getMessage());
			}
		}
		return i;
	}

	/**
	 * Creates a map object from this class
	 * @return map
	 */
	public Map<String, Object> toMapObject(){
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("claimId", this.claimId);
		map.put("itemNo", this.itemNo);
		map.put("currencyCd", this.currencyCd);
		map.put("itemTitle", this.itemTitle);
		map.put("lossDate", this.lossDate);
		map.put("cpiRecNo", this.cpiRecNo);
		map.put("cpiBranchCd", this.cpiBranchCd);
		map.put("otherInfo", this.otherInfo);
		map.put("currencyRate", this.currencyRate);
		map.put("clmCurrencyRate", this.clmCurrencyRate);
		map.put("clmCurrencyCd", this.clmCurrencyCd);
		map.put("groupedItemNo", this.groupedItemNo);
		map.put("itemDesc", this.itemDesc);
		map.put("itemDesc2", this.itemDesc2);
		return map;
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

	public Integer getCurrencyCd() {
		return currencyCd;
	}

	public void setCurrencyCd(Integer currencyCd) {
		this.currencyCd = currencyCd;
	}

	public String getItemTitle() {
		return itemTitle;
	}

	public void setItemTitle(String itemTitle) {
		this.itemTitle = itemTitle;
	}

	public Date getLossDate() {
		return lossDate;
	}

	/**
	 * Get a string formatted date
	 * @return
	 */
	public String getStrLossDate(){
		DateFormat df = new SimpleDateFormat("MM-dd-yyyy hh:mm:ss aa");
		if (lossDate != null) {
			return df.format(lossDate);
		} else {
			return null;
		}
	}
	
	public void setLossDate(Date lossDate) {
		this.lossDate = lossDate;
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

	public String getOtherInfo() {
		return otherInfo;
	}

	public void setOtherInfo(String otherInfo) {
		this.otherInfo = otherInfo;
	}

	public BigDecimal getCurrencyRate() {
		return currencyRate;
	}

	public void setCurrencyRate(BigDecimal currencyRate) {
		this.currencyRate = currencyRate;
	}

	public Integer getClmCurrencyCd() {
		return clmCurrencyCd;
	}

	public void setClmCurrencyCd(Integer clmCurrencyCd) {
		this.clmCurrencyCd = clmCurrencyCd;
	}

	public Integer getGroupedItemNo() {
		return groupedItemNo;
	}

	public void setGroupedItemNo(Integer groupedItemNo) {
		this.groupedItemNo = groupedItemNo;
	}

	public String getItemDesc() {
		return itemDesc;
	}

	public void setItemDesc(String itemDesc) {
		this.itemDesc = itemDesc;
	}

	public String getItemDesc2() {
		return itemDesc2;
	}

	public void setItemDesc2(String itemDesc2) {
		this.itemDesc2 = itemDesc2;
	}

	public void setClmCurrencyRate(BigDecimal clmCurrencyRate) {
		this.clmCurrencyRate = clmCurrencyRate;
	}

	public BigDecimal getClmCurrencyRate() {
		return clmCurrencyRate;
	}

}
