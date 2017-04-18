/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.security;

import org.springframework.dao.DataAccessException;
import org.springframework.security.authentication.dao.SaltSource;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;


/**
 * The Class GeniisysUserDetailsService.
 */
public class GeniisysUserDetailsService implements UserDetailsService {
	
	/** The user details service. */
	private UserDetailsService userDetailsService;
	
	/** The password encoder. */
	private PasswordEncoder passwordEncoder;
	
	/** The salt source. */
	private SaltSource saltSource;
	
	/**
	 * Sets the password encoder.
	 * 
	 * @param passwordEncoder the new password encoder
	 */
	public final void setPasswordEncoder(PasswordEncoder passwordEncoder) {
        this.passwordEncoder = passwordEncoder;
    }

    /**
     * Sets the user details service.
     * 
     * @param userDetailsService the new user details service
     */
    public final void setUserDetailsService(UserDetailsService userDetailsService) {
        this.userDetailsService = userDetailsService;
    }

    /**
     * Sets the salt source.
     * 
     * @param saltSource the new salt source
     */
    public final void setSaltSource(SaltSource saltSource) {
        this.saltSource = saltSource;
    }

	/* (non-Javadoc)
	 * @see org.springframework.security.core.userdetails.UserDetailsService#loadUserByUsername(java.lang.String)
	 */
	@Override
	public UserDetails loadUserByUsername(String username)
			throws UsernameNotFoundException, DataAccessException {
		//load user using JdbcDaoImpl userDetailsService
		//Logger log = Logger.getLogger(GeniisysUserDetailsService.class);
		
		UserDetails user = userDetailsService.loadUserByUsername(username);
		
		User encodedUser = new User(user.getUsername(), encodePassword(user), user.isEnabled(),
                user.isAccountNonExpired(),
                user.isCredentialsNonExpired(), user.isAccountNonLocked(),
                user.getAuthorities());
		
		return encodedUser;
	}

	/**
	 * Encode password.
	 * 
	 * @param userDetails the user details
	 * @return the string
	 */
	private String encodePassword(UserDetails userDetails) {
        Object salt = null;

        if (this.saltSource != null) {
            salt = this.saltSource.getSalt(userDetails);
        }
        return passwordEncoder.encodePassword(userDetails.getPassword(), salt);
    }
}
