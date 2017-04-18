/**
 * 
 */
package com.geniisys.giac.entity;

import java.util.Date;

import com.geniisys.giis.entity.BaseEntity;

/**
 * @author steven
 * @date 04.11.2013
 */
public class GIACBatchAcctEntry extends BaseEntity{
	private Date prodDate;
	
	private Date newProdDate;
	
	private Integer giacbNum;
	
	private String excludeSpecial;
	
	private String msg;
	
	private String log;
	
	private String genHome;
	
	private String sqlPath;
	
	private Integer varParamValueN;
	
	private String fundCd;
	
	private String riIssCd;
	
	private String issCd;  //used in GIACB004
	
	private String varIssCd; //used in GIACB004
	
	private Integer prodTkUp; //used in GIACB004
	
	private String premRecGrossTag;
	
	private String report;
	
	private String errorMsg;
	
	private String process;
	
	private boolean cond;

	/**
	 * @return the prodDate
	 */
	public Date getProdDate() {
		return prodDate;
	}

	/**
	 * @param prodDate the prodDate to set
	 */
	public void setProdDate(Date prodDate) {
		this.prodDate = prodDate;
	}

	/**
	 * @return the newProdDate
	 */
	public Date getNewProdDate() {
		return newProdDate;
	}

	/**
	 * @param newProdDate the newProdDate to set
	 */
	public void setNewProdDate(Date newProdDate) {
		this.newProdDate = newProdDate;
	}

	/**
	 * @return the giacbNum
	 */
	public Integer getGiacbNum() {
		return giacbNum;
	}

	/**
	 * @param giacbNum the giacbNum to set
	 */
	public void setGiacbNum(Integer giacbNum) {
		this.giacbNum = giacbNum;
	}

	/**
	 * @return the excludeSpecial
	 */
	public String getExcludeSpecial() {
		return excludeSpecial;
	}

	/**
	 * @param excludeSpecial the excludeSpecial to set
	 */
	public void setExcludeSpecial(String excludeSpecial) {
		this.excludeSpecial = excludeSpecial;
	}

	/**
	 * @return the msg
	 */
	public String getMsg() {
		return msg;
	}

	/**
	 * @param msg the msg to set
	 */
	public void setMsg(String msg) {
		this.msg = msg;
	}

	/**
	 * @return the log
	 */
	public String getLog() {
		return log;
	}

	/**
	 * @param log the log to set
	 */
	public void setLog(String log) {
		this.log = log;
	}

	/**
	 * @return the genHome
	 */
	public String getGenHome() {
		return genHome;
	}

	/**
	 * @param genHome the genHome to set
	 */
	public void setGenHome(String genHome) {
		this.genHome = genHome;
	}

	/**
	 * @return the sqlPath
	 */
	public String getSqlPath() {
		return sqlPath;
	}

	/**
	 * @param sqlPath the sqlPath to set
	 */
	public void setSqlPath(String sqlPath) {
		this.sqlPath = sqlPath;
	}

	/**
	 * @return the varParamValueN
	 */
	public Integer getVarParamValueN() {
		return varParamValueN;
	}

	/**
	 * @param varParamValueN the varParamValueN to set
	 */
	public void setVarParamValueN(Integer varParamValueN) {
		this.varParamValueN = varParamValueN;
	}

	/**
	 * @return the fundCd
	 */
	public String getFundCd() {
		return fundCd;
	}

	/**
	 * @param fundCd the fundCd to set
	 */
	public void setFundCd(String fundCd) {
		this.fundCd = fundCd;
	}

	/**
	 * @return the riIssCd
	 */
	public String getRiIssCd() {
		return riIssCd;
	}

	/**
	 * @param riIssCd the riIssCd to set
	 */
	public void setRiIssCd(String riIssCd) {
		this.riIssCd = riIssCd;
	}

	/**
	 * @return the premRecGrossTag
	 */
	public String getPremRecGrossTag() {
		return premRecGrossTag;
	}

	/**
	 * @param premRecGrossTag the premRecGrossTag to set
	 */
	public void setPremRecGrossTag(String premRecGrossTag) {
		this.premRecGrossTag = premRecGrossTag;
	}

	/**
	 * @return the report
	 */
	public String getReport() {
		return report;
	}

	/**
	 * @param report the report to set
	 */
	public void setReport(String report) {
		this.report = report;
	}

	/**
	 * @return the errorMsg
	 */
	public String getErrorMsg() {
		return errorMsg;
	}

	/**
	 * @param errorMsg the errorMsg to set
	 */
	public void setErrorMsg(String errorMsg) {
		this.errorMsg = errorMsg;
	}

	/**
	 * @return the process
	 */
	public String getProcess() {
		return process;
	}

	/**
	 * @param process the process to set
	 */
	public void setProcess(String process) {
		this.process = process;
	}

	/**
	 * @return the cond
	 */
	public boolean isCond() {
		return cond;
	}

	/**
	 * @param cond the cond to set
	 */
	public void setCond(boolean cond) {
		this.cond = cond;
	}

	/**
	 * @return the issCd
	 */
	public String getIssCd() {
		return issCd;
	}

	/**
	 * @param issCd the issCd to set
	 */
	public void setIssCd(String issCd) {
		this.issCd = issCd;
	}

	/**
	 * @return the varIssCd
	 */
	public String getVarIssCd() {
		return varIssCd;
	}

	/**
	 * @param varIssCd the varIssCd to set
	 */
	public void setVarIssCd(String varIssCd) {
		this.varIssCd = varIssCd;
	}

	/**
	 * @return the prodTkUp
	 */
	public Integer getProdTkUp() {
		return prodTkUp;
	}

	/**
	 * @param prodTkUp the prodTkUp to set
	 */
	public void setProdTkUp(Integer prodTkUp) {
		this.prodTkUp = prodTkUp;
	}
	
	
	
}
