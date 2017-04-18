<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="polListingPerPlateNoMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Policy Listing per Plate No</label>
		</div>
	</div>
	
	<div id="plateNoFieldsDiv" class="sectionDiv" style="width: 100%; height: 136px;">
		<div>
			<table id="plateNoTbl" style="width: 480px; margin: 6px 5px 5px 80px; float: left;">
				<tr>
					<td>Plate No.</td>
					<td>
						<div id="plateNoDiv" class="required" style="border: 1px solid gray; width: 410px; height: 20px; float: left;">
							<input id="txtPlateNo" name="txtPlateNo" class="leftAligned allCaps required" type="text" maxlength="10" style="border: none; float: left; width: 380px; height: 13px; margin: 0px;" value="" tabindex="101"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPlateNo" alt="Go" style="float: right;"/>
						</div>
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<fieldset style="height: 70px; width: 395px; margin-bottom: 2px;">
							<legend>Search By</legend>
							<table style="margin: 2px 0 0 20px;">
								<tr>
									<td>
										<input id="inceptDateRB" name="dateTypeRG" type="radio" value="1" style="margin: 2px 5px 4px 5px; float: left;" checked="checked">
										<label for="inceptDateRB" style="margin: 2px 0 4px 0">Incept Date</label>
									</td>
									<td>
										<input id="effDateRB" name="dateTypeRG" type="radio" value="2" style="margin: 2px 5px 4px 25px; float: left;" >
										<label for="effDateRB" style="margin: 2px 0 4px 0">Effectivity Date</label>
									</td>
									<td>
										<input id="issueDateRB" name="dateTypeRG" type="radio" value="3" style="margin: 2px 5px 4px 25px; float: left;" >
										<label for="issueDateRB" style="margin: 2px 0 4px 0">Issue Date</label>
									</td>
								</tr>
								<tr>
									<td style="padding: 3px 7px 0 0;">Crediting Branch</td>
									<td><input id="txtCredBranch" type="text" class="allCaps" maxlength="2" style="width: 100px;" tabindex="102"/></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
		
		<div id="plateDatesDiv" class="sectionDiv" style="width: 250px; height: 100px;  margin: 10px 5px 5px 40px;">
			<table style="margin: 5px 0 0 10px;">
				<tr>
					<td class="rightAligned" style="padding-right: 13px;">
						<input id="asOfRB" name="plateDateRG" type="radio" value="1" style="margin: 2px 5px 4px 5px; float: left;" checked="checked">
						<label for="asOfRB" style="margin: 2px 0 4px 0">As Of</label>
					</td>
					<td>
						<div id="asOfDateDiv" class="withIcon required" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
							<input id="txtAsOfDate" name="txtAsOfDate" readonly="readonly" type="text" class="withIcon disableDelKey required" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value=""  tabindex="103"/>
							<img id="imgAsOfDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAsOfDate'),this, null);"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input id="fromRB" name="plateDateRG" type="radio" value="2" style="margin: 2px 5px 4px 5px; float: left;">
						<label for="fromRB" style="margin: 2px 0 4px 0">From</label>
					</td>
					<td>
						<div id="fromDateDiv" class="withIcon" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
							<input id="txtFromDate" name="txtFromDate" readonly="readonly" type="text" class="withIcon disableDelKey" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="104"/>
							<img id="imgFromDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<label style="margin: 2px 0 4px 38px;">To</label>
					</td>
					<td>
						<div id="toDateDiv" class="withIcon" style="float: left; border: 1px solid gray; width: 145px; height: 20px;">
							<input id="txtToDate" name="txtToDate" readonly="readonly" type="text" class="withIcon disableDelKey" maxlength="10" style="border: none; float: left; width: 120px; height: 13px; margin: 0px;" value="" tabindex="105"/>
							<img id="imgToDate" alt="Date" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onclick="scwShow($('txtToDate'),this, null);"/>
						</div>
					</td>
				</tr>
			</table>
		</div>		
	</div>
	
	<div id="itemPolbasicDiv" class="sectionDiv" style="width: 100%; height: 580px;">
		
		<div id="vehicleItemTGDiv" style="width: 900px; height: 336px; margin: 10px 10px 0px 10px;"></div>
		
		<div id="totalsDiv" style="width: 920px;">
			<table style="margin-left: 610px">
				<tr>
					<td style="padding-right: 7px;">Totals</td>
					<td>
						<input id="txtSumTsiAmt" type="text" readonly="readonly" class="rightAligned" style="width: 116px;">
						<input id="txtSumPremAmt" type="text" readonly="readonly" class="rightAligned" style="width: 116px;">
					</td>
				</tr>
			</table> 
		</div>
		
		<div id="polbasicFieldsDiv" class="sectionDiv" style="width: 900px; height: 150px; margin: 10px 10px 0px 10px;">
			<table style="margin: 10px 0 0 110px;">
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Policy No.</td>
					<td colspan="3"><input id="txtPolicyNo" type="text" readonly="readonly" style="width: 600px;"> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Assured</td>
					<td colspan="3"><input id="txtAssdName" type="text" readonly="readonly" style="width: 600px;"> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Inception Date</td>
					<td><input id="txtInceptDate" type="text" readonly="readonly" style="width: 190px;"> </td>
					<td class="rightAligned" style="padding: 0 5px 0 130px;">Expiry Date</td>
					<td><input id="txtExpiryDate" type="text" readonly="readonly" style="width: 190px;"> </td>
				</tr>
				<tr>
					<td class="rightAligned" style="padding-right: 5px;">Effectivity Date</td>
					<td><input id="txtEffDate" type="text" readonly="readonly" style="width: 190px;"> </td>
					<td class="rightAligned" style="padding: 0 5px 0 130px;">Issue Date</td>
					<td><input id="txtIssueDate" type="text" readonly="readonly" style="width: 190px;"> </td>
				</tr>
			</table>
		</div>
		
		<div class="buttonsDiv">
			<input id="btnPrint" type="button" class="button" value="Print Report" style="width: 100px;">
		</div>
		
	</div>

</div>

<script type="text/javascript">
try{
	setModuleId("GIPIS193");
	setDocumentTitle("Policy Listing Per Plate No.");
	initializeAll();
	
	$("txtPlateNo").focus();
	$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
	disableToolbarButton("btnToolbarEnterQuery");
	disableToolbarButton("btnToolbarExecuteQuery");
	disableToolbarButton("btnToolbarPrint");
	
	disableDate("imgFromDate");
	disableDate("imgToDate");
	disableButton("btnPrint");
	
	var dateTypeRB = "1";
	
	var selectedRowInfo = null;
	var selectedIndex = null;
	
	var objVehicleItem = new Object();
	objVehicleItem.tablegrid = JSON.parse('${vehicleItemGrid}'.replace(/\\/g, '\\\\'));
	objVehicleItem.objRows = objVehicleItem.tablegrid || [];
	objVehicleItem.objList = [];
	
	try{
		var vItemTableModel = {
			url: contextPath+"/GIPIVehicleController?action=showGIPIS193PolListing&refresh=1",
			options:{
				width: "900px",
				height: "306px",
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = vehicleItemTG.geniisysRows[y];
					selectedIndex = y;
					populateItemPolbasicFields(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					vehicleItemTG.keys.releaseKeys();
					selectedRowInfo = null;
					selectedIndex = null;
					populateItemPolbasicFields(null);
				},
				onSort: function(){
					vehicleItemTG.onRemoveRowFocus();
				},
				onRefresh: function(){
					vehicleItemTG.onRemoveRowFocus();
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						vehicleItemTG.onRemoveRowFocus();
					}
				}
			},
			columnModel: [
				{
					id: 'recordStatus',
					width: '0px',
					visible: false,
					editor: 'checkbox'
				},
				{
					id: 'divCtrId',
					width: '0px',
					visible: false
				},		
				{
					id: 'policyId',
					width: '0px',
					visible: false
				},
				{
					id: 'plateNo',
					width: '0px',
					visible: false
				},
				{
					id: 'credBranch',
					width: '0px',
					visible: false
				},		
				{
					id: 'policyNo',
					width: '0px',
					visible: false
				},
				{
					id: 'assdNo',
					width: '0px',
					visible: false
				},
				{
					id: 'assdName',
					width: '0px',
					visible: false
				},		
				{
					id: 'inceptDate',
					width: '0px',
					visible: false
				},
				{
					id: 'expiryDate',
					width: '0px',
					visible: false
				},
				{
					id: 'effDate',
					width: '0px',
					visible: false
				},  
				{
					id: 'issueDate',
					width: '0px',
					visible: false
				},  	
				{
					id: 'itemNo',
					title: 'Item No.',
					titleAlign: 'right',
					align: 'right',
					width: '70px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'number'
				},  	
				{
					id: 'itemTitle',
					title: 'Item Title',
					width: '250px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'make',
					title: 'Make',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'motorNo',
					title: 'Motor No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'serialNo',
					title: 'Serial No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'tsiAmt',
					title: 'TSI Amount',
					titleAlign: 'right',
					align: 'right',
					width: '120px',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				},  	
				{
					id: 'premAmt',
					title: 'Premium Amount',
					titleAlign: 'right',
					align: 'right',
					width: '120px',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				}	              
			],
			rows: objVehicleItem.objRows
		};
		
		vehicleItemTG = new MyTableGrid(vItemTableModel);
		vehicleItemTG.pager = objVehicleItem.tablegrid;
		vehicleItemTG.render('vehicleItemTGDiv');
		vehicleItemTG.afterRender = function(){
			objVehicleItem.objList = vehicleItemTG.geniisysRows;
		};
	}catch(e){
		showErrorMessage("Vehicle Item tablegrid error", e);
	}
	
	function populateItemPolbasicFields(row){
		try{
			row == null ? $("txtPolicyNo").clear() : $("txtPolicyNo").value = unescapeHTML2(row.policyNo);
			row == null ? $("txtAssdName").clear() : $("txtAssdName").value = unescapeHTML2(row.assdName);
			row == null ? $("txtInceptDate").clear() : $("txtInceptDate").value = dateFormat(row.inceptDate, 'mm-dd-yyyy');
			row == null ? $("txtExpiryDate").clear() : $("txtExpiryDate").value = dateFormat(row.expiryDate, 'mm-dd-yyyy');
			row == null ? $("txtEffDate").clear() : $("txtEffDate").value = dateFormat(row.effDate, 'mm-dd-yyyy');
			row == null ? $("txtIssueDate").clear() : $("txtIssueDate").value = dateFormat(row.issueDate, 'mm-dd-yyyy');
			/*row == null ? disableButton("btnPrint") : enableButton("btnPrint");
			row == null ? disableToolbarButton("btnToolbarPrint") : enableToolbarButton("btnToolbarPrint");*/
		}catch(e){
			showErrorMessage("populateItemPolbasicFields", e);
		}
	}
	
	function togglePlateFields(enable){
		try{
			if(enable){
				$("txtPlateNo").readOnly = false;
				$("txtPlateNo").clear();
				enableSearch("searchPlateNo");
				$("txtCredBranch").readOnly = false;
				$("txtCredBranch").clear();				
				
				$$("input[name='dateTypeRG']").each(function(rb){
					rb.disabled = false;
				});
				$$("input[name='plateDateRG']").each(function(rb){
					rb.disabled = false;
				});
				$$("div#plateDatesDiv input[type='text']").each(function(txt){
					$(txt).clear();
				});
				$$("div#plateDatesDiv img").each(function(img){
					enableDate(img);
				});
				
				$("txtPlateNo").focus();
				
				$("asOfRB").checked = true;
				fireEvent($("asOfRB"), "click");
				enableDate("imgAsOfDate");
				$("imgFromDate").hide();
				$("imgToDate").hide();
				$("fromDateDiv").setStyle({backgroundColor: 'white'});	
				$("toDateDiv").setStyle({backgroundColor: 'white'});				
			}else{
				$("txtPlateNo").readOnly = true;
				disableSearch("searchPlateNo");
				$("txtCredBranch").readOnly = true;				
				
				$$("input[name='dateTypeRG']").each(function(rb){
					rb.disabled = true;
				});
				$$("input[name='plateDateRG']").each(function(rb){
					rb.disabled = true;
				});
				$$("div#plateDatesDiv img").each(function(img){
					disableDate(img);
				});
			}
		}catch(e){
			showErrorMessage("togglePlateFields", e);
		}
	}
	
	function showPlateNoLOV(){
		try{
			var searchString = $F("txtPlateNo").trim() == "" ? "%" : unescapeHTML2($F("txtPlateNo"));
			
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {
					action:			"getGipis193PlateNoLOV",
					searchString:	searchString
				},
				title: "Plate Number",
				width: 500,
				height: 386,
				draggable: true,
				autoSelectOneRecord: true,
				filterText: searchString,
				columnModel: [
					{
						id: 'plateNo',
						title: 'Plate No.',
						width: 487,
						filterOption: true
					}              
				],
				onSelect: function(row){
					$("txtPlateNo").value = unescapeHTML2(row.plateNo);
					$("txtPlateNo").focus();
					//enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel: function(){
					$("txtPlateNo").focus();
				},
				onUndefinedRow: function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPlateNo");
				}
			});
		}catch(e){
			showErrorMessage("showPlateNoLOV", e);
		}
	}
	
	function getVehicleItemTotals(){
		try{
			new Ajax.Request(contextPath+"/GIPIVehicleController", {
				method: "POST",
				parameters: {
					action:			"getGipis193VehicleItemTotals",
					plateNo:		$F("txtPlateNo").replace(/'/g, "''"),
					credBranch:		$F("txtCredBranch").replace(/'/g, "''"),
					dateType:		dateTypeRB,
					asofDate:		$F("txtAsOfDate"),
					fromDate:		$F("txtFromDate"),
					toDate:			$F("txtToDate")
				},
				evalScripts: true,
				asynchronous: false,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						$("txtSumTsiAmt").value = formatCurrency(json.sumTsiAmt);
						$("txtSumPremAmt").value = formatCurrency(json.sumPremAmt);
					}
				}
			});
		}catch(e){
			showErrorMessage("getVehicleItemTotals", e);
		}
	}
	
	$("imgFromDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtFromDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtFromDate"),this, null);
	});
	
	$("imgToDate").observe("click", function(){
		scwNextAction = function(){
							checkInputDates("txtToDate", "txtFromDate", "txtToDate");
						}.runsAfterSCW(this, null);
						
		scwShow($("txtToDate"),this, null);
	});
	
	
	$("searchPlateNo").observe("click", showPlateNoLOV);
	
	$("txtPlateNo").observe("change", function(){
		if (this.value != ""){
			var searchString = $F("txtPlateNo").trim() == "" ? "%" : unescapeHTML2($F("txtPlateNo"));
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis193PlateNoLOV", searchString, "Searching Plate No, please wait...");
			
			if (cond == 0 || cond == 2){
				showPlateNoLOV();
			}
		}
	});
	
	
	$$("div#plateNoFieldsDiv input[type='text']").each(
			function(obj){
				obj.observe("keypress", function(event){
					if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
						if(this.readOnly)
							return;
						
						enableToolbarButton("btnToolbarExecuteQuery");
						//enableToolbarButton("btnToolbarEnterQuery");
					}
				});
			}		
		);
	
	$("txtFromDate").observe("blur", function(){
		if (this.value != "" && $F("txtToDate") != ""){			
			checkInputDates(this.id, this.id, "txtToDate");
		}
	});
	
	$("txtToDate").observe("blur", function(){
		if (this.value != "" && $F("txtFromDate") != ""){				
			checkInputDates(this.id, "txtFromDate", this.id);
		}
	});
	
	/*$$("div#plateDatesDiv img").each(function(img){
		img.observe("click", function(){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		});
	});*/
	
	$$("input[name='plateDateRG']").each(function(rb){
		rb.observe("click", function(){
			if (rb.value == 1){		//as of
				$("txtAsOfDate").value = dateFormat(new Date(), "mm-dd-yyyy");
				$("txtAsOfDate").addClassName("required");
				$("asOfDateDiv").setStyle({backgroundColor: '#FFFACD'});	
				enableDate("imgAsOfDate");
				$("txtFromDate").clear();
				$("txtFromDate").removeClassName("required");
				$("fromDateDiv").setStyle({backgroundColor: 'white'});	
				disableDate("imgFromDate");
				$("txtToDate").clear();
				$("txtToDate").removeClassName("required");
				$("toDateDiv").setStyle({backgroundColor: 'white'});	
				disableDate("imgToDate");
			}else if(rb.value == 2){	//from
				$("txtFromDate").addClassName("required");
				$("fromDateDiv").setStyle({backgroundColor: '#FFFACD'});	
				enableDate("imgFromDate");
				$("txtToDate").addClassName("required");
				$("toDateDiv").setStyle({backgroundColor: '#FFFACD'});		
				enableDate("imgToDate");
				$("txtAsOfDate").clear();
				$("txtAsOfDate").removeClassName("required");
				$("asOfDateDiv").removeClassName("required");
				$("asOfDateDiv").setStyle({backgroundColor: 'white'});	
				disableDate("imgAsOfDate");
			}
		});	
	});
	
	$$("input[name='dateTypeRG']").each(function(rb){
		rb.observe("click", function(){
			dateTypeRB = rb.value;
		});
	});
	
	//added here by Alejandro Burgos 02.04.2016
	function showPrintDialog(){
		vehicleItemTG.keys.releaseKeys();
		showGenericPrintDialog("Policy Listing per Plate No.", printReport, "", true);
		$("csvOptionDiv").show();
	}
	
	$("btnPrint").observe("click", showPrintDialog);
	$("btnToolbarPrint").observe("click", showPrintDialog);
	
	function printReport(){
		try {
			
			var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR193&reportId=GIPIR193"
									 +"&plateNo="+$F("txtPlateNo").replace(/'/g, "''")+"&credBranch="+$F("txtCredBranch").replace(/'/g, "''")
									 +"&dateType="+dateTypeRB+"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");;
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Policy Listing per Plate No.");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies"),
								  printerName : $F("selPrinter")
								 },
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing complete.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
			var fileType = "PDF";
		
			if($("rdoPdf").checked)
				fileType = "PDF";
			else if ($("rdoCsv").checked)
				fileType = "CSV"; 
			
			
			new Ajax.Request(content, {
				method: "POST",
				parameters : {destination : "file",
							  fileType    : fileType},
				evalScripts: true,
				asynchronous: true,
				onCreate: showNotice("Generating report, please wait..."),
				onComplete: function(response){
					hideNotice();
					if (checkErrorOnResponse(response)){
						if (fileType == "CSV"){ 
							copyFileToLocal(response, "csv");
							deleteCSVFileFromServer(response.responseText);
						} else 
							copyFileToLocal(response);
					}
				}
			});
			
			}else if("local" == $F("selDestination")){
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
			}
			
		} catch (e){
			showErrorMessage("GIACS108 printReport", e);
		}
	}
	//ended here by Alejandro Burgos 02.04.2016
	
	//comment out by Alejandro Burgos 02.04.2016
	/*
	$("btnPrint").observe("click", function(){
		vehicleItemTG.keys.releaseKeys();
		showGenericPrintDialog("Print Policy Listing Per Plate No.", 
				function(){
					var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
					
					var content = contextPath+"/PolicyInquiryPrintController?action=printGIPIR193&reportId=GIPIR193&reportTitle=Policy Listing Per Plate No."
									+"&plateNo="+$F("txtPlateNo")+"&fileType="+fileType+"&noOfCopies="+$F("txtNoOfCopies")+"&printerName="+$F("selPrinter")
									+"&destination="+$F("selDestination");
					
					printGenericReport(content, "Policy Listing Per Plate No.");
				}, 
				null, 
				true);
	});
	
	$("btnToolbarPrint").observe("click", function(){
		fireEvent($("btnPrint"), "click");
	});
	*/
	//end comment
	
	$("btnToolbarEnterQuery").observe("click", function(){
		vehicleItemTG.onRemoveRowFocus();
		togglePlateFields(true);
		disableToolbarButton(this.id);
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarPrint");
		disableButton("btnPrint");
		populateItemPolbasicFields(null);
		getVehicleItemTotals();
		vehicleItemTG.url = contextPath+"/GIPIVehicleController?action=showGIPIS193PolListing&refresh=1";
		vehicleItemTG._refreshList();
	});
	
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv('plateNoFieldsDiv')){
			togglePlateFields(false);
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarPrint");
			enableButton("btnPrint");
			vehicleItemTG.url = contextPath+"/GIPIVehicleController?action=showGIPIS193PolListing&refresh=1"
								+"&plateNo="+$F("txtPlateNo").replace(/'/g, "''")+"&credBranch="+$F("txtCredBranch").replace(/'/g, "''")
								+"&dateType="+dateTypeRB+"&asOfDate="+$F("txtAsOfDate")+"&fromDate="+$F("txtFromDate")+"&toDate="+$F("txtToDate");
			vehicleItemTG._refreshList();
			
			getVehicleItemTotals();
			
			if (objVehicleItem.objList.length == 0){
				showMessageBox("Query caused no records to be retrieved. Re-enter.");
			}
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		vehicleItemTG.onRemoveRowFocus();
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null); 
	});
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>