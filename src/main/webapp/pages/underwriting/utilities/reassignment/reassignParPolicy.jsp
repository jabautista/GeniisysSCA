<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reassignParPolicyMainDiv" changeTagAttr='true'>
	<div id="reassignParPolicyMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="reassignParPolicyExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" style="width: 100%; margin-bottom: 1px;" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label title="Principal Signatory Information">PAR Assignment - Policy</label>
		</div>
	</div>
	<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="reassignParPolicyTableGridDiv" style="padding: 10px;">
			<div id="reassignParPolicyTableGrid" style="height: 350px; width: 900px;"></div>
		</div>
		<div style="float:left; width: 100%; padding-bottom: 20px; text-align: center;">
			<input id="btnAssignPar" class="button" type="button" style="width: 130px;" value="Assign Par" name="btnAssignPar">
		</div>
	</div>
</div>

<script>
	setModuleId("GIPIS051");
	setDocumentTitle("PAR Assignment - Policy");
	var assdNameTitle="Assured Name";
	var lineCd='';
	var issCd='';
	var remarksTemp='';
	disableButton("btnAssignPar");
	var selectedRow=-1;
	var selectedColumn=-1;
	objUW.hidObjGIPIS051 = {};
// 	initializeChangeTagBehavior(saveReassignParPolicy);
	
	try{
		var objReassignParPolicyArray = [];
		var objReassignParPolicy = new Object();
		objReassignParPolicy.objReassignParPolicyTableGrid = JSON.parse('${objReassignParPolicy}'.replace(/\\/g, '\\\\')); 
		objReassignParPolicy.reassignParPolicy = objReassignParPolicy.objReassignParPolicyTableGrid.rows || [];
		
	var tableModel = {
			url : contextPath+"/GIPIReassignParPolicyController?action=showReassignParPolicyListing",
			resetChangeTag: true,
			options: {
				height: '315px',
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					var obj = reassignParPolicyTableGrid.geniisysRows[y];
					lineCd=obj.lineCd;
					issCd=obj.issCd;
					formatAppearance("show", obj);
					selectedRow=y;
					selectedColumn=x;
					remarksTemp=obj.remarks;
					observeChangeTagInTableGrid(reassignParPolicyTableGrid);
				},
				onCellBlur: function(element, value, x, y, id) {
					observeChangeTagInTableGrid(reassignParPolicyTableGrid);
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					if(x!="7" && selectedColumn==7){
						if(remarksTemp!=$F("mtgInput1_7,"+y)){
							reassignParPolicyTableGrid.setValueAt(unescapeHTML2($F("mtgInput1_7,"+y)),7,y);
							$("mtgIC1_7,"+y).setStyle({
									width: '304px',
									height: '24px',
									padding: '3px',
									position: 'relative', 
									border: '0px none',
									margin: '-2px 0px 0px'
								});
						}else{
							$("mtgIC1_7,"+y).innerHTML=remarksTemp;
							$("mtgIC1_7,"+y).setStyle({	
								width:'324px',
								height:'18px',
								padding:'3px'
							});
						}
					}
					formatAppearance();
				},
				onSort: function() {
					formatAppearance();
				},
				beforeSort: function(){
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveReassignParPolicy();
								}, function(){
									reassignParPolicyTableGrid.refresh();
									changeTag = 0;
								}, "");
						return false;
					}else{
						return true;
					}
				},
				postPager: function () {
					formatAppearance();
				},
				toolbar : {
					elements : [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN,MyTableGrid.SAVE_BTN],
					onRefresh: function(){
						formatAppearance();
					},
					onFilter: function(){
						formatAppearance();
					},onSave: function(){
						saveReassignParPolicy();
					}
				}
			},
			columnModel: [
	      		{
					id: 'recordStatus',
					width: '0',
					visible: false
				},
				{
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'tbgPackPolFlag',
					title: 'P',
					altTitle: 'Package', //added by John Daniel SR-5378
					width: '25px',
					align: 'center',
					titleAlign:'center',
					editable: false,
					editor:	 'checkbox',
					sortable: false
				},
				{
					id: 'parNo',
					title: 'Par No.',
					width: '150px',
					align: 'left'
				},
				{
					id: 'assdName',
					title: 'Assured Name',
					width: '180px',
					align: 'left',
					filterOption: true
				},
				{
					id: 'underwriter',
					title: 'User ID',
					width: '80px',
					align: 'left',
					filterOption: true
				},
				{
					id: 'parstatDate',
					title: 'Create Date',
					titleAlign: 'center',
					width: '100px',
					align: 'center',
					renderer: function(value){
						return dateFormat(value,"mm-dd-yyyy");
					}
				},
				{
					id: 'remarks',
					title: 'Remarks',
					width: '330px',
					align: 'left',
					visible: true,
					filterOption: false,
					editable: true,
					maxlength: 4000,
					editor: new MyTableGrid.EditorInput({
						onClick: function(){
							var coords = reassignParPolicyTableGrid.getCurrentPosition();
							var x = coords[0];
							var y = coords[1];
							var title = "Remarks ("+ reassignParPolicyTableGrid.geniisysRows[y].parNo+")";
							showTableGridEditor(reassignParPolicyTableGrid, x, y,title, 4000, false);
							$("btnSubmitText").observe("click", function () {
								selectedColumn=-1;
							});
							}
					})
				},
				{
					id: 'lineCd',
					width: '0',
					title: 'Par No. - Line Cd',
					visible: false,
					filterOption: true
				},
				{
					id: 'issCd',
					width: '0',
					title: 'Par No. - Source',
					visible: false,
					filterOption: true
				},
				{
					id: 'parYY',
					width: '0',
					title: 'Par No. - Year',
					visible: false,
					filterOption: true
				},
				{
					id: 'parSeqNo',
					width: '0',
					title: 'Par No. - Seq. No.',
					visible: false,
					filterOption: true
				},
				{
					id: 'quoteSeqNo',
					width: '0',
					title: 'Par No. - Qoute',
					visible: false,
					filterOption: true
				}
			],
			rows: objReassignParPolicy.reassignParPolicy
		};
		
		reassignParPolicyTableGrid = new MyTableGrid(tableModel);
		reassignParPolicyTableGrid.pager = objReassignParPolicy.objReassignParPolicyTableGrid;
		reassignParPolicyTableGrid.render('reassignParPolicyTableGrid');
		reassignParPolicyTableGrid.afterRender = function(){
															objReassignParPolicyArray=reassignParPolicyTableGrid.geniisysRows;
															assdNameTitle="Assured Name";
															};
	} catch(e){
		showErrorMessage("reassignParPolicyTableGrid", e);
	}
	
	
	
	
	
	function exitReassignParPolicy() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	}

	function formatAppearance(cond,obj) {
		if (cond==="show"){
			obj.lineCd==="SU" ? assdNameTitle="Principal Name": assdNameTitle="Assured Name";
			$('mtgIHC1_4').title=assdNameTitle;
			$('mtgIHC1_4').alt=assdNameTitle;
			$("mtgIHC1_4").innerHTML = assdNameTitle+"&nbsp; <span id='mtgSortIcon1_4' class='"+$('mtgSortIcon1_4').classNames()+"' style='"+$('mtgSortIcon1_4').readAttribute('style')+";'>&nbsp;&nbsp;&nbsp;</span>";
			enableButton("btnAssignPar");
		}else{
			assdNameTitle="Assured Name";
			$('mtgIHC1_4').title=assdNameTitle;
			$('mtgIHC1_4').alt=assdNameTitle;
			$("mtgIHC1_4").innerHTML = assdNameTitle+"&nbsp; <span id='mtgSortIcon1_4' class='"+$('mtgSortIcon1_4').classNames()+"' style='"+$('mtgSortIcon1_4').readAttribute('style')+";'>&nbsp;&nbsp;&nbsp;</span>";
			disableButton("btnAssignPar");
			reassignParPolicyTableGrid.keys.releaseKeys();
		}
	}
	
	function setReassignObject(index) {
		try {
			var obj = new Object();
			obj.parNo			=	objReassignParPolicyArray[index].parNo;
			obj.parId			=	objReassignParPolicyArray[index].parId;
			obj.packParId 		=	objReassignParPolicyArray[index].packParId;
			obj.lineCd 			=	objReassignParPolicyArray[index].lineCd;
			obj.issCd 			=	objReassignParPolicyArray[index].issCd;
			obj.parYY 			=	objReassignParPolicyArray[index].parYY;
			obj.parSeqNo 		=	objReassignParPolicyArray[index].parSeqNo;
			obj.quoteSeqNo		=	objReassignParPolicyArray[index].quoteSeqNo;
			obj.assdNo			=	objReassignParPolicyArray[index].assdNo;
			obj.assignSw		=	objReassignParPolicyArray[index].assignSw;
			obj.underwriter		=	objUW.hidObjGIPIS051.vUnderwriter;
			obj.remarks			=	objReassignParPolicyArray[index].remarks;
			obj.parStatus		=	objReassignParPolicyArray[index].parStatus;
			obj.parType			=	objReassignParPolicyArray[index].parType;
			obj.assdName		=	objReassignParPolicyArray[index].assdName;
			obj.parstatDate		=	objReassignParPolicyArray[index].parstatDate;
			obj.packPolFlag		=	objReassignParPolicyArray[index].packPolFlag;
			obj.tbgPackPolFlag  =   objReassignParPolicyArray[index].tbgPackPolFlag; //marco - 04.11.2013 - for packPolFlag checkbox
			return obj;
		} catch (e) {
			showErrorMessage("setReassignObject",e);
		}
	}
	
//	 function to update record	
	function updateReassignParPolicy() {
		var newObj  = setReassignObject(selectedRow);
		for(var i = 0; i<objReassignParPolicyArray.length; i++){
			if ((objReassignParPolicyArray[i].parNo == newObj.parNo)&&(objReassignParPolicyArray[i].recordStatus != -1)){
				newObj.recordStatus = 1;
				newObj.cond = 1;
				objReassignParPolicyArray.splice(i, 1, newObj);
				reassignParPolicyTableGrid.updateVisibleRowOnly(newObj, reassignParPolicyTableGrid.getCurrentPosition()[1]);
				formatAppearance();
			}
		}
	}
	objUW.hidObjGIPIS051.updateReassignParPolicy=updateReassignParPolicy;
	
// 	 function to save record	
	function saveReassignParPolicy() {
		try{
			var objParameters = new Object();
			var modifiedRemarks = reassignParPolicyTableGrid.getModifiedRows();
			for ( var i = 0; i < modifiedRemarks.length; i++) {
					for ( var j = 0; j < objReassignParPolicyArray.length; j++) {
						if (modifiedRemarks[i].parNo === objReassignParPolicyArray[j].parNo){
							objReassignParPolicyArray[j].remarks = modifiedRemarks[i].remarks;
							objReassignParPolicyArray[j].recordStatus = 1;
					}
				}
			}
			objParameters.setReassignParPolicy = getAddedAndModifiedJSONObjects(objReassignParPolicyArray);
			new Ajax.Request(contextPath+"/GIPIReassignParPolicyController?action=saveReassignParPolicy",{
				method: "POST",
				asynchronous: true,
				parameters:{
					param: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving Re-assign Par Policy, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					changeTag = 0;
					if(checkErrorOnResponse(response)){
						//showMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS);
						//reassignParPolicyTableGrid.refresh();
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, showReassignParPolicyListing);
					}
				}
			});
		} catch(e){
			showErrorMessage("saveReassignParPolicy", e);
		}
	}
	
	function checkUser(){
		try{
			var isValid = true;
			new Ajax.Request(contextPath+"/GIPIReassignParPolicyController?action=checkUser", {
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				onComplete: function(response){
					if(checkErrorOnResponse(response)){
						var json = JSON.parse(response.responseText);
						var rows = [];
						if (json.rows.length > 0) {
							rows = json.rows[0];
						}
//						if(nvl(rows.allUserSw, 'N') == 'Y' && nvl(rows.misSw, 'N') == 'N' && nvl(rows.mgrSw, 'N') == 'N'){ //added nvl by reymon 11132013
/* 						if(nvl(rows.allUserSw, 'N') == 'N' && nvl(rows.misSw, 'N') == 'N' && nvl(rows.mgrSw, 'N') == 'N'){ //added nvl by reymon 11132013 // Dren 11.05.2015 SR-0019528 : Allow reassign when either ALL USER, MIS, MGR switch is on.
							showMessageBox('You are not allowed to assign this PAR to another user unless MIS allows you or you have a Manager permission.','I');
							isValid = false;
						} */ //Dren 12.03.2015 SR-0019528 : Switches will not be considered anymore.
					}
				}
			});
			
			return isValid;
		}catch(e){
			showErrorMessage("checkUser", e);
		}
	}
	
	/* observe */
	$("reassignParPolicyExit").stopObserving("click"); 
	$("reassignParPolicyExit").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveReassignParPolicy();
						exitReassignParPolicy();
					}, function(){
						exitReassignParPolicy();
						changeTag = 0;
					}, "");
		}else{
			exitReassignParPolicy();
		}
	});
	
	$("btnAssignPar").observe("click",function(){
		if(checkUser()){ //added by christian 03/13/2013 --//commented out by robert 03.19.2014  //UNCOMMENT-OUT BY STEVEN 07.11.2014
			showReassignParPolicyLOV(lineCd, issCd);
		}
	});
	
</script>
