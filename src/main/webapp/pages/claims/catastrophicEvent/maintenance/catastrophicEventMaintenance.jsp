<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div>
	<div id="gicls056MainDiv">	
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Catastrophic Event Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
		   	</div>
		</div>		
		<div class="sectionDiv">
			<div id="catastrophicEventTableDiv" style="padding-top: 10px;">
				<div id="catastrophicEventTable" style="height: 331px; margin-left: 11px;"></div>
			</div>
			<div align="center" id="catastrophicEvent">
				<table style="margin-top: 10px;" ><!-- border="1" cellspacing="0" cellpadding="0"> -->
					<tr>
						<td class="rightAligned">Code</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCatastrophicCd" type="text" style="width: 200px; text-align: right; margin: 0;" readonly="readonly">
							
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Catastrophic Event</td>
						<td class="leftAligned" colspan="3">
							<input id="txtCatastrophicDesc" type="text" class="required" maxlength="50" style="width: 533px; margin: 0;" >
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
								<input type="text" id="txtLineCd" class="allCaps" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="2"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCd" alt="Go" style="float: right;"/>
							</span>
							<input id="txtLineName" type="text" style="width: 427px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Loss Category</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan" style="width: 100px; margin: 0; height: 21px;">
								<input type="text" id="txtLossCatCd" class="allCaps" ignoreDelKey="true" style="width: 75px; float: left; border: none; height: 14px; margin: 0;" lastValidValue="" maxlength="2"/> 
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLossCatCd" alt="Go" style="float: right;"/>
							</span>
							<input id="txtLossCatDes" type="text" style="width: 427px;margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
						</td>
					</tr>	
					<tr>
						<td class="rightAligned">Loss Date From</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0;" class="withIconDiv" id="divFrom">
								<input type="text" id="txtStartDate" class="withIcon" readonly="readonly" style="width: 181px;"/>
								<img id="imgStartDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Start Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
						<td class="rightAligned">Loss Date To</td>
						<td class="leftAligned">
							<div style="float: left; width: 206px; height: 21px; margin: 0; float: right;" class="withIconDiv" id="divFrom">
								<input type="text" removeStyle="true" id="txtEndDate" class="withIcon" readonly="readonly" style="width: 181px;"/>
								<img id="imgEndDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="End Date" style="margin-top: 1px; cursor: pointer;" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Location</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLocation" type="text" style="width: 533px; margin: 0;" maxlength="160">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reserve Amount</td>
						<td class="leftAligned">
							<input id="txtResAmt" type="text" style="width: 200px; margin: 0; text-align: right;" readonly="readonly">
						</td>
						<td class="rightAligned">Paid Amount</td>
						<td class="leftAligned">
							<input id="txtPdAmt" type="text" style="width: 200px; margin: 0; float: right; text-align: right;" readonly="readonly">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 539px; border: 1px solid gray; height: 21px; margin: 0;">
								<textarea style="float: left; height: 15px; width: 513px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" ></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned"><input id="txtUserId" type="text" class="" style="width: 200px; margin: 0;" readonly="readonly" ></td>
						<td width="109px" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 200px; margin: 0; float: right;" readonly="readonly" ></td>
					</tr>			
				</table>
			</div>
			<div style="margin: 15px; text-align: center;">
				<input type="button" class="button" id="btnAdd" value="Add" style="width: 80px; margin-bottom: 5px;" >
				<input type="button" class="button" id="btnDelete" value="Delete" style="width: 80px;">
				<div class="sectionDiv" style="float: none; border-bottom: 0;">
				
				</div>
				<input type="button" class="button" id="btnDetails" value="Details" style="width: 90px; margin-top: 5px;" >
				<input type="button" class="button" id="btnFireDetails" value="Add'l Fire Information" style="width: 150px;" >
				<input type="button" class="button" id="btnPrint" value="Print" style="width: 90px;" >
			</div>
		</div>
		<div class="buttonsDiv">
			<input type="button" class="button" id="btnCancel" value="Cancel" style="width: 90px;">
			<input type="button" class="button" id="btnSave" value="Save" style="width: 90px;">
		</div>
	</div>
	
	<!-- Details -->
	<div id="gicls056DetailsDiv" style="display: none;">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExitDetails">Exit</a></li>
				</ul>
			</div>
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Details</label>
		   	</div>
		</div>
		<div class="sectionDiv">
			<div>
				<table align="center" style="margin: 10px auto;">
					<tr>
						<td style="text-align: right; padding-right: 5px;">Catastrophic Event</td>
						<td>
							<input type="text" id="txtCatastrophicCd2" style="width: 100px; text-align: right;" readonly="readonly"/>
							<input type="text" id="txtCatastrophicDesc2" style="width: 400px;" readonly="readonly"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv" style="margin-top: 1px;">
			<div id="detailsTableDiv" style="padding-top: 35px;">
				<div id="detailsTable" style="height: 249px; margin-left: 11px;"></div>
			</div>
			<div>
				<table style="margin-left: 25px; margin-top: -20px; float: left;" border="0">
					<tr>
						<td>
							<input type="checkbox" id="chkRemoveAll" style="float: left; margin-left: 15px;" />
							<label for="chkRemoveAll" style="margin-left: 5px;">Remove All</label>
						</td>
					</tr>
					<tr>
						<td><input type="button" class="button" id="btnRemoveFromList" value="Remove from List" style="margin-top: 5px;"/></td>
					</tr>
					<tr>
						<td><input type="button" class="button" id="btnShowList" value="Show List" style="margin-top: 3px; width: 100%;"/></td>
					</tr>
				</table>
				<fieldset style="float: right; margin-top: -20px; margin-bottom: 20px; padding: 0 10px 10px 10px; margin-right: 97px;">
					<legend><b>Totals</b></legend>
					<table align="center">
						<tr height="30px;">
							<th colspan="2">Reserve Amount</th>
							<th colspan="2">Paid Amount</th>
						</tr>
						<tr>
							<td style="text-align: right; padding-right: 5px;">Net Retention</td>
							<td><input type="text" id="txtTotResNetRet" style="margin: 0; text-align: right;" readonly="readonly"/></td>
							<td style="text-align: right; padding-right: 5px;">Net Retention</td>
							<td><input type="text" id="txtTotPdNetRet" style="margin: 0; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="text-align: right; padding-right: 5px;">Proportional Treaty</td>
							<td><input type="text" id="txtTotResPropTrty" style="margin: 0; text-align: right;" readonly="readonly"/></td>
							<td style="text-align: right; padding-right: 5px; width: 170px;">Proportional Treaty</td>
							<td><input type="text" id="txtTotPdPropTrty" style="margin: 0; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="text-align: right; padding-right: 5px;">Non-Proportional Treaty</td>
							<td><input type="text" id="txtTotResNonPropTrty" style="margin: 0; text-align: right;" readonly="readonly"/></td>
							<td style="text-align: right; padding-right: 5px;">Non-Proportional Treaty</td>
							<td><input type="text" id="txtTotPdNonPropTrty" style="margin: 0; text-align: right;" readonly="readonly"/></td>
						</tr>
						<tr>
							<td style="text-align: right; padding-right: 5px;">Facultative</td>
							<td><input type="text" id="txtTotResFacul" style="margin: 0; text-align: right;" readonly="readonly"/></td>
							<td style="text-align: right; padding-right: 5px;">Facultative</td>
							<td><input type="text" id="txtTotPdFacul" style="margin: 0; text-align: right;" readonly="readonly"/></td>
						</tr>
					</table>
				</fieldset>
				<table align="center" style="margin: 10px auto; clear: both;">
					<tr>
						<td style="text-align: right; padding-right: 5px;">Policy Number</td>
						<td><input type="text" id="txtPolicyNo" style="width: 300px; margin: 0;" readonly="readonly"/></td>
						<td style="text-align: right; padding-right: 5px;">Loss Reserve</td>
						<td><input type="text" id="txtLossReserve" style="width: 150px; margin: 0; text-align: right;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="text-align: right; padding-right: 5px;">Assured</td>
						<td><input type="text" id="txtAssured" style="width: 300px; margin: 0;" readonly="readonly"/></td>
						<td style="text-align: right; padding-right: 5px;">Losses Paid</td>
						<td><input type="text" id="txtLossesPaid" style="width: 150px; margin: 0; text-align: right;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="text-align: right; padding-right: 5px;">Processor</td>
						<td><input type="text" id="txtProcessor" style="width: 300px; margin: 0;" readonly="readonly"/></td>
						<td style="text-align: right; padding-right: 5px;">Expense Reserve</td>
						<td><input type="text" id="txtExpenseReserve" style="width: 150px; margin: 0; text-align: right;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="text-align: right; padding-right: 5px;">Status</td>
						<td><input type="text" id="txtStatus" style="width: 300px; margin: 0;" readonly="readonly"/></td>
						<td style="text-align: right; padding-right: 5px;">Expenses Paid</td>
						<td style="width: 150px;"><input type="text" id="txtExpensesPaid" style="width: 150px; margin: 0;  text-align: right;" readonly="readonly"/></td>
					</tr>
					<tr>
						<td style="text-align: right; padding-right: 5px;">Location</td>
						<td colspan="3"><input type="text" id="txtLocation2" style="width: 600px; margin: 0;" readonly="readonly"/></td>
					</tr>
				</table>
			</div>
		</div>
		<div style="margin-bottom: 50px; text-align: center;">
			<input type="button" class="button" value="Return" id="btnReturnDetails" style="margin: 10px auto 0; width: 80px;"/>
		</div>
	</div>
</div>

<script type="text/javascript">	
	setModuleId("GICLS056");
	setDocumentTitle("Catastrophic Event Maintenance");
	initializeAll();
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	objDetails = new Object();
	objFireDetails = new Object();
	
	function saveGicls056(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgCatastrophicEvent.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgCatastrophicEvent.geniisysRows);
		
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController", {
			method: "POST",
			parameters : {action : "saveGicls056",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGicls056.exitPage != null) {
							objGicls056.exitPage();
						} else {
							tbgCatastrophicEvent._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	observeReloadForm("reloadForm", showGICLS056);
	
	//var objGicls056 = {};
	objGicls056 = new Object();
	var objCatastrophicEvent = null;
	objGicls056.catastrophicEventList = JSON.parse('${jsonCatastrophicEvent}');
	objGicls056.exitPage = null;
	
	var catastrophicEventTable = {
			id: "tbgMain",
			url : contextPath + "/GICLCatastrophicEventController?action=showGICLS056&refresh=1",
			options : {
				width : 900,
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCatastrophicEvent = tbgCatastrophicEvent.geniisysRows[y];
					setFieldValues(objCatastrophicEvent);
					tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
					tbgCatastrophicEvent.keys.releaseKeys();
					$("txtCatastrophicDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
					tbgCatastrophicEvent.keys.releaseKeys();
					$("txtCatastrophicCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
						tbgCatastrophicEvent.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
					tbgCatastrophicEvent.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
					tbgCatastrophicEvent.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValues(null);
					tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
					tbgCatastrophicEvent.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "catCd catDesc",
					title: "Catastrophic Event",
					children: [
						{
							id : "catCd",
							title : "Catastrophic Cd",
							filterOption : true,
							filterOptionType : "integerNoNegative",
							width : 60,
							align: "right",
							renderer: function(val){
								return val == "" ? "" : formatNumberDigits(val, 5);
							}
						},
						{
							id : "catDesc",
							title : "Catastrophic Desc",
							filterOption : true,
							width : 218
						}
					]
				},
				{
					id: "lineCd lineName",
					title: "Line",
					children: [
						{
							id: "lineCd",
							title: "Line Cd",
							width: 50,
							filterOption: true
						},
						{
							id: "lineName",
							title: "Line Name",
							width: 133,
							filterOption: true
						}
					]
				},
				{
					id: "lossCatCd lossCatDes",
					title: "Loss Category",
					children: [
						{
							id: "lossCatCd",
							title: "Loss Cat Cd",
							width: 50,
							filterOption: true
						},
						{
							id: "lossCatDes",
							title: "Loss Cat Desc",
							width: 150,
							filterOption: true
						}
					]
				},
				{
					id: "startDate",
					title: "Loss Date From",
					width: 100,
					align: "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : "formattedDate",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				},
				{
					id: "endDate",
					title: "Loss Date To",
					width: 100,
					align: "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : "formattedDate",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				}
			],
			rows : objGicls056.catastrophicEventList.rows
		};

		tbgCatastrophicEvent = new MyTableGrid(catastrophicEventTable);
		tbgCatastrophicEvent.pager = objGicls056.catastrophicEventList;
		tbgCatastrophicEvent.render("catastrophicEventTable");
	
	function setFieldValues(rec){
		try{
			objFireDetails = new Object();
			
			objGicls056.catCd = (rec == null ? "" : rec.catCd);
			$("txtCatastrophicCd").value = (rec == null ? "" : formatNumberDigits(rec.catCd, 5));
			$("txtCatastrophicCd").setAttribute("lastValidValue", (rec == null ? "" : formatNumberDigits(rec.catCd, 5)));
			$("txtCatastrophicDesc").value = (rec == null ? "" : unescapeHTML2(rec.catDesc));
			
			$("txtLineCd").value = (rec == null ? "" : rec.lineCd);
			$("txtLineCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lineCd));
			$("txtLineName").value = (rec == null ? "" : unescapeHTML2(rec.lineName));
			$("txtLineName").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lineName)));			
			
			$("txtLossCatCd").value = (rec == null ? "" : rec.lossCatCd);
			$("txtLossCatCd").setAttribute("lastValidValue", (rec == null ? "" : rec.lossCatCd));
			$("txtLossCatDes").value = (rec == null ? "" : unescapeHTML2(rec.lossCatDes));
			$("txtLossCatDes").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.lossCatDes)));
			
			$("txtStartDate").value = (rec == null ? "" : (rec.startDate == null || rec.startDate == "" ? "" : dateFormat(rec.startDate, "mm-dd-yyyy")));
			$("txtEndDate").value = (rec == null ? "" : (rec.endDate == null || rec.endDate == "" ? "" : dateFormat(rec.endDate, "mm-dd-yyyy")));
			$("txtLocation").value = (rec == null ? "" : unescapeHTML2(rec.location));
			$("txtResAmt").value = (rec == null ? "0.00" : formatCurrency(rec.resAmt));
			$("txtPdAmt").value = (rec == null ? "0.00" : formatCurrency(rec.pdAmt));
			
			$("txtCatastrophicCd").value = $("txtCatastrophicCd").value == "00000" ? "" : $("txtCatastrophicCd").value;
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			//rec == null ? $("txtCatastrophicCd").readOnly = false : $("txtCatastrophicCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
						
			if(rec == null){
				disableButton("btnFireDetails");
				disableButton("btnDetails");
				disableButton("btnPrint");
				
				$("txtCatastrophicDesc").readOnly = false;
				$("txtLineCd").readOnly = false;
				$("txtLossCatCd").readOnly = false;
				observeBackSpaceOnDate("txtStartDate");
				observeBackSpaceOnDate("txtEndDate");
				$("txtLocation").readOnly = false;
				
				enableSearch("imgLineCd");
				enableSearch("imgLossCatCd");
				
				enableDate("imgStartDate");
				enableDate("imgEndDate");
			} else {
				
				if($("txtCatastrophicCd").value != ""){
					enableButton("btnDetails");
					
					$("txtCatastrophicDesc").readOnly = true;
					$("txtLineCd").readOnly = true;
					$("txtLossCatCd").readOnly = true;
					$("txtLocation").readOnly = true;
					
					disableSearch("imgLineCd");
					disableSearch("imgLossCatCd");
					
					disableDate("imgStartDate");
					disableDate("imgEndDate");
					
					if(rec.printSw == "Y")
						enableButton("btnPrint");
					else
						disableButton("btnPrint");
				} else {
					disableButton("btnDetails");
					disableButton("btnPrint");
					
					$("txtCatastrophicDesc").readOnly = false;
					$("txtLineCd").readOnly = false;
					$("txtLossCatCd").readOnly = false;
					observeBackSpaceOnDate("txtStartDate");
					observeBackSpaceOnDate("txtEndDate");
					$("txtLocation").readOnly = false;
					
					enableSearch("imgLineCd");
					enableSearch("imgLossCatCd");
					
					enableDate("imgStartDate");
					enableDate("imgEndDate");
				}
				
				if(rec.lineCd == "FI"){
					objFireDetails.provinceCd = rec.provinceCd;
					objFireDetails.provinceDesc = rec.provinceDesc;
					objFireDetails.cityCd = rec.cityCd;
					objFireDetails.city = rec.city;
					objFireDetails.districtNo = rec.districtNo;
					objFireDetails.districtDesc = rec.districtDesc;
					objFireDetails.blockNo = rec.blockNo;
					objFireDetails.blockDesc = rec.blockDesc;
					enableButton("btnFireDetails");
				} else {
					disableButton("btnFireDetails");
				}
				
				objDetails = new Object();
				objDetails.districtNo = rec.districtNo == "" ? "" : rec.districtNo;
				objDetails.blockNo = rec.blockNo == null ? "" : rec.blockNo;
			}
			
			objCatastrophicEvent = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.catCd = $F("txtCatastrophicCd");
			obj.catDesc = escapeHTML2($F("txtCatastrophicDesc"));
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.lineName = escapeHTML2($F("txtLineName"));
			obj.lossCatCd = escapeHTML2($F("txtLossCatCd"));
			obj.lossCatDes = escapeHTML2($F("txtLossCatDes"));
			obj.startDate = $F("txtStartDate");
			obj.endDate = $F("txtEndDate");
			obj.location = escapeHTML2($F("txtLocation"));
			obj.resAmt = unformatCurrencyValue($F("txtResAmt"));
			obj.pdAmt = unformatCurrencyValue($F("txtPdAmt"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			
			obj.provinceCd = objFireDetails.provinceCd;
			obj.provinceDesc = escapeHTML2(objFireDetails.provinceDesc);
			obj.cityCd = objFireDetails.cityCd;
			obj.city = escapeHTML2(objFireDetails.city);
			obj.districtNo = objFireDetails.districtNo;
			obj.districtDesc = escapeHTML2(objFireDetails.districtDesc);
			obj.blockNo = objFireDetails.blockNo;
			obj.blockDesc = escapeHTML2(objFireDetails.blockDesc);
			
			obj.userId = userId;
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveGicls056;
			var dept = setRec(objCatastrophicEvent);
			if($F("btnAdd") == "Add"){
				tbgCatastrophicEvent.addBottomRow(dept);
			} else {
				tbgCatastrophicEvent.updateVisibleRowOnly(dept, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgCatastrophicEvent.keys.removeFocus(tbgCatastrophicEvent.keys._nCurrentFocus, true);
			tbgCatastrophicEvent.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	/* function valAddRec(){
		if($F("txtCatastrophicDesc").trim() == ""){
			$("txtCatastrophicDesc").clear();
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtCatastrophicDesc");
			return false;
		}
		
		if($F("txtLineCd").trim() == "" && $F("txtLossCatCd").trim() == "" && $F("txtStartDate").trim() == ""
				&& $F("txtEndDate").trim() == "" && $F("txtLocation").trim() == ""){
			showMessageBox("Please enter at least one detail for catastrophic event (Line, Loss Category, Loss Date or Location).");
			return false;
		}
		
		if($F("txtStartDate") == "" && $F("txtEndDate") != ""){
			customShowMessageBox("Please enter Loss Date From", "I", "txtStartDate");
			return false;
		}
		
		if($F("txtStartDate") != "" && $F("txtEndDate") == ""){
			customShowMessageBox("Please enter Loss Date To", "I", "txtEndDate");
			return false;
		}
		
		addRec();
	} */
	
	function valAddRec(){
		
		if($F("txtCatastrophicDesc").trim() == ""){
			$("txtCatastrophicDesc").clear();
			customShowMessageBox(objCommonMessage.REQUIRED, "I", "txtCatastrophicDesc");
			return false;
		}
		
		if($F("txtLineCd").trim() == "" && $F("txtLossCatCd").trim() == "" && $F("txtStartDate").trim() == ""
				&& $F("txtEndDate").trim() == "" && $F("txtLocation").trim() == ""){
			showMessageBox("Please enter at least one detail for catastrophic event (Line, Loss Category, Loss Date or Location).");
			return false;
		}
		
		if($F("txtStartDate") == "" && $F("txtEndDate") != ""){
			customShowMessageBox("Please enter Loss Date From", "I", "txtStartDate");
			return false;
		}
		
		if($F("txtStartDate") != "" && $F("txtEndDate") == ""){
			customShowMessageBox("Please enter Loss Date To", "I", "txtEndDate");
			return false;
		}
		
		try{
			if($F("btnAdd") == "Add") {
				
				var addedSameExists = false;
				var deletedSameExists = false;	
				
				for(var i=0; i<tbgCatastrophicEvent.geniisysRows.length; i++){
					
					if(tbgCatastrophicEvent.geniisysRows[i].recordStatus == 0 || tbgCatastrophicEvent.geniisysRows[i].recordStatus == 1){
						
						if(tbgCatastrophicEvent.geniisysRows[i].catDesc == $F("txtCatastrophicDesc")){
							addedSameExists = true;	
						}	
						
					} else if(tbgCatastrophicEvent.geniisysRows[i].recordStatus == -1){
						
						if(tbgCatastrophicEvent.geniisysRows[i].catDesc == $F("txtCatastrophicDesc")){
							deletedSameExists = true;
						}
					}
				}
				
				if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
					showMessageBox("Record already exists with the same catastrophic_desc.", "E");
					return;
				} else if(deletedSameExists && !addedSameExists){
					addRec();
					return;
				}					
				
				new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
					parameters : {action : "gicls056ValAddRec",
								  catDesc : $F("txtCatastrophicDesc")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				});
				
			} else {
				
				var updatedSameExists = false;
				var deletedSameExists = false;	
				
				for(var i=0; i<tbgCatastrophicEvent.geniisysRows.length; i++){
					
					if(tbgCatastrophicEvent.geniisysRows[i].recordStatus == 0 || tbgCatastrophicEvent.geniisysRows[i].recordStatus == 1){
						
						if(tbgCatastrophicEvent.geniisysRows[i].catDesc == $F("txtCatastrophicDesc")){								
								if( removeLeadingZero(tbgCatastrophicEvent.geniisysRows[i].catCd) != removeLeadingZero($F("txtCatastrophicCd")))
									updatedSameExists = true;	
						}	
						
					} else if(tbgCatastrophicEvent.geniisysRows[i].recordStatus == -1){
						
						if(tbgCatastrophicEvent.geniisysRows[i].catDesc == $F("txtCatastrophicDesc")){
							deletedSameExists = true;
						}
					}
				}
				
				if((updatedSameExists && !deletedSameExists) || (deletedSameExists && updatedSameExists)){
					showMessageBox("Record already exists with the same catastrophic_desc.", "E");
					return;
				} else if(deletedSameExists && !updatedSameExists){
					addRec();
					return;
				}
				
				new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
					parameters : {action : "gicls056ValAddRec",
								  catCd : removeLeadingZero($F("txtCatastrophicCd")),
								  catDesc : $F("txtCatastrophicDesc")},
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							addRec();
						}
					}
				});
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGicls056;
		objCatastrophicEvent.recordStatus = -1;
		tbgCatastrophicEvent.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
				parameters : {action : "gicls056ValDelete",
							  catCd : removeLeadingZero($F("txtCatastrophicCd"))},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						if(response.responseText == "Y"){
							showConfirmBox("Confirmation", "There are detail records under the catastrophic event that you are about delete. Do you want to continue?", "Yes", "No", 
									deleteRec, null, null);
						}else{
							deleteRec();
						}
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
	}	
	
	function cancelGicls056(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGicls056.exitPage = exitPage;
						saveGicls056();
					}, function(){
						goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", null);
		}
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtCatastrophicDesc").observe("keyup", function(){
		$("txtCatastrophicDesc").value = $F("txtCatastrophicDesc").toUpperCase();
	});
	
	$("txtLocation").observe("keyup", function(){
		$("txtLocation").value = $F("txtLocation").toUpperCase();
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGicls056);
	$("btnCancel").observe("click", cancelGicls056);
	$("btnAdd").observe("click", valAddRec);
	//$("btnAdd").observe("click", addRec);
	$("btnDelete").observe("click", valDeleteRec);
	
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtCatastrophicCd").focus();
	
	function showGicls056FireDetails(){
		try {
			overlayFireInfo = 
				Overlay.show(contextPath+"/GICLCatastrophicEventController", {
					urlContent: true,
					urlParameters: {action : "showGicls056FireDetails",																
									ajax : "1"
					},
				    title: "Fire Details",
				    height: 164,
				    width: 500,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("showGicls056FireDetails" , e);
			}
	}
	
	$("btnFireDetails").observe("click", showGicls056FireDetails);
	
	function setDetailsField (rec) {
		try {
			if(rec != null) {
				$("txtPolicyNo").value = rec.policyNo;
				$("txtLossReserve").value = formatCurrency(rec.lossResAmt);
				$("txtAssured").value =  unescapeHTML2(rec.assdName);
				$("txtLossesPaid").value = formatCurrency(rec.lossPdAmt);
				$("txtProcessor").value = rec.inHouAdj;
				$("txtExpenseReserve").value = formatCurrency(rec.expResAmt);
				$("txtStatus").value = rec.clmStat;
				$("txtExpensesPaid").value = formatCurrency(rec.expPdAmt);
				$("txtLocation2").value = unescapeHTML2(rec.location);
			} else {
				$("txtPolicyNo").clear();
				$("txtLossReserve").clear();
				$("txtAssured").clear();
				$("txtLossesPaid").clear();
				$("txtProcessor").clear();
				$("txtExpenseReserve").clear();
				$("txtStatus").clear();
				$("txtExpensesPaid").clear();
				$("txtLocation2").clear();
			}
		} catch (e) {
			showErrorMessage("setDetailsField", e);
		}
		
	}
	
	/* var objGicls056Details = {};
	var objCatastrophicEventDetails = null;
	objGicls056Details.detailList = JSON.parse('${jsonCatastrophicEventDetails}');
	objGicls056Details.exitPage = null; */
	
	var detailsTable = {};
	
	detailsTable = {
			id : "tbgDetails",
			url : contextPath + "/GICLCatastrophicEventController?action=showGicls056Details&refresh=1&catCd=" + removeLeadingZero($F("txtCatastrophicCd2"))
			+ "&districtNo=" + objDetails.districtNo + "&blockNo=" + objDetails.blockNo,
			options : {
				width : 900,
				//hideColumnChildTitle: true,
				validateChangesOnPrePager: false,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					setDetailsField(tbgdetails.geniisysRows[y]);
					tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
					tbgdetails.keys.releaseKeys();
					//$("txtCatastrophicDesc").focus();
				},
				onRemoveRowFocus : function(){
					setDetailsField(null);
					tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
					tbgdetails.keys.releaseKeys();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						//rowIndex = -1;
						//setFieldValues(null);
						tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
						tbgdetails.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					/* if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} */
				},
				onSort: function(){
					//rowIndex = -1;
					setDetailsField(null);
					//$("chkRemoveAll").checked = false;
					tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
					tbgdetails.keys.releaseKeys();
				},
				onRefresh: function(){
					//rowIndex = -1;
					//checkedClaims = [];
					setDetailsField(null);
					//$("chkRemoveAll").checked = false;
					tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
					tbgdetails.keys.releaseKeys();
				},				
				prePager: function(){
					/* if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					} */
					//rowIndex = -1;
					//setFieldValues(null);
					setDetailsField(null);
					//$("chkRemoveAll").checked = false;
					tbgdetails.keys.removeFocus(tbgdetails.keys._nCurrentFocus, true);
					tbgdetails.keys.releaseKeys();
				}/* ,
				checkChanges: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag == 1 ? true : false);
				} */
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "C",
					title: "C",
					width: 25,
					editable: true,
					sortable: false,
					editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
						if (value){
							return"Y";
						}else{
							return"N";
						}
					}})
				},
				{
					id : "claimNo",
					title: "Claim Number",
					width: 170,
					filterOption: true
				},
				{
					id: "lossCat",
					title: "Loss Category",
					width: 150,
					filterOption: true
				},
				{
					id: "lossDate",
					title: "Loss Date",
					width: 100,
					align: "center",
					titleAlign : "center",
					filterOption : true,
					filterOptionType : "formattedDate",
					renderer: function(val){
						return val == "" ? "" : dateFormat(val, "mm-dd-yyyy");
					}
				},
				{
					id: "netResAmt trtyResAmt npTrtyResAmt faculResAmt",
					title : "<label style='margin-left: 150px;'>Reserve Amount</label>",
					altTitle : "Reserve Amount",
					titleAlign: "center",
					children: [
						{
							id: "netResAmt",
							title: "Net Retention",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "trtyResAmt",
							title: "Prop. Treaty",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "npTrtyResAmt",
							title: "Non-Prop. Treaty",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "faculResAmt",
							title: "Facultative",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},           
					]
				},
				{
					id: "netPdAmt trtyPdAmt npTrtyPdAmt faculPdAmt",
					title : "<label style='margin-left: 150px;'>Paid Amount</label>",
					altTitle : "Paid Amount",
					titleAlign : "center",
					children: [
						{
							id: "netPdAmt",
							title: "Net Retention",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "trtyPdAmt",
							title: "Prop. Treaty",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "npTrtyPdAmt",
							title: "Non-Prop. Treaty",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						},
						{
							id: "faculPdAmt",
							title: "Facultative",
							width: 100,
							align: "right",
							titleAlign : "right",
							geniisysClass : "money"
						}        
		            ]
				}									
			],
			rows : []//objGicls056Details.detailList.rows
		};

		tbgdetails = new MyTableGrid(detailsTable);
		tbgdetails.pager = [];//objGicls056Details.detailList;
		tbgdetails.render("detailsTable");
		/* tbgdetails.afterRender = function(){
			if(tbgdetails.geniisysRows.length <= 0)
				return;
			
			if($("chkRemoveAll").checked){
				for(var x = 0; x < tbgdetails.geniisysRows.length; x++){
					$("mtgInputtbgDetails_2," + x).checked = true;
				}
			}
			
			$$("div#myTableGridtbgDetails .mtgInputCheckbox").each(
				function(obj){
					obj.observe("click", function(){
						var index = this.id.substring(this.id.length - 1);
						var claimId = tbgdetails.geniisysRows[index].claimId;
						
						if(this.checked){
							checkedClaims.push(claimId);
						} else {
							for(var x = 0; x < checkedClaims.length; x++){
								if(claimId == checkedClaims[x]){
									checkedClaims.splice(x, 1);
									break;
								}
							}
						}
						
						$("chkRemoveAll").checked = false;
					}
				);
			});
					
			for(var x = 0; x < tbgdetails.geniisysRows.length; x++){
				for(var y = 0; y < checkedClaims.length; y++){
					if(tbgdetails.geniisysRows[x].claimId == checkedClaims[y]){
						$("mtgInputtbgDetails_2," + x).checked = true;
						break;
					}
				}
			}
			
		}; */
		
		var checkedClaims = [];
		
	function getDetailsTotal(){
		new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
			parameters : {
				action : "getGicls056DetailsTotal",
				catCd : removeLeadingZero($F("txtCatastrophicCd2")),
				districtNo : objDetails.districtNo,
				blockNo : objDetails.blockNo
				},
			onCreate: showNotice("Getting totals, please wait..."),				
			onComplete: function(response){
				hideNotice();
				if (checkErrorOnResponse(response)){
					var rec = JSON.parse(response.responseText);
					
					$("txtTotResNetRet").value = formatCurrency(rec.totNetResAmt);
					$("txtTotResPropTrty").value = formatCurrency(rec.totTrtyResAmt);
					$("txtTotResNonPropTrty").value = formatCurrency(rec.totNpTrtyResAmt);
					$("txtTotResFacul").value = formatCurrency(rec.totFaculResAmt);
					$("txtTotPdNetRet").value = formatCurrency(rec.totNetPdAmt);
					$("txtTotPdPropTrty").value = formatCurrency(rec.totTrtyPdAmt);
					$("txtTotPdNonPropTrty").value = formatCurrency(rec.totNpTrtyPdAmt);
					$("txtTotPdFacul").value = formatCurrency(rec.totaculPdAmt);
				}
			}
		});
	}		
	
	function setDetailTotals(){
		try{
			if(tbgdetails.geniisysRows.length > 0) {
				var rec = tbgdetails.geniisysRows[0];
				$("txtTotResNetRet").value = formatCurrency(rec.totNetResAmt);
				$("txtTotResPropTrty").value = formatCurrency(rec.totTrtyResAmt);
				$("txtTotResNonPropTrty").value = formatCurrency(rec.totNpTrtyResAmt);
				$("txtTotResFacul").value = formatCurrency(rec.totFaculResAmt);
				$("txtTotPdNetRet").value = formatCurrency(rec.totNetPdAmt);
				$("txtTotPdPropTrty").value = formatCurrency(rec.totTrtyPdAmt);
				$("txtTotPdNonPropTrty").value = formatCurrency(rec.totNpTrtyPdAmt);
				$("txtTotPdFacul").value = formatCurrency(rec.totFaculPdAmt);
				$("chkRemoveAll").disabled = false;
			} else {
				$("txtTotResNetRet").clear();
				$("txtTotResPropTrty").clear();
				$("txtTotResNonPropTrty").clear();
				$("txtTotResFacul").clear();
				$("txtTotPdNetRet").clear();
				$("txtTotPdPropTrty").clear();
				$("txtTotPdNonPropTrty").clear();
				$("txtTotPdFacul").clear();
				$("chkRemoveAll").disabled = true;
			}
		} catch (e) {
			showErrorMessage("tbgDetails", e);
		}
	}
	
	function showDetails(){
		try {
			$("txtCatastrophicCd2").value = $F("txtCatastrophicCd");
			$("txtCatastrophicDesc2").value = $F("txtCatastrophicDesc");
			
			$("txtTotResNetRet").clear();
			$("txtTotResPropTrty").clear();
			$("txtTotResNonPropTrty").clear();
			$("txtTotResFacul").clear();
			$("txtTotPdNetRet").clear();
			$("txtTotPdPropTrty").clear();
			$("txtTotPdNonPropTrty").clear();
			$("txtTotPdFacul").clear();
			
			$("gicls056MainDiv").hide();
			$("gicls056DetailsDiv").show();
			
			$("chkRemoveAll").checked = false;
			
			tbgdetails.render("detailsTable");
			
			tbgdetails.url = contextPath + "/GICLCatastrophicEventController?action=showGicls056Details&refresh=1&catCd=" + removeLeadingZero($F("txtCatastrophicCd2"))
			+ "&districtNo=" + objDetails.districtNo + "&blockNo=" + objDetails.blockNo;
			tbgdetails._refreshList();
			
			setDetailTotals();
			
			$("mtgRefreshBtntbgDetails").stopObserving();
			
			$("mtgRefreshBtntbgDetails").observe("click", function(){
				checkedClaims = [];
				tbgdetails._refreshList();
			});
			
			checkedClaims = [];
			
			tbgdetails.afterRender = function(){
				if(tbgdetails.geniisysRows.length <= 0)
					return;
				
				if($("chkRemoveAll").checked){
					for(var x = 0; x < tbgdetails.geniisysRows.length; x++){
						$("mtgInputtbgDetails_2," + x).checked = true;
					}
				}
				
				$$("div#myTableGridtbgDetails .mtgInputCheckbox").each(
					function(obj){
						obj.observe("click", function(){
							var index = this.id.substring(this.id.length - 1);
							var claimId = tbgdetails.geniisysRows[index].claimId;
							
							if(this.checked){
								checkedClaims.push(claimId);
							} else {
								for(var x = 0; x < checkedClaims.length; x++){
									if(claimId == checkedClaims[x]){
										checkedClaims.splice(x, 1);
										break;
									}
								}
							}
							
							$("chkRemoveAll").checked = false;
						}
					);
				});
						
				for(var x = 0; x < tbgdetails.geniisysRows.length; x++){
					for(var y = 0; y < checkedClaims.length; y++){
						if(tbgdetails.geniisysRows[x].claimId == checkedClaims[y]){
							$("mtgInputtbgDetails_2," + x).checked = true;
							break;
						}
					}
				}
				
			};
			
		} catch (e) {
			showErrorMessage("showDetails", e);
		}
	}
	
	function hideDetails(){
		$("gicls056DetailsDiv").hide();
		$("gicls056MainDiv").show();
		
		tbgdetails = new MyTableGrid(detailsTable);
		tbgdetails.pager = [];//objGicls056Details.detailList;
		tbgdetails.render("detailsTable");
	}
	
	$("btnDetails").observe("click", showDetails);
	
	$("btnExitDetails").observe("click", hideDetails);
	
	$("btnReturnDetails").observe("click", function(){
		getDspAmt();
		
		$("btnExitDetails").click();
	});
	
	function showClaimList (searchType) {
		try {
			overlayClaimList = 
				Overlay.show(contextPath+"/GICLCatastrophicEventController", {
					urlContent: true,
					urlParameters: {
						action : "showGicls056ClaimList",
						lossCatCd : objClaimListParams.lossCatCd,
						startDate : objClaimListParams.startDate,
						endDate : objClaimListParams.endDate,
						location : objClaimListParams.location,
						provinceCd : objClaimListParams.provinceCd,
						cityCd : objClaimListParams.cityCd,
						districtNo : objClaimListParams.districtNo,
						blockNo : objClaimListParams.blockNo,
						searchType : objClaimListParams.searchType,
						lineCd : objClaimListParams.lineCd, 	
						ajax : "1"
					},
				    title: "Claim list valid for Catastrophic Event",
				    height: 410,
				    width: 800,
				    draggable: true
				});
		} catch (e) {
			showErrorMessage("showClaimList" , e);
		}
	}
	
	$("btnShowList").observe("click", function(){
		objClaimListParams = new Object();
		
		objClaimListParams.lossCatCd = $F("txtLossCatCd");
		objClaimListParams.startDate = $F("txtStartDate");
		objClaimListParams.endDate	= $F("txtEndDate");
		objClaimListParams.location = $F("txtLocation");
		objClaimListParams.provinceCd = objFireDetails.provinceCd;
		objClaimListParams.cityCd = objFireDetails.cityCd;
		objClaimListParams.districtNo = objFireDetails.districtNo;
		objClaimListParams.blockNo = objFireDetails.blockNo;
		objClaimListParams.lineCd = $F("txtLineCd");
		
		showConfirmBox4("Match Details", "Would you like to query all claims that match the information you previously entered?", "Yes", "At least one", "Cancel",
				function(){
				showNotice("Fetching claims, please wait...");
				objClaimListParams.searchType = "all";
				showClaimList();
			}, function(){
				showNotice("Fetching claims, please wait...");
				objClaimListParams.searchType = "atLeastOne";
				showClaimList();
			}, function(){
				delete objClaimListParams;
			}, null);
	});
	
	function getRecordsToBeRemoved(objArray) {
		var tempObjArray = new Array();
		
		if(objArray != null){
			for (var i = 0; i<objArray.length; i++){
				if($("mtgInput"+tbgdetails._mtgId+"_2,"+i).checked){
					tempObjArray.push(objArray[i]);
				}		
			}
		}			
		return tempObjArray;
	}
	
	function removeFromList(){
		var objParams = new Object();
		objParams.setRows = getRecordsToBeRemoved(tbgdetails.geniisysRows);
		
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
			method: "POST",
			parameters: {
					     action : "gicls056UpdateDetails",
					     objParams : JSON.stringify(objParams),
					     pAction : "REMOVE",
					     checkedClaims : checkedClaims.toString()
					     
					     
			},
			asynchronous: false,
			onCreate : function(){
				showNotice("Removing records, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					tbgdetails._refreshList();
					setDetailTotals();
					checkedClaims = [];
				}
			}
		});
	}
	
	function removeAllFromList(){
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
			method: "POST",
			parameters: {
					     action : "gicls056RemoveAll",
					     catCd : removeLeadingZero($F("txtCatastrophicCd"))					     
			},
			asynchronous: false,
			onCreate : function(){
				showNotice("Removing records, please wait...");
			},
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					tbgdetails._refreshList();
					setDetailTotals();
					$("chkRemoveAll").checked = false;
					checkedClaims = [];
				}
			}
		});
	}
	
	function checkTaggedDetails(){
		/* var x = false;
		for(var i = 0; i < tbgdetails.geniisysRows.length; i++){
			if($("mtgInput"+tbgdetails._mtgId+"_2,"+i).checked) {
				x = true;
				break;
			}				
		}
		return x; */
		if(checkedClaims.length > 0)
			return true;
		else if ($("chkRemoveAll").checked)
			return true;
		else
			return false;
	}
	
	$("btnRemoveFromList").observe("click", function(){
		if(checkTaggedDetails()){
			showConfirmBox("Confirmation", "Are you sure you want to remove the record/s you checked?", "Yes", "No", function(){
				
				if($("chkRemoveAll").checked)
					removeAllFromList();
				else
					removeFromList();
				
			}, null, null);	
		} else {
			showMessageBox("Please check at least one record.");
			return;	
		}
		
	});
	
	function getLineLOV() {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getGicls056LineLOV",
				filterText : ($F("txtLineCd") == $("txtLineCd").readAttribute("lastValidValue") ? "" : $F("txtLineCd")),
				page : 1,
				moduleId : "GICLS056"
			},
			title : "List of Lines",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "lineCd",
				title : "Line Code",
				width : '120px',
			}, {
				id : "lineName",
				title : "Line Name",
				width : 345
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtLineCd") == $("txtLineCd").readAttribute("lastValidValue") ? "" : $F("txtLineCd")),
			onSelect : function(row) {
				
				if($("txtLineCd").readAttribute("lastValidValue") != unescapeHTML2(row.lineCd)){
					$("txtLossCatCd").clear();
					$("txtLossCatDes").clear();
					$("txtLossCatCd").setAttribute("lastValidValue", "");
					$("txtLossCatDes").setAttribute("lastValidValue", "");
				}
				
				$("txtLineCd").value = unescapeHTML2(row.lineCd);
				$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
				$("txtLineName").value = unescapeHTML2(row.lineName);
				$("txtLineName").setAttribute("lastValidValue", $F("txtLineName"));
				
				if(row.lineCd == "FI"){
					enableButton("btnFireDetails");
				} else {
					disableButton("btnFireDetails");
					objFireDetails = new Object();	
				}
			},
			onCancel : function () {
				$("txtLineCd").value = nvl($("txtLineCd").readAttribute("lastValidValue"), "");
				$("txtLineName").value = nvl($("txtLineName").readAttribute("lastValidValue"), "");
				$("txtLineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				$("txtLineCd").value = nvl($("txtLineCd").readAttribute("lastValidValue"), "");
				$("txtLineName").value = nvl($("txtLineName").readAttribute("lastValidValue"), "");
				$("txtLineCd").focus();
			}
		});
	}
	
	$("imgLineCd").observe("click", getLineLOV);
	
	function getLossCatLov() {
		LOV.show({
			controller : "ClaimsLOVController",
			urlParameters : {
				action : "getGicls056LossCatLov",
				lineCd : $("txtLineCd").value,
				filterText : ($F("txtLossCatCd") == $("txtLossCatCd").readAttribute("lastValidValue") ? "" : $F("txtLossCatCd")),
				page : 1,
				moduleId : "GICLS056"
			},
			title : "List of Loss Categories",
			width : 480,
			height : 386,
			columnModel : [ {
				id : "lossCatCd",
				title : "Code",
				width : '120px',
			}, {
				id : "lossCatDes",
				title : "Description",
				width : 345
			} ],
			draggable : true,
			autoSelectOneRecord: true,
			filterText:  ($F("txtLossCatCd") == $("txtLossCatCd").readAttribute("lastValidValue") ? "" : $F("txtLossCatCd")),
			onSelect : function(row) {
				$("txtLossCatCd").value = unescapeHTML2(row.lossCatCd);
				$("txtLossCatDes").value = unescapeHTML2(row.lossCatDes);
				$("txtLossCatCd").setAttribute("lastValidValue", $F("txtLossCatCd"));
				$("txtLossCatDes").setAttribute("lastValidValue", $F("txtLossCatDes"));
			},
			onCancel : function () {
				$("txtLossCatCd").value = nvl($("txtLossCatCd").readAttribute("lastValidValue"), "");
				$("txtLossCatDes").value = nvl($("txtLossCatDes").readAttribute("lastValidValue"), "");
				$("txtLossCatCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLossCatCd");
				$("txtLossCatCd").value = nvl($("txtLossCatCd").readAttribute("lastValidValue"), "");
				$("txtLossCatDes").value = nvl($("txtLossCatDes").readAttribute("lastValidValue"), "");
				$("txtLossCatCd").focus();				
			}
		});
	}
	
	$("imgLossCatCd").observe("click", getLossCatLov);
	
	$("imgStartDate").observe("click", function() {
		if ($("imgStartDate").disabled == true)
			return;
		scwShow($("txtStartDate"), this, null);
	});
	
	$("imgEndDate").observe("click", function() {
		if ($("imgEndDate").disabled == true)
			return;
		scwShow($("txtEndDate"), this, null);
	});
	
	$("txtStartDate").observe("focus", function(){
		if($F("txtStartDate") != ""){
			if($F("txtEndDate") == "")
				$("txtEndDate").value = $F("txtStartDate");
		}		
	});
	
	observeBackSpaceOnDate("txtStartDate");
	observeBackSpaceOnDate("txtEndDate");
	
	
	$("txtEndDate").observe("focus", function(){
		if ($("imgEndDate").disabled == true) return;
		var endDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g,"/")) : "";
		var startDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g,"/")) : "";
		
		if (endDate < startDate && endDate != ""){
			customShowMessageBox("Loss Date From should not be later than Loss Date To.", "I", "txtEndDate");
			$("txtEndDate").clear();
			return false;
		}
		
	});
	
	$("txtStartDate").observe("focus", function(){
		if ($("imgEndDate").disabled == true) return;
		var endDate = $F("txtEndDate") != "" ? new Date($F("txtEndDate").replace(/-/g,"/")) : "";
		var startDate = $F("txtStartDate") != "" ? new Date($F("txtStartDate").replace(/-/g,"/")) : "";
		
		if (endDate < startDate && endDate != ""){
			customShowMessageBox("Loss Date From should not be later than Loss Date To.", "I", "txtStartDate");
			$("txtStartDate").clear();
			return false;
		}
		
	});
	
	$("chkRemoveAll").observe("click", function(){
		
		if(this.checked)
			getClaimNos();
		else
			checkedClaims = [];
		
		for(var i = 0; i < tbgdetails.geniisysRows.length; i++){
			$("mtgInput"+tbgdetails._mtgId+"_2,"+i).checked = this.checked;				
		}
	});
	
	/* $("txtLineCd").observe("keypress", function(event){
		if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "");
			
			$("txtLossCatCd").clear();
			$("txtLossCatDes").clear();
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDes").setAttribute("lastValidValue", "");
		}
	}); */
	
	$("txtLineCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtLineCd").clear();
			$("txtLineName").clear();
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").setAttribute("lastValidValue", "");
			disableButton("btnFireDetails");
			objFireDetails = new Object();
			
			$("txtLossCatCd").clear();
			$("txtLossCatDes").clear();
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDes").setAttribute("lastValidValue", "");
		} else
			getLineLOV();
	});
	
	/* $("txtLossCatCd").observe("keypress", function(event){
		if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
			$("txtLossCatDes").clear();
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDes").setAttribute("lastValidValue", "");
		}
	}); */
	
	$("txtLossCatCd").observe("change", function(){
		if(this.value.trim() == ""){
			$("txtLossCatCd").clear();
			$("txtLossCatDes").clear();
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDes").setAttribute("lastValidValue", "");
		} else
			getLossCatLov();
	});
	
	function printReport(){
		try {
			var content = contextPath + "/PrintCatastrophicEventReportController?action=printReport"
					                  + "&reportId=GICLR056"
					                  + "&catCd=" + objGicls056.catCd
					                  + "&noOfCopies=" + $F("txtNoOfCopies")
					                  + "&printerName=" + $F("selPrinter")
					                  + "&destination=" + $F("selDestination");
			
			if("screen" == $F("selDestination")){
				showPdfReport(content, "Claim Listing per Catastrophic Event");
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					parameters : {noOfCopies : $F("txtNoOfCopies")},
					onCreate: showNotice("Processing, please wait..."),				
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							showMessageBox("Printing Completed.", "S");
						}
					}
				});
			}else if("file" == $F("selDestination")){
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
			showErrorMessage("printReport", e);
		}
	}
	
	$("btnPrint").observe("click", function(){
		 showGenericPrintDialog("Print Claim Listing per Catastrophic Event", printReport, null, true);
	});	
	
	setFieldValues(null);
	
	function getClaimNos(){		
		new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
			method: "POST",
			parameters:{
				action     : "gicls056GetClaimNos",
				catCd : removeLeadingZero($F("txtCatastrophicCd2")),
				districtNo : objDetails.districtNo,
				blockNo : objDetails.blockNo
			},
			asynchronous: false,
			onCreate: function(){
				showNotice("Loading, please wait...");
			},
			onComplete: function(response){
				hideNotice();					
				if(checkErrorOnResponse(response)) {
					var temp = response.responseText.trim();
					var claimNos = new Array();
					if(temp != ""){
						temp = temp.substring(0, temp.length - 1);
						claimNos = temp.split(",");
					}
					checkedClaims = claimNos;					
				}
			}
		});
	}
	
	function getDspAmt(){
		new Ajax.Request(contextPath + "/GICLCatastrophicEventController", {
			parameters : {
				action : "gicls056GetDspAmt",
			  	catCd : removeLeadingZero($F("txtCatastrophicCd"))
		  	},
			onCreate : showNotice("Processing, please wait..."),
			onComplete : function(response){
				hideNotice();
				if(checkErrorOnResponse(response)){
					var res = JSON.parse(response.responseText);
					$("txtResAmt").value = formatCurrency(res.resAmt);
					$("txtPdAmt").value = formatCurrency(res.pdAmt);
					res.exists == "Y" ? enableButton("btnPrint") : disableButton("btnPrint");
					tbgCatastrophicEvent.geniisysRows[rowIndex].resAmt = res.resAmt;
					tbgCatastrophicEvent.geniisysRows[rowIndex].pdAmt = res.pdAmt;					
					tbgCatastrophicEvent.geniisysRows[rowIndex].printSw = (res.exists, "N"); 
				}
			}
		});
	}
</script>