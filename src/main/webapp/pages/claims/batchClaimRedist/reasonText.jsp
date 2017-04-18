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
<div id="reasonTextMainDiv" name="reasonTextMainDiv" style="margin-top: 1px;">
	<div id="reasonTextDiv" name="reasonTextDiv" class="sectionDiv" style="width: 99%; margin-left: 4px; margin-top: 10px; height: 240px;">
		<div id="reasonTextMainTable">
			<div id="reasonTextTable" style="height: 260px; margin-left: 10px; margin-top: 10px;">
			</div>
		</div>
	</div>
	<div class="buttonDiv" style="float: left; width: 99%; padding-bottom: 5px; padding-top: 10px; margin-left: 4px;"> 
		<table align="center">
			<tbody>
				<tr>
					<td>
						<input id="btnInspection" class="button noChangeTagAttr" type="button" style="display: none; value="Select Inspection" name="btnInspection">
					</td>
					<td>
						<input id="btnClose" class="button" type="button" style="width: 120px;" value="Close" name="btnClose">
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</div>
<script type="text/javascript">
	var objReasonTxt = new Object();
	objReasonTxt.objReasonTxtTableGrid = JSON.parse('${reasonTxtList}');
	objReasonTxt.objReasonTxtList = objReasonTxt.objReasonTxtTableGrid.rows || [];
	var savePath = '${savePath}';
	var destination = '${destination}';
	var fileName = '${fileName}';
	
	try{
		var reasonTxtTableModel = {
				url: contextPath+"/GICLClaimReserveController?action=showReasonTextOverlay&refresh=1&rows=" + objReasonTxt.objReasonTxtTableGrid,
				options: {
					title: '',
					height: '220px',
					width: '673px',
					pager : {},
					onCellFocus: function(element, value, x, y, id){
						var mtgId = reasonTxtTableGrid._mtgId;
						selectedIndex = -1;
						if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
							selectedIndex = y;
	                	}
					},
					onRemoveRowFocus: function(){
						reasonTxtTableGrid.keys.removeFocus(reasonTxtTableGrid.keys._nCurrentFocus, true);
						reasonTxtTableGrid.keys.releaseKeys();
					}
				},
				columnModel:[
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
							id: 'pMessage',
							title: 'Reason',
							width: '670',
							titleAlign: 'center'
						}
				],
				rows: objReasonTxt.objReasonTxtList,
				id: 1
		};
		
		reasonTxtTableGrid = new MyTableGrid(reasonTxtTableModel);
		reasonTxtTableGrid.pager = objReasonTxt.objReasonTxtTableGrid;
		reasonTxtTableGrid.render('reasonTextTable');
		reasonTxtTableGrid.afterRender = function(){
			document.getElementById('pagerDiv1').style.display='none';
		};
	}catch(e){
		showMessageBox("Error in Reason Text Table Grid : " + e, imgMessage.ERROR);
	}
	
	$("btnClose").observe("click", function(){
		var userLocalPath = $("geniisysAppletUtil").copyFileToLocal(savePath, "GICLS038_LOGS");
		showMessageBox("The list of claims that has been redistributed is saved to " + userLocalPath.substring(9) + fileName , "S");
		
		new Ajax.Request(contextPath + "/GICLClaimReserveController", {
			parameters : {
				action : "deleteCopiedFile",
				url : savePath
			}
		});
		
		overlayReasonText.close();
		delete overlayReasonText;
	});

	var selectedIndex = 0;
</script>