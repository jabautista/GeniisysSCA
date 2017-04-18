<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="flaDtlsDiv" name="flaDtlsDiv" class="sectionDiv" style="height: 300px; padding-top: 15px;">
	<div id="flaDtlsTGDiv" name="flaDtlsTGDiv" style="height: 170px; width: 99%; padding-left: 55px;">
		
	</div>
	
	<div id="flaTitleDiv" name="flaTitleDiv" style="height: 95px; width: 99%;">
		<table align="center">
			<tr>
				<td align="right" style="padding-bottom: 2px;">FLA Title</td>
				<td>
					<div style="border: 1px solid gray; height: 20px; width: 500px;">
						<textarea id="flaTitle" name="flaTitle" style="width: 470px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="500"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFlaTitle" />
					</div>
				</td>
			</tr>
			<tr>
				<td align="right" style="padding-bottom: 2px;">FLA Header</td>
				<td>
					<div style="border: 1px solid gray; height: 20px; width: 500px;">
						<textarea id="flaHeader" name="flaHeader" style="width: 470px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="500"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFlaHeader" />
					</div>
				</td>
			</tr>
			<tr>
				<td align="right" style="padding-bottom: 2px;">FLA Footer</td>
				<td>
					<div style="border: 1px solid gray; height: 20px; width: 500px;">
						<textarea id="flaFooter" name="flaFooter" style="width: 470px; border: none; height: 13px; margin: 0px; resize: none;" maxlength="2000"/></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editFlaFooter" />
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="updateBtnDiv" name="updateBtnDiv" align="center" class="buttonsDiv" style="margin-top: 0px; padding-top: 0px;">
		<input id="btnUpdate" name="btnUpdate" type="button" class="button" value="Update" style="width: 90px;">
	</div>
</div>

<script type="text/javascript">
	var arrFlaDtlsButtons = [MyTableGrid.REFRESH_BTN];
	var selectedIndex = -1;

	changeTag = 0;
	objCLM.objFlaDtlsTableGrid = JSON.parse('${flaDtlsTableGrid}');
	objCLM.objFlaDtlsRows = objCLM.objFlaDtlsTableGrid.rows || [];
	try{
		var flaDtlsTableModel = {
			url: contextPath+"/GICLAdvsFlaController?action=getFLADtls&refresh=1&claimId="+objCLM.fla.claimId+"&grpSeqNo="+objCLM.fla.grpSeqNo+"&shareType="+objCLM.fla.shareType+"&adviceId="+objCLM.fla.adviceId,
			options: {
				hideColumnChildTitle: true,
				title: '',
	          	height: '132px',
	          	width: '810px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = flaDtlsTableGrid._mtgId;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            		objCLM.fla.laYy = flaDtlsTableGrid.geniisysRows[0].laYy;
	    				objCLM.fla.advFlaId = flaDtlsTableGrid.geniisysRows[0].advFlaId;
	    				enableFlaFields();
	            	}
	            	flaDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
	            },
	            onRemoveRowFocus: function(){
	            	flaDtlsTableGrid.keys.removeFocus(flaDtlsTableGrid.keys._nCurrentFocus, true);
	            	flaDtlsTableGrid.keys.releaseKeys();
            		disableFlaFields();
	            	selectedIndex = -1;
	            	flaDtlsTableGrid.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
	            },
	            onRefresh: function(){
	            	selectedIndex = 0;
	            	enableFlaFields();
	            },
	            onSort: function(){
	            	selectedIndex = 0;
	            	enableFlaFields();
	            },
	            toolbar: {
	            	elements: (arrFlaDtlsButtons)
	            }
			},
			columnModel:[
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
							id: 'advFlaId',
							width: '0px',
							visible: false
						},
						{
							id: 'laYy',
							width: '0px',
							visible: false
						},
						{
							id: 'checkGen',
							title: '&nbsp;&nbsp;P',
						    width: '25px',
						    visible: true,
						    titleAlign: 'left',
						    align: 'left',
						    editable:true,
						    hideSelectAllBox: true,
						    sortable: false,
						    altTitle : 'Check FLA to be printed',
						    editor: new MyTableGrid.CellCheckbox({
								getValueOf: function(value){
				            		if (value){
										return "Y";
				            		}else{
										return "N";	
				            		}	
				            	} ,
				            	onClick: function() {
			            		}
				            })
						},
						{	
							id: 'printSw',
							title: '&nbsp;&nbsp;P',
			            	width: '25px',
			            	altTitle: 'Print Switch',
			            	titleAlign: 'left',
			            	align: 'left',
			            	sortable: false,
			            	editable: false,
			            	editor: 'checkbox'
						},
						{	id: 'flaNo',
							title: 'FLA No.',
			            	width: '113px',
			            	titleAlign: 'center'
						},
						{	id: 'dspRiName',
							title: 'Reinsurer',
			            	width: '250px',
			            	titleAlign: 'center'
						},
						{	id: 'paidShrAmt',
							title: 'Paid Share Amount',
			            	width: '120px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'netShrAmt',
							title: 'Net Share Amount',
			            	width: '120px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'advShrAmt',
							title: 'Advice Share Amount',
			            	width: '123px',
			            	titleAlign: 'center',
			            	align: 'right',
			            	geniisysClass: 'money'
						},
						{	id: 'flaSeqNo',
							width: '0px',
							visible: false
						},
						{	id: 'flaId',
							width: '0px',
							visible: false
						},
						{	id: 'riCd',
							width: '0px',
							visible: false
						},
						{	id: 'shareType',
							width: '0px',
							visible: false
						},
						{	id: 'grpSeqNo',
							width: '0px',
							visible: false
						}
  					],
  				rows: objCLM.objFlaDtlsRows,
  				id: 3
		};
		flaDtlsTableGrid = new MyTableGrid(flaDtlsTableModel);
		flaDtlsTableGrid.pager = objCLM.objFlaDtlsTableGrid;
		flaDtlsTableGrid.render("flaDtlsTGDiv");
		flaDtlsTableGrid.afterRender = function(){
			if (objCLM.objFlaDtlsRows.length > 0){
				flaDtlsTableGrid.selectRow('0');
				selectedIndex = 0;
				objCLM.fla.laYy = flaDtlsTableGrid.geniisysRows[0].laYy;
				objCLM.fla.advFlaId = flaDtlsTableGrid.geniisysRows[0].advFlaId;
				$("flaTitle").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[0].flaTitle);
				$("flaHeader").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[0].flaHeader);
				$("flaFooter").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[0].flaFooter);
				enableFlaFields();
			}else{
				disableFlaFields();
			}
		};
	}catch(e){
		showMessageBox("Error in FLA Details: " + e, imgMessage.ERROR);		
	}
	
	initializeFlaFields();
	function initializeFlaFields(){
		if(objCLM.fla.selectedIndexAdv == -1){
			disableFlaFields();
		}else{
			if(adviceDtlsTableGrid.geniisysRows[objCLM.fla.selectedIndexAdv].generateSw == 'N'){
				disableFlaFields();
			}
		}
	}
	
	function enableFlaFields(){
		enableButton("btnUpdate");
		$("flaTitle").setStyle("width: 470px");
		$("flaHeader").setStyle("width: 470px");
		$("flaFooter").setStyle("width: 470px");
		$("flaTitle").enable();
		$("flaHeader").enable();
		$("flaFooter").enable();
		$("editFlaTitle").show();
		$("editFlaHeader").show();
		$("editFlaFooter").show();
		if (objCLM.objFlaDtlsRows.length > 0){
			$("flaTitle").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[selectedIndex].flaTitle); //added by steven 12/11/2012 "unescapeHTML2"
			$("flaHeader").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[selectedIndex].flaHeader);
			$("flaFooter").value = unescapeHTML2(flaDtlsTableGrid.geniisysRows[selectedIndex].flaFooter);
		}
	}
	
	function disableFlaFields(){
		disableButton("btnUpdate");
		$("flaTitle").setStyle("width: 494px");
		$("flaHeader").setStyle("width: 494px");
		$("flaFooter").setStyle("width: 494px");
		$("flaTitle").disable();
		$("flaHeader").disable();
		$("flaFooter").disable();
		$("flaTitle").value = "";
		$("flaHeader").value = "";
		$("flaFooter").value = "";
		$("editFlaTitle").hide();
		$("editFlaHeader").hide();
		$("editFlaFooter").hide();
	}
	
	$("btnUpdate").observe("click", function(){
		if(changeTag == 1){
			updateFla();
		}else{
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
		}
	});
	
	function updateFla(){
		new Ajax.Request(contextPath+"/GICLAdvsFlaController",{
			parameters:{
				action    : "updateFla",
				claimId   : objCLM.fla.claimId,
				grpSeqNo  : objCLM.fla.grpSeqNo,
				shareType : objCLM.fla.shareType,
				adviceId  : objCLM.fla.adviceId,
				flaSeqNo  : flaDtlsTableGrid.geniisysRows[selectedIndex].flaSeqNo,
				flaTitle  : unescapeHTML2($F("flaTitle")), //added by steven 12/11/2012 "unescapeHTML2"
				flaHeader : unescapeHTML2($F("flaHeader")),
				flaFooter : unescapeHTML2($F("flaFooter"))
			},
			asynchronous: false,
			evalScripts: true,
			onCreate: function(){
				showNotice("Saving, please wait...");
			},
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					changeTag = 0;
					showMessageBox(objCommonMessage.SUCCESS, "S");
					flaDtlsTableGrid._refreshList();
				}else{
					showMessageBox(response.responseText, imgMessage.ERROR);
				}
			}
		});
	}
	
	$("flaTitle").observe("click", function(){
		flaDtlsTableGrid.keys.removeFocus(flaDtlsTableGrid.keys._nCurrentFocus, true);
    	flaDtlsTableGrid.keys.releaseKeys();
	});
	
	$("flaHeader").observe("click", function(){
		flaDtlsTableGrid.keys.removeFocus(flaDtlsTableGrid.keys._nCurrentFocus, true);
    	flaDtlsTableGrid.keys.releaseKeys();
	});
	
	$("flaFooter").observe("click", function(){
		flaDtlsTableGrid.keys.removeFocus(flaDtlsTableGrid.keys._nCurrentFocus, true);
    	flaDtlsTableGrid.keys.releaseKeys();
	});
	
	$("editFlaTitle").observe("click", function(){
		showEditor("flaTitle", 500, false);
		adviceDtlsTableGrid.keys.releaseKeys(); // added by jdiago 03.25.2014 to be able to use enter key in text-editor
	});
	
	$("editFlaHeader").observe("click", function(){
		showEditor("flaHeader", 500, false);
		adviceDtlsTableGrid.keys.releaseKeys(); // added by jdiago 03.25.2014 to be able to use enter key in text-editor
	});
	
	$("editFlaFooter").observe("click", function(){
		showEditor("flaFooter", 2000, false);
		adviceDtlsTableGrid.keys.releaseKeys(); // added by jdiago 03.25.2014 to be able to use enter key in text-editor
	});
	
	$("flaTitle").observe("change", function(){
		changeTag = 1;
	});
	
	$("flaHeader").observe("change", function(){
		changeTag = 1;
	});
	
	$("flaFooter").observe("change", function(){
		changeTag = 1;
	});
	
</script>