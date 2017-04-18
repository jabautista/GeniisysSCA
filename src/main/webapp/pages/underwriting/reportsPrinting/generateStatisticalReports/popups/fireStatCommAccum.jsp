<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<div id="commAccumMainDiv">
	<div class="sectionDiv" style="width: 1090px; height: 407px; margin: 5px;">
		<div id="commAccumDetailDiv" style="width: 700px; height: 175px; margin: 5px 5px 5px 220px;"></div>
		
		<div id="commAccumDetail2Div" style="width: 840px; height: 175px; margin: 5px;"></div>
		
		<div id="totalsDiv" style="width: 1089px; height: 30px; margin-top: 15px;">
			<label style="padding: 6px 10px 0 233px;">Totals</label>
			<input id="txtTotalTsiAmtB" type="text" class="money rightAligned" readonly="readonly" value="0.00" style="width: 122px;">
			<input id="txtTotalPremAmtB" type="text" class="money rightAligned" readonly="readonly" value="0.00"  style="width: 122px; ">
			<input id="txtTotalTsiAmtC" type="text" class="money rightAligned" readonly="readonly" value="0.00" style="width: 122px; ">
			<input id="txtTotalPremAmtC" type="text" class="money rightAligned" readonly="readonly" value="0.00"  style="width: 122px;">
			<input id="txtTotalTsiAmtL" type="text" class="money rightAligned" readonly="readonly" value="0.00" style="width: 122px; ">
			<input id="txtTotalPremAmtL" type="text" class="money rightAligned" readonly="readonly" value="0.00"  style="width: 122px; ">
		</div>
	
	</div>
	
	<div id="consolDiv" style="width: 1090px;">
		<table style="margin: 5px 0 0 450px; float: left;">
			<tr>
				<td>
					<input type="checkbox" id="consolSw" style="margin: 2px 5px 4px 2px; float: left;"><label for="consolSw" style="margin: 2px 0 4px 3px" tabindex="120">Consolidate All Records</label>
				</td>
			</tr>
		</table>
	</div>
	
	<div class="buttonsDiv" style="width: 1090px;">
		<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;" tabindex="101">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px;" tabindex="102">
	</div>
</div>

<script type="text/javascript">
try{
	objGIPIS901.consolSw = "N"; //edgar 04/15/2015
	objGIPIS901.fromCommAccum = "Y"; //edgar 04/15/2015
	$("btnPrint").focus();
	
	$("btnReturn").observe("click", function(){
		objGIPIS901.fromCommAccum = "N"; //edgar 04/15/2015
		caMasterTG.onRemoveRowFocus();
		caDetailTG.onRemoveRowFocus();
		overlayDetailsDialog.close();
	});
	
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	var objCAMaster = new Object();
	objCAMaster.tableGrid = JSON.parse('${commAccumMasterTG}'.replace(/\\/g, '\\\\'));
	objCAMaster.objRows = objCAMaster.tableGrid.rows || [];
	objCAMaster.objList = [];	// holds all the geniisys rows
	
	try{
		var caMasterTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireCommAccumMaster&refresh=1&asOfSw="+objGIPIS901.asOfSw+"&zoneType="+$F("hidZoneType"),//edgar 04/08/2015
			options: {
				width: '670px',
				height: '150px',
				onCellFocus: function(element, value, x, y, id){					
					selectedRowInfo = caMasterTG.geniisysRows[y];
					objGIPIS901.commitAccumDistShare = selectedRowInfo.distShare;
					objGIPIS901.commitAccumShareType = selectedRowInfo.shareType; //edgar 03/23/2015
					objGIPIS901.commitAccumAcctTrtyType = selectedRowInfo.acctTrtyType; //edgar 03/23/2015
					computeCATotals(selectedRowInfo);
					refreshCADetailTG(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					caMasterTG.keys.releaseKeys();
					selectedRowInfo = null;
					computeCATotals(selectedRowInfo);
					refreshCADetailTG(selectedRowInfo);
				},
				onRefresh: function(){
					caMasterTG.onRemoveRowFocus();
				},
				onSort: function(){
					caMasterTG.onRemoveRowFocus();
				},
				prePager: function(){
					caMasterTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						caMasterTG.onRemoveRowFocus();
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
					id: 'zoneGroup',
					width: '0px',
					visible: false,
				},
				{
					id: 'shareCd',
					width: '0px',
					visible: false
				},
				{
					id: 'shareType',
					width: '0px',
					visible: false
				},
				{
					id: 'acctTrtyType',
					width: '0px',
					visible: false
				},
				{
					id: 'nbtZoneGrp',
					title: 'Zone',
					width: '130px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'distShare',
					title: 'Distribution Share',
					width: '505px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				}             
			],
			rows: objCAMaster.objRows
		};
		
		caMasterTG = new MyTableGrid(caMasterTableModel);
		caMasterTG.pager = objCAMaster.tableGrid;
		caMasterTG.render('commAccumDetailDiv');
		
	}catch(e){
		showErrorMessage("Comm Accum Master table grid error", e);
	}
	
	
	var objCADetail = new Object();
	objCADetail.tableGrid = JSON.parse('${commAccumDetailTG}'.replace(/\\/g, '\\\\'));
	objCADetail.objRows = objCADetail.tableGrid.rows || [];
	objCADetail.objList = [];	// holds all the geniisys rows
	
	try{
		var caDetailTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireCommAccumDetail&refresh=1",
			options: {
				width: '1080px',
				height: '160px',
				onRemoveRowFocus: function(){
					caDetailTG.keys.releaseKeys();
					selectedRowInfo = null;
				},
				onRefresh: function(){
					caDetailTG.onRemoveRowFocus();
				},
				onSort: function(){
					caDetailTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						caDetailTG.onRemoveRowFocus();
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
					id: 'zoneGroup',
					width: '0px',
					visible: false,
				},
				{
					id: 'zoneType',
					width: '0px',
					visible: false
				},
				{
					id: 'asOfSw',
					width: '0px',
					visible: false
				},
				{
					id: 'lineCd',
					title: 'Line Code', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015
				},
				{
					id: 'sublineCd',
					title: 'Subline Code', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015
				},
				{
					id: 'issCd',
					title: 'Issue Code', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015
				},
				{
					id: 'issueYy',
					title: 'Issue Year', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015
				},
				{
					id: 'polSeqNo',
					title: 'Policy Seq No.', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015 
				},
				{
					id: 'renewNo',
					title: 'Renew No.', // jhing 04.23.2015
					width: '0px',
					visible: false,
					filterOption: true // jhing 04.23.2015 
				},
				{
					id: 'shareCd',
					width: '0px',
					visible: false
				},
				{
					id: 'zoneNo',
					sortable: true,
					children: [
						{
							id: 'zoneNo',
							title: 'Zone No.',
							align: 'right',
							width: 65,
							filterOption: true,
							sortable: true
						}           
					]
				},
				{
					id: 'policyNo',
					children: [
						{
							id: 'policyNo',
							title: 'Policy No.',
							width: 190,
							titleAlign: 'left',
							visible: true,
							filterOption: true
						}         
					]
				},
				{
					id: 'tsiAmtB', //removed premAmtB edgar 04/08/2015
					title: 'Building',
					titleAlign: 'center',
					sortable: false,
					children: [
						{
							id: 'tsiAmtB',
							title: 'TSI Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						},
						{
							id: 'premAmtB',
							title: 'Premium Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						}
					]
				},
				{
					id: 'tsiAmtC', //removed premAmtC edgar 04/08/2015
					title: 'Contents',
					titleAlign: 'center',
					children: [
						{
							id: 'tsiAmtC',
							title: 'Insured Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						},
						{
							id: 'premAmtC',
							title: 'Premium Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						}
					]
				},
				{
					id: 'tsiAmtL', //removed premAmtL edgar 04/08/2015
					title: 'Loss of Profit',
					titleAlign: 'center',
					children: [
						{
							id: 'tsiAmtL',
							title: 'Insured Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						},
						{
							id: 'premAmtL',
							title: 'Premium Amount',
							width: 130,
							titleAlign: 'right',
							align: 'right',
							sortable: true,
							visible: true,
							renderer : function(value) {
								return formatCurrency(value)}
						}
					]
				}
			],
			rows: objCADetail.objRows
		}; 
		
		caDetailTG = new MyTableGrid(caDetailTableModel);
		caDetailTG.pager = objCADetail.objRows;
		caDetailTG.render('commAccumDetail2Div');
		
	}catch(e){
		showErrorMessage("Comm Accum Detail table grid error", e);
	}
	
	function computeCATotals(row){
		try{
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:		"computeFireCATotals",
					asOfSw:		objGIPIS901.asOfSw,
					zone:		objGIPIS901.extractPrevParam[0].zone,
					zoneGrp:	row == null ? null : row.zoneGroup,
					nbtZoneGrp:	row == null ? null : row.nbtZoneGrp,
					zoneType:	objGIPIS901.extractPrevParam[0].zoneType,
					shareCd:	row == null ? null : row.shareCd,
					shareType:  row == null ? null : row.shareType,	
					acctTrtyType:  row == null ? null : row.acctTrtyType,		
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						$("txtTotalTsiAmtB").value = formatCurrency(nvl(json.sumTsiAmtB, 0));
						$("txtTotalPremAmtB").value = formatCurrency(nvl(json.sumPremAmtB, 0));
						$("txtTotalTsiAmtC").value = formatCurrency(nvl(json.sumTsiAmtC, 0));
						$("txtTotalPremAmtC").value = formatCurrency(nvl(json.sumPremAmtC, 0));
						$("txtTotalTsiAmtL").value = formatCurrency(nvl(json.sumTsiAmtL, 0));
						$("txtTotalPremAmtL").value = formatCurrency(nvl(json.sumPremAmtL, 0));
					}
				}
			});
		}catch(e){
			showErrorMessage("computeCATotals", e);
		}
	}
	
	function refreshCADetailTG(row){
		objGIPIS901.fireSelectedRow = row;
		if (row == null){
			caDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireCommAccumDetail&refresh=1";
		}else{
			caDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireCommAccumDetail&refresh=1&asOfSw="+
			 				objGIPIS901.asOfSw+"&zone="+objGIPIS901.extractPrevParam[0].zone+"&zoneGrp="+row.zoneGroup+"&nbtZoneGrp="
			 				+row.nbtZoneGrp+"&zoneType="+objGIPIS901.extractPrevParam[0].zoneType+"&shareCd="+row.shareCd
			 				+"&shareType="+row.shareType+"&acctTrtyType="+row.acctTrtyType;
		}		
		caDetailTG._refreshList();
	}
	
	function getTrtyName(){
		new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController", {
			parameters: {
				action:		"getTrtyName",
				distShare:	objGIPIS901.commitAccumDistShare
			},
			onComplete: function(response){
				if (checkErrorOnResponse(response)){
					if (objGIPIS901.fireSelectedRow.distShare == "TOTAL RETENTION"){
						objGIPIS901.printSw = "R";
					}else if (objGIPIS901.fireSelectedRow.distShare == response.responseText){
						objGIPIS901.commAccumSw = true;
						objGIPIS901.printSw = "T";
					}else if (objGIPIS901.fireSelectedRow.distShare == "TOTAL FACULTATIVE"){
						objGIPIS901.printSw = "F";
					}
					
					showGIPIS901FirePrintDialog("Print Fire Statistical Request");		  
				}
			}
		});
	}
	
	$("btnPrint").observe("click", function(){
		if (objGIPIS901.fireSelectedRow == null){
			showMessageBox("Please select a record first.", "I");
			return false;
		}
		
		//commAccumMasterTG.keys.releaseKeys();
		getTrtyName();
	});
	//added edgar 04/15/2015
	$("consolSw").observe("click", function(){
		if (this.checked){
			objGIPIS901.consolSw = "Y";
		}else{
			objGIPIS901.consolSw = "N";
		}
	});
}catch(e){
	showErrorMessage("popup page error", e);
}
</script>