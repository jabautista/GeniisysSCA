/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;

import java.math.BigDecimal;
import com.geniisys.giis.entity.BaseEntity;

/**
 * The Class GIISMotorType.
 */
public class GIISMotorType extends BaseEntity {

	/** The type cd. */
	private int typeCd;
	
	/** The motor type desc. */
	private String motorTypeDesc;
	
	/** The subline cd. */
	private String sublineCd;
	
	/** The unladen wt. */
	private String unladenWt;
	
	/** The motor type rate. */
	private BigDecimal motorTypeRate;
	
	/** The remarks. */
	private String remarks;
	
	/** The type class cd. */
	private String typeClassCd;

	/**
	 * Gets the type cd.
	 * 
	 * @return the type cd
	 */
	public int getTypeCd() {
		return typeCd;
	}

	/**
	 * Sets the type cd.
	 * 
	 * @param typeCd the new type cd
	 */
	public void setTypeCd(int typeCd) {
		this.typeCd = typeCd;
	}

	/**
	 * Gets the motor type desc.
	 * 
	 * @return the motor type desc
	 */
	public String getMotorTypeDesc() {
		return motorTypeDesc;
	}

	/**
	 * Sets the motor type desc.
	 * 
	 * @param motorTypeDesc the new motor type desc
	 */
	public void setMotorTypeDesc(String motorTypeDesc) {
		this.motorTypeDesc = motorTypeDesc;
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
	 * Gets the unladen wt.
	 * 
	 * @return the unladen wt
	 */
	public String getUnladenWt() {
		return unladenWt;
	}

	/**
	 * Sets the unladen wt.
	 * 
	 * @param unladenWt the new unladen wt
	 */
	public void setUnladenWt(String unladenWt) {
		this.unladenWt = unladenWt;
	}

	/**
	 * Gets the motor type rate.
	 * 
	 * @return the motor type rate
	 */
	public BigDecimal getMotorTypeRate() {
		return motorTypeRate;
	}

	/**
	 * Sets the motor type rate.
	 * 
	 * @param motorTypeRate the new motor type rate
	 */
	public void setMotorTypeRate(BigDecimal motorTypeRate) {
		this.motorTypeRate = motorTypeRate;
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
	 * Gets the type class cd.
	 * 
	 * @return the type class cd
	 */
	public String getTypeClassCd() {
		return typeClassCd;
	}

	/**
	 * Sets the type class cd.
	 * 
	 * @param typeClassCd the new type class cd
	 */
	public void setTypeClassCd(String typeClassCd) {
		this.typeClassCd = typeClassCd;
	}
}
