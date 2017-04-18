<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="inspectionListingMainDiv" name="inspectionListingMainDiv">
	<div id="inspectionListingMenu">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="inspectionListingExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>List of Inspection Reports</label>
		</div>
	</div>
	
	<div id="inspListTableSectionDiv" class="sectionDiv" style="height: 370px;">
		<div id="inspListTableGridDiv" style="padding: 10px;">
			<div id="inspListTableGrid" style="height: 325px; width: 900px;"></div>
		</div>
	</div>
</div>
<script type="text/javaScript">
	setDocumentTitle("List of Inspection Reports");
	var row = null;

	try {
		var objInsp = new Object();
		objInsp.objInspListTableGrid = JSON.parse('${inspDataTableGrid}'.replace(/\\/g, '\\\\'));
		objInsp.objInspList = objInsp.objInspListTableGrid.rows || [];

		var inspDataTableModel = {
			url: contextPath+"/GIPIInspectionReportController?action=refreshInspectionListing",
			options: {
				title: '',
				width: '900px', 
				onRowDoubleClick: function(y){
					var rowObj = inspTableGrid.geniisysRows[y];
					showInspectionReport(rowObj);
				},
				onCellFocus: function(element, value, x, y, id){
					row = inspTableGrid.geniisysRows[y];
				},
				onRemoveRowFocus: function (element, value, x, y, id){
					row = null;
				},
				toolbar: {
					elements: [MyTableGrid.ADD_BTN, MyTableGrid.EDIT_BTN, MyTableGrid.PRINT_BTN, MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onAdd: function(){
						inspTableGrid.keys.releaseKeys();
						var newInsp = new Object();
						//newInsp.inspNo = generateInspNo();
						newInsp.inspNo = "";
						newInsp.assdNo = "";
						newInsp.assdName = "";
						newInsp.inspCd = "";
						newInsp.inspName = "";
						newInsp.intmNo = "";
						newInsp.intmName = "";
						newInsp.dateApproved = "";
						newInsp.dateInsp = "";
						showInspectionReport(newInsp);
					},
					onEdit: function(){
						inspTableGrid.keys.releaseKeys(); // andrew - 05.27.2011
						if (row == null){
							showMessageBox("Please select an inspection report", imgMessage.ERROR);
							return false;
						} else {
							showInspectionReport(row);
						}
					},
					onPrint: function(){
						inspTableGrid.keys.releaseKeys(); // andrew - 05.27.2011
						if (row == null){
							showMessageBox("Please select an inspection report", imgMessage.ERROR);
							return false;
						} else {
							printInspectionReport(row.inspNo);
						}
					}
				}
			},
			columnModel: [
			    {
					id: 'recordStatus',
					title: '',
					width: '0',
					visible: false,
					editor: 'checkbox'
			    },
			    {
					id: 'divCtrId',
					width: '0',
					visible: false
			    },
			    {
					id: 'inspNo',
					title: 'Inspection No.',
					width: '144px',
					align: 'left',
					filterOption: true
			    },
			    {
					id: 'inspName',
					title: 'Inspector',
					width: '245px',
					align: 'left',
					filterOption: true
			    },
			    {
					id: 'assdName',
					title: 'Assured',
					width: '245px',
					align: 'left',
					filterOption: true
			    },
			    {
					id: 'strDateInsp',
					title: 'Date Inspected',
					width: '215px',
					titleAlign: 'center',
					align: 'center',
					filterOption: true,
					renderer: function(value){
						return dateFormat(value, "mm/dd/yyyy");//return formatDateToDefaultMask(value);
					}
			    },
// 			    {					//remove by steven 08.22.2012
// 					id: 'status',
// 					sortable: false,
// 					align: 'center',
// 					title: '&#160;&#160;A',
// 					titleAlign: 'center',
// 					width: '23px',
// 					defaultValue: false,
// 					otherValue: false,
// 					editor: new MyTableGrid.CellCheckbox({
// 						getValueOf: function (value){
// 							if (value){
// 								return "A";
// 							} else {
// 								return "N";
// 							}
// 						}
// 					})
// 			    },
				{
					id: 'status',		//added by steven 08.22.2012
					visible: false,
					width: '0',
					defaultValue: false,
					otherValue: false,
					editor: new MyTableGrid.CellCheckbox({
						getValueOf: function (value){
							if (value){
								return "A";
							} else {
								return "N";
							}
						}
					})
			    },
				{
					id: 'tbgStatus',		// added by: steven 08.22.2012 - to uncheck the 'A' only if the status is new
					sortable: false,
					align: 'center',
					title: '&#160;&#160;A',
					titleAlign: 'center',
					width: '23px',
					editable: false,
					editor:	 'checkbox',
					sortable:false
			    },
			    {
					id: 'inspCd',
					width: '0',
					visible: false
			    },
			    {
					id: 'assdNo',
					width: '0',
					visible: false
			    },
			    {
					id: 'intmNo',
					width: '0',
					visible: false
			    },
			    {
					id: 'intmName',
					width: '0',
					visible: false
			    },
			    {
					id: 'approvedBy',
					width: '0',
					visible: false
			    },
			    {
					id: 'dateApproved',
					width: '0',
					visible: false
			    }
			],
			requiredColumns: '',
			resetChangeTag: true,
			rows: objInsp.objInspList
		};

		inspTableGrid = new MyTableGrid(inspDataTableModel);
		inspTableGrid.pager = objInsp.objInspListTableGrid;
		inspTableGrid.render('inspListTableGrid');
	} catch (e){
		showErrorMessage("inspectionListing.jsp", e);
	}
	
	$("inspectionListingExit").observe("click", function(){
		inspTableGrid.keys.removeFocus(inspTableGrid.keys._nCurrentFocus, true);
		inspTableGrid.keys.releaseKeys();
		checkChangeTagBeforeUWMain();
	});
</script>