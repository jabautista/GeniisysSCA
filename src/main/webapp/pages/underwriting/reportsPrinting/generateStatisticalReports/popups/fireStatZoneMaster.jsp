<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<div id="zoneMainDiv" style="width: 860px; height: 407px; ">
	<div class="sectionDiv" style="width: 860px; height: 407px; margin: 5px;">
		<table style="margin: 10px 0 5px 15px;">
			<tr>
				<td style="padding-right: 10px;">Zone</td>
				<td><input id="txtZone" type="text" readonly="readonly" style="width: 250px;" tabindex="101"/></td>
			</tr>
		</table>
		
		<div id="zoneMasterDiv" style="width: 700px; height: 310px; margin: 5px 5px 5px 10px;"></div>
				
		<div id="totalsDiv" style="width: 835px; height: 30px; margin-top: 15px;">
			<label style="padding: 6px 10px 0 375px;">Totals</label>
			<input id="txtTotalTsiAmt" type="text" class="money rightAligned" readonly="readonly" style="width: 190px; margin-left: 5px;">
			<input id="txtTotalPremAmt" type="text" class="money rightAligned" readonly="readonly"  style="width: 190px;">
		</div>
	
	</div>
	
	<div class="buttonsDiv">
		<input id="btnPrint" type="button" class="button" value="Print" style="width: 90px;" tabindex="102">
		<input id="btnDetail" type="button" class="button" value="Detail" style="width: 90px;" tabindex="103">
		<input id="btnReturn" type="button" class="button" value="Return" style="width: 90px;" tabindex="104">
	</div>
</div>

<script type="text/javascript">
try{
	$("txtZone").value = unescapeHTML2(objGIPIS901.extractPrevParam[0].zone);
	$("txtTotalTsiAmt").value = formatCurrency('${sumShareTsiAmt}');
	$("txtTotalPremAmt").value = formatCurrency('${sumSharePremAmt}');

	$("btnReturn").observe("click", function(){
		objGIPIS901.fireSelectedRow = null;
		zoneMasterTG.onRemoveRowFocus();
		overlayDetailsDialog.close();
	});
	
	var objZoneMaster = new Object();
	objZoneMaster.tableGrid = JSON.parse('${zoneMasterTG}'.replace(/\\/g, '\\\\'));
	objZoneMaster.objRows = objZoneMaster.tableGrid.rows || [];
	objZoneMaster.objList = [];	// holds all the geniisys rows
	
	try{
		var zoneMasterTableModel = {
			url: contextPath+"/GIPIGenerateStatisticalReportsController?action=getFireZoneMaster&refresh=1&asOfSw="+objGIPIS901.asOfSw+
				 "&lineCdFi="+objGIPIS901.lineCdFi+"&zoneType="+$F("hidZoneType"),
			options: {
				width: '840px',
				height: '295px',
				onCellFocus: function(element, value, x, y, id){
					objGIPIS901.fireSelectedRow = zoneMasterTG.geniisysRows[y];
				},
				onRemoveRowFocus: function(){
					zoneMasterTG.keys.releaseKeys();
					objGIPIS901.fireSelectedRow = null;
				},
				onRefresh: function(){
					zoneMasterTG.onRemoveRowFocus();
				},
				onSort: function(){
					zoneMasterTG.onRemoveRowFocus();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						zoneMasterTG.onRemoveRowFocus();
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
					id: 'shareCd',
					width: '0px',
					visible: false
				},    
				{
					id: 'asOfSw',
					width: '0px',
					visible: false
				},    
				{//added line name : edgar 03/20/2015
					id: 'lineName',
					title: 'Line Name',
					width: '80px',
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'shareName',
					title: 'Distribution Name',
					width: '340px', //changed width : edgar 03/20/2015
					titleAlign: 'left',
					visible: true,
					sortable: true,
					filterOption: true
				},
				{
					id: 'shareTsiAmt',
					title: 'TSI Amount',
					width: '200px',
					titleAlign: 'right',
					align:	'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				},
				{
					id: 'sharePremAmt',
					title: 'Premium Amount',
					width: '200px',
					titleAlign: 'right',
					align:	'right',
					visible: true,
					sortable: true,
					geniisysClass: 'money'
				}
			],
			rows: objZoneMaster.objRows
		};
		
		zoneMasterTG = new MyTableGrid(zoneMasterTableModel);
		zoneMasterTG.pager = objZoneMaster.tableGrid;
		zoneMasterTG.render('zoneMasterDiv');
		
	}catch(e){
		showErrorMessage("Zone Master table grid error", e);
	}
	
	function showZoneDetailsDialog(){
		objGIPIS901.share = unescapeHTML2(objGIPIS901.fireSelectedRow.shareName);
		
		overlayZoneDetailDialog = Overlay.show(contextPath+"/GIPIGenerateStatisticalReportsController", {
			urlContent : true,
			urlParameters: {
				action : 	"getFireZoneDetail",
				asOfSw:		objGIPIS901.asOfSw,
				lineCdFi:	objGIPIS901.lineCdFi,
				shareCd:	objGIPIS901.fireSelectedRow.shareCd,
				zoneType:	$F("hidZoneType") //edgar 03/20/2015
			},
		    title: "Firestat Zone Detail",
		    height: 510,
		    width: 870,
		    //draggable: true
		});
	}
	
	$("btnDetail").observe("click", function(){
		if (objGIPIS901.fireSelectedRow == null){
			showMessageBox("Please select a record first.", "I");
			return false;
		}
		
		zoneMasterTG.keys.releaseKeys();
		showZoneDetailsDialog();
	});
	 
	$("btnPrint").observe("click", function(){
		objGIPIS901.printSw = "Z";
		showGIPIS901FirePrintDialog("Print Fire Statistical Request");
	});

}catch(e){
	showErrorMessage("popup page error", e);
}
</script>