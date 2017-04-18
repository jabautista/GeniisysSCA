<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<script>
objAC.modifiedRows = null;
objAC.addedRows = null;
objAC.dateToday = new Date();

var objGIACSpoiledOr = JSON.parse('${spoiledOrListing}'.replace(/\\/g, "\\\\"));
var spoilORTable = {
		url: contextPath+"/GIACSpoiledOrController?action=refreshSpoiledOR&fundCd="+objACGlobal.fundCd+"&branchCd="+objACGlobal.branchCd,
		options: {
			hideColumnChildTitle: true,
			width: '660px',
			pager: {
			},
			toolbar: {
				elements: [MyTableGrid.ADD_BTN, MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
				onAdd: function(){
					tbgSpoilOR.keys.releaseKeys();
				},
				onEdit: function(){
					tbgSpoilOR.keys.releaseKeys();
				}
			},
			onCellFocus : function(element, value, x, y, id) {
				var spoilTag = tbgSpoilOR.getRow(y).spoilTag;
				loopCtr = 0;
				objAC.yValue = y;
				objAC.prevTranId = tbgSpoilOR.getRow(y).tranId;
				objAC.orPref = tbgSpoilOR.getRow(y).orPref;
				objAC.orNo = tbgSpoilOR.getRow(y).orNo;
				objAC.fundCd = tbgSpoilOR.getRow(y).fundCd;
				objAC.branchCd = tbgSpoilOR.getRow(y).branchCd;
				objAC.spoilDate = tbgSpoilOR.getRow(y).spoilDate;
				objAC.prevOrDate = tbgSpoilOR.getRow(y).orDate;
				objAC.origOrPref = tbgSpoilOR.getRow(y).origOrPref;
				objAC.origOrNo = tbgSpoilOR.getRow(y).origOrNo;
				
				if (spoilTag == 'M') {
					$("mtgIC" + this._mtgId + '_' + x +','+y).setAttribute("editableDiv", "true");
				}else if (spoilTag == 'S') {
					$("mtgIC" + this._mtgId + '_' + x +','+y).setAttribute("editableDiv", "false");
				}else if (spoilTag == null){
					//tbgSpoilOR.getRow(y).spoilTag = "M";
				}
			},
			onCellBlur: function (element, value, x, y, id) {
				objAC.modifiedRows = tbgSpoilOR.getModifiedRows();
				objAC.addedRows = tbgSpoilOR.getNewRowsAdded();
				if (objAC.modifiedRows.length > 0 || objAC.addedRows.length > 0) {
					changeTag = 1;
					if (tbgSpoilOR.getRow(y).orPref != "" && tbgSpoilOR.getRow(y).orNo != ""){
						if (tbgSpoilOR.geniisysRows[y] != null){
							if  (tbgSpoilOR.geniisysRows[y].origOrPref != tbgSpoilOR.getRow(y).orPref || tbgSpoilOR.geniisysRows[y].origOrNo != tbgSpoilOR.getRow(y).orNo){
								validateSpoiledOr(y);
							}
						}else {
							validateSpoiledOr(y);
						}
					}
				}
				loopCtr = loopCtr + 1;
				if (loopCtr < 2){
					fireEvent($("mtgIC1_11," + y), "click");
				}
			},	
			rowPostQuery: function (y) {	
				setOrigKeys();
			}	
		},								
		columnModel: [
			{
			    id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{
				id: 'spoilTag',
				width: '0',
				visible: false 
			},
			{
				id: 'tranId',
				width: '0',
				visible: false 
			},
			{
				id: 'fundCd',
				width: '0',
				visible: false 
			},
			{
				id: 'branchCd',
				width: '0',
				visible: false 
			},
			{
				id: 'origOrNo',
				width: '0',
				visible: false 
			},
			{
				id: 'origOrPref',
				width: '0',
				visible: false 
			},
			{	id: 'orPref orNo',
				title: 'O.R. Number',
				children : 
				[
					{			
						id : "orPref",
						title: "OR Pref Suf",
						width: 70,
						filterOption: true,
						editable: true,
						align: 'right',
						editor: new MyTableGrid.CellInput({
							validate: function(value, input) {
								setColumnValues();
								return true;
							}
						})
					},
					{
					id : "orNo",
					title: "OR Number",
					width: 92,
					filterOption: true,
					editable: true,
					align: 'right',
					editor: new MyTableGrid.CellInput({
						validate: function(value, input) {
							setColumnValues(value);
							return true;
						}
					})
					}
				]
			},	
			{
				id : "orDate",
				title: "O.R. Date",
				width: '120px',
				filterOption: true,
				editable: true,
				editor: new MyTableGrid.CellInput({
					validate: function(value, input) {
					var inputDate = Date.parse(value);
					var coords = tbgSpoilOR.getCurrentPosition();
                    var x = coords[0]*1;
                    var y = coords[1]*1;
						if (inputDate != null){
		                    tbgSpoilOR.setValueAt(inputDate.format("mm-dd-yyyy"), tbgSpoilOR.getColumnIndex('orDate'), y);
		                    setColumnValues();
		                    return true;
						}else if (inputDate == null && tbgSpoilOR.getRow(y).orDate != ""){
							showMessageBox("Date must be entered in a format like MM-DD-RRRR.", imgMessage.INFO);
							tbgSpoilOR.setValueAt("", tbgSpoilOR.getColumnIndex('orDate'), y);
							return false;
						}
					}
				})
			},
			{	
				id : "spoilDate",
				title: "Spoil Date",
				width: '170px'
			},
			{	
				id : "spoilTagDesc",
				title: "Spoil Tag",
				width: '180px'
			}
		],
		rows: objGIACSpoiledOr.rows
	};

tbgSpoilOR = new MyTableGrid(spoilORTable);
tbgSpoilOR.pager = objGIACSpoiledOr;
tbgSpoilOR.render('spoilORTable');

function setColumnValues(){
	var coords = tbgSpoilOR.getCurrentPosition();
    var y = coords[1]*1;
    if (y < 0) {
		tbgSpoilOR.setValueAt(objAC.dateToday.format("mm-dd-yyyy hh:MM:ss TT"), tbgSpoilOR.getColumnIndex('spoilDate'), y);
		tbgSpoilOR.setValueAt("M - MANUALLY SPOILED", tbgSpoilOR.getColumnIndex('spoilTagDesc'), y);
    }
}

function setOrigKeys(){
	for (var i=0; i<tbgSpoilOR.geniisysRows.length; i++){
		tbgSpoilOR.geniisysRows[i].origOrPref = tbgSpoilOR.geniisysRows[i].orPref;
		tbgSpoilOR.geniisysRows[i].origOrNo = tbgSpoilOR.geniisysRows[i].orNo;
	}
}
</script>