<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c"  uri="/WEB-INF/tld/c.tld" %>
<%
	request.setAttribute("contextPath", request.getContextPath());
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<%-- <jsp:include page="/pages/common/utils/overlayTitleHeader.jsp"></jsp:include> --%>
<div style="float: left; width: 100%;">
	<div id="addtlInfoContainerDiv" style="margin-left: 5px;">
		<div id="forPolicyReportDiv" class="sectionDiv" style="width: 385px; float: left; margin-top: 10px; padding-left: 10px; padding-right: 15px; padding-bottom: 10px;">
			<span style="display: block; width: 200px; margin: 10px 0 10px 10px; float: left;">
				<label>For the Policy Report</label>
			</span>
			<div id="forPolicyFieldsDiv" style="float: left;">	
				<c:choose>
					<c:when test="${sublineCd eq 'G28' or sublineCd eq 'G(28)'}">
						<jsp:include page="subPages/policyReportG28.jsp"></jsp:include>
					</c:when>
					<c:when test="${sublineCd eq 'G15' or sublineCd eq 'G(15)' or sublineCd eq 'G14' or sublineCd eq 'G(14)'}">
						<jsp:include page="subPages/policyReportG15.jsp"></jsp:include>
					</c:when>
					<c:when test="${sublineCd eq 'JCL5' or sublineCd eq 'JCL(5)'}">
						<jsp:include page="subPages/policyReportJCL5.jsp"></jsp:include>
					</c:when>
					<c:when test="${sublineCd eq 'JCL06' or sublineCd eq 'JCL(06)' or sublineCd eq 'JCL6' or sublineCd eq 'JCL(6)'}">
						<jsp:include page="subPages/policyReportJCL06.jsp"></jsp:include>
					</c:when>
					<c:when test="${sublineCd eq 'JCL13' or sublineCd eq 'JCL(13)'}">
						<jsp:include page="subPages/policyReportJCL13.jsp"></jsp:include>
					</c:when>
					<c:when test="${sublineCd eq 'JCL15' or sublineCd eq 'JCL(15)'}">
						<jsp:include page="subPages/policyReportS1.jsp"></jsp:include>
					</c:when>
				</c:choose>
			</div>
		</div>		
		<div id="forIndemnityReportDiv" class="sectionDiv" style="width: 385px; height: 290px; float: left; margin-top: 10px; padding: 10px;">
			<span style="display: block; width: 200px; margin: 0 0 10px 0; float: left;">
				<label>For the Indemnity Report</label>
			</span>
			<table align="center" style="margin-top: 7px;">
				<tr>
					<td class="rightAligned" width="150px">Period </td>
					<td class="leftAligned">
						<input type="text" id="txtPeriod" name="txtPeriod" style="margin-left: 10px; width: 200px;" value="${period}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Signed in the presence of</td>
					<td class="leftAligned">
						<input type="text" id="txtSignA" name="txtSignA" style="margin-left: 10px; width: 200px;" value="${signA}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px"></td>
					<td class="leftAligned">
						<input type="text" id="txtSignB" name="txtSignB" style="margin-left: 10px; width: 200px;" value="${signB}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Acknowledgment Location</td>
					<td class="leftAligned">
						<input type="text" id="txtAckLoc" name="txtAckLoc" style="margin-left: 10px; width: 200px;" value="${ackLoc}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Acknowledgment Date</td>
					<td class="leftAligned">
						<div style="float:left; border: solid 1px gray; width: 206px; height: 21px; margin-left: 10px;">
				    		<input style="width: 178px; height: 13px; border: none;" id="txtAckDate" name="txtAckDate" type="text" value="${ackDate}" readonly="readonly"/>
				    		<img id="hrefAckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAckDate'),this, null);" alt="txtAckDate" class="hover" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Doc. No. </td>
					<td class="leftAligned">
						<input type="text" id="txtDocNo" name="txtDocNo" style="margin-left: 10px; width: 200px;" value="${docNo}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Page No. </td>
					<td class="leftAligned">
						<input type="text" id="txtPageNo" name="txtPageNo" style="margin-left: 10px; width: 200px;" value="${pageNo}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Book No. </td>
					<td class="leftAligned">
						<input type="text" id="txtBookNo" name="txtBookNo" style="margin-left: 10px; width: 200px;" value="${bookNo}" maxlength="30"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" width="140px">Series</td>
					<td class="leftAligned">
						<input type="text" id="txtSeries" name="txtSeries" style="margin-left: 10px; width: 200px;" value="${series}" maxlength="30"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="buttonsDiv" style="float:left; width: 100%; margin: 15px 0 5px 0;">
		<input type="button" class="button" id="btnReturnG28" style="width: 80px;" name="btnReturnG28"	value="Return" />
	</div>
</div>

<script type="text/javascript">
	if('${reportId}' != 'POLICY_SU'){
		$("forPolicyReportDiv").hide();
		$("forIndemnityReportDiv").show();
	} else {
		$("forPolicyReportDiv").show();
		$("forIndemnityReportDiv").hide();
	}
	
	var lineCd = getLineCd($F("policyLineCd"));
	var sublineCd = $F("sublineCd");

	var chkPolicy = "N";
	var chkAoj = "N";
	var chkIndem = "N";
	var enableAckDate = true;

	observeBackSpaceOnDate("txtAckDate");

	function setAddtlInfoForPrinting() {
		if('${reportId}' == 'POLICY_SU') {
			if($F("sublineCd") == "G15" || $F("sublineCd") == "G(15)" || $F("sublineCd") == "G14" || $F("sublineCd") == "G(14)"){
				$("hidRegDeedNo").value = $F("regDeedNo");
				$("hidDateIssued").value = $F("dateIssued");
			} else if($F("sublineCd") == "G28" || $F("sublineCd") == "G(28)") {
				$("hidRegDeedNo").value = $F("regDeedNo");
				$("hidRegDeed").value = $F("regDeed");
				$("hidDateIssued").value = $F("dateIssued");
			} else if ($F("sublineCd") == "JCL6" || $F("sublineCd") == "JCL(6)" || $F("sublineCd") == "JCL06" || $F("sublineCd") == "JCL(06)"){
				$("hidBondTitle").value = $F("bondTitle");
				$("hidReason").value = $F("reason");
				$("hidSavingsAcctNo").value = $F("savingsAcctNo");
			} else if($F("sublineCd") == "JCL15" || $F("sublineCd") == "JCL(15)"){
				$("hidComplainant").value = $F("complainant");
				$("hidVersus").value = $F("versus");
				$("hidJudge").value = $F("judge");
				$("hidSection").value = $F("section");
				$("hidRule").value = $F("rule");
				$("hidDateIssued").value = $F("dateIssued");
				$("hidJudge").value = $F("judge");
			} else if($F("sublineCd") == "JCL(13)" || $F("sublineCd") == "JCL13"){
				$("hidCaseNo").value = $F("caseNo");
				$("hidVersusA").value = $F("versusA");
				$("hidVersusB").value = $F("versusB");
				$("hidVersusC").value = $F("versusC");
				$("hidSheriffLoc").value = $F("sheriffLoc");
				$("hidDateIssued").value = $F("dateIssued");
				$("hidJudge").value = $F("judge");
				$("hidSignatory").value = $F("signatory");
			} else if($F("sublineCd") == "JCL(5)" || $F("sublineCd") == "JCL5" || $F("sublineCd") == "JCL(05)" || $F("sublineCd") == "JCL05"){
				$("hidPartA").value = $F("partA");
				$("hidPartB").value = $F("partB");
				$("hidPartC").value = $F("partC");
				$("hidPartD").value = $F("partD");
				$("hidPartE").value = $F("partE");
				$("hidPartF").value = $F("partF");
				$("hidBranch").value = $F("branch");
				$("hidBranchLoc").value = $F("branchLoc");
				$("hidJudge").value = $F("judge");
				$("hidAppDate").value = $F("appDate");
				$("hidGuardian").value = $F("guardian");
				$("hidSignAJCL5").value = $F("signAJCL5");
				$("hidSignBJCL5").value = $F("signBJCL5");
				$("hidDateIssued").value = $F("dateIssued");
			}
		} else {		
			$("hidPeriod").value = $F("txtPeriod");
			$("hidSignA").value = $F("txtSignA");
			$("hidSignB").value = $F("txtSignB");
			$("hidAckLoc").value = $F("txtAckLoc");
			$("hidAckDate").value = $F("txtAckDate");
			$("hidDocNo").value = $F("txtDocNo");
			$("hidPageNo").value = $F("txtPageNo");
			$("hidBookNo").value = $F("txtBookNo");
			$("hidSeries").value = $F("txtSeries");
		}
	}

	$("btnReturnG28").observe("click", function() {
		setAddtlInfoForPrinting();
		//overlayPolicyNumber.close();
		//hideOverlay();
		overlayAddtlInfo.close();
	});

	$$("div[name='forPrint']").each(function(row) {
		var docType = row.getAttribute("docType");
		if(docType == "POLICY_SU") chkPolicy = "Y";
		if(docType == "AOJ") chkAoj = "Y";
		if(docType == "INDEMNITY") chkIndem = "Y";
	});

	loadFieldStatus();

	function loadFieldStatus() {
		if(lineCd == "SU") {
			if(sublineCd == "G28" || sublineCd == "G(28)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$("regDeedNoG28").setAttribute("readonly", "readonly");
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$("regDeedNoG28").setAttribute("readonly", "readonly");
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
					
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$("regDeedNoG28").setAttribute("readonly", "readonly");
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else {
					disableIndemnityFields(false);
				}
			} else if(sublineCd == "G15" || sublineCd == "G(15)" || sublineCd == "G14" || sublineCd == "G(14)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$("regDeedNoG28").setAttribute("readonly", "readonly");
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$("regDeedNoG28").setAttribute("readonly", "readonly");
					$("dateIssuedG28").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				}  else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else {
					disableIndemnityFields(false);
				}
			} else if(sublineCd == "JCL15" || sublineCd == "JCL(15)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$("complainant").setAttribute("readonly", "readonly");
					$("versusS1").setAttribute("readonly", "readonly");
					$("judgeS1").setAttribute("readonly", "readonly");
					$("sectionS1").setAttribute("readonly", "readonly");
					$("ruleS1").setAttribute("readonly", "readonly");
					$("issDateS1").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$("complainant").setAttribute("readonly", "readonly");
					$("versusS1").setAttribute("readonly", "readonly");
					$("judgeS1").setAttribute("readonly", "readonly");
					$("sectionS1").setAttribute("readonly", "readonly");
					$("ruleS1").setAttribute("readonly", "readonly");
					$("issDateS1").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$("complainant").setAttribute("readonly", "readonly");
					$("versusS1").setAttribute("readonly", "readonly");
					$("judgeS1").setAttribute("readonly", "readonly");
					$("sectionS1").setAttribute("readonly", "readonly");
					$("ruleS1").setAttribute("readonly", "readonly");
					$("issDateS1").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				}  else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else {
					disableIndemnityFields(false);
				}
			} else if(sublineCd == "JCL5" || sublineCd == "JCL(5)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$$("div#polReportJCL5 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$$("div#polReportJCL5 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(false);
					$$("div#polReportJCL5 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				}  else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
					$$("div#polReportJCL5 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else {
					disableIndemnityFields(false);
				}
			} else if(sublineCd == "JCL13" || sublineCd == "JCL(13)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$$("div#polReportJCL13 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				}  else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
					$$("div#polReportJCL13 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else {
					disableIndemnityFields(false);
				}
			} else if(sublineCd == "JCL06" || sublineCd == "JCL(06)") {
				if(chkPolicy == "Y" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
					$("titleJCL06").setAttribute("readonly", "readonly");
					$("reasonJCL06").setAttribute("readonly", "readonly");
					$("savingsAcctJCL06").setAttribute("readonly", "readonly");
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(false);
				} else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "Y") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "N" && chkAoj == "Y" && chkIndem == "Y") {
					disableIndemnityFields(true);
				} else if(chkPolicy == "Y" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				}  else if(chkPolicy == "N" && chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
					$$("div#polReportJCL13 input").each(function(r) {
						r.setAttribute("readonly", "readonly");
					});
				} else {
					disableIndemnityFields(false);
				}
			} else {
				if(chkAoj == "N" && chkIndem == "N") {
					disableIndemnityFields(true);
				} else if(chkAoj == "Y" && chkIndem == "N") {
					disableIndemnityFields(true);
				}/* else if(chkAoj == "Y" && chkIndem == "Y") {
					
				} else {

				}*/
			}
		}
	}

	function disableIndemnityFields(disable) {
		if(disable) {
			$$("div#forIndemnityReportDiv input").each(function(r) {
				r.setAttribute("readonly", "readonly");
			});
			$("hrefAckDate").hide();
		} else {
			$$("div#forIndemnityReportDiv input").each(function(r) {
				r.removeAttribute("readonly");
			});
			$("hrefAckDate").show();
		}
	}

	observeBackSpaceOnDate("txtAckDate");

	$("txtPeriod").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtSignA").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtSignB").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtDocNo").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtPageNo").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtBookNo").observe("keyup", function() {
		limitText(this, 30);
	});

	$("txtSeries").observe("keyup", function() {
		limitText(this, 30);
	});

	//<img id="hrefAckDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtAckDate'),this, null);" alt="txtAckDate" class="hover" />
						
/*	$("hrefAckDate").observe("click", function() {
		if(enableAckDate) {
			scwShow($('txtAckDate'),this, null);
		}
	});*/
	

</script>

