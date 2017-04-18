package com.geniisys.framework.util;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang.StringUtils;

import com.geniisys.common.exceptions.PasswordException;

public class PasswordChecker {
	
	@Deprecated
	public static boolean validatePassword(String password) throws PasswordException{
		boolean hasLetter = false;
		boolean hasNumber = false;
		boolean hasSpecialChar = false;
		Character[] specialChars = {'~','!','#','$','%','^','&','*','(',')','_','+','{','}',':','|','\'','<','>','?','[',']',';','\\',',','.','/','`'};
		
		if(password != null && password.trim() != "") {
			if(password.length() < 8){
				throw new PasswordException("Password should be at least 8 characters long. It should also contain at least one digit/number, one character and one special character.");				
			} else {
				for(int i=0; i<password.length(); i++){
		            if (Character.isDigit(password.charAt(i)))
		                hasNumber = true;
		            else if (Character.isLetter(password.charAt(i)))
		            	hasLetter = true;
				}
				for(Character c: specialChars){
					if(password.contains(c.toString())) {
						hasSpecialChar = true;
						break;
					}
				}
				if(!hasNumber)
					throw new PasswordException("Password should contain at least one digit or number.");
				else if(!hasLetter)
					throw new PasswordException("Password should contain at least one character.");
				else if(!hasSpecialChar)
					throw new PasswordException("Password should contain at least one special character.");
			}
		}
		
		return true;
	}
	
	public static boolean validatePassword(Map<String, Object> params) throws PasswordException {
		
		String password = params.get("password").toString();
		int minPasswordLength = params.get("MIN_PASSWORD_LENGTH") != null ? Integer.parseInt(params.get("MIN_PASSWORD_LENGTH").toString()) : 0;
		int minLettersInPw = params.get("MIN_LETTERS_IN_PW") != null ? Integer.parseInt(params.get("MIN_LETTERS_IN_PW").toString()) : 0;
		int minNumberInPw = params.get("MIN_NUMBER_IN_PW") != null ? Integer.parseInt(params.get("MIN_NUMBER_IN_PW").toString()) : 0;
		int minSpecialCharsInPw = params.get("MIN_SPECIAL_CHARS_IN_PW") != null ? Integer.parseInt(params.get("MIN_SPECIAL_CHARS_IN_PW").toString()) : 0;
		
		if(minPasswordLength != 0 && password.length() < minPasswordLength)
			throw new PasswordException("Password should be at least " + minPasswordLength + " characters long.");
		
		if(minLettersInPw != 0 && countRegex(password.toUpperCase(), "[A-Z]") < minLettersInPw)
			throw new PasswordException("Password should contain at least " + minLettersInPw + " letter(s).");
		
		if(minNumberInPw != 0 && countRegex(password, "\\d") < minNumberInPw)
			throw new PasswordException("Password should contain at least " + minNumberInPw + " digit(s).");
		
		if(minSpecialCharsInPw != 0 && countRegex(password, "\\W") < minSpecialCharsInPw)
			throw new PasswordException("Password should contain at least " + minNumberInPw + " special character(s).");
		
		return true;
	}
	
	private static boolean useRegex(String password, String pattern) {
		Pattern p = Pattern.compile(pattern);
		Matcher m = p.matcher(password);
		
		return m.find();
	}
	
	private static int countRegex(String password, String pattern) {
		int count = 0;
		Pattern p = Pattern.compile(pattern);
		Matcher m = p.matcher(password);
		
		while (m.find())
			count++;
		
		return count;
	}
	
	@Deprecated
	public static int getPasswordStrengthScore(String password) {
		int score = 0;
		boolean hasSmallLetter = false;
		boolean hasBigLetter = false;
		boolean hasNumber = false;
		boolean hasSpecialChar = false;
		
		if (password.length() < 5)
			score += 3;
		else if (password.length() > 4 && password.length() < 8)
			score += 6;
		else if (password.length() > 7 && password.length() < 16)
			score += 12;		
		else if (password.length() > 15)
			score += 18;
		
		if(useRegex(password, "[a-z]")){
			score += 1;
			hasSmallLetter = true;
		}
		
		if(useRegex(password, "[A-Z]")) {
			score += 5;
			hasBigLetter = true;
		}
		
		if(useRegex(password, "\\d")) {
			score += 5;
			hasNumber = true;
		}
		
		if(useRegex(password, "(.*)?\\d(.*)?\\d(.*)?\\d(.*)?")) {
			score += 5;
		}
		
		if(useRegex(password, "\\W")) {
			score += 5;
			hasSpecialChar = true;
		}
		
		if(useRegex(password, "(.*)?\\W(.*)?\\W(.*)?")) {
			score += 5;
		}
		
		if(hasBigLetter && hasSmallLetter) {
			score += 2;
		}
		
		if((hasBigLetter || hasSmallLetter) && hasNumber) {
			score += 2;
		}
		
		if((hasBigLetter || hasSmallLetter) && hasNumber && hasSpecialChar) {
			score += 2;
		}
		
		int result = score * 2;
		
		return result;
	}
	
	public static String getPasswordStrength(String password) {
		int score = 0;
		int length = 0;
		int upper = 0;
		int lower = 0;
		int num = 0;
		int sym = 0;
		int mid = 0;
		int req = 0;
		
		length = (password.length() * 4);
		score += length;
		//System.out.println("Number of Characters: " + length);

		if(password.length() >= 8){
			req++;
		}
		
		if(useRegex(password, "[A-Z]")) {
			upper = password.length() - countRegex(password, "[A-Z]");
			score += upper*2;
			req++;
		}
		//System.out.println("Uppercase Letters: " + (upper*2));
		
		if(useRegex(password, "[a-z]")){
			lower = password.length() - countRegex(password, "[a-z]");
			score += lower*2;
			req++; 
		}
		//System.out.println("Lowercase Letters: " + (lower*2));
		
		num = countRegex(password, "\\d");
		if(num > 0 && num < password.length()) {
			score += num*4;
			req++;
		}
		//System.out.println("Numbers: " + (num*4));
		
		if(useRegex(password, "\\W")) {
			sym = countRegex(password, "\\W");
			score += sym*6;
			req++;
		}
		//System.out.println("Symbols: " + (sym*6));
		
		mid = countNumberInBetweenText(password);
		score += mid*2; 
		//System.out.println("Middle Numbers or Symbols: " + (mid*2));		
		
		if(password.length() >= 8 && req >= 4){
			score += req*2;
		}
		//System.out.println("Requirements: " + req*2);
	
		score = computeDeductions(password, score, num, sym);
		
		System.out.println("Real Score: " + score);
		if(score < 0){
			score = 0;
		} else if(score > 100){
			score = 100;
		}
		
		if(score <= 20){
			return score + "% - Very Weak";
		} else if (score <= 40){
			return score + "% - Weak";
		} else if (score <= 60) {
			return score + "% - Good";
		} else if (score <= 80) {
			return score + "% - Strong";
		} else {
			return score + "% - Very Strong";
		}
				
	}
	
	private static int computeDeductions(String password, int score, int num, int sym){
		int dedLettersOnly = 0;
		
		if(num == 0 && sym == 0){
			dedLettersOnly = password.length();
			score -= dedLettersOnly;
		}
		//System.out.println("Letters Only: -" + dedLettersOnly);
		
		int dedNumbersOnly = 0;
		if(num == password.length()){
			dedNumbersOnly = password.length();
			score -= dedNumbersOnly;
		}
		//System.out.println("Numbers Only: -" + dedNumbersOnly);
		
		int dedRepeatChar = 0;
		dedRepeatChar = countRepeatChars(password);
		score -= dedRepeatChar;
		//System.out.println("Repeat Characters: -" + (dedRepeatChar));
		
		int dedConsUpperChar = 0;
		dedConsUpperChar = countConsecutiveUppercaseChars(password);
		score -= dedConsUpperChar*2;
		//System.out.println("Consecutive Uppercase Letters: -" + (dedConsUpperChar*2));
		
		int dedConsLowerChar = 0;
		dedConsLowerChar = countConsecutiveLowercaseChars(password);		
		score -= dedConsLowerChar*2;
		//System.out.println("Consecutive Lowercase Letters: -" + (dedConsLowerChar*2));
		
		int dedConsNumber = 0;
		dedConsNumber = countConsecutiveNumbers(password);		
		score -= dedConsNumber*2;
		//System.out.println("Consecutive Numbers: -" + (dedConsNumber*2));
		
		int dedSeqChar = 0;
		dedSeqChar = countSequentialCharacters(password);		
		score -= dedSeqChar*3;
		//System.out.println("Sequential Letters: -" + (dedSeqChar*3));
		
		int dedSeqNumber = 0;
		dedSeqNumber = countSequentialNumbers(password);		
		score -= dedSeqNumber*3;
		//System.out.println("Sequential Numbers: -" + (dedSeqNumber*3));
		
		return score;
	}
	
	public static int countNumberInBetweenText(String password){
		int numberCount = countRegex(password, "\\d");
		int specialCharCount = countRegex(password, "\\W");
		
		String start = password.substring(0,1);
		String end = password.substring(password.length()-1, password.length());
		
		if(StringUtils.isNumeric(start)){
			numberCount -= 1;
		}
		
		if(StringUtils.isNumeric(end)){
			numberCount -= 1;
		}
		
		if(useRegex(start, "\\W")){
			specialCharCount -= 1;
		}
		
		if(useRegex(end, "\\W")){
			specialCharCount -= 1;
		}
		
		return numberCount + specialCharCount;
	}
	
	private static int countRepeatChars(String s) {
		int counter = 0;
		String temp = s.toLowerCase();
		
		for (int i = 0; i < s.length(); i++){
		    String ch = s.substring(i,i+1).toLowerCase();
		    int c = countRegex(temp, ch);
		    if(c > 1){
		    	counter += c;
		    	temp = temp.replaceAll(ch, "");
		    }
		}
		
		return counter;
	}
	
	public static int countConsecutiveUppercaseChars(String s) {
		int count = 0;
		int counter = 0;
		String str = s;
		char[] ch = str.toCharArray();
		
		for (int i = 0; i < ch.length-1; i++){
			if(Character.isAlphabetic(ch[i]) && Character.isAlphabetic(ch[i+1]) 
					&& Character.isUpperCase(ch[i]) && Character.isUpperCase(ch[i+1])){
				counter++;
			} else {
				if(counter > 0){
					count += counter;					
				}
				counter = 0;
			}
		}
		
		if(counter > 0){
			count += counter;
		}
		
		return count;
	}

	public static int countConsecutiveLowercaseChars(String s) {
		int count = 0;
		int counter = 0;
		String str = s;
		char[] ch = str.toCharArray();
		
		for (int i = 0; i < ch.length-1; i++){
			if(Character.isAlphabetic(ch[i]) && Character.isAlphabetic(ch[i+1]) 
					&& Character.isLowerCase(ch[i]) && Character.isLowerCase(ch[i+1])){
				counter++;
			} else {
				if(counter > 0){
					count += counter;					
				}
				counter = 0;
			}
		}
		
		if(counter > 0){
			count += counter;
		}
		
		return count;
	}
	
	public static int countConsecutiveNumbers(String s) {
		int count = 0;
		int counter = 0;
		String str = s;
		char[] ch = str.toCharArray();
		
		for (int i = 0; i < ch.length-1; i++){
			if(Character.isDigit(ch[i]) && Character.isDigit(ch[i+1])){
				counter++;
			} else {
				if(counter > 0){
					count += counter;					
				}
				counter = 0;
			}
		}
		
		if(counter > 0){
			count += counter;
		}
		
		return count;
	}
	
	public static int countSequentialCharacters(String s) {
		int counter = 0;
		String str = s.toLowerCase();
		char[] ch = str.toCharArray();
		
		for (int i = 0; i < ch.length-2; i++){
			if(Character.isAlphabetic(ch[i]) 
					&& Character.isAlphabetic(ch[i+1])
					&& Character.isAlphabetic(ch[i+2])
					&& Character.getNumericValue(ch[i])+1 == Character.getNumericValue(ch[i+1]) 
					&& Character.getNumericValue(ch[i])+2 == Character.getNumericValue(ch[i+2])){
				counter++;
			}
		}
		
		return counter;
	}
	
	public static int countSequentialNumbers(String s) {
		int counter = 0;
		String str = s.toLowerCase();
		char[] ch = str.toCharArray();
		
		for (int i = 0; i < ch.length-2; i++){
			if(Character.isDigit(ch[i]) 
					&& Character.isDigit(ch[i+1])
					&& Character.isDigit(ch[i+2])
					&& Character.getNumericValue(ch[i])+1 == Character.getNumericValue(ch[i+1]) 
					&& Character.getNumericValue(ch[i])+2 == Character.getNumericValue(ch[i+2])){
				counter++;
			}
		}
		
		return counter;
	}
}