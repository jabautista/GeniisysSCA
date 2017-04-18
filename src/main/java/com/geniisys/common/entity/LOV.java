/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.entity;


/**
 * The Class LOV.
 */
public class LOV {
	
	/** The code. */
	private String code;
	
	/** The name. */
	private String name;
	
	private String shortName;
	
	/** The desc. */
	private String desc;
	
	/** The value string. */
	private String valueString;
	
	/** The value integer. */
	private int valueInteger;
	
	/** The value float. */
	private float valueFloat;
	
	/**
	 * Instantiates a new lOV.
	 */
	public LOV(){		
	}

	/**
	 * Gets the code.
	 * 
	 * @return the code
	 */
	public String getCode() {
		return code;
	}

	/**
	 * Sets the code.
	 * 
	 * @param code the new code
	 */
	public void setCode(String code) {
		this.code = code;
	}

	/**
	 * Gets the desc.
	 * 
	 * @return the desc
	 */
	public String getDesc() {
		return desc;
	}

	/**
	 * Sets the desc.
	 * 
	 * @param desc the new desc
	 */
	public void setDesc(String desc) {
		this.desc = desc;
	}

	/**
	 * Gets the value string.
	 * 
	 * @return the value string
	 */
	public String getValueString() {
		return valueString;
	}

	/**
	 * Sets the value string.
	 * 
	 * @param valueString the new value string
	 */
	public void setValueString(String valueString) {
		this.valueString = valueString;
	}

	/**
	 * Gets the value integer.
	 * 
	 * @return the value integer
	 */
	public int getValueInteger() {
		return valueInteger;
	}

	/**
	 * Sets the value integer.
	 * 
	 * @param valueInteger the new value integer
	 */
	public void setValueInteger(int valueInteger) {
		this.valueInteger = valueInteger;
	}

	/**
	 * Gets the value float.
	 * 
	 * @return the value float
	 */
	public float getValueFloat() {
		return valueFloat;
	}

	/**
	 * Sets the value float.
	 * 
	 * @param valueFloat the new value float
	 */
	public void setValueFloat(float valueFloat) {
		this.valueFloat = valueFloat;
	}

	/**
	 * Gets the name.
	 * 
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * Sets the name.
	 * 
	 * @param name the new name
	 */
	public void setName(String name) {
		this.name = name;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}
	
}
