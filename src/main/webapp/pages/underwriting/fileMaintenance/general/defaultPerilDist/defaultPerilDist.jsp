<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="giiss165MainDiv" name="giiss165MainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>

	<div id="giiss165" name="giiss165">
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Default Peril Distribution Maintenance</label>
		   		<span class="refreshers" style="margin-top: 0;">
		   			<label name="gro" style="margin-left: 5px;">Hide</label>
					<label id="reloadForm" name="reloadForm">Reload Form</label>
				</span>
		   	</div>
		</div>
	
		<div id="distSectionDiv" class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="defaultDistTable" style="height: 210px; margin-left: 10px;"></div>
			</div>
			
			<div align="center" id="defaultDistFormDiv">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Default No.</td>
						<td>
							<input type="text" id="defaultNo" style="width: 120px; float: left; height: 13px; margin-left: 3px; text-align: right;" tabindex="101" readonly="readonly"/>
						</td>
						<td class="rightAligned">Issuing Source</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required upper" type="text" id="issCd" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="102" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssCd" alt="Go" style="float: right;"/>
							</span>
							<input id="dspIssName" type="text" style="width: 250px; height: 15px;" readonly="readonly" tabindex="103"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required upper" type="text" id="lineCd" style="width: 60px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="104" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" alt="Go" style="float: right;"/>
							</span>
							<input id="dspLineName" type="text" style="width: 250px; height: 15px; margin-right: 10px;" readonly="readonly" tabindex="105"/>
						</td>
						<td class="rightAligned">Default Dist Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required" type="text" id="distType" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="106" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDistType" alt="Go" style="float: right;"/>
							</span>
							<input id="dspDistName" type="text" style="width: 250px; height: 15px;" readonly="readonly" tabindex="107"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Subline</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 85px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required upper" type="text" id="sublineCd" style="width: 60px; float: left; border: none; height: 15px; margin: 0;" maxlength="7" tabindex="108" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" alt="Go" style="float: right;"/>
							</span>
							<input id="dspSublineName" type="text" style="width: 250px; height: 15px;" readonly="readonly" tabindex="109"/>
						</td>
						<td class="rightAligned">Default Type</td>
						<td class="leftAligned">
							<span class="lovSpan required" style="float: left; width: 65px; margin-right: 5px; margin-top: 2px; height: 21px;">
								<input class="required integerNoNegativeUnformatted" type="text" id="defaultType" style="width: 40px; float: left; border: none; height: 15px; margin: 0;" maxlength="2" tabindex="110" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDefaultType" alt="Go" style="float: right;"/>
							</span>
							<input id="dspDefaultName" type="text" style="width: 250px; height: 15px;" readonly="readonly" tabindex="111"/>
						</td>
					</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="button" id="btnAdd" value="Add" tabindex="112">
				<input type="button" class="disabledButton" id="btnDelete" value="Delete" tabindex="113">
			</div>
			
			<div style="margin: 10px; padding: 10px; border-top: 1px solid #E0E0E0; margin-bottom: 0;" align="center">
				<input type="button" class="disabledButton" id="btnRange" value="Range" style="width: 100px;" tabindex="114">
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Peril</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>
		
		<div id="perilSectionDiv" class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="perilTable" style="height: 220px; margin-left: 250px;"></div>
			</div>
		</div>
		
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
		   		<label>Share</label>
		   		<span class="refreshers" style="margin-top: 0;">
					<label name="gro" style="margin-left: 5px;">Hide</label>
				</span>
		   	</div>
		</div>
		
		<div id="shareSectionDiv" class="sectionDiv">
			<div style="padding-top: 10px;">
				<div id="distPerilTable" style="height: 210px; margin-left: 155px;"></div>
			</div>
			
			<div align="center" id="defaultDistPerilFormDiv" style="margin-right: 25px;">
				<table style="margin-top: 5px;">
					<tr>
						<td class="rightAligned">Sequence</td>
						<td class="leftAligned" colspan="3">
							<input type="text" id="sequence" style="width: 160px; float: left; height: 13px; text-align: right;" tabindex="301" readonly="readonly"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Share</td>
						<td class="leftAligned" colspan="3">
							<span class="lovSpan required" style="float: left; width: 85px; margin: 2px 5px 0 0; height: 21px;">
								<input class="required integerNoNegativeUnformatted" type="text" id="shareCd" style="width: 60px; float: left; border: none; height: 15px; margin: 0; text-align: right;" maxlength="3" tabindex="302" readonly="readonly" lastValidValue="" ignoreDelKey=""/>
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchShareCd" alt="Go" style="float: right;"/>
							</span>
							<input id="trtyName" type="text" style="width: 340px; height: 15px;" readonly="readonly" tabindex="303"/>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Percent Share</td>
						<td class="leftAligned">
							<input id="sharePct" type="text" class="moneyRate2" style="width: 160px; height: 13px; text-align: right;" readonly="readonly" maxlength="13" lastValidValue="" tabindex="304"/>
						</td>
						<td class="rightAligned">Share Amount</td>
						<td class="leftAligned">
							<input id="shareAmount" type="text" class="money2" style="width: 160px; height: 13px; text-align: right; margin-left: 3px;" readonly="readonly" maxlength="17" lastValidValue="" tabindex="305"/>
						</td>
					</tr>
				<tr>
					<td class="rightAligned">Remarks</td>
					<td class="leftAligned" colspan="3">
						<div id="remarksDiv" name="remarksDiv" style="float: left; width: 438px; border: 1px solid gray; height: 22px;">
							<textarea style="float: left; height: 16px; width: 408px; margin-top: 0; border: none;" id="remarks" name="remarks" maxlength="4000" onkeyup="limitText(this,4000);" readonly="readonly" tabindex="306"></textarea>
							<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">User Id</td>
					<td class="leftAligned">
						<input id="userId" type="text" style="width: 160px;" readonly="readonly" tabindex="307">
					</td>
					<td width="89px" class="rightAligned">Last Update</td>
					<td class="leftAligned">
						<input id="lastUpdate" type="text" style="width: 160px; margin-left: 3px;" readonly="readonly" tabindex="308">
					</td>
				</tr>
				</table>
			</div>
			
			<div style="margin: 10px;" align="center">
				<input type="button" class="disabledButton" id="btnAddDistPeril" value="Add" tabindex="309">
				<input type="button" class="disabledButton" id="btnDeleteDistPeril" value="Delete" tabindex="310">
			</div>
		</div>
	</div>

	<div class="buttonsDiv">
		<input type="button" class="button" id="btnCancel" value="Cancel" tabindex="311">
		<input type="button" class="button" id="btnSave" value="Save" tabindex="312">
	</div>
</div>

<script type="text/javascript">
	var rowIndex = -1;
	var objGiiss165 = {};
	var selectedRow = null;
	objGiiss165.defDistList = JSON.parse('${distJSON}');
	objGiiss165.exitPage = null;
	
	var defDistModel = {
		id: 101,
		url: contextPath + "/GIISDefaultDistController?action=showGiiss165&refresh=1",
		options: {
			width: '900px',
			height: '207px',
			pager: {},
			beforeClick: function(){
				if(hasPendingChildRecords()){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus: function(element, value, x, y, id){
				rowIndex = y;
				selectedRow = defDistTG.geniisysRows[y];
				setFieldValues(selectedRow);
				defDistTG.keys.removeFocus(defDistTG.keys._nCurrentFocus, true);
				defDistTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				rowIndex = -1;
				setFieldValues(null);
				defDistTG.keys.removeFocus(defDistTG.keys._nCurrentFocus, true);
				defDistTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					defDistTG.onRemoveRowFocus();
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
				defDistTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				defDistTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				defDistTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'defaultNo',
				title: 'Default No.',
				width: '85px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : lpad(value, 9, "0");
				}
			},
			{	id: 'dspLineName',
				title: 'Line',
				width: '160px',
				filterOption: true
			},
			{	id: 'dspSublineName',
				title: 'Subline',
				width: '200px',
				filterOption: true
			},
			{	id: 'dspIssName',
				title: 'Issuing Source',
				width: '160px',
				filterOption: true
			},
			{	id: 'dspDistName',
				title: 'Default Dist Type',
				width: '130px',
				filterOption: true
			},
			{	id: 'dspDefaultName',
				title: 'Default Type',
				width: '130px',
				filterOption: true
			}
		],
		rows: objGiiss165.defDistList.rows
	};
	defDistTG = new MyTableGrid(defDistModel);
	defDistTG.pager = objGiiss165.defDistList;
	defDistTG.render("defaultDistTable");
	
	var perilModel = {
		id: 103,
		url: contextPath + "/GIISDefaultDistController?action=getPerilList",
		options: {
			width: '400px',
			height: '207px',
			pager: {},
			beforeClick: function(){
				if(hasPendingChildRecords()){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			onCellFocus: function(element, value, x, y, id){
				objGiiss165.selectedPeril = perilTG.geniisysRows[y].perilCd;
				getDistPerilVariables();
				perilTG.keys.removeFocus(perilTG.keys._nCurrentFocus, true);
				perilTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objGiiss165.selectedPeril = null;
				getDistPerilVariables();
				perilTG.keys.removeFocus(perilTG.keys._nCurrentFocus, true);
				perilTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					perilTG.onRemoveRowFocus();
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
				perilTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				perilTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				perilTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false			
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'perilName',
				title: 'Peril Name',
				width: '372px',
				filterOption: true
			}
		],
		rows: []
	};
	perilTG = new MyTableGrid(perilModel);
	perilTG.pager = {};
	perilTG.render("perilTable");
	
	var defDistPerilModel = {
		id: 104,
		url: contextPath + "/GIISDefaultDistController?action=getDefaultDistPerilList",
		options: {
			width: '595px',
			height: '207px',
			pager: {},
			onCellFocus: function(element, value, x, y, id){
				objGiiss165.distPerilIndex = y;
				setPerilValues(defDistPerilTG.geniisysRows[y]);
				defDistPerilTG.keys.removeFocus(defDistPerilTG.keys._nCurrentFocus, true);
				defDistPerilTG.keys.releaseKeys();
			},
			onRemoveRowFocus: function(){
				objGiiss165.distPerilIndex = -1;
				setPerilValues(null);
				defDistPerilTG.keys.removeFocus(defDistPerilTG.keys._nCurrentFocus, true);
				defDistPerilTG.keys.releaseKeys();
			},
			toolbar: {
				elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
				onFilter: function(){
					defDistPerilTG.onRemoveRowFocus();
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
				defDistPerilTG.onRemoveRowFocus();
			},
			onRefresh: function(){
				defDistPerilTG.onRemoveRowFocus();
			},				
			prePager: function(){
				if(changeTag == 1){
					showWaitingMessageBox(objCommonMessage.SAVE_CHANGES, "I", function(){
						$("btnSave").focus();
					});
					return false;
				}
				defDistPerilTG.onRemoveRowFocus();
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
			{   id: 'recordStatus',
			    width: '0',				    
			    visible: false
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false
			},
			{	id: 'sequence',
				title: 'Sequence',
				width: '85px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'integerNoNegative',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : lpad(value, 3, "0");
				}
			},
			{	id: 'trtyName',
				title: 'Share',
				width: '175px',
				filterOption: true
			},
			{	id: 'sharePct',
				title: 'Percent Share',
				width: '150px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : formatToNineDecimal(value);
				}
			},
			{	id: 'shareAmt1',
				title: 'Share Amount',
				width: '150px',
				align: 'right',
				titleAlign: 'right',
				filterOption: true,
				filterOptionType: 'numberNoNegative',
				renderer: function(value){
					return nvl(value, "") == "" ? "" : formatCurrency(value);
				}
			}
		],
		rows: []
	};
	defDistPerilTG = new MyTableGrid(defDistPerilModel);
	defDistPerilTG.pager = {};
	defDistPerilTG.render("distPerilTable");
	
	function showLineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiiss165LineLOV",
				issCd: $F("issCd"),
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
			},
			title: "List of Lines",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "lineCd",
								title: "Line Code",
								width: "100px"
							},
							{	id: "lineName",
								title: "Line Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("lineCd").value = unescapeHTML2(row.lineCd);
					$("dspLineName").value = unescapeHTML2(row.lineName);
					$("lineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
					
					$("sublineCd").value = "";
					$("dspSublineName").value = "";
					$("sublineCd").setAttribute("lastValidValue", "");
				}
			},
			onCancel: function(){
				$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showSublineLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiiss165SublineLOV",
				lineCd: $F("lineCd"),
				filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
			},
			title: "List of Sublines",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "sublineCd",
								title: "Subline Code",
								width: "100px"
							},
							{	id: "sublineName",
								title: "Subline Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("sublineCd").value = unescapeHTML2(row.sublineCd);
					$("dspSublineName").value = unescapeHTML2(row.sublineName);
					$("sublineCd").setAttribute("lastValidValue", unescapeHTML2(row.sublineCd));
				}
			},
			onCancel: function(){
				$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showIssourceLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiiss165IssourceLOV",
				lineCd: $F("lineCd"),
				filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%"
			},
			title: "List of Issuing Sources",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "issCd",
								title: "Issue Code",
								width: "100px"
							},
							{	id: "issName",
								title: "Issue Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("issCd").value = unescapeHTML2(row.issCd);
					$("dspIssName").value = unescapeHTML2(row.issName);
					$("issCd").setAttribute("lastValidValue", unescapeHTML2(row.issCd));
				}
			},
			onCancel: function(){
				$("issCd").value = $("issCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("issCd").value = $("issCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showTypeLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiiss165DistLOV",
				rvDomain: "GIIS_DEFAULT_DIST.DEFAULT_TYPE",
				filterText: $F("defaultType") != $("defaultType").getAttribute("lastValidValue") ? nvl($F("defaultType"), "%") : "%"
			},
			title: "List of Default Types",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "type",
								title: "Code",
								width: "100px"
							},
							{	id: "meaning",
								title: "Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("defaultType") != $("defaultType").getAttribute("lastValidValue") ? nvl($F("defaultType"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("defaultType").value = unescapeHTML2(row.type);
					$("dspDefaultName").value = unescapeHTML2(row.meaning);
					$("defaultType").setAttribute("lastValidValue", unescapeHTML2(row.type));
				}
			},
			onCancel: function(){
				$("defaultType").value = $("defaultType").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("defaultType").value = $("defaultType").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showDistLOV(){
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: "getGiiss165DistLOV",
				rvDomain: "GIIS_DEFAULT_DIST.DIST_TYPE",
				filterText: $F("distType") != $("distType").getAttribute("lastValidValue") ? nvl($F("distType"), "%") : "%"
			},
			title: "List of Default Dist Types",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "type",
								title: "Code",
								width: "100px"
							},
							{	id: "meaning",
								title: "Description",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("distType") != $("distType").getAttribute("lastValidValue") ? nvl($F("distType"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("distType").value = unescapeHTML2(row.type);
					$("dspDistName").value = unescapeHTML2(row.meaning);
					$("distType").setAttribute("lastValidValue", unescapeHTML2(row.type));
				}
			},
			onCancel: function(){
				$("distType").value = $("distType").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("distType").value = $("distType").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}
	
	function showTrtyLOV(){
		var action = $F("defaultType") == "1" ? "getGiiss165TrtyV2LOV" : "getGiiss165TrtyLOV";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action: action,
				defaultNo: $F("defaultNo"),
				lineCd: $F("lineCd"),
				perilCd: objGiiss165.selectedPeril,
				notIn: createNotInParam(0),
				notInDeleted: createNotInParam(-1),
				filterText: $F("shareCd") != $("shareCd").getAttribute("lastValidValue") ? nvl($F("shareCd"), "%") : "%"
			},
			title: "List of Distribution Shares",
			width: 365,
			height: 386,
			columnModel:[
							{	id: "shareCd",
								title: "Share Code",
								width: "100px",
								align: "right",
								titleAlign: "right"
							},
							{	id: "trtyName",
								title: "Treaty Name",
								width: "250px"
							}
						],
			draggable: true,
			showNotice: true,
			autoSelectOneRecord : true,
			filterText: $F("shareCd") != $("shareCd").getAttribute("lastValidValue") ? nvl($F("shareCd"), "%") : "%",
		    noticeMessage: "Getting list, please wait...",
			onSelect : function(row){
				if(row != undefined) {
					$("shareCd").value = unescapeHTML2(row.shareCd);
					$("trtyName").value = unescapeHTML2(row.trtyName);
					$("shareCd").setAttribute("lastValidValue", unescapeHTML2(row.shareCd));
				}
			},
			onCancel: function(){
				$("shareCd").value = $("shareCd").getAttribute("lastValidValue");
			},
			onUndefinedRow: function(){
				showMessageBox("No record selected.", "I");
				$("shareCd").value = $("shareCd").getAttribute("lastValidValue");
			},
			onShow: function(){
				$(this.id+"_txtLOVFindText").focus();
			}
		});
	}

	function newFormInstance(){
		$("defaultNo").focus();
		setModuleId("GIISS165");
		setDocumentTitle("Default Peril Distribution Maintenance");
		initializeAll();
		initializeAccordion();
		initializeAllMoneyFields();
		makeInputFieldUpperCase();
		disableSearch("searchShareCd");
		changeTag = 0;
		
		/* $("distType").value = "2";
		$("dspDistName").value = "BY PERIL";
		$("distType").setAttribute("lastValidValue", "2");
		
		$("defaultType").value = "2";
		$("dspDefaultName").value = "BY PERCENTAGE";
		$("defaultType").setAttribute("lastValidValue", "2"); */
	}
	
	function showRangeOverlay(){
		if(changeTag == 1){
			showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
			return;
		}
		
		rangeOverlay = Overlay.show(contextPath+"/GIISDefaultDistController", {
			urlParameters: {
				action: "showRangeOverlay",
				defaultNo: $F("defaultNo")
			},
			showNotice: true,
			urlContent: true,
			draggable: true,
		    title: "Range",
		    height: 340,
		    width: 510
		});
	}
	
	function getPerils(){
		perilTG.url = contextPath + "/GIISDefaultDistController?action=getPerilList&lineCd="+$F("lineCd");
		perilTG._refreshList();
	}
	
	function getDistPerilVariables(){
		try{
			new Ajax.Request(contextPath + "/GIISDefaultDistController", {
				parameters: {
					action: "getDistPerilVariables",
					defaultNo: $F("defaultNo"),
					lineCd: $F("lineCd"),
					perilCd: objGiiss165.selectedPeril
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objGiiss165.totalSharePct = obj.totalSharePct;
						objGiiss165.maxSequence = obj.maxSequence;
						
						defDistPerilTG.url = contextPath + "/GIISDefaultDistController?action=getDefaultDistPerilList&defaultNo="+$F("defaultNo")+
															"&lineCd="+$F("lineCd")+"&perilCd="+nvl(objGiiss165.selectedPeril, 0);
						defDistPerilTG._refreshList();
					}
				}
			});
		}catch(e){
			showErrorMessage("getTotalSharePct", e);
		}
	}
	
	function hasPendingChildRecords(){
		try{
			return getDeletedJSONObjects(defDistPerilTG.geniisysRows).length > 0 || 
					getAddedAndModifiedJSONObjects(defDistPerilTG.geniisysRows).length ? true : false;
		}catch(e){
			showErrorMessage("hasPendingChildRecords", e);
		}
	}
	
	function createNotInParam(status){
		var notIn = "";
		var withPrevious = false;
		var rows = defDistPerilTG.geniisysRows;

		for(var i = 0; i < rows.length; i++){
			if(rows[i].recordStatus == status){
				if(withPrevious){
					notIn += ",";
				}
				notIn += rows[i].shareCd;
				withPrevious = true;
			}
		}
		
		return (notIn != "" ? "("+notIn+")" : "");
	}
	
	function setFieldValues(rec){
		try{
			$("defaultNo").value = (rec == null ? "" :  (nvl(rec.defaultNo, "") == "" ? "" : lpad(rec.defaultNo, 9, "0")));
			$("lineCd").value = (rec == null ? "" : unescapeHTML2(rec.lineCd));
			$("dspLineName").value = (rec == null ? "" : unescapeHTML2(rec.dspLineName));
			$("sublineCd").value = (rec == null ? "" : unescapeHTML2(rec.sublineCd));
			$("dspSublineName").value = (rec == null ? "" : unescapeHTML2(rec.dspSublineName));
			$("issCd").value = (rec == null ? "" : unescapeHTML2(rec.issCd));
			$("dspIssName").value = (rec == null ? "" : unescapeHTML2(rec.dspIssName));
			$("defaultType").value = (rec == null ? "" : rec.defaultType);
			$("dspDefaultName").value = (rec == null ? "" : unescapeHTML2(rec.dspDefaultName));
			$("distType").value = (rec == null ? "" : rec.distType);
			$("dspDistName").value = (rec == null ? "" : unescapeHTML2(rec.dspDistName));
			
			$("lineCd").setAttribute("lastValidValue", (rec == null ? "" : $F("lineCd")));
			$("sublineCd").setAttribute("lastValidValue", (rec == null ? "" : $F("sublineCd")));
			$("issCd").setAttribute("lastValidValue", (rec == null ? "" : $F("issCd")));
			$("defaultType").setAttribute("lastValidValue", (rec == null ? "" : $F("defaultType")));
			$("distType").setAttribute("lastValidValue", (rec == null ? "" : $F("distType")));
			
			if(rec == null){
				$("sharePct").removeClassName("required");
				$("shareAmount").removeClassName("required");
			}else{
				if($F("defaultType") == 1){
					$("sharePct").removeClassName("required");
					$("shareAmount").addClassName("required");
				}else{
					$("sharePct").addClassName("required");
					$("shareAmount").removeClassName("required");
				}
			}
			
			rec == null ? $("btnAdd").value = "Add" : $("btnAdd").value = "Update";
			rec == null ? disableButton("btnDelete") : enableButton("btnDelete");
			//Range button temporarily disabled
			//rec == null ? disableButton("btnRange") : enableButton("btnRange");
			
			rec == null ? enableSearch("searchLineCd") : disableSearch("searchLineCd");
			rec == null ? enableSearch("searchSublineCd") : disableSearch("searchSublineCd");
			rec == null ? enableInputField("lineCd") : disableInputField("lineCd");
			rec == null ? enableInputField("sublineCd") : disableInputField("sublineCd");
			
			selectedRow = rec;
			getPerils();
		}catch(e){
			showErrorMessage("setFieldValues", e);
		}
	}
	
	function setPerilValues(rec){
		try{
			$("sequence").value = (rec == null ? "" :  (nvl(rec.sequence, "") == "" ? "" : lpad(rec.sequence, 3, "0")));
			$("shareCd").value = (rec == null ? "" : rec.shareCd);
			$("trtyName").value = (rec == null ? "" : unescapeHTML2(rec.trtyName));
			$("sharePct").value = (rec == null ? "" : (nvl(rec.sharePct, "") == "" ? "" : formatToNineDecimal(rec.sharePct)));
			$("shareAmount").value = (rec == null ? "" : (nvl(rec.shareAmt1, "") == "" ? "" : formatCurrency(rec.shareAmt1)));
			$("remarks").value = (rec == null ? "" : unescapeHTML2(rec.remarks));
			$("userId").value = (rec == null ? "" : unescapeHTML2(rec.userId));
			$("lastUpdate").value = (rec == null ? "" : rec.lastUpdate);
			
			if(rec == null && objGiiss165.selectedPeril == null){
				$("btnAddDistPeril").value = "Add";
				
				disableInputField("shareCd");
				disableInputField("sharePct");
				disableInputField("shareAmount");
				disableInputField("remarks");
				disableSearch("searchShareCd");
				disableButton("btnAddDistPeril");
				disableButton("btnDeleteDistPeril");
			}else if(rec == null && objGiiss165.selectedPeril != null){
				if($F("defaultType") == "1"){
					enableInputField("shareAmount");
					disableInputField("sharePct");
				}else{
					disableInputField("shareAmount");
					enableInputField("sharePct");
				}
			
				$("btnAddDistPeril").value = "Add";
				enableButton("btnAddDistPeril");
				disableButton("btnDeleteDistPeril");
				enableInputField("remarks");
				enableSearch("searchShareCd");
				enableInputField("shareCd");
			}else{
				if($F("defaultType") == "1"){
					enableInputField("shareAmount");
					disableInputField("sharePct");
				}else{
					disableInputField("shareAmount");
					enableInputField("sharePct");
				}
				
				$("btnAddDistPeril").value = "Update";
				enableButton("btnAddDistPeril");
				enableButton("btnDeleteDistPeril");
				enableInputField("remarks");
				disableSearch("searchShareCd");
				disableInputField("shareCd");
			}
			
			objGiiss165.selectedDistPeril = rec;
		}catch(e){
			showErrorMessage("setPerilValues", e);
		}
	}
	
	function confirmSave(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		if($F("defaultType") == "2" && objGiiss165.selectedPeril != null && (parseFloat(objGiiss165.totalSharePct) != parseFloat(100))){
			if(parseInt(defDistPerilTG.geniisysRows.filter(function(obj){return parseInt(nvl(obj.recordStatus, 0)) != parseInt(-1);}).length) > parseInt(0)){
				objGiiss165.exitPage = null;
				showMessageBox("Total share percent must be 100%.", "I");
				return;
			}
		}
		
		showConfirmBox("Confirmation", "Saving this record will delete the existing record for the same line_cd, default_type, " + 
			"dist_type, subline_cd and iss_cd with NULL range values. Do you want to continue?", "Yes", "No", saveGiiss165,
			function(){
				objGiiss165.exitPage = null;
			}, "1");
	}
	
	function valAddRec(){
		if(checkAllRequiredFieldsInDiv("defaultDistFormDiv")){
			if(hasPendingChildRecords()){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return;
			}
			
			var proceed = false;
			for(var i = 0; i < defDistTG.geniisysRows.length; i++){
				var row = defDistTG.geniisysRows[i];
				
				if(row.recordStatus != -1 && i != rowIndex){
					if(row.lineCd == $F("lineCd") && row.sublineCd == $F("sublineCd") && row.issCd == $F("issCd")){
						showMessageBox("Record already exists with the same line_cd, subline_cd and iss_cd.", "E");
						return;
					}
				}
				if(row.recordStatus == -1 && row.lineCd == $F("lineCd") && row.sublineCd == $F("sublineCd") && row.issCd == $F("issCd")){
					proceed = true;
				}
			}
			if(proceed){
				addRec();
				return;
			}
			
			new Ajax.Request(contextPath + "/GIISDefaultDistController", {
				parameters: {
					action: "valAddRec",
					defaultNo: $F("defaultNo"),
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					issCd: $F("issCd")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						addRec();
					}
				}
			});
		}
	}
	
	function setRec(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			obj.defaultNo = $F("defaultNo");
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.dspLineName = escapeHTML2($F("dspLineName"));
			obj.defaultType = escapeHTML2($F("defaultType"));
			obj.dspDefaultName = escapeHTML2($F("dspDefaultName"));
			obj.distType = escapeHTML2($F("distType"));
			obj.dspDistName = escapeHTML2($F("dspDistName"));
			obj.sublineCd = escapeHTML2($F("sublineCd"));
			obj.dspSublineName = escapeHTML2($F("dspSublineName"));
			obj.issCd = escapeHTML2($F("issCd"));
			obj.dspIssName = escapeHTML2($F("dspIssName"));
			obj.userId = userId;
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setRec", e);
		}
	}
	
	function addRec(){
		try{
			changeTagFunc = saveGiiss165;
			var row = setRec(selectedRow);
			
			if($F("btnAdd") == "Add"){
				defDistTG.addBottomRow(row);
			} else {
				defDistTG.updateVisibleRowOnly(row, rowIndex, false);
			}
			
			changeTag = 1;
			setFieldValues(null);
			defDistTG.keys.removeFocus(defDistTG.keys._nCurrentFocus, true);
			defDistTG.keys.releaseKeys();
		}catch(e){
			showErrorMessage("addRec", e);
		}
	}
	
	function valDeleteRec(){
		try{
			if(hasPendingChildRecords()){
				showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
				return;
			}
			if($F("defaultNo") == ""){
				deleteRec();
			}else{
				new Ajax.Request(contextPath + "/GIISDefaultDistController", {
					parameters: {
						action: "valDeleteRec",
						defaultNo: $F("defaultNo")
					},
					asynchronous: false,
					evalScripts: true,
					onCreate : showNotice("Processing, please wait..."),
					onComplete : function(response){
						hideNotice();
						if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							deleteRec();
						} 
					} 
				}); 
			} 
		} catch(e){
			showErrorMessage("valDeleteRec", e);
		}
	}
	
	function deleteRec(){
		changeTagFunc = saveGiiss165;
		selectedRow.recordStatus = -1;
		defDistTG.deleteRow(rowIndex);
		changeTag = 1;
		setFieldValues(null);
	}
	
	function valAddPeril(){
		try{
			if(checkAllRequiredFieldsInDiv("defaultDistPerilFormDiv")){
				if($F("defaultType") == "1"){
					addPeril();
				}else if($F("defaultType") == "2"){
					var newTotal = 0;
					if($F("btnAddDistPeril") == "Add"){
						newTotal = parseFloat(nvl(objGiiss165.totalSharePct, 0)) + parseFloat($F("sharePct"));
					}else{
						newTotal = (parseFloat(nvl(objGiiss165.totalSharePct, 0)) -
									parseFloat(objGiiss165.selectedDistPeril.sharePct)) +
									parseFloat($F("sharePct"));
					}
					
					if(parseFloat(newTotal) > parseFloat(100)){
						showMessageBox("Total share percent must not exceed 100%.", "I");
					}else{
						objGiiss165.totalSharePct = newTotal;
						addPeril();
					}
				}
			}
		}catch(e){
			showErrorMessage("valAddPeril", e);
		}
	}
	
	function setPeril(rec){
		try {
			var obj = (rec == null ? {} : rec);
			
			if(nvl(obj.sequence, "") == ""){
				objGiiss165.maxSequence = parseInt(objGiiss165.maxSequence) + 1;
				obj.sequence = objGiiss165.maxSequence;
				obj.childTag = "Y";
				selectedRow.childTag = "Y";
				defDistTG.updateVisibleRowOnly(selectedRow, rowIndex, true);
			}else{
				obj.sequence = $F("sequence");
			}
			
			obj.defaultNo = $F("defaultNo");
			obj.lineCd = escapeHTML2($F("lineCd"));
			obj.perilCd = objGiiss165.selectedPeril;
			obj.shareCd = $F("shareCd");
			obj.trtyName = escapeHTML2($F("trtyName"));
			obj.sharePct = $F("sharePct");
			obj.shareAmt1 = $F("shareAmount");
			obj.userId = escapeHTML2(userId);
			obj.remarks = escapeHTML2($F("remarks"));
			obj.lastUpdate = dateFormat(new Date(), 'mm-dd-yyyy hh:MM:ss TT');
			
			return obj;
		} catch(e){
			showErrorMessage("setPeril", e);
		}
	}
	
	function addPeril(){
		try{
			if(checkAllRequiredFieldsInDiv("defaultDistPerilFormDiv")){
				changeTagFunc = saveGiiss165;
				var row = setPeril(objGiiss165.selectedDistPeril);
				
				if($F("btnAddDistPeril") == "Add"){
					defDistPerilTG.addBottomRow(row);
				} else {
					defDistPerilTG.updateVisibleRowOnly(row, objGiiss165.distPerilIndex, false);
				}
				
				changeTag = 1;
				setPerilValues(null);
				defDistPerilTG.keys.removeFocus(defDistPerilTG.keys._nCurrentFocus, true);
				defDistPerilTG.keys.releaseKeys();
			}
		}catch(e){
			showErrorMessage("addPeril", e);
		}
	}
	
	function valDeletePeril(){
		if(parseInt(objGiiss165.selectedDistPeril.sequence) == parseInt(objGiiss165.maxSequence)){
			objGiiss165.maxSequence = parseInt(objGiiss165.maxSequence) - parseInt(1);
			deletePeril();
		}else{
			showMessageBox("Only records with the last sequence can be deleted.", "I");
		}
	}
	
	function deletePeril(){
		changeTagFunc = saveGiiss165;
		objGiiss165.totalSharePct = parseFloat(objGiiss165.totalSharePct) - parseFloat(objGiiss165.selectedDistPeril.sharePct);
		objGiiss165.selectedDistPeril.recordStatus = -1;
		defDistPerilTG.deleteRow(objGiiss165.distPerilIndex);
		changeTag = 1;
		setPerilValues(null);
	}
	
	function saveGiiss165(){
		var setRows = getAddedAndModifiedJSONObjects(defDistTG.geniisysRows);
		var delRows = getDeletedJSONObjects(defDistTG.geniisysRows);
		var setPerilRows = getAddedAndModifiedJSONObjects(defDistPerilTG.geniisysRows);
		var delPerilRows = getDeletedJSONObjects(defDistPerilTG.geniisysRows);
		
		new Ajax.Request(contextPath+"/GIISDefaultDistController", {
			method: "POST",
			parameters: {
				action: "saveGiiss165",
				setRows: prepareJsonAsParameter(setRows),
				delRows: prepareJsonAsParameter(delRows),
				setPerilRows: prepareJsonAsParameter(setPerilRows),
				delPerilRows: prepareJsonAsParameter(delPerilRows)
			},
			asynchronous: false,
			evalScripts: true,
			onCreate : showNotice("Saving, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						if(objGiiss165.exitPage != null) {
							objGiiss165.exitPage();
						} else {
							defDistTG._refreshList();
						}
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function checkDistRecords(){
		try{
			new Ajax.Request(contextPath + "/GIISDefaultDistController", {
				parameters: {
					action: "checkDistRecords",
					defaultNo: $F("defaultNo"),
					lineCd: $F("lineCd")
				},
				asynchronous: false,
				evalScripts: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete : function(response){
					hideNotice();
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						showTypeLOV();
					}else{
						$("defaultType").value = $("defaultType").getAttribute("lastValidValue");
					}
				}
			});
		} catch(e){
			showErrorMessage("checkDistRecords", e);
		}
	}
	
	function exitPage(){
		changeTag = 0;
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	}
	
	function cancelGiiss165(){
		if(changeTag ==1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
				function(){
					objGiiss165.exitPage = exitPage;
					//saveGiiss165();
					confirmSave();
				}, exitPage, "");
		} else {
			exitPage();
		}
	}
	
	function observeLOVOnChange(code, name, func){
		$(code).observe("change", function(){
			if($F(code) == ""){
				$(code).setAttribute("lastValidValue", "");
				$(name).value = "";
				
				if(code == "lineCd"){
					$("sublineCd").value = "";
					$("dspSublineName").value = "";
					$("sublineCd").setAttribute("lastValidValue", "");
				}
			}else{
				func();
			}
		});
	}
	
	$w("shareCd sharePct shareAmount").each(function(e){
		$(e).observe("focus", function(){
			$(e).setAttribute("lastValidValue", $F(e));
		});
	});
	
	$("shareCd").observe("change", function(){
		if($F("shareCd") != "" && (isNaN($F("shareCd")) || parseInt($F("shareCd")) < 1  || $F("shareCd").include("."))){
			showWaitingMessageBox("Invalid Share Code. Valid value should be from 1 to 999.", "E", function(){
				$("shareCd").value = $("shareCd").getAttribute("lastValidValue");
				$("shareCd").focus();
			});
		}else if($F("shareCd") == ""){
			$("shareCd").setAttribute("lastValidValue", "");
			$("trtyName").value = "";
		}else{
			showTrtyLOV();
		}
	});
	
	$("sharePct").observe("change", function(){
		if($F("sharePct") != "" && (isNaN($F("sharePct")) || parseFloat($F("sharePct")) < 0 || parseFloat($F("sharePct")) > 100)){
			showWaitingMessageBox("Invalid Percent Share. Valid value should be from 0.000000000 to 100.000000000.", "E", function(){
				$("sharePct").value = $("sharePct").getAttribute("lastValidValue");
				$("sharePct").focus();
			});
		}else{
			$("sharePct").value = formatToNineDecimal($F("sharePct"));
		}
	});
	
	$("shareAmount").observe("change", function(){
		var amount = unformatCurrencyValue($F("shareAmount"));
		
		if(amount != "" && (isNaN($F("shareAmount")) || parseFloat(amount) < 0 || parseFloat(amount) > parseFloat(99999999999990.99))){
			showWaitingMessageBox("Invalid Share Amount. Valid value should be from 0.00 to 99,999,999,999,990.99.", "E", function(){
				$("shareAmount").value = $("shareAmount").getAttribute("lastValidValue");
				$("shareAmount").focus();
			});
		}else{
			$("shareAmount").value = formatCurrency($F("shareAmount"));
		}
	});
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("remarks", 4000, $("remarks").hasAttribute("readonly"));
	});
	
	$("btnExit").stopObserving("click");
	$("btnExit").observe("click", function(){
		fireEvent($("btnCancel"), "click");
	});
	
	$("searchLineCd").observe("click", showLineLOV);
	$("searchSublineCd").observe("click", showSublineLOV);
	$("searchIssCd").observe("click", showIssourceLOV);
	$("searchDefaultType").observe("click", checkDistRecords);
	$("searchDistType").observe("click", showDistLOV);
	$("searchShareCd").observe("click", showTrtyLOV);
	$("btnAdd").observe("click", valAddRec);
	$("btnDelete").observe("click", valDeleteRec);
	$("btnAddDistPeril").observe("click", valAddPeril);
	$("btnDeleteDistPeril").observe("click", valDeletePeril);
	$("btnRange").observe("click", showRangeOverlay);
	$("btnSave").observe("click", confirmSave);
	$("btnCancel").observe("click", cancelGiiss165);

	observeLOVOnChange("lineCd", "dspLineName", showLineLOV);
	observeLOVOnChange("sublineCd", "dspSublineName", showSublineLOV);
	observeLOVOnChange("issCd", "dspIssName", showIssourceLOV);
	observeLOVOnChange("distType", "dspDistName", showDistLOV);
	observeLOVOnChange("defaultType", "dspDefaultName", checkDistRecords);
	observeReloadForm("reloadForm", showGiiss165);
	newFormInstance();
</script>
