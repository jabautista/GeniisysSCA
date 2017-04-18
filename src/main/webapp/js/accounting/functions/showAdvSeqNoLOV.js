/**
 * Shows giac inst no list of values
 * @author d.alcantara
 * @date 03.12.2012
 * @module GICLS017
 */
function showAdvSeqNoLOV(tranType, lineCd, issCd, advYear, advSeqNo, vIssCd, notIn, notIn2) {
	LOV.show({
		controller: "AccountingLOVController",
		urlParameters: {action: "getAdvSeqNoLOV",
						tranType: 	tranType,
						lineCd: 	lineCd,
						issCd : 	issCd,
						advYear: 	advYear,
						vIssCd: 	vIssCd,
						notIn: 		notIn,
						notIn2:     notIn2,
						page: 1},
		title: "Advice No. List",
		width: 390,
		height: 390,
		columnModel : [
		               {
		            	   id: "adviceNo",
		            	   title: "Advice Number",
		            	   width: '340px',
		            	   align: 'left', // changed from center by shan 10.30.2013
		            	   titleAlign: 'left' // changed from center by shan 10.30.2013
		               }
		              ],
		draggable: true,
		onSelect: function(row) {
			$("selCurrency").value = row==null ? "" : row.currencyCode;
			$("dcpConvertRate").value = row==null ? "" : row.convertRate;
			$("dcpCurrencyDesc").value = row==null ? "" : row.currencyDescription;
			
			$("txtLineCd").value		= row.lineCode;
			$("txtIssCd").value			= row.issueCode;
			$("txtAdviceYear").value	= row.adviceYear;
			$("txtAdvSeqNo").value 	    = row.adviceSequenceNumber;
			//$("txtAdviceSequence").value = row.adviceNo;
			$("adviceIdAC017").value 	= row.adviceId;
			$("claimIdAC017").value 	= row.claimId;
			
			$("txtClaimNumber").value 	= row.claimNumber;
			$("txtPolicyNumber").value	= row.policyNumber;
			$("txtAssuredName").value 	= unescapeHTML2(row.assuredName);//added unescapeHTML2 reymon 04242013
			
			getListOfPayees();
		}
	});	
}