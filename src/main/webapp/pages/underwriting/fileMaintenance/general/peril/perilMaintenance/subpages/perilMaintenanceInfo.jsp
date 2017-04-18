<div id="perilMaintenanceInfo" style="margin-top: 50px;">
	<table align="center">
		<tr>
			<td class="rightAligned" >Peril Code</td>
			<td class="leftAligned"><input type="text" id="txtPerilCode" style="width: 126px; text-align: right;" value="" class="required integerNoNegativeUnformatted" maxlength="5"/></td>
			<td class="rightAligned">Peril Short Name</td>
			<td class="leftAligned"><input type="text" id="txtPerilShortName" style="width: 126px;" value="" class="required upper" maxlength="4"/></td>
			<td class="rightAligned">Sequence</td>
			<td class="leftAligned"><input type="text" id="txtSequence" style="width: 114px; text-align: right;" value="" class="integerNoNegativeUnformatted" maxlength="2"/></td>
		</tr>
		<tr>
			<td class="rightAligned">Peril Name</td>
			<td class="leftAligned" colspan="5"><input type="text" id="txtPerilName" value="" style="width: 580px;" class="required upper" maxlength="20"/></td>
		</tr>
		<tr>
			<td colspan="6">
				<table>
					<td width="31.5px"></td>
					<td align="right" >Peril Type</td>
					<td class="leftAligned">
						<select id="dDnPerilType" name="dDnPerilType" class="required upper" style="text-align: left; width: 246px;">
							<option value="B">Basic</option>
							<option value="A">Allied</option>
		 				</select>
					</td>
					<td width="30px"></td>
					<td class="rightAligned">Subline</td>
					<td class="leftAligned">
						 <div style="border: 1px solid gray; height: 20px; margin-left: 3px; float: right; width: 249px;">
							<input id="txtSublineName" type="text" value="" maxlength="30" style="width: 224px; height: 11px; border: none; float: left;" name="txtSublineName" />
							<img id="btnSearchSubline" alt="Go" name="btnSearchSubline" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: left;"> 
						 </div>
					</td>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="6">
				<table>
					<td width="2px"></td>
					<td align="right">RI Comm Rate</td>
					<td class="leftAligned">
						<input type="text" id="txtRiCommRate" value="" class="required upper" style="width: 238.5px; text-align: right;" maxlength="13"/>
					</td>
					<td width="25px"></td>
					<td class="rightAligned">Print Tag</td>
					<td class="leftAligned">
						<select id="dDnPrintTag" name="dDnPrintTag" style="text-align: left; width: 251px;">
							<option></option>
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
 						</select>
					</td>
				</table>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Basic Peril</td>			 
			<td class="leftAligned" colspan="3">
				<div style="border: 1px solid gray; height: 21px; float: left; width:387px;">
					<input id="txtBasicPerilName" type="text" value="" style="width: 357px; height: 13px; border-bottom: none; float: left; border-color: transparent; margin-top: 0px;" maxlength="20" name="txtBasicPerilName" />
					<img id="btnSearchBasicPerilCd" alt="Go" name="btnSearchBasicPerilCd" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: right;"/>
				 </div>
			</td>
			<td></td>
			<td>
				<table>
					<td class="rightAligned">
						<input id="chkProfitCommTag" type="checkbox" style="width: 13px; height: 13px;" name="chkProfitCommTag"></td>
					<td class="leftAligned">
						<label for="chkProfitCommTag" title="Profit Comm Tag">Profit Comm Tag</label></td>
				</table>
			</td>
		</tr>
		<!-- <tr id="zoneTypeFI">
			<td class="rightAligned">Zone Type</td>
			<td class="leftAligned"colspan="4">
				 <div style="border: 1px solid gray; height: 21px; float: left; width:387px;">
					<input id="txtZoneNameFi" type="text" value="" style="width: 357px; height: 11px; border: none; float: left;" name="txtZoneNameFi"/>
					<img id="btnSearchZoneTypeFi" alt="Go" name="btnSearchZoneTypeFi" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: right;">
				 </div>
			</td>
		</tr>--><!-- commented out and replaced with codes below to include EQ Zone Type edgar 03/10/2015  -->
		<tr id="zoneTypeFI">
			<td colspan="6">
				<table>
					<td width="25px"></td>
					<td align="right">Zone Type</td>
					<td class="leftAligned">
						 <div style="border: 1px solid gray; height: 21px; float: left; width:245.5px;"><!-- changed width of ZoneType from 387px : edgar 03/11/2015 -->
							<input id="txtZoneNameFi" type="text" value="" style="width: 215.5px; height: 11px; border: none; float: left;" name="txtZoneNameFi"/> <!-- changed width of ZoneType from 357px : edgar 03/11/2015 -->
							<img id="btnSearchZoneTypeFi" alt="Go" name="btnSearchZoneTypeFi" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: right;">
						 </div>
					</td>
					<td width="2px"></td>
					<td>EQ Zone Type</td>
					<td class="rightAligned">
						 <div style="border: 1px solid gray; height: 21px; float: left; width:245.5px;">
							<input id="txtEqZoneNameFi" type="text" value="" class="required" style="width: 220.5px; height: 11px; border: none; float: left;" name="txtEqZoneNameFi"/>
							<img id="btnSearchEqZoneTypeFi" class="required"alt="Go" name="btnSearchEqZoneTypeFi" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: right;">
						 </div>
					</td>
				</table>
			</td>
		</tr>
		<tr id="zoneTypeMC">
			<td class="rightAligned">Zone Type</td>
			<td class="leftAligned" colspan="3">
				 <div style="border: 1px solid gray; height: 21px; float: left; width:387px;">
					<input id="txtZoneNameMc" type="text" value="" style="width: 357px; height: 11px; border: none; float: left;" name="txtZoneNameMc"/>
					<img id="btnSearchZoneTypeMc" alt="Go" name="btnSearchZoneTypeMc" src="/Geniisys/images/misc/searchIcon.png" style="width: 18px; height: 17px; float: right;">
				 </div>
			</td>
			<td></td>
			<td>
				<table>
					<td class="rightAligned">
						<input id="chkEvalSw" type="checkbox" style="width: 13px; height: 13px;" name="chkEvalSw"></td>
					<td class="leftAligned">
						<label for="chkEvalSw" title="MC Evaluation Tag">MC Evaluation Tag</label></td>
				</table>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Default Rate</td>
			<td class="leftAligned">
				<input type="text" id="txtDefaultRate" value="" style="width: 126px; text-align: right;" maxlength="13"/>	</td>
			<td class="rightAligned">Default TSI</td>
			<td class="leftAligned">
				<input type="text" name="valDefaultTsi" id="txtDefaultTsi" hasOwnKeyUp="N" hasOwnChange="N" hasOwnBlur="N" class="applyDecimalRegExp2" hideErrMsg="Y" max="99999999999999.99" min="0.00" regexppatt="pDeci1402" customLabel="Default Tsi" maxlength="17" value=""  style="width: 126px; text-align: right;"/>
			</td>
			<td></td>
			<td>
				<table>
					<td class="rightAligned">
						<input id="chkDefaultTag" type="checkbox" style="width: 13px; height: 13px;" name="chkDefaultTag"></td>
					<td class="leftAligned">
						<label for="chkDefaultTag" title="Default Tag">Default Tag</label></td>
				</table>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Peril Long Name</td>
			<td colspan="5" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 588px;">
					<textarea id="txtPerilLongName" name="txtPerilLongName" style="border: none; height: 13px; resize: none; width: 95%" maxlength="500"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditPerilLongName" id="editPerilLongNameText" tabindex=206/>
				</div>
			</td>
		</tr>
		<tr>
			<td class="rightAligned">Remarks</td>
			<td colspan="5" class="leftAligned">
				<div style="border: 1px solid gray; height: 21px; width: 589px;">
					<textarea id="txtRemarks" name="txtRemarks" style="border: none; height: 13px; resize: none; width: 95%" maxlength="4000"></textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="EditRemark" id="editRemarksText" tabindex=206/>
				</div>
			</td>
		</tr>
		<tr>
		<td colspan="6">
				<table>
					<td width="43px"></td>
					<td align="right">User ID</td>
					<td class="leftAligned"><input type="text" id="txtUserId" value="" readonly="readonly" style="width: 238px;"/></td>
					<td width="12px"></td>
					<td class="rightAligned">Last Update</td>
					<td class="leftAligned"><input type="text" id="txtLastUpdate" value="" readonly="readonly" style="width: 241px;"/></td>
				</table>
			</td>
		</tr>
		<tr>
			<td><input type="hidden" id="hidLineCd" name="hidLineCd" value="" /></td>
			<td><input type="hidden" id="hidLineName" name="hidLineName" value="" /></td>
			<td><input type="hidden" id="hidMenuLineCd" name="hidMenuLineCd" value="" /></td>
			<td><input type="hidden" id="hidLastValidPerilCode" value="" class="required upper" maxlength="5"/></td>
			<td><input type="hidden" id="hidLastValidPerilShortName" value="" class="required upper" maxlength="4"/></td>
			<td><input type="hidden" id="hidLastValidSequence" value="" class="required upper" maxlength="2"/></td>
			<td><input type="hidden" id="hidLastValidDefaultRate" value=""/></td>
			<td><input type="hidden" id="hidLastValidDefaultTsi" value=" "/></td>		
			<td><input type="hidden" id="hidLastValidPerilName" name="hidLastValidPerilName" value="" /></td>
			<td><input type="hidden" id="hidLastValidRiCommRate" value=""/></td>
			<td><input type="hidden" id="hidLastValidSublineName" name="hidLastValidSublineName" value="" code=""/></td>
			<td><input type="hidden" id="hidLastValidBasicPerilName" name="hidLastValidBasicPerilName" value="" code=""/></td>
			<td><input type="hidden" id="hidLastValidFi" name="hidLastValidFi" value="" code=""/></td>
			<td><input type="hidden" id="hidLastValidEqFi" name="hidLastValidEqFi" value="" code=""/></td> <!-- edgar 03/10/2015 -->
			<td><input type="hidden" id="hidLastValidMc" name="hidLastValidMc" value="" code=""/></td>
			<td><input type="hidden" id="hidBasicPerilCd"value="" name="hidBasicPerilCd"/></td>
			<td><input id="txtBasicPerilCd" type="hidden" value="" name="txtBasicPerilCd" readonly="readonly"/></td>
			<td><input id="txtZoneTypeFi" type="hidden" value="" name="txtZoneTypeFi" readonly="readonly"/></td>
			<td><input id="txtEqZoneTypeFi" type="hidden" value="" name="txtEqZoneTypeFi" readonly="readonly"/></td><!-- edgar 03/10/2015 -->
			<td><input id="txtZoneTypeMc" type="hidden" value="" name="txtZoneTypeMc" readonly="readonly"/></td>
			<td><input id="txtSubline" type="hidden" value="" maxlength="7" name="txtSubline" readonly="readonly"/></td>
		</tr>
	</table>
</div>

<script>
	try{
		var row = 0;
		var objPerilMain = [];
		var objLine = new Object();
		objLine.objLineListing = JSON.parse('${perilMaintenance}'.replace(/\\/g, '\\\\'));
		objLine.objLineMaintenance = objLine.objLineListing.rows || [];
		var lineMaintenanceTG = {
				url: contextPath+"/GIISSPerilMaintenanceController?action=getPerilMaintenanceDisplay",
			options: {
				width: '460px',
				height: '200px',
				onCellFocus: function(element, value, x, y, id){ 
					row = y;
				    objLineMaintain = lineMaintenanceTableGrid.geniisysRows[y];
				    perilMaintenanceTableGrid.url = contextPath+"/GIISSPerilMaintenanceController?action=getGIISPerilGIISS003"
																 +"&lineCd="+encodeURIComponent(unescapeHTML2(objLineMaintain.lineCd));
				   // observeReloadForm("reloadForm", showPerilMaintenance);
				   onFocus();
				   perilMaintenanceTableGrid._refreshList();
				},
				onRemoveRowFocus: function(){ 
					 if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		onRemove();
                   		perilMaintenanceTableGrid.refreshURL(perilMaintenanceTableGrid);
       				    perilMaintenanceTableGrid.refresh();
                	}
	            },
	            beforeSort: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {
                		onRemove();
                	}
	            },
	            onSort: function(){
	            	onRemove();
	            },
	            prePager: function(){
	            	if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
                	} else {	            		
                		onRemove();
                	}
                },
                onRefresh: function(){
                	onRemove();
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
						onRemove();
					}
				}
			},
			columnModel: [
				{   id: 'recordStatus',
				    title: '',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'userId',
					width: '0',
					visible: false
				},
				{	id: 'moduleId',
					width: '0',
					visible: false
				},
			    {   id: 'lineCd',
				    title: 'Line Code',
				    width: '92px',
				    visible: true,
				    filterOption: true
				},
				{	id: 'lineName',
					title: 'Line Name',
					width: '335px',
					visible: true,
					filterOption: true
				},
				{	id: 'menuLineCd',
					title: 'Menu Line Code',
					width: '0px',
					visible: false,
					filterOption: false
				}
				],
			rows: objLine.objLineMaintenance
		};
		lineMaintenanceTableGrid = new MyTableGrid(lineMaintenanceTG);
		lineMaintenanceTableGrid.pager = objLine.objLineListing;
		lineMaintenanceTableGrid.render('lineMaintenanceTable');
		lineMaintenanceTableGrid.afterRender = function(){
			objPerilMain = lineMaintenanceTableGrid.geniisysRows;
			changeTag = 0;
		};
	}catch (e) {
		showErrorMessage("Peril Maintenance Table Grid", e);
	}

	function clearFields() {
		$("txtSublineName").value		= "";
		$("txtBasicPerilName").value	= "";
		$("txtZoneNameMc").value		= "";
		$("txtZoneNameFi").value		= "";
		$("txtEqZoneNameFi").value		= "";//edgar 03/10/2015
		$("txtPerilCode").value 		= ""; 
		$("txtSequence").value 			= ""; 
		$("txtPerilShortName").value 	= "";
		$("txtPerilName").value 		= "";
		$("dDnPerilType").value 		= "B";
		$("txtSubline").value 			= "";
		$("txtRiCommRate").value 		= formatToNineDecimal(0);
		$("dDnPrintTag").value 			= "1";
		$("txtBasicPerilCd").value 		= "";
		$("hidBasicPerilCd").value 		= "";
		$("chkProfitCommTag").checked	= false;
		$("txtPerilLongName").value 	= "";
		$("txtRemarks").value 			= "";
		$("txtZoneTypeFi").value 		= "";
		$("txtEqZoneTypeFi").value 		= ""; //edgar 03/10/2015
		$("txtZoneTypeMc").value 		= "";
		$("chkEvalSw").checked			= false;
		$("chkDefaultTag").checked		= false;
		$("txtDefaultRate").value 		= "";
		$("txtDefaultTsi").value 		= "";
		$("txtUserId").value = "${PARAMETERS['USER'].userId}";
		$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:M:ss TT');
	}
	
	function enableFields() {
	   	enableInputField("txtPerilCode"); 
	   	enableInputField("txtSequence"); 
	   	enableInputField("txtPerilShortName");
	   	enableInputField("txtPerilName");
	   	enableInputField("txtRiCommRate");
		enableInputField("txtPerilLongName");
		enableInputField("txtRemarks");
		enableInputField("txtDefaultRate");
		enableInputField("txtDefaultTsi");
		enableInputField("txtSublineName");
		enableButton("btnAddPeril");
		enableSearch("btnSearchSubline");
		$("dDnPerilType").disabled = false;
		$("dDnPrintTag").disabled = false;
		$("chkProfitCommTag").disabled	= false;
		$("chkDefaultTag").disabled	= false;
	}
	
	function disableFields() {
		disableInputField("txtPerilCode"); 
		disableInputField("txtSequence"); 
		disableInputField("txtPerilShortName");
		disableInputField("txtPerilName");
		disableInputField("txtRiCommRate");
		disableInputField("txtPerilLongName");
		disableInputField("txtRemarks");
		disableInputField("txtDefaultRate");
		disableInputField("txtDefaultTsi");
		disableInputField("txtSublineName");
		disableInputField("txtBasicPerilName");
		disableButton("btnAddPeril");
		disableButton("btnDeletePeril");
		disableSearch("btnSearchSubline");
		disableSearch("btnSearchBasicPerilCd");
		$("dDnPerilType").disabled = true;
		$("dDnPrintTag").disabled = true;
		$("chkProfitCommTag").disabled	= true;
		$("chkDefaultTag").disabled	= true;
	}
	
	function refreshPeril(){
		perilMaintenanceTableGrid.url = contextPath+"/GIISSPerilMaintenanceController?action=getGIISPerilGIISS003";
		perilMaintenanceTableGrid._refreshList();
	}
	
	function showZoneType(){ 
		if ( $("hidLineCd").value == 'FI' || $("hidMenuLineCd").value == 'FI' ){
			$("zoneTypeFI").show();
			$("zoneTypeMC").hide();
			$("btnTariffCd").show();
		} else if ( $("hidLineCd").value == 'MC'|| $("hidMenuLineCd").value == 'MC' ){
			$("zoneTypeMC").show();
			$("zoneTypeFI").hide();
			$("btnTariffCd").show();
		}else{ 
			pageLoad();
		}
	}
		
	function pageLoad(){
		$("zoneTypeFI").hide();
		$("zoneTypeMC").hide();
		$("btnTariffCd").hide();
		disableButton("btnWandC");
		disableButton("btnTariffCd");
	}
	
	function onFocus(){
		lineMaintenanceTableGrid.keys.releaseKeys();
		clearFields();
	    enableFields();
	    $("txtPerilCode").focus();
		$("hidLineCd").value =  objLineMaintain.lineCd;
	    $("hidMenuLineCd").value =  objLineMaintain.menuLineCd;
	    $("hidLineName").value =  objLineMaintain.lineName;
	    showZoneType();
	    perilMaintenanceTableGrid._toggleColumnVisibility(14, objLineMaintain.lineCd == "MC" || objLineMaintain.menuLineCd == "MC");	
		perilMaintenanceTableGrid._toggleColumnVisibility(15, objLineMaintain.lineCd == "FI" || objLineMaintain.menuLineCd == "FI");
		perilMaintenanceTableGrid._toggleColumnVisibility(4, objLineMaintain.lineCd == "MC" || objLineMaintain.menuLineCd == "MC");
		//perilMaintenanceTableGrid.refreshURL(perilMaintenanceTableGrid);
	}
	
	function onRemove(){
		lineMaintenanceTableGrid.keys.releaseKeys(); 
		refreshPeril();
       	clearFields();
       	disableFields();
       	pageLoad();
       	$("hidLineCd").value =  "";
        $("hidMenuLineCd").value =  "";
        $("hidLineName").value =  "";
	}
	
	$("dDnPerilType").observe("change",function(){
		if ($("dDnPerilType").value == 'A'){
			enableSearch("btnSearchBasicPerilCd");
			enableInputField("txtBasicPerilName");
			$("txtBasicPerilName").value 		= "";
			$("txtBasicPerilCd").value 		= "";
		} else {
			disableSearch("btnSearchBasicPerilCd");
			disableInputField("txtBasicPerilName");
			$("txtBasicPerilName").value 		= "";
			$("txtBasicPerilCd").value 		= "";
		}
	});
	
	/* $("editRemarksText").observe("click", function () {
		showEditor("txtRemarks", 4000);
	});
	
	$("txtRemarks").observe("keyup", function () {
		limitText(this, 4000);
	}); */
	
	$("editRemarksText").observe("click", function () {
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"), function() {
			limitText($("txtRemarks"),4000);
		});
	});
	
	/* $("editPerilLongNameText").observe("click", function () {
		showEditor("txtPerilLongName", 500);
	});
	
	$("txtPerilLongName").observe("keyup", function () {
		limitText(this, 500);
	}); */
	
	$("editPerilLongNameText").observe("click", function () {
		showOverlayEditor("txtPerilLongName", 500, $("txtPerilLongName").hasAttribute("readonly"), function() {
			limitText($("txtPerilLongName"),500);
		});
	});
	
	pageLoad();
	disableFields();
	$("txtRiCommRate").value = formatToNineDecimal(0);
	$("dDnPrintTag").value = "1";
	$("txtUserId").value = "${PARAMETERS['USER'].userId}";
	$("txtLastUpdate").value = dateFormat(new Date(), 'mm-dd-yyyy hh:M:ss TT');
	
	//marco - 05.03.2013 - moved to perilMaintenance.jsp
	/* $("txtSublineName").observe("change",function() {
		if ($("txtSublineName").value != ""){
			showSublineCdLOV($("hidLineCd").value, $("txtSublineName").value);
		}else if ($("txtSublineName").value == ""){
			$("txtSubline").value = "";
			$("hidLastValidSublineName").value = "";
		}
	});
	
	$("txtZoneNameFi").observe("change",function() {
		if ($("txtZoneNameFi").value != ""){
			showZoneLOV("getZoneTypeFiLOV", $("txtZoneTypeFi"), $("txtZoneNameFi"), $("txtZoneNameFi").value, $("hidLastValidFi"));
		}else if ($("txtZoneNameFi").value == ""){
			$("txtZoneTypeFi").value = "";
			$("hidLastValidFi").value = "";
		}
	});
	
	$("txtZoneNameMc").observe("change",function() {
		if ($("txtZoneNameMc").value != ""){
			showZoneLOV("getZoneTypeMcLOV", $("txtZoneTypeMc"), $("txtZoneNameMc"), $("txtZoneNameMc").value, $("hidLastValidMc"));
		}else if ($("txtZoneNameMc").value == ""){
			$("txtZoneTypeMc").value = "";
			$("hidLastValidMc").value = "";
		}
	});
	
	$("txtBasicPerilName").observe("change",function() {
		if ($("txtBasicPerilName").value != ""){
			showBasicPerilCdLOV($("hidLineCd").value, $("txtBasicPerilName").value);
		}else if ($("txtBasicPerilName").value == ""){
			$("txtBasicPerilCd").value = "";
			$("hidLastValidBasicPerilName").value = "";
		}
	}); */
	
</script>