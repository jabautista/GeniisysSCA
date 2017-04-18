function showWindow(id, title, width, height, page, top)	{
 	try	{
 	if ("loginWin" == id && Windows.getWindow("loginWin") != undefined)	{
 	 	return false;
	}
	
	var win = new Window(id, {
	 			  className: "alphacube",
				  blurClassName: "alphacube",
				  title: title,
				  width: width,
				  height: height,
				  closable: true,
				  minimizable: false,
				  maximizable: false,
				  draggable: false,
				  destroyOnClose: true,
				  showEffect: Effect.Appear,
				  showEffectOptions: {duration: .5},
				  hideEffect: Effect.Fade,
				  hideEffectOptions: {duration: .5},
				  parent: $("mainBody")});
			win.setDestroyOnClose(true);
			win.setAjaxContent(page);
			win.showCenter(true, top);
			
			if (page == "miniCounselorsList.php")	{
				win.options.draggable = true;
			}
	} catch (e)	{
		alert(e.message);
	}
}

function showChat(id, title, width, height, page, top)	{
 	if (Windows.getWindow(id) != undefined)	{
		Windows.getWindow(id).show();
	}	else	{
	 	try	{
		var win = new Window(id, {
		 			  url: page,
		 			  className: "alphacube",
					  blurClassName: "alphacube",
					  title: title,
					  width: width,
					  height: height,
					  closable: true,
					  minimizable: true,
					  maximizable: false,
					  draggable: false,
					  destroyOnClose: false,
					  showEffect: Effect.Appear,
					  showEffectOptions: {duration: .5},
					  hideEffect: Effect.Fade,
					  hideEffectOptions: {duration: .5},
					  parent: $("windowsDiv")});
				win.showCenter(true, top);
				//win.show();
				//win.maximize();
		} catch (e)	{
			alert(e.message);
		}
	}
}

function showContents(page, isLogin)	{
	Effect.Appear("contents", 
				{
				 	duration: 1,
				 	beforeFinish: function ()	{
						if ("activities.html" == page || "buzzSessions.html" == page || "news.html" == page)	{
							$$(".vertical_accordion_toggle").each(
								function(h3)	{
										h3.observe("click", function ()	{
											Effect.toggle(h3.next().getAttribute("id"), "blind", 
											{
												duration: .5	
											});
										});
								}
							);
						}
						
						if ("guestbook.html?pageNo=0&temp=0" == page)	{
							$$("div[name='cDiv']").each(
								function(div)	{
									div.observe("mouseover", function()	{
										div.down('span', 1).show();
										div.addClassName("lightblue");
									});
									
									div.observe("mouseout", function()	{
										div.down('span', 1).hide();
										div.removeClassName("lightblue");
									});
								}
							);
						}
						
						if ("counselors.html?pageNo=0" == page)	{
							$$("div[name='cDiv']").each(
								function(div)	{
									div.observe("mouseover", function()	{
										div.down('span', 1).show();
										div.addClassName("lightblue");
									});
									
									div.observe("mouseout", function()	{
										div.down('span', 1).hide();
										div.removeClassName("lightblue");
									});
								});
								
							$$("label[name='view']").each(
								function (label)	{
									label.observe("click", function	(){
										viewProfile(label.getAttribute("id").substring(4));
									});
							});
							
							$$("label[name='sendMessage']").each(
								function (label)	{
									label.observe("click", function	(){
										viewSendMessageForm(label.getAttribute("id").substring(11));
									});
							});
						}
						if (isLogin)	{
						 	if (Windows.getWindow("loginWin") != undefined)	{
								Windows.getWindow("loginWin").close();
							}
						}
						initializeAll();
						new lightwindow();
					}
				});
}

function goToNextPageOfCounselorsMini(pageNo)	{
	Effect.Fade("list",
				{
					duration: 1,
					beforeFinish: function()	{
						new Ajax.Updater("list",
										"miniCounselorsList.php?pageNo="+pageNo,
										{
										 	asynchronous: true,
										 	evalScripts: true,
										 	onComplete: function ()	{
										 	 	Effect.Appear("list", 
												{
												 	duration: 1,
												 	afterFinish: function ()	{
														$$("div[name='cDiv']").each(
															function(div)	{
																div.observe("mouseover", function()	{
																	div.down('span', 1).show();
																	div.addClassName("lightblue");
																});
																
																div.observe("mouseout", function()	{
																	div.down('span', 1).hide();
																	div.removeClassName("lightblue");
																});
															}
														);
														
														$$("label[name='view']").each(
															function (label)	{
																label.observe("click", function	(){
																	viewProfile(label.getAttribute("id").substring(4));
																});
														});
														
														$$("label[name='sendMessage']").each(
															function (label)	{
																label.observe("click", function	(){
																	viewSendMessageForm(label.getAttribute("id").substring(11));
																});
														});
														initializeAll();
														new lightwindow();
													}
												});
											}
										});
					}
				});
}

function goToNextPageOfCounselors(pageNo)	{
	Effect.Fade("list",
				{
					duration: 1,
					beforeFinish: function()	{
						new Ajax.Updater("list",
										"counselors.php?pageNo="+pageNo,
										{
										 	asynchronous: true,
										 	evalScripts: true,
										 	onComplete: function ()	{
										 	 	Effect.Appear("list", 
												{
												 	duration: 1,
												 	afterFinish: function ()	{
														$$("div[name='cDiv']").each(
															function(div)	{
																div.observe("mouseover", function()	{
																	div.down('span', 1).show();
																	div.addClassName("lightblue");
																});
																
																div.observe("mouseout", function()	{
																	div.down('span', 1).hide();
																	div.removeClassName("lightblue");
																});
															}
														);
														
														$$("label[name='view']").each(
															function (label)	{
																label.observe("click", function	(){
																	viewProfile(label.getAttribute("id").substring(4));
																});
														});
														
														$$("label[name='sendMessage']").each(
															function (label)	{
																label.observe("click", function	(){
																	viewSendMessageForm(label.getAttribute("id").substring(11));
																});
														});
														initializeAll();
														new lightwindow();
													}
												});
											}
										});
					}
				});
}

function showInformation(tag, isLogin)	{
 	Effect.Fade("contents", 
	 			{
	  				duration: 1,
	  				beforeFinish: function ()	{
						new Ajax.Updater("contents",
										"getInformationByTag.php?tag="+tag,
										{
											asynchronous: true,
											evalScripts: true,
											onComplete: showContents("", isLogin)
										});
					}
				});
}

function showPage(page)	{
 	Windows.closeAll();
 	Effect.Fade("contents", 
	 			{
	  				duration: 1,
	  				beforeFinish: function ()	{
						new Ajax.Updater("contents",
										page,
										{
										 	asynchronous: true,
										 	evalScripts: true,
										 	onComplete: showContents(page, "")
										});
					}
				});
}

function viewProfile(counselorId)	{
 	/*if ((typeof Windows.getWindow("profile")) != undefined)	{
		Windows.getWindow("profile").close();
	}*/
	showWindow("", "Counselor Profile", 460, 530, "viewProfile.php?counselorId="+counselorId, 30);
}

function viewSendMessageForm(counselorId)	{
 	if (Windows.getWindow("sendMessageForm") != undefined)	{
 	 	return false;
 	 	try	{
 	 	Windows.getWindow("sendMessageForm").close();
 		Windows.getWindow("sendMessageForm").hide();
 		Windows.getWindow("sendMessageForm").destroy();
 		} catch (e)	{
			alert(e.message);
		}
 	}	else	{
		showWindow("sendMessageForm", "Send Message", 524, 295, "sendMessage.html?counselorId="+counselorId, 50);	
	}
}

function viewInterviewInvitationForm(counselorId)	{
 	if (Windows.getWindow("interviewInvitationForm") != undefined)	{
 	 	return false;
 	 	try	{
 	 	Windows.getWindow("interviewInvitationForm").close();
 		Windows.getWindow("interviewInvitationForm").hide();
 		Windows.getWindow("interviewInvitationForm").destroy();
 		} catch (e)	{
			alert(e.message);
		}
 	}	else	{
		showWindow("interviewInvitationForm", "Send Message", 524, 295, "interviewInvitationForm.html?counselorId="+counselorId, 50);	
	}
}

function refreshMenu()	{
 	Effect.Fade("menuContainer", 
 	{
		duration: .5,
		beforeFinish: function ()	{
			new Ajax.Updater("menuContainer",
					"menu.php",
					{
						asynchronous: true,
						evalScripts: true,
						onComplete: function ()	{
							Effect.Appear("menuContainer", 
							{
							 	duration: .5,
							 	afterFinish: function ()	{
									
									ddsmoothmenu.init( {
										mainmenuid :"smoothmenu", //"smoothmenu1", //menu DIV id
										orientation :'h', //Horizontal or vertical menu: Set to "h" or "v"
										classname :'ddsmoothmenu', //class added to menu's outer DIV
										contentsource : [ "menuContainer", "menu.php" ]
									});	
								}
							});
						}
					});		
		}
	});
}