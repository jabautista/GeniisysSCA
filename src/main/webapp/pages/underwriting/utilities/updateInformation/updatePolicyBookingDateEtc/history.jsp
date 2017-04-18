<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div style="width: 99.5%; margin-top: 5px;">
	<div class="sectionDiv">
		<table align="center" border="0">
			<tr>
				<td style="padding-right: 5px;"><label for="txtPolicyEndtNo" style="float: right;">Policy / Endt. No.</label></td>
				<td><input type="text" id="txtPolicyEndtNo" style="width: 420px;" readonly="readonly"/></td>
				<td style="padding-right: 5px; width: 89px;"><label for="txtTakeupNo" style="float: right;">Takeup No.</label></td>
				<td><input type="text" id="txtTakeupNo" style="width: 150px; text-align: right;" readonly="readonly"/></td>
			</tr>
			<tr>
				<td style="padding-right: 5px;"><label for="txtAssured2" style="float: right;">Assured</label></td>
				<td colspan="3"><input type="text" id="txtAssured2" style="width: 680px;" readonly="readonly"/></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div style="clear: both; margin: 10px auto; width: 820px;">
			<div id="historyTableGridDiv" style="height: 300px;"></div>
		</div>
	</div>
	<div style="float : none; text-align: center;">
		<input type="button" class="button" id="btnReturn" value="Return" style="width: 100px; margin-top: 10px;"/>
	</div>
	
</div>
<script>
	try {
		
		$("txtPolicyEndtNo").value = objGIPIS156.policyEndtNo;
		$("txtAssured2").value = unescapeHTML2(objGIPIS156.assdName2);
		
		if(objGIPIS156.endtType == 'N')
			$("txtTakeupNo").value = "";
		else
			$("txtTakeupNo").value = objGIPIS156.takeupSeqNo;
		
		var jsonGIPIS156History = JSON.parse('${jsonGIPIS156History}');
		historyTableModel = {
				url: contextPath+ "/UpdateUtilitiesController?action=showGIPIS156History&refresh=1&policyId=" + objGIPIS156.policyId + "&premSeqNo=" + objGIPIS156.premSeqNo + "&takeupSeqNo=" + objGIPIS156.takeupSeqNo,
				id: 'tbgHistory',		
				options: {
					/* toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					}, */
					width: '820px',
					height: '275px',
					hideColumnChildTitle : false,
					onCellFocus : function(element, value, x, y, id) {
						//setDetails(historyTbg.geniisysRows[y]);					
						historyTbg.keys.removeFocus(historyTbg.keys._nCurrentFocus, true);
						historyTbg.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){					
						//setDetails(null);
						historyTbg.keys.removeFocus(historyTbg.keys._nCurrentFocus, true);
						historyTbg.keys.releaseKeys();
					},
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
						id: 'histNo',
						title: 'No.',
						width: '40px',
						align: 'right',
						titleAlign: 'right',
						sortable: false
					},
					{
						id: 'oldRPolSwitch dspOldBookingMthYy dspOldCredBranch',
						title: 'Old',
						sortable: false,
						//width: '210px',
						children: [
							{
								id: 'oldRPolSwitch',
								title: 'R',
								width: 30,
								sortable: false,
								editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
									if (value){
										return"Y";
									}else{
										return"N";
									}
								}})
							},
							{
								id: 'dspOldBookingMthYy',
								title: 'Booking Month/Year',
								width: 130,
								sortable: false
							},
							{
								id: 'dspOldCredBranch',
								title: 'Crediting Branch',
								width: 130,
								sortable: false
							}
						]
					},
					{
						id: 'newRPolSwitch dspNewBookingMthYy dspNewCredBranch',
						title: 'New',
						sortable: false,
						//width: '210px',
						children: [
							{
								id: 'newRPolSwitch',
								title: 'R',
								width: 30,
								sortable: false,
								editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
									if (value){
										return"Y";
									}else{
										return"N";
									}
								}})
							},
							{
								id: 'dspNewBookingMthYy',
								title: 'Booking Month/Year',
								width: 130,
								sortable: false
							},
							{
								id: 'dspNewCredBranch',
								title: 'Crediting Branch',
								width: 130,
								sortable: false
							}
						]
					},
					{
						id: 'dspUserId',
						title: 'User ID',
						width: '80px',
						sortable: false
					},
					{
						id: 'dspLastUpdate',
						title: 'Last Update',
						width: '96px',
						align: 'center',
						titleAlign: 'center',
						sortable: false
					}
				],
				rows: jsonGIPIS156History.rows
			};
		
		historyTbg = new MyTableGrid(historyTableModel);
		historyTbg.pager = jsonGIPIS156History;
		historyTbg.render('historyTableGridDiv');
		//historyTbg.afterRender = function(){};
		
		$("btnReturn").observe("click", function(){
			overlayHistory.close();
			delete overlayHistory;
		});
		
		initializeAll();
		
	} catch (e) {
		showMessageBox("Error in history" + e, imgMessage.ERROR);
	}
</script>