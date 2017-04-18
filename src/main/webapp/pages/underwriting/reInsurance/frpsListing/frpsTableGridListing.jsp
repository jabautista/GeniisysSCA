<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<jsp:include page="/pages/underwriting/reInsurance/menu.jsp"/>
<div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>FRPS Listing for ${lineName}</label>
			<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
		</div>
	</div>
	<div id="mainFrpsListingDiv" class="sectionDiv" style="margin-bottom: 50px;">
		<div id="frpsTableGridSectionDiv" class="" style="height: 360px;">
			<div id="frpsTableGridDiv" style="padding: 10px;">
				<div id="frpsTableGrid" style="height: 325px; width: 900px;"></div>
			</div>
		</div>
		<div id="frpsTableDetailsDiv" name="frpsTableDetailsDiv" class="" style="margin-bottom: 10px;">
			<table style="margin-top: 10px;" border="0" align="center">
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned" colspan="5">
						<input style="width: 568px;" type="text" id="assdName" name="assdName" value="" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Package Policy No</td>
					<td class="leftAligned" colspan="3">
						<input style="width: 200px;" type="text" id="packPolNo" name="packPolNo" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">Reference Policy No</td>
					<td class="leftAligned" >
						<input style="width: 180px;" type="text" id="refPolNo" name="refPolNo" value="" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Coverage Period</td>
					<td class="leftAligned">
						<input style="width: 80px;" type="text" id="covFrom" name="covFrom" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">to</td>
					<td class="leftAligned">
						<input style="width: 80px;" type="text" id="covTo" name="covTo" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">Currency</td>
						<td class="leftAligned">
						<input style="width: 180px;" type="text" id="currDesc" name="currDesc" value="" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Distribution No.</td>
					<td class="leftAligned" colspan="2">
						<input style="width: 100px; text-align: right;" type="text" id="distNo" name="distNo" value="" readonly="readonly"/>
					</td>
					<td class="leftAligned" >
						<input style="width: 80px; text-align: right;" type="text" id="distSeqNo" name="distSeqNo" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">Distribution Status</td>
					<td class="leftAligned">
						<input style="width: 180px;" type="text" id="distStat" name="distStat" value="" readonly="readonly"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Total TSI</td>
					<td class="leftAligned" colspan="3">
						<input style="width: 200px; text-align: right;" type="text" id="totTsi" name="totTsi" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">Total Premium</td>
						<td class="leftAligned">
						<input style="width: 180px; text-align: right;" type="text" id="totPrem" name="totPrem" value="" readonly="readonly"/>
					</td>
			   </tr>
				<tr>
					<td class="rightAligned">Facultative TSI Share</td>
					<td class="leftAligned" colspan="3">
						<input style="width: 200px; text-align: right;" type="text" id="totFacTsi" name="totFacTsi" value="" readonly="readonly"/>
					</td>
					<td class="rightAligned">Facultative Premium Share</td>
					<td class="leftAligned">
						<input style="width: 180px; text-align: right;" type="text" id="totFacPrem" name="totFacPrem" value="" readonly="readonly"/>
					</td>
				</tr> 
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIRIS006");
	setDocumentTitle("FRPS Listing");
	disableMenu("frpsListing");
	clearObjectValues(objRiFrps);
	
	function initializeFrps(row) {
		try {
			objRiFrps.lineCd = row.lineCd;
			objRiFrps.frpsYy = row.frpsYy;
			objRiFrps.frpsSeqNo = row.frpsSeqNo;

			objRiFrps.frpsNo = row.frpsNo;
			objRiFrps.premAmt = row.premAmt;
			objRiFrps.tsiAmt = row.tsiAmt;
			objRiFrps.endtNo = row.endtNo;
			objRiFrps.policyNo = row.policyNo;
			objRiFrps.currDesc = row.currDesc;
			objRiFrps.totFacTsi = row.totFacTsi;
			objRiFrps.totFacPrem = row.totFacPrem;
			
			objRiFrps.parNo = row.parNo;
			objRiFrps.parType = row.parType;
			objRiFrps.distNo = row.distNo;
			objRiFrps.distSeqNo = row.distSeqNo;
			objRiFrps.renewNo = row.renewNo;
			
			objRiFrps.parId = row.parId;
			objRiFrps.issCd = row.issCd;
			objRiFrps.parYy = row.parYy;
			objRiFrps.parSeqNo = row.parSeqNo;
			 
			objRiFrps.sublineCd = row.sublineCd;
			objRiFrps.renewNo = row.renewNo;
			objRiFrps.polSeqNo = row.polSeqNo;
			objRiFrps.issueYy = row.issueYy;
		} catch(e) {
			showErrorMessage("initializeFrps", e);
		}
	}
	
	try{
		var objFrps = new Object();
		objFrps.objFrpsListTableGrid = JSON.parse('${giriFrpsListTableGrid}'.replace(/\\/g, '\\\\'));
		objFrps.objFrpsList = objFrps.objFrpsListTableGrid.rows || [];
		
		var frpsTableModel = {
			url: contextPath+"/GIRIDistFrpsController?action=refreshFrpsListing&lineCd="+encodeURIComponent($F("lineCd")),
			options: {
				title: '',
				width: '900px',	
				onCellFocus: function(element, value, x, y, id){
					var obj = frpsTableGrid.geniisysRows[y];
					populateFrpsDetails(obj);
					riAcceptSearch = "N";
					var row = frpsTableGrid.geniisysRows[y];
					objRiFrps.lineName = '${lineName}'; //added by Gzelle 10.21.2013
					initializeFrps(row);
					frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true); // andrew - 11.09.2012
					frpsTableGrid.keys.releaseKeys(); // andrew - 11.09.2012
				}, 
				onRemoveRowFocus: function (element, value, x, y, id) {
					populateFrpsDetails(null);
					clearObjectValues(objRiFrps);
					frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true); // andrew - 11.09.2012
					frpsTableGrid.keys.releaseKeys(); // andrew - 11.09.2012
				},
				toolbar:{
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onRefresh: function() {
						clearFrpsFields();
						frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true); // andrew - 11.09.2012
						frpsTableGrid.keys.releaseKeys(); // andrew - 11.09.2012
					}
				},
				onRowDoubleClick: function(y){
					frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true);
					frpsTableGrid.keys.releaseKeys();
					var row = frpsTableGrid.geniisysRows[y];
					objRiFrps.lineName = '${lineName}'; //added by steven 10/15/2012
					initializeFrps(row);
					showCreateRiPlacementPage();
				},
				onSort: function(){
					clearFrpsFields();
					frpsTableGrid.keys.removeFocus(frpsTableGrid.keys._nCurrentFocus, true); // andrew - 11.09.2012
					frpsTableGrid.keys.releaseKeys(); // andrew - 11.09.2012
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
				{	id: 'distByTsiPrem',
					title: '&#160;&#160;&#160;D',
					width: '30',
					align: 'center',
					altTitle: 'Dist. by TSI / Prem.',
					sortable: false,
					editable:	false,
					defaultValue: false,
					otherValue:	false,
					validValue: 1,
					editor: 'checkbox'
				},
				{	id: 'frpsNo',
					width: '160',
					title: 'FRPS No.',
					titleAlign: 'center'					
				},
				{	id: 'frpsYy',
					width: '0',
					title: 'FRPS Year',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'frpsSeqNo',
					width: '0',
					title: 'FRPS Seq No.',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'parNo',
					title: 'PAR No.',
					width: '180',
					titleAlign: 'center'
				},
				{	id: 'issCd',
					width: '0',
					title: 'Issue Code',
					visible: false,
					filterOption: true
				},
				{	id: 'parYy',
					title: 'PAR Year',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'parSeqNo',
					title: 'PAR Seq No.',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'parType',
					title: '&#160;&#160;&#160;P',
					width: '30',
					titleAlign: 'center',
					align: 'center',
					altTitle: 'PAR Type',
					sortable: false
				},
				{	id: 'policyNo',
					title: 'Policy No.',
					titleAlign: 'center',
					width: '227'
				},
				{	id: 'sublineCd',
					title: 'Subline Code',
					width: '0',
					visible: false,
					filterOption: true
				},
				{	id: 'issueYy',
					title: 'Issue Year',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'polSeqNo',
					title: 'Policy Seq No.',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtNo',
					title: 'Endorsement No.',
					titleAlign: 'center',
					width: '180'
				},
				{	id: 'endtYy',
					title: 'Endt Year',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{	id: 'endtSeqNo',
					title: 'Endt Seq No.',
					width: '0',
					visible: false,
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				},
				{ 	id:			'spclPolTag',
					sortable:	false,
					align:		'center',
					title:		'&#160;&#160;&#160;S',
					altTitle:   'Special Policy',
					titleAlign:	'center',
					width:		'30',
					editable:	false,
					defaultValue: false,
					otherValue:	false,
					validValue:	2,
					editor:		'checkbox'
				},
 				{
					id: 'assdName',
					title: 'Assured Name',
					visible: false,
					width: '0',
					filterOption : true
				},
				{
					id: 'distNo',
					title: 'Distribution No.',
					visible: false,
					width: '0',
					filterOption: true,
					filterOptionType: 'integerNoNegative'
				}
			],
			rows: objFrps.objFrpsList	
		};
	
		frpsTableGrid = new MyTableGrid(frpsTableModel);
		frpsTableGrid.pager = objFrps.objFrpsListTableGrid;
		frpsTableGrid.render('frpsTableGrid');
	
	}catch(e){
		showErrorMessage("frpsTableGridListing.jsp", e);
	}
</script>
