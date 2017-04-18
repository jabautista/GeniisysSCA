/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
import java.util.List;

import com.geniisys.framework.util.BaseEntity;
import com.geniisys.framework.util.PasswordEncoder;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISUser.
 */
public class GIISUser extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -5636012556617819928L;

	private String maintainUserId;
	
	/** The user grp. */
	private Integer userGrp;
	
	/** The user grp desc. */
	private String userGrpDesc;
	
	/** The username. */
	private String username;
	
	/** The user level. */
	private Integer userLevel;
	
	/** The acctg sw. */
	private String acctgSw;
	
	/** The claim sw. */
	private String claimSw;
	
	/** The dist sw. */
	private String distSw;
	
	/** The exp sw. */
	private String expSw;
	
	/** The inq sw. */
	private String inqSw;
	
	/** The mis sw. */
	private String misSw;
	
	/** The pol sw. */
	private String polSw;
	
	/** The rmd sw. */
	private String rmdSw;
	
	/** The ri sw. */
	private String riSw;
	
	/** The comm update tag. */
	private String commUpdateTag;
	
	/** The mgr sw. */
	private String mgrSw;
	
	/** The mktng sw. */
	private String mktngSw;
	
	/** The all user sw. */
	private String allUserSw;
	
	/** The remarks. */
	private String remarks;
	
	/** The last user id. */
	private String lastUserId;
	
	/** The active flag. */
	private String activeFlag;
	
	/** The change password sw. */
	private String changePasswordSw;
	
	/** The workflow tag. */
	private String workflowTag;
	
	/** The email add. */
	private String emailAdd;
	
	/** The password. */
	private String password;
	
	/** The iss cd. */
	private String issCd;
	
	/** The iss name. */
	private String issName;
	
	/** The last password reset. */
	private Date lastPasswordReset;
	
	/** The days before password expires. */
	private Integer daysBeforePasswordExpires;
	
	/** The transactions. */
	private List<GIISUserTran> transactions;
	
	private Date lastLogin;
	private String tempAccessTag;
	private String allowGenFileSw;
	private String strLastUpdate2;
	private String salt;
	private String unchangedPw;
	private BigDecimal resetPwDuration;
	private Integer invalidLoginTries;

	/**
	 * Instantiates a new gIIS user.
	 */
	public GIISUser() {

	}

	public Date getLastLogin() {
		return lastLogin;
	}

	public void setLastLogin(Date lastLogin) {
		this.lastLogin = lastLogin;
	}

	/**
	 * Instantiates a new gIIS user.
	 * 
	 * @param userId the user id
	 */
	public GIISUser(String userId) {
		this.setUserId(userId);
	}

	public GIISUser(String userId, String password) {
		this.setUserId(userId);
		this.password = password;
	}

	/**
	 * Gets the transactions.
	 * 
	 * @return the transactions
	 */
	public List<GIISUserTran> getTransactions() {
		return transactions;
	}

	/**
	 * Sets the transactions.
	 * 
	 * @param transactions the new transactions
	 */
	public void setTransactions(List<GIISUserTran> transactions) {
		this.transactions = transactions;
	}

	/**
	 * Gets the days before password expires.
	 * 
	 * @return the days before password expires
	 */
	public Integer getDaysBeforePasswordExpires() {
		return daysBeforePasswordExpires;
	}

	/**
	 * Sets the days before password expires.
	 * 
	 * @param daysBeforePasswordExpires the new days before password expires
	 */
	public void setDaysBeforePasswordExpires(Integer daysBeforePasswordExpires) {
		this.daysBeforePasswordExpires = daysBeforePasswordExpires;
	}

	/**
	 * Gets the last password reset.
	 * 
	 * @return the last password reset
	 */
	public Date getLastPasswordReset() {
		return lastPasswordReset;
	}

	/**
	 * Sets the last password reset.
	 * 
	 * @param lastPasswordReset the new last password reset
	 */
	public void setLastPasswordReset(Date lastPasswordReset) {
		this.lastPasswordReset = lastPasswordReset;
	}

	/**
	 * Gets the user grp.
	 * 
	 * @return the user grp
	 */
	public Integer getUserGrp() {
		return userGrp;
	}

	/**
	 * Sets the user grp.
	 * 
	 * @param userGrp the new user grp
	 */
	public void setUserGrp(Integer userGrp) {
		this.userGrp = userGrp;
	}

	/**
	 * Gets the username.
	 * 
	 * @return the username
	 */
	public String getUsername() {
		return username;
	}

	/**
	 * Sets the username.
	 * 
	 * @param username the new username
	 */
	public void setUsername(String username) {
		this.username = username;
	}

	/**
	 * Gets the user level.
	 * 
	 * @return the user level
	 */
	public Integer getUserLevel() {
		return userLevel;
	}

	/**
	 * Sets the user level.
	 * 
	 * @param userLevel the new user level
	 */
	public void setUserLevel(Integer userLevel) {
		this.userLevel = userLevel;
	}

	/**
	 * Gets the acctg sw.
	 * 
	 * @return the acctg sw
	 */
	public String getAcctgSw() {
		return acctgSw;
	}

	/**
	 * Sets the acctg sw.
	 * 
	 * @param acctgSw the new acctg sw
	 */
	public void setAcctgSw(String acctgSw) {
		this.acctgSw = acctgSw;
	}

	/**
	 * Gets the claim sw.
	 * 
	 * @return the claim sw
	 */
	public String getClaimSw() {
		return claimSw;
	}

	/**
	 * Sets the claim sw.
	 * 
	 * @param claimSw the new claim sw
	 */
	public void setClaimSw(String claimSw) {
		this.claimSw = claimSw;
	}

	/**
	 * Gets the dist sw.
	 * 
	 * @return the dist sw
	 */
	public String getDistSw() {
		return distSw;
	}

	/**
	 * Sets the dist sw.
	 * 
	 * @param distSw the new dist sw
	 */
	public void setDistSw(String distSw) {
		this.distSw = distSw;
	}

	/**
	 * Gets the exp sw.
	 * 
	 * @return the exp sw
	 */
	public String getExpSw() {
		return expSw;
	}

	/**
	 * Sets the exp sw.
	 * 
	 * @param expSw the new exp sw
	 */
	public void setExpSw(String expSw) {
		this.expSw = expSw;
	}

	/**
	 * Gets the inq sw.
	 * 
	 * @return the inq sw
	 */
	public String getInqSw() {
		return inqSw;
	}

	/**
	 * Sets the inq sw.
	 * 
	 * @param inqSw the new inq sw
	 */
	public void setInqSw(String inqSw) {
		this.inqSw = inqSw;
	}

	/**
	 * Gets the mis sw.
	 * 
	 * @return the mis sw
	 */
	public String getMisSw() {
		return misSw;
	}

	/**
	 * Sets the mis sw.
	 * 
	 * @param misSw the new mis sw
	 */
	public void setMisSw(String misSw) {
		this.misSw = misSw;
	}

	/**
	 * Gets the pol sw.
	 * 
	 * @return the pol sw
	 */
	public String getPolSw() {
		return polSw;
	}

	/**
	 * Sets the pol sw.
	 * 
	 * @param polSw the new pol sw
	 */
	public void setPolSw(String polSw) {
		this.polSw = polSw;
	}

	/**
	 * Gets the rmd sw.
	 * 
	 * @return the rmd sw
	 */
	public String getRmdSw() {
		return rmdSw;
	}

	/**
	 * Sets the rmd sw.
	 * 
	 * @param rmdSw the new rmd sw
	 */
	public void setRmdSw(String rmdSw) {
		this.rmdSw = rmdSw;
	}

	/**
	 * Gets the ri sw.
	 * 
	 * @return the ri sw
	 */
	public String getRiSw() {
		return riSw;
	}

	/**
	 * Sets the ri sw.
	 * 
	 * @param riSw the new ri sw
	 */
	public void setRiSw(String riSw) {
		this.riSw = riSw;
	}

	/**
	 * Gets the comm update tag.
	 * 
	 * @return the comm update tag
	 */
	public String getCommUpdateTag() {
		return commUpdateTag;
	}

	/**
	 * Sets the comm update tag.
	 * 
	 * @param commUpdateTag the new comm update tag
	 */
	public void setCommUpdateTag(String commUpdateTag) {
		this.commUpdateTag = commUpdateTag;
	}

	/**
	 * Gets the mgr sw.
	 * 
	 * @return the mgr sw
	 */
	public String getMgrSw() {
		return mgrSw;
	}

	/**
	 * Sets the mgr sw.
	 * 
	 * @param mgrSw the new mgr sw
	 */
	public void setMgrSw(String mgrSw) {
		this.mgrSw = mgrSw;
	}

	/**
	 * Gets the mktng sw.
	 * 
	 * @return the mktng sw
	 */
	public String getMktngSw() {
		return mktngSw;
	}

	/**
	 * Sets the mktng sw.
	 * 
	 * @param mktngSw the new mktng sw
	 */
	public void setMktngSw(String mktngSw) {
		this.mktngSw = mktngSw;
	}

	/**
	 * Gets the all user sw.
	 * 
	 * @return the all user sw
	 */
	public String getAllUserSw() {
		return allUserSw;
	}

	/**
	 * Sets the all user sw.
	 * 
	 * @param allUserSw the new all user sw
	 */
	public void setAllUserSw(String allUserSw) {
		this.allUserSw = allUserSw;
	}

	/**
	 * Gets the remarks.
	 * 
	 * @return the remarks
	 */
	public String getRemarks() {
		return StringFormatter.escapeBackslash(remarks); //Added by Carlo SR 22009 08.24.2016
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
	 * Gets the last user id.
	 * 
	 * @return the last user id
	 */
	public String getLastUserId() {
		return lastUserId;
	}

	/**
	 * Sets the last user id.
	 * 
	 * @param lastUserId the new last user id
	 */
	public void setLastUserId(String lastUserId) {
		this.lastUserId = lastUserId;
	}

	/**
	 * Gets the active flag.
	 * 
	 * @return the active flag
	 */
	public String getActiveFlag() {
		return activeFlag;
	}

	/**
	 * Sets the active flag.
	 * 
	 * @param activeFlag the new active flag
	 */
	public void setActiveFlag(String activeFlag) {
		this.activeFlag = activeFlag;
	}

	/**
	 * Gets the change password sw.
	 * 
	 * @return the change password sw
	 */
	public String getChangePasswordSw() {
		return changePasswordSw;
	}

	/**
	 * Sets the change password sw.
	 * 
	 * @param changePasswordSw the new change password sw
	 */
	public void setChangePasswordSw(String changePasswordSw) {
		this.changePasswordSw = changePasswordSw;
	}

	/**
	 * Gets the workflow tag.
	 * 
	 * @return the workflow tag
	 */
	public String getWorkflowTag() {
		return workflowTag;
	}

	/**
	 * Sets the workflow tag.
	 * 
	 * @param workflowTag the new workflow tag
	 */
	public void setWorkflowTag(String workflowTag) {
		this.workflowTag = workflowTag;
	}

	/**
	 * Gets the email add.
	 * 
	 * @return the email add
	 */
	public String getEmailAdd() {
		return emailAdd;
	}

	public String getEncryptedEmailAdd() {
		String email = null;
		try {
			if(this.emailAdd != null) {
				email = StringFormatter.escapeBackslash4(PasswordEncoder.doEncrypt(emailAdd)); //Dren 02.16.2016 SR-21366
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return email;
	}
	
	public String getDecryptedEmailAdd() {
		String email = null;
		try {
			if(this.emailAdd != null) {
				email = PasswordEncoder.doDecrypt(emailAdd);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return email;
	}
	
	/**
	 * Sets the email add.
	 * 
	 * @param emailAdd the new email add
	 */
	public void setEmailAdd(String emailAdd) {
		this.emailAdd = emailAdd;
	}

	/**
	 * Gets the password.
	 * 
	 * @return the password
	 */
	public String getPassword() {
		return password;
	}

	/**
	 * Sets the password.
	 * 
	 * @param password the new password
	 */
	public void setPassword(String password) {
		this.password = password;
	}

	/**
	 * Gets the user grp desc.
	 * 
	 * @return the user grp desc
	 */
	public String getUserGrpDesc() {
		return userGrpDesc;
	}

	/**
	 * Sets the user grp desc.
	 * 
	 * @param userGrpDesc the new user grp desc
	 */
	public void setUserGrpDesc(String userGrpDesc) {
		this.userGrpDesc = userGrpDesc;
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
	 * Gets the iss name.
	 * 
	 * @return the iss name
	 */
	public String getIssName() {
		return issName;
	}

	/**
	 * Sets the iss name.
	 * 
	 * @param issName the new iss name
	 */
	public void setIssName(String issName) {
		this.issName = issName;
	}

	public void setTempAccessTag(String tempAccessTag) {
		this.tempAccessTag = tempAccessTag;
	}

	public String getTempAccessTag() {
		return tempAccessTag;
	}

	public String getStrLastUpdate2() {
		return strLastUpdate2;
	}

	public void setStrLastUpdate2(String strLastUpdate2) {
		this.strLastUpdate2 = strLastUpdate2;
	}

	public String getMaintainUserId() {
		return maintainUserId;
	}

	public void setMaintainUserId(String maintainUserId) {
		this.maintainUserId = maintainUserId;
	}

	public String getAllowGenFileSw() {
		return allowGenFileSw;
	}

	public void setAllowGenFileSw(String allowGenFileSw) {
		this.allowGenFileSw = allowGenFileSw;
	}
	
	public String getSalt() {
		return salt;
	}
	
	public void setSalt(String salt) {
		this.salt = salt;
	}
	
	public String getUnchangedPw() {
		return unchangedPw;
	}
	
	public void setUnchangedPw(String unchangedPw) {
		this.unchangedPw = unchangedPw;
	}
	
	public BigDecimal getResetPwDuration() {
		return resetPwDuration;
	}
	
	public void setResetPwDuration(BigDecimal resetPwDuration) {
		this.resetPwDuration = resetPwDuration;
	}

	public Integer getInvalidLoginTries() {
		return invalidLoginTries;
	}

	public void setInvalidLoginTries(Integer invalidLoginTries) {
		this.invalidLoginTries = invalidLoginTries;
	}
}
