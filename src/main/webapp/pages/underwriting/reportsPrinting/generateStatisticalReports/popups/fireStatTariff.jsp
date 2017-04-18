<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="tariffMainDiv" style="width: 860px; height: 407px; ">
	<div class="sectionDiv" style="width: 860px; height: 407px; margin: 5px;">
		<div id="tariffDetailDiv" style="width: 700px; height: 175px; margin: 5px 5px 5px 100px;"></div>
		
		<div id="tariffDetail2Div" style="width: 840px; height: 175px; margin: 5px;"></div>
		
		<div id="totalsDiv" style="width: 835px; height: 30px; margin-top: 15px;">
			<label style="padding: 6px 0 0 530px;">Totals</label>
			<input id="txtTotalTsiAmt" type="text" class="money rightAligned" readonly="readonly" value="0.00" style="width: 120px; margin-left: 5px;">
			<input id="txtTotalPremAmt" type="text" class="money rightAligned" readonly="readonly" value="0.00"  style="width: 120px; margin-left: 5px;">
		</div>
	
	</div>
	
	<div class="buttonsDiv">
		<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;" tabindex="101">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px;" tabindex="102">
	</div>
</div>

<script type="text/javascript">
try{
	$("btnPrint").focus();
	
	$("btnReturn").observe("click", function(){
		tariffMasterTG.onRemoveRowFocus();
		overlayDetailsDialog.close();
	});
	
	var selectedIndex = -1;	//holds the selected index
	var selectedRowInfo = null;	//holds the selected row info
	
	var objTariffMaster = new Object();
	objTariffMaster.tableGrid = JSON.parse('${tariffMasterTG}'.replace(/\\/g, '\\\\'));
	objTariffMaster.objRows = objTariffMaster.tableGrid.rows || [];
	objTariffMaster.objList = [];	// holds all the geniisys rows
	
	try{
		var tariffMasterTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireTariffMaster&refresh=1&asOfSw="+objGIPIS901.asOfSw+"&zoneType="+$F("hidZoneType"),//edgar 04/08/2015
			options: {
				width: '670px',
				height: '150px',
				onCellFocus: function(element, value, x, y, id){
					selectedRowInfo = tariffMasterTG.geniisysRows[y];
					computeTariffTotals(selectedRowInfo);
					refreshTariffDetailTG(selectedRowInfo);
				},
				onRemoveRowFocus: function(){
					tariffMasterTG.keys.releaseKeys();
					selectedRowInfo = null;
					computeTariffTotals(selectedRowInfo);
					refreshTariffDetailTG(selectedRowInfo);
				},
				onRefresh: function(){
					tariffMasterTG.onRemoveRowFocus();
				},
				onSort: function(){
					tariffMasterTG.onRemoveRowFocus();
				},
				prePager: function(){
					tariffMasterTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						tariffMasterTG.onRemoveRowFocus();
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
					id: 'tarfCd',
					title: 'Tariff Code',
					width: '190px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'tarfDesc',
					title: 'Tariff',
					width: '450px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				}
			],
			rows: objTariffMaster.objRows
		};
		
		tariffMasterTG = new MyTableGrid(tariffMasterTableModel);
		tariffMasterTG.pager = objTariffMaster.tableGrid;
		tariffMasterTG.render('tariffDetailDiv');
		
	}catch(e){
		showErrorMessage("tariffMaster table grid", e);
	}
	
	
	var objTariffDetail = new Object();
	objTariffDetail.tableGrid = JSON.parse('${tariffDetailTG}'.replace(/\\/g, '\\\\'));
	objTariffDetail.objRows = objTariffDetail.tableGrid.rows || [];
	objTariffDetail.objList = [];	// holds all the geniisys rows
	
	try{
		var tariffDetailTableModel = {
				url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireTariffDetail&refresh=1",
				options: {
					width: '840px',
					height: '150px',
					onRemoveRowFocus: function(){
						tariffDetailTG.keys.releaseKeys();
					},
					onRefresh: function(){
						tariffDetailTG.onRemoveRowFocus();
					},
					onSort: function(){
						tariffDetailTG.onRemoveRowFocus();
					},
					toolbar: {
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onFilter: function(){
							tariffDetailTG.onRemoveRowFocus();
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
						id: 'tarfCd',
						width: '0px',
						visible: false
					},
					{
						id: 'assdNo',
						width: '0px',
						visible: false
					},
					{
						id: 'userId',
						width: '0px',
						visible: false
					},
					{
						id: 'policyNo',
						title: 'Policy No',
						width: '240px',
						titleAlign: 'left',
						visible: true,
						sortable: true,
						filterOption: true
					},
					{
						id: 'assdName',
						title: 'Assured Name',
						width: '300px',
						titleAlign: 'left',
						visible: true,
						sortable: true,
						filterOption: true
					},
					{
						id: 'tsiAmt',
						title: 'TSI Amount',
						width: '130px',
						titleAlign: 'right',
						align:	'right',
						visible: true,
						sortable: true,
						geniisysClass: 'money'
					},
					{
						id: 'premAmt',
						title: 'Premium Amount',
						width: '130px',
						titleAlign: 'right',
						align:	'right',
						visible: true,
						sortable: true,
						geniisysClass: 'money'
					}
				],
				rows: objTariffDetail.objRows
		};
		
		tariffDetailTG = new MyTableGrid(tariffDetailTableModel);
		tariffDetailTG.pager = objTariffDetail.tableGrid;
		tariffDetailTG.render('tariffDetail2Div');
	}catch(e){
		showErrorMessage("tariffDetail table grid", e);
	}
	
	function computeTariffTotals(row){
		try{
			new Ajax.Request(contextPath+"/GIPIGenerateStatisticalReportsController",{
				parameters: {
					action:		"computeFireTariffTotals",
					asOfSw:		objGIPIS901.asOfSw,
					tarfCd:		row == null ? null : row.tarfCd,
					zoneType :  $F("hidZoneType") //edgar 03/20/2015
				},
				onComplete: function(response){
					if (checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						$("txtTotalTsiAmt").value = formatCurrency(nvl(json.sumTsiAmt, 0));
						$("txtTotalPremAmt").value = formatCurrency(nvl(json.sumPremAmt, 0));
					}
				}
			});
		}catch(e){
			showErrorMessage("computeTariffTotals", e);
		}
	}
	
	function refreshTariffDetailTG(row){
		var tarfCd = row == null? null : row.tarfCd;
		tariffDetailTG.url = contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireTariffDetail&refresh=1&tarfCd="+tarfCd+
							 "&asOfSw="+objGIPIS901.asOfSw+"&zoneType="+$F("hidZoneType"); //edgar 03/20/2015
		tariffDetailTG._refreshList();
	}
	
	
	$("btnPrint").observe("click", function(){
		objGIPIS901.commAccumSw = false;
		objGIPIS901.printSw = "T";
		showGIPIS901FirePrintDialog("Print Fire Statistical Request");
	});
}catch(e){
	showErrorMessage("popup page error", e);
}
</script>