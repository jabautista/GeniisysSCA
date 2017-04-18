package com.geniisys.giis.entity;

import java.math.BigDecimal;

public class GIISPostingLimit extends BaseEntity{
	
	private String postingUser;
	private String issCd;
	private String issName;
	private String lineCd;
	private String lineName;
	private String allAmtSw;
	private BigDecimal postLimit;
	private String userId;
	private BigDecimal endtPostLimit;
	private String endtAllAmtSw;
	
	public GIISPostingLimit() {
		super();
	}
	
	public String getPostingUser() {
		return postingUser;
	}
	
	public void setPostingUser(String postingUser) {
		this.postingUser = postingUser;
	}
	
	public String getIssCd() {
		return issCd;
	}
	
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}
	
	public String getLineCd() {
		return lineCd;
	}
	
	public void setLineCd(String lineCd) {
		this.lineCd = lineCd;
	}
	
	public String getLineName() {
		return lineName;
	}

	public void setLineName(String lineName) {
		this.lineName = lineName;
	}
	
	public String getAllAmtSw() {
		return allAmtSw;
	}
	
	public void setAllAmtSw(String allAmtSw) {
		this.allAmtSw = allAmtSw;
	}
	
	public BigDecimal getPostLimit() {
		return postLimit;
	}
	
	public void setPostLimit(BigDecimal postLimit) {
		this.postLimit = postLimit;
	}
	
	public String getUserId() {
		return userId;
	}
	
	public void setUserId(String userId) {
		this.userId = userId;
	}
	
	public BigDecimal getEndtPostLimit() {
		return endtPostLimit;
	}
	
	public void setEndtPostLimit(BigDecimal endtPostLimit) {
		this.endtPostLimit = endtPostLimit;
	}
	
	public String getEndtAllAmtSw() {
		return endtAllAmtSw;
	}
	
	public void setEndtAllAmtSw(String endtAllAmtSw) {
		this.endtAllAmtSw = endtAllAmtSw;
	}

	public String getIssName() {
		return issName;
	}

	public void setIssName(String issName) {
		this.issName = issName;
	}

}
