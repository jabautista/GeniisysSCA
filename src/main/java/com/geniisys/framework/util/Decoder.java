/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;


/**
 * The Class Decoder.
 */
public class Decoder {
	
	/**
	 * Decode.
	 * 
	 * @param password the password
	 * @return the string
	 */
	public static String decode(String password) {
		int z = 0;
		int a = 0;

		String alpha[] = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
				"K", "L", "M", "N", "�", "O", "P", "Q", "R", "S", "T", "U",
				"V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g",
				"h", "i", "j", "k", "l", "m", "n", "�", "o", "p", "q", "r",
				"s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4",
				"5", "6", "7", "8", "9", "0", ":", "@", "-", "." };

		// String password ="02313531912348976654583669687";
		String temp = password.substring(0, 1);
		int len = password.length() - 1;
		password = password.substring(1, password.length());
		String pword = password;
		int len1 = (len - 1) / 4 + 1;
		String temppword1 = "";
		String temppword2 = "";
		String password1 = "";
		if (temp.equals("0")) {
			String sample1[] = { "5452", "1431", "1935", "1373", "1693",
					"7645", "4625", "7935", "4689", "1023", "9341", "7958",
					"0326", "7458", "1380", "1984", "2125", "3544", "2549",
					"2345", "3687", "3869", "6875", "5876", "6879", "2435",
					"6899", "6545", "3543", "8364", "9687", "1234", "3666",
					"3565", "5319", "6872", "2313", "0213", "8366", "2315",
					"3574", "2186", "1589", "9863", "5649", "8976", "6583",
					"5187", "0513", "3897", "8675", "4666", "5189", "2054",
					"9873", "6542", "8943", "0531", "6546", "9846", "0515",
					"2136", "6575", "6932", "6933", "6934", "6935", "6936" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("1")) {
			String sample1[] = { "5431", "0520", "0252", "8793", "7652",
					"4536", "7589", "1452", "1463", "3568", "0123", "7849",
					"7485", "9644", "4458", "7146", "8436", "8972", "7940",
					"0463", "6548", "8954", "0256", "8520", "7541", "3549",
					"7846", "0146", "7832", "1286", "7468", "0213", "9872",
					"5423", "8923", "3587", "2312", "0454", "8634", "8762",
					"0542", "9873", "2752", "7896", "0543", "5460", "8962",
					"7610", "0564", "6523", "8241", "7531", "3563", "2054",
					"4562", "3593", "2564", "7856", "0161", "7951", "5605",
					"8756", "5432", "8654", "8655", "8656", "8657", "8658" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("2")) {
			String sample1[] = { "4568", "7459", "5464", "7946", "4865",
					"7895", "0454", "7893", "2514", "5415", "5494", "5821",
					"8605", "5109", "0561", "7346", "3591", "8954", "4025",
					"7861", "0576", "8269", "8419", "4036", "0502", "8989",
					"2134", "8675", "4535", "3876", "9969", "4561", "4751",
					"8762", "3583", "7862", "3830", "7456", "0453", "7894",
					"5624", "7547", "5867", "8654", "4161", "8924", "8796",
					"0156", "8797", "1265", "3256", "0564", "2876", "9764",
					"0580", "2782", "04547", "8769", "7254", "3541", "2583",
					"4678", "6786", "1871", "1872", "1873", "1874", "1875" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("3")) {
			String sample1[] = { "5852", "1324", "4365", "6543", "4356",
					"7856", "9832", "4503", "7619", "5687", "2345", "4677",
					"4567", "9086", "7805", "2435", "7858", "3345", "1257",
					"0985", "8907", "3465", "7689", "0234", "1334", "9678",
					"1345", "6872", "5640", "2341", "2468", "5686", "9836",
					"8790", "3456", "8642", "3497", "5679", "6542", "5678",
					"3548", "9867", "7900", "7897", "7890", "8659", "1357",
					"3257", "6798", "8900", "6788", "8988", "8770", "4444",
					"9816", "2457", "3457", "9800", "2348", "9842", "2346",
					"2347", "9805", "3248", "3249", "3250", "3251", "3252" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("4")) {
			String sample1[] = { "1232", "1566", "4679", "7689", "2945",
					"6768", "2345", "5985", "6534", "9637", "7410", "8231",
					"7531", "3589", "4488", "1285", "1685", "9638", "4287",
					"0637", "9642", "1196", "8995", "3644", "2238", "8311",
					"9655", "9663", "1148", "7765", "8534", "6254", "8247",
					"6584", "5489", "1877", "5298", "8565", "8957", "1557",
					"9742", "9332", "9667", "9334", "9635", "9363", "8642",
					"8332", "8654", "7856", "8544", "5535", "8324", "6544",
					"5284", "6247", "8334", "9354", "8354", "8769", "8965",
					"8521", "9896", "7766", "7767", "7768", "7769", "7770" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("5")) {
			String sample1[] = { "1458", "9645", "8523", "9647", "8741",
					"3256", "0550", "0147", "6056", "9631", "7421", "9634",
					"3997", "4568", "8635", "3584", "8524", "8954", "0158",
					"9076", "0546", "4944", "8975", "0567", "7895", "2578",
					"8797", "4657", "8756", "4892", "3210", "3148", "6345",
					"4476", "0355", "9637", "9337", "8574", "0248", "7426",
					"8684", "8927", "4566", "8783", "8794", "8620", "7892",
					"7411", "0258", "9630", "6048", "1159", "7530", "8534",
					"6985", "2589", "9875", "4789", "6541", "1236", "7358",
					"8961", "0159", "8350", "8351", "8352", "8353", "8354"

			};
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("6")) {
			String sample1[] = { "4102", "8965", "7889", "9635", "4101",
					"0258", "8960", "1020", "2010", "2030", "7389", "0554",
					"7385", "5123", "4251", "3526", "5253", "4142", "1424",
					"3020", "4605", "8962", "0128", "0175", "5895", "7895",
					"6592", "0325", "8921", "1452", "8932", "0586", "9610",
					"5830", "8205", "4254", "2567", "5892", "8369", "4356",
					"4002", "8254", "4754", "8792", "1005", "0021", "0058",
					"0089", "0091", "0075", "0158", "0557", "0558", "0059",
					"0895", "0358", "8951", "8954", "7589", "7500", "0057",
					"0858", "0159", "0085", "0086", "0087", "0088", "0090" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("7")) {
			String sample1[] = { "7412", "8501", "0471", "7625", "8966",
					"0457", "8314", "0538", "8621", "5899", "5201", "8965",
					"4520", "3896", "9654", "0582", "3965", "1358", "3785",
					"8961", "7410", "8962", "0128", "0175", "5895", "7894",
					"6592", "0325", "8921", "1452", "1524", "8520", "4105",
					"7895", "8952", "3401", "8352", "0258", "1258", "3258",
					"3111", "2111", "1111", "0111", "9258", "8258", "7258",
					"6258", "5258", "4258", "4111", "5111", "6111", "7111",
					"8111", "9111", "5241", "5272", "5273", "5274", "5275",
					"5276", "5278", "5279", "5280", "5281", "5382", "5383"

			};
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("8")) {
			String sample1[] = { "4021", "8694", "1012", "1013", "1014",
					"1015", "1011", "1016", "1017", "1018", "2028", "2027",
					"2026", "2025", "2024", "2023", "2022", "2021", "2020",
					"1019", "2029", "3500", "3501", "3502", "3503", "3504",
					"3505", "3506", "3507", "3508", "8527", "8526", "8535",
					"8525", "8524", "8523", "8522", "8521", "8520", "3509",
					"5694", "6310", "1111", "0111", "9258", "8258", "7258",
					"6258", "5258", "4258", "4594", "8335", "9058", "6052",
					"8210", "5054", "5241", "5272", "5273", "5274", "0145",
					"8005", "9003", "6005", "6006", "6007", "6008", "6009" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		} else if (temp.equals("9")) {
			String sample1[] = { "9630", "9631", "9632", "9633", "9634",
					"9635", "9636", "9637", "9638", "9639", "8526", "8525",
					"8524", "8523", "8515", "8504", "8513", "8522", "8521",
					"8520", "8527", "8528", "8529", "7410", "7411", "7412",
					"7413", "7414", "7415", "7416", "1236", "1235", "1234",
					"1233", "1232", "1231", "1230", "7419", "7418", "7417",
					"1237", "1238", "1239", "9870", "9871", "9872", "9873",
					"9874", "9875", "9876", "4566", "4565", "4564", "4563",
					"4562", "4561", "4560", "9879", "9878", "9877", "4567",
					"4568", "4569", "8430", "8431", "8432", "8433", "8434" };
			for (z = 0; z < len1; z++) {
				if (pword.length() != 4) {
					temppword1 = pword.substring(0, 4);
				} else {
					temppword1 = pword;
				}
				temppword2 = pword.substring(4, pword.length());
				for (a = 0; a < 68; a++) {

					if (temppword1.equals(sample1[a])) {
						password1 = password1 + alpha[a];
						pword = temppword2;
					}
				}
			}// end of password
		}
		password = password1;
		return password;
	}
}