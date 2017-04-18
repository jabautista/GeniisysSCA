<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left;" id="printDialogOptionsFormDiv1">
		<table id="printOptionsDialogMainTab" name="printOptionsDialogMainTab" align="left" style="padding: 10px 10px 0 10px;">
			<tr id="trMotorshop" style="visibility: hidden;">
				<td class="rightAligned">Motorshop</td>
				<td class="leftAligned">
				    <input style="width: 149px;" id="txtMotorshop" name="txtMotorshop" type="text" value="" tabindex="900" class="required"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><input type="checkbox" id="chkDemandLetter1" name="recoveryLetter" tabindex="901" title="Demand Letter 1" reportId="GICLR025" reportTitle="Demand Letter 1" style="float: left;"/><label title="Demand Letter 1" for="chkDemandLetter1">Demand Letter 1 </label></td>
				<td class="leftAligned">
				    <input style="width: 149px;" id="txtDemandLetterDate" name="txtDemandLetterDate" type="text" value="" readonly="readonly" tabindex="902" class=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><input disabled="disabled" type="checkbox" id="chkDemandLetter2" name="recoveryLetter" title="Demand Letter 2" reportId="GICLR025_B" reportTitle="Demand Letter 2" style="float: left;"/><label title="Demand Letter 2" for="chkDemandLetter2">Demand Letter 2 </label></td>
				<td class="leftAligned">
					<div style="float: left; margin-top: 2px; width: 155px; height: 19px; margin-right:3px; border: 1px solid gray;" class="">
				    	<input style="margin-top: 0; width: 131px; border: none; float: left; height: 11px;" id="txtDemandLetterDate2" name="txtDemandLetterDate2" type="text" value="" readonly="readonly" tabindex="" class=""/>
				    	<img name="imgDate2" id="imgDate2" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDemandLetterDate2'),this, null);" alt="Date" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><input disabled="disabled" type="checkbox" id="chkDemandLetter3" name="recoveryLetter" title="Demand Letter 3" reportId="GICLR025_C" reportTitle="Demand Letter 3" style="float: left;"/><label title="Demand Letter 3" for="chkDemandLetter3">Demand Letter 3 </label></td>
				<td class="leftAligned">
				    <input style="width: 149px;" id="txtDemandLetterDate3" name="txtDemandLetterDate3" type="text" value="" readonly="readonly" tabindex="" />				    
				</td>
			</tr>
			<tr>
				<td class="rightAligned"><input type="checkbox" id="chkDeedOfSale" name="recoveryLetter" title="Deed of Sale" reportId="GICLR025_D" reportTitle="Deed Of Sale" style="float: left;"/><label title="Deed of Sale" for="chkDeedOfSale">Deed of Sale </label></td>
				<td class="leftAligned">					
				</td>
			</tr>	
		</table>
		<table align="right" style="padding: 0 10px 10px 0;">
			<tr>
				<td class="rightAligned">Date</td>
				<td class="leftAligned">
					<div style="float: left; margin-top: 2px; width: 197px; height: 19px; margin-right:3px; border: 1px solid gray;" class="">
				    	<input style="margin-top: 0; width: 173px; border: none; float: left; height: 11px;" id="txtDate" name="txtDate" type="text" value="" readonly="readonly" tabindex="" class=""/>
				    	<img name="imgDate4" id="imgDate4" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtDate'),this, null);" alt="Date" />
					</div>				
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Place</td>
				<td class="leftAligned">
					<input type="text" id="txtPlace" style="float: left; text-align: right; width: 293px;" class="" disabled="disabled" maxlength="200">				
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="float: left;" id="printDialogFormDiv">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 200px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
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
					<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma">
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
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
	</div>	
</div>
<script type="text/javascript">
	var reportVersion = '${reportVersion}';
	var sysdate = '${sysdate}';
	var demandLetterDate = '${demandLetterDate}';
	var demandLetterDate2 = '${demandLetterDate2}';
	var demandLetterDate3 = '${demandLetterDate3}';
	var printChangeTag = 0; //added by steven 9/19/2012
	initializeAll();
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
		} else {
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

	$("btnPrintCancel").observe("click", function(){
		overlayPrintRecoveryLetter.close();
		if (printChangeTag == 1){
			objCLM.recoveryDetailsTG.refresh();
		}
	});
	
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
	
	function printRecoveryLetters(){
		var reports = [];	
		var letterDate = $F("txtDemandLetterDate").trim() == "" ? sysdate : $F("txtDemandLetterDate"); //added by steven 9/19/2012
		var letterDate2 = $F("txtDemandLetterDate2").trim() == "" ? sysdate : $F("txtDemandLetterDate2");
		var letterDate3 = $F("txtDemandLetterDate3").trim() == "" ? sysdate : $F("txtDemandLetterDate3");
		$$("input[name='recoveryLetter']").each(function(chk){			
			if(chk.checked){
				var reportId = chk.getAttribute("reportId");
				var reportTitle = chk.getAttribute("reportTitle");
				var content = contextPath+"/PrintRecoveryLetterController?action=printRecoveryLetter"
								+"&reportId="+reportId
								+"&claimId="+nvl(objCLMGlobal.claimId, objCLM.basicInfo.claimId)
								+"&recoveryId="+objCLM.recoveryDetailsCurrRow.recoveryId
								+"&payorCd="+objCLM.recPayorCurrRow.payorCd
								+"&payorClassCd="+objCLM.recPayorCurrRow.payorClassCd
								+"&reportTitle="+reportTitle
								+"&printerName="+$F("selPrinter")
								+"&destination="+$F("selDestination")	//added by steven 8/23/2012
								+"&claimNo="+$F("claimNo")
								+"&DemandLetterDate="+letterDate	//added by steven 9/19/2012
								+"&DemandLetterDate2="+letterDate2
								+"&DemandLetterDate3="+letterDate3
								+"&DeedOfSaleDate="+$F("txtDate")
								+"&DeedOfSalePlace="+encodeURIComponent($F("txtPlace"));	//added by steven 12/11/2012
				reports.push({reportUrl : content, reportTitle : reportTitle});
				
				if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						method: "POST",
						parameters : {noOfCopies : $F("txtNoOfCopies")},					
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								showMessageBox("Printing Completed.", "S");  //added by steven 8/23/2012
							}
						}
					});
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "FILE"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "LOCAL"},
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}
							}
						}
					});
				}				
			}
		});		
		
		if("screen" == $F("selDestination")){
			showMultiPdfReport(reports);
		}
	}	
	
	function updateDemandLetterDate(){
		new Ajax.Request(contextPath+"/GICLClmRecoveryController?action=updateDemandLetterDates", {
			parameters : {
				claimId : nvl(objCLMGlobal.claimId, objCLM.basicInfo.claimId),
				recoveryId : objCLM.recoveryDetailsCurrRow.recoveryId,
				demandLetterDate : $F("txtDemandLetterDate"),
				demandLetterDate2 : $F("txtDemandLetterDate2"),
				demandLetterDate3 : $F("txtDemandLetterDate3")
			},
			onComplete: function(response){
				hideNotice();
			}
		});
	}
	
	function validatePrint(){
		if(!$("chkDemandLetter1").checked && !$("chkDemandLetter2").checked && !$("chkDemandLetter3").checked && !$("chkDeedOfSale").checked){
			showMessageBox("Please check at least one of the choices.", "E");
		} else {		
			var dest = $F("selDestination");
			if(dest == "printer" && !checkAllRequiredFieldsInDiv("printDialogFormDiv")){	//change by steven 8/23/2012 from: checkAllRequiredFieldsInDiv("printDialogFormDiv") to:	!checkAllRequiredFieldsInDiv("printDialogFormDiv")
				return false;
			}else if(dest == "printer"){
				if(isNaN($F("txtNoOfCopies")) || $F("txtNoOfCopies") <= 0 || $F("txtNoOfCopies") > 100){
					showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
						$("txtNoOfCopies").value = "1";
					});
				}
			}			
			
			new Ajax.Request(contextPath + "/GICLRecoveryPaytController", {
				parameters : {action : "valPrint",
							  report1 : $("chkDemandLetter1").checked ? "Y" : "N", 
							  report2 : $("chkDemandLetter2").checked ? "Y" : "N",
						      report3 : $("chkDemandLetter3").checked ? "Y" : "N",
						      report4 : $("chkDeedOfSale").checked ? "Y" : "N"
							 },
				onComplete : function(response){
					try {
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){					
							printRecoveryLetters();
							showDemandDate(); //added by steven 9/19/2012
							updateDemandLetterDate();
							printChangeTag = 1; //added by steven 9/19/2012 para kung naprint na siya irerefresh niya yong objCLM.recoveryDetailsTG na tableGrid kapag nag-cancel ka.
 						}
					} catch(e){
						showErrorMessage("validatePrint - onComplete", e);							
					}
				}
			});			
		}
	}	
	
	function initializePrintDialog(){
// 		$("txtDemandLetterDate").value = objCLM.recoveryDetailsCurrRow.demandLetterDate == null ? "" : dateFormat(objCLM.recoveryDetailsCurrRow.demandLetterDate, "mm-dd-yyyy");
// 		$("txtDemandLetterDate2").value = objCLM.recoveryDetailsCurrRow.demandLetterDate2 == null ? "" : dateFormat(objCLM.recoveryDetailsCurrRow.demandLetterDate2, "mm-dd-yyyy");
// 		$("txtDemandLetterDate3").value = objCLM.recoveryDetailsCurrRow.demandLetterDate3 == null ? "" : dateFormat(objCLM.recoveryDetailsCurrRow.demandLetterDate3, "mm-dd-yyyy");

		$("txtDemandLetterDate").value = demandLetterDate;   	//added by steven 8/30/2012
		$("txtDemandLetterDate2").value = demandLetterDate2;	//added by steven 8/30/2012
		$("txtDemandLetterDate3").value = demandLetterDate3;	//added by steven 8/30/2012
		disableDate("imgDate4");
		
		if($F("txtRecoveredAmt").trim() == "" || $F("txtRecoveredAmt") == "0.00"){
			$("chkDeedOfSale").disabled = true;
		} else {
			$("chkDeedOfSale").disabled = false;
		}
		
		if(reportVersion == "CIC"){
			$("chkDemandLetter2").disabled = false;
			$("chkDemandLetter3").disabled = false;
			$("trMotorshop").style.visibility = "visible";
		} else {
			disableDate("imgDate2");
			
			if($F("txtDemandLetterDate").trim() != ""){
				$("chkDemandLetter2").disabled = false;
			}
			
			if($F("txtDemandLetterDate2").trim() != ""){
				$("chkDemandLetter3").disabled = false;
				enableDate("imgDate2");
			}
		}
	}
	
	function onChangeDeedOfSale(){
		if($("chkDeedOfSale").checked){
			enableDate("imgDate4");
			$("txtPlace").disabled = false;
		} else {
			disableDate("imgDate4");
			$("txtPlace").disabled = true;
		}
	}
	
	function onChangeDemandLetter1(){
		if($("chkDemandLetter1").checked){	
// 			if($F("txtDemandLetterDate").trim() == "" && $F("txtDemandLetterDate2").trim() == ""){	remove by steven 9/19/2012
// 				$("txtDemandLetterDate").value = sysdate;
// 				$("txtDemandLetterDate2").value = sysdate;									
// 				$("chkDemandLetter2").disabled = false;
// 				$("chkDemandLetter3").disabled = false;
// 			} else 
			if($F("txtDemandLetterDate").trim() != ""){
				if($F("txtDemandLetterDate").trim() != sysdate){										
					showConfirmBox("Confirmation", "The first demand letter was printed on " + dateFormat(Date.parse($F("txtDemandLetterDate").trim()), "mmmm dd, yyyy") + ". Do you want to update the demand letter date to the current date?",
									"Yes",
									"No",
									function(){
										$("txtDemandLetterDate").value = sysdate;
										$("txtDemandLetterDate2").value = sysdate;
										objCLM.recoveryDetailsCurrRow.demandLetterDate = sysdate;
										objCLM.recoveryDetailsCurrRow.demandLetterDate2 = sysdate;
									},
									function(){															
										$("txtDemandLetterDate2").value = $("txtDemandLetterDate").value;
										objCLM.recoveryDetailsCurrRow.demandLetterDate2 = $("txtDemandLetterDate").value;
									});
				}
			}
		}		
	}
	
	function onChangeDemandLetter2(){
		if($("chkDemandLetter2").checked){
// 			if($F("txtDemandLetterDate2").trim() == "" && $F("txtDemandLetterDate3").trim() == ""){	remove by steven 9/19/2012
// 				$("txtDemandLetterDate2").value = sysdate;
// 				$("chkDemandLetter3").disabled = false;
// 			} else 
			if($F("txtDemandLetterDate2").trim() != ""){
				if($F("txtDemandLetterDate2").trim() != sysdate){
					showConfirmBox("Confirmation", "The second demand letter was printed on " + dateFormat(Date.parse($F("txtDemandLetterDate").trim()), "mmmm dd, yyyy") + ". Do you want to update the demand letter date to the current date?",
									"Yes",
									"No",
									function(){
										$("txtDemandLetterDate2").value = sysdate;
										objCLM.recoveryDetailsCurrRow.demandLetterDate2 = sysdate;
									},
									"");
				}
			}
		}		
	}
	
	function onChangeDemandLetter3(){
		if($("chkDemandLetter3").checked){
// 			if($F("txtDemandLetterDate3").trim() == "" && $F("txtDemandLetterDate2").trim() != ""){	remove by steven 9/19/2012
// 				$("txtDemandLetterDate3").value = sysdate;
// 			} else 
			if($F("txtDemandLetterDate3").trim() != ""){
				if($F("txtDemandLetterDate3").trim() != sysdate){
					showConfirmBox("Confirmation", "The third demand letter was printed on " + dateFormat(Date.parse($F("txtDemandLetterDate3").trim()), "mmmm dd, yyyy") + ". Do you want to update the demand letter date to the current date?",
									"Yes",
									"No",
									function(){
										$("txtDemandLetterDate3").value = sysdate;
										objCLM.recoveryDetailsCurrRow.demandLetterDate3 = sysdate;
									},
									"");
				}
			}
		}		
	}
	
	function showDemandDate() {//added by steven 9/19/2012
		if($("chkDemandLetter1").checked){	
			if($F("txtDemandLetterDate").trim() == "" && $F("txtDemandLetterDate2").trim() == ""){
				$("txtDemandLetterDate").value = sysdate;
				$("txtDemandLetterDate2").value = sysdate;									
				$("chkDemandLetter2").disabled = false;
				$("chkDemandLetter3").disabled = false;
			} 
		}
		if($("chkDemandLetter2").checked){
			if($F("txtDemandLetterDate2").trim() == "" && $F("txtDemandLetterDate3").trim() == ""){
				$("txtDemandLetterDate2").value = sysdate;
				$("chkDemandLetter3").disabled = false;
			} 
		}
		if($("chkDemandLetter3").checked){
			if($F("txtDemandLetterDate3").trim() == "" && $F("txtDemandLetterDate2").trim() != ""){
				$("txtDemandLetterDate3").value = sysdate;
			} 
		}
	}
	
	$("btnPrint").observe("click", validatePrint);
	$("chkDeedOfSale").observe("change", onChangeDeedOfSale);	
	$("chkDemandLetter1").observe("change", onChangeDemandLetter1);	
	$("chkDemandLetter2").observe("change", onChangeDemandLetter2);
	$("chkDemandLetter3").observe("change", onChangeDemandLetter3);
	
	initializePrintDialog();
	toggleRequiredFields("screen");
</script>