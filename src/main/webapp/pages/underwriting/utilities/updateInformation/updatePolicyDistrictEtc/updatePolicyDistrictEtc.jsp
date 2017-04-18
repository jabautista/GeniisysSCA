<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="updatePolicyDistrictEtcMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv" style="width: 100%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Update Block Details</label>
	   		<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="policyDiv" class="sectionDiv" style="width: 920px; height: 100px;">
		<table align="center" border="0" style="margin: 20px auto;">
			<tr>
				<input id="hidPolicyId" type="hidden"/>
				<input id="hidParId" type="hidden"/>
				<td style="padding-right: 5px;"><label for="txtLineCd" style="float: right;">Policy No.</label></td>
				<td>
					<input type="text" id="txtLineCd" class="required allCaps" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="101"/>
				</td>
				<td>
					<input type="text" id="txtSublineCd" class="required allCaps" maxlength="7" style="width: 70px; margin: 0px; height: 14px; " tabindex="102" />
				</td>
				<td>
					<input type="text" id="txtIssCd" class="required allCaps" maxlength="2" style="width: 40px; margin: 0px; height: 14px;" tabindex="103"/>
				</td>
				<td>
					<input type="text" id="txtIssueYy" class="required integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 40px; margin: 0px; height: 14px; text-align: right;" tabindex="104"/>
				</td>
				<td>
					<input type="text" id="txtPolSeqNo" class="required integerNoNegativeUnformattedNoComma" maxlength="7" style="width: 70px; margin: 0px; height: 14px; text-align: right;" tabindex="105"/>
				</td>
				<td>
					<input type="text" id="txtRenewNo" class="required integerNoNegativeUnformattedNoComma" maxlength="2" style="width: 40px; margin: 0px; height: 14px; text-align: right;" tabindex="106"/>
				</td>
				<td>
					<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicy" alt="Go" style="float: right;" tabindex="107"/>
				</td>
				<td style="padding-right: 5px;"><label for="txtEndtIssCd" style="margin-left: 20px; float: right;">Endorsement No.</label></td>
				<td>
					<input id="hidEndtIssCd" type="hidden"/>
					<input id="hidEndtYy" type="hidden"/>
					<input id="hidEndtSeqNo" type="hidden"/>
					<input type="text" id="txtDspEndtIssCd" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" tabindex="108"/>
				</td>
				<td>
					<input type="text" id="txtDspEndtYy" class="allCaps" style="width: 40px; margin: 0px; height: 14px;" tabindex="109"/>
				</td>
				<td>
					<input type="text" id="txtDspEndtSeqNo" class="allCaps" style="width: 70px; margin: 0px; height: 14px;" tabindex="110"/>
				</td>
			</tr>
			<tr>
				<input id="hidAssdNo" type="hidden"/>
				<td style="padding-right: 5px;"><label for="txtAssured" style="float: right;">Assured</label></td>
				<td colspan="11">
					<input type="text" id="txtAssdName" class="" style="margin: 0; width: 695px; height: 14px;" tabindex="111"/>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="fireItemDiv" class="sectionDiv" style="width: 920px; height: 500px;">
	
		<div id="fireItemTGDiv" style="margin: 10px; height: 270px"></div>
		
		<table id="fireItemFieldsTbl" cellspacing="0" width="80%" align="center" style="margin: 20px 15px 10px 15px;">
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Province</td>
				<td>
					<div id="provinceCdDiv" class="required" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="txtProvinceCd" name="txtProvinceCd" class="leftAligned upper required" type="text" maxlength="6" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="201" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchProvince" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="txtProvinceDesc" type="text" readonly="readonly" class="" style="width: 245px;" lastValidValue="" tabindex="202"> </td>	
				<td class="rightAligned" style="padding: 0 7px 0 67px;">Risk</td>
				<td>
					<div id="risCdkDiv" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="riskCd" name="riskCd" class="leftAligned upper" type="text" maxlength="7" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="203" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRisk" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="risk" type="text" readonly="readonly" style="width: 245px;" lastValidValue="" tabindex="204"> </td>					
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">City</td>
				<td>
					<div id="cityCdDiv" class="required" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="txtCityCd" name="txtCityCd" class="leftAligned upper required" type="text" maxlength="6" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="205" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCity" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="txtCity" type="text" readonly="readonly" class="" style="width: 245px;" lastValidValue="" tabindex="206"> </td>	
				<td class="rightAligned" style="padding: 0 7px 0 0px;">EQ Zone</td>
				<td>
					<div id="eqzoneDiv" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="eqZone" name="eqZone" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="207" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchEqZone" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="eqZoneDesc" type="text" readonly="readonly" style="width: 245px;" lastValidValue="" tabindex="208"> </td>					
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">District</td>
				<td>
					<div id="districtNoDiv" class="required" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="txtDistrictNo" name="txtDistrictNo" class="leftAligned upper required" type="text" maxlength="6" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="209" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchDistrict" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="txtDistrictDesc" type="text" readonly="readonly" class="" style="width: 245px;" lastValidValue="" tabindex="210"> </td>	
				<td class="rightAligned" style="padding: 0 7px 0 0px;">Flood Zone</td>
				<td>
					<div id="floodZoneDiv" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="floodZone" name="floodZone" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="211" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchFloodZone" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="floodZoneDesc" type="text" readonly="readonly" style="width: 245px;" lastValidValue="" tabindex="212"> </td>					
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Block</td>
				<td>
					<input id="hidBlockId" type="hidden"/>
					<div id="blockNoDiv" class="required" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="txtBlockNo" name="txtBlockNo" class="leftAligned upper required" type="text" maxlength="6" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="213" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBlock" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="txtBlockDesc" type="text" readonly="readonly" class="" style="width: 245px;" lastValidValue="" tabindex="214"> </td>	
				<td class="rightAligned" style="padding: 0 7px 0 0px;">Typhoon Zone</td>
				<td>
					<div id="typhoonZoneDiv" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="typhoonZone" name="typhoonZone" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="215" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTyphoonZone" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="typhoonZoneDesc" type="text" readonly="readonly" style="width: 245px;" lastValidValue="" tabindex="216"> </td>					
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 7px;">Tariff</td>
				<td>
					<div id="tarfDiv" class="required" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="tarfCd" name="tarfCd" class="leftAligned upper required" type="text" maxlength="12" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="217" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTarf" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="tarfDesc" type="text" readonly="readonly" class="" style="width: 245px;" lastValidValue="" tabindex="218"> </td>	
				<td class="rightAligned" style="padding: 0 7px 0 0px;">Tariff Zone</td>
				<td>
					<div id="tariffZoneDiv" style="border: 1px solid gray; width: 110px; height: 20px; float: left;">
						<input id="tariffZone" name="tariffZone" class="leftAligned upper" type="text" maxlength="2" style="border: none; float: left; width: 80px; height: 13px; margin: 0px;" value="" tabindex="219" lastValidValue=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTariffZone" name="searchFiLovs" alt="Go" style="float: right;"/>
					</div>
				</td>
				<td><input id="tariffZoneDesc" type="text" readonly="readonly" style="width: 245px;" lastValidValue="" tabindex="220"> </td>					
			</tr>
		</table>
		
		<div id="fireItemBtnsDiv" class="buttonsDiv">
			<input id="btnUpdate" type="button" class="button" value="Update" style="width: 80px;" tabindex="221">
			<input id="btnHistory" type="button" class="button" value="History" style="width: 80px;" tabindex="222">
		</div>
	</div>
	
	<div id="mainBtnsDiv" class="buttonsDiv">
		<input id="btnCancel" type="button" class="button" value="Cancel" tabindex="301">
		<input id="btnSave" type="button" class="button" value="Save" tabindex="302">
	</div>
	
</div>

<script type="text/javascript">
try{
	setModuleId("GIPIS155");
	setDocumentTitle("Update Block Details");
	//makeInputFieldsUpperCase();
	initializeAll();
	
	disableButton("btnSave");
	
	showToolbarButton("btnToolbarSave");
	hideToolbarButton("btnToolbarPrint");
	disableToolbarButton("btnToolbarSave");	
	disableToolbarButton("btnToolbarExecuteQuery");	
	disableToolbarButton("btnToolbarEnterQuery");	
	
	var selectedRowInfo = null;
	var selectedIndex = null;
	var exitPage = null;
	
	changeTag = 0;
	
	var objFI = new Object();
	objFI.tableGrid = JSON.parse('${fireitemGrid}'.replace(/\\/g, '\\\\'));
	objFI.objRows = objFI.tableGrid.rows || [];
	objFI.objList = [];	// holds all the geniisys rows
	
	try{
		var fiTableModel = {
			url: contextPath + "/UpdateUtilitiesController?action=getGipis155FireItemListing&refresh=1",
			options: {
				width : '900px',
				height: '250px',
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = fireItemTG.geniisysRows[y];
					selectedIndex = y;
					populateFireItemInformation(selectedRowInfo);
					fireItemTG.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					fireItemTG.keys.releaseKeys();
					selectedRowInfo = null;
					selectedIndex = null;
					populateFireItemInformation(null);
				},
				beforeSort: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}
				},
				onSort: function(){
					fireItemTG.onRemoveRowFocus();
				},
				prePager: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						fireItemTG.onRemoveRowFocus();
					}					
				},
				onRefresh: function(){
					if (changeTag == 1){
						showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
						return false;
					}else{
						fireItemTG.onRemoveRowFocus();
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
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						fireItemTG.onRemoveRowFocus();
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
					id: 'blockId',
					width: '0px',
					visible: false
				},
				{
					id: 'provinceDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'city',
					width: '0px',
					visible: false
				},
				{
					id: 'districtNo',
					width: '0px',
					visible: false
				},
				{
					id: 'districtDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'blockNo',
					width: '0px',
					visible: false
				},
				{
					id: 'blockDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'riskDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'eqZoneDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'floodZoneDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'typhoonZoneDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'origTarfCd',
					width: '0px',
					visible: false
				},
				{
					id: 'tarfDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'tariffZoneDesc',
					width: '0px',
					visible: false
				},
				{
					id: 'userId',
					width: '0px',
					visible: false
				},
				{
					id: 'lastUpdate',
					width: '0px',
					visible: false
				},  	
				{
					id: 'itemNo',
					title: 'Item No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},  	
				{
					id: 'provinceCd',
					title: 'Province Cd',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'cityCd',
					title: 'City Cd',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'nbDistrictNo',
					title: 'District No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'nbBlockNo',
					title: 'Block No.',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'riskCd',
					title: 'Risk',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},   	
				{
					id: 'eqZone',
					title: 'EQ Zone',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'floodZone',
					title: 'Flood Zone',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'typhoonZone',
					title: 'Typhoon Zone',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'tarfCd',
					title: 'Tarf Cd',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				},  	
				{
					id: 'tariffZone',
					title: 'Tariff Zone',
					width: '100px',
					visible: true,
					sortable: true,
					filterOption: true
				}
			],
			rows: objFI.objRows
		};
		
		fireItemTG = new MyTableGrid(fiTableModel);
		fireItemTG.pager = objFI.tableGrid;
		fireItemTG.render('fireItemTGDiv');
		fireItemTG.afterRender = function(){
			objFI.objList = fireItemTG.geniisysRows;
		};
		
	}catch(e){
		showErrorMessage("Fireitem tablegrid error", e);
	}
	

	function populatePolicyInformation(row){
		try{
			row == null ? $("hidParId").clear() : $("hidParId").value = row.parId;
			row == null ? $("hidPolicyId").clear() : $("hidPolicyId").value = row.policyId;
			row == null ? $("hidEndtIssCd").clear : $("hidEndtIssCd").value = unescapeHTML2(row.endtIssCd);
			row == null ? $("hidEndtYy").clear() : $("hidEndtYy").value = row.endtYy;
			row == null ? $("hidEndtSeqNo").clear() : $("hidEndtSeqNo").value = row.endtSeqNo;
			row == null ? $("hidAssdNo").clear() : $("hidAssdNo").value = row.assdNo;
			row == null ? $("txtLineCd").clear() : $("txtLineCd").value = unescapeHTML2(row.lineCd);
			row == null ? $("txtSublineCd").clear() : $("txtSublineCd").value = unescapeHTML2(row.sublineCd);
			row == null ? $("txtIssCd").clear() : $("txtIssCd").value = unescapeHTML2(row.issCd);
			row == null ? $("txtIssueYy").clear() : $("txtIssueYy").value = row.issueYy;
			row == null ? $("txtPolSeqNo").clear() : $("txtPolSeqNo").value = formatNumberDigits(row.polSeqNo, 7);
			row == null ? $("txtRenewNo").clear() : $("txtRenewNo").value = formatNumberDigits(row.renewNo, 2);
			row == null ? $("txtDspEndtIssCd").clear() : $("txtDspEndtIssCd").value = unescapeHTML2(row.dspEndtIssCd);
			row == null ? $("txtDspEndtYy").clear() : $("txtDspEndtYy").value = row.dspEndtYy;
			row == null ? $("txtDspEndtSeqNo").clear() : $("txtDspEndtSeqNo").value = row.dspEndtSeqNo;
			row == null ? $("txtAssdName").clear() : $("txtAssdName").value = unescapeHTML2(row.assdName);
		}catch(e){
			showErrorMessage("populatePolicyInformation", e);
		}
	}
	
	function togglePolicyFields(enable){
		try{
			if(enable){
				$$("div#policyDiv input[type='text']").each(function(txt){
					$(txt).readOnly = false;
				});
				enableSearch("searchPolicy");
				disableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarSave");
				disableButton("btnSave");
			}else{
				$$("div#policyDiv input[type='text']").each(function(txt){
					$(txt).readOnly = true;
				});
				disableSearch("searchPolicy");
				enableToolbarButton("btnToolbarSave");
				enableButton("btnSave");
			}
		}catch(e){
			showErrorMessage("togglePolicyFields", e);
		}
	}
	
	function populateFireItemInformation(row){
		try{
			row == null ? $("hidBlockId").clear() : $("hidBlockId").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("blockId"), selectedIndex));
			row == null ? $("txtProvinceCd").clear() : $("txtProvinceCd").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("provinceCd"), selectedIndex));
			row == null ? $("txtProvinceDesc").clear() : $("txtProvinceDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("provinceDesc"), selectedIndex));
			row == null ? $("txtCityCd").clear() : $("txtCityCd").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("cityCd"), selectedIndex));
			row == null ? $("txtCity").clear() : $("txtCity").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("city"), selectedIndex));
			row == null ? $("txtDistrictNo").clear() : $("txtDistrictNo").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("nbDistrictNo"), selectedIndex));
			row == null ? $("txtDistrictDesc").clear() : $("txtDistrictDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("districtDesc"), selectedIndex));
			row == null ? $("txtBlockNo").clear() : $("txtBlockNo").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("nbBlockNo"), selectedIndex));
			row == null ? $("txtBlockDesc").clear() : $("txtBlockDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("blockDesc"), selectedIndex));
			row == null ? $("tarfCd").clear() : $("tarfCd").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tarfCd"), selectedIndex));
			row == null ? $("tarfDesc").clear() : $("tarfDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tarfDesc"), selectedIndex));
			row == null ? $("riskCd").clear() : $("riskCd").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("riskCd"), selectedIndex));
			row == null ? $("risk").clear() : $("risk").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("riskDesc"), selectedIndex));
			row == null ? $("eqZone").clear() : $("eqZone").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("eqZone"), selectedIndex));
			row == null ? $("eqZoneDesc").clear() : $("eqZoneDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("eqZoneDesc"), selectedIndex));
			row == null ? $("floodZone").clear() : $("floodZone").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("floodZone"), selectedIndex));
			row == null ? $("floodZoneDesc").clear() : $("floodZoneDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("floodZoneDesc"), selectedIndex));
			row == null ? $("typhoonZone").clear() : $("typhoonZone").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("typhoonZone"), selectedIndex));
			row == null ? $("typhoonZoneDesc").clear() : $("typhoonZoneDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("typhoonZoneDesc"), selectedIndex));
			row == null ? $("tariffZone").clear() : $("tariffZone").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tariffZone"), selectedIndex));
			row == null ? $("tariffZoneDesc").clear() : $("tariffZoneDesc").value = unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tariffZoneDesc"), selectedIndex));
			
			row == null ? $("txtProvinceCd").setAttribute("lastValidValue", "") : $("txtProvinceCd").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("provinceCd"), selectedIndex)));
			//row == null ? $("txtProvinceDesc").setAttribute("lastValidValue", "") : $("txtProvinceDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("provinceDesc"), selectedIndex)));
			row == null ? $("txtCityCd").setAttribute("lastValidValue", "") : $("txtCityCd").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("cityCd"), selectedIndex)));
			//row == null ? $("txtCity").setAttribute("lastValidValue", "") : $("txtCity").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("city"), selectedIndex)));
			row == null ? $("txtDistrictNo").setAttribute("lastValidValue", "") : $("txtDistrictNo").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("nbDistrictNo"), selectedIndex)));
			//row == null ? $("txtDistrictDesc").setAttribute("lastValidValue", "") : $("txtDistrictDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("districtDesc"), selectedIndex)));
			row == null ? $("txtBlockNo").setAttribute("lastValidValue", "") : $("txtBlockNo").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("nbBlockNo"), selectedIndex)));
			//row == null ? $("txtBlockDesc").setAttribute("lastValidValue", "") : $("txtBlockDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("blockDesc"), selectedIndex)));
			row == null ? $("tarfCd").setAttribute("lastValidValue", "") : $("tarfCd").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tarfCd"), selectedIndex)));
			//row == null ? $("tarfDesc").setAttribute("lastValidValue", "") : $("tarfDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tarfDesc"), selectedIndex)));
			row == null ? $("riskCd").setAttribute("lastValidValue", "") : $("riskCd").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("riskCd"), selectedIndex)));
			//row == null ? $("risk").setAttribute("lastValidValue", "") : $("risk").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("riskDesc"), selectedIndex)));
			row == null ? $("eqZone").setAttribute("lastValidValue", "") : $("eqZone").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("eqZone"), selectedIndex)));
			//row == null ? $("eqZoneDesc").setAttribute("lastValidValue", "") : $("eqZoneDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("eqZoneDesc"), selectedIndex)));
			row == null ? $("floodZone").setAttribute("lastValidValue", "") : $("floodZone").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("floodZone"), selectedIndex)));
			//row == null ? $("floodZoneDesc").setAttribute("lastValidValue", "") : $("floodZoneDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("floodZoneDesc"), selectedIndex)));
			row == null ? $("typhoonZone").setAttribute("lastValidValue", "") : $("typhoonZone").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("typhoonZone"), selectedIndex)));
			//row == null ? $("typhoonZoneDesc").setAttribute("lastValidValue", "") : $("typhoonZoneDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("typhoonZoneDesc"), selectedIndex)));
			row == null ? $("tariffZone").setAttribute("lastValidValue", "") : $("tariffZone").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tariffZone"), selectedIndex)));
			//row == null ? $("tariffZoneDesc").setAttribute("lastValidValue", "") : $("tariffZoneDesc").setAttribute("lastValidValue", unescapeHTML2(fireItemTG.getValueAt(fireItemTG.getColumnIndex("tariffZoneDesc"), selectedIndex)));
			
			toggleFireItemFields(row);
		}catch(e){
			showErrorMessage("populateFireItemInformation", e);
		}
	}
		
	function toggleFireItemFields(row){
		try{
			if (row == null){
				$$("table#fireItemFieldsTbl input[type='text'].upper").each(function(txt){
					$(txt).readOnly = true;
				});
				
				$$("table#fireItemFieldsTbl img[name='searchFiLovs']").each(function(img){
					disableSearch(img);
				});
				
				$("txtLineCd").focus();
				disableButton("btnUpdate");
				disableButton("btnHistory");
			}else{
				$$("table#fireItemFieldsTbl input[type='text'].upper").each(function(txt){
					$(txt).readOnly = false;
				});
				
				$$("table#fireItemFieldsTbl img[name='searchFiLovs']").each(function(img){
					enableSearch(img);
				});

				enableButton("btnUpdate");
				enableButton("btnHistory");
			}
		}catch(e){
			showErrorMessage("toggleFireItemFields", e);
		}
	}
	
	function updateFireItemTG(){
		try{
			/*fireItemTG.setValueAt($F("hidBlockId"), fireItemTG.getColumnIndex("blockId"), selectedIndex);
			fireItemTG.setValueAt($F("txtProvinceCd"), fireItemTG.getColumnIndex("provinceCd"), selectedIndex);
			fireItemTG.setValueAt($F("txtProvinceDesc"), fireItemTG.getColumnIndex("provinceDesc"), selectedIndex);
			fireItemTG.setValueAt($F("txtCityCd"), fireItemTG.getColumnIndex("cityCd"), selectedIndex);
			fireItemTG.setValueAt($F("txtCity"), fireItemTG.getColumnIndex("city"), selectedIndex);
			fireItemTG.setValueAt($F("txtDistrictNo"), fireItemTG.getColumnIndex("districtNo"), selectedIndex);
			fireItemTG.setValueAt($F("txtDistrictNo"), fireItemTG.getColumnIndex("nbDistrictNo"), selectedIndex);
			fireItemTG.setValueAt($F("txtDistrictDesc"), fireItemTG.getColumnIndex("districtDesc"), selectedIndex);
			fireItemTG.setValueAt($F("txtBlockNo"), fireItemTG.getColumnIndex("blockNo"), selectedIndex);
			fireItemTG.setValueAt($F("txtBlockNo"), fireItemTG.getColumnIndex("nbBlockNo"), selectedIndex);
			fireItemTG.setValueAt($F("txtBlockDesc"), fireItemTG.getColumnIndex("blockDesc"), selectedIndex);
			fireItemTG.setValueAt($F("tarfCd"), fireItemTG.getColumnIndex("tarfCd"), selectedIndex);
			fireItemTG.setValueAt($F("tarfDesc"), fireItemTG.getColumnIndex("tarfDesc"), selectedIndex);
			fireItemTG.setValueAt($F("riskCd"), fireItemTG.getColumnIndex("riskCd"), selectedIndex);
			fireItemTG.setValueAt($F("risk"), fireItemTG.getColumnIndex("riskDesc"), selectedIndex);
			fireItemTG.setValueAt($F("eqZone"), fireItemTG.getColumnIndex("eqZone"), selectedIndex);
			fireItemTG.setValueAt($F("eqZoneDesc"), fireItemTG.getColumnIndex("eqZoneDesc"), selectedIndex);
			fireItemTG.setValueAt($F("floodZone"), fireItemTG.getColumnIndex("floodZone"), selectedIndex);
			fireItemTG.setValueAt($F("floodZoneDesc"), fireItemTG.getColumnIndex("floodZoneDesc"), selectedIndex);
			fireItemTG.setValueAt($F("typhoonZone"), fireItemTG.getColumnIndex("typhoonZone"), selectedIndex);
			fireItemTG.setValueAt($F("typhoonZoneDesc"), fireItemTG.getColumnIndex("typhoonZoneDesc"), selectedIndex);
			fireItemTG.setValueAt($F("tariffZone"), fireItemTG.getColumnIndex("tariffZone"), selectedIndex);
			fireItemTG.setValueAt($F("tariffZoneDesc"), fireItemTG.getColumnIndex("tariffZoneDesc"), selectedIndex);*/
			
			var obj = (selectedRowInfo == null ? {} : selectedRowInfo);
			obj.blockId = escapeHTML2($F("hidBlockId"));
			obj.provinceCd = escapeHTML2($F("txtProvinceCd"));
			obj.provinceDesc = escapeHTML2($F("txtProvinceDesc"));
			obj.cityCd = escapeHTML2($F("txtCityCd"));
			obj.city = escapeHTML2($F("txtCity"));
			obj.districtNo = escapeHTML2($F("txtDistrictNo"));
			obj.nbDistrictNo = escapeHTML2($F("txtDistrictNo"));
			obj.districtDesc = escapeHTML2($F("txtDistrictDesc"));
			obj.blockNo = escapeHTML2($F("txtBlockNo"));
			obj.nbBlockNo = escapeHTML2($F("txtBlockNo"));
			obj.blockDesc = escapeHTML2($F("txtBlockDesc"));
			obj.tarfCd = escapeHTML2($F("tarfCd"));
			obj.tarfDesc = escapeHTML2($F("tarfDesc"));
			obj.riskCd = escapeHTML2($F("riskCd"));
			obj.riskDesc = escapeHTML2($F("risk"));
			obj.eqZone = escapeHTML2($F("eqZone"));
			obj.eqZoneDesc = escapeHTML2($F("eqZoneDesc"));
			obj.floodZone = escapeHTML2($F("floodZone"));
			obj.floodZoneDesc = escapeHTML2($F("floodZoneDesc"));
			obj.typhoonZone = escapeHTML2($F("typhoonZone"));
			obj.typhoonZoneDesc = escapeHTML2($F("typhoonZoneDesc"));
			obj.tariffZone = escapeHTML2($F("tariffZone"));
			obj.tariffZoneDesc = escapeHTML2($F("tariffZoneDesc"));

			fireItemTG.updateVisibleRowOnly(obj, selectedIndex, false);
			
			changeTag = 1;
			changeTagFunc = saveFireItemRecords;
			
			//fireItemTG.onRemoveRowFocus();
			populateFireItemInformation(null);
		}catch(e){
			showErrorMessage("updateFireItemTG", e);
		}
	}
	
	function saveFireItemRecords(){
		try{
			var modifiedRows = prepareJsonAsParameter(/*fireItemTG.getModifiedRows()*/getAddedAndModifiedJSONObjects(fireItemTG.geniisysRows));
			
			new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
				parameters: {
					action:			"saveFireItems",
					modifiedRows: 	modifiedRows
				},
				onCreate: showNotice("Saving Records, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						changeTagFunc = "";
						resetGipis155GlobalVars();
						fireItemTG.onRemoveRowFocus();
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if (exitPage != null){
								exitPage();
							}else{
								fireItemTG.refresh();
							}
						});
					}
				}
			});
		}catch(e){
			showErrorMessage("saveFireItemRecords", e);
		}
	}
	
	
	function getGIPIS155PolNoLOV(){
		LOV.show({
			id : "getGipis155PolicyListing",
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getGipis155PolicyListing",
				lineCd : $F('txtLineCd'),
				sublineCd : $F('txtSublineCd'),
				issCd : $F('txtIssCd'),
				issueYy : $F('txtIssueYy'),
				polSeqNo : $F('txtPolSeqNo'),
				renewNo : $F('txtRenewNo'),
				assdName : $F('txtAssdName').replace(/'/g, "''"),
				dspEndtIssCd:	$F('txtDspEndtIssCd'),
				dspEndtSeqNo : $F('txtDspEndtSeqNo'),
				dspEndtYy : $F('txtDspEndtYy'),
				moduleId : 'GIPIS155',
				page : 1
			},
			hideColumnChildTitle : true,
			filterVersion: "2",
			title : "",
			width : 700,
			height : 403,
			columnModel : [
			    {
			    	id: "parId",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "policyId",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtIssCd",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtYy",
			    	width: '0px',
			    	visible: false
			    },
			    {
			    	id: "endtSeqNo",
			    	width: '0px',
			    	visible: false
			    },
           		{
					id : "policyNo",
					title : "Policy No.",
					width: 303,
					children : [
						{
							id: 'lineCd',
							title: 'Line Cd',
							width: 40
						},
						{
							id: 'sublineCd',
							title: 'Subline Cd',
							width: 70,
							filterOption: true
						},
						{
							id: 'issCd',
							title: 'Iss Cd',
							width: 40,
							filterOption: true
						},
						{
							id: 'issueYy',
							title: 'Issue Yy',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'polSeqNo',
							title: 'Pol Seq No',
							width: 70,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'renewNo',
							title: 'Renew No',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						}
					]
				},
				{
					id : 'endorsementNo',
					title : 'Endt No.',
					children : [
						{
							id: 'dspEndtIssCd' ,
							title : 'Endt Iss Cd',
							width: 40,
							filterOption: true
						},
						{
							id: 'dspEndtYy',
							title : 'Endt Yy',
							width: 40,
							filterOption: true,
							filterOptionType: 'number'
						},
						{
							id: 'dspEndtSeqNo',
							title : 'Endt Seq No',
							width: 70,
							filterOption: true,
							filterOptionType: 'number'
						}
					]
				},
				{
					id : 'assdName',
					title : 'Assured Name',
					width : 500,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			onSelect : function(row) {
				populatePolicyInformation(row);
				enableToolbarButton("btnToolbarExecuteQuery");
			},
			onCancel : function () {
				$("txtLineCd").focus();
			},
			onUndefinedRow : function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
				$("txtLineCd").focus();
			}
		});
	}
	
	function getGIPIS155ProvinceLOV(){		
		var searchString = $("txtProvinceCd").readAttribute("lastValidValue").trim() != $F("txtProvinceCd").trim() ? $F("txtProvinceCd").trim() : "";
		
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 		"getGIISProvinceLOV2",
				searchString:	searchString,
				page : 			1
			},
			title : "Provinces",
			width : 615,
			height : 386,
			columnModel : [			   
			    {
			    	id: "provinceDesc",
			    	title: 'Province',
			    	width: 500,
			    	visible: true,
			    	sortable: true,
			    	filterOption: true,
					renderer : function(val){
						return unescapeHTML2(val);
					}			    	
			    },           		
				{
					id : 'provinceCd',
					title : 'Code',
					width : 100,
					sortable: true,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			filterText: searchString,
			onSelect : function(row) {
				if (row.provinceCd != $("txtProvinceCd").readAttribute("lastValidValue")){
					$("txtCityCd").clear();
					$("txtCity").clear();
					$("txtDistrictNo").clear();
					$("txtDistrictDesc").clear();
					$("hidBlockId").clear();
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtCityCd").setAttribute("lastValidValue", "");
					$("txtDistrictNo").setAttribute("lastValidValue", "");
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}				
				$("txtProvinceCd").value = unescapeHTML2(row.provinceCd);
				$("txtProvinceDesc").value = unescapeHTML2(row.provinceDesc);
				$("txtProvinceCd").setAttribute("lastValidValue", unescapeHTML2(row.provinceCd));
			},
			onCancel : function () {
				$("txtProvinceCd").value = $("txtProvinceCd").readAttribute("lastValidValue");
				$("txtProvinceCd").focus();
			},
			onUndefinedRow : function(){
				$("txtProvinceCd").value = $("txtProvinceCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtProvinceCd");
			}
		});
	}
	
	function getGIPIS155CityLOV(){
		var searchString = $("txtCityCd").readAttribute("lastValidValue").trim() != $F("txtCityCd").trim() ? $F("txtCityCd").trim() : "";
		
		LOV.show({
			id : "getGipis155CityLOV",
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 		"getGipis155CityLOV",
				provinceCd:		$F("txtProvinceCd"),
				searchString:	searchString,
				page : 			1
			},
			title : "Cities",
			width : 615,
			height : 386,
			columnModel : [			   
			    {
			    	id: "city",
			    	title: 'City',
			    	width: 500,
			    	visible: true,
			    	sortable: true,
			    	filterOption: true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
			    	
			    },           		
				{
					id : 'cityCd',
					title : 'Code',
					width : 100,
					sortable: true,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			filterText: searchString,
			onSelect : function(row) {
				if ($("txtCityCd").readAttribute("lastValidValue") != row.cityCd){
					$("txtDistrictNo").clear();
					$("txtDistrictDesc").clear();
					$("hidBlockId").clear();
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtDistrictNo").setAttribute("lastValidValue", "");
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}			
				$("txtCityCd").setAttribute("lastValidValue",unescapeHTML2(row.cityCd));
				$("txtCityCd").value = unescapeHTML2(row.cityCd);
				$("txtCity").value = unescapeHTML2(row.city);	
			},
			onCancel : function () {		
				$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");
				$("txtCityCd").focus();
			},
			onUndefinedRow : function(){
				$("txtCityCd").value = $("txtCityCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtCityCd");
			}
		});
	}
	
	
	function getGIPIS155DistrictLOV(){	
		var searchString = $("txtDistrictNo").readAttribute("lastValidValue").trim() != $F("txtDistrictNo").trim() ? $F("txtDistrictNo").trim() : "";
		
		LOV.show({
			id : "getGipis155DistrictLOV",
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 	"getGipis155DistrictLOV",
				provinceCd:	$F("txtProvinceCd"),
				cityCd:		$F("txtCityCd"),
				searchString:	searchString,
				page : 		1
			},
			title : "Districts",
			width : 615,
			height : 386,
			columnModel : [			   
			    {
			    	id: "districtDesc",
			    	title: 'District Desc',
			    	width: 500,
			    	visible: true,
			    	sortable: true,
			    	filterOption: true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
			    	
			    },           		
				{
					id : 'districtNo',
					title : 'District No',
					width : 100,
					sortable: true,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			filterText: searchString,
			onSelect : function(row) {
				if (unescapeHTML2(row.districtNo) != $("txtDistrictNo").readAttribute("lastValidValue")){
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}			
				$("txtDistrictNo").setAttribute("lastValidValue", unescapeHTML2(row.districtNo));
				$("txtDistrictNo").value = unescapeHTML2(row.districtNo);
				$("txtDistrictDesc").value = unescapeHTML2(row.districtDesc);
				$("hidBlockId").clear();	
				getBlockId();
			},
			onCancel : function () {
				$("txtDistrictNo").value = $("txtDistrictNo").readAttribute("lastValidValue");
				$("txtDistrictNo").focus();
			},
			onUndefinedRow : function(){
				$("txtDistrictNo").value = $("txtDistrictNo").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtDistrictNo");
			}
		});
	}
	
	
	function getGIPIS155BlockLOV(){	
		searchString = $("txtBlockNo").readAttribute("lastValidValue").trim() != $F("txtBlockNo").trim() ? $F("txtBlockNo").trim() : "";
		
		LOV.show({
			id : "getGipis155BlockLOV",
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : 		"getGipis155BlockLOV",
				provinceCd:		$F("txtProvinceCd"),
				cityCd:			$F("txtCityCd"),
				districtNo:		$F("txtDistrictNo"),
				searchString:	searchString,
				page : 			1
			},
			title : "Blocks",
			width : 615,
			height : 386,
			columnModel : [			   
			    {
			    	id: "blockDesc",
			    	title: 'Block Desc',
			    	width: 500,
			    	visible: true,
			    	sortable: true,
			    	filterOption: true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
			    	
			    },           		
				{
					id : 'blockNo',
					title : 'Block No',
					width : 100,
					sortable: true,
					filterOption : true,
					renderer : function(val){
						return unescapeHTML2(val);
					}
				}
      		],
			draggable : true,
			autoSelectOneRecord: true, 
			filterText: searchString,
			onSelect : function(row) {
				if (unescapeHTML2(row.blockNo) != $("txtBlockNo").readAttribute("lastValidValue")){
					$("riskCd").clear();
					$("risk").clear();
					$("riskCd").setAttribute("lastValidValue", "");
				}			
				$("txtBlockNo").setAttribute("lastValidValue", unescapeHTML2(row.blockNo));
				$("txtBlockNo").value = unescapeHTML2(row.blockNo);
				$("txtBlockDesc").value = unescapeHTML2(row.blockDesc);	
				getBlockId();
			},
			onCancel : function () {
				$("txtBlockNo").value = $("txtBlockNo").readAttribute("lastValidValue");
				$("txtBlockNo").focus();
			},
			onUndefinedRow : function(){
				$("txtBlockNo").value = $("txtBlockNo").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "txtBlockNo");
			}
		});
	}
		
	function showGipis155TarfLOV(){
		var searchString = $("tarfCd").readAttribute("lastValidValue").trim() != $F("tarfCd").trim() ? escapeHTML2($F("tarfCd").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : "getGipis155TarfLOV",
				searchString:	searchString,
				page : 1
			},
			title: "Tariff Codes",
			width: 500,
			height: 386,
			columnModel : [	
				{	id : "tarfCd",
					title: "Tariff Code",
					width: '94px'
				},
               	{	id : "tarfDesc",
					title: "Tariff Description",
					width: '391px'
				}
			],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("tarfCd").setAttribute("lastValidValue", unescapeHTML2(row.tarfCd));
				$("tarfCd").value = unescapeHTML2(row.tarfCd);
				$("tarfDesc").value = unescapeHTML2(row.tarfDesc);
				$("tarfCd").focus();
			},
			onCancel: function(){
				$("tarfCd").value = $("tarfCd").readAttribute("lastValidValue");			
				$("tarfCd").focus();
			},
			onUndefinedRow : function(){
				$("tarfCd").value = $("tarfCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "tarfCd");
			}
		  });
	}
	
	function showGipis155RiskLOV(){
		var searchString = $("riskCd").readAttribute("lastValidValue").trim() != $F("riskCd").trim() ? escapeHTML2($F("riskCd").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : 		"getGIISRiskLOV2",
				blockId:		$F("hidBlockId"),
				searchString:	searchString,
				page : 			1
			},
			title: "Risks",
			width: 500,
			height: 386,
			columnModel : [	
               	{	id : "riskDesc",
					title: "Description",
					width: '391px'
				},
				{	id : "riskCd",
					title: "Code",
					width: '94px'
				}
			],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("riskCd").setAttribute("lastValidValue", unescapeHTML2(row.riskCd));
				$("riskCd").value = unescapeHTML2(row.riskCd);
				$("risk").value = unescapeHTML2(row.riskDesc);
				$("riskCd").focus();
			},
			onCancel: function(){
				$("riskCd").value = $("riskCd").readAttribute("lastValidValue");
				$("riskCd").focus();
			},
			onUndefinedRow : function(){
				$("riskCd").value = $("riskCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "riskCd");
			}
		  });
	}
	
	function showGipis155EQZoneLOV(){
		var searchString = $("eqZone").readAttribute("lastValidValue").trim() != $F("eqZone").trim() ? escapeHTML2($F("eqZone").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : 		"getEQZoneLOV2",
				searchString:	searchString,
				page : 			1
			},
			title: "Earthquake Zones",
			width: 500,
			height: 386,
			columnModel : [	{	id : "eqDesc",
								title: "EQ Zone Desc",
								width: '391px'
							},
							{	id : "eqZone",
								title: "EQ Zone",
								width: '94px'
							}
						],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("eqZone").setAttribute("lastValidValue", unescapeHTML2(row.eqZone));
				$("eqZone").value = unescapeHTML2(row.eqZone);
				$("eqZoneDesc").value = unescapeHTML2(row.eqDesc);
				$("eqZone").focus();
			},
			onCancel: function(){
				$("eqZone").value = $("eqZone").readAttribute("lastValidValue");
				$("eqZone").focus();
			},
			onUndefinedRow : function(){
				$("eqZone").value = $("eqZone").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "eqZone");
			}
		  });
	}
	
	function showGipis155FloodZoneLOV(){
		var searchString = $("floodZone").readAttribute("lastValidValue").trim() != $F("floodZone").trim() ? escapeHTML2($F("floodZone").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : 		"getFloodZoneLOV2",
				searchString:	searchString,
				page : 			1
			},
			title: "Flood Zones",
			width: 500,
			height: 386,
			columnModel : [	{	id : "floodZoneDesc",
								title: "Flood Zone Desc",
								width: '391px'
							},
							{	id : "floodZone",
								title: "Flood Zone",
								width: '94px'
							}
						],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("floodZone").setAttribute("lastValidValue", unescapeHTML2(row.floodZone));
				$("floodZone").value = unescapeHTML2(row.floodZone);
				$("floodZoneDesc").value = unescapeHTML2(row.floodZoneDesc);
				$("floodZone").focus();
			},
			onCancel: function(){
				$("floodZone").value = $("floodZone").readAttribute("lastValidValue");
				$("floodZone").focus();
			},
			onUndefinedRow : function(){
				$("floodZone").value = $("floodZone").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "floodZone");
			}
		  });
	}
	
	function showGipis155TyphoonZoneLOV(){
		var searchString = $("typhoonZone").readAttribute("lastValidValue").trim() != $F("typhoonZone").trim() ? escapeHTML2($F("typhoonZone").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : 		"getTyphoonZoneLOV2",
				searchString:	searchString,
				page : 			1
			},
			title: "Typhoon Zones",
			width: 500,
			height: 386,
			columnModel : [	{	id : "typhoonZoneDesc",
								title: "Typhoon Zone Desc",
								width: '391px'
							},
							{	id : "typhoonZone",
								title: "Typhoon Zone",
								width: '94px'
							}
						],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("typhoonZone").setAttribute("lastValidValue", unescapeHTML2(row.typhoonZone));
				$("typhoonZone").value = unescapeHTML2(row.typhoonZone);
				$("typhoonZoneDesc").value = unescapeHTML2(row.typhoonZoneDesc);
				$("typhoonZone").focus();
			},
			onCancel: function(){
				$("typhoonZone").value = $("typhoonZone").readAttribute("lastValidValue");
				$("typhoonZone").focus();
			},
			onUndefinedRow : function(){
				$("typhoonZone").value = $("typhoonZone").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "typhoonZone");
			}
		  });
	}
	
	function showGipis155TariffZoneLOV(){
		var searchString = $("tariffZone").readAttribute("lastValidValue").trim() != $F("tariffZone").trim() ? escapeHTML2($F("tariffZone").trim()) : "";
		
		LOV.show({
			controller: "UnderwritingLOVController",
			urlParameters: {
				action : 		"getTariffZoneLOV2",
				searchString:	searchString,
				page : 			1
			},
			title: "Tariff Zone",
			width: 500,
			height: 386,
			columnModel : [	{	id : "tariffZoneDesc",
								title: "Tariff Description",
								width: '391px'
							},
							{	id : "tariffZone",
								title: "Tariff Code",
								width: '94px'
							}
						],
			draggable: true,
			filterText: searchString,
			autoSelectOneRecord: true,
			onSelect: function(row){
				$("tariffZone").setAttribute("lastValidValue", unescapeHTML2(row.tariffZone));
				$("tariffZone").value = unescapeHTML2(row.tariffZone);
				$("tariffZoneDesc").value = unescapeHTML2(row.tariffZoneDesc);
				$("tariffZone").focus();
			},
			onCancel: function(){
				$("tariffZone").value = $("tariffZone").readAttribute("lastValidValue");
				$("tariffZone").focus();
			},
			onUndefinedRow : function(){
				$("tariffZone").value = $("tariffZone").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "tariffZone");
			}
		  });
	}
	
	function getBlockId(){
		try{
			new Ajax.Request(contextPath+"/UpdateUtilitiesController", {
				parameters: {
					action:		"getBlockIdGipis155",
					provinceCd:	$F("txtProvinceCd"),
					cityCd:		$F("txtCityCd"),
					districtNo:	$F("txtDistrictNo"),
					blockNo:	$F("txtBlockNo") == "" ? null : $F("txtBlockNo")
				},
				onCreate: showNotice("Getting Block Id, please wait.."),
				onComplete: function(response){
					hideNotice();
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						
						if (json.length == 0){
							showMessageBox("Block Id does not exist in BLOCK table. District, Province, City and Block No. combination is invalid.", "I");
						}else if (json.length == 1){
							$("hidBlockId").value = json[0];
						}
						
					}
				}
			});
		}catch(e){
			showErrorMessage("getBlockId", e);
		}
	}
	
	function resetGipis155GlobalVars(){
		objGIPIS155.policyId = null;
		objGIPIS155.itemNo = null;
		objGIPIS155.blockId = null;
		changeTag = 0;
	}

	function exitModule(){
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null); 
	}
	
	
	$$("#policyDiv input[type='text']").each(
			function(obj){
				obj.observe("keypress", function(event){
					if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
						if(this.readOnly)
							return;
						
						//enableToolbarButton("btnToolbarExecuteQuery");
						enableToolbarButton("btnToolbarEnterQuery");
					}
				});
			}		
		);
	
	$("searchPolicy").observe("click", function(){ 
		if (/* checkAllRequiredFieldsInDiv('policyDiv') */ $F("txtLineCd") != ""){
			getGIPIS155PolNoLOV();
		}else{
			customShowMessageBox("Please enter Line Code first.", "I", "txtLineCd");
		}
	});
	
	
	$("searchProvince").observe("click", getGIPIS155ProvinceLOV);
	
	$("txtProvinceCd").observe("change", function(){
		if (this.value != ""){			
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGIISProvinceLOV2",findText,"Searching Province, please wait...");
			
			if(cond == 0){
				if (this.value != this.readAttribute("lastValidValue")){
					$("txtCityCd").clear();
					$("txtCity").clear();
					$("txtDistrictNo").clear();
					$("txtDistrictDesc").clear();
					$("hidBlockId").clear();
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtCityCd").setAttribute("lastValidValue", "");
					$("txtDistrictNo").setAttribute("lastValidValue", "");
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}	
				getGIPIS155ProvinceLOV();
				this.clear();
			}else if(cond == 2){
				getGIPIS155ProvinceLOV();
			}else{	
				getGIPIS155ProvinceLOV();
			}
		}else{
			$("txtProvinceDesc").clear();
			this.setAttribute("lastValidValue", "");
			showMessageBox("Province must be entered.", "I");
		}
	});
		
	$("searchCity").observe("click", getGIPIS155CityLOV);
	
	$("txtCityCd").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis155CityLOV&provinceCd="+$F("txtProvinceCd"),findText,"Searching City, please wait...");
			
			if(cond == 0){
				if (this.value != this.readAttribute("lastValidValue")){
					$("txtDistrictNo").clear();
					$("txtDistrictDesc").clear();
					$("hidBlockId").clear();
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtDistrictNo").setAttribute("lastValidValue", "");
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}	
				getGIPIS155CityLOV();
				this.clear();
			}else if(cond == 2){
				getGIPIS155CityLOV();
			}else{
				getGIPIS155CityLOV();
			}
		}else{
			$("txtCity").clear();
			this.setAttribute("lastValidValue", "");
			showMessageBox("City must be entered.", "I");
		}
	});
	
	$("searchDistrict").observe("click", getGIPIS155DistrictLOV);
		
	$("txtDistrictNo").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			var params = "&provinceCd="+$F("txtProvinceCd")+"&cityCd="+$F("txtCityCd");
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis155DistrictLOV"+params,findText,"Searching District, please wait...");
			
			if(cond == 0){
				if (this.value != this.readAttribute("lastValidValue")){
					$("hidBlockId").clear();
					$("txtBlockNo").clear();
					$("txtBlockDesc").clear();
					$("riskCd").clear();
					$("risk").clear();
					$("txtBlockNo").setAttribute("lastValidValue", "");
					$("riskCd").setAttribute("lastValidValue", "");
				}	
				getGIPIS155DistrictLOV();
				this.clear();
			}else if(cond == 2){
				getGIPIS155DistrictLOV();
			}else{
				getGIPIS155DistrictLOV();
				getBlockId();	
			}		
		}else{
			$("txtDistrictDesc").clear();
			this.setAttribute("lastValidValue", "");
			showMessageBox("District must be entered.", "I");
		}
	});
	
	$("searchBlock").observe("click", getGIPIS155BlockLOV);
	
	$("txtBlockNo").observe("change", function(){
		if (this.value != ""){
			var findText = this.value.trim();
			var params = "&provinceCd="+$F("txtProvinceCd")+"&cityCd="+$F("txtCityCd")+"&districtNo="+$F("txtDistrictNo");
			
			var cond = validateTextFieldLOV("/UnderwritingLOVController?action=getGipis155BlockLOV"+params,findText,"Searching Block, please wait...");
			
			if(cond == 0){
				if (this.value != this.readAttribute("lastValidValue")){
					$("riskCd").clear();
					$("risk").clear();
					$("riskCd").setAttribute("lastValidValue", "");
				}	
				getGIPIS155BlockLOV();
				this.clear();
			}else if(cond == 2){
				getGIPIS155BlockLOV();
			}else{
				getGIPIS155BlockLOV();
				getBlockId();	
			}			
		}else{
			$("txtBlockDesc").clear();
			this.setAttribute("lastValidValue", "");
			showMessageBox("Block must be entered.", "I");
		}
	});
	
	$("searchTarf").observe("click", showGipis155TarfLOV);
	
	$("tarfCd").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){	
			showGipis155TarfLOV();		
		}else{
			$("tarfDesc").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("searchRisk").observe("click", showGipis155RiskLOV);
	
	$("riskCd").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){	
			showGipis155RiskLOV();
		}else{
			$("risk").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	
	$("searchEqZone").observe("click", showGipis155EQZoneLOV);
	
	$("eqZone").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){	
			showGipis155EQZoneLOV();		
		}else{
			$("eqZoneDesc").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("searchFloodZone").observe("click", showGipis155FloodZoneLOV);
	
	$("floodZone").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){	
			showGipis155FloodZoneLOV();	
		}else{
			$("floodZoneDesc").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("searchTyphoonZone").observe("click", showGipis155TyphoonZoneLOV);
	
	$("typhoonZone").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){	
			showGipis155TyphoonZoneLOV();	
		}else{
			$("typhoonZoneDesc").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("searchTariffZone").observe("click", showGipis155TariffZoneLOV);
	
	$("tariffZone").observe("change", function(){
		if (this.value.trim() != "" && this.value != this.readAttribute("lastValidValue")){		
			showGipis155TariffZoneLOV();
		}else{
			$("tariffZoneDesc").clear();
			this.setAttribute("lastValidValue", "");
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		if (changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveFireItemRecords();
						resetGipis155GlobalVars();
						disableToolbarButton("btnToolbarExecuteQuery");
						togglePolicyFields(true);
						populatePolicyInformation(null);
						fireItemTG.url = contextPath + "/UpdateUtilitiesController?action=getGipis155FireItemListing&refresh=1";
						fireItemTG._refreshList();
						$("txtLineCd").focus();
					}, 
					function(){
						resetGipis155GlobalVars();
						disableToolbarButton("btnToolbarExecuteQuery");
						togglePolicyFields(true);
						populatePolicyInformation(null);
						fireItemTG.url = contextPath + "/UpdateUtilitiesController?action=getGipis155FireItemListing&refresh=1";
						fireItemTG._refreshList();
						$("txtLineCd").focus();          						
					}, "");
		}else{
			resetGipis155GlobalVars();
			disableToolbarButton("btnToolbarExecuteQuery");
			togglePolicyFields(true);
			populatePolicyInformation(null);
			fireItemTG.url = contextPath + "/UpdateUtilitiesController?action=getGipis155FireItemListing&refresh=1";
			fireItemTG._refreshList();
			$("txtLineCd").focus();
		}		
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('policyDiv')){
			disableToolbarButton(this.id);
			enableToolbarButton("btnToolbarSave");
			enableButton("btnSave");
			togglePolicyFields(false);
			fireItemTG.url = contextPath + "/UpdateUtilitiesController?action=getGipis155FireItemListing&refresh=1&policyId="+$F("hidPolicyId");
			fireItemTG._refreshList();
		}
	});
	
	$("btnUpdate").observe("click", function(){
		if (checkAllRequiredFieldsInDiv('fireItemDiv')){
			updateFireItemTG();
		}
	});
		
	
	$("btnHistory").observe("click", function(){
		objGIPIS155.policyId = selectedRowInfo.policyId;
		objGIPIS155.itemNo = selectedRowInfo.itemNo;
		objGIPIS155.blockId = $F("hidBlockId");
		
		fireItemTG.keys.releaseKeys();
		
		tarfHistOverlay = Overlay.show(contextPath+"/UpdateUtilitiesController", {
			urlContent : true,
			urlParameters: {
				action : 	"getGipis155TarfHistListing",
				policyId:	objGIPIS155.policyId,
				itemNo:		objGIPIS155.itemNo,
				blockId:	objGIPIS155.blockId
			},
		    title: "Tariff Code History",
		    height: 320,
		    width: 595,
		    draggable: true
		});
	});
	

	observeSaveForm("btnSave", saveFireItemRecords);
	
	observeSaveForm("btnToolbarSave", saveFireItemRecords);
	
	observeCancelForm("btnToolbarExit",  
			function(){
				exitPage = exitModule;
				saveFireItemRecords();
			},
			function(){
				resetGipis155GlobalVars();
				fireItemTG.onRemoveRowFocus();
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null); 
			}
	);
	
	observeCancelForm("btnCancel",  
			function(){
			    exitPage = exitModule;
				saveFireItemRecords();
			},
			function(){
				resetGipis155GlobalVars();
				fireItemTG.onRemoveRowFocus();
				goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null); 
			}
	);
		
	observeReloadForm("reloadForm", showGipis155);
	
	toggleFireItemFields(null);
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>