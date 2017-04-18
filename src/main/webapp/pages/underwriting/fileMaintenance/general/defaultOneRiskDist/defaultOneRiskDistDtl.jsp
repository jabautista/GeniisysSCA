<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="giisDefaultDistDtlMainDiv" name="giisDefaultDistDtlMainDiv">
	<div id="giisDefaultDistDtl" name="giisDefaultDistDtl">
		<div class="sectionDiv" style="width: 99%; height: 342px; margin-top: 5px; margin-left: 2px;">
			<div id="giisDefaultDistDtlTableDiv" style="padding-top: 10px; padding-left: 10px;">
				<div id="giisDefaultDistDtlTable" style="height: 100px; margin-left: 0px;"></div>
			</div>
			<div align="center" id="giisDefaultDistDtlFormDiv" style="width: 99%; margin-top: 160px; margin-left: 2px;">
				<table style="margin-top: 5px;">
					<tr>
						<td align="right">Range From</td>
						<td style="padding-left: 5px;">
							<input id="txtRangeFrom" class="required" type="text" style="width:150px; margin-bottom: 0px; text-align: right;" tabindex="601">
						</td>
						<td align="right" style="padding-left: 20px;">Range To</td>
						<td style="padding-left: 5px;">
							<input id="txtRangeTo" class="required" type="text" style="width:150px; margin-bottom: 0px; text-align: right;" tabindex="602">
						</td>
					</tr>
				</table>
			</div>
			<div align="center" style="margin: 10px;">
				<input type="button" class="button" id="btnAddRange" value="Add" tabindex="404" style="width: 80px;">
				<input type="button" class="button" id="btnDeleteRange" value="Delete" tabindex="405" style="width: 80px;">
			</div>
			<div align="center" style="margin: 18px;">
				<input type="button" class="button" id="btnReturn" value="Return" tabindex="406" style="width: 80px;">
				<input type="button" class="button" id="btnSaveRange" value="Save" tabindex="407" style="width: 80px;">
			</div>
		</div>
	</div>
</div>
<input id="txtDefaultNo"    type="hidden"  value="${defaultNo}"/>
<script type="text/javascript">
	var rowIndexRange = -1;
	
	var objRange = {};
	var objCurrRange = null;
	objRange.rangeList = JSON.parse('${jsonGiisDefaultDistDtl}');
	
	var rangeTable = {
			url : contextPath + "/GIISDefaultOneRiskController?action=showGiiss065Range&refresh=1" + "&defaultNo=" + $F("txtDefaultNo"),
			options : {
				width : '575px',
				height : '250px',
				hideColumnChildTitle: true,
				pager : {},
				onCellFocus : function(element, value, x, y, id){
					rowIndexRange = y;
					objCurrRange = tbgRange.geniisysRows[y];
					setRangeFieldValues(objCurrRange);
					tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
					tbgRange.keys.releaseKeys();
					$("txtRangeFrom").focus();
				},
				toolbar : {
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter: function(){
						rowIndexRange = -1;
						setRangeFieldValues(null);
						tbgRange.keys.removeFocus(tbgRange.keys._nCurrentFocus, true);
						tbgRange.keys.releaseKeys();
					}
				}
			},
			columnModel : [
				{ 								// this column will only use for deletion
				    id: 'recordStatus', 		// 'id' should be 'recordStatus' to disregard the some event for saving and 'editor' should be 'checkbox' not instanceof CellCheckbox
				    width: '0',				    
				    visible : false			
				},
				{
					id : 'divCtrId',
					width : '0',
					visible : false
				},
				{
					id : "rangeFrom",
					title : "Range From",
					titleAlign : 'right',
					width : '275px',
					geniisysClass: 'money',
					align : 'right',
				},
				{
					id : "rangeTo",
					title : "Range To",
					titleAlign : 'right',
					width : '275px',
					geniisysClass: 'money',
					align : 'right',
				}
			],
			rows : objRange.rangeList.rows
	};
	
	tbgRange = new MyTableGrid(rangeTable);
	tbgRange.pager = objRange.rangeList;
	tbgRange.render("giisDefaultDistDtlTable");
	
	function setRangeFieldValues(rec){
		try{
			$("txtRangeFrom").value = (rec == null ? "" : formatCurrency(rec.rangeFrom));
			$("txtRangeTo").value = (rec == null ? "" : formatCurrency(rec.rangeTo));
			
			rec == null ? enableButton("btnAddRange") : disableButton("btnAddRange");
			rec == null ? disableButton("btnDeleteRange") : enableButton("btnDeleteRange");
			objCurrRange = rec;
		} catch(e){
			showErrorMessage("setRangeFieldValues", e);
		}
	}
	
	function closeOverlay(){
		overlayGiiss065Range.close();
		delete overlayGiiss065Range;
	}
	
	$("btnReturn").observe("click", closeOverlay);
</script>