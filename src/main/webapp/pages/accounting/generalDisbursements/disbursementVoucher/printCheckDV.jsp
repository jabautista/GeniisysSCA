<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="printCheckDVMainDiv" class="sectionDiv" style="padding:10px; margin-top: 10px; margin-bottom: 10px; width: 96%;">
	<div id="payeeTopDiv" name="payeeTopDiv" class="sectionDiv" align="center">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned" width="75px">DV Payee</td>
				<td class="leftAligned" colspan="5"><input type="text" id="txtPrintDvPayee" name="txtPrintDvPayee" style="width: 500px;" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">DV No</td>
				<td class="leftAligned"><input style="width: 60px;" type="text" id="txtPrintDvPref" name="txtPrintDvPref" readonly="readonly"></td>
				<td class="rightAligned" width="2px">-</td>
				<td class="leftAligned"><input style="width: 120px; text-align: right;" type="text" id="txtPrintDvNo" name="txtPrintDvNo" readonly="readonly"></td>
				<td class="rightAligned" width="90px">DV Status</td>
				<td class="leftAligned">
					<input type="hidden" id="hidPrintDvFlag" name="hidPrintDvFlag">
					<input style="width: 201px;" type="text" id="txtPrintDvStatus" name="txtPrintDvStatus" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
	<div id="itemDiv" name="itemDiv" class="sectionDiv" align="center">
		<table style="margin: 10px;">
			<tr>
				<td class="rightAligned">Item No.</td>
				<td class="leftAligned" colspan="3">
					<div style="float:left; border: solid 1px gray; width: 60px; height: 23px;" class="">
						<input type="text" id="txtPrintItemNo" name="txtPrintItemNo" readonly="readonly" style="width: 34px; border:none; float:left; text-align: right;" class="" /> 
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osPrintItemNo" name="osPrintItemNo" alt="Go" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblPrintPayee">Check Payee</td>
				<td class="leftAligned" colspan="3"><input style="width: 500px;" type="text" id="txtPrintCheckPayee" name="txtPrintCheckPayee" readonly="readonly"></td>
			</tr>
			<tr>
				<td class="rightAligned">Bank</td>
				<td class="leftAligned">
					<input type="hidden" id="hidPrintBankCd" name="hidPrintBankCd">
					<input style="width: 201px;" type="text" id="txtPrintBank" name="txtPrintBank" readonly="readonly">
				</td>
				<td class="rightAligned" width="85px">Bank Acct.</td>
				<td class="leftAligned">
					<input type="hidden" id="hidPrintBankAcctCd" name="hidPrintBankAcctCd">
					<input style="width: 201px;" type="text" id="txtPrintBankAcct" name="txtPrintCheckBankAcct" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" id="lblPrintCheckStatus">Check Status</td>
				<td class="leftAligned">
					<input type="hidden" id="hidPrintCheckStat" name="hidPrintCheckStat">
					<input style="width: 201px;" type="text" id="txtPrintCheckStatus" name="txtPrintCheckStatus" readonly="readonly">
				</td>
				<td class="rightAligned" id="lblPrintCheckDate">Check Date</td>
				<td class="leftAligned">
					<div id="printCheckDateDiv" name="printCheckDateDiv" style="border: solid 1px gray; width:207px; height: 20px;" class="required">
				    	<input type="text" id="txtPrintCheckDate" name="txtPrintCheckDate"  style="float:left;width:182px; border: none; height:12px;" class="required" changeTagAttr="true" readonly="readonly"/>
				    	<img name="hrefCheckDate" id="hrefCheckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="align:right;" alt="CheckDate" onClick="scwShow($('txtPrintCheckDate'),this, null);" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div id="optionsDiv" class="sectionDiv">
		<table style="float: left; margin-top:30px; margin-left: 60px;">
			<tr>
				<td style="float: left; height: 20px;"><input type="checkbox" id="chkCheck" name="chkCheck" style="margin-top: 3px;"></td>
				<td><label for="chkCheck">Check</label></td>
			</tr>
			<tr>
				<td style="float: left; height: 20px;"><input type="checkbox" id="chkDv" name="chkDv" style="margin-top: 3px;"></td>
				<td><label for="chkDv">DV</label></td>
			</tr>
		</table>
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px; float: left; margin-left: 70px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<!-- <option value="screen">Screen</option> -->
						<option value="printer">Printer</option>
						<!-- <option value="file">File</option> -->
						<option value="local">Local Printer</option>
					</select>
				</td>
			</tr>		
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 200px;" class="required">
						<option></option>
						<%-- <c:forEach var="p" items="${printers}">
							<option value="${p.printerNo}">${p.printerName}</option>
						</c:forEach> --%>
						<!-- installed printers muna gamitin - andrew - 02.27.2012 -->
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">No. of Copies</td>
				<td class="leftAligned">
					<input type="text" id="txtNoOfCopies" maxlength="2" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
	</div>
</div>
<div style="" align="center">
	<input type="button" class="button" id="btnPrintCmDm" value="Print CM/DM" style="width: 100px; display: none;"/>
	<input type="button" class="button" id="btnPrintReport" value="Print" style="width: 80px;"/>
	<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 80px;"/>
</div>
<script type="text/javascript">
try{	
	var confirmToggle = false; //kenneth SR 19136 08072015
	var showSuccessMsg = true; //kenneth SR 19136 08072015
	var contUpdateGiac = false; //added by robert SR 5301 01.28.2016

	$("btnCancel").observe("click", function(){
		if(nvl(objGIACS052.reloadCheckDetails, "N") == "Y"){
			showCheckDetailsPage(objGIACS052.disbVoucherInfo, $F("hidGaccTranId"));	
		}
		objGIACS002.dvFlag = objGIACS052.dvFlag;
		objGIACS002.dvFlagMean = objGIACS052.dvFlagMean; // kris 04.16.2014
		overlayGIACS052.close();
	});

  	window.addEventListener("unload",function(e) {//kenneth SR 19136 08072015
		if(confirmToggle){
			e.returnValue = "Message";
			fireEvent($("btn1"), "click");
			showSuccessMsg = false;
		}else{
			null;
		}
    });  
 
   window.addEventListener("beforeunload",function(e) {//kenneth SR 19136 08072015
		if(confirmToggle){
			e.returnValue = "Message";
			fireEvent($("btn1"), "click");
			showSuccessMsg = false;
		}else{
			null;
		}
    });  
     
	objGIACS052.vars = JSON.parse('${objGIACS052}');
	objGIACS052.setCmDmPrint = JSON.parse('${setCmDmParams}'); // added by: Nica 06.13.2013 AC-SPECS-2012-153
	
	
	if(nvl(objGIACS052.setCmDmPrint.enablePrintBtn, "N") == "Y"){
		$("btnPrintCmDm").show();
	}else{
		$("btnPrintCmDm").hide();
	}
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			if('${showFileOption}' == 'true'){ //condition added by: Nica 04.22.2013 - to prevent javascript error
				$("rdoPdf").disable();				
			}
		} else {
			if('${showFileOption}' == 'true'){ //condition added by: Nica 04.22.2013 - to prevent javascript error
				if(dest == "file"){
					$("rdoPdf").enable();
				} else {
					$("rdoPdf").disable();
				}				
			}
			
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}

	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	

	function disableCheckFields(){
		$("chkCheck").disabled = true;
		$("printCheckDateDiv").removeClassName("required");
		$("txtPrintCheckDate").removeClassName("required");
		disableDate("hrefCheckDate");
		disableSearch("osPrintItemNo");

		if(objGIACS052.checkDVPrint == "1" || objGIACS052.checkDVPrint == "3"){
			disableButton("btnPrintReport");
		}
	}
	
	function clearSomeItems(){
		try {
			$("txtPrintItemNo").value = "";
			$("txtPrintCheckPayee").value = "";
			$("hidPrintBankCd").value = "";
			$("txtPrintBank").value = "";
			$("hidPrintCheckStat").value = "";
			$("txtPrintCheckDate").value = "";
			$("txtPrintCheckStatus").value = "";
			$("txtPrintBankAcct").value = "";
			$("hidPrintBankAcctCd").value = "";
			$("chkCheck").checked = false;
			$("selDestination").selectedIndex = 0;
			$("selPrinter").selectedIndex = 0;
			$("txtNoOfCopies").value = 1;
		} catch(e){
			showErrorMessage("clearSomeItems", e);
		}
	}

	function executeQuery(){
		new Ajax.Request(contextPath+"/GIACChkDisbursementController", {
				parameters: {action : "showGIACS052",
							 reQuery : "Y",
							 tranId : objGIACS052.gaccTranId},
				onComplete: function(response){
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						objGIACS052.vars = JSON.parse(response.responseText);
						objGIACS052.dvFlag = nvl(objGIACS052.vars.dvFlag,objGIACS052.dvFlag); //added by steven 09.16.2014
						objGIACS052.dvFlagMean = nvl(objGIACS052.vars.dvFlagMean,objGIACS052.dvFlagMean);//added by steven 09.16.2014
						initGIACS052(true);
					}
				}
			});
	}
	
	function restoreCheck(){
		try {
			confirmToggle = false; //kenneth SR 19136 08072015
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "giacs052RestoreCheck",
							  tranId : objGIACS052.gaccTranId,
							  branchCd : objGIACS052.gibrBranchCd,
							  fundCd : objGIACS052.gibrGfunFundCd,
							  checkCnt : objGIACS052.checkCnt,
							  itemNo : $F("txtPrintItemNo"),
							  bankCd : $F("hidPrintBankCd"),
							  bankAcctCd : $F("hidPrintBankAcctCd"),
							  checkDvPrint : objGIACS052.checkDVPrint,
							  checkDate : $F("txtPrintCheckDate"),
							  chkPrefix : objGIACS052.chkPrefix,
							  checkNo : objGIACS052.checkNo},
		 		onComplete : function(response){
			 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
			 			$("chkDv").checked = false;
			 			$("chkCheck").checked = false;
						$("selDestination").selectedIndex = 0;
						$("selPrinter").selectedIndex = 0;
						$("txtNoOfCopies").value = 1;
			 		}
			 	}
			});
		} catch(e){
			showErrorMessage("restoreCheck", e);
		}			
	}
	
	function spoilCheck(){
		try {
			confirmToggle = false; //kenneth SR 19136 08072015
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "giacs052SpoilCheck",
							  tranId : objGIACS052.gaccTranId,
							  branchCd : objGIACS052.gibrBranchCd,
							  fundCd : objGIACS052.gibrGfunFundCd,
							  checkCnt : objGIACS052.checkCnt,
							  itemNo : $F("txtPrintItemNo"),
							  checkDvPrint : objGIACS052.checkDVPrint},
		 		onComplete : function(response){
			 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
			 			$("chkDv").checked = false;
			 			$("chkCheck").checked = false;
						$("selDestination").selectedIndex = 0;
						$("selPrinter").selectedIndex = 0;
						$("txtNoOfCopies").value = 1;
			 		}
			 	}
			});
		} catch(e){
			showErrorMessage("spoilCheck", e);
		}			
	}
	
	// added by: Nica 06.13.2013 AC-SPECS-2012-153
	function setCmDmPrintBtn(){
		try {
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "setCmDmPrintBtn",
							  tranId : objGIACS052.gaccTranId},
		 		onComplete : function(response){
			 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
			 			var res = JSON.parse(response.responseText);	
			 			if(nvl(res.enablePrintBtn, "N") == "Y"){
			 				$("btnPrintCmDm").show();
			 				objGIACS052.setCmDmPrint = res;
			 				if(showSuccessMsg){ //kenneth SR 19136 08072015
			 					customShowMessageBox("DV/Check printing is successful. You may now print the Credit Memo for RI Commissions. Simply press the Print CM/DM button.", "I", "btnPrintCmDm");
			 					getCmDmTranIdMemoStat(); 
			 				}
			 			}else{
			 				$("btnPrintCmDm").hide();
			 				if(showSuccessMsg){ //kenneth SR 19136 08072015
			 					showMessageBox("Printing successful.", "S"); //added by robert
			 				}
			 			}
			 			showSuccessMsg = true; //kenneth SR 19136 08072015
				 	}
			 	}
			});
		} catch(e){
			showErrorMessage("setCmDmPrintBtn", e);
		}
	}
	/* added by MarkS 5.24.2016 */
	function getCmDmTranIdMemoStat(){
		try {
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "getCmDmTranIdMemoStat",
							  tranId : objGIACS052.gaccTranId},
		 		onComplete : function(response)
		 		{
		 			if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response))
		 			{
		 				var res = JSON.parse(response.responseText);
		 				objGIACS052.setCmDmTranIdMemoStat = res;
			 		}
			 			
				 }
			 	
			});
		} catch(e){
			showErrorMessage("getCmDmTranIdMemoStat", e);
		}

}
	/* end SR-5484 */
	function updateGiac(){
		try {
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
				parameters : {action : "giacs052UpdateGiac",
							  tranId : objGIACS052.gaccTranId,
							  branchCd : objGIACS052.gibrBranchCd,
							  fundCd : objGIACS052.gibrGfunFundCd},
				onComplete : function(response){
			 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
			 			if(objGIACS052.checkDVPrint == "2"){	
			 				clearSomeItems();
							executeQuery();
			 			}
			 			if(objGIACS052.dvFlag == "P"){ // added by Kris 04.16.2014
			 				$("txtPrintDvStatus").value = objGIACS052.dvFlagMean;
							$("txtPrintItemNo").value = "";
							disableSearch("osPrintItemNo");
							$("txtPrintCheckPayee").value = "";
							$("txtPrintBank").value = "";
							$("txtPrintBankAcct").value = "";
							$("txtPrintCheckStatus").value = "";
							$("txtPrintCheckDate").value = "";
							disableDate("hrefCheckDate");
			 			}
			 			setCmDmPrintBtn(); // added by: Nica 06.13.2013 AC-SPECS-2012-153
			 			confirmToggle = false; //kenneth SR 19136 08072015
				 	}
			 	}
			});
		} catch(e){
			showErrorMessage("updateGiac", e);
		}		
	}
	
	function processAfterPrinting(){
		try {
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
					asynchronous : false,
					parameters : {action : "giacs052ProcessAfterPrinting",
								  tranId : objGIACS052.gaccTranId,
								  branchCd : objGIACS052.gibrBranchCd,
								  fundCd : objGIACS052.gibrGfunFundCd,
								  checkCnt : objGIACS052.checkCnt,
								  itemNo : $F("txtPrintItemNo"),
								  bankCd : $F("hidPrintBankCd"),
								  bankAcctCd : $F("hidPrintBankAcctCd"),
								  checkDvPrint : objGIACS052.checkDVPrint,
								  printDv : ($("chkDv").checked ? "Y" : "N"),
								  printCheck : ($("chkCheck").checked ? "Y" : "N"),
								  checkDate : $F("txtPrintCheckDate"),
								  disbMode : objGIACS052.vars.disbMode,
								  dvFlag : objGIACS052.dvFlag,
								  prtDv : objGIACS052.vars.prtDv,
								  prtChk : nvl(objGIACS052.vars.prtChk, "N"),
								  chkPrefix : objGIACS052.chkPrefix,
								  checkNo : objGIACS052.checkNo,
								  documentCd: objGIACS052.setCmDmPrint.documentCd},
			 		onComplete : function(response){
				 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
				 			if(objGIACS052.checkDVPrint == "1" || objGIACS052.checkDVPrint == "3") {
				 				confirmToggle = true; //kenneth SR 19136 08072015
				 				showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No", 
				 						updateGiac, 
					 					function(){
						 					showConfirmBox4("Confirmation", "What do you want to do?", "Spoil Check", "Restore Check", "Exit", spoilCheck, restoreCheck, updateGiac);	
						 				});
				 			} else if(objGIACS052.checkDVPrint == "2"){	
					 			if(!$("chkCheck").checked && objGIACS052.vars.disbMode == "B"){
						 			clearSomeItems();
						 		}
					 			if($("chkDv").checked){
										objGIACS052.vars.prtDv = "Y";
										showSuccessMsg = true;
								}
				 				if(objGIACS052.vars.prtChk == "Y"){
				 					confirmToggle = true; //kenneth SR 19136 08072015
				 					objGIACS052.vars.prtChk = "N";
				 					showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No", 
					 						updateGiac, 
						 					function(){
							 					showConfirmBox4("Confirmation", "What do you want to do?", "Spoil Check", "Restore Check", "Exit", spoilCheck, restoreCheck, updateGiac);	
							 				});					 				
				 				} else if(nvl(objGIACS052.vars.prtChk, "N") == "N" && objGIACS052.vars.prtDv == "Y"){  //added nvl by robert 02.13.15
				 					if(contUpdateGiac){ //added by robert SR 5301 01.28.2016
				 						updateGiac();
				 					}
				 					contUpdateGiac = false;
				 					objGIACS052.vars.prtDv = "N";
				 					$("chkDv").checked = false;
				 					$("selPrinter").selectedIndex = 0;
				 					setCmDmPrintBtn();
				 					
					 			}				
				 			}

							var result = JSON.parse(response.responseText);
							if(result.stillWithCheck == "N"){
				 				disableCheckFields();
							}
							// added by Kris 04.16.2014 to clear the fields after successful printing
							objGIACS052.dvFlag = nvl(result.dvFlag, objGIACS052.dvFlag);
				 			objGIACS052.dvFlagMean = nvl(result.dvFlagMean, objGIACS052.dvFlagMean);
					 	}
				 	}
				});
		} catch(e){
			showErrorMessage("processAfterPrinting", e);
		}
	}
	
	function processAfterPrinting2(reports){
		try {
			new Ajax.Request(contextPath + "/GIACChkDisbursementController", {
					asynchronous : false,
					parameters : {action : "giacs052ProcessAfterPrinting",
								  tranId : objGIACS052.gaccTranId,
								  branchCd : objGIACS052.gibrBranchCd,
								  fundCd : objGIACS052.gibrGfunFundCd,
								  checkCnt : objGIACS052.checkCnt,
								  itemNo : $F("txtPrintItemNo"),
								  bankCd : $F("hidPrintBankCd"),
								  bankAcctCd : $F("hidPrintBankAcctCd"),
								  checkDvPrint : objGIACS052.checkDVPrint,
								  printDv : ($("chkDv").checked ? "Y" : "N"),
								  printCheck : ($("chkCheck").checked ? "Y" : "N"),
								  checkDate : $F("txtPrintCheckDate"),
								  disbMode : objGIACS052.vars.disbMode,
								  dvFlag : objGIACS052.dvFlag,
								  prtDv : objGIACS052.vars.prtDv,
								  prtChk : nvl(objGIACS052.vars.prtChk, "N"),
								  chkPrefix : objGIACS052.chkPrefix,
								  checkNo : objGIACS052.checkNo,
								  documentCd: objGIACS052.setCmDmPrint.documentCd},
			 		onComplete : function(response){
				 		if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
				 			 if(objGIACS052.checkDVPrint == "2"){	
					 			if(!$("chkCheck").checked && objGIACS052.vars.disbMode == "B"){
						 			clearSomeItems();
						 		}
					 					 				
				 				if(objGIACS052.vars.prtChk == "Y"){
				 					confirmToggle = true; 
				 					objGIACS052.vars.prtChk = "N";
				 					showSuccessMsg = false;
									var result = JSON.parse(response.responseText);
									if(result.stillWithCheck == "N"){
						 				disableCheckFields();
									}
									objGIACS052.dvFlag = nvl(result.dvFlag, objGIACS052.dvFlag);
						 			objGIACS052.dvFlagMean = nvl(result.dvFlagMean, objGIACS052.dvFlagMean);
				 					if($F("selDestination") == "printer"){
					 					showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No",
					 							function(){
					 								contUpdateGiac = true; //added by robert SR 5301 01.28.2016
					 								for(var i=0; i<reports.length; i++){
					 									new Ajax.Request(reports[i].reportUrl, {
					 										asynchronous : false,
					 										parameters : {noOfCopies : $F("txtNoOfCopies")},
					 										onCreate: showNotice("Processing, please wait..."),				
					 										onComplete: function(response){
					 											hideNotice();
					 											if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					 												updateGiac()	;
					 												processAfterPrinting();
					 											}
					 										}
					 									});
					 								}
					 							}, 
							 					function(){
					 								contUpdateGiac = false; //added by robert SR 5301 01.28.2016
								 					showConfirmBox4("Confirmation", "What do you want to do?", "Spoil Check", "Restore Check", "Exit", spoilCheck, restoreCheck, updateGiac);	
								 				});			
				 					}else if("local" == $F("selDestination")){
				 						showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No",
					 							function(){
				 									contUpdateGiac = true; //added by robert SR 5301 01.28.2016
					 								for(var i=0; i<reports.length; i++){
					 									new Ajax.Request(reports[i].reportUrl, {
					 										asynchronous : false,
					 										parameters : {destination : "LOCAL"},
					 										onComplete: function(response){
					 											hideNotice();
					 											if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					 												var result = printToLocalPrinter(response.responseText);
					 												if(result){
					 													updateGiac();
					 													processAfterPrinting();
					 												}
					 											}
					 										}
					 									});
					 								}
					 							}, 
							 					function(){
					 								contUpdateGiac = false; //added by robert SR 5301 01.28.2016
								 					showConfirmBox4("Confirmation", "What do you want to do?", "Spoil Check", "Restore Check", "Exit", spoilCheck, restoreCheck, updateGiac);	
								 				});	
				 					}
				 				}			
				 			}
					 	}
				 	}
				});
		} catch(e){
			showErrorMessage("processAfterPrinting2", e);
		}
	}
	
	function printGIACR052Report(){
		try {
			var reports = [];
			var checkReportVars = [];
			var dvReportVars = [];
			var reportId = "GIACR052";
			var reportTitle = "Check Voucher";
			var content = contextPath+"/GIACS052PrintController?action=printGIACS052Report&tranId="+objGIACS052.gaccTranId
							//+"&itemNo="+ nvl($F("txtTGItem"), $F("txtPrintItemNo")) // Kenneth 10202014  //replaced by john dolon 7.13.2016
							+"&itemNo="+ $F("txtPrintItemNo")
							+"&checkDate="+$F("txtPrintCheckDate")
							+"&checkPref="+objGIACS052.chkPrefix //lara 12/16/2013
							+"&checkNo="+objGIACS052.checkNo
							+"&branchCd="+objGIACS052.gibrBranchCd
							+"&printerName="+$F("selPrinter");
			
			
			if(objGIACS052.checkDVPrint == "1") {
				reportId = "GIACR052";
				reports.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
 			} else if(objGIACS052.checkDVPrint == "2"){
				if($("chkCheck").checked){
					reportId = "GIACR052C";
					reportTitle = "Check";
					objGIACS052.vars.prtChk = "Y";
					//reports.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
					checkReportVars.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
				}
				if($("chkDv").checked){
					reportId = "GIACR052A";
					reportTitle = "Voucher";
					objGIACS052.vars.prtDv = "Y";
					//reports.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});	
					dvReportVars.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
				}			
			} else if(objGIACS052.checkDVPrint == "3"){
				reportId = "GIACR052C";
				reports.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
			} else if(objGIACS052.checkDVPrint == "4"){
				reportId = "GIACR052A";
				reports.push({reportUrl : content+"&reportId="+reportId+"&reportTitle="+reportTitle, reportTitle : reportTitle});
			}
			if(objGIACS052.checkDVPrint != "2"){
				if("screen" == $F("selDestination")){
					showMultiPdfReport(reports);
					processAfterPrinting();
					reports = [];
				}else if($F("selDestination") == "printer"){
					for(var i=0; i<reports.length; i++){
						new Ajax.Request(reports[i].reportUrl, {
							asynchronous : false,
							parameters : {noOfCopies : $F("txtNoOfCopies")},
							onCreate: showNotice("Processing, please wait..."),				
							onComplete: function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									processAfterPrinting();							
								}
							}
						});
					}
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "FILE"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					for(var i=0; i<reports.length; i++){
						new Ajax.Request(reports[i].reportUrl, {
							asynchronous : false,
							parameters : {destination : "LOCAL"},
							onComplete: function(response){
								hideNotice();
								if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
									var result = printToLocalPrinter(response.responseText);
									if(result){
										processAfterPrinting();
									}
								}
							}
						});
					}
				}
			}else{
				if($F("selDestination") == "printer"){
					if($("chkCheck").checked && $("chkDv").checked){
						for(var i=0; i<checkReportVars.length; i++){
							new Ajax.Request(checkReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {noOfCopies : $F("txtNoOfCopies")},
								onCreate: showNotice("Processing, please wait..."),				
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										processAfterPrinting2(dvReportVars);
									}
								}
							});
						}
					}else{
						for(var i=0; i<checkReportVars.length; i++){
							new Ajax.Request(checkReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {noOfCopies : $F("txtNoOfCopies")},
								onCreate: showNotice("Processing, please wait..."),				
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										processAfterPrinting();							
									}
								}
							});
						}
						for(var i=0; i<dvReportVars.length; i++){
							new Ajax.Request(dvReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {destination : "LOCAL"},
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										var result = printToLocalPrinter(response.responseText);
										if(result){
											processAfterPrinting();
										}
									}
								}
							});
						}
					}
				}else if("local" == $F("selDestination")){
					if($("chkCheck").checked && $("chkDv").checked){
						for(var i=0; i<checkReportVars.length; i++){
							new Ajax.Request(checkReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {destination : "LOCAL"},
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										var result = printToLocalPrinter(response.responseText);
										if(result){
											processAfterPrinting2(dvReportVars);
/* 											if(!$("chkCheck").checked && objGIACS052.vars.disbMode == "B"){
									 			clearSomeItems();
									 		}
											confirmToggle = true; 
							 				objGIACS052.vars.prtChk = "N";
											showConfirmBox("Confirmation", "Was the printing successful?", "Yes", "No", 
							 						function(){
							 							updateGiac();
							 							for(var i=0; i<dvReportVars.length; i++){
							 								new Ajax.Request(dvReportVars[i].reportUrl, {
							 									asynchronous : false,
							 									parameters : {destination : "LOCAL"},
							 									onComplete: function(response){
							 										hideNotice();
							 										if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
							 											var result = printToLocalPrinter(response.responseText);
							 											if(result){
							 												processAfterPrinting();
							 											}
							 										}
							 									}
							 								});
							 							}
							 						}, 
								 					function(){
									 					showConfirmBox4("Confirmation", "What do you want to do?", "Spoil Check", "Restore Check", "Exit", spoilCheck, restoreCheck, updateGiac);	
									 				}); */
										}
									}
								}
							});
						}
					}else{
						for(var i=0; i<checkReportVars.length; i++){
							new Ajax.Request(checkReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {destination : "LOCAL"},
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										var result = printToLocalPrinter(response.responseText);
										if(result){
											processAfterPrinting();
										}
									}
								}
							});
						}
						for(var i=0; i<dvReportVars.length; i++){
							new Ajax.Request(dvReportVars[i].reportUrl, {
								asynchronous : false,
								parameters : {destination : "LOCAL"},
								onComplete: function(response){
									hideNotice();
									if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
										var result = printToLocalPrinter(response.responseText);
										if(result){
											processAfterPrinting();
										}
									}
								}
							});
						}
					}
				}
			}
		} catch(e){
			showErrorMessage("printGIACR052Report", e);
		}
	}
	
	// added by: Nica 06.13.2013 AC-SPECS-2012-153
	//edited by MarkS 5.24.2016 SR-5484 added parameter currTran
	function updateCmDmMemoStatus(currTran){
		try{
			new Ajax.Request(contextPath + "/GIACMemoController?action=updateMemoStatus", {
				method		: "POST",
				parameters	: {
					memoStatus	: objGIACS052.setCmDmTranIdMemoStat[currTran].memoStatus,
					gaccTranId	: nvl(objGIACS052.setCmDmTranIdMemoStat[currTran].cmDmTranId, 0)					
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function (response) {
					if(!(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response, null))){
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}catch(e){
			showErrorMessage("updateCmDmMemoStatus",e);
		}
	}
	
	// added by: Nica 06.13.2013 AC-SPECS-2012-153
	// edited MarkS 5.24.2016 SR-5484
	function printCmDm(){
		try{
			var tranIds;
			for (i = 0; i < objGIACS052.setCmDmTranIdMemoStat.length; i++){
				if(i==0){
					tranIds = "|" + objGIACS052.setCmDmTranIdMemoStat[i].cmDmTranId + "|";	
				} else{
					tranIds = tranIds + objGIACS052.setCmDmTranIdMemoStat[i].cmDmTranId + "|";
				}
			};
 				var content = contextPath + "/GeneralLedgerPrintController?action=printReport"
								  			  + "&noOfCopies=" + $F("txtNoOfCopies") 
								  			  + "&printerName=" + $F("selPrinter") 
								  			  + "&destination=" + $F("selDestination")
											  + "&tranId=" + tranIds
											  + "&reportId=GIACR071";
				
				printGenericReport(content, "Print Credit/Debit Memo",updateCmDmMemoStats); 
				
			//end SR-5484
		}catch(e){
			showErrorMessage("printCmDm",e);
		}
	}

	objGIACS052.printGIACR052Report = printGIACR052Report;
	// added MarkS 9.23.2016 SR-23107
    function updateCmDmMemoStats(){
    	for (i = 0; i < objGIACS052.setCmDmTranIdMemoStat.length; i++){
			updateCmDmMemoStatus(i);
		}
    }
  	//end SR-23107
	function showCheckNo(){
		overlayGIACS052CheckNo = Overlay.show(contextPath+"/GIACChkDisbursementController", {
			urlContent: true,
			urlParameters: {action : "showGIACS052CheckNo",
							printPrsd : "Y",
							disbMode : objGIACS052.vars.disbMode,
							bankCd : $F("hidPrintBankCd"),
							bankSname : $F("txtPrintBank"),
							bankAcctCd : $F("hidPrintBankAcctCd"),
							printCheck : ($("chkCheck").checked ? "Y" : "N"),
							branchCd : objGIACS052.gibrBranchCd,
							fundCd : objGIACS052.gibrGfunFundCd},
			showNotice: true,
		    title: "Check No",
		    height: 150,
		    width: 400,
		    draggable: true
		});
	}
	
	function validateBeforePrint(){
		if(objGIACS052.checkDVPrint == "2"){
			if(!$("chkCheck").checked && !$("chkDv").checked){
				showWaitingMessageBox("Please choose document to print.", "I", function(){
					$("chkCheck").focus();
				});
				return false;
			}
		}

		if(objGIACS052.checkDVPrint == "2" && objGIACS052.vars.disbMode != "B" && $("chkCheck").checked){
			if($F("txtPrintItemNo") == "") {
				showWaitingMessageBox("Please select an item number.", "I", function(){
					$("txtPrintItemNo").focus();
				});
			}

			var dvDate = Date.parse(objGIACS052.dvDate); //.format("mm-dd-yyyy");
			var checkDate = Date.parse($F("txtPrintCheckDate")); //.format("mm-dd-yyyy");

			//if(checkDate < dvDate){
			if (compareDatesIgnoreTime(checkDate, dvDate) == 1){
				showWaitingMessageBox("Check date should not be earlier than DV date " + Date.parse(objGIACS052.dvDate).format("mmmm-dd-yyyy"), "I", function(){
					$("txtPrintCheckDate").focus();
				});
				return false;
			}			
		} else if(objGIACS052.checkDVPrint == "1" && objGIACS052.vars.disbMode != "B" && objGIACS052.vars.genTransferNo == "M"){
			var dvDate = Date.parse(objGIACS052.dvDate).format("mm-dd-yyyy");
			var checkDate = Date.parse($F("txtPrintCheckDate")).format("mm-dd-yyyy");
			
			if($("chkCheck").checked && checkDate < dvDate) {
				showWaitingMessageBox("Check date should not be earlier than DV date " + Date.parse(objGIACS052.dvDate).format("mmmm-dd-yyyy"), "I", function(){
					$("txtPrintCheckDate").focus();
				});
				return false;
			}
		} else if(objGIACS052.checkDVPrint == "3" && objGIACS052.vars.disbMode != "B"){
			if($F("txtPrintItemNo") == "") {
				showWaitingMessageBox("Please select an item number.", "I", function(){
					$("txtPrintItemNo").focus();
				});
			}

			var dvDate = Date.parse(objGIACS052.dvDate).format("mm-dd-yyyy");
			var checkDate = Date.parse($F("txtPrintCheckDate")).format("mm-dd-yyyy");

			if(checkDate < dvDate){
				showWaitingMessageBox("Check date should not be earlier than DV date " + Date.parse(objGIACS052.dvDate).format("mmmm-dd-yyyy"), "I", function(){
					$("txtPrintCheckDate").focus();
				});
				return false;
			}			
		}

		if($("chkCheck").checked){
			enableSearch("osPrintItemNo");
		} else {
			disableSearch("osPrintItemNo");
		}
		
		if("printer" == $F("selDestination")){
			if($F("selPrinter") == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, "E", function(){
					$("selPrinter").focus();
				});
				return false;
			} else if($F("txtNoOfCopies") == ""){
				showWaitingMessageBox(objCommonMessage.REQUIRED, "E", function(){
					$("txtNoOfCopies").focus();
				});
				return false;
			}
		}

		if($("chkCheck").checked){
			showCheckNo();
		} else if(!$("chkCheck").checked && objGIACS052.vars.disbMode == "B" && $F("hidPrintCheckStat") == "1"){
			showCheckNo();
		} else {
			printGIACR052Report();
		}
	}

	function setCheckDvPrintItems(reQuery){
		if(objGIACS052.checkDVPrint == "1"){
			$("chkCheck").disabled = true;
			$("chkDv").disabled = true;

			if(objGIACS052.vars.disbMode == "B"){
				$("chkCheck").checked = false;
			} else {
				$("chkCheck").checked = true;
			}
			if(!reQuery) {
				$("chkDv").checked = true;
			}			
		} else if(objGIACS052.checkDVPrint == "2"){
			if(objGIACS052.vars.dvApprovedBy != null){
				if(objGIACS052.vars.disbMode == "B"){
					if(objGIACS052.vars.genTransferNo == "M"){
						$("chkCheck").disabled = true;
					} 
					$("chkCheck").checked = false;	
				} else {
					$("chkCheck").disabled = false;
					$("chkCheck").checked = true;
				}
			} else {
				$("chkCheck").disabled = true;
				$("chkCheck").checked = false;	
			}

			$("chkDv").disabled = false;
			if(!reQuery) {
				$("chkDv").checked = true;
			}
		} else if(objGIACS052.checkDVPrint == "3"){
			$("chkCheck").disabled = true;
			$("chkDv").disabled = true;

			if(objGIACS052.vars.disbMode == "B"){
				if(objGIACS052.vars.genTransferNo == "M"){
					$("chkCheck").checked = false;
				}
			} else {
				$("chkCheck").checked = true;
			}

			if(!reQuery) {
				$("chkDv").checked = true;
			}
		} else if(objGIACS052.checkDVPrint == "4"){
			$("chkCheck").disabled = true;
			$("chkDv").disabled = true;
			$("chkCheck").checked = false;
			if(!reQuery) {
				$("chkDv").checked = true;
			}
		}
	}
	
	function initGIACS052(reQuery){
		try {
			$("txtPrintDvPayee").value = objGIACS052.payee;
			$("txtPrintDvPref").value = objGIACS052.dvPref;
			$("txtPrintDvNo").value = objGIACS052.dvNo;
			$("hidPrintDvFlag").value = objGIACS052.dvFlag;
			$("txtPrintDvStatus").value = objGIACS052.dvFlagMean;
			$("txtPrintItemNo").value = objGIACS052.vars.itemNo;
			$("txtPrintCheckPayee").value = unescapeHTML2(objGIACS052.vars.payee);
			$("hidPrintBankCd").value = objGIACS052.vars.bankCd;
			$("txtPrintBank").value = objGIACS052.vars.bankSname;
			$("hidPrintCheckStat").value = objGIACS052.vars.checkStat;
			$("txtPrintCheckDate").value = objGIACS052.vars.checkDate == null ? "" : Date.parse(objGIACS052.vars.checkDate).format("mm-dd-yyyy"); //added format by robert
			$("txtPrintCheckStatus").value = objGIACS052.vars.checkStatMean;
			$("txtPrintBankAcct").value = objGIACS052.vars.bankAcctNo;
			$("hidPrintBankAcctCd").value = objGIACS052.vars.bankAcctCd;

			setCheckDvPrintItems(reQuery);
			
			if(objGIACS052.vars.stillWithCheck != "Y"){
				$("chkCheck").disabled = true;
				$("printCheckDateDiv").removeClassName("required");
				$("txtPrintCheckDate").removeClassName("required");
				disableDate("hrefCheckDate");
				disableSearch("osPrintItemNo");
			}
			
			if(objGIACS052.vars.disbMode == "B"){
				$("lblPrintPayee").innerHTML = "Payee";
				$("lblPrintCheckStatus").innerHTML = "BT Status";
				$("lblPrintCheckDate").innerHTML = "BT Date";
			} else {
				$("lblPrintPayee").innerHTML = "Check Payee";
				$("lblPrintCheckStatus").innerHTML = "Check Status";
				$("lblPrintCheckDate").innerHTML = "Check Date";
			}
			
			if(objGIACS052.checkDVPrint == "4"){
				$("chkDv").checked = true;
			}

			if($F("txtPrintItemNo") != ""){			
				if((objGIACS052.checkDVPrint == "1" || objGIACS052.checkDVPrint == "3") && objGIACS052.vars.disbMode == "C"){
					if(!$("chkCheck").checked){
						$("chkCheck").checked = true;
					}

					if(objGIACS052.checkDVPrint == "1"){
						if(!$("chkDv").checked){ //changed from chkDV to chkDv by robert 10.17.2013
							$("chkDv").checked = true;
						}
					}
				}
			}
			
			toggleRequiredFields("printer");
			$("btnPrintReport").focus();
		 } catch(e){
			showErrorMessage("initGIACS052", e);
		 }
	}

	$("btnPrintReport").observe("click", validateBeforePrint);
	
	$("osPrintItemNo").observe("click", function(){
		LOV.show({
			controller: "AccountingLOVController",
			urlParameters: {action: "getGIACS052ChecksLOV",
							tranId: objGIACS052.gaccTranId,
							page: 1},
			title: "List of Check Details",
			width: 800,
			height: 350,
			columnModel : [
			               {
			            	   id : "itemNo",
			            	   title: "Item No",
			            	   titleAlign : 'right',
			            	   align : 'right',
			            	   width: '65px'
			               },
			               {
			            	   id: "payee",
			            	   title: "Payee",
			            	   width: '250px'
			               },
			               {
			            	   id: "bankSname",
			            	   title: "Bank",
			            	   width: '90px'
			               },
			               {
			            	   id: "bankAcctNo",
			            	   title: "Bank Acct No.",
			            	   width: '110px'
			               },
			               {
			            	   id: "checkStatMean",
			            	   title: "Check Status",
			            	   width: '90px'
			               },
			               {
			            	   id: "amount",
			            	   title: "Amount",
			            	   width: '100px',
			            	   titleAlign : 'right',
			            	   align : 'right',
			            	   renderer: function(value){
			            		   return formatCurrency(value);
			            	   }		            	   
			               },
			               {
			            	   id: "shortName",
			            	   title: "Currency",
			            	   width: '80px'		            	   
			               }
			              ],
			draggable: true,
			onSelect: function(row) {
				$("txtPrintItemNo").value = row.itemNo;
				$("txtPrintCheckPayee").value = row.payee;
				$("hidPrintBankCd").value = row.bankCd;
				$("txtPrintBank").value = row.bankSname;
				$("hidPrintCheckStat").value = row.checkStat;
				$("txtPrintCheckDate").value = row.checkDate;
				$("txtPrintCheckStatus").value = row.checkStatMean;
				$("txtPrintBankAcct").value = row.bankAcctNo;
				$("hidPrintBankAcctCd").value = row.bankAcctCd;
			}
		});
	});

	$("txtNoOfCopies").observe("keyup", function(e) {	
		if(isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) < 1) { //edited d.alcantara, 10.12.2012
			$("txtNoOfCopies").value = 1;
		}
	});
	
	// added by: Nica 06.13.2013 AC-SPECS-2012-153
	$("btnPrintCmDm").observe("click", function(){
		getCmDmTranIdMemoStat();
		showGenericPrintDialog("Print Credit/Debit Memo", printCmDm, null, true);
		
	});
	
/* 	setModuleId("GIACS052");
	setDocumentTitle("Print Check DV"); */
	initializeAll();
	initGIACS052(false);
}catch(e){
	showErrorMessage("Print Check DV Error: ", e);
}


</script>