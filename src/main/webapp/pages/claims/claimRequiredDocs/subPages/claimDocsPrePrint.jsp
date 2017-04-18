<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<input type="hidden" value="${printerNames}" id="printerNames">
<input type="hidden" id="callOut" name="callOut" value="${callOut}"/>
<input type="hidden" id="title" name="title" value="${title}"/>
<div id="docsListMainDiv" class="sectionDiv" style="width:497px;">
	<div id="prePrintDiv" style="margin: 10px;">
		<table style="width: 400px;">
			<tr>
				<td colspan="2">Send To:</td>
				<!-- <td></td> -->
			</tr>
			<tr>
				<td>
					<div style="border: 1px solid gray; width: 176px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 150px;" id="sendToCd" name="sendToCd" type="text" value="${details.sendToCd}" maxlength="30" rea/>
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sendToCdGo" name="sendToCdGo" alt="Go" />
			    	</div>	
				</td>
				<td>
					<div style="border: 1px solid gray; width: 276px; height: 21px; float: left; margin-right: 3px;">
			    		<input style="float: left; border: none; margin-top: 0px; width: 250px;" id="sendTo" name="sendTo" type="text" value="${assuredName}" maxlength="800"/>
			    		<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sendToGo" name="sendToGo" alt="Go" />
			    	</div>			
				</td>
			</tr>
			<tr>
				<td colspan="2">Address:</td>
			</tr>
			<tr>
				<td colspan="2">
					<textArea id="address" name="address"  maxlength="150"  style="width: 97.6%; resize: none;" >${details.address}</textArea>
				</td>	
			</tr>
			<tr>
				<td colspan="2">Attention:</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="text" id="attention" name="attention"  maxlength="150" style="width: 97.6%;" value="${details.attention}"/>
				</td>	
			</tr>
			<tr>
				<td colspan="2">Beginning Text:</td>
			</tr>
			<tr>
				<td colspan="2">
					<%-- <textArea id="beginningText" name="beginningText"  maxlength="500"  style="width: 97.6%; resize: none;" >${details.beginningText}</textArea> --%>
					<div style=" border: 1px solid gray; height: 20px; padding-bottom: 1px;">
						<textarea tabindex="1003" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 435px; height: 13px; float: left; border: none; resize : none;" id="beginningText" name="beginningText">${details.beginningText}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="editBeginningText" id="editBeginningText" class="hover" />
					</div>
				</td>	
			</tr>
			<tr>
				<td colspan="2">Ending Text:</td>
			</tr>
			<tr>
				<td colspan="2">
					<%-- <textArea id="endingText" name="endingText"  maxlength="500"  style="width: 97.6%;  resize: none;" >${details.endingText}</textArea> --%>
					<div style=" border: 1px solid gray; height: 20px; padding-bottom: 1px;">
						<textarea tabindex="1003" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);" style="width: 435px; height: 13px; float: left; border: none; resize : none;" id="endingText" name="endingText">${details.endingText}</textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: left;" alt="editBeginningText" id="editEndingText" class="hover" />
					</div>
				</td>	
			</tr>
		</table>
		<table style="margin-top: 10px; width: 100%;">
			<tr>
				<td class="rightAligned" style="width: 10%;">
					Destination
				</td>
				<td class="leftAligned" style="width: 35%;">
					<select id="reportDestination" class="leftAligned required" style="width: 60%;"/>
						<option value="SCREEN">Screen</option>
						<option value="PRINTER">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>
					</select>
				</td>
			</tr>
			<tr>
				<c:if test="${showFileOption eq 'true'}">
				<tr>
					<td></td>
					<td>
						<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label>
						<input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label>
					</td>
				</tr>
			</c:if>	
			</tr>
			<tr>
				<td class="rightAligned" style="width: 25%;">
					Printer
				</td>
				<td class="leftAligned" style="width: 30%;" colspan="4">
					<select id="printerName" class="leftAligned" style="width: 60%;"/>

					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="width: 10%;">
					No. of Copies
				</td>
				<td class="leftAligned" style="">
					<input type="text" id="noOfCopies" maxlength="3" style="float: left; text-align: right; width: 143px;" class="required integerNoNegativeUnformattedNoComma">
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
	<div class="buttonsDiv">
		<input type="button" id="btnOk"	name="btnOk" class="button hover" style="width: 90px;" value="Return"/> <!--change by steven 2.6.2013; "Return"-->
		<input type="button" id="btnPrint" name="btnPrint" style="width: 90px;" class="button hover"   value="Print" />
		<input type="hidden" id="remove" />
	</div> 
</div>
<script>

	$("editBeginningText").observe("click", function(){
		showEditor("beginningText", 2000, "false"); //change by steven 2.6.2013;"false"
	});
	$("editEndingText").observe("click", function(){ //change by steven 2.6.2013;"false"
		showEditor("endingText", 2000, "false");
	});
	
	if($F("sendToCd") == ""){
		$("sendToCd").value = "Assured";
	}

	insertPrinterNames();
	$("printerName").disable();
	$("noOfCopies").removeClassName("required");
	$("noOfCopies").disable();
	
	function validateBeforePrint(){
		var result = true;
		if ($("reportDestination").value == "PRINTER" && $("noOfCopies").value == ""){
			result = false;
			$("reportDestination").focus();
			showMessageBox("Required fields must be entered.", "I");
		} else if (($("printerName").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			$("printerName").focus();
			showMessageBox("Required fields must be entered.", "I");
		} else if (($("noOfCopies").selectedIndex == 0) && ($("reportDestination").value == "PRINTER")){
			result = false;
			$("noOfCopies").focus();
			showMessageBox("Required fields must be entered.", "I");
		} 
		return result;
	}
	
	$("btnPrint").observe("click", function(){
		try{
			if (validateBeforePrint()){
				var destination	= $("reportDestination").value;
				var printerName = $("printerName").value;
				var noOfCopies 	= $("noOfCopies").value;
				
				// added replace function to print new line in report - christian 07.30.2012
				var content = contextPath+"/PrintDocumentsController?action=printClaimDocument"
						+"&claimId="+objCLMGlobal.claimId
						+"&sendTo="+encodeURIComponent($F("sendTo"))
						+"&address="+encodeURIComponent($F("address").replace(/\n/g, "<br/>"))
						+"&attention="+encodeURIComponent($F("attention"))
						+"&lineCd="+encodeURIComponent(objCLMGlobal.lineCd)
						+"&issCd="+encodeURIComponent(objCLMGlobal.issCd)
						+"&claimNo="+objCLMGlobal.claimNo
						+"&policyNo="+objCLMGlobal.policyNo
						+"&lossDate="+objCLMGlobal.strDspLossDate
						+"&callOut="+encodeURIComponent($F("callOut"))
						+"&title="+encodeURIComponent($F("title"))
						//+"&beginningText="+encodeURIComponent($F("beginningText").replace(/\n/g, "<br/>"))
						//+"&endingText="+encodeURIComponent($F("endingText").replace(/\n/g, "<br/>"))
						+"&beginningText="+encodeURIComponent($F("beginningText"))
						+"&endingText="+encodeURIComponent($F("endingText"))
						+"&printerName="+$F("printerName")
						+"&destination="+destination; 
				
				if ("SCREEN" == $F("reportDestination")) {
					//window.open(content, "name=test", "location=no, toolbar=no, menubar=no, fullscreen=yes");
					showPdfReport(content, "Claim Document"); // andrew - 12.12.2011
					//hideNotice("");
					if (!(Object.isUndefined($("docsListMainDiv")))){
						//hideOverlay();
					}
				} else if("file" == $F("reportDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : $("rdoPdf").checked ? "PDF" : "XLS"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response);
							}
						}
					});
				} else if("local" == $F("reportDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "local"},
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
				} else {
					new Ajax.Request(content, {
						parameters : {noOfCopies : noOfCopies,
							  	      printerName : printerName},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								
							}
						}
					});
				}
			}
		}catch(e){
			showErrorMessage("doc print error",e);
		}
		
	});	
	
	$("reportDestination").observe("change", function(){
		checkPrintDestinationFields();
	});

	$("sendToCdGo").observe("click", function(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGIISPayeeClassLOV",
							moduleId :  "GICLR011",
							page : 1},
			title: "Payees",
			width: 450,
			height: 400,
			columnModel : [
							{
								id : "classDesc",
								title: "Class Description",
								width: '430px'
							}
						],
			draggable: true,
			onSelect : function(row){
				$("sendToCd").value = unescapeHTML2(row.classDesc);
			}
		  });		

	});
	
	$("sendToGo").observe("click", function(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGIISPayeeLOVDetails",
							moduleId :  "GICLR011",
							sendToCd: $("sendToCd").value, 
							page : 1},
			title: "Payee Last Names",
			width: 620,
			height: 400,
			columnModel : [
							{
								id : "payeeLastName",
								title: "Payee Last Name",
								width: '200px'
							},{
								id:"address",
								title: "Address",
								width: '200px'
							},{
								id:"attention",
								title: "Attention",
								width: '200px'
							}
							
						],
			draggable: true,
			onSelect : function(row){
				$("sendTo").value = unescapeHTML2(row.payeeLastName);
				$("address").value = unescapeHTML2(row.address);
				$("attention").value = unescapeHTML2(row.attention);
			}
		  });		

	});
	$("btnOk").observe("click", function(){
		overlayPrinter.close();
		delete overlayPrinter;
	});
	
	function checkPrintDestinationFields(){
	if ("SCREEN" == $("reportDestination").value || "" == $("reportDestination").value || "local" == $("reportDestination").value || "screen" == $("reportDestination").value){
		$("printerName").removeClassName("required");
		$("noOfCopies").removeClassName("required");
		$("printerName").disable();
		$("noOfCopies").disable();
		$("printerName").selectedIndex = 0;
		$("noOfCopies").value = "";
		$("imgSpinUp").hide();
		$("imgSpinDown").hide();
		$("imgSpinUpDisabled").show();
		$("imgSpinDownDisabled").show();
		$("rdoPdf").disable();
		$("rdoExcel").disable();
		if ($("isPreview") != undefined){
			$("isPreview").value = 1;
		}
	} else if ("file" == $("reportDestination").value){
		$("rdoPdf").enable();
		$("rdoExcel").enable();
	}else {
		$("printerName").enable();
		$("noOfCopies").enable();
		$("printerName").addClassName("required");
		$("noOfCopies").addClassName("required");
		$("imgSpinUp").show();
		$("imgSpinDown").show();
		$("imgSpinUpDisabled").hide();
		$("imgSpinDownDisabled").hide();
		$("noOfCopies").value = 1;
		if ($("isPreview") != undefined){
			$("isPreview").value = 0;
		}
	}
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("noOfCopies"), 0));
		if(no < 100){
			$("noOfCopies").value = no + 1;
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("noOfCopies"), 0));
		if(no > 1){
			$("noOfCopies").value = no - 1;
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
	
	$("noOfCopies").observe("change", function(){
		if(isNaN($F("noOfCopies")) || $F("noOfCopies") <= 0 || $F("noOfCopies") > 100){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("noOfCopies").value = "1";
			});			
		}
	});
}
</script>