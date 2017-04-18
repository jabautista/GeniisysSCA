<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "No-cache");
	response.setHeader("Pragma", "No-cache");
%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>PLA Details</label>
   		<span class="refreshers" style="margin-top: 0;">
   			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
   	</div>
</div>
<div id="plaDetailsSectionDiv" class="sectionDiv">
	<div id="plaDetailsGrid" style="height: 106px; width: 800px; margin: auto; margin-top: 10px; margin-bottom: 35px;"></div>
	<table align="center" style="margin-bottom: 10px;">
		<tr>
			<td class="rightAligned">PLA Title</td>
			<!--removed Text field and replaced by Text Editor by MAC 05/08/2013-->
			<!--<td class="leftAligned"><input type="text" id="txtPlaTitle" name="txtPlaTitle" style="width: 500px;" maxlength="150"></td>-->
			<td class="leftAligned">
				<div style="float:left; width: 506px;" class="withIconDiv">
					<!-- <textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtPlaTitle" name="txtPlaTitle" style="width: 480px;" class="withIcon"> </textarea> -->
					<!-- bonok :: 10.14.2013 :: set limitText to 150 as per SR 342 -->
					<textarea onKeyDown="limitText(this, 150);" onKeyUp="limitText(this, 150);" id="txtPlaTitle" name="txtPlaTitle" style="width: 480px;" class="withIcon"> </textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtPlaTitle" />
				</div>	
			</td>
		</tr>
		<tr>
			<td class="rightAligned">PLA Header</td>
			<!--removed Text field and replaced by Text Editor by MAC 05/08/2013-->
			<!--<td class="leftAligned"><input type="text" id="txtPlaHeader" name="txtPlaHeader" style="width: 500px;" maxlength="150"></td>-->
			<td class="leftAligned">
				<div style="float:left; width: 506px;" class="withIconDiv">
					<!-- <textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtPlaHeader" name="txtPlaHeader" style="width: 480px;" class="withIcon"> </textarea> -->
					<!-- bonok :: 10.14.2013 :: set limitText to 150 as per SR 342 -->
					<textarea onKeyDown="limitText(this,150);" onKeyUp="limitText(this,150);" id="txtPlaHeader" name="txtPlaHeader" style="width: 480px;" class="withIcon"> </textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtPlaHeader" />
				</div>	
			</td>
		</tr>
		<tr>
			<td class="rightAligned">PLA Footer</td>
			<td class="leftAligned">
				<div style="float:left; width: 506px;" class="withIconDiv">
					<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtPlaFooter" name="txtPlaFooter" style="width: 480px;" class="withIcon"> </textarea>
					<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editTxtPlaFooter" />
				</div>	
			</td>
		</tr>
	</table>
	<div class="buttonDiv" id="clmButtonDiv" style="float: left; width: 100%;">
		<table align="center" border="0" style="margin-bottom: 10px; margin-top: 0px;">
			<tr>
				<td><input type="button" class="button" id="btnUpdatePla" name="btnUpdatePla" value="Update" style="width: 80px;"/></td>
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
try{
	initializeAccordion();
	addStyleToInputs();
	initializeAll();
	initializeAllMoneyFields();
	initializeChangeAttribute();
	
	objCLM.plaDetails = JSON.parse('${plaDetails}').rows || [];
	objCLM.plaDetailsGrid = JSON.parse('${plaDetailsTG}');
	objCLM.plaDetailsRows = objCLM.plaDetailsGrid.rows || [];
	
	objCLM.plaDetailsCurrXX = null;
	objCLM.plaDetailsCurrYY = null;
	objCLM.plaDetailsCurrRow = null;
	
	objCLM.plaDetailsTM = {
		url: contextPath+"/GICLAdvsPlaController?action=showPLADetails"+
				"&claimId=" +(objCLM.reserveDetailsRow == null ? "" :nvl(objCLMGlobal.claimId,""))+
				"&grpSeqNo=" +(objCLM.reserveDetailsRow == null ? "" :(objCLM.distDetailsCurrRow != null ? nvl(String(String(objCLM.distDetailsCurrRow.grpSeqNo)),"") :""))+
				"&clmResHistId=" +(objCLM.reserveDetailsRow == null ? "" :nvl(String(objCLM.reserveDetailsRow.clmResHistId),""))+
				"&shareType=" +(objCLM.reserveDetailsRow == null ? "" :(objCLM.distDetailsCurrRow != null ? nvl(String(objCLM.distDetailsCurrRow.shareType),"") :""))+ 
				"&refresh=1",
		options:{
			hideColumnChildTitle: true,
			title: '',
			newRowPosition: 'bottom',
			onCellFocus: function(element, value, x, y, id){
				objCLM.plaDetailsCurrXX = Number(x);
				objCLM.plaDetailsCurrYY = Number(y);
				populatePLA(objCLM.plaDetailsTG.getRow(objCLM.plaDetailsCurrYY));
				objCLM.plaDetailsTG.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
			},
			beforeSort: function(){ //Added by: Jerome Cris 03032015
				if (changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			prePager: function(){
				if (changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
					return false;
				}
			},
			onSort: function(){
				if(changeTag == 1){
					showMessageBox(objCommonMessage.SAVE_CHANGES,"I");
					return false;
				}
			},
			onRemoveRowFocus: function ( x, y, element) {
				objCLM.plaDetailsCurrXX = null;
				objCLM.plaDetailsCurrYY = null;
				populatePLA(null);
				objCLM.plaDetailsTG.keys.releaseKeys(); //used releaseKeys to be able to use Enter key in Text Editor by MAC 05/08/2013
			}
		},
		columnModel: [
			{
			    id: 'recordStatus',
			    title : '&nbsp;P',
             	altTitle: 'Check PLA to be printed',
	            width: '20',
	            visible: true,
	            editor: "checkbox",
	            editable: true,
	            hideSelectAllBox: true,
	            sortable: false
			},
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			},
			{
				id: 'plaId',
				width: '0',
				visible: false
			},
			{
				id: 'claimId',
				width: '0',
				visible: false
			},
			{
				id: 'grpSeqNo',
				width: '0',
				visible: false
			},
			{
				id: 'riCd',
				width: '0',
				visible: false
			},
			{
				id: 'lineCd',
				width: '0',
				visible: false
			},
			{
				id: 'laYy',
				width: '0',
				visible: false
			},
			{
				id: 'plaSeqNo',
				width: '0',
				visible: false
			},
			{
				id: 'userId',
				width: '0',
				visible: false
			},
			{
				id: 'lastUpdate',
				width: '0',
				visible: false
			},
			{
				id: 'shareType',
				width: '0',
				visible: false
			},
			{
				id: 'perilCd',
				width: '0',
				visible: false
			},
			{
				id: 'plaTitle',
				width: '0',
				visible: false
			},
			{
				id: 'plaHeader',
				width: '0',
				visible: false
			},
			{
				id: 'plaFooter',
				width: '0',
				visible: false
			},
			{
				id: 'cpiRecNo',
				width: '0',
				visible: false
			},
			{
				id: 'cpiBranchCd',
				width: '0',
				visible: false
			},
			{
				id: 'itemNo',
				width: '0',
				visible: false
			},
			{
				id: 'cancelTag',
				width: '0',
				visible: false
			},
			{
				id: 'resPlaId',
				width: '0',
				visible: false
			},
			{
				id: 'plaDate',
				width: '0',
				visible: false
			},
			{
				id: 'groupedItemNo',
				width: '0',
				visible: false
			},
			{
				id: 'printSw',
				title: '&nbsp;P',
	            altTitle: 'Print Switch',
	            width: '20',
	            maxlength: 1,
	            editable: false,
	            defaultValue: false,
	            otherValue: false,
	            hideSelectAllBox: true,
	            sortable: false,
	            editor: new MyTableGrid.CellCheckbox({
		            getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";	
	            		}	
	            	}
	            })
			},	
			{
			    id: 'lineCd laYy plaSeqNo',
			    title: 'PLA No.',
			    width : 148,
			    children : [
		            {
		                /* id : 'lineCode', */
		                id : 'lineCd', // added by j.diago 04.14.2014
		                title: 'Line Code',
		                width: 30,
		                filterOption: true
		            },
		            {
		                id : 'laYy', 
		                title: 'LA Year',
		                width: 30,
		                type: "number",
		                align: "right",
		                renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(value,2);
						}
		            },
		            {
		                id : 'plaSeqNo',
		                title: 'PLA Sequence No.',
		                width: 88,
		                type: "number",
		                align: "right",
		                renderer: function (value){
							return nvl(value,'') == '' ? '' :formatNumberDigits(value,12);
						}
		            }
		         ]
			},
			{
				id: 'dspRiName',
				title: 'Reinsurer',
				width: '230',
				visible: true
			},
			{
				id: 'lossShrAmt',
				title: 'Loss Share Amount',
				width: '160',
				titleAlign: 'right',
				type: 'number',
				geniisysClass: 'money',
				visible: true
			},
			{
				id: 'expShrAmt',
				title: 'Expense Share Amount',
				width: '160',
				titleAlign: 'right',
				type: 'number',
				geniisysClass: 'money',
				visible: true
			} 
		],
		resetChangeTag: true,
		rows: objCLM.plaDetailsRows,
		id: 3
	};
	
	objCLM.plaDetailsTG = new MyTableGrid(objCLM.plaDetailsTM);
	objCLM.plaDetailsTG.pager = objCLM.plaDetailsGrid;
	objCLM.plaDetailsTG._mtgId = 3;
	objCLM.plaDetailsTG.afterRender = function(){
		if (objCLM.plaDetailsTG.rows.length > 0){
			objCLM.plaDetailsCurrYY = Number(0);
			objCLM.plaDetailsTG.selectRow('0');
			objCLM.plaDetailsCurrRow = objCLM.plaDetailsTG.getRow(objCLM.plaDetailsCurrYY);
			populatePLA(objCLM.plaDetailsCurrRow);
		}else{
			populatePLA(null);
		}
	};	
	objCLM.plaDetailsTG.render('plaDetailsGrid');
	
	function populatePLA(obj){
		try{
			objCLM.plaDetailsCurrRow 		= obj;
			$("txtPlaTitle").value 			= obj != null ? unescapeHTML2(obj.plaTitle) :null;
			$("txtPlaHeader").value 		= obj != null ? unescapeHTML2(obj.plaHeader) :null;
			$("txtPlaFooter").value 		= obj != null ? unescapeHTML2(obj.plaFooter) :null;
			$("txtPlaTitle").readOnly 		= obj != null ? false :true;
			$("txtPlaHeader").readOnly 		= obj != null ? false :true;
			$("txtPlaFooter").readOnly 		= obj != null ? false :true;
			
			if (obj != null){
				enableButton("btnUpdatePla");
				//enable PLA Title, Header, and Footer if PLA record is selected by MAC 05/09/2013.
				$("txtPlaTitle").setStyle("width: 480px");
				$("txtPlaHeader").setStyle("width: 480px");
				$("txtPlaFooter").setStyle("width: 480px");
				$("txtPlaTitle").enable();
				$("txtPlaHeader").enable();
				$("txtPlaFooter").enable();
				$("editTxtPlaTitle").show();
				$("editTxtPlaHeader").show();
				$("editTxtPlaFooter").show();
			}else{
				disableButton("btnUpdatePla");
				objCLM.plaDetailsTG.unselectRows();
				//disable PLA Title, Header, and Footer if no PLA record is selected by MAC 05/09/2013.
				$("txtPlaTitle").setStyle("width: 500px");
				$("txtPlaHeader").setStyle("width: 500px");
				$("txtPlaFooter").setStyle("width: 500px");
				$("txtPlaTitle").disable();
				$("txtPlaHeader").disable();
				$("txtPlaFooter").disable();
				$("editTxtPlaTitle").hide();
				$("editTxtPlaHeader").hide();
				$("editTxtPlaFooter").hide();
			}	
			
			if (objCLM.reserveDetailsRow != null){
				if (nvl(objCLM.reserveDetailsRow.giclReserveRidsExist,null) == null){
					disableButton("btnCancelPLA");
				}else{
					enableButton("btnCancelPLA");
				}	
			}
			objCLM.plaDetailsTG.keys.releaseKeys();
			observeChangeTagInTableGrid(objCLM.plaDetailsTG);
		}catch(e){
			showErrorMessage("populatePLA", e);	
		}	
	}	
	
	//Observe Update button
	$("btnUpdatePla").observe("click", function(){
		var y = nvl(String(objCLM.plaDetailsCurrYY),null);
		if (y != null){
			objCLM.plaDetailsTG.setValueAt(escapeHTML2($F("txtPlaTitle")),objCLM.plaDetailsTG.getIndexOf('plaTitle'), y, true);
			objCLM.plaDetailsTG.setValueAt(escapeHTML2($F("txtPlaHeader")),objCLM.plaDetailsTG.getIndexOf('plaHeader'), y, true);
			objCLM.plaDetailsTG.setValueAt(escapeHTML2($F("txtPlaFooter")),objCLM.plaDetailsTG.getIndexOf('plaFooter'), y, true);
			populatePLA(null);
		}
	});
	
	//show Text Editor by MAC 05/08/2013
	/* modified by j.diago 04.14.2014
	** 1. limit editor from 2000 to 150
	** 2. Change showEditor to showOverlayEditor to always send limit message on top of text editor.   
	*/
	$("editTxtPlaTitle").observe("click", function () {
		//showEditor("txtPlaTitle", 150);
		showOverlayEditor("txtPlaTitle", 150, $("txtPlaTitle").hasAttribute("readonly"));
	});
	
	//show Text Editor by MAC 05/08/2013
	/* modified by j.diago 04.14.2014
	** 1. limit editor from 2000 to 150
	** 2. Change showEditor to showOverlayEditor to always send limit message on top of text editor.   
	*/
	$("editTxtPlaHeader").observe("click", function () {
		//showEditor("txtPlaHeader", 150);
		showOverlayEditor("txtPlaHeader", 150, $("txtPlaHeader").hasAttribute("readonly"));
	});
	
	/* modified by j.diago 04.14.2014
	** 1. Change showEditor to showOverlayEditor to always send limit message on top of text editor.
	*/
	$("editTxtPlaFooter").observe("click", function () {
		//showEditor("txtPlaFooter", 2000);
		showOverlayEditor("txtPlaFooter", 2000, $("txtPlaFooter").hasAttribute("readonly"));
	});
	
	hideNotice("");
}catch(e){
	showErrorMessage("PLA - PLA Details page.", e);
}
</script>	