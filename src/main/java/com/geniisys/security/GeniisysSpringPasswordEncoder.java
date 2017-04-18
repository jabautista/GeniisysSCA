/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.security;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.encoding.PasswordEncoder;


/**
 * The Class GeniisysSpringPasswordEncoder.
 */
public class GeniisysSpringPasswordEncoder implements PasswordEncoder {

	/* (non-Javadoc)
	 * @see org.springframework.security.authentication.encoding.PasswordEncoder#encodePassword(java.lang.String, java.lang.Object)
	 */
	@Override
	public String encodePassword(String password, Object salt)
			throws DataAccessException {
		//load user and with decrypted password
		Logger log = Logger.getLogger(GeniisysSpringPasswordEncoder.class);
		
		try {
			password = com.geniisys.framework.util.PasswordEncoder.doDecrypt(password);			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			log.info("Exception occured: " + e.getMessage());
		}
		
		return password.toUpperCase();
	}

	/* (non-Javadoc)
	 * @see org.springframework.security.authentication.encoding.PasswordEncoder#isPasswordValid(java.lang.String, java.lang.String, java.lang.Object)
	 */
	@Override
	public boolean isPasswordValid(String encodedPassword, String rawPassword, Object salt)
			throws DataAccessException {
		return true;
	}

}
