<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="giiss007MainDiv" name="giiss007MainDiv" style="">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="giiss007" name="giiss007">	
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Province</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
		   	</div>
		</div>	
		<div id="provinceDiv">	
			<div class="sectionDiv">
				<div id="provinceTableDiv" style="padding-top: 10px;">
					<div id="provinceTable" style="height: 200px; margin-left: 115px;"></div>
				</div>
				<div id="provinceFormDiv" align="center" style="margin: 10px 0 10px 5px">
					<table>
						<tr>
							<td style="width: 60px" align="right">Province</td>						
							<td style="width:125px"><span class="lovSpan" style="width: 125px; height:19px;margin-top:0">
									<input id="txtProvinceCd" maxlength="25" type="text" style="width:100px;margin: 0;height: 13px;border: 0" class="required" ignoreDelKey="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchProvince" alt="Go" style="float: right; margin-top: 2px;" class="required"/>
								</span>	
							</td>
							<td>
								<input id="txtProvince" readonly="readonly" type="text" style="width:371px;margin-top:0">
							</td>						
						</tr>					
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<input type="button" class="button" id="btnAddProvince" value="Add" tabindex="210">
					<input type="button" class="button" id="btnDeleteProvince" value="Delete" tabindex="211">
				</div>
			</div>	
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>City</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>	
		<div id="cityDiv">  
			<div class="sectionDiv">
				<div id="cityTableDiv" style="padding-top: 10px;">
					<div id="cityTable" style="height: 200px; margin-left: 115px;"></div>
				</div>
				<div id="cityFormDiv" align="center" style="margin: 10px 0 10px 5px">
					<table>
						<tr>
							<td style="width: 60px" align="right">City</td>						
							<td style="width:125px"><span class="lovSpan required" style="width: 125px; height:19px;margin-top:0">
									<input id="txtCityCd" maxlength="40" type="text" style="width:100px;margin: 0;height: 13px;border: 0" class="required" ignoreDelKey="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchCity" alt="Go" style="float: right; margin-top: 2px;" class="required"/>
								</span>	
							</td>
							<td>
								<input id="txtCity" readonly="readonly" type="text" style="width:371px;margin-top:0">
							</td>						
						</tr>				
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<input type="button" class="button" id="btnAddCity" value="Add" tabindex="210">
					<input type="button" class="button" id="btnDeleteCity" value="Delete" tabindex="211">
				</div>
			</div>	
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>District</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>
		<div id="districtDiv">	
			<div class="sectionDiv">
				<div id="districtTableDiv" style="padding-top: 10px;">
					<div id="districtTable" style="height: 200px; margin-left: 115px;"></div>
				</div>
				<div id="districtFormDiv" align="center" style="margin: 10px 0 10px 5px">
					<table>
						<tr>
							<tr>
							<td style="width: 60px" align="right">District</td>						
							<td style="width:125px">
								<input id="txtDistrictNo" maxlength="6" type="text" style="width:117px;margin-top:0" class="required">
							</td>
							<td>
								<input id="txtDistrictDesc" maxlength="40" type="text" style="width:371px;margin-top:0" class="required">
							</td>						
						</tr>
						<tr>
							<td style="width: 60px" align="right">Sheet No</td>
							<td colspan="2">
								<input id="txtSheetNo" maxlength="6" type="text" style="width:200px;margin-top:0">
							</td>
						</tr>
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<input type="button" class="button" id="btnAddDistrict" value="Add" tabindex="210">
					<input type="button" class="button" id="btnDeleteDistrict" value="Delete" tabindex="211">
				</div>
			</div>	
		</div>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Block</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>	
		<div id="blockDiv">	
			<div class="sectionDiv">
				<div id="blockTableDiv" style="padding-top: 10px;">
					<div id="blockTable" style="height: 200px; margin-left: 10px;"></div>
				</div>
				<div id="blockFormDiv" align="center">
					<table style="margin-top: 5px">
						<tr>
							<td align="right">Block ID</td>						
							<td colspan="2">
								<input id="txtBlockId" maxlength="12" type="text" style="width:200px;margin-top:0" class="rightAligned" readonly="readonly">
							</td>
							<td align="right" style="width: 186px;">Block No</td>
							<td><input id="txtBlockNo" maxlength="6" type="text"  style="width:200px" class="required"></td>
						</tr>
						<tr>
							<td align="right">Description</td>
							<td colspan="4">								
								<input id="txtBlockDesc" maxlength="40" type="text" style="width:602px;margin-top:0" class="required"/> 
							</td>
						</tr>					
						<tr>
							<td align="right">E-Quake Zone</td>						
							<td style="width:125px">
								<span class="lovSpan" style="width: 125px; height:19px;margin-top:0">
									<input id="txtEqZone" maxlength="2" type="text" style="width:100px;margin: 0;height: 13px;border: 0" ignoreDelKey="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchEqZone" alt="Go" style="float: right; margin-top: 2px;"/>
								</span>	
							</td>
							<td colspan="3">
								<input id="txtEqZoneDesc" readonly="readonly" type="text" style="width:471px;margin-top:0">
							</td>
						</tr>	
						<tr>
							<td align="right">Flood Zone</td>						
							<td style="width:125px">
								<span class="lovSpan" style="width: 125px; height:19px;margin-top:0">
									<input id="txtFloodZone" maxlength="2" type="text" style="width:100px;margin: 0;height: 13px;border: 0" ignoreDelKey="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFloodZone" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>
							<td colspan="3"><input id="txtFloodZoneDesc" readonly="readonly" type="text" style="width:471px;margin-top:0"></td>
						</tr>					
						<tr>
							<td align="right">Typhoon Zone</td>						
							<td style="width:125px">
								<span class="lovSpan" style="width: 125px;height:19px;margin-top:0">
									<input id="txtTyphoonZone" maxlength="2" type="text" style="width:100px;margin: 0;height: 13px;border: 0" ignoreDelKey="">
									<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchTyphoonZone" alt="Go" style="float: right; margin-top: 2px;" />
								</span>	
							</td>
							<td colspan="3"><input id="txtTyphoonZoneDesc" readonly="readonly" type="text" style="width:471px;margin-top:0"></td>
						</tr>	
						<tr>
							<td align="right"></td>						
							<td colspan="2">
								<input id="chkActiveTag" type="checkbox" style="float: left; margin-right: 5px;" disabled="disabled">
								<label for="chkActiveTag">Active Tag</label>
							</td>
							<td align="right" style="width: 186px;">Net Ret. Manual Balance</td>
							<td><input id="txtNetretBegBal" maxlength="21" type="text"  style="width:200px" class="rightAligned money4"></td>
						</tr>
						<tr>
							<td align="right" style="width: 90px">Retention Limit</td>						
							<td colspan="2">
								<input id="txtRetnLimAmt" maxlength="21" type="text" style="width:200px;margin-top:0" class="rightAligned money4" lastValidValue="">
							</td>
							<td align="right" style="width: 186px;">Facul Manual Balance</td>
							<td><input id="txtFaculBegBal" maxlength="21" type="text"  style="width:200px" class="rightAligned money4"></td>
						</tr>
						<tr>
							<td align="right">Treaty Limit</td>						
							<td colspan="2">
								<input id="txtTrtyLimAmt" maxlength="21" type="text" style="width:200px;margin-top:0" class="rightAligned money4" lastValidValue="">
							</td>
							<td align="right" style="width: 186px;">Treaty Manual Balance</td>
							<td><input id="txtTrtyBegBal" maxlength="21" type="text"  style="width:200px" class="rightAligned money4"></td>
						</tr>													
						<tr>
							<td align="right">Remarks</td>
							<td colspan="4">
								<div style="border: 1px solid gray; height: 21px; width: 608px">
									<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 582px" maxlength="4000"></textarea>
									<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; padding: 3px; float: right;" alt="EditRemark" id="editRemarks"/>
								</div>
							</td>
						</tr>
						<tr>
							<td align="right">User ID</td>
							<td colspan="2"><input id="txtUserId" type="text" style="width:200px" readonly="readonly"></td>
							<td align="right" style="width: 186px;">Last Update</td>
							<td><input id="txtLastUpdate" type="text"  style="width:200px" readonly="readonly"></td>
						</tr>				
					</table>
				</div>
				<div style="margin: 10px;" align="center">
					<input type="button" class="button" id="btnAddBlock" value="Add" tabindex="210">
					<input type="button" class="button" id="btnDeleteBlock" value="Delete" tabindex="211">
				</div>
				<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
						<input type="button" class="button" id="btnRisk" value="Risk" style="width: 100px;">
				</div>
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancelBlock" value="Cancel" tabindex="210">
	<input type="button" class="button" id="btnSaveBlock" value="Save" tabindex="211">
</div>
<script type="text/javascript">	
	setModuleId("GIISS007");
	setDocumentTitle("District/Block Maintenance");
	initializeAll();
	initializeAccordion();
	initializeAllMoneyFields();
	changeTag = 0;
	changeTag2 = 0;
	changeTagAddParent = 0;
	changeTagUpdateDistrict = 0;
	var rowIndexProvince = -1;
	var rowIndexCity = -1;
	var rowIndexDistrict = -1;
	var rowIndexBlock = -1;
	var objGIISS007 = {};
	var objCurrProvince = null;
	var objCurrCity = null;
	var objCurrDistrict = null;
	var objCurrBlock = null;
	var selected ={};  //Added by MarkS 9.26.2016 SR-5475
	objGIISS007.provinceList = JSON.parse('${jsonProvinceList}');
	objGIISS007.cityList = JSON.parse('${jsonCityList}');
	objGIISS007.districtList = JSON.parse('${jsonDistrictList}');
	objGIISS007.blockList = JSON.parse('${jsonBlockList}');
	objGIISS007.exitPage = null;
	
	function saveGiiss007(){		
		if(changeTagAddParent==1 && !hasChangesInTbg("City") && hasChangesInTbg("Province")){
			customShowMessageBox("City must be entered.", imgMessage.INFO,
			"txtCityCd");
			return;
		}else if (changeTagAddParent==1 && !hasChangesInTbg("District") && hasChangesInTbg("City")){
			customShowMessageBox("District must be entered.", imgMessage.INFO,
			"txtDistrictNo");
			return;
		}else if (changeTagAddParent==1 && !hasChangesInTbg("Block") && hasChangesInTbg("District")){
			customShowMessageBox("Block must be entered.", imgMessage.INFO,
			"txtBlockNo");
			return;				
		}
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRowsBlock = getAddedAndModifiedJSONObjects(tbgBlock.geniisysRows);	
		var updateRowsDistrict = new Array();	
		var delRowsBlock = getDeletedJSONObjects(tbgBlock.geniisysRows);
		var delRowsProvince = getDeletedJSONObjects(tbgProvince.geniisysRows);
		var delRowsCity = getDeletedJSONObjects(tbgCity.geniisysRows);
		var delRowsDistrict = getDeletedJSONObjects(tbgDistrict.geniisysRows);
		if(changeTagUpdateDistrict==1){
			updateRowsDistrict = getAddedAndModifiedJSONObjects(tbgDistrict.geniisysRows);		
		}
		new Ajax.Request(contextPath+"/GIISBlockController", {
			method: "POST",
			parameters : {action : "saveGiiss007",
						 setRowsBlock : prepareJsonAsParameter(setRowsBlock),
						 updateRowsDistrict : prepareJsonAsParameter(updateRowsDistrict),
						 delRowsBlock : prepareJsonAsParameter(delRowsBlock),
						 delRowsProvince : prepareJsonAsParameter(delRowsProvince),
						 delRowsCity : prepareJsonAsParameter(delRowsCity),
						 delRowsDistrict : prepareJsonAsParameter(delRowsDistrict)},						 
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGIISS007.exitPage != null) {
							objGIISS007.exitPage();
						} else {
							//edited by MarkS 9.26.2016 SR-5475
							tbgProvince._refreshList();
							setProvinceFieldValues(selected.objCurrProvince);
							setTbgCity(selected.objCurrProvince);
							enableFields("City");
							setCityFieldValues(selected.objCurrCity);
							setTbgDistrict(selected.objCurrProvince);
							enableFields("District");
							setDistrictFieldValues(selected.objCurrDistrict);
							setTbgBlock(selected.objCurrDistrict);
							enableFields("Block");
							//end SR-5475
						}
					});
					changeTag = 0;
					changeTag2 = 0;
					changeTagAddParent = 0;
					changeTagUpdateDistrict = 0;
				}
			}
		}); 
	}
		
	var provinceTable = {
		url : contextPath + "/GIISBlockController?action=getGiiss007Province",
		options : {
			width : '700px',
			hideColumnChildTitle: true,
			pager : {},
			beforeClick : function(element, value, x, y, id){				
				if(checkChangesTbg("Province")||changeTagAddParent==1){
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;						
				}			
			},
			onCellFocus : function(element, value, x, y, id){								
				rowIndexProvince = y;		
				objCurrProvince = tbgProvince.geniisysRows[y];
				selected.objCurrProvince = objCurrProvince; //Added by MarkS 9.26.2016 SR-5475
				setProvinceFieldValues(objCurrProvince);
				setTbgCity(objCurrProvince);
				enableFields("City");
				tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
				tbgProvince.keys.releaseKeys();									
			},
			onRemoveRowFocus : function(){			
				rowIndexProvince = -1;
				setProvinceFieldValues(null);
				setTbgCity(null);	
				disableFields("City");			
				tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
				tbgProvince.keys.releaseKeys();
				$("txtProvinceCd").focus();
			
			},					
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndexProvince = -1;
					setProvinceFieldValues(null);
					setTbgCity(null);	
					disableFields("City");
					tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
					tbgProvince.keys.releaseKeys();
				}
			},
			beforeSort : function(){
				if(checkChangesTbg("Province")||changeTagAddParent==1){
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;						
				}	
			},
			onSort: function(){
				rowIndexProvince = -1;
				setProvinceFieldValues(null);
				setTbgCity(null);	
				disableFields("City");
				tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
				tbgProvince.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndexProvince = -1;
				setProvinceFieldValues(null);
				setTbgCity(null);	
				disableFields("City");
				tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
				tbgProvince.keys.releaseKeys();
			},				
			prePager: function(){
				if(checkChangesTbg("Province")||changeTagAddParent==1){
					showMessageBox("Please save changes first.", imgMessage.INFO);				
					return false;						
				}else{
					rowIndexProvince = -1;
					setProvinceFieldValues(null);
					setTbgCity(null);	
					disableFields("City");
					tbgProvince.keys.removeFocus(tbgProvince.keys._nCurrentFocus, true);
					tbgProvince.keys.releaseKeys();					
				}			
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
				id : "provinceCd province",
				title : "Province",			
				width : '660px',			
				children : [{
	                id : 'provinceCd',
	                title:'Province Code',
	                align : 'left',
	                width: 150,
	                filterOption: true
	            },{
	                id : 'province',
	                title: 'Province',
	                align : "left",
	                width: 523,
	                filterOption: true
	            }]
			}			
		],
		rows : objGIISS007.provinceList.rows
	};
	tbgProvince = new MyTableGrid(provinceTable);
	tbgProvince.pager = objGIISS007.provinceList;
	tbgProvince.render("provinceTable");
		
	var cityTable = {
			url : contextPath + "/GIISBlockController?action=getGiiss007City",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick : function(element, value, x, y, id){				
					if(checkChangesTbg("City")||changeTagAddParent==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);					
						return false;						
					}			
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndexCity = y;
					objCurrCity = tbgCity.geniisysRows[y];
					selected.objCurrCity = objCurrCity; //Added by MarkS 9.26.2016 SR-5475
					setCityFieldValues(objCurrCity);
					setTbgDistrict(objCurrProvince);
					enableFields("District");
					tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
					tbgCity.keys.releaseKeys();							
				},
				onRemoveRowFocus : function(){					
					rowIndexCity = -1;
					setCityFieldValues(null);
					setTbgDistrict(null);
					disableFields("District");
					tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
					tbgCity.keys.releaseKeys();
					$("txtCityCd").focus();				
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexCity = -1;
						setCityFieldValues(null);
						setTbgDistrict(null);
						disableFields("District");
						tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
						tbgCity.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(checkChangesTbg("City")||changeTagAddParent==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}	
				},
				onSort: function(){
					rowIndexCity = -1;
					setCityFieldValues(null);
					setTbgDistrict(null);
					disableFields("District");
					tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
					tbgCity.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexCity = -1;
					setCityFieldValues(null);
					setTbgDistrict(null);
					disableFields("District");
					tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
					tbgCity.keys.releaseKeys();
				},				
				prePager: function(){
					if(checkChangesTbg("City")||changeTagAddParent==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}else{
						rowIndexCity = -1;
						setCityFieldValues(null);
						setTbgDistrict(null);
						disableFields("District");
						tbgCity.keys.removeFocus(tbgCity.keys._nCurrentFocus, true);
						tbgCity.keys.releaseKeys();
					}	
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
					id : "cityCd city",
					title : "City",			
					width : '660px',			
					children : [{
		                id : 'cityCd',
		                title:'City Code',
		                align : 'left',
		                width: 150,
		                filterOption: true
		            },{
		                id : 'city',
		                title: 'City',
		                align : "left",
		                width: 523,
		                filterOption: true
		            }]
				}				
			],
		rows : objGIISS007.cityList.rows
	};

	tbgCity = new MyTableGrid(cityTable);
	tbgCity.pager = objGIISS007.cityList;
	tbgCity.render("cityTable");
			
	var districtTable = {
			url : contextPath + "/GIISBlockController?action=getGiiss007District",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick : function(element, value, x, y, id){				
					if(checkChangesTbg("District") || changeTagAddParent==1 || changeTagUpdateDistrict==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}			
				},
				onCellFocus : function(element, value, x, y, id){				
					rowIndexDistrict = y;
					objCurrDistrict = tbgDistrict.geniisysRows[y];
					selected.objCurrDistrict = objCurrDistrict; //Added by MarkS 9.26.2016 SR-5475
					setDistrictFieldValues(objCurrDistrict);
					setTbgBlock(objCurrDistrict);
					enableFields("Block");
					tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
					tbgDistrict.keys.releaseKeys();
					$("txtDistrictDesc").focus();	
				},
				onRemoveRowFocus : function(){		
					rowIndexDistrict = -1;
					setDistrictFieldValues(null);
					setTbgBlock(null);
					disableFields("Block");
					tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
					tbgDistrict.keys.releaseKeys();
					$("txtDistrictNo").focus();					
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexDistrict = -1;
						setDistrictFieldValues(null);
						setTbgBlock(null);
						disableFields("Block");
						tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
						tbgDistrict.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(checkChangesTbg("District") || changeTagAddParent==1 || changeTagUpdateDistrict==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);					
						return false;						
					}
				},
				onSort: function(){
					rowIndexDistrict = -1;
					setDistrictFieldValues(null);
					setTbgBlock(null);
					disableFields("Block");
					tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
					tbgDistrict.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexDistrict = -1;
					setDistrictFieldValues(null);
					setTbgBlock(null);
					disableFields("Block");
					tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
					tbgDistrict.keys.releaseKeys();
				},				
				prePager: function(){
					if(checkChangesTbg("District") || changeTagAddParent==1 || changeTagUpdateDistrict==1){
						showMessageBox("Please save changes first.", imgMessage.INFO);
						return false;						
					}else{
						rowIndexDistrict = -1;
						setDistrictFieldValues(null);
						setTbgBlock(null);
						disableFields("Block");
						tbgDistrict.keys.removeFocus(tbgDistrict.keys._nCurrentFocus, true);
						tbgDistrict.keys.releaseKeys();
					}
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
					id : "districtNo districtDesc",
					title : "District",			
					width : '660px',			
					children : [{
		                id : 'districtNo',
		                title:'District No.',
		                align : 'left',
		                width: 150,
		                filterOption: true
		            },{
		                id : 'districtDesc',
		                title: 'Description',
		                align : "left",
		                width: 523,
		                filterOption: true
		            }]
				}	
			],
		rows : objGIISS007.districtList.rows
	};

	tbgDistrict = new MyTableGrid(districtTable);
	tbgDistrict.pager = objGIISS007.districtList;
	tbgDistrict.render("districtTable");
	
	var blockTable = {
			url : contextPath + "/GIISBlockController?action=getGiiss007Block",
			options : {
				width : '900px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexBlock = y;
					objCurrBlock = tbgBlock.geniisysRows[y];
					setBlockFieldValues(objCurrBlock);
					//enableToolbarButton("btnToolbarPrint");
					tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
					tbgBlock.keys.releaseKeys();
					$("txtBlockDesc").focus();
				},
				onRemoveRowFocus : function(){
					rowIndexBlock = -1;
					setBlockFieldValues(null);
					//disableToolbarButton("btnToolbarPrint");
					tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
					tbgBlock.keys.releaseKeys();
					$("txtBlockNo").focus();
				},					
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexBlock = -1;
						setBlockFieldValues(null);
						//disableToolbarButton("btnToolbarPrint");
						tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
						tbgBlock.keys.releaseKeys();
					}
				},
				beforeSort : function(){
					if(changeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveBlock").focus();
						});
						return false;
					}
				},
				onSort: function(){
					rowIndexBlock = -1;
					setBlockFieldValues(null);
					//disableToolbarButton("btnToolbarPrint");
					tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
					tbgBlock.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndexBlock = -1;
					setBlockFieldValues(null);
					//disableToolbarButton("btnToolbarPrint");
					tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
					tbgBlock.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag2 == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSaveBlock").focus();
						});
						return false;
					}
					rowIndexBlock = -1;
					setBlockFieldValues(null);
					//disableToolbarButton("btnToolbarPrint");
					tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
					tbgBlock.keys.releaseKeys();
				},
				checkChanges: function(){
					return (changeTag2 == 1 ? true : false);
				},
				masterDetailRequireSaving: function(){
					return (changeTag2 == 1 ? true : false);
				},
				masterDetailValidation: function(){
					return (changeTag2 == 1 ? true : false);
				},
				masterDetail: function(){
					return (changeTag2 == 1 ? true : false);
				},
				masterDetailSaveFunc: function() {
					return (changeTag2 == 1 ? true : false);
				},
				masterDetailNoFunc: function(){
					return (changeTag2 == 1 ? true : false);
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
					id: 'activeTag',
					title: 'A',
					altTitle: 'Active Tag',
					titleAlign: 'center',
					width: '22%',
					filterOption: true,
					filterOptionType: 'checkbox',
					editor: new MyTableGrid.CellCheckbox({
					    getValueOf: function(value) {
					    	if (value){
								return "Y";
		            		}else{
								return "N";	
		            		}
					    }
					}),
					visible: true
				},
				{
					id : 'blockId',
					title : "Block ID",			
					width : '111px',
					align : 'right',
					titleAlign : 'right',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{
					id : "blockNo",
					title : "Block No",
					width : '120px',
					filterOption: true
				},						
				{
					id : 'blockDesc',			
					title : 'Description',
					width : '310px',
					filterOption: true
				},											
				{
					id : 'eqZone',
					title : 'E-Quake Zone',
					width : '100px',
					filterOption: true
				},											
				{
					id : 'floodZone',
					title : 'Flood Zone',
					width : '100px',
					filterOption: true
				},											
				{
					id : 'typhoonZone',
					title : 'Typhoon Zone',
					width : '100px',
					filterOption: true
				}
			],
			rows : objGIISS007.blockList.rows
		};

		tbgBlock = new MyTableGrid(blockTable);
		tbgBlock.pager = objGIISS007.blockList;
		tbgBlock.render("blockTable");
		
	function setTbgCity(rec){
		try{
			if(rec != null){
				tbgCity.url = contextPath
				+ "/GIISBlockController?action=getGiiss007City&provinceCd="+encodeURIComponent(objCurrProvince.provinceCd); // edited by gab ramos 07.28.2015
				tbgCity._refreshList();	
				//$("cityDiv").show();
			}else{
				tbgCity.url = contextPath
				+ "/GIISBlockController?action=getGiiss007City";
				tbgCity._refreshList();	
				//$("cityDiv").hide();
			}
		} catch(e){
			showErrorMessage("setTbgCity", e);
		}	
	}
	
	function setTbgDistrict(rec){
		try{
			if(rec != null){
				tbgDistrict.url = contextPath
				+ "/GIISBlockController?action=getGiiss007District&provinceCd="+encodeURIComponent(objCurrProvince.provinceCd)+"&cityCd="+encodeURIComponent(objCurrCity.cityCd); // edited by gab ramos 07.28.2015
				tbgDistrict._refreshList();	
				//$("districtDiv").show();
			}else{
				tbgDistrict.url = contextPath
				+ "/GIISBlockController?action=getGiiss007District";
				tbgDistrict._refreshList();	
				//$("districtDiv").hide();
			}
		} catch(e){
			showErrorMessage("setTbgDistrict", e);
		}	
	}
	
	function setTbgBlock(rec){
		try{
			if(rec != null){
				tbgBlock.url = contextPath
				+ "/GIISBlockController?action=getGiiss007Block&provinceCd="+encodeURIComponent(objCurrProvince.provinceCd)+"&cityCd="+encodeURIComponent(objCurrCity.cityCd)+"&districtNo="+encodeURIComponent(objCurrDistrict.districtNo); // edited by gab ramos 07.28.2015
				tbgBlock._refreshList();	
				//$("blockDiv").show();
			}else{
				tbgBlock.url = contextPath
				+ "/GIISBlockController?action=getGiiss007Block";
				tbgBlock._refreshList();	
				//$("blockDiv").hide();
			}
		} catch(e){
			showErrorMessage("setTbgBlock", e);
		}	
	}
	
	function setProvinceFieldValues(rec){
		try{
			$("txtProvinceCd").value = (rec == null ? "" : unescapeHTML2(rec.provinceCd));
			$("txtProvince").value = (rec == null ? "" : unescapeHTML2(rec.province));				
			$("txtProvinceCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.provinceCd)));
			$("txtProvince").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.province)));	
			
			rec == null ? $("txtProvinceCd").readOnly = false : $("txtProvinceCd").readOnly = true;
			rec == null ? enableButton("btnAddProvince") : disableButton("btnAddProvince");
			rec == null ? disableButton("btnDeleteProvince") : enableButton("btnDeleteProvince");
			rec == null ? enableSearch("imgSearchProvince") : disableSearch("imgSearchProvince");			
			
			objCurrProvince = rec;
		} catch(e){
			showErrorMessage("setProvinceFieldValues", e);
		}		
	}
	
	function setCityFieldValues(rec){
		try{
			$("txtCityCd").value = (rec == null ? "" : unescapeHTML2(rec.cityCd));
			$("txtCity").value = (rec == null ? "" : unescapeHTML2(rec.city));				
			$("txtCityCd").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.cityCd)));
			$("txtCity").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.city)));	
			
			if($F("txtProvinceCd").trim() != ""){
				rec == null ? $("txtCityCd").readOnly = false : $("txtCityCd").readOnly = true;
				rec == null ? enableButton("btnAddCity") : disableButton("btnAddCity");
				rec == null ? disableButton("btnDeleteCity") : enableButton("btnDeleteCity");
				rec == null ? enableSearch("imgSearchCity") : disableSearch("imgSearchCity");	
			}
			objCurrCity = rec;
		} catch(e){
			showErrorMessage("setProvinceFieldValues", e);
		}		
	}
	
	function setDistrictFieldValues(rec){
		try{
			$("txtDistrictNo").value = (rec == null ? "" : unescapeHTML2(rec.districtNo));
			$("txtDistrictDesc").value = (rec == null ? "" : unescapeHTML2(rec.districtDesc));	
			$("txtSheetNo").value = (rec == null ? "" : unescapeHTML2(rec.sheetNo));
			
			if($F("txtCityCd").trim() != ""){
				rec == null ? $("txtDistrictNo").readOnly = false : $("txtDistrictNo").readOnly = true;			
				rec == null ? $("btnAddDistrict").value = "Add" : $("btnAddDistrict").value = "Update";					
				rec == null ? disableButton("btnDeleteDistrict") : enableButton("btnDeleteDistrict");
				rec == null ? $("chkActiveTag").disable() : $("chkActiveTag").enable();
			}
			objCurrDistrict = rec;
		} catch(e){
			showErrorMessage("setDistrictFieldValues", e);
		}		
	}
	
	function setBlockFieldValues(rec){
		try{
			$("txtBlockId").value = (rec == null ? "" : rec.blockId);
			$("txtBlockNo").value = (rec == null ? "" : unescapeHTML2(rec.blockNo));			
			$("txtBlockDesc").value = (rec == null ? "" : unescapeHTML2(rec.blockDesc));	
			$("txtEqZone").value = (rec == null ? "" : unescapeHTML2(rec.eqZone));	
			$("txtEqZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.eqZoneDesc));
			$("txtFloodZone").value = (rec == null ? "" : unescapeHTML2(rec.floodZone));
			$("txtFloodZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.floodZoneDesc));
			$("txtTyphoonZone").value = (rec == null ? "" : unescapeHTML2(rec.typhoonZone));
			$("txtTyphoonZoneDesc").value = (rec == null ? "" : unescapeHTML2(rec.typhoonZoneDesc));
			$("txtRetnLimAmt").value = (rec == null ? formatCurrency(0) : formatCurrency(rec.retnLimAmt));
			$("txtTrtyLimAmt").value = (rec == null ? formatCurrency(0) : formatCurrency(rec.trtyLimAmt));
			//$("txtSheetNo").value = (rec == null ? "" : unescapeHTML2(rec.sheetNo));
			$("txtNetretBegBal").value = (rec == null ? formatCurrency(0) : formatCurrency(rec.netretBegBal));
			$("txtFaculBegBal").value = (rec == null ? formatCurrency(0) : formatCurrency(rec.faculBegBal));
			$("txtTrtyBegBal").value = (rec == null ? formatCurrency(0) : formatCurrency(rec.trtyBegBal));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			$("chkActiveTag").checked = (rec == null ? true : rec.activeTag == "Y" ? true : false);
			
			$("txtEqZone").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.eqZone)));
			$("txtEqZoneDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.eqZoneDesc)));
			$("txtFloodZone").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.floodZone)));
			$("txtFloodZoneDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.floodZoneDesc)));
			$("txtTyphoonZone").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.typhoonZone)));
			$("txtTyphoonZoneDesc").setAttribute("lastValidValue", (rec == null ? "" : unescapeHTML2(rec.typhoonZoneDesc)));
			
			rec == null ? $("btnAddBlock").value = "Add" : $("btnAddBlock").value = "Update";
			rec == null ? disableButton("btnDeleteBlock") : enableButton("btnDeleteBlock");
			rec == null ? disableButton("btnRisk") : enableButton("btnRisk");
			rec == null ? $("txtBlockNo").readOnly = false : $("txtBlockNo").readOnly = true;
			//rec == null ? $("txtIssCd").readOnly = false : $("txtIssCd").readOnly = true;
			//rec == null ? enableSearch("imgSearchIssueSource") : disableSearch("imgSearchIssueSource");
			objCurrBlock = rec;
		} catch(e){
			showErrorMessage("setBlockFieldValues", e);
		}
	}
	
	function getGiiss007ProvinceLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss007ProvinceLOV",
				searchString : ($("txtProvinceCd").readAttribute("lastValidValue") != $F("txtProvinceCd") ? nvl($F("txtProvinceCd"),"%") : "%"),
				page : 1,				
			},
			title : "List of Provinces",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "provinceCd",
				title : "Province Code",
				width : '135px'
			},{
				id : "province",
				title : "Province",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$F("txtProvinceCd").toUpperCase(),
			onSelect : function(row) {
				$("txtProvinceCd").value = unescapeHTML2(row.provinceCd);	
				$("txtProvince").value = unescapeHTML2(row.province);				
				$("txtProvinceCd").setAttribute("lastValidValue", unescapeHTML2(row.provinceCd));
				$("btnAddProvince").focus();
			},
			onCancel : function() {
				$("txtProvinceCd").value = $("txtProvinceCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtProvinceCd");	
				$("txtProvinceCd").value = $("txtProvinceCd").getAttribute("lastValidValue"); 	
				/* $("txtProvinceCd").value = "";	
				$("txtProvince").value = "";	
				$("txtProvinceCd").setAttribute("lastValidValue", "");
				$("txtProvince").setAttribute("lastValidValue", ""); */
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}	
	
	function getGiiss007CityLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss007CityLOV",
				searchString : ($("txtCityCd").readAttribute("lastValidValue") != $F("txtCityCd") ? nvl($F("txtCityCd"),"%") : "%"),
				provinceCd : unescapeHTML2(objCurrProvince.provinceCd),
				page : 1,				
			},
			title : "List of Cities",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "cityCd",
				title : "City Code",
				width : '135px'
			},{
				id : "city",
				title : "City",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$F("txtCityCd").toUpperCase(),
			onSelect : function(row) {
				$("txtCityCd").value = unescapeHTML2(row.cityCd);	
				$("txtCity").value = unescapeHTML2(row.city);				
				$("txtCityCd").setAttribute("lastValidValue", unescapeHTML2(row.cityCd));
				$("btnAddCity").focus();
			},
			onCancel : function() {
				$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");
// 				$("txtCity").value = $("txtCity").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtCityCd");	
				/* $("txtCityCd").value = "";	
				$("txtCity").value = "";	
				$("txtCityCd").setAttribute("lastValidValue", "");
				$("txtCity").setAttribute("lastValidValue", ""); */
				$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");	
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function getGiiss007EqZoneLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss007EqZoneLOV",
				searchString : ($("txtEqZone").readAttribute("lastValidValue") != $F("txtEqZone") ? nvl($F("txtEqZone"),"%") : "%"),
				page : 1,				
			},
			title : "List of E-Quake Zones",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "eqZone",
				title : "Eq Zone",
				width : '135px'
			},{
				id : "eqDesc",
				title : "Eq Desc",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$F("txtEqZone").toUpperCase(),
			onSelect : function(row) {
				$("txtEqZone").value = unescapeHTML2(row.eqZone);	
				$("txtEqZoneDesc").value = unescapeHTML2(row.eqDesc);				
				$("txtEqZone").setAttribute("lastValidValue", unescapeHTML2(row.eqZone));
				$("txtEqZone").focus();
			},
			onCancel : function() {
				$("txtEqZone").value = $("txtEqZone").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtEqZone");	
				$("txtEqZone").value = $("txtEqZone").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function getGiiss007FloodZoneLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss007FloodZoneLOV",
				searchString : ($("txtFloodZone").readAttribute("lastValidValue") != $F("txtFloodZone") ? nvl($F("txtFloodZone"),"%") : "%"),
				page : 1,				
			},
			title : "List of Flood Zones",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "floodZone",
				title : "Flood Zone",
				width : '135px'
			},{
				id : "floodZoneDesc",
				title : "Flood Zone Desc",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$F("txtFloodZone").toUpperCase(),
			onSelect : function(row) {
				$("txtFloodZone").value = unescapeHTML2(row.floodZone);	
				$("txtFloodZoneDesc").value = unescapeHTML2(row.floodZoneDesc);				
				$("txtFloodZone").setAttribute("lastValidValue", unescapeHTML2(row.floodZone));
				$("txtFloodZone").focus();
			},
			onCancel : function() {
				$("txtFloodZone").value = $("txtFloodZone").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtFloodZone");	
				$("txtFloodZone").value = $("txtFloodZone").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function getGiiss007TyphoonZoneLOV() {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGiiss007TyphoonZoneLOV",
				searchString : ($("txtTyphoonZone").readAttribute("lastValidValue") != $F("txtTyphoonZone") ? nvl($F("txtTyphoonZone"),"%") : "%"),
				page : 1,				
			},
			title : "List of Typhoon Zones",
			width : 416,
			height : 390,
			columnModel : [ {
				id : "typhoonZone",
				title : "Typhoon Zone",
				width : '135px'
			},{
				id : "typhoonZoneDesc",
				title : "Typhoon Zone Desc",
				width : '250px'
			}  ],
			draggable : true,
			autoSelectOneRecord : true,
			filterText :$F("txtFloodZone").toUpperCase(),
			onSelect : function(row) {
				$("txtTyphoonZone").value = unescapeHTML2(row.typhoonZone);	
				$("txtTyphoonZoneDesc").value = unescapeHTML2(row.typhoonZoneDesc);				
				$("txtTyphoonZone").setAttribute("lastValidValue", unescapeHTML2(row.typhoonZone));
				$("txtTyphoonZone").focus();
			},
			onCancel : function() {
				$("txtTyphoonZone").value = $("txtTyphoonZone").readAttribute("lastValidValue");
			},
			onUndefinedRow : function() {
				customShowMessageBox("No record selected.", imgMessage.INFO,
						"txtTyphoonZone");	
				$("txtTyphoonZone").value = $("txtTyphoonZone").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function getGiiss007RisksDetails() {
		try {
			overlayRisksDetails = Overlay.show(contextPath
					+ "/GIISBlockController", {
				urlContent : true,
				urlParameters : {
					action : "getGiiss007RisksDetails",
					blockId : objCurrBlock.blockId
				},
				title : "Risks Details",
				height : 430,
				width : 524,
				draggable : true
			});
		} catch (e) {
			showErrorMessage("overlay error: ", e);
		}
	}

	function valAddRecProvince() {
		try {
			if (checkAllRequiredFieldsInDiv("provinceFormDiv")) {
				var addedSameExists = false;				
				for ( var i = 0; i < tbgProvince.geniisysRows.length; i++) {	
					if (tbgProvince.geniisysRows[i].provinceCd == $F("txtProvinceCd")&&tbgProvince.geniisysRows[i].recordStatus != -1) {
						addedSameExists = true;
					}							
				}
				if ((addedSameExists)) {
					showMessageBox(
							"Record already exists with the same province_cd.",
							"E");
					return;
				}
				addRecProvince();
			}	
		} catch (e) {
			showErrorMessage("valAddRecProvince", e);
		}
	}
	
	function valAddRecCity() {
		try {
			if (checkAllRequiredFieldsInDiv("cityFormDiv")) {
				var addedSameExists = false;				
				for ( var i = 0; i < tbgCity.geniisysRows.length; i++) {	
					if (tbgCity.geniisysRows[i].cityCd == $F("txtCityCd")&&tbgCity.geniisysRows[i].recordStatus != -1) {
						addedSameExists = true;
					}							
				}
				if ((addedSameExists)) {
					showMessageBox("Record already exists with the same city_cd.", "E");
					return;
				}
				addRecCity();
			}	
		} catch (e) {
			showErrorMessage("valAddRecCity", e);
		}
	}
	
	function valAddRecDistrict() {
		try {
			if (checkAllRequiredFieldsInDiv("districtFormDiv")) {
				if ($F("btnAddDistrict") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgDistrict.geniisysRows.length; i++) {	
						if (unescapeHTML2(tbgDistrict.geniisysRows[i].districtNo) == unescapeHTML2($F("txtDistrictNo")) && tbgDistrict.geniisysRows[i].recordStatus != -1) {
							addedSameExists = true;
						}
						if (unescapeHTML2(tbgDistrict.geniisysRows[i].districtNo) == unescapeHTML2($F("txtDistrictNo")) && tbgDistrict.geniisysRows[i].recordStatus == -1) {
							deletedSameExists = true;
						}
					}
					if ((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same district_no.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRecDistrict();
						return;
					}
					
					new Ajax.Request(contextPath + "/GIISBlockController", {
						parameters : {
							action : "valAddRecDistrict",
							provinceCd : $F("txtProvinceCd"),
							cityCd : $F("txtCityCd"),
							districtNo : $F("txtDistrictNo")
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)) {
								addRecDistrict();
							}
						}
					});
				}else{
					updateRecDistrict();					
				}
			}	
		} catch (e) {
			showErrorMessage("valAddRecDistrict", e);
		}
	}
	
	function valAddRecBlock() {
		try {					
			if (checkAllRequiredFieldsInDiv("blockFormDiv")) {
				if ($F("btnAddBlock") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;
					for ( var i = 0; i < tbgBlock.geniisysRows.length; i++) {	
						if (unescapeHTML2(tbgBlock.geniisysRows[i].blockNo) == $F("txtBlockNo")&&tbgBlock.geniisysRows[i].recordStatus != -1) {
							addedSameExists = true;
						}
						if (unescapeHTML2(tbgBlock.geniisysRows[i].blockNo) == $F("txtBlockNo")&&tbgBlock.geniisysRows[i].recordStatus == -1) {
							deletedSameExists = true;
						}
					}
					if ((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)) {
						showMessageBox("Record already exists with the same province_cd, city_cd, district_no and block_no.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRecBlock();
						return;
					}
				
					new Ajax.Request(contextPath + "/GIISBlockController", {
						parameters : {
							action : "valAddRecBlock",
							provinceCd : $F("txtProvinceCd"),
							cityCd : $F("txtCityCd"),
							districtNo : $F("txtDistrictNo"),
							blockNo : $F("txtBlockNo")							
						},
						onCreate : showNotice("Processing, please wait..."),
						onComplete : function(response) {
							hideNotice();
							if (checkCustomErrorOnResponse(response)
									&& checkErrorOnResponse(response)) {
								addRecBlock();
							}
						}
					});
				} else {					
					addRecBlock();
				}
			}			
		} catch (e) {
			showErrorMessage("valAddRecBlock", e);
		}
	}
	
	function checkChangesTbg(tbg){
		if(tbg=="Province"){	
			if(hasChangesInTbg("City") || hasChangesInTbg("District") || hasChangesInTbg("Block")){
				return true;
			}else{
				return false;
			}
		}else if(tbg=="City"){
			if(hasChangesInTbg("District") || hasChangesInTbg("Block")){
				return true;
			}else{
				return false;
			}
		}else if(tbg=="District"){
			if(hasChangesInTbg("Block")){
				return true;
			}else{
				return false;
			}
		}
	}
	
	function hasChangesInTbg(tbg){
		if(tbg=="Province"){			
			if(getDeletedJSONObjects(tbgProvince.geniisysRows) != "" ||getAddedAndModifiedJSONObjects(tbgProvince.geniisysRows)!= ""){
				return true;
			}else{
				return false;
			}
		}else if(tbg=="City"){			
			if(getDeletedJSONObjects(tbgCity.geniisysRows) != "" ||getAddedAndModifiedJSONObjects(tbgCity.geniisysRows)!= ""){
				return true;
			}else{
				return false;
			}
		}else if(tbg=="District"){
			if(getDeletedJSONObjects(tbgDistrict.geniisysRows) != "" ||getAddedAndModifiedJSONObjects(tbgDistrict.geniisysRows)!= ""){
				return true;
			}else{
				return false;
			}
		}else if(tbg=="Block"){
			if(getDeletedJSONObjects(tbgBlock.geniisysRows) != "" ||getAddedAndModifiedJSONObjects(tbgBlock.geniisysRows)!= ""){
				return true;
			}else{
				return false;
			}
		}
	}
	
	function addRecProvince(){
		try {
			changeTag = 1;
			changeTagAddParent = 1;
			changeTagFunc = saveGiiss007;
			var rec = setRecProvince(objCurrProvince);
			tbgProvince.addBottomRow(rec);			
			tbgProvince.selectRow(tbgProvince.geniisysRows.length-1);		
			rowIndexProvince = tbgProvince.geniisysRows.length-1;
			objCurrProvince = tbgProvince.geniisysRows[tbgProvince.geniisysRows.length-1];
			selected.objCurrProvince = objCurrProvince; //Added by MarkS 9.26.2016 SR-5475
			setProvinceFieldValues(objCurrProvince);
			setTbgCity(objCurrProvince);
			enableFields("City");
			objCurrProvince.oldCellFocus = "mtgC1_2,"+(tbgProvince.geniisysRows.length-1).toString();
			$("txtCityCd").focus();
		} catch(e){
			showErrorMessage("addRecProvince", e);
		}
	}	
	
	function addRecCity(){
		try {
			changeTag = 1;
			changeTagAddParent = 1;
			changeTagFunc = saveGiiss007;
			var rec = setRecCity(objCurrCity);
			tbgCity.addBottomRow(rec);		
			tbgCity.selectRow(tbgCity.geniisysRows.length-1);	
			rowIndexCity = tbgCity.geniisysRows.length-1;
			objCurrCity = tbgCity.geniisysRows[tbgCity.geniisysRows.length-1];
			selected.objCurrCity = objCurrCity; //Added by MarkS 9.26.2016 SR-5475
			setCityFieldValues(objCurrCity);
			setTbgDistrict(objCurrCity);
			enableFields("District");
			objCurrCity.oldCellFocus = "mtgC2_2,"+(tbgCity.geniisysRows.length-1).toString();
			$("txtDistrictNo").focus();
		} catch(e){
			showErrorMessage("addRecCity", e);
		}
	}		
	
	function updateRecDistrict(){
		var rec = setRecDistrict(objCurrDistrict);
		tbgDistrict.updateVisibleRowOnly(rec, rowIndexDistrict, false);
		tbgDistrict.selectRow(rowIndexDistrict);
		changeTag = 1;
		changeTagUpdateDistrict = 1;
		changeTagFunc = saveGiiss007;
		$("txtBlockNo").focus();
	}
	
	function addRecDistrict(){
		try {
			changeTag = 1;
			changeTagAddParent = 1;
			changeTagFunc = saveGiiss007;
			var dept = setRecDistrict(objCurrDistrict);
			tbgDistrict.addBottomRow(dept);	
			tbgDistrict.selectRow(tbgDistrict.geniisysRows.length-1);	
			rowIndexDistrict = tbgDistrict.geniisysRows.length-1;
			objCurrDistrict = tbgDistrict.geniisysRows[tbgDistrict.geniisysRows.length-1];
			selected.objCurrDistrict = objCurrDistrict; //Added by MarkS 9.26.2016 SR-5475
			setDistrictFieldValues(objCurrDistrict);
			setTbgBlock(objCurrDistrict);
			enableFields("Block");
			objCurrDistrict.oldCellFocus = "mtgC3_2,"+(tbgDistrict.geniisysRows.length-1).toString();
			$("txtBlockNo").focus();
		} catch(e){
			showErrorMessage("addRecDistrict", e);
		}
	}

	function addRecBlock(){
		try {
			
			var dept = setRecBlock(objCurrBlock);
			if($F("btnAddBlock") == "Add"){
				tbgBlock.addBottomRow(dept);
			} else {
				tbgBlock.updateVisibleRowOnly(dept, rowIndexBlock, false);
			}
			changeTag = 1;
			changeTag2 = 1;
			changeTagFunc = saveGiiss007;
			setBlockFieldValues(null);
			tbgBlock.keys.removeFocus(tbgBlock.keys._nCurrentFocus, true);
			tbgBlock.keys.releaseKeys();			
		} catch(e){
			showErrorMessage("addRecBlock", e);
		}
	}		

	function valDeleteRecProvince() {
		try {
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {
					action : "valDeleteRecProvince",
					provinceCd : unescapeHTML2(objCurrProvince.provinceCd)
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRecProvince();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRecProvince", e);
		}
	}
	
	function valDeleteRecCity() {
		try {
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {
					action : "valDeleteRecCity",
					provinceCd : unescapeHTML2(objCurrProvince.provinceCd),
					cityCd : objCurrCity.cityCd
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRecCity();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRecCity", e);
		}
	}
	
	function valDeleteRecDistrict() {
		try {
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {
					action : "valDeleteRecDistrict",
					provinceCd : unescapeHTML2(objCurrProvince.provinceCd),
					cityCd : objCurrCity.cityCd,
					districtNo : objCurrDistrict.districtNo
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRecDistrict();
					}
				}
			});
		} catch (e) {
			showErrorMessage("valDeleteRecDistrict", e);
		}
	}
	
	function valDeleteRecBlock() {
		try {
			new Ajax.Request(contextPath + "/GIISBlockController", {
				parameters : {
					action : "valDeleteRecBlock",
					blockId : objCurrBlock.blockId
				},
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response) {
					hideNotice();
					if (checkCustomErrorOnResponse(response)
							&& checkErrorOnResponse(response)) {
						deleteRecBlock();
					}
				}
			});		
		} catch (e) {
			showErrorMessage("valDeleteRecBlock", e);
		}
	}
	
	function deleteRecProvince() {	
		changeTag = 1;
		changeTagAddParent = 0;
		objCurrProvince.recordStatus = -1;
		tbgProvince.deleteRow(rowIndexProvince);
		tbgProvince.geniisysRows[rowIndexProvince].provinceCd = escapeHTML2($F("txtProvinceCd"));
		selected.objCurrProvince = null; //Added by MarkS 9.26.2016 SR-5475
		setProvinceFieldValues(null);
		setTbgCity(null);
		disableFields("City");
		changeTagFunc = saveGiiss007;
	}
	
	function deleteRecCity() {
		changeTag = 1;
		changeTagAddParent = 0;
		objCurrCity.recordStatus = -1;
		tbgCity.deleteRow(rowIndexCity);
		tbgCity.geniisysRows[rowIndexCity].provinceCd = escapeHTML2($F("txtProvinceCd"));
		tbgCity.geniisysRows[rowIndexCity].cityCd = escapeHTML2($F("txtCityCd"));
		selected.objCurrCity = null; //Added by MarkS 9.26.2016 SR-5475
		setCityFieldValues(null);
		setTbgDistrict(null);
		disableFields("District");
		changeTagFunc = saveGiiss007;
	}
	
	function deleteRecDistrict() {
		changeTag = 1;
		changeTagAddParent = 0;
		changeTagFunc = saveGiiss007;
		objCurrDistrict.recordStatus = -1;
		tbgDistrict.deleteRow(rowIndexDistrict);
		tbgDistrict.geniisysRows[rowIndexDistrict].provinceCd = escapeHTML2($F("txtProvinceCd"));
		tbgDistrict.geniisysRows[rowIndexDistrict].cityCd = escapeHTML2($F("txtCityCd"));
		tbgDistrict.geniisysRows[rowIndexDistrict].districtNo = escapeHTML2($F("txtDistrictNo"));
		selected.objCurrDistrict = null; //Added by MarkS 9.26.2016 SR-5475
		setDistrictFieldValues(null);
		setTbgBlock(null);
		disableFields("Block");
		changeTagFunc = saveGiiss007;
	}
	
	function deleteRecBlock() {
		changeTag = 1;
		changeTagFunc = saveGiiss007;
		objCurrBlock.recordStatus = -1;
		tbgBlock.deleteRow(rowIndexBlock);
		changeTag2 = 1;
		setBlockFieldValues(null);
	}
	
	function setRecProvince(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
			obj.province = escapeHTML2($F("txtProvince"));								
			return obj;
		} catch(e){
			showErrorMessage("setRecProvince", e);
		}
	}
		
	function setRecCity(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
			obj.cityCd = escapeHTML2($F("txtCityCd"));
			obj.city = escapeHTML2($F("txtCity"));								
			return obj;
		} catch(e){
			showErrorMessage("setRecCity", e);
		}
	}
	
	function setRecDistrict(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
			obj.cityCd = escapeHTML2($F("txtCityCd"));
			obj.districtNo = escapeHTML2($F("txtDistrictNo"));
			obj.districtDesc = escapeHTML2($F("txtDistrictDesc"));
			obj.sheetNo = escapeHTML2($F("txtSheetNo"));
			return obj;
		} catch(e){
			showErrorMessage("setRecDistrict", e);
		}
	}
	
	function setRecBlock(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
			obj.cityCd = escapeHTML2($F("txtCityCd"));
			obj.districtNo = escapeHTML2($F("txtDistrictNo"));
			obj.blockId = (rec == null ? "" : obj.blockId);
			obj.blockNo = escapeHTML2($F("txtBlockNo"));
			obj.blockDesc = escapeHTML2($F("txtBlockDesc"));
			obj.retnLimAmt = parseFloat($F("txtRetnLimAmt").replace(/,/g, ""));		
			obj.trtyLimAmt = parseFloat($F("txtTrtyLimAmt").replace(/,/g, ""));		
			obj.netretBegBal = parseFloat($F("txtNetretBegBal").replace(/,/g, ""));		
			obj.faculBegBal = parseFloat($F("txtFaculBegBal").replace(/,/g, ""));		
			obj.trtyBegBal = parseFloat($F("txtTrtyBegBal").replace(/,/g, ""));		
			obj.eqZone = escapeHTML2($F("txtEqZone"));	
			obj.eqZoneDesc = escapeHTML2($F("txtEqZoneDesc"));
			obj.floodZone = escapeHTML2($F("txtFloodZone"));
			obj.floodZoneDesc = escapeHTML2($F("txtFloodZoneDesc"));
			obj.typhoonZone = escapeHTML2($F("txtTyphoonZone"));	
			obj.typhoonZoneDesc = escapeHTML2($F("txtTyphoonZoneDesc"));	
			obj.sheetNo = escapeHTML2($F("txtSheetNo"));
			obj.districtDesc = escapeHTML2($F("txtDistrictDesc"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.province = escapeHTML2($F("txtProvince"));
			obj.city = escapeHTML2($F("txtCity"));
			obj.activeTag = escapeHTML2("Y");
			obj.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');	
			obj.activeTag = $("chkActiveTag").checked ? "Y" : "N";
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}

	function exitPage() {
		goToModule("/GIISUserController?action=goToUnderwriting",
				"Underwriting Main", null);
	}

	function cancelGiiss007() {
		if (changeTag == 1 || changeTag2 == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						objGIISS007.exitPage = exitPage;
						saveGiiss007();
					}, function() {
						goToModule(
								"/GIISUserController?action=goToUnderwriting",
								"Underwriting Main", null);
					}, "");
		} else {
			goToModule("/GIISUserController?action=goToUnderwriting",
					"Underwriting Main", null);
		}
	}
	
	
		
	function setAllFieldsValue(field){	
	}
	
	function disableFields(field){
		if(field == "City"){
			$("txtCityCd").readOnly = true;
			$("txtCityCd").value = "";
			$("txtCityCd").setAttribute("lastValidValue", "");
			$("txtCity").value = "";	
			$("txtCity").setAttribute("lastValidValue", "");
			disableSearch("imgSearchCity");	
			disableFields("District");
			disableButton("btnAddCity");
			disableButton("btnDeleteCity");
			//$("txtCityCd").disabled = true;
			//$("txtCityCd").setStyle({backgroundColor: '#F0F0F0'});
			//$("txtCity").disabled = true;
			//$("txtCity").setStyle({backgroundColor: '#F0F0F0'});
		}else if(field == "District"){
			$("txtDistrictNo").readOnly = true;
			$("txtDistrictNo").value = "";
			$("txtDistrictNo").setAttribute("lastValidValue", "");
			$("txtDistrictDesc").readOnly = true;
			$("txtDistrictDesc").value = "";	
			$("txtDistrictDesc").setAttribute("lastValidValue", "");
			$("txtSheetNo").readOnly = true;
			$("txtSheetNo").value = "";
			disableFields("Block");
			disableButton("btnAddDistrict");
			disableButton("btnDeleteDistrict");
			//$("txtDistrictNo").disabled = true;
			//$("txtDistrictNo").setStyle({backgroundColor: '#F0F0F0'});
			//$("txtDistrictDesc").disabled = true;
			//$("txtDistrictDesc").setStyle({backgroundColor: '#F0F0F0'});
		}else if(field == "Block"){
			//$("txtSheetNo").readOnly = true;
			$("txtBlockDesc").readOnly = true;
			$("txtEqZone").readOnly = true;
			$("txtEqZone").setAttribute("lastValidValue", "");
			$("txtEqZoneDesc").setAttribute("lastValidValue", "");
			$("txtFloodZone").readOnly = true;			
			$("txtFloodZone").setAttribute("lastValidValue","");
			$("txtFloodZoneDesc").setAttribute("lastValidValue","");
			$("txtTyphoonZone").readOnly = true;
			$("txtTyphoonZone").setAttribute("lastValidValue","");
			$("txtRetnLimAmt").readOnly = true;
			$("txtTrtyLimAmt").readOnly = true;
			$("txtNetretBegBal").readOnly = true;
			$("txtFaculBegBal").readOnly = true;
			$("txtTrtyBegBal").readOnly = true;
			$("txtRemarks").readOnly = true;
			disableSearch("imgSearchEqZone");
			disableSearch("imgSearchFloodZone");
			disableSearch("imgSearchTyphoonZone");
			disableEdit("editRemarks");
			setBlockFieldValues(null);
			disableButton("btnAddBlock");
			disableButton("btnDeleteBlock");
			disableButton("btnRisk");
			$("txtBlockNo").readOnly = true;
			/* $("txtSheetNo").disabled = true;
			$("txtSheetNo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtBlockId").setStyle({backgroundColor: '#F0F0F0'});
			$("txtBlockNo").disabled = true;
			$("txtBlockNo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtBlockDesc").disabled = true;
			$("txtBlockDesc").setStyle({backgroundColor: '#F0F0F0'});
			$("txtEqZone").disabled = true;
			$("txtEqZone").setStyle({backgroundColor: '#F0F0F0'});
			$("txtEqZoneDesc").disabled = true;
			$("txtEqZoneDesc").setStyle({backgroundColor: '#F0F0F0'});
			$("txtFloodZone").disabled = true;
			$("txtFloodZone").setStyle({backgroundColor: '#F0F0F0'});
			$("txtFloodZoneDesc").disabled = true;
			$("txtFloodZoneDesc").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTyphoonZone").disabled = true;
			$("txtTyphoonZone").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTyphoonZoneDesc").disabled = true;
			$("txtTyphoonZoneDesc").setStyle({backgroundColor: '#F0F0F0'});
			$("txtRetnLimAmt").disabled = true;
			$("txtRetnLimAmt").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTrtyLimAmt").disabled = true;
			$("txtTrtyLimAmt").setStyle({backgroundColor: '#F0F0F0'});
			$("txtNetretBegBal").disabled = true;
			$("txtNetretBegBal").setStyle({backgroundColor: '#F0F0F0'});
			$("txtFaculBegBal").disabled = true;
			$("txtFaculBegBal").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTrtyBegBal").disabled = true;
			$("txtTrtyBegBal").setStyle({backgroundColor: '#F0F0F0'});
			$("txtRemarks").disabled = true;
			$("txtRemarks").setStyle({backgroundColor: '#F0F0F0'});
			$("txtUserId").disabled = true;
			$("txtUserId").setStyle({backgroundColor: '#F0F0F0'});
			$("txtLastUpdate").disabled = true;
			$("txtLastUpdate").setStyle({backgroundColor: '#F0F0F0'}); */
		}
	}
	
	function enableFields(field){
		if(field == "City"){
			$("txtCityCd").readOnly = false;
			$("txtCityCd").value = "";
			$("txtCityCd").setAttribute("lastValidValue", "");
			$("txtCity").value = "";	
			$("txtCity").setAttribute("lastValidValue", "");
			enableSearch("imgSearchCity");
			enableButton("btnAddCity");
			disableButton("btnDeleteCity");
			//$("txtCityCd").disabled = false;
			//$("txtCityCd").setStyle({backgroundColor: '#FFFACD'});
			//$("txtCity").disabled = false;
			//$("txtCity").setStyle({backgroundColor: 'white'});
			//$("imgSearchCity").setStyle({backgroundColor: '#FFFACD'});
		}else if(field == "District"){
			$("txtDistrictNo").readOnly = false;
			$("txtDistrictNo").value = "";
			$("txtDistrictNo").setAttribute("lastValidValue", "");
			$("txtDistrictDesc").readOnly = false;
			$("txtDistrictDesc").value = "";	
			$("txtDistrictDesc").setAttribute("lastValidValue", "");
			$("txtSheetNo").readOnly = false;
			$("txtSheetNo").value = "";
			enableButton("btnAddDistrict");
			disableButton("btnDeleteDistrict");
			//$("txtDistrictNo").disabled = false;
			//$("txtDistrictNo").setStyle({backgroundColor: '#FFFACD'});
			//$("txtDistrictDesc").disabled = false;
			//$("txtDistrictDesc").setStyle({backgroundColor: 'white'});
		}else if(field == "Block"){
			//$("txtSheetNo").readOnly = false;
			$("txtBlockNo").readOnly = false;
			$("txtBlockDesc").readOnly = false;
			$("txtEqZone").readOnly = false;
			$("txtEqZone").setAttribute("lastValidValue", "");
			$("txtEqZoneDesc").setAttribute("lastValidValue", "");			
			$("txtFloodZone").readOnly = false;
			$("txtFloodZone").setAttribute("lastValidValue","");
			$("txtFloodZoneDesc").setAttribute("lastValidValue","");
			$("txtTyphoonZone").readOnly = false;
			$("txtTyphoonZone").setAttribute("lastValidValue","");
			$("txtRetnLimAmt").readOnly = false;
			$("txtTrtyLimAmt").readOnly = false;
			$("txtNetretBegBal").readOnly = false;
			$("txtFaculBegBal").readOnly = false;
			$("txtTrtyBegBal").readOnly = false;
			$("txtRemarks").readOnly = false;
			enableSearch("imgSearchEqZone");
			enableSearch("imgSearchFloodZone");
			enableSearch("imgSearchTyphoonZone");
			enableEdit("editRemarks");
			setBlockFieldValues(null);
			enableButton("btnAddBlock");
			disableButton("btnDeleteBlock");
			$("chkActiveTag").checked = true;
			/* $("txtSheetNo").disabled = false;
			$("txtSheetNo").setStyle({backgroundColor: 'white'});
			$("txtBlockId").setStyle({backgroundColor: '#E0E0E0'});
			$("txtBlockNo").disabled = false;
			$("txtBlockNo").setStyle({backgroundColor: '#FFFACD'});
			$("txtBlockDesc").disabled = false;
			$("txtBlockDesc").setStyle({backgroundColor: '#FFFACD'});
			$("txtEqZone").disabled = false;
			$("txtEqZone").setStyle({backgroundColor: 'white'});
			$("txtEqZoneDesc").disabled = false;
			$("txtEqZoneDesc").setStyle({backgroundColor: 'white'});
			$("txtFloodZone").disabled = false;
			$("txtFloodZone").setStyle({backgroundColor: 'white'});
			$("txtFloodZoneDesc").disabled = false;
			$("txtFloodZoneDesc").setStyle({backgroundColor: 'white'});
			$("txtTyphoonZone").disabled = false;
			$("txtTyphoonZone").setStyle({backgroundColor: 'white'});
			$("txtTyphoonZoneDesc").disabled = false;
			$("txtTyphoonZoneDesc").setStyle({backgroundColor: 'white'});	
			$("txtRetnLimAmt").disabled = false;
			$("txtRetnLimAmt").setStyle({backgroundColor: 'white'});
			$("txtTrtyLimAmt").disabled = false;
			$("txtTrtyLimAmt").setStyle({backgroundColor: 'white'});
			$("txtNetretBegBal").disabled = false;
			$("txtNetretBegBal").setStyle({backgroundColor: 'white'});
			$("txtFaculBegBal").disabled = false;
			$("txtFaculBegBal").setStyle({backgroundColor: 'white'});
			$("txtTrtyBegBal").disabled = false;
			$("txtTrtyBegBal").setStyle({backgroundColor: 'white'});
			$("txtRemarks").disabled = false;
			$("txtRemarks").setStyle({backgroundColor: 'white'});			
			$("txtUserId").disabled = false;
			$("txtUserId").setStyle({backgroundColor: 'white'});
			$("txtLastUpdate").disabled = false;
			$("txtLastUpdate").setStyle({backgroundColor: 'white'}); */
		}
	}
	
	function printGIPIR804() {
		try {
			var fileType = $("rdoPdf").checked ? "PDF" : "XLS";
			var content = contextPath+"/MaintenanceReportsController?action=printReport"
			+"&noOfCopies="+$F("txtNoOfCopies")
			+"&printerName="+$F("selPrinter")
			+"&destination="+$F("selDestination")
			+"&reportId=GIPIR804"
			+"&fileType="+fileType;	
			printGenericReport(content, "BLOCK LISTING REPORT",function(){
				if($F("selDestination") == "printer"){
					showWaitingMessageBox("Printing complete.", imgMessage.SUCCESS, function(){
						overlayGenericPrintDialog.close();
					});
				}
			});
		} catch (e) {
			showErrorMessage("printGIPIR804",e);
		}
	}
	
	function initializeGiiss007(){
		$("txtProvinceCd").setAttribute("lastValidValue","");
		//disableToolbarButton("btnToolbarPrint");
		showToolbarButton("btnToolbarSave");
		$("btnToolbarEnterQuery").hide();
		$("btnToolbarExecuteQuery").hide();
		$("btnToolbarSaveSep").hide();
		$("btnToolbarEnterQuerySep").hide();
		$("txtProvinceCd").focus();
		disableFields("City");
		disableButton("btnDeleteProvince");
		//$("cityDiv").hide();
		//$("districtDiv").hide();
		//$("blockDiv").hide();
	}
				
	$("txtProvinceCd").observe("change", function() {
		if($F("txtProvinceCd").trim()!=""&& $("txtProvinceCd").value != $("txtProvinceCd").readAttribute("lastValidValue")){						
			getGiiss007ProvinceLOV();			
		}else if($F("txtProvinceCd").trim()==""){
			$("txtProvinceCd").value="";	
			$("txtProvinceCd").setAttribute("lastValidValue","");
			$("txtProvince").value="";			
			$("txtProvince").setAttribute("lastValidValue","");
		}					
	});		
		
	$("txtCityCd").observe("change", function() {
		if($F("txtCityCd").trim()!=""&& $("txtCityCd").value != $("txtCityCd").readAttribute("lastValidValue")){						
			getGiiss007CityLOV();			
		}else if($F("txtCityCd").trim()==""){
			$("txtCityCd").value="";	
			$("txtCityCd").setAttribute("lastValidValue","");
			$("txtCity").value="";	
			$("txtCity").setAttribute("lastValidValue","");
		}	
	});		
	
	$("txtDistrictNo").observe("change", function() {
		if($F("txtDistrictNo").trim()!=""){						
			$("txtDistrictNo").value = $F("txtDistrictNo").toUpperCase();
		}else if($F("txtDistrictNo").trim()==""){
			$("txtDistrictNo").value="";				
		}					
	});	
	
	$("txtDistrictNo").observe("keyup", function() {					
		$("txtDistrictNo").value = $F("txtDistrictNo").toUpperCase();				
	});	
	
	$("txtDistrictDesc").observe("change", function() {
		if($F("txtDistrictDesc").trim()!=""){						
			$("txtDistrictDesc").value = $F("txtDistrictDesc").toUpperCase();
		}else if($F("txtDistrictDesc").trim()==""){
			$("txtDistrictDesc").value="";				
		}					
	});	
	
	$("txtDistrictDesc").observe("keyup", function() {					
		$("txtDistrictDesc").value = $F("txtDistrictDesc").toUpperCase();				
	});	
	
	$("txtBlockNo").observe("change", function() {
		if($F("txtBlockNo").trim()!=""){						
			$("txtBlockNo").value = $F("txtBlockNo").toUpperCase();
		}else if($F("txtBlockNo").trim()==""){
			$("txtBlockNo").value="";				
		}					
	});	
	
	$("txtBlockNo").observe("keyup", function() {					
		$("txtBlockNo").value = $F("txtBlockNo").toUpperCase();				
	});	
	
	$("txtEqZone").observe("change", function() {
		if($F("txtEqZone").trim()!=""&& $("txtEqZone").value != $("txtEqZone").readAttribute("lastValidValue")){						
			getGiiss007EqZoneLOV();			
		}else if($F("txtEqZone").trim()==""){
			$("txtEqZone").value="";	
			$("txtEqZone").setAttribute("lastValidValue","");
			$("txtEqZoneDesc").value="";	
			$("txtEqZoneDesc").setAttribute("lastValidValue","");
		}					
	});				
	
	$("txtFloodZone").observe("change", function() {
		if($F("txtFloodZone").trim()!=""&& $("txtFloodZone").value != $("txtFloodZone").readAttribute("lastValidValue")){						
			getGiiss007FloodZoneLOV();			
		}else if($F("txtFloodZone").trim()==""){
			$("txtFloodZone").value="";	
			$("txtFloodZone").setAttribute("lastValidValue","");
			$("txtFloodZoneDesc").value="";	
			$("txtFloodZoneDesc").setAttribute("lastValidValue","");
		}					
	});		

	$("txtTyphoonZone").observe("change", function() {
		if($F("txtTyphoonZone").trim()!=""&& $("txtTyphoonZone").value != $("txtTyphoonZone").readAttribute("lastValidValue")){						
			getGiiss007TyphoonZoneLOV();			
		}else if($F("txtTyphoonZone").trim()==""){
			$("txtTyphoonZone").value="";	
			$("txtTyphoonZone").setAttribute("lastValidValue","");
			$("txtTyphoonZoneDesc").value="";	
			$("txtTyphoonZoneDesc").setAttribute("lastValidValue","");
		}					
	});	
	
	$("txtRetnLimAmt").observe("focus", function(){
		$("txtRetnLimAmt").setAttribute("lastValidValue", formatCurrency($F("txtRetnLimAmt")));
	});
	$("txtRetnLimAmt").observe("change", function(){	
		if(isNaN($F("txtRetnLimAmt").replace(/,/g, ""))){
			showWaitingMessageBox("Field Retention Limit must be of form 99,999,999,999,990.99.", "I", function() {
				$("txtRetnLimAmt").clear();
				$("txtRetnLimAmt").focus();
			});
		}else{			
			if (parseFloat($F("txtRetnLimAmt").replace(/,/g, "")) > 99999999999990.99 || parseFloat($F("txtRetnLimAmt").replace(/,/g, "")) < -99999999999990.99) {
				showWaitingMessageBox("Invalid Retention Limit. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.", "I",
						function() {
							$("txtRetnLimAmt").value = $("txtRetnLimAmt").readAttribute("lastValidValue");
							$("txtRetnLimAmt").focus();
						});
			}else{
				$("txtRetnLimAmt").value = formatCurrency($F("txtRetnLimAmt"));
			}
		}		
	});
	
	$("txtTrtyLimAmt").observe("focus", function(){
		$("txtTrtyLimAmt").setAttribute("lastValidValue", formatCurrency($F("txtTrtyLimAmt")));
	});
	$("txtTrtyLimAmt").observe("change", function(){	
		if(isNaN($F("txtTrtyLimAmt").replace(/,/g, ""))){
			showWaitingMessageBox("Field Treaty Limit must be of form 99,999,999,999,990.99.", "I", function() {
				$("txtTrtyLimAmt").clear();
				$("txtTrtyLimAmt").focus();
			});
		}else{			
			if (parseFloat($F("txtTrtyLimAmt").replace(/,/g, "")) > 99999999999990.99 || parseFloat($F("txtTrtyLimAmt").replace(/,/g, "")) < -99999999999990.99) {
				showWaitingMessageBox("Invalid Treaty Limit. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.", "I",
						function() {
							$("txtTrtyLimAmt").value = $("txtTrtyLimAmt").readAttribute("lastValidValue");
							$("txtTrtyLimAmt").focus();
						});
			}else{
				$("txtTrtyLimAmt").value = formatCurrency($F("txtTrtyLimAmt"));			
			}
		}		
	});
	
	$("txtNetretBegBal").observe("focus", function(){
		$("txtNetretBegBal").setAttribute("lastValidValue", formatCurrency($F("txtNetretBegBal")));
	});
	$("txtNetretBegBal").observe("change", function(){	
		if(isNaN($F("txtNetretBegBal").replace(/,/g, ""))){
			showWaitingMessageBox("Field Net Ret. Manual Balance must be of form 99,999,999,999,990.99.", "I", function() {
				$("txtNetretBegBal").clear();
				$("txtNetretBegBal").focus();
			});
		}else{			
			if (parseFloat($F("txtNetretBegBal").replace(/,/g, "")) > 99999999999990.99 || parseFloat($F("txtNetretBegBal").replace(/,/g, "")) < -99999999999990.99) {
				showWaitingMessageBox("Invalid Net Ret. Manual Balance. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.", "I",
						function() {
							$("txtNetretBegBal").value = $("txtNetretBegBal").readAttribute("lastValidValue");
							$("txtNetretBegBal").focus();
						});
			}else{
				$("txtNetretBegBal").value = formatCurrency($F("txtNetretBegBal"));			
			}
		}		
	});
	
	$("txtFaculBegBal").observe("focus", function(){
		$("txtFaculBegBal").setAttribute("lastValidValue", formatCurrency($F("txtFaculBegBal")));
	});
	$("txtFaculBegBal").observe("change", function(){	
		if(isNaN($F("txtFaculBegBal").replace(/,/g, ""))){
			showWaitingMessageBox("Field Facul Manual Balance must be of form 99,999,999,999,990.99.", "I", function() {
				$("txtFaculBegBal").clear();
				$("txtFaculBegBal").focus();
			});
		}else{			
			if (parseFloat($F("txtFaculBegBal").replace(/,/g, "")) > 99999999999990.99 || parseFloat($F("txtFaculBegBal").replace(/,/g, "")) < -99999999999990.99) {
				showWaitingMessageBox("Invalid Facul Manual Balance. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.", "I",
						function() {
							$("txtFaculBegBal").value = $("txtFaculBegBal").readAttribute("lastValidValue");
							$("txtFaculBegBal").focus();
						});
			}else{
				$("txtFaculBegBal").value = formatCurrency($F("txtFaculBegBal"));			
			}
		}		
	});
	
	$("txtTrtyBegBal").observe("focus", function(){
		$("txtTrtyBegBal").setAttribute("lastValidValue", formatCurrency($F("txtTrtyBegBal")));
	});
	$("txtTrtyBegBal").observe("change", function(){	
		if(isNaN($F("txtTrtyBegBal").replace(/,/g, ""))){
			showWaitingMessageBox("Field Treaty Manual Balance must be of form 99,999,999,999,990.99.", "I", function() {
				$("txtTrtyBegBal").clear();
				$("txtTrtyBegBal").focus();
			});
		}else{			
			if (parseFloat($F("txtTrtyBegBal").replace(/,/g, "")) > 99999999999990.99 || parseFloat($F("txtTrtyBegBal").replace(/,/g, "")) < -99999999999990.99) {
				showWaitingMessageBox("Invalid Treaty Manual Balance. Valid value should be from -99,999,999,999,990.99 to 99,999,999,999,990.99.", "I",
						function() {
							$("txtTrtyBegBal").value = $("txtTrtyBegBal").readAttribute("lastValidValue");
							$("txtTrtyBegBal").focus();
						});
			}else{
				$("txtTrtyBegBal").value = formatCurrency($F("txtTrtyBegBal"));			
			}
		}		
	});
	
	$("editRemarks").observe("click", function() {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});	
	
	$("imgSearchProvince").observe("click", function() {
		getGiiss007ProvinceLOV();
	});
	$("imgSearchCity").observe("click", function() {
		getGiiss007CityLOV();
	});	
	$("imgSearchEqZone").observe("click", function() {
		getGiiss007EqZoneLOV();
	});
	$("imgSearchFloodZone").observe("click", function() {
		getGiiss007FloodZoneLOV();
	});
	$("imgSearchTyphoonZone").observe("click", function() {
		getGiiss007TyphoonZoneLOV();
	});		
	
	$("btnRisk").observe("click", function(){
		if(changeTag == 1){
			showMessageBox("Please save changes first.", "I");			
		}else{
			getGiiss007RisksDetails();	
		}
	});	
	$("btnToolbarSave").stopObserving("click");
	$("btnToolbarSave").observe("click", saveGiiss007);
	$("btnSaveBlock").observe("click", saveGiiss007);
	$("btnCancelBlock").observe("click", cancelGiiss007);
	$("btnAddProvince").observe("click", valAddRecProvince);
	$("btnDeleteProvince").observe("click", valDeleteRecProvince);
	$("btnAddCity").observe("click", valAddRecCity);
	$("btnDeleteCity").observe("click", valDeleteRecCity);
	$("btnAddDistrict").observe("click", valAddRecDistrict);
	$("btnDeleteDistrict").observe("click", valDeleteRecDistrict);
	$("btnAddBlock").observe("click",valAddRecBlock);
	$("btnDeleteBlock").observe("click", valDeleteRecBlock);
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Block Listing", printGIPIR804, null, true);
	});	
	$("btnToolbarExit").stopObserving("click");
	$("btnToolbarExit").observe("click", function() {
		fireEvent($("btnCancelBlock"), "click");
	});
	
	$("reloadForm").observe("click", function() {
		if(changeTag == 1 || changeTag2 == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					showGiiss007, "");
		} else {
			showGiiss007();
		}
	});
	
	$("logout").stopObserving("click");
	
	$("logout").observe("click", function() {
		if(changeTag2 == 1){
			changeTag = 1;
			logout();
		}else{
			logout();
		}
	});

	initializeGiiss007();
</script>