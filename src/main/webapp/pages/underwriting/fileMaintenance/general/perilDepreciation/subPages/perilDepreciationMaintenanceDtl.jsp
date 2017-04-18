<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
	<div id="innerDiv" name="innerDiv">
		<label>Depreciation Maintenance</label>
		<span class="refreshers" style="margin-top: 0;">
			<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
		</span>
	</div>
</div>

<div class="sectionDiv" id="maintenanceDetailsSectionDiv" name="maintenanceDetailsSectionDiv">
	<div id="maintenanceDetailsDiv" name="maintenanceDetailsDiv">
		<div id="perilDepListingTableGridDiv"" style="height: 250px; border-bottom: 0px; position: relative; margin-left: 185px; margin-top: 10px; margin-bottom: 0px"></div>	
		<div align="center">
			<table border="0" style="margin-bottom: 0px;">
					<tr>
						<td class="rightAligned">Peril Code</td>
						<td class="leftAligned">
							<input type="hidden" id="txtLineCd" type="text" value="" name="txtLineCd"/>  
							<input type="hidden" id="txtSearchPeril" type="text" value="" name="txtSearchPeril"/>
							<input type="hidden" id="txtLastValidPerilCd" value="" style="width: 250px;"/>
							<input type="hidden" id="txtLastValidPerilName" value="" style="width: 250px;"/>
							<input type="hidden" id="txtLastValidDistributionRate" value="" style="width: 250px;"/> 
							<div id="perilCodeDiv" class="required" style="border: 1px solid gray; width: 100px; height: 21px; float: left; margin-right: 3px;">
								<input class="required" id="txtPerilCd" type="text" value="" style="width: 70px; height: 13px; float: left; border: none; margin-top: 0px;" name="txtPerilCd" maxlength="5" tabindex="201"/>
								<img id="btnSearchPeril" alt="Go" name="btnSearchPeril" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="202"> 
							</div>
						</td>
						<td class="rightAligned">Peril Name</td>
						<td class="leftAligned">
							<!-- <div class="required" style="border: 1px solid gray; width: 200px; height: 21px; float: left; margin-right: 3px;"> -->
								<input id="txtPerilName" readonly="readonly" type="text" value="" style="width: 193px; height: 13px; float: left;" name="txtPerilName" tabindex="203"/> 
								<!-- <img id="btnSearchPerilCode" alt="Go" name="btnSearchPerilCode" src="/Geniisys/images/misc/searchIcon.png" style="width: 19px; height: 19px; float: right;" tabindex="204"> -->
							<!-- </div> -->
						</td>
					</tr>
					<tr>
						<td class="rightAligned" >Depreciation Rate</td>
						<td class="leftAligned" colspan="3">
								<input class="required rightAligned" id="txtDistributionRate" type="text" value="" style="width: 381px;" name="txtDistributionRate" maxlength ="13" tabindex="205"/>
								
						</td>		
					</tr>
					<tr>
						<td class="rightAligned">Remarks</td>
						<td colspan="3" class="leftAligned">
							<div style="border: 1px solid gray; height: 21px; width: 387px;">
								<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 350px;" maxlength="4000"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned">
								<input readonly="readonly" id="txtUserId" type="text" value="" style="width: 100px; background-color: transparent;" name="txtUserId" txtUserId="" tabindex="206"/> 
						</td>
						<td class="rightAligned">Last Update</td>
						<td colspan="3" class="leftAligned">
								<input readonly="readonly" id="txtLastUpdate" type="text" value="" style="width: 193px; background-color: transparent;" name="txtLastUpdate" txtLastUpdate="" tabindex="207"/> 
						</td>
					</tr>					
				</table>	
		<div class="buttonsDiv" style="margin-bottom: 10px">
			<input type="button" id="btnAddPerilDepreciation" name="btnAddPerilDepreciation" 	class="button"	value="Add" tabindex="208"/>
			<input type="button" id="btnDeletePerilDepreciation" name="btnDeletePerilDepreciation"	class="button"	value="Delete" tabindex="209"/>
		</div>
	</div>	
	</div>
</div>

<script type="text/javascript">

	changeTag = 0;
	var changeCounter = 0;
	depRate = null;
	remarks = null;
	
	try{
		var selectedDtlRowIndex;
		var row = 0;
		var objPerilListMain = [];
		var objPerilList = new Object();
		perilListRow = [];
		objPerilList.objPerilListing = [];
		objPerilList.objPerilDepMaintenance = objPerilList.objPerilListing.rows || [];
		
		var perilListModelTG = {
				url: contextPath+"/GIEXPerilDepreciationController?action=getGiiss208PerilDepreciationList",
			options: {
            	id    : 'table2',
                title : '',
				width: '563px',
				height: '220px',
				onCellFocus: function(element, value, x, y, id){
					row = y;
				    objPerilMaintainance = perilListTableGrid.geniisysRows[y];
				    perilListTableGrid.keys.releaseKeys();
					populatePerilDetails(objPerilMaintainance);
					$("txtDistributionRate").focus();
					$("btnAddPerilDepreciation").value = "Update";
					enableButton("btnDeletePerilDepreciation");
					disableLov();
					$("txtLastValidDistributionRate").value = $F("txtDistributionRate");
				},
				onRemoveRowFocus: function(){
					perilListTableGrid.keys.releaseKeys();
					disableButton("btnDeletePerilDepreciation");
					clearFields();
					clearLastValidValues();
					$("txtPerilCd").focus();
					enableLov();
	            },
	            beforeSort: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	}
                },
                onSort: function(){
                	clearFields();	
                	clearLastValidValues();
                	$("txtPerilCd").focus();
                	disableButton("btnDeletePerilDepreciation");
                	enableLov();
                },
                prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	            		
                		clearFields();
                		clearLastValidValues();
                		$("txtPerilCd").focus();
                		disableButton("btnDeletePerilDepreciation");
                		enableLov();
                	}
                },
                onRefresh: function(){
                		clearFields();
                		clearLastValidValues();
                		$("txtPerilCd").focus();
                		disableButton("btnDeletePerilDepreciation");
                		enableLov();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
		            	if (changeTag == 1){
	                		showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
							return false;
	                	} else {
	                		disableButton("btnDeletePerilDepreciation");
	                		clearFields();
	                		$("txtPerilCd").focus();
	                		clearLastValidValues();
	                		enableLov();
	                	}
					}
				}
			},
            columnModel : [ 
       	                {   
       						id: 'recordStatus',
       					    width: '0',
       					    visible: false,
       					    editor: 'checkbox'},
       					{	
       						id: 'divCtrId',
       						width: '0',
       						visible: false},
       	            	{
	       	                id : 'lineCd',
	       	                title : 'Line Code',
	       	                width : '0',
	       				    visible: false,
	       	                filterOption : false},
       	                {
	       	                id : 'lineName',
	       	                title : 'Line Name',
	       	                width : '0',
	       				    visible: false,
	       	                filterOption : false},
       					{
	       	                id : 'perilCd',
	       	                title : 'Peril Code',
	       	                titleAlign: 'left',
	       	                width : '100px',
	       	                filterOption : true},
       	                {
	       	                id : 'perilName',
	       	                title : 'Peril Name',
	       	                titleAlign: 'left',
	       	                width : '275px',
	       	                filterOption : true},
       	            	{
	       	                id : 'rate',
	       	                title : 'Dep. Rate',
	       	                altTitle: 'Depreciation Rate',
	       	                titleAlign: 'right',
	       	                width : '150px',
	       	             	align : 'right',
	       	                filterOption : true,
	       	             	renderer : function(value){
								return formatToNineDecimal(value);}},
       	                {
	       	                id : 'userId',
	       	                title : 'User Id',
	       	                width : '0',
	       				    visible: false,
	       	                filterOption : false},
	       	            {
	       	                id : 'lastUpdate',
	       	                title : 'Last Update',
	       	                titleAlign: 'center',
	       	                width : '0',
	       				    visible: false,
	       	                filterOption : false},
       	                {
	       	                id : 'remarks',
	       	                width : '0',
	       				    visible: false,
	       	                filterOption : false}
       	                ],
			rows: objPerilList.objPerilDepMaintenance
		};
		perilListTableGrid = new MyTableGrid(perilListModelTG);
		perilListTableGrid.pager = objPerilList.objPerilListing;
		perilListTableGrid.render('perilDepListingTableGridDiv');
		perilListTableGrid.afterRender = function(){
			objPerilListMain = perilListTableGrid.geniisysRows;
			changeTag = 0;
		};
		}catch (e) {
			 showErrorMessage("Peril Depreciation Maintenance Table Grid", e); 
		}
		
		function setPerilDepreciationMaintenanceTableValues(func) {
			var rowObjectPeril = new Object();
			
			rowObjectPeril.lineCd = escapeHTML2($("txtLineCd").value);
			rowObjectPeril.perilCd = escapeHTML2($("txtPerilCd").value);
			rowObjectPeril.perilName = escapeHTML2($("txtPerilName").value);
			rowObjectPeril.rate = $("txtDistributionRate").value == 0 ? 0 : formatToNineDecimal($("txtDistributionRate").value);
			rowObjectPeril.remarks = escapeHTML2($("txtRemarks").value);
			rowObjectPeril.userId = escapeHTML2(userId);
			var lastUpdate = new Date();
			rowObjectPeril.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
			
			rowObjectPeril.recordStatus = func == "Delete" ? -1 : func == "Add" ? 0 : 1;
			
			return rowObjectPeril;
		}
		
		/*populate fields from the table grid*/
		function populatePerilDetails(obj){
			try{ 
				$("txtLineCd").value = obj==null ? ""  : obj.lineCd;
				$("txtPerilCd").value = obj==null ? "" : obj.perilCd;
				$("txtPerilName").value = obj==null ? "" : unescapeHTML2(obj.perilName);
				$("txtDistributionRate").value = obj==null ? "" : formatToNineDecimal(obj.rate);
				$("txtUserId").value = obj==null ? "" : obj.userId;
				$("txtLastUpdate").value = obj==null ? "" : obj.lastUpdate;
				$("txtRemarks").value = obj==null ? "" : unescapeHTML2(obj.remarks);
				depRate = obj==null ? "" : formatToNineDecimal(obj.rate);
				remarks = obj==null ? "" : unescapeHTML2(obj.remarks);
			}catch(e){
				showErrorMessage("populatePerilDetails", e);
			}
		}
		
		/*LOV of peril code and peril name*/
		function showPerilDepreciationLOV(lineCd, perilCd, perilName){
			try{
				var column;
				var notIn = prepareNotInParam();
				
				if ($F("txtSearchPeril") == "Peril Code"){
					column = [{
						id :  'perilCd',
		            	title : 'Peril Code',
		            	titleAlign: 'left',
		            	width :'100px'
		              },
		              {
		            	id : 'perilName',
		            	title : 'Peril Name',
		            	titleAlign: 'left',
		            	width : '245px'
		              },
		              ]
					;
				}else{
					column = [{
						id :  'perilName',
		            	title : 'Peril Name',
		            	titleAlign: 'left',
		            	width : '245px'
		              },
		              {
		            	id : 'perilCd',
		            	title : 'Peril Code',
		            	titleAlign: 'left',
		            	width :'100px'
		              },
		              ]
					;
				}
				
				LOV.show({
					controller : "UnderwritingLOVController",
					urlParameters : {
						action : "getPerilDepNameLOV",
						lineCd : lineCd,
						perilCd : perilCd,
						perilName : perilName,
						page : 1,
						notIn : nvl(notIn, "")
					},
					title: "Peril Code and Name List",
					width : 360,
					height : 386.5,
					columnModel : column,
					draggable : true,
					autoSelectOneRecord : true,											//added by kenneth L. 12.27.2012
					onUndefinedRow : function(){										//added by kenneth L. 12.27.2012
						showMessageBox("No record selected.", imgMessage.INFO);
						$("txtPerilCd").value = $("txtLastValidPerilCd").value;
						$("txtPerilName").value = $("txtLastValidPerilName").value;
					},
					onSelect: function(row){											//replaced by kenneth L. 12.27.2012
						$("txtPerilCd").value = row.perilCd;
						$("txtPerilName").value = unescapeHTML2(row.perilName);
						$("txtLastValidPerilCd").value = row.perilCd;
						$("txtLastValidPerilName").value = unescapeHTML2(row.perilName);
						validateAddPerilCd();
					},
					onCancel: function(){												//added by kenneth L. 12.27.2012
						$("txtPerilCd").value = $("txtLastValidPerilCd").value;
						$("txtPerilName").value = $("txtLastValidPerilName").value;
					}
					/* draggable : true,     --removed by kenneth L. 12.27.2012
					onSelect: function(row){
						$("txtPerilCd").value = row.perilCd;
						$("txtPerilName").value = unescapeHTML2(row.perilName);
						validateAddPerilCd();
					} */
				});
			}catch(e){
				showErrorMessage("showPerilDepNameLOV", e);
			}
		}
		
		/*for adding and updating new peril depreciation*/
		function addUpdateDataInTable() {
			rowObj = setPerilDepreciationMaintenanceTableValues($("btnAddPerilDepreciation").value);
	
			if (checkAllRequiredFieldsInDiv("maintenanceDetailsDiv")) {
					if ($("btnAddPerilDepreciation").value != "Add") {
						if(depRate == $F("txtDistributionRate") && remarks  == $F("txtRemarks")){
							changetag = 0;
							perilListTableGrid.refresh();
						}else{
							objPerilListMain.splice(row, 1, rowObj);
							perilListTableGrid.updateVisibleRowOnly(rowObj, row);
							changeTag = 1;
							changeCounter++;
						}
						clearFields();
						clearLastValidValues();
						disableButton("btnDeletePerilDepreciation");
						enableLov();
					}else{
						rowObj.unsavedAddStat = 1;
						objPerilListMain.push(rowObj);
						perilListTableGrid.addBottomRow(rowObj);
						changeTag = 1;
						changeCounter++;
						clearFields();
						clearLastValidValues();
						disableButton("btnDeletePerilDepreciation");
						enableLov();
				}
			}
		}
	
		/*function used for deleting a peril depreciation*/
		function deletePerilDepreciation() {
			delObj = setPerilDepreciationMaintenanceTableValues($("btnDeletePerilDepreciation").value);

				objPerilListMain.splice(row, 1, delObj);
				perilListTableGrid.deleteVisibleRowOnly(row);
				if (changeCounter == 1 && delObj.unsavedAddStat == 1) {
					changeTag = 0;
					changeCounter = 0;
				} else {
					changeCounter++;
					changeTag = 1;
					clearFields();
					disableButton("btnDeletePerilDepreciation");
					enableLov();
				}
			}
		
		/*for saving the changes of peril depreciation*/
		function savePerilDepreciation() {
			var objParams = new Object();
			objParams.setRows = getAddedAndModifiedJSONObjects(objPerilListMain);
			objParams.delRows = getDeletedJSONObjects(objPerilListMain);

			new Ajax.Request(contextPath
					+ "/GIEXPerilDepreciationController?action=savePerilDepreciation", {
				method : "POST",
				parameters : {
					parameters : JSON.stringify(objParams)
				},
				asynchronous : false,
				evalScripts : true,
				onCreate : function() {
					showNotice("Saving Peril Depreciation, please wait...");
				},
				onComplete : function(response) {
					hideNotice("");
					changeTag = 0;
					if (checkErrorOnResponse(response)) {
						if (response.responseText == "SUCCESS") {
							perilListTableGrid.refresh();	
							showMessageBox(objCommonMessage.SUCCESS, "S");
							clearFields();
							clearLastValidValues();
							changeTagFunc = "";
							perilListTableGrid.keys.releaseKeys();	
						}
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		/*function that validates if there is an existing peril depreciation in the line code chosen*/
		function validateAddPerilCd() {
			new Ajax.Request(contextPath
					+ "/GIEXPerilDepreciationController", {
				method : "POST",
				parameters 	: {
					action : "validateAddPerilCd",
					lineCd : $("txtLineCd").value,
					perilCd : $("txtPerilCd").value
				},
				asynchronous : false,
				evalScripts : true,
				onComplete : function(response) {
					if (response.responseText == '1') {
						focusCursor(txtPerilCd);
						$("txtLastValidPerilCd").value = $F("txtPerilCd");
						$("txtLastValidPerilName").value = $F("txtPerilName");
					} else {
						customShowMessageBox("Record Already Exists.", imgMessage.ERROR, "txtPerilCd");
						$("txtPerilCd").value = ""; //$F("txtLastValidPerilCd");
						$("txtPerilName").value = ""; //$F("txtLastValidPerilName");
					}
				}
			});
		}
		
		/*clears the fields*/
		function clearFields() {
			$("txtPerilCd").value = "";
			$("txtPerilName").value = "";
			$("txtDistributionRate").value = "";
			$("txtRemarks").value = "";
			$("txtUserId").value = "";
			$("txtLastUpdate").value = "";
			$("btnAddPerilDepreciation").value = "Add";
			perilListTableGrid.keys.releaseKeys();
		}
		
		/*clears the hidden fields of last valid value*/
		function clearLastValidValues(){
			$("txtLastValidPerilCd").value = "";
			$("txtLastValidPerilName").value = "";
			$("txtLastValidDistributionRate").value = "";
		}
		
		function disableLov(){
			disableSearch("btnSearchPeril");
			//disableSearch("btnSearchPerilCode");
			disableInputField("txtPerilCd");
		}
		
		function enableLov(){
			enableSearch("btnSearchPeril");
			//enableSearch("btnSearchPerilCode");
			enableInputField("txtPerilCd");
		}
		
		/*for validation of distribution rate*/
		$("txtDistributionRate").observe("change",function(){
			var rateFieldValue = formatToNineDecimal($F("txtDistributionRate"));
			if (rateFieldValue < 0 && rateFieldValue != "") {
				customShowMessageBox("Invalid Distribution Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtDistributionRate");
				$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
			}else if ($F("txtDistributionRate") != "" && isNaN($F("txtDistributionRate"))) {
				customShowMessageBox("Invalid Distribution Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtDistributionRate");
				$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
			}else if (rateFieldValue > 100 && rateFieldValue != ""){
				customShowMessageBox("Invalid Distribution Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtDistributionRate");
				$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
			}else if ($F("txtDistributionRate").include("-")){
				customShowMessageBox("Invalid Distribution Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtDistributionRate");
				$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
			}else if ($F("txtDistributionRate") == ""){
				$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
			}else{
				//$("txtLastValidDistributionRate").value = rateFieldValue;
				
				var returnValue = "";
				var amt;
				amt = (($F("txtDistributionRate")).include(".") ? $F("txtDistributionRate") : ($F("txtDistributionRate")).concat(".00")).split(".");
			
				if(9 < amt[1].length){				
					returnValue = amt[0] + "." + amt[1].substring(0, 9);
					customShowMessageBox("Invalid Distribution Rate. Valid value should be from 0.000000000 to 100.000000000.", imgMessage.INFO, "txtDistributionRate");
					$("txtDistributionRate").value = $F("txtLastValidDistributionRate");
					
				}else{				
					returnValue = amt[0] + "." + rpad(amt[1], 9, "0");
					$("txtDistributionRate").value = returnValue;
					$("txtLastValidDistributionRate").value = returnValue;
				}
			} 
		});
		
		
		$("btnAddPerilDepreciation").observe("click", function() {
			changeTagFunc = savePerilDepreciation;
			addUpdateDataInTable();
		});
		
		$("btnSearchPeril").observe("click", function() {
			var notIn = "";
			var withPrevious = false;
			for ( var i = 0; i < objPerilListMain.length; i++) {
				if (objPerilListMain[i].recordStatus != -1) {
					if(withPrevious) notIn += ",";
					notIn += "'"+(objPerilListMain[i].perilCd)+"'";
					withPrevious = true;
				}
			}
			notIn = (notIn != "" ? "("+notIn+")" : "");
			$("txtSearchPeril").value = "Peril Code";
			if ($("txtPerilCd").value != "")
				showPerilDepreciationLOV($("txtLineCd").value, "", $("txtPerilCd").value);
			else{
				showPerilDepreciationLOV($("txtLineCd").value, "", "%");
			}
		});
		
		
		$("txtPerilCd").observe("change", function() {
			$("txtSearchPeril").value = "Peril Code";
			var notIn = prepareNotInParam();
			if(notIn.match($F("txtPerilCd")) && $F("txtPerilCd") != ""){
				customShowMessageBox("Record Already Exists.", imgMessage.ERROR, "txtPerilCd");
				$("txtPerilCd").value = "";
				$("txtPerilName").value = ""; 
			}else if ($F("txtPerilCd") == ""){
				$("txtPerilCd").value = "";
				$("txtPerilName").value = ""; 
			}else{
				perilCdLov();
			}
		});
		
		function prepareNotInParam(){
			withPrevious = false;
			var notIn = "";
			for(var i = 0; i < objPerilListMain.length; i++){
				if(objPerilListMain[i].recordStatus != -1){
					if(withPrevious){
						notIn += ",";
					}
					notIn += "'" + objPerilListMain[i].perilCd + "'";
					withPrevious = true;
				}
			}
			return notIn;
		}
		
		function perilNameLov(){
			if ($("txtPerilName").value != "")
				showPerilDepreciationLOV($("txtLineCd").value, "", $("txtPerilName").value);
			else{
				showPerilDepreciationLOV($("txtLineCd").value, "", "%");
			}
		}
		
		function perilCdLov(){
			if ($("txtPerilCd").value != "")
				showPerilDepreciationLOV($("txtLineCd").value, $("txtPerilCd").value, "");
			else{
				$("txtPerilCd").value = "";
				$("txtPerilName").value = "";
			}
		}

		$("btnDeletePerilDepreciation").observe("click", function () {
			changeTagFunc = savePerilDepreciation;
			deletePerilDepreciation();
		}); 
	
		observeSaveForm("btnSavePerilDepreciation", savePerilDepreciation);
		
		observeCancelForm("perilDepreciationExit", savePerilDepreciation, function(){
			perilListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});
		
		observeCancelForm("btnCancelPerilDepreciation", savePerilDepreciation, function(){
			perilListTableGrid.keys.releaseKeys();
			changeTag = 0;
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		});

		$("editRemarksText").observe("click", function () {
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
				limitText($("txtRemarks"),4000);
			});
		});
		
		$("txtRemarks").observe("keyup", function(){		
			limitText(this,4000);
		});	
		
		$("txtRemarks").observe("keydown", function(){	
			limitText(this,4000);
		});
</script>