<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%
	response.setHeader("Cache-Control", "no-chache");
	response.setHeader("Pragma","no-cache");
%>
<jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include>

<div class="sectionDiv" style="border-top: none; width: 99.3%; margin-left: 2px; margin-bottom: 20px;">
	<div style="width: 99.2%;">
		<span class="spanHeader" style="margin-top: 3px;">
			<label style="margin-bottom: 5px; margin-left: 5px;">User Group Details</label>
		</span>
		<label style="margin-left: 150px; margin-top: 2px;">User Group : </label>
		<input type="text" id="userGrp" name="userGrp" style="width: 30px; text-align: right;" readonly="readonly" />
		<input type="text" id="userDesc" name="userDesc" style="width: 230px;" readonly="readonly"  />
		<input type="text" id="grpIssCd" name="grpIssCd" style="width: 30px;" readonly="readonly"  /> 
	</div>
	
	<div style="width: 99.2%; margin-top: 2px;">
		<span style="margin-top: 3px;">
			<label style="margin-bottom: 5px; margin-left: 5px; font-weight: bold;">Current Transactions</label>
		</span>
		<div id="currTranTable" name="currTranTable" align="center" class="sectionDiv tableContainer" >
			<div id="transactionHeader" name="transactionHeader" class="tableHeader" style="width: 60%; margin-top: 5px;">
				<label style="text-align: right; margin-left: 65px; width: 50px;">Tran Cd</label>
				<label style="text-align: left; margin-left: 40px; width: 200px;">Description</label>
			</div>
			<div tabindex="1" id="transactionContent" name="transactionContent" class="tableContainer" style="width: 60%; height: 93px; overflow: auto;" >
				
			</div>
		</div>
	</div>
	
	<div>
		<input type="button" class="button" id="btnGetTranModules" name="btnGetTranModules" style="width: 105px; margin: 3px; margin-left: 300px;" value="Modules" />
	</div>
	
	<div id="moduleListing"  style="display: none;">
		<span style="margin-top: 3px;">
			<label style="margin-bottom: 5px; margin-left: 5px; font-weight: bold;">Accesible Modules</label>
		</span>
		
		<div id="moduleList" name="moduleList" class="sectionDiv" style="margin-left: 10%; margin-top: 10px; margin-bottom: 10px; width: 80%;">
			<div id="moduleHeader" name="moduleHeader" class="tableHeader" style="width: 100%;">
				<label style="text-align: left; margin-left: 40px; width: 80px;">Module ID</label>
				<label style="text-align: left; margin-left: 40px; width: 250px;">Description</label>
				<label style="text-align: left; margin-left: 40px; width: 80px;">Access Tag</label>
			</div>
			<div tabindex="2" id="moduleContent" name="moduleContent" class="tableContainer" style="width: 100%; height: 93px; overflow: auto;">
				
			</div>
		</div>
	</div>
	
	<div style="width: 99.2%; margin-top: 2px;">
		<span style="margin-top: 3px;">
			<label style="margin-bottom: 5px; margin-left: 5px; font-weight: bold;">Current Issue Sources</label>
		</span>
		
		<div id="currIssCdsTable" name="currIssCdsTable" align="center" class="sectionDiv tableContainer" >
			<div id="issCdHeader" name="issCdHeader" class="tableHeader" style="width: 60%; margin-top: 5px;">
				<label style="text-align: right; margin-left: 57px; width: 60px;">Issue Cd</label>
				<label style="text-align: left; margin-left: 39px; width: 200px;">Description</label>
			</div>
			<div tabindex="3" id="issCdContent" name="issCdContent" class="tableContainer" style="width: 60%; height: 93px; overflow: auto;">
				
			</div>
		</div>
	</div>
	
	<div style="width: 99.2%; margin-top: 2px; margin-bottom: 20px;">
		<span style="margin-top: 3px;">
			<label style="margin-bottom: 5px; margin-left: 5px; font-weight: bold;">Current Lines of Business</label>
		</span>
		
		<div id="currLinesOfBusinessTable" name="currLinesOfBusinessTable" align="center" class="sectionDiv tableContainer" >
			<div id="linesOfBusinessHeader" name="linesOfBusinessHeader" class="tableHeader" style="width: 60%; margin-top: 5px;">
				<label style="text-align: right; margin-left: 65px; width: 50px;">Line Cd</label>
				<label style="text-align: left; margin-left: 40px; width: 200px;">Description</label>
			</div>
			<div tabindex="4" id="linesOfBusinessContent" name="linesOfBusinessContent" class="tableContainer" style="width: 60%; height: 93px; overflow: auto;">
				
			</div>
		</div>
	</div>
</div>	
	
<script type="text/javascript">
	var objGrpAccess = new Object();
	objGrpAccess = eval((('(' + '${grpAccessParams}' + ')').replace(/&#039;/g, "'")));
	objUserGrpHdr = objGrpAccess.userGrpHdr;
	objUserGrpTran = objGrpAccess.userGroupTransactions;
	objIssSources = objGrpAccess.grpIssSources;
	objCurLines = objGrpAccess.grpCurLines;
	objModules = objGrpAccess.grpModules;

	fillUserGroupAccessTable();
	addScrollEvent();

	function fillUserGroupAccessTable(){
		fillUserGrpHdr();
		fillUserTransactions();
		fillIssCds();
		fillLines();
	}

	function fillUserGrpHdr(){
		$("userGrp").value = objUserGrpHdr.userGrp;
		$("userDesc").value = objUserGrpHdr.userGrpDesc;
		$("grpIssCd").value = objUserGrpHdr.grpIssCd;
	}

	function fillUserTransactions(){
		var content = "";
		for (var i = 0; i < objUserGrpTran.length; i++){
			var tranDiv = new Element("div");
			content = '<label style="text-align: right; margin-left: 65px; width: 50px;">' + objUserGrpTran[i].tranCd + '</label>' +
					  '<label style="text-align: left; margin-left: 40px; width: 200px;">' + objUserGrpTran[i].tranDesc +  '</label>';
			tranDiv.addClassName("tableRow");
			tranDiv.setAttribute("id", objUserGrpTran[i].tranCd);
			tranDiv.setAttribute("name", "tranRow");
			tranDiv.update(content);
			$("transactionContent").insert({bottom : tranDiv});
			fillClasses(tranDiv, "tranRow", filterTranDtl, clearTranDtls);
		}
	}

	function fillIssCds(){
		var content = "";
		for (var i = 0; i < objIssSources.length; i++){
			var issDiv = new Element("div");
			content = '<label style="text-align: right; margin-left: 57px; width: 60px;">' + objIssSources[i].issCd + '</label>' +
					  '<label style="text-align: left; margin-left: 39px; width: 200px;">' + objIssSources[i].issName +  '</label>';
			issDiv.addClassName("tableRow");
			issDiv.setAttribute("id", objIssSources[i].issCd);
			issDiv.setAttribute("name", "issRow");
			issDiv.setAttribute("tranCd", objIssSources[i].tranCd);
			issDiv.update(content);
			$("issCdContent").insert({bottom : issDiv});
			issDiv.hide();
			fillClasses(issDiv, "issRow", filterIssDtl, clearIssDtls);
		}
	}

	function fillLines(){
		var content = "";
		for (var i = 0; i < objCurLines.length; i++){
			var lineDiv = new Element("div");
			content = '<label style="text-align: right; margin-left: 57px; width: 60px;">' + objCurLines[i].lineCd + '</label>' +
					  '<label style="text-align: left; margin-left: 39px; width: 200px;">' + objCurLines[i].lineName +  '</label>';
			lineDiv.addClassName("tableRow");
			lineDiv.setAttribute("id", objCurLines[i].lineCd);
			lineDiv.setAttribute("name", "lineRow");
			lineDiv.setAttribute("tranCd", objCurLines[i].tranCd);
			lineDiv.setAttribute("issCd", objCurLines[i].issCd);
			lineDiv.update(content);
			$("linesOfBusinessContent").insert({bottom : lineDiv});
			lineDiv.hide();
			fillClasses(lineDiv, "lineRow", test, test);
		}
	}

	function fillClasses(div, rowName, onClickFunc, onUnclickFunc){
		div.observe("mouseover", function(){
			div.addClassName("lightblue");
		});

		div.observe("mouseout", function(){
			div.removeClassName("lightblue");
		});

		div.observe("click", function(){
			div.toggleClassName("selectedRow");
			if (div.hasClassName("selectedRow")){
				$$("div[name='"+rowName+"']").each(function (row){
					if (row.id != div.id){
						row.removeClassName("selectedRow");
					}
				});
				onClickFunc(div.id);
			} else{
				onUnclickFunc();
			}
		});
	}

	function clearTranDtls(){
		$$("div[name='moduleRow'], div[name='issRow'], div[name='lineRow']").each(function (row){
			row.hide();
		});
		$("moduleListing").hide();
	}

	function clearIssDtls(){
		$$("div[name='lineRow']").each(function (row){
			row.hide();
		});
	}

	function filterTranDtl(id){
		$$("div[name='issRow']").each(function (row){
			if (row.getAttribute("tranCd") == id){
				row.show();
			} else {
				row.hide();
			}
		});
		clearIssDtls();
		$("moduleContent").innerHTML = "";
		populateModuleList(id);
	}	

	function filterIssDtl(id){
		var tranCd = "";
		$$("div[name='tranRow']").each(function (tran){
			if (tran.hasClassName("selectedRow")){
				tranCd = tran.id;
			}
		});
		$$("div[name='lineRow']").each(function (row){
			if (row.getAttribute("issCd") == id && row.getAttribute("tranCd") == tranCd){
				row.show();
			} else{
				row.hide();
			}
		});
	}

	//wag galawin!!! -_+
	function test(id){
		
	}

	$("btnGetTranModules").observe("click", function () {
		Effect.toggle("moduleListing", "blind", {duration: .3});
	});

	function populateModuleList(tranCd){
		for (var i = 0; i < objModules.length; i++){
			if (objModules[i].tranCd == tranCd){
				var moduleDiv = new Element("div");
				var moduleDesc = objModules[i].moduleDesc.truncate(30, "...");
				var accessTag = objModules[i].accessTag == "" || objModules[i].accessTag == null ? "" : objModules[i].accessTag; 
				content = '<label style="text-align: left; margin-left: 40px; width: 80px;">' + objModules[i].moduleId + '</label>' +
						  '<label style="text-align: left; margin-left: 40px; width: 220px;" title="'+ objModules[i].moduleDesc +'">' + moduleDesc +'</label>' +
						  '<label style="text-align: left; margin-left: 40px; width: 80px;">' + accessTag + '</label>';
				moduleDiv.addClassName("tableRow");
				moduleDiv.setAttribute("id", objModules[i].moduleId);
				moduleDiv.setAttribute("name", "moduleRow");
				moduleDiv.update(content);
				$("moduleContent").insert({bottom : moduleDiv});
				fillClasses(moduleDiv, "moduleRow", test, test);
			} 
		}
	}

	function addScrollEvent(){
		addKeyPressObserve("transactionContent", "tranRow");
		addKeyPressObserve("moduleContent", "moduleRow");
		addKeyPressObserve("issCdContent", "issRow");
		addKeyPressObserve("linesOfBusinessContent", "lineRow");
	}

	function addKeyPressObserve(div, tableRow){
		var rowIndex = -1;
		var rowCount = $$("div[name='" + tableRow + "']").length;
		$(div).observe("keypress", function (evt){
			var keyCode = evt.keyCode;
			if (keyCode == 40 && rowIndex < rowCount-1){
				rowIndex++;
				fireEvent($(div).down("div", rowIndex), "click");
				document.getElementById(div).scrollTop = (((rowCount - 1)*31) - ((rowCount - rowIndex)*31));
			} else if (keyCode == 38 && rowIndex > 0){
				rowIndex--;
				fireEvent($(div).down("div", rowIndex), "click");
				document.getElementById(div).scrollTop = (((rowCount - 1)*31) - ((rowCount - rowIndex)*31));
			}
			
		});

		
	}
</script>