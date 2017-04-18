<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="reassignParEndtMainDiv">
	<div id="reassignParEndtMenuDiv">
		<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="reassignParEndtExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" style="width: 100%; margin-bottom: 1px;" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label title="Principal Signatory Information">PAR Assignment - Endorsement</label>
		</div>
	</div>
	<div id="tableGridSectionDiv" class="sectionDiv" style="height: 370;">
		<div id="reassignParEndtTableGridDiv" style="padding: 10px;">
			<div id="reassignParEndtTableGrid" style="height: 350px; width: 900px;"></div>
		</div>
		<div style="float:left; width: 100%; padding-bottom: 20px; text-align: center;">
			<input id="btnAssignPar" class="button" type="button" style="width: 130px;" value="Assign Par" name="btnAssignPar">
		</div>
	</div>
</div>

<script>

	try{
		setModuleId("GIPIS057");
		setDocumentTitle("PAR Assignment - Endorsement");
		var assdNameTitle="Assured Name";
		var popupDir = "${popupDir}";
		var lineCd=null;
		var issCd=null;
		var underwriter=null;
		var remarksTemp='';
		disableButton("btnAssignPar");
		var vUnderwriter = null;
		var objReassignParEndtArray = [];
		var objReassignParEndt = JSON.parse('${objReassignParEndt}'); 
		initializeChangeTagBehavior(saveReassignParEndt);
		var objGIPIS057 = {};
		objGIPIS057.exitPage = null;
		
	var tableModel = {
			url : contextPath+"/GIPIReassignParEndtController?action=getReassignParEndtListing&refresh=1",
			resetChangeTag: true,
			options: {
				height: '315px',
				width: '900px',
				onCellFocus: function(element, value, x, y, id){
					var obj = reassignParEndtTableGrid.geniisysRows[y];
					lineCd=obj.lineCd;
					issCd=obj.issCd;
					underwriter=obj.underwriter;
					formatAppearance("show", obj);
					selectedRow=y;
					selectedColumn=x;
					remarksTemp=obj.remarks;
					observeChangeTagInTableGrid(reassignParEndtTableGrid);
				},
				onCellBlur: function(element, value, x, y, id) {
					observeChangeTagInTableGrid(reassignParEndtTableGrid);
				},
				onRemoveRowFocus: function(element, value, x, y, id){
					if(x!="7" && selectedColumn==7){
						if(remarksTemp!=$F("mtgInput1_7,"+y)){
							reassignParEndtTableGrid.setValueAt(unescapeHTML2($F("mtgInput1_7,"+y)),7,y);
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
					reassignParEndtTableGrid.keys.removeFocus(reassignParEndtTableGrid.keys._nCurrentFocus, true);
					reassignParEndtTableGrid.keys.releaseKeys();
					if(changeTag == 1){
						showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
								function(){
									saveReassignParEndt();
								}, function(){
									reassignParEndtTableGrid.refresh();
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
						saveReassignParEndt();
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
					altTitle: 'Package', //added by John Daniel SR-5379
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
							var coords = reassignParEndtTableGrid.getCurrentPosition();
							var x = coords[0];
							var y = coords[1];
							var title = "Remarks ("+ reassignParEndtTableGrid.geniisysRows[y].parNo+")";
							showTableGridEditor(reassignParEndtTableGrid, x, y,title, 4000, false);
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
					filterOptionType : 'integerNoNegative',
					filterOption: true
				},
				{
					id: 'parSeqNo',
					width: '0',
					title: 'Par No. - Seq. No.',
					visible: false,
					filterOptionType : 'integerNoNegative',
					filterOption: true
				},
				{
					id: 'quoteSeqNo',
					width: '0',
					title: 'Par No. - Qoute',
					visible: false,
					filterOptionType : 'integerNoNegative',
					filterOption: true
				}
			],
			rows: objReassignParEndt.rows
		};
		reassignParEndtTableGrid = new MyTableGrid(tableModel);
		reassignParEndtTableGrid.pager = objReassignParEndt;
		reassignParEndtTableGrid.render('reassignParEndtTableGrid');
		reassignParEndtTableGrid.afterRender = function(){
															objReassignParEndtArray=reassignParEndtTableGrid.geniisysRows;
															assdNameTitle="Assured Name";
															};
	} catch(e){
		showErrorMessage("reassignParEndtTableGrid", e);
	}

	function formatAppearance(cond,obj) {
		if (cond==="show"){
			obj.lineCd==="SU" ? assdNameTitle="Principal Name": assdNameTitle="Assured Name";
			$('mtgIHC1_4').title=assdNameTitle;
			$('mtgIHC1_4').alt=assdNameTitle;
			$("mtgIHC1_4").innerHTML = assdNameTitle+"&nbsp; <span id='mtgSortIcon1_4' class='"+$('mtgSortIcon1_4').classNames()+"' style='"+$('mtgSortIcon1_4').readAttribute('style')+";'>&nbsp;&nbsp;&nbsp;</span>";
			enableButton("btnAssignPar");
// 			reassignParEndtTableGrid.keys.releaseKeys();
		}else{
			assdNameTitle="Assured Name";
			$('mtgIHC1_4').title=assdNameTitle;
			$('mtgIHC1_4').alt=assdNameTitle;
			$("mtgIHC1_4").innerHTML = assdNameTitle+"&nbsp; <span id='mtgSortIcon1_4' class='"+$('mtgSortIcon1_4').classNames()+"' style='"+$('mtgSortIcon1_4').readAttribute('style')+";'>&nbsp;&nbsp;&nbsp;</span>";
			disableButton("btnAssignPar");
			reassignParEndtTableGrid.keys.releaseKeys();
		}
	}
	
	function setReassignObject(index) {
		try {
			var obj = new Object();
			obj.parNo			=	objReassignParEndtArray[index].parNo;
			obj.parId			=	objReassignParEndtArray[index].parId;
			obj.packParId 		=	objReassignParEndtArray[index].packParId;
			obj.lineCd 			=	objReassignParEndtArray[index].lineCd;
			obj.issCd 			=	objReassignParEndtArray[index].issCd;
			obj.parYY 			=	objReassignParEndtArray[index].parYY;
			obj.parSeqNo 		=	objReassignParEndtArray[index].parSeqNo;
			obj.quoteSeqNo		=	objReassignParEndtArray[index].quoteSeqNo;
			obj.assdNo			=	objReassignParEndtArray[index].assdNo;
			obj.assignSw		=	objReassignParEndtArray[index].assignSw;
			obj.underwriter		=	vUnderwriter;
			obj.remarks			=	objReassignParEndtArray[index].remarks;
			obj.parStatus		=	objReassignParEndtArray[index].parStatus;
			obj.parType			=	objReassignParEndtArray[index].parType;
			obj.assdName		=	objReassignParEndtArray[index].assdName;
			obj.parstatDate		=	objReassignParEndtArray[index].parstatDate;
			obj.packPolFlag		=	objReassignParEndtArray[index].packPolFlag;
			obj.tbgPackPolFlag  =   objReassignParEndtArray[index].tbgPackPolFlag; //marco - 04.11.2013 - for packPolFlag checkbox
			return obj;
		} catch (e) {
			showErrorMessage("setReassignObject",e);
		}
	}
	
//	 function to update record	
	function updateReassignParEndt() {
		var newObj  = setReassignObject(selectedRow);
		for(var i = 0; i<objReassignParEndtArray.length; i++){
			if ((objReassignParEndtArray[i].parNo == newObj.parNo)&&(objReassignParEndtArray[i].recordStatus != -1)){
				newObj.recordStatus = 1;
				newObj.cond = 1;
				objReassignParEndtArray.splice(i, 1, newObj);
				reassignParEndtTableGrid.updateVisibleRowOnly(newObj, reassignParEndtTableGrid.getCurrentPosition()[1]);
				changeTag = 1;
				formatAppearance();
			}
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
/* 						if(nvl(rows.allUserSw, 'N') == 'N' && nvl(rows.misSw, 'N') == 'N' && nvl(rows.mgrSw, 'N') == 'N'){ // Dren 11.05.2015 SR-0019528 : Allow reassign when either ALL USER, MIS, MGR switch is on.			
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
	
	function showReassignParEndtLOV(lineCd, issCd) {
		LOV.show({
			controller : "UnderwritingLOVController",
			urlParameters : {
				action : "getReassignParEndtLOV",
				lineCd : lineCd,
				issCd : issCd
			},
			title : "Valid Values for Underwriter",
			width : 400,
			height : 410,
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'userId',
				title : 'Underwriter',
				align : 'left',
				width : '140px'
			}, {
				id : 'userGrp',
				title : 'User Grp.',
				align : 'right',
				width : '70px'
			}, {
				id : 'userName',
				title : 'User Name',
				align : 'left',
				width : '150px'
			} ],
			draggable : true,
			onSelect : function(row) {
				vUnderwriter = row.userId;
				updateReassignParEndt();
			}
		});
	}
	
//	 function to save record	
	function saveReassignParEndt() {
		try{
			var objParameters = new Object();
			var modifiedRemarks = reassignParEndtTableGrid.getModifiedRows();
			for ( var i = 0; i < modifiedRemarks.length; i++) {
					for ( var j = 0; j < objReassignParEndtArray.length; j++) {
						if (modifiedRemarks[i].parNo === objReassignParEndtArray[j].parNo){
							objReassignParEndtArray[j].remarks = modifiedRemarks[i].remarks;
							objReassignParEndtArray[j].recordStatus = 1;
					}
				}
			}
			objParameters.setReassignParEndt = getAddedAndModifiedJSONObjects(objReassignParEndtArray);
			new Ajax.Request(contextPath+"/GIPIReassignParEndtController?action=saveReassignParEndt",{
				method: "POST",
				asynchronous: false,
				evalScripts: true,
				parameters:{
					params: JSON.stringify(objParameters)
				},
				onCreate: function(){
					showNotice("Saving Re-assign Par Endorsement, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					changeTag = 0;
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response) ){
						var obj = eval(response.responseText);
						for ( var i = 0; i < obj.length; i++) {
							if (obj[i].msg != null && obj[i].msg != "") {
								$("geniisysAppletUtil").sendMessage(popupDir, obj[i].underwriter, obj[i].msg);
							}
						}
						showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
							if(objGIPIS057.exitPage != null) {
								objGIPIS057.exitPage();
							} else {
								reassignParEndtTableGrid._refreshList();
								reassignParEndtTableGrid.keys.releaseKeys();
							}
						});
						changeTag = 0;
					}	
				}
			});
		} catch(e){
			showErrorMessage("saveReassignParEndt", e);
		}
	}

	function exitReassignParEndt() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main" , null);
	}
	
	/* observe */
	try {
		$("btnAssignPar").observe("click",function(){
			if (checkUser()) {  //commented out by reymon 12062013 for 14548  //uncomment-out by steven 07.11.2014
				showReassignParEndtLOV(lineCd, issCd);
			}
		});
		
		$("reassignParEndtExit").stopObserving("click"); 
		$("reassignParEndtExit").observe("click", function(){
			reassignParEndtTableGrid.keys.removeFocus(reassignParEndtTableGrid.keys._nCurrentFocus, true);
			reassignParEndtTableGrid.keys.releaseKeys();
			if(changeTag == 1){
				showConfirmBox4("CONFIRMATION", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
						function(){
						    objGIPIS057.exitPage = exitReassignParEndt;
							saveReassignParEndt();
						}, function(){
							exitReassignParEndt();
							changeTag = 0;
						}, "");
			}else{
				exitReassignParEndt();
			}
		});
	} catch (e) {
		showErrorMessage("reassignParEndt.jsp observe", e);
	}
</script>