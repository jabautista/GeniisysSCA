<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="nonProportionalTreatyMainDiv" name="nonProportionalTreatyMainDiv">
	<div id="nonProportionalTreatyTableGridDiv">
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
	<div id="nonProportionalTreaty" name="nonProportionalTreaty">
		<div class="sectionDiv">
			<div id="giisXolDiv" style="padding-top: 10px; padding-bottom: 10px;">
				<div id="giisXolTable" style="height: 250px; margin-left: 115px;">
				</div>
			</div>
			<div align="center" id="giisXolFormDiv">
				<table style="margin-top: 5px; padding-bottom: 10px;">
					<tr>
						<td class="rightAligned">XOL Treaty</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLineCd" type="text" readonly="readonly" style="width: 50px; text-align: left;" tabindex="201">
							<input id="txtXolYy" type="text" readonly="readonly" style="width: 50px; text-align: right;" tabindex="202">
							<input id="txtXolSeqNo" type="text" readonly="readonly" style="width: 50px; text-align: right;" tabindex="203">
							-
							<input id="txtXolTrtyName" type="text" readonly="readonly" style="width: 249px; text-align: left;" tabindex="204">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Layer</td>
						<td class="leftAligned" colspan="3">
							<input id="txtLayerNo" type="text" readonly="readonly" style="width: 174px; text-align: right;" tabindex="205">
							-
							<input id="txtTrtyName" type="text" readonly="readonly" style="width: 249px; text-align: left;" tabindex="206">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Coverage Period</td>
						<td class="leftAligned">
							<input id="txtEffDate" type="text" readonly="readonly" style="width: 205px; text-align: left;" tabindex="207">
						</td>
						<td class="rightAligned">To</td>
						<td class="leftAligned">
							<input id="txtExpiryDate" type="text" readonly="readonly" style="width: 205px; text-align: left;" tabindex="208">
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="sectionDiv">
			<div id="trtyPerilXolDiv" style="padding-top: 10px;">
				<div id="trtyPerilXolTable" style="height: 340px; margin-left: 115px;">
				</div>
			</div>
			<div align="center" id="trtyPerilXolFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Peril Code</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="width: 205px; height: 22px; margin: 0px 0px 0 0; float: left;">
								<input id="txtPerilCd" type="text" class="required integerNoNegativeUnformatted" style="width: 180px; text-align: right; height: 13px; float: left; border: none;" tabindex="209" maxlength="5" ignoreDelKey="1" lastValidValue="">
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPeril" name="imgSearchPeril" alt="Go" style="float: right;">
							</span> 
						</td>
						<td class="rightAligned">Peril Name</td>
						<td class="leftAligned">
							<input id="txtDspPerilName" type="text" readonly="readonly" style="width: 200px;" tabindex="210" maxlength="20">
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Comm Rate</td>
						<td class="leftAligned">
							<input id="txtTrtyComRt" type="text" class="required moneyRate2" style="width: 200px; text-align: right;" tabindex="211" maxlength="14">
						</td>
						<td class="rightAligned">Prof Comm Rate</td>
						<td class="leftAligned">
							<input id="txtProfCommRt" type="text" class="moneyRate2" style="width: 200px; text-align: right;" tabindex="212" maxlength="14">
						</td>
					</tr>
					<tr>
						<td width="" class="rightAligned">Remarks</td>
						<td class="leftAligned" colspan="3">
							<div id="remarksDiv" name="remarksDiv" style="float: left; width: 567px; border: 1px solid gray; height: 22px;">
								<textarea style="float: left; height: 16px; width: 541px; margin-top: 0; border: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="213"></textarea>
								<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="214"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">User ID</td>
						<td class="leftAligned" style="width: 254px;">
							<input id="txtUserId" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="215">
						</td>
						<td class="rightAligned">Last Update</td>
						<td class="leftAligned">
							<input id="txtLastUpdate" type="text" class="" style="width: 200px;" readonly="readonly" tabindex="216">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="217">
				<input type="button" class="button" id="btnDelete" value="Delete" tabindex="218">
			</div>
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="button" id="btnIncludeAllPerils" value="Include All Perils" tabindex="219">
			</div>
		</div>
	</div>
</div>
<div class="buttonsDiv">
	<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="220">
	<input type="button" class="button" id="btnSave" value="Save" tabindex="221">
</div>
<input id="txtShareCd" type="hidden">
<script type="text/javascript">
	setModuleId("GIRIS007");
	setDocumentTitle("Maintain Treaty Peril");
	initializeAll();
	initializeAllMoneyFields();
	changeTag = 0;
	var rowIndex = -1;
	
	var objDistShareXol = {};
	var objCurrDistShareXol = null;
	objDistShareXol.distShareXolList = JSON.parse('${jsonXolList}');
	
	var distShareXolTable = {
		id: 853,
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
				objDistShareXol = tbgDistShareXol.geniisysRows[y];
				setFieldValuesDSXol(objDistShareXol);
				tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
				tbgDistShareXol.keys.releaseKeys();
				$("txtLineCd").focus();
			},
			onRemoveRowFocus : function(){
				rowIndex = -1;
				setFieldValuesDSXol(null);
				tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
				tbgDistShareXol.keys.releaseKeys();
				$("txtLineCd").focus();
			},
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					rowIndex = -1;
					setFieldValuesDSXol(null);
					executeTrtyPerilXol(null, null, null, null);
					tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
					tbgDistShareXol.keys.releaseKeys();
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
				setFieldValuesDSXol(null);
				executeTrtyPerilXol(null, null, null, null);
				tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
				tbgDistShareXol.keys.releaseKeys();
			},
			onRefresh: function(){
				rowIndex = -1;
				setFieldValuesDSXol(null);
				executeTrtyPerilXol(null, null, null, null);
				tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
				tbgDistShareXol.keys.releaseKeys();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				rowIndex = -1;
				setFieldValuesDSXol(null);
				executeTrtyPerilXol(null, null, null, null);
				tbgDistShareXol.keys.removeFocus(tbgDistShareXol.keys._nCurrentFocus, true);
				tbgDistShareXol.keys.releaseKeys();
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
				id : 'shareCd',
				width : '0',
				visible : false
			},
			{
				id: 'lineCd xolYy xolSeqNo',
				title: 'XOL Treaty',
			    width : '120px',
			    children : [
					{
						id : "lineCd",
						title : 'XOL Line Code',
						width : 45,
						align : "left",
						filterOption: true
					},
					{
						id : "xolYy",
						title : 'XOL Year',
						width : 30,
						align : "right",
						filterOption: true,
						filterOptionType : 'integerNoNegative'
					},
					{
						id : "xolSeqNo",
						title : 'XOL Sequence No.',
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
				id : 'xolTrtyName',
				filterOption : true,
				title : 'XOL Treaty Name',
				width : '125px'
			},
			{
				id: 'layerNo trtyName',
				title: 'Layer',
			    width : '175px',
			    children : [
					{
						id : "layerNo",
						title : 'Layer No.',
						width : 35,
						align : "right",
						filterOption: true,
						filterOptionType : 'integerNoNegative',
						renderer : function(value){
							return (value == null ? "" : value == "" ? "" : formatNumberDigits(value, 2)) ;
						}
					},
					{
						id : 'trtyName',
						filterOption : true,
						title : 'Treaty Name',
						width : 125
					}
			    ]
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
		rows : objDistShareXol.distShareXolList.rows
	};
	tbgDistShareXol = new MyTableGrid(distShareXolTable);
	tbgDistShareXol.pager = objDistShareXol.distShareXolList;
	tbgDistShareXol.render("giisXolTable");
	
	var objTrtyPerilXol = {};
	var objCurrTrtyPerilXol = null;
	objTrtyPerilXol.trtyPerilXolList = {};//JSON.parse('${jsonTrtyPerilXol}'); comment out by john 5/6/2014
	objTrtyPerilXol.exitPage = null;
	var perilIndex = -1;
	
	var trtyPerilXolTable = {
		id: 854,
		url : contextPath + "/TreatyPerilsController?action=executeTrtyPerilXol",
		options : {
			width : '700px',
			hideColumnChildTitle: true,
			pager : {},
			onCellFocus : function(element, value, x, y, id){
				perilIndex = y;
				objCurrTrtyPerilXol = tbgTrtyPerilXol.geniisysRows[y];
				setFieldValues(objCurrTrtyPerilXol);
				tbgTrtyPerilXol.keys.removeFocus(tbgTrtyPerilXol.keys._nCurrentFocus, true);
				tbgTrtyPerilXol.keys.releaseKeys();
				$("txtPerilCd").focus();
			},
			onRemoveRowFocus : function(){
				perilIndex = -1;
				setFieldValues(null);
				tbgTrtyPerilXol.keys.removeFocus(tbgTrtyPerilXol.keys._nCurrentFocus, true);
				tbgTrtyPerilXol.keys.releaseKeys();
				$("txtPerilCd").focus();
			},
			toolbar : {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					tbgTrtyPerilXol.onRemoveRowFocus();
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
				tbgTrtyPerilXol.onRemoveRowFocus();
			},
			onRefresh: function(){
				tbgTrtyPerilXol.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				tbgTrtyPerilXol.onRemoveRowFocus();
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
				titleAlign : 'right',
				align : 'right',
				width : '70px'
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
		rows : []//objTrtyPerilXol.trtyPerilXolList.rows comment out by john 5/6/2014
	};
	tbgTrtyPerilXol = new MyTableGrid(trtyPerilXolTable);
	tbgTrtyPerilXol.pager = {};
	tbgTrtyPerilXol.render("trtyPerilXolTable");
	
	function setFieldValuesDSXol(rec){
		try{
			$("txtLineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("txtXolYy").value = (rec == null ? "" : rec.xolYy);
			$("txtXolSeqNo").value = (rec == null ? "" : formatNumberDigits(rec.xolSeqNo, 3));
			$("txtXolTrtyName").value = (rec == null ? "" : unescapeHTML2(rec.xolTrtyName));
			$("txtLayerNo").value = (rec == null ? "" : rec.layerNo == null ? "" : rec.layerNo == "" ? "" : formatNumberDigits(rec.layerNo, 2));
			$("txtTrtyName").value = (rec == null ? "" : rec.trtyName == null ? "" : rec.trtyName == "" ? "" : unescapeHTML2(rec.trtyName));
			$("txtShareCd").value = (rec == null ? "" : rec.shareCd);
			$("txtEffDate").value = (rec == null ? "" : rec.effDate);
			$("txtExpiryDate").value = (rec == null ? "" : rec.expiryDate);
			
			objCurrDistShare = rec;
			
			if(rec != null){
				executeTrtyPerilXol(unescapeHTML2(objDistShareXol.lineCd), objDistShareXol.xolYy, objDistShareXol.xolSeqNo, objDistShareXol.shareCd);
			}else{
				executeTrtyPerilXol(null, null, null, null);
			}
		} catch(e){
			showErrorMessage("setFieldValuesDSXol", e);
		}
	}
	
	function executeTrtyPerilXol(lineCd, xolYy, xolSeqNo, shareCd){
		tbgTrtyPerilXol.url = contextPath + "/TreatyPerilsController?action=executeTrtyPerilXol&lineCd=" + encodeURIComponent(nvl(lineCd, "")) + "&xolYy=" + nvl(xolYy,0) + "&xolSeqNo=" + nvl(xolSeqNo,0) + "&shareCd=" + nvl(shareCd,0);
		tbgTrtyPerilXol._refreshList();
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
				enableButton("btnAdd");
				enableButton("btnIncludeAllPerils");
				$("txtPerilCd").readOnly = false;
				$("txtTrtyComRt").readOnly = false;
				$("txtProfCommRt").readOnly = false;
				$("txtRemarks").readOnly = false;
				rec == null ? $("txtPerilCd").readOnly = false : $("txtPerilCd").readOnly = true;
				rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
				rec == null ? enableSearch("imgSearchPeril") : disableSearch("imgSearchPeril");
				rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			}
			
			objCurrA6401 = rec;
		} catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	$("txtPerilCd").setAttribute("lastValidValue", "");
	$("txtDspPerilName").setAttribute("lastValidValue", "");
	$("imgSearchPeril").observe("click", function(){
		if($F("txtShareCd") == "" || $F("txtShareCd") == null){
			showMessageBox("List of Values contains no entries.", "I");
		} else {
			showA6401PerilCd();
		}
	});
	$("txtPerilCd").observe("change", function() {		
		if($F("txtPerilCd").trim() == "") {
			$("txtPerilCd").value = "";
			$("txtPerilCd").setAttribute("lastValidValue", "");
			$("txtDspPerilName").value = "";
			$("txtDspPerilName").setAttribute("lastValidValue", "");
		} else {
			if($F("txtPerilCd").trim() != "" && $F("txtPerilCd") != $("txtPerilCd").readAttribute("lastValidValue")) {
				if($F("txtShareCd") == "" || $F("txtShareCd") == null){
					showMessageBox("List of Values contains no entries.", "I");
				} else {
					showA6401PerilCd();
				}
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
	
	function valAddTrtyPerilXolRec(){
		try{
			if(checkAllRequiredFieldsInDiv("trtyPerilXolFormDiv")){
				if($F("btnAdd") == "Add") {
					var addedSameExists = false;
					var deletedSameExists = false;					
					
					for(var i=0; i<tbgTrtyPerilXol.geniisysRows.length; i++){
						if(tbgTrtyPerilXol.geniisysRows[i].recordStatus == 0 || tbgTrtyPerilXol.geniisysRows[i].recordStatus == 1){								
							if(tbgTrtyPerilXol.geniisysRows[i].perilCd == $F("txtPerilCd")){
								addedSameExists = true;								
							}							
						} else if(tbgTrtyPerilXol.geniisysRows[i].recordStatus == -1){
							if(tbgTrtyPerilXol.geniisysRows[i].perilCd == $F("txtPerilCd")){
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
							action : "valAddTrtyPerilXolRec",
							lineCd : $F("txtLineCd"),
						    xolYy : $F("txtXolYy"),
						    xolSeqNo : $F("txtXolSeqNo"),
						    perilCd : $F("txtPerilCd"),
						    shareCd : $F("txtShareCd") //nieko 02142017, SR 23828
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
			showErrorMessage("valAddTrtyPerilXolRec", e);
		}
	}
	
	function addRec(){
		try {
			changeTagFunc = saveTrtyPerilXol;
			var trtyPerilXol = setRec(objCurrTrtyPerilXol);
			if($F("btnAdd") == "Add"){
				tbgTrtyPerilXol.addBottomRow(trtyPerilXol);
			} else {
				tbgTrtyPerilXol.updateVisibleRowOnly(trtyPerilXol, perilIndex, false);
			}
			changeTag = 1;
			setFieldValues(null);
			tbgTrtyPerilXol.keys.removeFocus(tbgTrtyPerilXol.keys._nCurrentFocus, true);
			tbgTrtyPerilXol.keys.releaseKeys();
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
		changeTagFunc = saveTrtyPerilXol;
		objCurrTrtyPerilXol.recordStatus = -1;
		tbgTrtyPerilXol.geniisysRows[perilIndex].lineCd = escapeHTML2($F("txtLineCd"));
		tbgTrtyPerilXol.deleteRow(perilIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function saveTrtyPerilXol(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		var setRows = getAddedAndModifiedJSONObjects(tbgTrtyPerilXol.geniisysRows);
		var delRows = getDeletedJSONObjects(tbgTrtyPerilXol.geniisysRows);

		new Ajax.Request(contextPath+"/TreatyPerilsController", {
			method: "POST",
			parameters : {
				action : "saveTrtyPerilXol",
				setRows : prepareJsonAsParameter(setRows),
				delRows : prepareJsonAsParameter(delRows)
			},
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objTrtyPerilXol.exitPage != null) {
							objTrtyPerilXol.exitPage();
						} else {
							//tbgTrtyPerilXol._refreshList();
							//executeTrtyPerilXol(unescapeHTML2(objDistShareXol.lineCd), objDistShareXol.xolYy, objDistShareXol.xolSeqNo);

							//nieko 02142017, SR 23828
							//tbgDistShareXol._refreshList();
							tbgTrtyPerilXol._refreshList();
							//nieko 02142017 end
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
			showNonProportionalTreatyInfo();
		} else {
			showMessageBox(objCommonMessage.UNAVAILABLE_MODULE, imgMessage.INFO);
		}
	}
	
	function cancelTrtyPerilXol(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						objTrtyPerilXol.exitPage = exitPage;
						saveTrtyPerilXol();
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
		if($F("txtShareCd") == "" || $F("txtShareCd") == null){
			showMessageBox("Peril list of values contains no entries.", "I");
		} else {
			tbgTrtyPerilXol.url = contextPath + "/TreatyPerilsController?action=includeAllA6401&lineCd=" + objDistShareXol.lineCd + "&trtyYy=" 
			+ objDistShareXol.xolYy + "&shareCd=" + nvl(objDistShareXol.shareCd, "0");
			tbgTrtyPerilXol._refreshList();
			changeTag = 1;
			reInsertTGRecord();
		}
	}
	
	function reInsertTGRecord(){
		for(var i=0; i<tbgTrtyPerilXol.geniisysRows.length; i++){
			var index = i;
			objCurrTrtyPerilXol = tbgTrtyPerilXol.geniisysRows[i];
			
			if(tbgTrtyPerilXol.geniisysRows[i].includeAll != "Y"){
				var obj = {};
				obj.lineCd = escapeHTML2(tbgTrtyPerilXol.geniisysRows[i].lineCd);
				obj.trtySeqNo = tbgTrtyPerilXol.geniisysRows[i].trtySeqNo;
				obj.perilCd = tbgTrtyPerilXol.geniisysRows[i].perilCd;
				obj.dspPerilName = escapeHTML2(tbgTrtyPerilXol.geniisysRows[i].dspPerilName);
				obj.trtyComRt = unformatCurrencyValue(tbgTrtyPerilXol.geniisysRows[i].trtyComRt);
				obj.profCommRt = unformatCurrencyValue(tbgTrtyPerilXol.geniisysRows[i].profCommRt);
				obj.remarks = escapeHTML2(tbgTrtyPerilXol.geniisysRows[i].remarks);
				obj.userId = userId;
				var lastUpdate = new Date();
				obj.lastUpdate = dateFormat(lastUpdate, 'mm-dd-yyyy hh:MM:ss TT');
				obj.includeAll = "Y";
				
				tbgTrtyPerilXol.addBottomRow(obj);
				
				changeTagFunc = saveTrtyPerilXol;
				objCurrTrtyPerilXol.recordStatus = -1;
				tbgTrtyPerilXol.deleteRow(index);
				changeTag = 1;
			}
		}
	}
	
	$("btnAdd").observe("click", valAddTrtyPerilXolRec);
	$("btnDelete").observe("click", deleteRec);
	observeSaveForm("btnSave", saveTrtyPerilXol);
	$("btnCancel").observe("click", cancelTrtyPerilXol);
	
	disableButton("btnAdd");
	disableButton("btnDelete");
	disableButton("btnIncludeAllPerils");
	disableSearch("imgSearchPeril");
	observeReloadForm("reloadForm", showGiris007);
	$("btnIncludeAllPerils").observe("click", getAllPerils);
	
	$("menuFileMaintenanceExit").stopObserving("click");
	$("menuFileMaintenanceExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	function showNonProportionalTreatyInfo(){
		try{
			new Ajax.Request(contextPath + "/GIISDistributionShareController", {
				method: "POST",
				parameters : {
					action : "showNonProportionalTreatyInfo",
					xolId: objUW.hideGIIS060.xolId
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
			showErrorMessage("showNonProportionalTreatyInfo",e);
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
		var rows = tbgTrtyPerilXol.geniisysRows;
		
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
			
			tbgTrtyPerilXol.addBottomRow(obj);
		}
		changeTagFunc = saveTrtyPerilXol;
		changeTag = 1;
		tbgTrtyPerilXol.onRemoveRowFocus();
	}
</script>