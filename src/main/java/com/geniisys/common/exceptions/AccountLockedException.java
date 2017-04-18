/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.exceptions;


/**
 * The Class AccountLockedException.
 */
public class AccountLockedException extends Exception {

	/** The Constant serialVersionUID. */
	private static final long serialVersionUID = -2620143043175545023L;

	/**
	 * Instantiates a new account locked exception.
	 * 
	 * @param message the message
	 */
	public AccountLockedException(String message) {
		super(message);
	}
	
}
