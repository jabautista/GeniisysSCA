<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>

<div id="statisticalRepMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit" name="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Generate Statistical Reports</label>
		</div>
	</div>
 
 	<div id="groDiv" name="groDiv" class="sectionDiv" style="margin-bottom: 10px;">
 		<input type="hidden">
		<div id="tabComponentsDiv1" class="tabComponents1" style="float: left;">
			<ul>
				<li class="tab1 selectedTab1" style="width: 130px;"><a id="statistical">Statistical</a></li>
				<li class="tab1" style="width: 130px;"><a id="riskProfile">Risk Profile</a></li>
				<li class="tab1" style="width: 130px;"><a id="fireStat">Fire Stat</a></li>
				<li class="tab1" style="width: 130px;"><a id="motorStat">Motor Stat</a></li>
			</ul>
		</div>
		
		<div class="tabBorderBottom1"></div>
		
		<div id="statisticalReportsDiv">
			<div class="" style="float: left; width: 920px; height: 450px;" align="center"">
				<div class="sectionDiv" style="width: 600px; height: 400px; margin: 20px 0 30px 175px;">
					<div id="fieldsDiv" class="sectionDiv" style="width: 580px; height: 180px; margin: 10px 10px 1px 10px;">
						<table align="center" style="margin-top: 15px;">
							<tr>
								<td class="rightAligned">Subline</td>
								<td>
									<input id="hidLineCd" type="hidden">
									<input id="hidSublineCd" type="hidden">
									<div id="sublineDiv" style="border: 1px solid gray; width: 350px; height: 20px; float: left; margin-right: 7px;">
										<input id="txtSubline" name="txtSubline" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 320px; height: 13px; margin: 0px;" value="" tabindex="101"/>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSubline" name="searchSubline" alt="Go" style="float: right;"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Vessel</td>
								<td>
									<input id="hidVesselCd" type="hidden">
									<div id="vesselDiv" style="border: 1px solid gray; width: 350px; height: 20px; float: left; margin-right: 7px;">
										<input id="txtVessel" name="txtVessel" class="leftAligned upper" type="text" maxlength="30" style="border: none; float: left; width: 320px; height: 13px; margin: 0px;" value="" tabindex="102"/>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchVessel" name="searchVessel" alt="Go" style="float: right;"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Class Code</td>
								<td>
									<div id="cargoClassCdDiv" style="border: 1px solid gray; width: 350px; height: 20px; float: left; margin-right: 7px;">
										<input id="txtCargoClassCd" name="txtCargoClassCd" class="leftAligned upper integerNoNegativeUnformattedNoComma" type="text" maxlength="2" style="border: none; float: left; width: 320px; height: 13px; margin: 0px;" value="" tabindex="103"/>
										<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCargoClassCd" name="searchCargoClassCd" alt="Go" style="float: right;"/>
									</div>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Description</td>
								<td>
									<input id="txtCargoClassDesc" name="txtCargoClassDesc" class="leftAligned upper" type="text" readonly="readonly" maxlength="300" style="float: left; width: 345px;" value="" tabindex="104"/>
										
								</td>
							</tr>
							<tr>
								<td class="rightAligned">From</td>									
								<td>
									<div id="fromDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
										<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="required disableDelKey" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="105"/>
										<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtFromDate').focus(); scwShow($('txtFromDate'),this, null);" />
									</div>
									<label style="float: left; padding-top: 2px; margin-right: 5px; padding-left: 28px;">To</label>
									<div id="toDateDiv" class="required" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
										<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="required disableDelKey" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="106"/>
										<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="$('txtToDate').focus(); scwShow($('txtToDate'),this, null);" />
									</div>
								</td>
							</tr>
						</table>	
					</div>
					
					<div id="rdoDiv" class="sectionDiv" style="width: 230px; height: 150px; margin: 0 1px 5px 10px;">
						<table style="margin: 25px 0 0 0;">
							<tr>
								<td>Report Layout:</td>
							</tr>
							<tr>
								<td>
									<input value="V" title="Vessel" type="radio" id="vesselRB" name="statChoiceRG" style="margin: 12px 5px 4px 25px; float: left;" checked="checked" ><label for="vesselRB" style="margin: 12px 0 4px 0" tabindex="107">Vessel</label>
								</td>
							</tr>
							<tr>
								<td>
									<input value="C" title="Cargo Classification" type="radio" id="cargoRB" name="statChoiceRG" style="margin: 2px 5px 4px 25px; float: left;" ><label for="cargoRB" style="margin: 2px 0 4px 0" tabindex="108" >Cargo Classification</label>
								</td>
							</tr>
						</table>
					</div>
					
					<div class="sectionDiv" id="printDialogFormDiv" style="padding-top: 5px; width: 346px; height: 145px;" align="center">
						<table style="float: left; padding: 15px 0 0 15px;">
							<tr>
								<td class="rightAligned">Destination</td>
								<td class="leftAligned">
									<select id="selDestination" style="width: 200px;" tabindex="109">
										<option value="screen">Screen</option>
										<option value="printer">Printer</option>
										<option value="file">File</option>
										<option value="local">Local Printer</option>
									</select>
								</td>
							</tr>
							<tr>
								<td></td>
								<td>
									<input value="PDF" title="PDF" type="radio" id="pdfRB" name="fileRG" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled"><label for="pdfRB" style="margin: 2px 0 4px 0" tabindex="110">PDF</label>
									<input value="EXCEL" title="Excel" type="radio" id="excelRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="excelRB" style="margin: 2px 0 4px 0" tabindex="111">Excel</label>
									<input value="CSV" title="CSV" type="radio" id="csvRB" name="fileRG" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled"><label for="csvRB" style="margin: 2px 0 4px 0" tabindex="111">CSV</label>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">Printer</td>
								<td class="leftAligned">
									<select id="selPrinter" style="width: 200px;" class="required" tabindex="112">
										<option></option>
										<c:forEach var="p" items="${printers}">
											<option value="${p.name}">${p.name}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td class="rightAligned">No. of Copies</td>
								<td class="leftAligned">
									<input type="text" id="txtNoOfCopies" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="113">
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
						<input id="btnPrint" type="button" class="button" value="Print" style="width: 85px;" tabindex="114">
					</div>
				</div>
			</div>
		</div>
 	</div>
 	
</div>

<script type="text/javascript">
try{
	setModuleId("GIPIS901");
	setDocumentTitle("Generate Statistical Reports");
	makeInputFieldUpperCase();
	initializeTabs();
	initializeAll();
	$("txtSubline").focus();
	$("txtCargoClassCd").readOnly = true;
	disableSearch("searchCargoClassCd");
	
	objGIPIS901.changeTagDetail = 0;	
	objGIPIS901.lineCdFi = '${lineCdFi}';
	objGIPIS901.lineCdMc = '${lineCdMc}';
	
	var statChoice = "V";
	
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
			$("pdfRB").disabled = true;
			$("excelRB").disabled = true;
			$("csvRB").disabled = true;
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
			if(dest == "file"){
				$("pdfRB").disabled = false;
				$("excelRB").disabled = false;
				$("csvRB").disabled = false;
			}else{
				$("pdfRB").disabled = true;
				$("excelRB").disabled = true;
				$("csvRB").disabled = true;
			}		
		}
	}
	
	function setCurrentTab(id){
		$$("div.tabComponents1 a").each(function(a){
			if(a.id == id) {
				$(id).up("li").addClassName("selectedTab1");					
			}else{
				a.up("li").removeClassName("selectedTab1");	
			}	
		});
	}
	
	function showSublineLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGipis901MnSublineLOV"
			},
			title : "List of Sublines",
			width : 450,
			height : 380,
			columnModel : [ {
				id : "sublineName",
				title : "Subline",
				width : '350px',
			}, {
				id : "sublineCd",
				title : "Subline Cd",
				width : '80px'
			}, {
				id : "lineCd",
				title : "Line Cd",
				width : '80px'
			} ],
			findText : $F("txtSubline").trim(),
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				$("hidLineCd").value = row.lineCd;
				$("hidSublineCd").value = row.sublineCd;
				$("txtSubline").value = row.sublineName;
			},
			onCancel: function(){
				$("txtSubline").focus();
			}
		});
	}
	
	function showVesselLOV(){
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGipis901MnVesselLOV"
			},
			title : "List of Vessels",
			width : 450,
			height : 380,
			columnModel : [ {
				id : "vesselName",
				title : "Vessel",
				width : '350px',
			}, {
				id : "vesselCd",
				title : "Code",
				width : '80px'
			}],
			findText : $F("txtVessel").trim(),
			draggable : true,
			autoSelectOneRecord: true,
			onSelect : function(row) {
				$("hidVesselCd").value = row.vesselCd;
				$("txtVessel").value = row.vesselName;
			},
			onCancel: function(){
				$("txtVessel").focus();
			}
		});
	}
	
	
	function beforePrinting(){
		try{
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters:	{
					action:			"beforePrintingStatTab",
					statChoice:		statChoice,
					fromDate:		$F("txtFromDate"),
					toDate:			$F("txtToDate"),
					vessel:			statChoice == "V" ? $F("txtVessel") : null,
					cargoClassCd:	statChoice == "C" ? $F("txtCargoClassCd") : null,
					subline:		$F("txtSubline")
				},
				onCreate: showNotice("Extracting records, please wait..."),
				onComplete: function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						objGIPIS901.extractId = json.extractId;
						
						//if (json.recCnt != 0){
							var params = "&sublineCd="+$F("hidSublineCd")+"&extractId="+objGIPIS901.extractId+"&fromDate="+$F("txtFromDate")
							  			+"&toDate="+$F("txtToDate");
							var reportId = null;
							var reportTitle = null;
							
							if (statChoice == "V"){
								reportId = "GIPIR071";
								reportTitle = "STATISTICAL REPORT PER VESSEL";
								params = params+"&reportId="+reportId+"&vesselCargoCd="+$F("hidVesselCd");
							}else if (statChoice == "C"){
								reportId = "GIPIR072";
								reportTitle = "STATISTICAL REPORT PER CARGO CLASSIFICATION";
								params = params+"&reportId="+reportId+"&vesselCargoCd="+$F("txtCargoClassCd");
							}
							
							printReport(reportId, reportTitle, params);
						/*}else{
							showMessageBox("No records printed for the chosen parameter", imgMessage.WARNING);
						}*/
					}
				}
			});
		}catch(e){
			showErrorMessage("beforePrinting", e);
		}
	}
	
	function printReport(reportId, reportTitle, params){
		try{
			var content = contextPath+"/UWPrintStatisticalReportsController?action=printReportsStatisticalTab"+"&noOfCopies="+
						  $F("txtNoOfCopies")+"&printerName="+$F("selPrinter")+"&destination="+$F("selDestination")+params;
			
			if($F("selDestination") == "screen"){
				showPdfReport(content, reportTitle);
			} else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "POST",
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "I");
						}
					}
				});
			}else if("file" == $F("selDestination")){
				//added by clperello | 06.10.2014
				 var fileType = "PDF";
			
				if($("pdfRB").checked)
					fileType = "PDF";
				else if ($("excelRB").checked)
					fileType = "XLS";
				else if ($("csvRB").checked)
					fileType = "CSV"; 
				//end here clperello | 06.10.2014	
				
				new Ajax.Request(content, {
						method: "POST",
						parameters : {destination : "FILE",
									  fileType    : fileType}, //$("pdfRB").checked ? "PDF" : "XLS"}, commented out by clperello
						evalScripts: true,
						asynchronous: true,
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								/*var message = $("fileUtil").copyFileToLocal(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								}*/
								if (checkErrorOnResponse(response)){
									if (fileType == "CSV"){ //added by clperello | 06.10.2014
										copyFileToLocal(response, "csv");
										deleteCSVFileFromServer(response.responseText);
									} else 
										copyFileToLocal(response);
								}
							}
						}
					});
			} else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "LOCAL"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							printToLocalPrinter(response.responseText);
						}
					}
				});
			}	
		}catch(e){
			showErrorMessage("printReport", e);
		}
	}
	
	function checkRiskProfileDetail(tabName){
		
		/* if(objGIPIS901.changeTagDetail == 1) { // Removed by Apollo Cruz 10.22.2014
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						//goToTab(tabName);
						riskSave(function(){goToTab(tabName);}); 
					}, 
					function(){
						objGIPIS901.changeTagDetail = 0;
						goToTab(tabName); 
					}, 
					"");
		}else{
			objGIPIS901.changeTagDetail = 0;
			goToTab(tabName); 
		} */
		
		objGIPIS901.changeTagDetail = 0;
		goToTab(tabName);
	}
	
	function goToTab(tabName){
		var tabName2 = tabName + "Tab";
		
		if (changeTag == 0){
			setCurrentTab(tabName);
			resetGIPIS901GlobalVar();
			showGIPIS901(tabName2);
		}
	}
	
	observeAccessibleModule(accessType.MENU, "GIPIS901", "statistical", function(){
		checkRiskProfileDetail("statistical");
	});
	observeAccessibleModule(accessType.MENU, "GIPIS901", "riskProfile", function(){
		checkRiskProfileDetail("riskProfile");
	});
	
	observeAccessibleModule(accessType.MENU, "GIPIS901", "fireStat", function(){
		checkRiskProfileDetail("fireStat");
	});
	
	observeAccessibleModule(accessType.MENU, "GIPIS901", "motorStat", function(){
		checkRiskProfileDetail("motorStat");
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
	
	$("searchSubline").observe("click", showSublineLOV);
	
	$("txtSubline").observe("change", function(){
		if (this.value != ""){
			var findText = $F("txtSubline").trim();
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis901MnSublineLOV",findText,"Searching Subline, please wait...");
			
			if(cond == 0){
				this.clear();
				$("hidLineCd").clear();
				$("hidSublineCd").clear();
				//showMessageBox("Invalid value for SUBLINE_NAME", imgMessage.INFO);
				showSublineLOV();
			}else if(cond == 2){
				showSublineLOV();
			}else{
				this.value = unescapeHTML2(cond.rows[0].sublineName);
				$("hidLineCd").value = unescapeHTML2(cond.rows[0].lineCd);
				$("hidSublineCd").value = unescapeHTML2(cond.rows[0].sublineCd);
			}
		}else{
			$("hidLineCd").clear();
			$("hidSublineCd").clear();
		}
	});
	
	
	$("searchVessel").observe("click", showVesselLOV);
	
	$("txtVessel").observe("change", function(){
		if (this.value != ""){
			var findText = $F("txtVessel").trim();
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis901MnVesselLOV",findText,"Searching Vessel, please wait...");
			
			if(cond == 0){
				this.clear();
				$("hidVesselCd").clear();
				//showMessageBox("Invalid Value for VESSEL_NAME", imgMessage.INFO);
				showVesselLOV();
			}else if(cond == 2){
				showVesselLOV();
			}else{
				this.value = unescapeHTML2(cond.rows[0].vesselName);
				$("hidVesselCd").value = unescapeHTML2(cond.rows[0].vesselCd);
			}
		}else{
			$("hidVesselCd").clear();
		}	
	});
	
	$("searchCargoClassCd").observe("click", showCargoClassLOV2);
	
	$("txtCargoClassCd").observe("change", function(){
		$("txtCargoClassDesc").clear();
		if (this.value != ""){
			var findText = $F("txtCargoClassCd").trim();
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getCargoClassLOV3",findText,"Searching Vessel, please wait...");
			
			if(cond == 0){
				this.clear();
				$("txtCargoClassDesc").clear();
				$("txtCargoClassDesc").clear();
				//showMessageBox("Invalid value for CARGO_CLASS_CD", imgMessage.INFO);
				showCargoClassLOV2();
			}else if(cond == 2){
				showCargoClassLOV2();
			}else{
				this.value = cond.rows[0].cargoClassCd;
				$("txtCargoClassDesc").value = unescapeHTML2(cond.rows[0].cargoClassDesc);
			}
		}
	});
	
	$("txtFromDate").observe("blur", function(){
		checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
	});
	
	$("txtToDate").observe("blur", function(){
		checkInputDates("txtToDate", "txtFromDate", "txtToDate");
	});
	
	$$("input[name='statChoiceRG']").each(function(rb){
		rb.observe("click", function(){
			if ($F(rb) == "V"){
				statChoice = $F(rb);
				$("txtVessel").readOnly = false;
				enableSearch("searchVessel");
				$("txtCargoClassCd").readOnly = true;
				disableSearch("searchCargoClassCd");
				$("txtCargoClassCd").clear();
				$("txtCargoClassDesc").clear();
			}else{
				statChoice = $F(rb);
				$("txtCargoClassCd").readOnly = false;
				enableSearch("searchCargoClassCd");
				$("txtVessel").readOnly= true;
				disableSearch("searchVessel");
				$("hidVesselCd").clear();
				$("txtVessel").clear();
			}
		});
	});
	
	$("btnPrint").observe("click", function(){
		if (checkAllRequiredFieldsInDiv("fieldsDiv") && checkAllRequiredFieldsInDiv("printDialogFormDiv")){
			beforePrinting();
		}
	});
	
	$("btnExit").observe("click", function(){
		if (changeTag == 1 || objGIPIS901.changeTagDetail == 1 ){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel",
					function(){
						riskSave(function(){goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);});
						//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, 
					function(){
						changeTag = 0;
						objGIPIS901.changeTagDetail = 0;
						goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					},
					function(){}
				);
		}else{
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}	
	});
	

	toggleRequiredFields("screen");
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>
