<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib uri="http://ajaxtags.org/tags/ajax" prefix="ajax" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
		<label>BIR Relief & Alphalist</label>
		<span class="refreshers" style="margin-top: 0;">
	 		<label id="reloadForm" name="reloadForm">Reload Form</label> 
		</span>
	</div>
</div>
<div id="birAlphalistMainDiv" style="margin-bottom: 15px; height: 545px; width: 100%; border: 1px solid #E0E0E0; float: left;">
	<div id="birAlphalistDiv" class="sectionDiv" style="height: 500px; width: 703px; margin: 20px 0px 0px 105px; ">
		<div style="width: 701px; height: 181px; float: left; ">
			<fieldset style="height: 165px; width: 321px; float: left; margin-left: 5px;">
				<legend><b>Record Type</b></legend>
				<div style="height: 30px; width: 100%; margin-top: 20px; float: left;">
					<input type="radio" id="rdoRelief" checked="checked" name="repType" style="float: left; margin-left: 23px;"/><label for="rdoRelief" style="margin-top: 3px;">Relief</label>
					<input type="radio" id="rdoAlphalist" name="repType" style="float: left; margin-left: 140px;"/><label for="rdoAlphalist" style="margin-top: 3px;">Alphalist</label>
				</div>
				<div style="float: left; width: 100%; margin-top: 10px; margin-bottom: 20px;">
					<hr size=1 width="300px">
				</div>
				<div id="rlfTypeDiv" style="width: 100%; float: left;">
					<table>
						<tr>
							<td><input type="radio" id="rdoSales" name="rlfType" checked="checked" style="margin-left: 10px; float: left;" /><label for="rdoSales" style="margin-top: 3px;">Summary List of Sales (SLS)</label></td>
						</tr>
						<tr>
							<td><input type="radio" id="rdoPurchases" name="rlfType" style="margin-left: 10px; float: left;" /><label for="rdoPurchases" style="margin-top: 3px;">Summary List of Purchases (SLP)</label></td>
						</tr>
					</table>
				</div>
				<div id="alpTypeDiv" style="width: 100%; float: left;">
					<table>
						<tr>
							<td><input type="radio" id="rdoMap" name="alpType" checked="checked" style="margin-left: 10px; float: left;" /><label for="rdoMap" style="margin-top: 3px;">Monthly Alphalist of Payees (MAP)</label></td>
						</tr>
						<tr>
							<td><input type="radio" id="rdoSawt" name="alpType" style="margin-left: 10px; float: left;" /><label for="rdoSawt" style="margin-top: 3px;">Summary Alphalist of Withholding Taxes (SAWT)</label></td>
						</tr>
					</table>
				</div>
			</fieldset>
			<fieldset style="width: 333px; height: 165px; float: left;">
				<legend><b>Taxable Period</b></legend>
				<table>
					<tr>
						<td>
							<input type="radio" id="rdoMonth" name="birFreqTagQuery" checked="checked" style="float: left;"/><label for="rdoMonth" style="margin-top: 3px;">Month</label>
						</td>
						<td>
							<select id="selMonth" style="width: 170px; margin-top: 5px;">
								<option value="1">January</option>
								<option value="2">February</option>
								<option value="3">March</option>
								<option value="4">April</option>
								<option value="5">May</option>
								<option value="6">June</option>
								<option value="7">July</option>
								<option value="8">August</option>
								<option value="9">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
						</td>
						<td>
							<input type="text" id="txtMYear" maxlength="4" style="width: 50px; margin-top: 4px; float: left; text-align: right;"/>
							<div style="float: left; width: 15px; margin-top: 2px;">
								<img id="mSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; cursor: pointer;">
								<img id="mSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; display: none;">
								<img id="mSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="mSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>		
						</td>
					</tr>
					<tr>
						<td>
							<input type="radio" id="rdoAnnual" name="birFreqTagQuery" style="float: left;"/><label for="rdoAnnual" style="margin-top: 3px;">Annual</label>
						</td>
						<td>
							<input type="text" id="txtYYear" maxlength="4" style="width: 50px; margin-top: 4px; float: left; text-align: right;"/>
							<div style="float: left; width: 15px; margin-top: 2px;">
								<img id="ySpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; cursor: pointer;">
								<img id="ySpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; display: none;">
								<img id="ySpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="ySpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>		
						</td>
					</tr>
				</table>
				<table width="100%" style="margin-top: 10px;">
					<tr>
						<td class="leftAligned" width="165px">Amended Return</td>
						<td>No. of Sheets Attached</td>
					</tr>
					<tr>
						<td>
							<input type="radio" id="rdoYes" name="amendedRtn" style="float: left;" /><label for="rdoYes" style="margin-top: 3px;">Yes</label> 
							<input type="radio" id="rdoNo" name="amendedRtn" style="float: left; margin-left: 25px;" checked="checked"/><label for="rdoNo" style="margin-top: 3px;">No</label>
						</td>
						<td>
							<input type="text" id="txtNoOfSheets" style="width: 50px; margin-left: 43px; margin-top: 4px; float: left;"/>
							<div style="float: left; width: 15px; margin-top: 2px;">
								<img id="sSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; cursor: pointer;">
								<img id="sSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 3px; margin-top: 2px; display: none;">
								<img id="sSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
								<img id="sSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
							</div>		
						</td>
					</tr>
				</table>
				<div id="sawtFormDiv" style="float: left;">
					<label style="margin-top: 9px; margin-left: 35px;">SAWT Form</label>
					<select id="selSawtForm" style="width: 170px; margin-top: 5px; margin-left: 5px;">
						<option value="1700">1700</option>
						<option value="1701">1701</option>
						<option value="1701Q">1701Q</option>
						<option value="1702">1702</option>
						<option value="1702Q">1702Q</option>
						<option value="2550M">2550M</option>
						<option value="2550Q">2550Q</option>
						<option value="2551M">2551M</option>
						<option value="2553">2553</option>
					</select>
				</div>
			</fieldset>
		</div>
		<fieldset style="margin-left: 5px; width: 676px; height: 242px;">
			<legend><b>BIR Forms</b></legend>
			<div id="BIRAlphalistTGDiv" style="height: 231px; width: 675px; float: left; ">
				
			</div>
		</fieldset>
		<div id="buttonsDiv" style="margin-top: 18px; margin-left: 222px; height: 25px; float: left; ">
			<input type="button" class="button" id="btnExtract" value="Extract" style="width: 120px;"/>
			<input type="button" class="button" id="btnGenerateCSV" value="Generate CSV" style="width: 120px;"/>
		</div>
	</div>
	<div id="hiddenDiv">
		<input type="hidden" id="checkExtract" />
	</div>
</div>
<script type="text/JavaScript">
try{
	setModuleId("GIACS115");
	setDocumentTitle("BIR Relief & Alphalist");
	objGIACS115 = new Object();
	objGIACS115.reportId = "";
	
	function getGiacs115Params(){
		var params = "";
		params = "&repType=" + ($("rdoRelief").checked ? "R" : "A") + "&alpType=" + ($("rdoRelief").checked ? ($("rdoSales").checked ? "S" : "P") : ($("rdoMap").checked ? "E" : "W")) //$("rdoMap").checked ? "E" : "W") edited by MarkS 9.15.2016 SR5632
				 + "&birFreqTagQuery=" + ($("rdoMonth").checked ? "M" : "A");
		return params;
	}
	
	try{
		objGIACS115.objBIRAlphalistTableGrid = JSON.parse('${jsonBIRAlphalist}');
		objGIACS115.objBIRAlphalist = objGIACS115.objBIRAlphalistTableGrid.rows || []; 
		
		var BIRAlphalistModel = {
			url:contextPath+"/GIACGeneralLedgerReportsController?action=showGIACS115&refresh=1"+getGiacs115Params(),
			options:{
				width: '675px',
				height: '207px',
				onCellFocus: function(element, value, x, y, id){
					objGIACS115.reportId = BIRAlphalistTableGrid.geniisysRows[y].reportId;
					
					BIRAlphalistTableGrid.keys.removeFocus(BIRAlphalistTableGrid.keys._nCurrentFocus, true);
					BIRAlphalistTableGrid.keys.releaseKeys();
					
					checkExtractGIACS115();
					toggleGenerateCSV();
				},
				onRemoveRowFocus: function(){
					objGIACS115.reportId = "";
					
					BIRAlphalistTableGrid.keys.removeFocus(BIRAlphalistTableGrid.keys._nCurrentFocus, true);
					BIRAlphalistTableGrid.keys.releaseKeys();
					
					disableButton("btnGenerateCSV");
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						BIRAlphalistTableGrid.keys.removeFocus(BIRAlphalistTableGrid.keys._nCurrentFocus, true);
						BIRAlphalistTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'reportId',
					title: 'Report ID',
					width: '150px',
					visible: true,
					filterOption : true
				},
				{	id: 'reportTitle',
					title: 'Report Title',
					width: '480px',
					visible: true,
					filterOption : true
				},
			],
			rows: objGIACS115.objBIRAlphalist
		};
		BIRAlphalistTableGrid = new MyTableGrid(BIRAlphalistModel);
		BIRAlphalistTableGrid.pager = objGIACS115.objBIRAlphalistTableGrid;
		BIRAlphalistTableGrid.render('BIRAlphalistTGDiv');
		BIRAlphalistTableGrid.afterRender = function(){
			try{
				if(BIRAlphalistTableGrid.geniisysRows.length > 0){			
					$('mtgRow'+BIRAlphalistTableGrid._mtgId+'_0').addClassName('selectedRow');
					objGIACS115.reportId = BIRAlphalistTableGrid.geniisysRows[0].reportId;
					
					checkExtractGIACS115();
					toggleGenerateCSV();
				}
			}catch(e){
				showErrorMessage("BIRAlphalistTableGrid.afterRender", e);
			}
		};
	}catch(e){
		showErrorMessage("BIRAlphalistTableGrid",e);
	}
	
	function checkExtractGIACS115(){
		if(objGIACS115.reportId == ""){
			showMessageBox("Please select a Report.", "I");
		}else{
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=checkExtractGIACS115",{
				parameters : {
					repType : $("rdoRelief").checked ? "R" : "A",
					//alpType : $("rdoMap").checked ? "E" : "W", replaced by robert SR 5473 03.14.16
					alpType : $("rdoRelief").checked ? ($("rdoSales").checked ? "S" : "P") : ($("rdoMap").checked ? "E" : "W"), //$("rdoMap").checked ? "E" : "W",
					birFreqTagQuery : $("rdoMonth").checked ? "M" : "A",
					reportId : objGIACS115.reportId,
					month : $("selMonth").value,
					mYear : $F("txtMYear"), 
					yYear : $F("txtYYear")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					$("checkExtract").value = response.responseText; 
				}
			});
		}
	}
	
	function extractGIACS115(){
		if(objGIACS115.reportId == ""){
			showMessageBox("Please select a Report.", "I");
		}else{
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=extractGIACS115",{
				parameters : {
					repType : $("rdoRelief").checked ? "R" : "A",
					//alpType : $("rdoMap").checked ? "E" : "W", replaced by robert SR 5473 03.14.16
					alpType : $("rdoRelief").checked ? ($("rdoSales").checked ? "S" : "P") : ($("rdoMap").checked ? "E" : "W"), //$("rdoMap").checked ? "E" : "W",
					birFreqTagQuery : $("rdoMonth").checked ? "M" : "A",
					reportId : objGIACS115.reportId,
					month : $("selMonth").value,
					mYear : $F("txtMYear"), 
					yYear : $F("txtYYear")
				},
				onCreate : showNotice("Extracting..."),
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						if(parseFloat(response.responseText) > 0){
							//showMessageBox("Extraction finished.  " +response.responseText + " records extracted.", "I");	replaced by robert SR 5473 03.14.16
							showWaitingMessageBox("Extraction finished.  " +response.responseText + " records extracted.", "I",
									function() {
										enableButton("btnGenerateCSV");
							});
						}else{
							showMessageBox("Extraction finished.  No record extracted.", "I");
						}
						
					}
				}
			});
		}
	}
	
	function setProperty(){
		if($("rdoAlphalist").checked){
			$("rdoAnnual").disabled = false;
			$("rdoYes").disabled = false;
			$("rdoNo").disabled = false;
			$("rlfTypeDiv").hide();
			$("alpTypeDiv").show();
			if($("rdoSawt").checked){
				$("sawtFormDiv").show();	
			}
			$("txtNoOfSheets").disabled = false;
			$("sSpinUp").show();
			$("sSpinUpDisabled").hide();
			$("sSpinDown").show();
			$("sSpinDownDisabled").hide();
			if($("rdoMonth").checked){
				$("selMonth").disabled = false;
				$("txtYYear").disabled = true;
				$("ySpinUp").hide();
				$("ySpinUpDisabled").show();
				$("ySpinDown").hide();
				$("ySpinDownDisabled").show();
				$("txtMYear").disabled = false;
				$("mSpinUp").show();
				$("mSpinUpDisabled").hide();
				$("mSpinDown").show();
				$("mSpinDownDisabled").hide();
			}else{
				$("selMonth").disabled = true;
				$("txtYYear").disabled = false;
				$("ySpinUp").show();
				$("ySpinUpDisabled").hide();
				$("ySpinDown").show();
				$("ySpinDownDisabled").hide();
				$("txtMYear").disabled = true;
				$("mSpinUp").hide();
				$("mSpinUpDisabled").show();
				$("mSpinDown").hide();
				$("mSpinDownDisabled").show();
			}
		}else{
			$("rlfTypeDiv").show();
			$("alpTypeDiv").hide();
			$("rdoAnnual").disabled = true;
			$("txtYYear").disabled = true;
			$("txtNoOfSheets").disabled = true;
			$("rdoYes").disabled = true;
			$("rdoNo").disabled = true;
			$("ySpinUp").hide();
			$("ySpinUpDisabled").show();
			$("ySpinDown").hide();
			$("ySpinDownDisabled").show();
			$("rdoMonth").checked = true;
			$("selMonth").disabled = false;
			$("txtYYear").disabled = true;
			$("ySpinUp").hide();
			$("ySpinUpDisabled").show();
			$("ySpinDown").hide();
			$("ySpinDownDisabled").show();
			$("txtMYear").disabled = false;
			$("mSpinUp").show();
			$("mSpinUpDisabled").hide();
			$("mSpinDown").show();
			$("mSpinDownDisabled").hide();
			$("sSpinUp").hide();
			$("sSpinUpDisabled").show();
			$("sSpinDown").hide();
			$("sSpinDownDisabled").show();
		}
	}
	
	function queryBIRForms(){
		setProperty();
		objGIACS115.reportId = "";
		//added by MarkS 9.25.2016 SR5632 to check if Summary List of Purchases (SLP) is checked and show a message box.
		if($("rdoPurchases").checked && $("rdoRelief").checked){
			showMessageBox("The Report is not yet available in the System", "I");
		}	
		BIRAlphalistTableGrid.url = contextPath+"/GIACGeneralLedgerReportsController?action=showGIACS115&refresh=1"+getGiacs115Params();
		BIRAlphalistTableGrid._refreshList();
		//end sr5632
	}
	
	$("rdoRelief").observe("click", queryBIRForms);
	$("rdoAlphalist").observe("click", queryBIRForms);
	$("rdoSales").observe("click", queryBIRForms); //added by robert SR 5473 03.16.16
	$("rdoPurchases").observe("click", queryBIRForms); //added by robert SR 5473 03.16.16
	$("rdoMap").observe("click", queryBIRForms);
	$("rdoSawt").observe("click", queryBIRForms);
	$("rdoMonth").observe("click", queryBIRForms);
	$("rdoAnnual").observe("click", queryBIRForms);
	
	$("rdoSawt").observe("click", function(){
		$("sawtFormDiv").show();
	});
	
	$("rdoMap").observe("click", function(){
		$("sawtFormDiv").hide();
	});
	
	$("selMonth").observe("change", function(){
		checkExtractGIACS115();
		toggleGenerateCSV();
	});
	
	function toggleGenerateCSV(){
		if($F("checkExtract") == "Y"){
			enableButton("btnGenerateCSV");
		}else{
			disableButton("btnGenerateCSV");
		}
	}
	
	$("mSpinUp").observe("click", function(){
		$("txtMYear").value = parseFloat($("txtMYear").value) + 1;
		if(parseFloat($F("txtMYear")) > 9999){
			$("txtMYear").value = "9999";
		}
		if(objGIACS115.reportId != ""){ //added by robert SR 5473 03.16.16
			checkExtractGIACS115();
			toggleGenerateCSV();
		}
	});
	$("mSpinDown").observe("click", function(){
		$("txtMYear").value = parseFloat($("txtMYear").value) - 1;
		if(parseFloat($F("txtMYear")) < 1990){
			$("txtMYear").value = "1990";
		}
		if(objGIACS115.reportId != ""){ //added by robert SR 5473 03.16.16
			checkExtractGIACS115();
			toggleGenerateCSV();
		}
	});
	var prevMYear = "";
	$("txtMYear").observe("focus", function(){
		prevMYear = $F("txtMYear");
	});
	$("txtMYear").observe("change", function(){
		if(isNaN($F("txtMYear"))){
			customShowMessageBox("Invalid Month Year. Valid value should be from 1990 to 9999.", "I", "txtMYear");
			$("txtMYear").value = prevMYear;
		}
	});
	
	$("ySpinUp").observe("click", function(){
		$("txtYYear").value = parseFloat($("txtYYear").value) + 1;
		if(parseFloat($F("txtYYear")) > 9999){
			$("txtYYear").value = "9999";
		}
		if(objGIACS115.reportId != ""){ //added by robert SR 5473 03.16.16
			checkExtractGIACS115();
			toggleGenerateCSV();
		}
	});
	$("ySpinDown").observe("click", function(){
		$("txtYYear").value = parseFloat($("txtYYear").value) - 1;
		if(parseFloat($F("txtYYear")) < 1990){
			$("txtYYear").value = "1990";
		}
		if(objGIACS115.reportId != ""){ //added by robert SR 5473 03.16.16
			checkExtractGIACS115();
			toggleGenerateCSV();
		}
	});
	var prevYYear = "";
	$("txtYYear").observe("focus", function(){
		prevYYear = $F("txtYYear");
	});
	$("txtYYear").observe("change", function(){
		if(isNaN($F("txtYYear"))){
			customShowMessageBox("Invalid Annual Year. Valid value should be from 1990 to 9999.", "I", "txtYYear");
			$("txtYYear").value = prevYYear;
		}
	});
	
	$("sSpinUp").observe("click", function(){
		$("txtNoOfSheets").value = parseFloat($("txtNoOfSheets").value) + 1;
		if(parseFloat($F("txtNoOfSheets")) > 999){
			$("txtNoOfSheets").value = "999";
		}
	});
	$("sSpinDown").observe("click", function(){
		$("txtNoOfSheets").value = parseFloat($("txtNoOfSheets").value) - 1;
		if(parseFloat($F("txtNoOfSheets")) < 0){
			$("txtNoOfSheets").value = "0";
		}
	});
	var prevNoOfSheets = "";
	$("txtNoOfSheets").observe("focus", function(){
		prevNoOfSheets = $F("txtNoOfSheets");
	});
	$("txtNoOfSheets").observe("change", function(){
		if(isNaN($F("txtNoOfSheets"))){
			customShowMessageBox("Invalid No. of Sheets. Valid value should be from 0 to 999.", "I", "txtNoOfSheets");
			$("txtNoOfSheets").value = prevNoOfSheets;
		}
	});
	
	function whenNewFormInstance(){
		var month;
		
		$("alpTypeDiv").hide();
		$("rdoAnnual").disabled = true;
		$("txtYYear").disabled = true;
		$("txtNoOfSheets").disabled = true;
		$("txtNoOfSheets").value = 0;
		$("rdoYes").disabled = true;
		$("rdoNo").disabled = true;
		$("ySpinUp").hide();
		$("ySpinUpDisabled").show();
		$("ySpinDown").hide();
		$("ySpinDownDisabled").show();
		disableButton("btnGenerateCSV");	
		$("txtYYear").value = new Date().toString('yyyy');
		$("txtMYear").value = new Date().toString('yyyy');
		$("sawtFormDiv").hide();
		month = new Date().getMonth();
		$("selMonth").selectedIndex = month;
	}
	
	$("btnExtract").observe("click", function(){
		checkExtractGIACS115();
		if($F("checkExtract") == "Y"){
			showConfirmBox("", "Data has already been extracted. Do you want to extract it again?", "Yes", "No", extractGIACS115, "", "");
		}else{
			extractGIACS115();
		}
	});
	
	function generateCSVGIACS115(){
		if(objGIACS115.reportId == ""){
			showMessageBox("Please select a Report.", "I");
		}else{
			new Ajax.Request(contextPath+"/GIACGeneralLedgerReportsController?action=generateCSVGIACS115",{
				parameters : {
					reportId : objGIACS115.reportId,
					month : $("selMonth").value,
					mYear : $F("txtMYear"),
					yYear : $F("txtYYear"),
					birFreqTagQuery : $("rdoMonth").checked ? "M" : "A",
					amendedRtn : $("rdoYes").checked ? "Y" : "N",
					noOfSheets : $F("txtNoOfSheets"),
					sawtForm : $F("selSawtForm")
				},
				onCreate : showNotice("Generating CSV..."),
				onComplete : function(response){
					hideNotice("");
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						if($("geniisysAppletUtil") == null || $("geniisysAppletUtil").copyFileToLocal == undefined){
							showMessageBox("Local printer applet is not configured properly. Please verify if you have accepted to run the Geniisys Utility Applet and if the java plugin in your browser is enabled.", imgMessage.ERROR);
						} else {
							var message = $("geniisysAppletUtil").copyFileToLocal(json.csv, "bir_temp");
							if(message.include("SUCCESS")){
								showWaitingMessageBox("Report generated.\n\n" + message.substring(9) + json.csvFileName, "I", function(){
																												generateDATGIACS115(json.dat, json.datFileName);	
																											});	
							} else {
								showMessageBox(message, "E");
							}
							deleteFile(json.csv);
						}
					}
				}
			});
		}
	}
	
	function generateDATGIACS115(url, fileName){
		var message = $("geniisysAppletUtil").copyFileToLocal(url, "bir_temp");
		if(message.include("SUCCESS")){
			showMessageBox("Report generated.\n\n" + message.substring(9)  + fileName, "I");	
		} else {
			showMessageBox(message, "E");
		}
		deleteFile(url);
	}
	
	function deleteFile(url){
		new Ajax.Request(contextPath + "/GIACGeneralLedgerReportsController", {
			parameters : {
				action: "deleteFile",
				url: url
			}
		});
	}
	
	$("btnGenerateCSV").observe("click", generateCSVGIACS115);
	
	whenNewFormInstance();
	observeReloadForm("reloadForm", showGIACS115);
	$("acExit").stopObserving();
	$("acExit").observe("click", function(){
		delete objGIACS115;
		goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
	});
}catch(e){
	showErrorMessage("birAlphalist.jsp",e);
}
</script>