<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="margin: 10px; width: 50%;" id="renewalTable" name="renewalTable">
	<div class="tableHeader">
		<label style="text-align: left; margin-left: 5px;">Policy No.</label>
	</div>
	<div id="renRepForDeleteDiv" name="renRepForDeleteDiv" style="visibility: hidden;"></div>
	<div id="renRepForInsertDiv" name="renRepForInsertDiv" style="visibility: hidden;"></div>	
	<div class="tableContainer" id="policyNoListing" name="policyNoListing" style="display: block;">		
			<c:forEach var="wpolnrep" items="${wpolnreps}">
				<!-- trap null or blank row RSIC-SR-15094 JC -->
				<c:if test="${not empty wpolnrep.lineCd && not empty wpolnrep.sublineCd && not empty wpolnrep.issCd && not empty wpolnrep.issueYy && not empty wpolnrep.polSeqNo && not empty wpolnrep.renewNo}">
					<div id="rowPolnrep${wpolnrep.oldPolicyId}" class="tableRow"  name="rowPolnrep">
						<input type="hidden" 	id="origOldPolicyId" 	name="origOldPolicyId" 	value="${wpolnrep.oldPolicyId}" />
						<input type="hidden" 	id="oldPolicyId" 		name="oldPolicyId" 		value="${wpolnrep.oldPolicyId}" />
						<input type="hidden" 	id="lineCd" 			name="lineCd" 			value="${wpolnrep.lineCd}" />
						<input type="hidden" 	id="sublineCd" 			name="sublineCd"		value="${wpolnrep.sublineCd}" />
						<input type="hidden" 	id="issCd"  			name="issCd" 			value="${wpolnrep.issCd}" />
						<input type="hidden" 	id="issYy"				name="issYy"			value="${wpolnrep.issueYy}" />
						<input type="hidden" 	id="polSeqNo"			name="polSeqNo"			value="${wpolnrep.polSeqNo}" />
						<input type="hidden" 	id="renewNo" 			name="renewNo" 			value="${wpolnrep.renewNo}" />
						<input type="hidden"    id="renewExpiry"		name="renewExpiry"      value="<fmt:formatDate value="${wpolnrep.expiryDate}" pattern="MM/dd/yyyy" />" /> <!-- added a format to remove time stamp value adpascual 06.19.2012 -->
						
				   		<label style="text-align: center; text-transform: uppercase; margin-left: 5px;" id="policyNo" name="policyNo">
				   			${wpolnrep.lineCd} 
				   			- ${wpolnrep.sublineCd} 
				   			- ${wpolnrep.issCd}
				   			- <fmt:formatNumber pattern="00">
				   				${wpolnrep.issueYy} 
				   			  </fmt:formatNumber>
				   			- <fmt:formatNumber pattern="0000000">
				   				${wpolnrep.polSeqNo}
							  </fmt:formatNumber>  
				   			- <fmt:formatNumber pattern="00">
				   				${wpolnrep.renewNo}
				   			  </fmt:formatNumber>
				   		</label>
				   	</div>
			   	</c:if>
			</c:forEach>		
	</div>	
</div>
<table width="50%" style="margin-top: 10px;">
	<tr>
		<td class="rightAligned" width="15%">Policy No.</td>
		<td width="12%">
			<input type="hidden" id="wpolnrepOldPolicyId" name="wpolnrepOldPolicyId" value="" />
			<input type="hidden" id="incrRepl" name="incrRepl" value="${incrRepl}"/>
			<input type="text" style="width: 84%;"   id="wpolnrepLineCd"   	name="wpolnrepLineCd"    readonly="readonly" value="${lineCd}" class=""/>
		</td>
		<td width="17%"><input type="text" style="width: 88%;" 	id="wpolnrepSublineCd" 	name="wpolnrepSublineCd" readonly="readonly" value="${sublineCd}" class=""/></td>
		<td width="12%"><input type="text" style="width: 84%; text-transform: uppercase;" 	id="wpolnrepIssCd"		name="wpolnrepIssCd" maxlength="2" class="required"/></td>
		<td width="12%"><input type="text" style="width: 84%; text-align: right;"		id="wpolnrepIssueYy"	name="wpolnrepIssueYy" maxlength="2" class="required integerNoNegative" /></td>
		<td width="20%"><input type="text" style="width: 88%; text-align: right;"		id="wpolnrepPolSeqNo"	name="wpolnrepPolSeqNo" maxlength="7" class="required integerNoNegativeUnformatted" /></td>
		<td width="12%"><input type="text" style="width: 84%; text-align: right;"		id="wpolnrepRenewNo"	name="wpolnrepRenewNo" maxlength="2" class="required integerNoNegative" /></td>			
	</tr>
	<tr>
		<td></td>
		<td colspan="7">
			<label style="margin-right: 5px;"><input type="checkbox" id="samePolicyNo" name="samePolicyNo" value="" class="rightAligned" title="Same Policy No."/></label>
			<label class="rightAligned">Same Policy No.</label>
		</td>
	</tr>
</table>
<div style="width: 100%; margin: 10px 0px 10px 0px;" align="center" >
	<input id="btnAddRenewal" class="button" type="button" value="Add" style="width: 60px;" />
	<input id="btnDeleteRenewal" class="button" type="button" value="Delete" style="width: 60px;" />
</div>

<script type="text/javascript" defer="defer">

	var oldPolicyId 	= 0;
	var origOldPolicyId = null;
	var lineCd 			= null;
	var sublineCd 		= null;
	var issCd 			= null;
	var issueYy 		= null;
	var polSeqNo 		= null;
	var renewNo 		= null;	
	var policyNo		= null;
	var renewExpiry		= null;
	var renewPolCnt		= 0;
	var prevPolicyId 	= 0;

	//clearPolicyRenewalForm();
	setPolnrepForm(null);
	checkIfToResizeTable("policyNoListing", "rowPolnrep");
	checkTableIfEmpty("rowPolnrep", "renewalTable");
	addStyleToInputs();
	initializeAll();
	initializeChangeTagBehavior(changeTagFunc); 
	initializeTable("tableContainer", "rowPolnrep", "", "");	
/*	
	function getRowCount() {
		try {
			var rowCount = $$("div[name='rowPolnrep']").size();			
			return rowCount;
		} catch (e) {
			showErrorMessage("getRowCount", e);
			//showMessageBox("getRowCount : " + e.message);
		}
	}
*/
	if ($("samePolnoSw") != null){	
		var rowCount = $$("div[name='rowPolnrep']").size();
		if($F("samePolnoSw") == "Y" && rowCount > 0){
			$("samePolicyNo").checked = true;
		} else {
			$("samePolicyNo").checked = false;
		}
	}

	// added by Nica 09.07.2011 - to observe tagging of samePolicyNo checkbox
	$("samePolicyNo").observe("change", function(){
		if(renewPolCnt > 1) {
			showMessageBox("This option is not available for multiple lines.");
			$("samePolicyNo").checked = false;
			$("samePolnoSw").value = "N";
		} else {
			if ($("samePolnoSw") != null){	
				var rowCount = $$("div[name='rowPolnrep']").size();
				if($("samePolicyNo").checked && rowCount > 0){
					$("samePolnoSw").value = "Y";
				} else {
					$("samePolnoSw").value = "N";
				}
			}
		}
		
	});

	$("btnAddRenewal").observe("click", function() {
		checkPolnrep();
	});

	$("btnDeleteRenewal").observe("click", function() {
		deletePolicyRenewal();
	});

	$("wpolnrepIssueYy").observe("focus", function(){
		$("wpolnrepIssueYy").select();
	});
	
	$("wpolnrepPolSeqNo").observe("focus", function(){
		$("wpolnrepPolSeqNo").select();
	});

	$("wpolnrepRenewNo").observe("focus", function(){
		$("wpolnrepRenewNo").select();
	});

	$("wpolnrepIssueYy").observe("blur", function(){
		if($F("wpolnrepIssueYy") != "") {
			$("wpolnrepIssueYy").value = formatNumberDigits($F("wpolnrepIssueYy"), 2);
		}
	});

	$("wpolnrepPolSeqNo").observe("blur", function(){
		if($F("wpolnrepPolSeqNo") != "") {
			if (isNaN(parseInt($("wpolnrepPolSeqNo").value)) || 0 > parseInt($("wpolnrepPolSeqNo").value)
					|| String($("wpolnrepPolSeqNo").value).indexOf(".") > 0 || String($("wpolnrepPolSeqNo").value).indexOf("-") > 0) {
				$("wpolnrepPolSeqNo").value = "0000000";
			} else {
				$("wpolnrepPolSeqNo").value = formatNumberDigits($F("wpolnrepPolSeqNo"), 7);
			}
		}
	});

	$("wpolnrepRenewNo").observe("blur", function(){
		if($F("wpolnrepRenewNo") != "") {
			// added if condition - dencal25 2010-09-22
			if (isNaN(parseInt($("wpolnrepRenewNo").value)) || 0 > parseInt($("wpolnrepRenewNo").value)) {
				$("wpolnrepRenewNo").value = "000000";
			} else {
				$("wpolnrepRenewNo").value = formatNumberDigits($F("wpolnrepRenewNo"), 2);
			}
		}
	});
	
	$("wpolnrepIssCd").observe("focus", function(){
		$("wpolnrepIssCd").select();
	});
	
	$("wpolnrepIssCd").focus();

	$("samePolicyNo").observe("change", function() {
		validateSamePolicyNo();
	});

	$$("div[name='rowPolnrep']").each(
		function (row)	{			
			row.observe("click", function ()	{
				//renewPolCnt++; //marco - 07.12.2013 - comment out
				if (row.hasClassName("selectedRow"))	{
					//getDefaults(row);
					setPolnrepForm(row);
				} else {
					//clearPolicyRenewalForm();
					setPolnrepForm(null);
				}
			}); 
		}
	);

	function validateSamePolicyNo(){
		try {
			renewalIsChanged = true;
			var rowCount = $$("div[name='rowPolnrep']").size();
			if($("samePolicyNo").checked == true && 1 < rowCount){
				showMessageBox("The option 'Same Policy No.' is not applicable for multiple policies.", imgMessage.ERROR);
				$("samePolicyNo").checked = false;
			} else if($F("globalIssCd").toUpperCase() != $F("wpolnrepIssCd").toUpperCase() 
				   && $F("wpolnrepIssCd") != ""){
						showMessageBox("Issuing source code must be the same with the policy to be renewed if the 'Same Policy No.' option will be used.", imgMessage.ERROR);
						$("samePolicyNo").checked = false;			
			}
		} catch(e){
			showErrorMessage("validateSamePolicyNo", e);
			//showMessageBox("validateSamePolicyNo : " + e.message);
		}
	}

	function formatNumberWithSuffix(number){
		try {
			number = number + "";
			var suffix;
			var lastDigit = number.substring(number.length - 1, number.length);
		       	
	       	if (lastDigit == "1"){
	       	  	suffix = "st";
	       	} else if (lastDigit == "2"){
				suffix = "nd";
	       	} else if (lastDigit == "3"){
	       	  	suffix = "rd";
	       	} else { 
	       		suffix = "th";
			}
			return number + suffix;
		} catch (e){
			showErrorMessage("formatNumberWithSuffix", e);
			//showMessageBox("getNumberSuffix : " + e.message);
		}
	}
	
	function renewPolicy(count){
		try {			
	       	count = parseInt(count)+1;	       	
	       	showConfirmBox("Confirmation", "This will be the " + formatNumberWithSuffix(count)
                    + " renewal for policy " + policyNo + ".  Are you really sure you want to continue?", "Yes", "No", addPolicyRenewal, clearFields);    // changed "" --> clearFields  - dencal25 2010-09-22
            renewPolCnt++;
            if(renewPolCnt > 1) {
       			$("samePolicyNo").checked = false;
       			$("samePolnoSw").value = "N";
       		}        
		} catch(e){
			showErrorMessage("renewPolicy", e);
			//showMessageBox("renewPolicy : " + e.message);
		}
	}

	function setPolnrepVariables(){
		try{
			origOldPolicyId = $("wpolnrepOldPolicyId").value;
			lineCd 			= $F("wpolnrepLineCd");
			sublineCd 		= $F("wpolnrepSublineCd");
			issCd 			= $F("wpolnrepIssCd");
			issueYy 		= $F("wpolnrepIssueYy");
			polSeqNo 		= $F("wpolnrepPolSeqNo");
			renewNo 		= $F("wpolnrepRenewNo");
			policyNo		= lineCd + "-" + sublineCd + "-" + issCd.toUpperCase() + "-" + issueYy + "-" + polSeqNo + "-" + renewNo;
		} catch(e){
			showErrorMessage("setPolnrepVariables", e);
			//showMessageBox("setPolnrepVariables : " + e.message);
		}
	}
	
	function checkPolnrep() {	
		try {
			setPolnrepVariables();
			//var issCd 		= $F("wpolnrepIssCd");
			//var issueYy 	= $F("wpolnrepIssueYy");
			//var polSeqNo 	= $F("wpolnrepPolSeqNo");
			//var renewNo 	= $F("wpolnrepRenewNo");

			var rowCount = $$("div[name='rowPolnrep']").size();
			var exists = false;
			
			$$("div[name='rowPolnrep']").each(function(row)	{			
				//var id = "rowPolnrep" + oldPolicyId;
				if (!row.hasClassName("selectedRow")) {
					var tempPolicyNo = row.down("input", 2).value 
									   + "-" + row.down("input", 3).value 
									   + "-" + row.down("input", 4).value.toUpperCase() 
									   + "-" + formatNumberDigits(row.down("input", 5).value, 2) 
								   	   + "-" + formatNumberDigits(row.down("input", 6).value, 6) 
									   + "-" + formatNumberDigits(row.down("input", 7).value, 2);		 				
					if (tempPolicyNo.replace(/ /g, "") == policyNo.replace(/ /g, "")) {
						exists = true;						
					}
				}
			});

			if (issCd == "" || 
				issueYy == "" || 
				polSeqNo == "" ||
				renewNo == "") {	
				//showMessageBox("Please complete policy no.", imgMessage.ERROR);
				showMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR);
				return false;
			} else if($F("globalIssCd").toUpperCase() != $F("wpolnrepIssCd").toUpperCase() 
					   && $("samePolicyNo").checked && $F("wpolnrepIssCd") != "") {
				//validation for different Issue Code while Same Policy No. checkbox is checked - dencal25 2010-09-22
				showMessageBox("Issuing source code must be the same with the policy to be renewed if the 'Same Policy No.' option will be used.", imgMessage.ERROR);
				$("samePolicyNo").checked = false;
				setPolnrepForm(null);
				return false;
			} else if ($("samePolicyNo").checked && rowCount > 1){
				showMessageBox("The option 'Same Policy No.' is not applicable for multiple policies.", imgMessage.ERROR);  //  previously.. "You cannot add another policy no. if the option 'Same Policy No.' is checked." - dencal25 2010-09-22
				setPolnrepForm(null);
				return false;
			} else if (exists && $F("btnAddRenewal") == "Add"){
				showMessageBox("Policy entered must be unique.", imgMessage.ERROR);
				setPolnrepForm(null);
				return false;
			} else if (exists && $F("btnAddRenewal") == "Update"){
				showMessageBox("Policy must be unique.", imgMessage.ERROR);
				setPolnrepForm(null);
				return false;
			} else if (isNaN(parseInt(issueYy)) || 0 == String(issueYy).indexOf(".") || 0 > parseInt(issueYy)) {
				// previously... "parseFloat", added 2 conditions - dencal25 2010-09-22
				showMessageBox("Invalid Issuing Year <br />Value should be from 1 to 99.", imgMessage.ERROR);
				$("wpolnrepIssueYy").value = "";
				$("wpolnrepIssueYy").focus();
				return false;
			} else if (isNaN(parseInt(polSeqNo)) || 0 < String(polSeqNo).indexOf(".") || 0 > parseInt(polSeqNo)) {
				// previously... "parseFloat", added 2 conditions - dencal25 2010-09-22
				showMessageBox("Invalid Policy Sequence Number <br />Value must be integer.", imgMessage.ERROR);
				$("wpolnrepPolSeqNo").value = "";
				$("wpolnrepPolSeqNo").focus();
				return false;
			} else if (isNaN(parseInt(renewNo)) || 0 == String(renewNo).indexOf(".") || 0 > parseInt(renewNo)) {
				// previously... "parseFloat", added 2 conditions - dencal25 2010-09-22
				showMessageBox("Invalid Renewal Number <br />Value must be integer.", imgMessage.ERROR);
				$("wpolnrepRenewNo").value = "";
				$("wpolnrepRenewNo").focus();
				return false;
			}

			if('${isPack}' == "Y"){ // condition added by: nica for Package PAR renewal/replacement details
				checkPackPolicy();
			}else{
				new Ajax.Request(contextPath+"/GIPIWPolnrepController", {
					method: "GET",
					parameters: {action: 			"checkPolnrep",
								 globalParId:		$F("globalParId"),
								 globalLineCd:		$F("wpolnrepLineCd"),
								 globalSublineCd:	$F("wpolnrepSublineCd"),
								 wpolnrepIssCd: 	$F("wpolnrepIssCd"),
								 wpolnrepIssueYy: 	$F("wpolnrepIssueYy"),
								 wpolnrepPolSeqNo:	$F("wpolnrepPolSeqNo"),
								 wpolnrepRenewNo:	$F("wpolnrepRenewNo"),
								 polFlag:			$F("policyStatus")
								 },
					onCreate: function (){
						setCursor("wait");
					},
					onComplete: function (response) {
						setCursor("default");
						if (checkErrorOnResponse(response)){
							//var messageArr = response.responseText.split("@@");
							var res = JSON.parse(response.responseText);
							var messageArr = res.message.split("@@");
							
							if (messageArr[0] == "2") {
								oldPolicyId = messageArr[1];
								renewExpiry = res.renewExpiry;
								addPolicyRenewal();
							} else if (messageArr[0] == "1") {
								oldPolicyId = messageArr[1];
								var confirmMessage = "There is/are existing " + messageArr[2] + " renewed policy for " 
														+ policyNo + ".  Are you sure you want to continue?";
						
								showConfirmBox("Confirmation", confirmMessage, "Yes", "No", function(){
												renewPolicy(messageArr[2]);
												}, clearFields);  // changed ""
							} else if(messageArr[0] == "0") {
								showMessageBox(messageArr[1], imgMessage.ERROR);
								setPolnrepForm(null);
								return false;
							} else if(messageArr[0] == "3") { //Added by Jerome Bautista 08.07.2015 SR 19653
								showMessageBox(messageArr[1], imgMessage.ERROR);
								setPolnrepForm(null);
								return false;  
							} else if(messageArr[0] == "4") { //show confirmation message if user will proceed in processing manual renewal for policy with existing claim by MAC 03/21/2013.
								showConfirmBox("Confirmation", messageArr[1], "Yes", "No", function(){
									oldPolicyId = res.oldPolicyId;	//shan 07.04.2013, SR-13491: to pass the correct value for oldPolicyId
									addPolicyRenewal();
									}, clearFields);
							}else{ //to show response msg upon adding of renewal policy - RSIC-SR-15162 JC
								showMessageBox(res.message, imgMessage.ERROR);
								setPolnrepForm(null);
								return false;
							}
														
							// Show message for policy not existing - dencal25 2010-09-22
							//if (response.responseText == "Policy entered does not exist, please do the necessary action.") { robert 12.06.2012
								//showMessageBox(response.responseText, imgMessage.ERROR);
							if (res.message == "Policy entered does not exist, please do the necessary action.") {
								showMessageBox(res.message, imgMessage.ERROR);
								setPolnrepForm(null);
								return false;
							}		
						}
					}
				});
			}
		} catch (e){
			showErrorMessage("checkPolnrep", e);
			//showMessageBox("checkPolnrep : " + e.message);
		}
	}

	
	// Clear the text boxes - dencal25 2010-09-22
	function clearFields() {
		$("wpolnrepIssCd").value 	= "";
		$("wpolnrepIssueYy").value 	= "";
		$("wpolnrepPolSeqNo").value = "";
		$("wpolnrepRenewNo").value 	= "";
	}
	
	function addPolicyRenewal() {
		try	{
			//if (!exists)	{
				renewalIsChanged = true;
				var insContent = '<input type="hidden" 	id="insOldPolicyId" 	name="insOldPolicyId" 	value="' + oldPolicyId + '" />';
				//added a format to renewExpiry to remove time stamp value adpascual 06.20.2012
				var content = '<input type="hidden" 	id="origOldPolicyId" 	name="origOldPolicyId" 	value="' + origOldPolicyId + '" />' + 
							'<input type="hidden" 	id="oldPolicyId" 	name="oldPolicyId" 	value="' + oldPolicyId + '" />' + 
							'<input type="hidden" 	id="lineCd" 		name="lineCd" 		value="' + lineCd + '" />'+
							'<input type="hidden" 	id="sublineCd" 		name="sublineCd"	value="' + sublineCd + '" />'+
							'<input type="hidden" 	id="issCd"  		name="issCd" 		value="' + issCd + '" />'+
							'<input type="hidden" 	id="issYy"			name="issYy"		value="' + issueYy + '">'+
							'<input type="hidden" 	id="polSeqNo"		name="polSeqNo"		value="' + polSeqNo + '">'+
							'<input type="hidden" 	id="renewNo" 		name="renewNo" 		value="' + renewNo + '" />'+
							'<input type="hidden" 	id="renewExpiry"	name="renewExpiry" 		value="' + new Date(renewExpiry).format("mm/dd/yyyy") + '" />'+
							'<label style="margin-left: 5px; text-align: center; text-transform: uppercase;" id="policyNo" name="policyNo">'+
					   			lineCd + ' - ' + sublineCd + ' - ' + issCd + ' - ' + formatNumberDigits(issueYy, 2) + ' - ' + formatNumberDigits(polSeqNo, 7) + ' - ' + formatNumberDigits(renewNo, 2) +
					   		'</label>';
				
				if ($F("btnAddRenewal") == "Update") {
					//$("rowPolnrep" + origOldPolicyId).update(content);
					var row = getSelectedRow("rowPolnrep");
					row.update(content);
					row.removeClassName("selectedRow");
					setPolnrepForm(null);
				} else {
					if ($$("div[name='rowPolnrep']").size() > 0) { //untagged Same Policy No. checkbox if record has multiply policies by MAC 03/14/2013.
						$("samePolicyNo").checked = false;
						$("samePolnoSw").value = "N";
					}
					var newRow = new Element('div');
					newRow.setAttribute("name", "rowPolnrep");
					newRow.setAttribute("id", "rowPolnrep" + oldPolicyId);
					newRow.addClassName("tableRow");
					newRow.setStyle("display: none;");
					newRow.update(content);
					
					$('policyNoListing').insert({bottom: newRow});

					var renRepForInsertDiv = $("renRepForInsertDiv");
					renRepForInsertDiv.insert({bottom : insContent});
					
					newRow.observe("mouseover", function ()	{
						newRow.addClassName("lightblue");
					});
					
					newRow.observe("mouseout", function ()	{
						newRow.removeClassName("lightblue");
					});

					newRow.observe("click", function ()	{
						newRow.toggleClassName("selectedRow");
						if (newRow.hasClassName("selectedRow"))	{
							$$("div[name='rowPolnrep']").each(function (li)	{  // previously.. name='ded' - dencal25 2010-09-20
									if (newRow.getAttribute("id") != li.getAttribute("id"))	{
									li.removeClassName("selectedRow");
								}
							});

							//getDefaults(newRow);
							setPolnrepForm(newRow);
						} else {	
							//clearPolicyRenewalForm();
							setPolnrepForm(null);
						}
					});
		
					Effect.Appear(newRow, {
						duration: .5, 
						afterFinish: function ()	{
							checkIfToResizeTable("policyNoListing", "rowPolnrep");
							checkTableIfEmpty("rowPolnrep", "renewalTable");
						}
					});
					//clearPolicyRenewalForm();
					setPolnrepForm(null);
					updateBasicInfoFields();
				}
			//}
		} catch (e)	{
			showErrorMessage("addPolicyRenewal", e);
			//showMessageBox("addPolicyRenewal: " + e.message);
		}
	}
	
	function deletePolicyRenewal(){
		try {
			$$("div[name='rowPolnrep']").each(function (row) {
				if (row.hasClassName("selectedRow")){
					var oldPolId = row.down("input", 1).value;
					var renRepForDeleteDiv = $("renRepForDeleteDiv");				
					var delContent  = '<input type="hidden" 	id="delOldPolicyId" 	name="delOldPolicyId" 	value="' + oldPolId + '" />';
							
					renRepForDeleteDiv.insert({bottom : delContent});

					$$("input[name='insPerilCd']").each(function(input){
						var id = input.getAttribute("id");
						if(id == "insPerilCd"+perilCd){
							input.remove();
						}
					});
					
					Effect.Fade(row, {
						duration: .5,
						afterFinish: function ()	{
							renewalIsChanged = true;
							row.remove();
							//clearPolicyRenewalForm();
							setPolnrepForm(null);
							checkTableIfEmpty("rowPolnrep", "renewalTable");
							checkIfToResizeTable("policyNoListing", "rowPolnrep");
							renewPolCnt--;
							updateBasicInfoFields();
						} 
					});
				}
			});
		} catch (e){
			showErrorMessage("deletePolicyRenewal", e);
			//showMessageBox("deletePolicyRenewal : " + e.message);
		}
	}
/*	
	function clearPolicyRenewalForm(){
		try {
			$("wpolnrepIssCd").value 	= "";
			$("wpolnrepIssueYy").value 	= "";
			$("wpolnrepPolSeqNo").value = "";
			$("wpolnrepRenewNo").value 	= "";
	
			$("btnAddRenewal").value 	= "Add";
			//$("samePolicyNo").checked 	= false;
			disableButton("btnDeleteRenewal");
		} catch (e){
			showErrorMessage("clearPolicyRenewalForm", e);
			//showMessageBox("clearPolicyRenewalForm : " + e.message);
		}
	}
	
	function getDefaults(row){
		try {
			$("wpolnrepOldPolicyId").value 	= row.down("input", 0).value;
			$("wpolnrepIssCd").value 		= row.down("input", 4).value;
			$("wpolnrepIssueYy").value 		= formatNumberDigits(row.down("input", 5).value, 2);
			$("wpolnrepPolSeqNo").value		= formatNumberDigits(row.down("input", 6).value, 7);
			$("wpolnrepRenewNo").value 		= formatNumberDigits(row.down("input", 7).value, 2);
			$("btnAddRenewal").value = "Update";
			enableButton("btnDeleteRenewal");
		} catch (e){
			showErrorMessage("getDefaults", e);
			//showMessageBox("getDefaults : " + e.message);
		}		
	}
*/
	function setPolnrepForm(row){
		try {
			var rowCount = $$("div[name='rowPolnrep']").size();
			renewExpiry = row == null ? null : row.down("input", 8).value;
			
			(row != null ? $("wpolnrepOldPolicyId").value = row.down("input", 0).value : "");
			(row != null ? oldPolicyId = row.down("input", 0).value : "");
			(row != null ? prevPolicyId = row.down("input", 0).value : "");
			$("wpolnrepIssCd").value 		= (row != null ? row.down("input", 4).value : "");
			$("wpolnrepIssueYy").value 		= (row != null ? formatNumberDigits(row.down("input", 5).value, 2) : "");
			$("wpolnrepPolSeqNo").value		= (row != null ? formatNumberDigits(row.down("input", 6).value, 7) : "");
			$("wpolnrepRenewNo").value 		= (row != null ? formatNumberDigits(row.down("input", 7).value, 2) : "");
			//$("btnAddRenewal").value 		= (row != null ? "Update" : "Add");
			(row != null ? disableButton("btnAddRenewal") : enableButton("btnAddRenewal"));
			(row != null ? enableButton("btnDeleteRenewal") : disableButton("btnDeleteRenewal"));
			($F("policyStatus") == 3 && $F("incrRepl") == 'N' ? $("samePolicyNo").disable() : $("samePolicyNo").enable());
			(rowCount == 0 ? $("samePolicyNo").checked = false : ""); 
		} catch (e){
			showErrorMessage("setPolnrepForm", e);
			//showMessageBox("setPolnrepForm : " + e.message);
		}
	}
	
	function updateBasicInfoFields(){
		try {
			var rowCount = $$("div[name='rowPolnrep']").size();
			if (rowCount > 0){
				
				objUW.hidObjGIPIS002.gipiWPolnrepExist = "1";
			} else {
				objUW.hidObjGIPIS002.gipiWPolnrepExist = "0";
				$("samePolicyNo").checked = false;
			}
			
			if ($("samePolnoSw") != null){
				if($("samePolicyNo").checked == true) {
					$("samePolnoSw").value = "Y";
				} else {
					$("samePolnoSw").value = "N";
				}
			}
		} catch (e){
			showErrorMessage("updateBasicInfoFields", e);
			//showMessageBox("updateBasicInfoFields : " + e.message);
		}
	}

	// added by: nica 03.09.2011 - for Package PAR renewal/replacement details
	function checkPackPolicy(){
		new Ajax.Request(contextPath+"/GIPIPackWPolnrepController", {
			method: "POST",
			parameters: {action: 			"checkPackPolnrep",
						 packParId:			objUWGlobal.packParId,
						 lineCd:			$F("wpolnrepLineCd"),
						 sublineCd:			$F("wpolnrepSublineCd"),
						 wpolnrepIssCd: 	$F("wpolnrepIssCd"),
						 wpolnrepIssueYy: 	$F("wpolnrepIssueYy"),
						 wpolnrepPolSeqNo:	$F("wpolnrepPolSeqNo"),
						 wpolnrepRenewNo:	$F("wpolnrepRenewNo"),
						 polFlag:			$F("policyStatus")
						 },
			onCreate: function (){
				setCursor("wait");
			},
			onComplete: function (response) {
				setCursor("default");
				if (checkErrorOnResponse(response)){
					//var messageArr = response.responseText.split("@@");
					var res = JSON.parse(response.responseText);
					var messageArr = res.message.split("@@");
					if (messageArr[0] == "2") {
						oldPolicyId = messageArr[1];
						renewExpiry = res.renewExpiry;
						addPolicyRenewal();
					} else if (messageArr[0] == "1") {
						oldPolicyId = messageArr[1];
						var confirmMessage = "There is/are existing " + messageArr[2] + " renewed policy for " 
												+ policyNo + ".  Are you sure you want to continue?";
				
						showConfirmBox("Confirmation", confirmMessage, "Yes", "No", function(){
										renewPolicy(messageArr[2]);
										}, clearFields);
					} else if(messageArr[0] == "0") {
						showMessageBox(messageArr[1], imgMessage.ERROR);
						setPolnrepForm(null);
						return false;
					}
				}
			}
		});
	} 
</script>