<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss039MainDiv" name="giiss039MainDiv" style="">
	<div id="vesselTableGridDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="menuFileMaintenanceExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Vessel Maintenance</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadFormVessel" name="reloadFormVessel">Reload Form</label>
			</span>
	   	</div>
	</div>	
	<div id="giiss039" name="giiss039">		
		<div class="sectionDiv">
			<div id="vesselTableDiv" style="padding-top: 10px;">
				<div id="vesselTable" style="height: 290px; margin-left: 27px;"></div>
			</div>
			<div align="center" id="vesselFormDiv">
				<table style="margin-top: 25px;">
					<tr>	
						<td></td>					
						<td>
							<input id="chkHullSw" type="checkbox" style="float: left; margin: 0 7px 0 5px;"><label for="chkHullSw" style="margin: 0 4px 2px 2px;">Marine Hull ?</label>								
							<input id="chkPropelSw" type="checkbox" style="float: left; margin: 0 7px 0 50px;"><label for="chkPropelSw" style="margin: 0 4px 2px 2px;">With Propeller</label>						
						</td>
						<td colspan="2"></td>
					</tr>
					<tr>
						<td class="rightAligned">Vessel Code</td>
						<td class="leftAligned">
							<input id="txtVesselCd" type="text" class="required allCaps" style="width: 250px;" tabindex="201" maxlength="6">
						</td>
						<td class="rightAligned">Vessel Type</td>
						<td class="leftAligned">
							<input type="hidden" id="hidVestypeCd">
							<div id="vestypeDescDiv" class="required allCaps" style="width: 255px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtVestypeDesc" name="txtVestypeDesc" type="text" maxlength="30" class="required" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" tabindex="217" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchVestypeLOV" alt="Go" style="float: right;" tabindex="218"/>							
							</div>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Vessel Name</td>
						<td class="leftAligned">
							<input id="txtVesselName" type="text" class="required allCaps" style="width: 250px;" tabindex="202" maxlength="30">
						</td>
						<td class="rightAligned">Vessel Class</td>
						<td class="leftAligned">
							<input type="hidden" id="hidVessClassCd">
							<div id="vessClassDescDiv" class="required allCaps" style="width: 255px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtVessClassDesc" name="txtVessClassDesc" type="text" maxlength="20" class="required" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" tabindex="219" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchVessClassLOV" alt="Go" style="float: right;" tabindex="220"/>							
							</div>
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Old Name</td>
						<td class="leftAligned">
							<input id="txtVesselOldName" type="text" class="allCaps" style="width: 250px;" tabindex="203" maxlength="30">
						</td>
						<td class="rightAligned">Hull Type</td>
						<td class="leftAligned">
							<input type="hidden" id="hidHullTypeCd">
							<div id="hullTypeDescDiv" class="required allCaps" style="width: 255px; height: 20px; border: solid gray 1px; float: left;">
								<input id="txtHullTypeDesc" name="txtHullTypeDesc" type="text" maxlength="20" class="required" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" tabindex="221" />
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchHullTypeLOV" alt="Go" style="float: right;" tabindex="222"/>							
							</div>
						</td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Registered Owner</td>
						<td class="leftAligned" colspan="3">
							<input id="txtRegOwner" type="text" maxlength="50" style="width: 655px;" tabindex="204">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Registered Place</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtRegPlace" type="text" class="" style="width: 250px;" maxlength="30" tabindex="205"></td>
						<td width="" class="rightAligned" >Gross Tonnage</td>
						<td class="leftAligned"><input id="txtGrossTon" type="text" class="applyDecimal" regExpPatt="pDeci1002" style="width: 250px;" tabindex="223" customLabel="Gross Tonnage" min="0" max="99999999.99"></td>
					</tr>						
					<tr>
						<td class="rightAligned">Year Built</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtYearBuilt" type="text" class="integerNoNegativeUnformattedNoComma rightAligned" style="width: 250px;" maxlength="4" tabindex="206"></td>
						<td width="" class="rightAligned" >Net Tonnage</td>
						<td class="leftAligned"><input id="txtNetTon" type="text" class="applyDecimal" regExpPatt="pDeci1002" style="width: 250px;" tabindex="224" customLabel="Net Tonnage" min="0" max="99999990.90"></td>
					</tr>	
					<tr>
						<td width="" class="rightAligned">Drydocked Date</td>
						<td class="leftAligned">
							<div id="dryDateDiv" style="float: left; border: 1px solid gray; width: 255px; height: 20px;">
								<input id="txtDryDate" name="txtDryDate" readonly="readonly" type="text" maxlength="10" style="border: none; float: left; width: 230px; height: 13px; margin: 0px;" value="" tabindex="207"/>
								<img id="imgDryDate" alt="imgDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" tabindex="208" onclick="scwShow($('txtDryDate'), this, null);"/>
							</div>	
						</td>
						<td class="rightAligned" style="width: 135px;">Deadweight Tonnage</td>
						<td class="leftAligned">
							<input id="txtDeadweight" type="text" class="integerNoNegative" style="width: 250px; text-align: right;" tabindex="225" errorMsg="Invalid Deadweight Tonnage. Valid values should be from 0 to 99,999,999." min="0" max="99999999" maxlength="10">
						</td>
					</tr>													
					<tr>
						<td class="rightAligned">Place Drydocked</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtDryPlace" type="text" class="" style="width: 250px;" maxlength="30" tabindex="209"></td>
						<td width="" class="rightAligned" >Vessel Flag</td>
						<td class="leftAligned"><input id="txtVesselFlag" type="text" class="required allCaps" maxlength="1" style="width: 250px;" tabindex="226" ></td>
					</tr>																		
					<tr>
						<td class="rightAligned">Crew Nationality</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtCrewNat" type="text" class="" style="width: 250px;" maxlength="30" tabindex="210"></td>
						<td width="" class="rightAligned" >RPC No.</td>
						<td class="leftAligned"><input id="txtRpcNo" type="text" class="" maxlength="15" style="width: 250px;" tabindex="227" ></td>
					</tr>																			
					<tr>
						<td class="rightAligned">Engine Type</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtEngineType" type="text" class="" style="width: 250px;" maxlength="20" tabindex="211"></td>
						<td width="" class="rightAligned" >Vessel Breadth</td>
						<td class="leftAligned"><input id="txtVesselBreadth" type="text" class="applyDecimal" regExpPatt="pDeci0402" maxlength="7" style="width: 250px; text-align: right;" tabindex="228" min="0" max="9999.99" customLabel="Vessel Breadth"></td>
					</tr>																			
					<tr>
						<td class="rightAligned">No. of Passengers</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtNoPass" type="text" class="integerNoNegative rightAligned" style="width: 250px;" maxlength="5" tabindex="212" min="0" max="99999" errorMsg="Invalid No. of Passengers. Valid Values should be from 0 to 99999. "></td>
						<td width="" class="rightAligned" >Vessel Length</td>
						<td class="leftAligned"><input id="txtVesselLength" type="text" class="applyDecimal" regExpPatt="pDeci0402" maxlength="7" style="width: 250px; text-align: right;" tabindex="229" min="0" max="9999.99" customLabel="Vessel Length"></td>
					</tr>																								
					<tr>
						<td width="" class="rightAligned" >Number of Crew</td>
						<td class="leftAligned"><input id="txtNoCrew" type="text" class="integerNoNegative rightAligned" style="width: 250px;" tabindex="213"  min="0" max="99999" errorMsg="Invalid Number of Crew. Valid Values should be from 0 to 99999." maxlength="5"></td>
						<td width="" class="rightAligned" >Vessel Depth</td>
						<td class="leftAligned"><input id="txtVesselDepth" type="text" class="applyDecimal" regExpPatt="pDeci0402" maxlength="7" style="width: 250px; text-align: right;" tabindex="230" min="0" max="9999.99" customLabel="Vessel Depth"></td>
					</tr>			
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 661px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 635px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="214"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="215"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;"><input id="txtUserId" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="-1"></td>
						<td width="" class="rightAligned">Last Update</td>
						<td class="leftAligned"><input id="txtLastUpdate" type="text" class="" style="width: 250px;" readonly="readonly" tabindex="-1"></td>
					</tr>			
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="231">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="232">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="233">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="234">
</div>
<script type="text/javascript">	
	setModuleId("GIISS039");
	setDocumentTitle("Vessel Maintenance");
	initializeAccordion();
	changeTag = 0;
	var rowIndex = -1;
	
	function saveGiiss039(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgVessel.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgVessel.geniisysRows);
		new Ajax.Request(contextPath+"/GIISVesselController", {
			method: "POST",
			parameters : {action : "saveGiiss039",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  delRows : prepareJsonAsParameter(delRows)},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS039.exitPage != null) {
							objGIISS039.exitPage();
						} else {
							tbgVessel._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	//edited by gab 10.21.2015
	//observeReloadForm("reloadForm", showGiiss039);
	observeReloadForm("reloadFormVessel", showGiiss039);
	
	var objGIISS039 = {};
	var objVessel = null;
	objGIISS039.vesselList = JSON.parse('${jsonVesselList}');
	objGIISS039.exitPage = null;
	
	var vesselTable = {
			url : contextPath + "/GIISVesselController?action=showGiiss039&refresh=1",
			options : {
				width : '870px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objVessel = tbgVessel.geniisysRows[y];
					setFieldValues(objVessel);
					tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
					tbgVessel.keys.releaseKeys();
					$("txtVestypeDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
					tbgVessel.keys.releaseKeys();
					$("txtVesselCd").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValues(null);
						tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
						tbgVessel.keys.releaseKeys();
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
					tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
					tbgVessel.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValues(null);
					tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
					tbgVessel.keys.releaseKeys();
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
					tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
					tbgVessel.keys.releaseKeys();
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
					id : "vesselCd",
					title : "Vessel Code",
					filterOption : true,
					width : '80px'
				},
				{
					id : 'vesselName',
					filterOption : true,
					title : 'Vessel Name',
					width : '257px'				
				},	
				{
					id : 'vestypeDesc',
					filterOption : true,
					title : 'Vessel Type',
					width : '150px'				
				},
				{
					id : 'vessClassDesc',
					filterOption : true,
					title : 'Vessel Class',
					width : '150px'				
				},	
				{
					id : 'hullTypeDesc',
					filterOption : true,
					title : 'Hull Type',
					width : '150px'				
				},
				{
					id : 'vestypeCd',
					width : '0',
					visible: false				
				},
				{
					id : 'vessClassCd',
					width : '0',
					visible: false				
				},
				{
					id : 'hullTypeCd',
					width : '0',
					visible: false				
				},
				{
					id : 'regOwner',
					width : '0',
					visible: false				
				},
				{
					id : 'regPlace',
					width : '0',
					visible: false				
				},
				{
					id : 'yearBuilt',
					width : '0',
					visible: false				
				},
				{
					id : 'dryPlace',
					width : '0',
					visible: false				
				},
				{
					id : 'dryDate',
					width : '0',
					visible: false				
				},
				{
					id : 'crewNat',
					width : '0',
					visible: false				
				},
				{
					id : 'engineType',
					width : '0',
					visible: false				
				},
				{
					id : 'noPass',
					width : '0',
					visible: false				
				},
				{
					id : 'noCrew',
					width : '0',
					visible: false				
				},
				{
					id : 'netTon',
					width : '0',
					visible: false				
				},
				{
					id : 'grossTon',
					width : '0',
					visible: false				
				},
				{
					id : 'deadweight',
					width : '0',
					visible: false				
				},
				{
					id : 'rpcNo',
					width : '0',
					visible: false				
				},
				{
					id : 'vesselLength',
					width : '0',
					visible: false				
				},
				{
					id : 'vesselBreadth',
					width : '0',
					visible: false				
				},
				{
					id : 'vesselDepth',
					width : '0',
					visible: false				
				},
				{
					id : 'hullSw',
					width : '0',
					visible: false				
				},
				{
					id : 'propelSw',
					width : '0',
					visible: false				
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'remarks',
					width : '0',
					visible: false				
				},
				{
					id : 'userId',
					width : '0',
					visible: false
				},
				{
					id : 'lastUpdate',
					width : '0',
					visible: false				
				}
			],
			rows : objGIISS039.vesselList.rows
		};

		tbgVessel = new MyTableGrid(vesselTable);
		tbgVessel.pager = objGIISS039.vesselList;
		tbgVessel.render("vesselTable");
	
	function setFieldValues(rec){
			$("chkHullSw").checked = (rec == null ? true : (rec.hullSw == "Y" ? true : false));
			$("chkPropelSw").checked = (rec == null ? true : (rec.propelSw == "S" ? true : false));
			$("txtVesselCd").value = (rec == null ? "" : unescapeHTML2(rec.vesselCd));
			$("txtVesselCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.vesselCd)));
			$("txtVesselName").value = (rec == null ? "" : unescapeHTML2(rec.vesselName));
			$("txtVesselOldName").value = (rec == null ? "" : unescapeHTML2(rec.vesselOldName));
			$("hidVestypeCd").value = (rec == null ? "" : unescapeHTML2(rec.vestypeCd));
			$("txtVestypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.vestypeDesc));
			$("txtVestypeDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.vestypeDesc)));
			$("hidVessClassCd").value = (rec == null ? "" : rec.vessClassCd);
			$("txtVessClassDesc").value = (rec == null ? "" : unescapeHTML2(rec.vessClassDesc));
			$("txtVessClassDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.vessClassDesc)));
			$("hidHullTypeCd").value = (rec == null ? "" : rec.hullTypeCd);
			$("txtHullTypeDesc").value = (rec == null ? "" : unescapeHTML2(rec.hullTypeDesc));
			$("txtHullTypeDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.hullTypeDesc)));
			$("txtRegOwner").value = (rec == null ? "" : unescapeHTML2(rec.regOwner));
			$("txtRegPlace").value = (rec == null ? "" : unescapeHTML2(rec.regPlace));
			$("txtYearBuilt").value = (rec == null ? "" :rec.yearBuilt);
			$("txtDryDate").value = (rec == null ? "" : (rec.dryDate == "" || rec.dryDate == null ? "" : dateFormat(rec.dryDate, 'mm-dd-yyyy')) );
			$("txtDryPlace").value = (rec == null ? "" : unescapeHTML2(rec.dryPlace));
			$("txtCrewNat").value = (rec == null ? "" : unescapeHTML2(rec.crewNat));
			$("txtEngineType").value = (rec == null ? "" : unescapeHTML2(rec.engineType));
			$("txtNoPass").value = (rec == null ? "" : rec.noPass);
			$("txtGrossTon").value = (rec == null ? "" : formatCurrency(rec.grossTon));
			$("txtNetTon").value = (rec == null ? "" : formatCurrency(rec.netTon));
			$("txtDeadweight").value = (rec == null ? "" : (rec.deadweight == null ? "" : formatNumber(rec.deadweight)) );
			$("txtNoCrew").value = (rec == null ? "" : rec.noCrew);
			$("txtVesselFlag").value = (rec == null ? "V" : rec.vesselFlag);
			$("txtVesselFlag").setAttribute("lastValidValue", (rec == null ? "V" : unescapeHTML2(rec.vesselFlag)));
			$("txtRpcNo").value = (rec == null ? "" : unescapeHTML2(rec.rpcNo));
			$("txtVesselBreadth").value = (rec == null ? "" : formatToNthDecimal(rec.vesselBreadth, 2));
			$("txtVesselLength").value = (rec == null ? "" : formatToNthDecimal(rec.vesselLength, 2));
			$("txtVesselDepth").value = (rec == null ? "" : formatToNthDecimal(rec.vesselDepth, 2));
			
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? $("txtVesselCd").readOnly = false : $("txtVesselCd").readOnly = true;
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			objVessel = rec;
		
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.hullSw = $("chkHullSw").checked ? "Y" : "N";
			obj.propelSw = $("chkPropelSw").checked ? "S" : "N";
			obj.vesselCd = escapeHTML2($F("txtVesselCd"));
			obj.vesselName = escapeHTML2($F("txtVesselName"));
			obj.vesselOldName = escapeHTML2($F("txtVesselOldName"));
			obj.vestypeCd = escapeHTML2($F("hidVestypeCd"));
			obj.vestypeDesc = escapeHTML2($F("txtVestypeDesc"));
			obj.vessClassCd = escapeHTML2($F("hidVessClassCd"));
			obj.vessClassDesc = escapeHTML2($F("txtVessClassDesc"));
			obj.hullTypeCd = escapeHTML2($F("hidHullTypeCd"));
			obj.hullTypeDesc = escapeHTML2($F("txtHullTypeDesc"));
			obj.regOwner = escapeHTML2($F("txtRegOwner"));
			obj.regPlace = escapeHTML2($F("txtRegPlace"));
			obj.yearBuilt = $F("txtYearBuilt");
			obj.dryDate = $F("txtDryDate");
			obj.dryPlace = escapeHTML2($F("txtDryPlace"));
			obj.crewNat = escapeHTML2($F("txtCrewNat"));
			obj.engineType = escapeHTML2($F("txtEngineType"));
			obj.rpcNo = escapeHTML2($F("txtRpcNo"));
			obj.noPass = $F("txtNoPass");
			obj.noCrew = $F("txtNoCrew");
			obj.grossTon = $F("txtGrossTon");
			obj.netTon = $F("txtNetTon");
			obj.deadweight = $F("txtDeadweight");
			obj.vesselFlag = $F("txtVesselFlag");
			obj.vesselBreadth = $F("txtVesselBreadth");
			obj.vesselLength = $F("txtVesselLength");
			obj.vesselDepth = $F("txtVesselDepth");
			obj.remarks = escapeHTML2($F("txtRemarks"));
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
			changeTagFunc = saveGiiss039;
			var vessel = setRec(objVessel);
			if($F("btnAdd") == "Add"){
				tbgVessel.addBottomRow(vessel);
			} else {
				tbgVessel.updateVisibleRowOnly(vessel, rowIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgVessel.keys.removeFocus(tbgVessel.keys._nCurrentFocus, true);
			tbgVessel.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}		
	
	function valAddRec(){
		try{
			if(checkAllRequiredFieldsInDiv("vesselFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgVessel.geniisysRows.length; i++){
						if(tbgVessel.geniisysRows[i].recordStatus == 0 || tbgVessel.geniisysRows[i].recordStatus == 1){								
							if(tbgVessel.geniisysRows[i].vesselCd == $F("txtVesselCd")){
								addedSameExists = true;								
							}							
						} else if(tbgVessel.geniisysRows[i].recordStatus == -1){
							if(tbgVessel.geniisysRows[i].vesselCd == $F("txtVesselCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same vessel_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISVesselController", {
						parameters : {action : "valAddRecGiiss039",
									  vesselCd : $F("txtVesselCd")},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response){
							hideNotice();
							if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
								addRec();
							}
						}
					});
				} else {
					addRec();
				}
			}
		} catch(e){
			showErrorMessage("valAddRec", e);
		}
	}	
	
	function deleteRec(){
		changeTagFunc = saveGiiss039;
		objVessel.recordStatus = -1;
		tbgVessel.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valDeleteRec(){
		try{
			new Ajax.Request(contextPath + "/GIISVesselController", {
				parameters : {action : "valDeleteRecGiiss039",
							  vesselCd : $F("txtVesselCd")},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						deleteRec();
					}
				}
			});
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function exitPage(){
		if (objMKGlobal.callingForm == "GIIMM009") {
			showQuotationCarrierInfoPage();  //added by steven 12.09.2013
			$("mainNav").show();
		} else if (objUWGlobal.callingForm == "GIPIS007" || objUWGlobal.callingForm == "GIPIS076"){
			changeTag = 0;
			setDocumentTitle("Enter Vessel Information");
			setModuleId(objUWGlobal.callingForm);
			$("maintainDiv").hide();
			$("parInfoMenu").show();
			$("carrierInfoMainDiv").show();
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}	
	
	function cancelGiiss039(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objGIISS039.exitPage = exitPage;
						saveGiiss039();
					}, function(){
						exitPage();
						//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
					}, "");
		} else {
			exitPage();
			//goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		}
	}
	
	function showVestypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtVestypeDesc").trim() == "" ? "%" : $F("txtVestypeDesc"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS039VestypeLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Vessel Types",
				width : 480,
				height : 386,
				columnModel : [  {
					id : "vestypeDesc",
					title : "Description",
					width : '345px'
				},{
					id : "vestypeCd",
					title : "Vessel Type",
					width : '120px',
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("hidVestypeCd").value = row.vestypeCd;
						$("txtVestypeDesc").setAttribute("lastValidValue", unescapeHTML2(row.vestypeDesc));
						$("txtVestypeDesc").value = unescapeHTML2(row.vestypeDesc);
					}
				},
				onCancel: function(){
					$("txtVestypeDesc").focus();
					$("txtVestypeDesc").value = $("txtVestypeDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtVestypeDesc").value = $("txtVestypeDesc").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtVestypeDesc");
				} 
			});
		}catch(e){
			showErrorMessage("showVestypeLOV", e);
		}		
	}
	
	function showVessClassLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtVessClassDesc").trim() == "" ? "%" : $F("txtVessClassDesc"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS039VessClassLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Vessel Classes",
				width : 480,
				height : 386,
				columnModel : [  {
					id : "vessClassDesc",
					title : "Description",
					width : '345px'
				},{
					id : "vessClassCd",
					title : "Vessel Class",
					titleAlign: 'right',
					align: 'right',
					width : '120px',
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("hidVessClassCd").value = row.vessClassCd;
						$("txtVessClassDesc").setAttribute("lastValidValue", unescapeHTML2(row.vessClassDesc));
						$("txtVessClassDesc").value = unescapeHTML2(row.vessClassDesc);
					}
				},
				onCancel: function(){
					$("txtVessClassDesc").focus();
					$("txtVessClassDesc").value = $("txtVessClassDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtVessClassDesc").value = $("txtVessClassDesc").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtVessClassDesc");
				} 
			});
		}catch(e){
			showErrorMessage("showVessClassLOV", e);
		}		
	}
	
	function showHullTypeLOV(isIconClicked){
		try{
			var searchString = isIconClicked ? "%" : ($F("txtHullTypeDesc").trim() == "" ? "%" : $F("txtHullTypeDesc"));	
			
			LOV.show({
				controller : "UnderwritingLOVController",
				urlParameters : {
					action : "getGIISS039HullTypeLOV",
					searchString : searchString,
					page : 1
				},
				title : "List of Hull Types",
				width : 480,
				height : 386,
				columnModel : [  {
					id : "hullDesc",
					title : "Description",
					width : '345px'
				},{
					id : "hullTypeCd",
					title : "Hull Type",
					titleAlign: 'right',
					align: 'right',
					width : '120px',
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("hidHullTypeCd").value = row.hullTypeCd;
						$("txtHullTypeDesc").setAttribute("lastValidValue", unescapeHTML2(row.hullDesc));
						$("txtHullTypeDesc").value = unescapeHTML2(row.hullDesc);
					}
				},
				onCancel: function(){
					$("txtHullTypeDesc").focus();
					$("txtHullTypeDesc").value = $("txtHullTypeDesc").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtHullTypeDesc").value = $("txtHullTypeDesc").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtHullTypeDesc");
				} 
			});
		}catch(e){
			showErrorMessage("showHullTypeLOV", e);
		}		
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("txtVesselName").observe("keyup", function(){
		$("txtVesselName").value = $F("txtVesselName").toUpperCase();
	});
	
	$("txtVesselCd").observe("keyup", function(){
		$("txtVesselCd").value = $F("txtVesselCd").toUpperCase();
	});
	
	$("searchVestypeLOV").observe("click", function(){
		showVestypeLOV(true);
	});
	
	$("txtVestypeDesc").observe("change", function(){
		if (this.value != ""){
			showVestypeLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("hidVestypeCd").clear();
		}
	});
	
	$("searchVessClassLOV").observe("click", function(){
		showVessClassLOV(true);
	});
	
	$("txtVessClassDesc").observe("change", function(){
		if (this.value != ""){
			showVessClassLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("hidVessClassCd").clear();
		}
	});
	
	$("searchHullTypeLOV").observe("click", function(){
		showHullTypeLOV(true);
	});
	
	$("txtHullTypeDesc").observe("change", function(){
		if (this.value != ""){
			showHullTypeLOV(false);
		}else{
			this.setAttribute("lastValidValue", "");
			$("hidHullTypeCd").clear();
		}
	});
	
	$("txtVesselFlag").observe("change", function(){	//added to prevent Check Constraint (VESSEL_VESSEL_FLAG_CHK) error
		if (this.value != "A"  && this.value != "V" && this.value != "I" ){
			showWaitingMessageBox("Invalid Vessel Flag. Valid Values are V, A, and I.", "E", function(){
				$("txtVesselFlag").focus();
				$("txtVesselFlag").value = $("txtVesselFlag").getAttribute("lastValidValue");
			});
		}else{
			this.setAttribute("lastValidValue", this.value);
		}
	});
	
	$("txtDeadweight").observe("blur", function(e){
		if(!((this.value).empty())){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(this.getAttribute("errorMsg"), imgMessage.ERROR, this.id);
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					customShowMessageBox(this.getAttribute("errorMsg"), imgMessage.ERROR, this.id);
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					customShowMessageBox(this.getAttribute("errorMsg"), imgMessage.ERROR, this.id);
				}else{
					this.value = (this.value == "" ? "" :formatNumber(this.value.replace(/,/g, "")*1));
				}
			}
		}			
	});
		
	$("txtVesselBreadth").observe("blur", function(){
		if(!((this.value).empty()) && this.getAttribute("executeOnBlur") != "N"){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(getNumberFieldErrMsg(this, true , (this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, this.id);
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselBreadth").value = $("txtVesselBreadth").getAttribute("lastValidValue");
						$("txtVesselBreadth").focus();
					});
					return false;
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselBreadth").value = $("txtVesselBreadth").getAttribute("lastValidValue");
						$("txtVesselBreadth").focus();
					});
					return false;
				}else{
					val = formatNumberByRegExpPattern(this);		
				}
			}
		}
	});
	
	$("txtVesselLength").observe("blur", function(){
		if(!((this.value).empty()) && this.getAttribute("executeOnBlur") != "N"){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(getNumberFieldErrMsg(this, true , (this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, this.id);
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselLength").value = $("txtVesselLength").getAttribute("lastValidValue");
						$("txtVesselLength").focus();
					});
					return false;
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselLength").value = $("txtVesselLength").getAttribute("lastValidValue");
						$("txtVesselLength").focus();
					});
					return false;
				}else{
					val = formatNumberByRegExpPattern(this);		
				}
			}
		}
	});
	
	$("txtVesselDepth").observe("blur", function(){
		if(!((this.value).empty()) && this.getAttribute("executeOnBlur") != "N"){
			if(isNaN(parseInt((this.value).replace(/,/g, "")))){
				this.value = "";
				customShowMessageBox(getNumberFieldErrMsg(this, true , (this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, this.id);
			}else{
				if(parseInt(this.value) < parseInt(this.getAttribute("min"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselDepth").value = $("txtVesselDepth").getAttribute("lastValidValue");
						$("txtVesselDepth").focus();
					});
					return false;
				}else if(parseInt(this.value) > parseInt(this.getAttribute("max"))){
					showWaitingMessageBox(getNumberFieldErrMsg(this, true,(this.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						$("txtVesselDepth").value = $("txtVesselDepth").getAttribute("lastValidValue");
						$("txtVesselDepth").focus();
					});
					return false;
				}else{
					val = formatNumberByRegExpPattern(this);		
				}
			}
		}
	});
	
	function getNumberFieldErrMsg(m, addSeparator, useCustomLabel){
		try{
			var mssg = "";
			if(m.up(1).down(0) != null && m.up(1).down(0) != undefined){
				//mssg = "Invalid " + m.up(1).down(0).innerHTML.trim() + ". Valid value is from ";
				mssg = "Invalid " + (nvl(useCustomLabel,"N") == "Y" ? m.getAttribute("customLabel") : getElementLabelInTable(m.id).trim()) + ". Valid value should be from ";
				mssg = mssg + m.getAttribute("min") + " to " + (addSeparator ? addSeparatorToNumber2(m.getAttribute("max"), ",") : m.getAttribute("max")) + ".";
			}		
			
			return mssg;		
		}catch(e){
			showErrorMessage("getNumberFieldErrMsg", e);
		}
	}
	
	$$("input[type='text'].applyDecimal").each(function(m){
		m.setStyle("text-align: right");
		
		m.observe("focus", function(){
			m.select();
			m.value = (m.value).replace(/,/g, "");
			m.setAttribute("lastValidValue", this.value);
		});
		
		m.observe("keyup", function(e){				
			var pattern = m.getAttribute("regExpPatt"); 				
			var val = m.value.replace(/,/g, "");
			
			if(pattern.substr(0,1) == "p"){
				if(this.value.include("-")){
					m.setAttribute("executeOnBlur", "N");
					showWaitingMessageBox(getNumberFieldErrMsg(m, true, (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
						m.value = m.getAttribute("lastValidValue");
						m.focus();
					});
					return false;
				}else{						
					this.value = (val).match(RegExDecimal[pattern])[0];
					m.setAttribute("executeOnBlur", "Y");
				}
			}else{					
				this.value = (val).match(RegExDecimal[pattern])[0];
				m.setAttribute("executeOnBlur", "Y");
			}					    						
		});
		
		m.observe("blur", function(e){				
			if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
				if(isNaN(parseInt((m.value).replace(/,/g, "")))){
					m.value = "";
					customShowMessageBox(getNumberFieldErrMsg(m, true , (m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
				}else{
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else{
						val = formatNumberByRegExpPattern(m);				
						
						m.value = addSeparatorToNumber2(val, ",");
					}
				}
			}
		});
		
		m.observe("change", function(){
			if(!((m.value).empty()) && m.getAttribute("executeOnBlur") != "N"){
				if(isNaN(parseInt((m.value).replace(/,/g, "")))){
					m.value = "";
					customShowMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, m.id);
				}else{
					if(parseInt(m.value) < parseInt(m.getAttribute("min"))){
						showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else if(parseInt(m.value) > parseInt(m.getAttribute("max"))){
						showWaitingMessageBox(getNumberFieldErrMsg(m, true,(m.getAttribute("customLabel") != null ? "Y" : "N")), imgMessage.ERROR, function(){
							m.value = m.getAttribute("lastValidValue");
							m.focus();
						});
						return false;
					}else{
						val = formatNumberByRegExpPattern(m);							
						m.value = val;							
						m.setAttribute("lastValidValue", m.value);
					}
				}
			}
		});
	});
	
	disableButton("btnDelete");
	
	observeSaveForm("btnSave", saveGiiss039);
	$("btnCancel").observe("click", cancelGiiss039);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);

	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("txtVesselCd").focus();	
	
	setFieldValues(null);
	initializeAll();
</script>