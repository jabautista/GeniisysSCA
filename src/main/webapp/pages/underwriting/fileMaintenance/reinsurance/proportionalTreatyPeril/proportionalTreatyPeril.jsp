<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="proportionalTreatyMainDiv" name="proportionalTreatyMainDiv">
	<div id="proportionalTreatyTableGridDiv">
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
	   		<label>Maintain Treaty Perils</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
	   	</div>
	</div>
	<div id="proportionalTreaty" name="proportionalTreaty">
		<div class="sectionDiv">
			<div id="a6102Div" style="padding-top: 10px; padding-bottom: 10px;">
				<div id="a6102Table" style="height: 250px; margin-left: 115px;">
				</div>
			</div>
			<div align="center" id="a6102FormDiv">
				<table style="margin-top: 5px; padding-bottom: 10px;">
					<tr>
						<td class="rightAligned">Treaty</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLineCd" type="text" readonly="readonly" style="width: 50px; text-align: left: ;" tabindex="201">
							<input id="txtTrtyYy" type="text" readonly="readonly" style="width: 50px; text-align: left: ; text-align: right;" tabindex="202">
							<input id="txtShareCd" type="text" readonly="readonly" style="width: 50px; text-align: left: ; text-align: right;" tabindex="203">
							-
							<input id="txtTrtyName" type="text" readonly="readonly" style="width: 249px; text-align: left: ;" tabindex="204">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Coverage Period</td>
						<td class="leftAligned">
							<input id="txtEffDate" type="text" readonly="readonly" style="width: 205px; text-align: left: ;" tabindex="205">
						</td>
						<td class="rightAligned">To</td>
						<td class="leftAligned">
							<input id="txtExpiryDate" type="text" readonly="readonly" style="width: 205px; text-align: left: ;" tabindex="206">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="a6401Div" style="padding-top: 10px;">
				<div id="a6401Table" style="height: 340px; margin-left: 115px;">
				</div>
			</div>
			<div align="center" id="a6401FormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Peril Code</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="width: 205px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtPerilCd" type="text" class="required integerNoNegativeUnformatted" style="width: 180px; text-align: right; height: 13px; float: left; border: none;" tabindex="207" maxlength="5" ignoreDelKey="1">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPeril" name="imgSearchPeril" alt="Go" style="float: right;">
							</span> 
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Peril Name</td>
						<td class="leftAligned" colspan="3">
							<input id="txtDspPerilName" type="text" readonly="readonly" style="width: 561px;" tabindex="208" maxlength="20">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Comm Rate</td>
						<td class="leftAligned">
							<input id="txtTrtyComRt" type="text" class="required moneyRate2" style="width: 200px; text-align: right;" tabindex="209" maxlength="14">
						</td>
						<td class="rightAligned">Prof Comm Rate</td>
						<td class="leftAligned">
							<input id="txtProfCommRt" type="text" class="moneyRate2" style="width: 200px; text-align: right;" tabindex="210" maxlength="14">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 567px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 541px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="211"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="212"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;">
							<input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="213">
						</td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned">
							<input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="214">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="215">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="216">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnIncludeAllPerils" value="Include All Perils" tabindex="217">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="218">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="219">
</div>
<script type="text/javascript">
	setModuleId("GIRIS007");
	setDocumentTitle("Maintain Treaty Peril");
	initializeAll();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	var objDistShare = {};
	var objCurrDistShare = null;
	objDistShare.distShareList = JSON.parse('${jsonDistShareList}');
	
	var distShareTable = {
			url : contextPath + "/TreatyPerilsController?action=showGiris007&refresh=1" + "&callForm=" + objUWGlobal.module
					+ "&shareType=" + objGiris007.shareType + "&layerNo=" + objGiris007.layerNo + "&proportionalTreaty=" + objGiris007.proportionalTreaty,
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				beforeClick: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
				},
				onCellFocus : function(element, value, x, y, id){
					rowIndex = y;
					objCurrDistShare = tbgDistShare.geniisysRows[y];
					setFieldValuesDS(objCurrDistShare);
					tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
					tbgDistShare.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				onRemoveRowFocus : function(){
					rowIndex = -1;
					setFieldValuesDS(null);
					tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
					tbgDistShare.keys.releaseKeys();
					$("txtLineCd").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndex = -1;
						setFieldValuesDS(null);
						executeA6401(null, null, null);
						tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
						tbgDistShare.keys.releaseKeys();
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
					setFieldValuesDS(null);
					executeA6401(null, null, null);
					tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
					tbgDistShare.keys.releaseKeys();
				},
				onRefresh: function(){
					rowIndex = -1;
					setFieldValuesDS(null);
					executeA6401(null, null, null);
					tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
					tbgDistShare.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					rowIndex = -1;
					setFieldValuesDS(null);
					executeA6401(null, null, null);
					tbgDistShare.keys.removeFocus(tbgDistShare.keys._nCurrentFocus, true);
					tbgDistShare.keys.releaseKeys();
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
				{
				    id: 'recordStatus',
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id: 'lineCd trtyYy shareCd',
					title: 'Treaty',
				    width : '120px',
				    children : [
						{
							id : "lineCd",
							title : 'Line Code',
							width : 45,
							align : "left",
							filterOption: true
						},
						{
							id : "trtyYy",
							title : 'Treaty Year',
							width : 30,
							align : "right",
							filterOption: true,
							filterOptionType : 'integerNoNegative'
						},
						{
							id : "shareCd",
							title : 'Share Code',
							width : 45,
							align : "right",
							filterOption: true,
							filterOptionType : 'integerNoNegative',
							renderer : function(value){
								return formatNumberDigits(value, 3);
							}
						}
				    ]
				},
				{
					id : 'trtyName',
					filterOption : true,
					title : 'Treaty Name',
					width : '295px'
				},
				{
					id : 'effDate',
					title : 'Coverage Period From',
					titleAlign : 'center',
				    width : '130px',
				    align : "center",
				    filterOption : true,
				    filterOptionType : 'formattedDate'
				},
				{
					id : 'expiryDate',
					title : 'Coverage Period To',
					titleAlign : 'center',
				    width : '120px',
				    align : "center",
				    filterOption : true,
				    filterOptionType : 'formattedDate'
				}
			],
			rows : objDistShare.distShareList.rows
	};
	tbgDistShare = new MyTableGrid(distShareTable);
	tbgDistShare.pager = objDistShare.distShareList;
	tbgDistShare.render("a6102Table");
	
	var objA6401 = {};
	var objCurrA6401 = null;
	//objA6401.a6401List = JSON.parse('${jsonA6401List}');
	objA6401.exitPage = null;
	var perilIndex = -1;
	
	var a6401Table = {
			url : contextPath + "/TreatyPerilsController?action=executeA6401",
			options : {
				width : '700px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					perilIndex = y;
					objCurrA6401 = tbgA6401.geniisysRows[y];
					setFieldValues(objCurrA6401);
					tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
					tbgA6401.keys.releaseKeys();
					$("txtPerilCd").focus();
				},
				onRemoveRowFocus : function(){
					perilIndex = -1;
					setFieldValues(null);
					tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
					tbgA6401.keys.releaseKeys();
					$("txtPerilCd").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						perilIndex = -1;
						setFieldValues(null);
						tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
						tbgA6401.keys.releaseKeys();
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
					perilIndex = -1;
					setFieldValues(null);
					tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
					tbgA6401.keys.releaseKeys();
				},
				onRefresh: function(){
					perilIndex = -1;
					setFieldValues(null);
					tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
					tbgA6401.keys.releaseKeys();
				},				
				prePager: function(){
					if(changeTag == 1){
						showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
							$("btnSave").focus();
						});
						return false;
					}
					perilIndex = -1;
					setFieldValues(null);
					tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
					tbgA6401.keys.releaseKeys();
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
				{
				    id: 'recordStatus',
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "perilCd",
					title : "Peril Cd",
					filterOption : true,
					filterOptionType : 'integerNoNegative',
					width : '70px',
					align: 'right',
					titleAlign: 'right'
				},
				{
					id : 'dspPerilName',
					filterOption : true,
					title : 'Peril Name',
					width : '280px'
				},
				{
					id : 'trtyComRt',
					title : 'Comm Rate',
					align: 'right',
					titleAlign : 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value){
						return formatToNthDecimal(value, 9);
					}
				},
				{
					id : 'profCommRt',
					title : 'Prof Comm Rate',
					align: 'right',
					titleAlign : 'right',
					width : '150px',
					filterOption : true,
					filterOptionType : 'number',
					renderer : function(value){
						return formatToNthDecimal(value, 9);
					}
				},
				{
					id : 'lineCd',
					width : '0',
					visible: false				
				},
				{
					id : 'trtySeqNo',
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
				},
				{
					id : 'includeAll',
					width : '0',
					visible : false
				}
			],
			rows : []//objA6401.a6401List.rows
	};
	tbgA6401 = new MyTableGrid(a6401Table);
	tbgA6401.pager = {};
	tbgA6401.render("a6401Table");
	
	function setFieldValuesDS(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtTrtyYy").value = (rec == null ? "" : rec.trtyYy);
			$("txtShareCd").value = (rec == null ? "" : formatNumberDigits(rec.shareCd, 3));
			$("txtTrtyName").value = (rec == null ? "" : unescapeHTML2(rec.trtyName));
			$("txtEffDate").value = (rec == null ? "" : rec.effDate);
			$("txtExpiryDate").value = (rec == null ? "" : rec.expiryDate);
			objCurrDistShare = rec;
			
			if(rec == null){
				executeA6401(null, null, null);
			}else{
				executeA6401(unescapeHTML2(objCurrDistShare.lineCd), objCurrDistShare.trtyYy, objCurrDistShare.shareCd);
			}
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function executeA6401(lineCd, trtyYy, shareCd){
		tbgA6401.url = contextPath + "/TreatyPerilsController?action=executeA6401&lineCd=" + encodeURIComponent(nvl(lineCd, "")) + "&trtyYy=" + nvl(trtyYy, 0) + "&shareCd=" + nvl(shareCd, 0);
		tbgA6401._refreshList();
	}
	
	function setFieldValues(rec){
		try{
			$("txtPerilCd").value = (rec == null ? "" : rec.perilCd);
			$("txtPerilCd").setAttribute("lastValidValue", (rec == null ? "" : rec.perilCd));
			$("txtDspPerilName").value = (rec == null ? "" : unescapeHTML2(rec.dspPerilName));
			$("txtTrtyComRt").value = (rec == null ? "" : formatToNthDecimal(rec.trtyComRt, 9));
			$("txtProfCommRt").value = (rec == null ? "" : formatToNthDecimal(rec.profCommRt, 9));
			$("txtRemarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("txtUserId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("txtLastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			if(rowIndex == -1){
				$("txtPerilCd").readOnly = true;
				$("txtTrtyComRt").readOnly = true;
				$("txtProfCommRt").readOnly = true;
				$("txtRemarks").readOnly = true;
				$("btnAdd").value = "Add";
				disableSearch("imgSearchPeril");
				disableButton("btnAdd");
				disableButton("btnDelete");
				disableButton("btnIncludeAllPerils");
			}else{
				enableButton("btnIncludeAllPerils");
				enableButton("btnAdd");
				$("txtPerilCd").readOnly = false;
				$("txtTrtyComRt").readOnly = false;
				$("txtProfCommRt").readOnly = false;
				$("txtRemarks").readOnly = false;
				
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? $("txtPerilCd").readOnly = false : $("txtPerilCd").readOnly = true;
				rec == null ? enableSearch("imgSearchPeril") : disableSearch("imgSearchPeril");
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");	
			}
			
			objCurrA6401 = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtPerilCd").setAttribute("lastValidValue", "");
	$("imgSearchPeril").observe("click", showA6401PerilCd);
	$("txtPerilCd").observe("change", function() {		
		if($F("txtPerilCd").trim() == "") {
			$("txtPerilCd").value = "";
			$("txtPerilCd").setAttribute("lastValidValue", "");
			$("txtDspPerilName").value = "";
			$("txtDspPerilName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPerilCd").trim() != "" && $F("txtPerilCd") != $("txtPerilCd").readAttribute("lastValidValue")) {
				showA6401PerilCd();
			}
		}
	});
	
	function showA6401PerilCd(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getA6401PerilCd",
				lineCd :  $F("txtLineCd"),
				filterText : ($("txtPerilCd").readAttribute("lastValidValue").trim() != $F("txtPerilCd").trim() ? $F("txtPerilCd").trim() : ""),
				page : 1
			},
			title: "List of Perils",
			width: 500,
			height: 400,
			columnModel : [
				{
					id : "perilCd",
					title: "Peril Code",
					align : 'right',
					titleAlign : 'right',
					width: '100px',
					filterOption: true
				},
				{
					id : "perilSname",
					title: "Short Name",
					width: '100px',
					filterOption: true
				},
				{
					id : "perilName",
					title: "Peril Name",
					width: '150px',
					filterOption: true
				},
				{
					id : "perilType",
					title: "Peril Type",
					width: '100px',
					filterOption: true
				}
			],
			autoSelectOneRecord: true,
			filterText : ($("txtPerilCd").readAttribute("lastValidValue").trim() != $F("txtPerilCd").trim() ? $F("txtPerilCd").trim() : ""),
			onSelect: function(row) {
				$("txtPerilCd").value = row.perilCd;
				$("txtDspPerilName").value = unescapeHTML2(row.perilName);
				$("txtPerilCd").setAttribute("lastValidValue", $F("txtPerilCd"));
			},
			onCancel: function (){
				$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtPerilCd").value = $("txtPerilCd").readAttribute("lastValidValue");
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
	  });
	}
	
	$("txtTrtyComRt").setAttribute("lastValidValue", $F("txtTrtyComRt"));
	$("txtTrtyComRt").observe("blur", function(){
		if (isNaN($F("txtTrtyComRt")) || $F("txtTrtyComRt") > 999.999999999 || $F("txtTrtyComRt") < -999.999999999){
			customShowMessageBox("Invalid Comm Rate. Valid value should be from -999.999999999 to 999.999999999.", imgMessage.INFO, "txtTrtyComRt");
			$("txtTrtyComRt").value = $("txtTrtyComRt").readAttribute("lastValidValue");
		}
		
		$("txtTrtyComRt").value = formatToNthDecimal($("txtTrtyComRt").value, 9); 
		$("txtTrtyComRt").setAttribute("lastValidValue", $F("txtTrtyComRt"));
	});
	
	$("txtProfCommRt").setAttribute("lastValidValue", $F("txtProfCommRt"));
	$("txtProfCommRt").observe("blur", function(){
		if (isNaN($F("txtProfCommRt")) || $F("txtProfCommRt") > 999.999999999 || $F("txtTrtyComRt") < -999.999999999){
			customShowMessageBox("Invalid Prof Comm Rate. Valid value should be from -999.999999999 to 999.999999999.", imgMessage.INFO, "txtProfCommRt");
			$("txtProfCommRt").value = $("txtProfCommRt").readAttribute("lastValidValue");
		}
		
		$("txtProfCommRt").value = formatToNthDecimal($("txtProfCommRt").value, 9); 
		$("txtProfCommRt").setAttribute("lastValidValue", $F("txtProfCommRt"));
	});
	
	function valAddA6401Rec(){
		try{
			if(checkAllRequiredFieldsInDiv("a6401FormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgA6401.geniisysRows.length; i++){
						if(tbgA6401.geniisysRows[i].recordStatus == 0 || tbgA6401.geniisysRows[i].recordStatus == 1){								
							if(tbgA6401.geniisysRows[i].perilCd == $F("txtPerilCd")){
								addedSameExists = true;								
							}							
						} else if(tbgA6401.geniisysRows[i].recordStatus == -1){
							if(tbgA6401.geniisysRows[i].perilCd == $F("txtPerilCd")){
								deletedSameExists = true;
							}
						}
					}
					
					if((addedSameExists && !deletedSameExists) || (deletedSameExists && addedSameExists)){
						showMessageBox("Record already exists with the same line_cd, trty_seq_no and peril_cd.", "E");
						return;
					} else if(deletedSameExists && !addedSameExists){
						addRec();
						return;
					}
					
					new Ajax.Request(contextPath + "/TreatyPerilsController", {
						parameters : {
							action : "valAddA6401Rec",
							lineCd : $F("txtLineCd"),
						    trtyYy : $F("txtTrtyYy"),
						    shareCd : $F("txtShareCd"),
						    perilCd : $F("txtPerilCd")
						},
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
			showErrorMessage("valAddA6401Rec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveA6401;
			var a6401 = setRec(objCurrA6401);
			if($F("btnAdd") == "Add"){
				tbgA6401.addBottomRow(a6401);
			} else {
				tbgA6401.updateVisibleRowOnly(a6401, perilIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgA6401.keys.removeFocus(tbgA6401.keys._nCurrentFocus, true);
			tbgA6401.keys.releaseKeys();
		} catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.trtySeqNo = $F("txtShareCd");
			obj.perilCd = $F("txtPerilCd");
			obj.dspPerilName = escapeHTML2($F("txtDspPerilName"));
			obj.trtyComRt = unformatCurrencyValue($F("txtTrtyComRt"));
			obj.profCommRt = unformatCurrencyValue($F("txtProfCommRt"));
			obj.remarks = escapeHTML2($F("txtRemarks"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveA6401;
		objCurrA6401.recordStatus = -1;
		tbgA6401.geniisysRows[perilIndex].lineCd = escapeHTML2($F("txtLineCd"));
		tbgA6401.deleteRow(perilIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveA6401(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgA6401.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgA6401.geniisysRows);

		new Ajax.Request(contextPath+"/TreatyPerilsController", {
			method: "POST",
			parameters : {
				action : "saveA6401",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objA6401.exitPage != null) {
							objA6401.exitPage();
						} else {
							//executeA6401(unescapeHTML2(objCurrDistShare.lineCd), objCurrDistShare.trtyYy, objCurrDistShare.shareCd);
							tbgDistShare._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function exitPage(){
		if(objUWGlobal.module == "menu"){
			goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
		} else if (objUWGlobal.module == "GIISS031"){
			showProportionalTreatyInfo();
		} 
		else {
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
		}
	}
	
	function cancelA6401(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objA6401.exitPage = exitPage;
						saveA6401();
					}, function(){
						if(objUWGlobal.module == "menu"){
							goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
						} else {
							showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
						}
					}, "");
		} else {
			exitPage();
		}
	}
	
	function includeAllPerils(){
		tbgA6401.url = contextPath + "/TreatyPerilsController?action=includeAllA6401&lineCd=" + objCurrDistShare.lineCd + "&trtyYy=" 
				+ objCurrDistShare.trtyYy + "&shareCd=" + objCurrDistShare.shareCd;
		tbgA6401._refreshList();
		changeTag = 1;
		reInsertTGRecord();
	}
	
	function reInsertTGRecord(){
		for(var i=0; i<tbgA6401.geniisysRows.length; i++){
			var index = i;
			objCurrA6401 = tbgA6401.geniisysRows[i];
			
			if(tbgA6401.geniisysRows[i].includeAll != "Y"){
				var obj = {};
				obj.lineCd = tbgA6401.geniisysRows[i].lineCd;
				obj.trtySeqNo = tbgA6401.geniisysRows[i].trtySeqNo;
				obj.perilCd = tbgA6401.geniisysRows[i].perilCd;
				obj.dspPerilName = tbgA6401.geniisysRows[i].dspPerilName;
				obj.trtyComRt = tbgA6401.geniisysRows[i].trtyComRt;
				obj.profCommRt = tbgA6401.geniisysRows[i].profCommRt;
				obj.remarks = tbgA6401.geniisysRows[i].remarks;
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				obj.includeAll = "Y";
				
				tbgA6401.addBottomRow(obj);
				
				changeTagFunc = saveA6401;
				objCurrA6401.recordStatus = -1;
				tbgA6401.deleteRow(index);
				changeTag = 1;
			}
		}
	}
	
	$("btnAdd").observe("click", valAddA6401Rec);
	$("btnDelete").observe("click", deleteRec);
	observeSaveForm("btnSave", saveA6401);
	$("btnCancel").observe("click", cancelA6401);
	$("btnIncludeAllPerils").observe("click", getAllPerils);
	
	disableButton("btnAdd");
	disableButton("btnDelete");
	disableButton("btnIncludeAllPerils");
	disableSearch("imgSearchPeril");
	observeReloadForm("reloadForm", showGiris007);
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	function showProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showProportionalTreatyInfo",
					lineCd: objUW.hideGIIS060.lineCd,
					shareCd: objUW.hideGIIS060.shareCd
				},
				onCreate : showNotice("Loading, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						$("mainContents").update(response.responseText);
						
					}
				}
			});
		}catch(e){
			showErrorMessage("showProportionalTreatyInfo",e);
		}
	}
	
	$("editRemarks").observe("click", function(){
		if($F("txtLineCd") != ""){
			showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));	
		}
	});
	
	$("txtPerilCd").readOnly = true;
	$("txtTrtyComRt").readOnly = true;
	$("txtProfCommRt").readOnly = true;
	$("txtRemarks").readOnly = true;
	
	function getAllPerils(){
		new Ajax.Request(contextPath+"/TreatyPerilsController", {
			method: "GET",
			parameters: {
				action: "getAllPerils",
				lineCd: $F("txtLineCd"),
				trtySeqNo: $F("txtShareCd"),
				notIn: createNotInParam(0),
				notInDeleted: createNotInParam(-1)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					addAllPerils(eval(response.responseText));
				}
			}
		});
	}
	
	function createNotInParam(status){
		var notIn = "";
		var withPrevious = false;
		var rows = tbgA6401.geniisysRows;

		for(var i=0; i < rows.length; i++){
			if(parseInt(status) == -1 ? (rows[i].recordStatus == status) : (rows[i].recordStatus == 0 || rows[i].recordStatus == 1)){
				if(withPrevious){
					notIn += ",";
				}
				notIn += rows[i].perilCd;
				withPrevious = true;
			}
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function addAllPerils(rows){
		for(var i = 0; i < rows.length; i++){
			var obj = {};
			obj.lineCd = escapeHTML2($F("txtLineCd"));
			obj.trtySeqNo = $F("txtShareCd");
			obj.perilCd = rows[i].perilCd;
			obj.dspPerilName = escapeHTML2(rows[i].perilName);
			obj.trtyComRt = 0.00;
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			tbgA6401.addBottomRow(obj);
		}
		changeTagFunc = saveA6401;
		changeTag = 1;
		tbgA6401.onRemoveRowFocus();
	}
</script>