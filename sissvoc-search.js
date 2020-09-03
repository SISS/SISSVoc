/*
clippy.BASE_PATH = 'clippy/agents/';
var clippyObj = {};

function initOrHideClippy(agent) {
	if(this.clippyObj[agent] == undefined) {
		//hide others
		$.each(this.clippyObj, function(key, agentObj) {
			if(agentObj.toggle == true) {
			   	agentObj.agent.hide();
				agentObj.toggle = false;
			}
		});
		
		this.clippyObj[agent] = {};
		initClippy(agent);
		this.clippyObj[agent].toggle = true;
		
		
	}
	else {
		if(this.clippyObj[agent].toggle == true) {
			this.clippyObj[agent].agent.hide();
			this.clippyObj[agent].toggle = false;

		}
		else {
			this.clippyObj[agent].agent.show();

			this.clippyObj[agent].toggle = true;
		}
	}
	
}

function initClippy(agentStr) {
	clippy.load(agentStr, function (agent) {
		// Do anything with the loaded agent
		this.clippyObj[agentStr].agent = agent;
		this.clippyObj.currAgentName = agentStr;

		this.clippyObj[agentStr].agent.show();
		this.clippyObj[agentStr].agent.animate();
		
	});
};

var agentSpeak = function (text, hold) {

	$.each( this.clippyObj, function( key, agentObj ) {
		if(agentObj.toggle == true) {
		  	agentObj.agent.stopCurrent();

			agentObj.agent.animate();
			//agent.speak(text, hold);
		}
		
	});
};

*/

var i = 0;

var knownSissvocEndpoints = [
					"http://sissvoc.ereefs.info/sissvoc/ereefs",
					"http://auscope-services-test.arrc.csiro.au/elda-demo/wq",
					"http://def.seegrid.csiro.au/sissvoc/isc2012" ,
					"http://auscope-services-test.arrc.csiro.au/elda-demo/nerc",
					"http://neiivocab.bom.gov.au/api/aclep",
					"http://sissvoc.ereefs.info/sissvoc/ereefs"
								];
var currentEndpoint = "http://sissvoc.ereefs.info/sissvoc/ereefs";

var delay = (function () {
	var timer = 0;
	return function (callback, ms) {
		clearTimeout(timer);
		timer = setTimeout(callback, ms);
	};
})();


function showAboutSissvocSearch() {
	
	var modalDlg =
		$('<div class="sissvocSearchModal modal hide fade" >' +
			'<div class="modal-header">' +
			'<a class="close" data-dismiss="modal" >&times;</a>' +
			'<h3>About SISSVoc Search</h3>' +
			'</div>' +
			
			'<div class="modal-body">' +
			'<p>SISSVoc search is a prototype query interface to SISSVoc service endpoints. It demonstrates the ability to define client interfaces ' +
			'for rich user interactions over SISSVoc vocabulary services.</p>' +
			'<p>The searching capabilities here have been developed to query concepts based on the SISSVoc design APIs, which allows access to SKOS definitions using Linked Data.</p>' +
			'<p>For more information, contact Jonathan Yu - jonathan[dot]yu[at]csiro[dot]au</p>' +
			'</div>' +
			
			'<div class="modal-footer">' +
			'<a href="#" id="okButton" class="btn btn-primary">OK</a>' +
			'</div>' +
			'</div>');
	
	modalDlg.find('#okButton').click(function (event) {
		
		modalDlg.modal('hide');
	});
	modalDlg.modal('show');
};

function showAdvancedDlg() {
	
	var modalDlg =
		$('<div class="sissvocSearchModal modal hide fade" >' +
			'<div class="modal-header">' +
			'<a class="close" data-dismiss="modal" >&times;</a>' +
			'<h3>Advanced search options</h3>' +
			'</div>' +
			
			'<div class="modal-body">' +
			'<p>Available hashtags to add to query for advanced searching:</p>' +
			'<ul>' +
			'<li><b>#anylabel</b> (exact text in any of the label properties)</li>' +
			'<li><b>#broader</b>  (broader concepts to concepts matching exact text in any of the label properties)</li>' +
			'<li><b>#narrower</b> (narrower concepts to concepts matching exact text in any of the label properties)</li>' + 
			'<li><b>#broaderTransitive</b> (broaderTransitive concepts to concepts matching exact text in any of the label properties)</li>' +
			'<li><b>#narrowerTransitive</b> (narrowerTransitive concepts to concepts matching exact text in any of the label properties)</li>' +
			'</ul>' +
			'</p>' +
			'<p>These hashtag options are based on the SISSVoc Design API for SKOS concept-based queries</p>'+
			'</div>' +
			
			'<div class="modal-footer">' +
			'<a href="#" id="okButton" class="btn btn-primary">OK</a>' +
			'</div>' +
			'</div>');
	
	modalDlg.find('#okButton').click(function (event) {
		
		modalDlg.modal('hide');
	});
	modalDlg.modal('show');
};


function confirm(heading, question, cancelButtonTxt, okButtonTxt, callback) {
	
	var confirmModal =
		$('<div class="sissvocSearchModal modal hide fade">' +
			'<div class="modal-header">' +
			'<a class="close" data-dismiss="modal" >&times;</a>' +
			'<h3>' + heading + '</h3>' +
			'</div>' +
			
			'<div class="modal-body">' +
			'<p>Select:</p>' +
			'<select id="changeOptions"></select>' +
			'</div>' +
			'<div class="modal-body">' +
			'<p>' + question + '</p>' +
			'<input type="text" id="changeUri"  type="text" />' +
			'</div>' +
			
			'<div class="modal-footer">' +
			'<a href="#" class="btn" data-dismiss="modal">' +
			cancelButtonTxt +
			'</a>' +
			'<a href="#" id="okButton" class="btn btn-primary">' +
			okButtonTxt +
			'</a>' +
			'</div>' +
			'</div>');
	
	confirmModal.find('#okButton').click(function (event) {
		var uriElem = confirmModal.find('#changeUri').val();
		callback(uriElem);
		
		confirmModal.modal('hide');
	});
	$.each(this.knownSissvocEndpoints, function(i, item) {
		confirmModal.find('#changeOptions').append($("<option />").val(item).text(item));
		confirmModal.find('#changeOptions').change(function() {
			    confirmModal.find('#changeUri').val(this.value);
		});
		confirmModal.find('#changeOptions').click(function() {
			    confirmModal.find('#changeUri').val(this.value);
		});
	});
	confirmModal.modal('show');
};

var changeServiceUrl = function () {
	
	var heading = 'Change SISSVoc service URL';
	var question = 'Change SISSVoc service URL to:';
	var cancelButtonTxt = 'Cancel';
	var okButtonTxt = 'Confirm';
	
	var callback = function (url) {
		//trim any whitespace and match
		var trimmed = url.trim();

		//validate url
		if (trimmed === undefined || !trimmed.match(/^http(s)*:\/\//)) {
			alert('Invalid URL for SISSVoc endpoint');
			return;
		}
		
		
		//alert('url: ' + urlElem.value);
		var existsFlag = false;
		$.each(this.knownSissvocEndpoints, function(i, item) {
			if(item == trimmed) {
				existsFlag = true;
			}
		});
		
		if(!existsFlag) {
			this.knownSissvocEndpoints.push(trimmed);
		}
		
		//document.getElementById('serviceUriField').value = trimmed;
		document.getElementById('service-url-value').innerHTML = trimmed;
	};
	
	confirm(heading, question, cancelButtonTxt, okButtonTxt, callback);
	
};

var execQuery = function (ajaxQuery, term, svc) {
	var start = new Date().getTime();
	$("#searchloading img").show();

	ajaxQuery.done(function (data) {
		$("#results").empty();
		$("#results").append("<p id='resultDescrip'>Results for <b><span id='dispsearchterm'>" + term + "</b></span><span id='dispSearchPage'></span></p>");
		
		$.each(data.result.items, function (i, item) {
			var resourceUri = item._about;
			var promise = $.ajax({
					url : svc + "/resource.json",
					data : {
						uri : resourceUri,
						_view : "all"
					},
					type : "GET"
				}).done(function (itemDetails) {
					$("#results").append(renderSearchResultItem(resourceUri, processSkosLabel(item.prefLabel), itemDetails));
				});
		});
		var elapsed = new Date().getTime() - start;
		var secs = elapsed / 1000;
		
		delay(function () {
			handlePagination(data, term, svc, secs);
		}, 1000);
		$("#searchloading img").hide();

		//agentSpeak("Showing search results",1000);
	});
	ajaxQuery.fail(function(jqXHR, textStatus) {
	    alert("Request to SISSVoc endpoint failed: " + textStatus);
	});
};

var handlePagination = function (data, term, svc, secs) {
	
	//handle pagination
	$("#pagination").hide();
	$("#pagination").empty();
	
	var numResultsOnPage = data.result.items.length;
	
	if (data.result.page != 0 && data.result.startIndex !== undefined && data.result.itemsPerPage !== undefined) {
		$("#dispSearchPage").html(". Showing page " + (data.result.page + 1) + ", result " + data.result.startIndex + " to " + (data.result.startIndex + numResultsOnPage - 1)
			 + " (" + secs + " secs)");
	} else if (data.result.page == 0 && data.result.startIndex !== undefined && data.result.itemsPerPage !== undefined) {
		
		$("#dispSearchPage").html(". Showing page " + (data.result.page + 1) + ", result " + data.result.startIndex + " to " + (data.result.startIndex + numResultsOnPage - 1)
			 + " (" + secs + " secs)");
		
	}
	
	if (data.result.page != 0 && data.result.first !== undefined && data.result.prev !== undefined) {
		
		//render first
		var first = $('<a href="#"></a>').append('first').attr("data-info", data.result.first).click(function () {
				var query = $.ajax({
						url : $(this).attr('data-info'),
						type : "GET"
					});
				
				execQuery(query, term, svc);
			});
		
		$("#pagination").append(first);
		
		var prev = $('<a href="#"></a>').append('prev').attr("data-info", data.result.prev).click(function () {
				var query = $.ajax({
						url : $(this).attr('data-info'),
						type : "GET"
					});
				
				execQuery(query, term, svc);
			});
		
		$("#pagination").append(prev);
		
	}
	if (data.result.next !== undefined) {
		var next = $('<a href="#"></a>').append('next').attr("data-info", data.result.next).click(function () {
				var query = $.ajax({
						url : $(this).attr('data-info'),
						type : "GET"
					});
				
				execQuery(query, term, svc);
			});
		
		$("#pagination").append(next);
		
	}
	
	delay(function () {
		$("#pagination").show();
	}, 1000);
	
}
var searchFn = function (q, svc) {
      currentEndpoint = svc;
	if(q == "") {
		$("#results").empty();

	   return;
	}

	$("#searchloading img").show();
	
	var ajaxData = parseQuery(q, svc);
	
	var query = $.ajax(ajaxData);
	
	execQuery(query, q, svc);
	//agentSpeak("Searching...", 100);
	
};

var parseQuery = function (query, svc) {
	var data = new Object();
	data._view = "all";
	var ajaxObj = new Object();
	
	if ($.trim(query).match(/#anylabel\W*/)) {
		//chop query
		data.anylabel = $.trim(query.replace("#anylabel", ''));
		ajaxObj.url = svc + "/concept.json";
	} else if ($.trim(query).match(/#broader\W*/)) {
		data.anylabel = $.trim(query.replace("#broader", ''));
		ajaxObj.url = svc + "/concept/broader.json";
	} else if ($.trim(query).match(/#broaderTransitive\W*/)) {
		data.anylabel = $.trim(query.replace("#broaderTransitive", ''));
		ajaxObj.url = svc + "/concept/broaderTransitive.json";
	} else if ($.trim(query).match(/#narrower\W*/)) {
		data.anylabel = $.trim(query.replace("#narrower", ''));
		ajaxObj.url = svc + "/concept/narrower.json";
	} else if ($.trim(query).match(/#narrowerTransitive\W*/)) {
		data.anylabel = $.trim(query.replace("#narrowerTransitive", ''));
		ajaxObj.url = svc + "/concept/narrowerTransitive.json";
	} else {
		data.labelcontains = query;
		ajaxObj.url = svc + "/concept.json";
		
	}
	
	ajaxObj.data = data;
	ajaxObj.type = "GET";
	ajaxObj._view= "skos";
	
	return ajaxObj;
};

var processMultilingualLabel = function (labelObj) {
	
	if (labelObj === undefined) {
		return;
	}
	
	if (labelObj._value !== undefined) {
	    if(labelObj._lang !== undefined && labelObj._lang != "en") {
		      return labelObj._value + "@" + labelObj._lang;
		}
  	   	return labelObj._value;		
	}

	
	return labelObj;
};

var processSkosLabel = function (labelObjOrArray) {
	var str;
	if ($.type(labelObjOrArray) === "array") {
		str = "<ul class='skoslabel'>";
		$.each(labelObjOrArray, function (i, item) {
			str = str + "<li>" + processMultilingualLabel(item) + "</li> ";
		});
		str = str + "</ul>";
	} else {
		return processMultilingualLabel(labelObjOrArray);
	}
	return str;
};
var getLinkOrText = function (str, label) {
	if (str === undefined)
		return str
		
		var regex = /^http:\/\/*/;
	if (regex.test(str)) {
		if (label === undefined) {
			return "<a href=\"" + currentEndpoint + "/resource?uri=" + String(str).replace('#', '%23') + "\">" + str + "</a>";
                }
		else {
			return "<a href=\"" + currentEndpoint + "/resource?uri=" + String(str).replace("#", '%23') + "\">" + label + "</a>";
		}
	} else {
		if (label === undefined)
			return str;
		else {
			return label;
		}
	}
	
};
var handleUnmappedResources = function (resource) {
	if ($.type(resource) === "array") {
		var str = "<ul>";
		$.each(resource, function (i, item) {
			str = str + "<li>" + processAboutOrDefault(item) + "</li> ";
		});
		str = str + "</ul>";
		return str;
		
	} else {
		return processAboutOrDefault(resource);
	}
};
var formatResPropList = function (prop, value) {

	if(value._value !== undefined) {
		return "<li id='resProp'>" + prop + ": " + value._value + "</li>";
	}

	return "<li id='resProp'>" + prop + ": " + value + "</li>";
};

var processAboutOrDefault = function (currResource) {
	var str;
	if (currResource === undefined) {
		return;
	}
	if (currResource._about !== undefined) {
		str = getLinkOrText(currResource._about)
	}
	//try currResource
	else {
		str = getLinkOrText(currResource)
	}
	return str;
}

var processResourceLinkText = function (currResource, arrResource) {
	if ($.type(currResource) === "array") {
		$.each(currResource, function (i, res) {
			//nonLabelStr = nonLabelStr + formatResPropList(k, getLinkOrText(altLabelItem._about));
			arrResource.push(processAboutOrDefault(res));
		});
	} else {
		//nonLabelStr = nonLabelStr + formatResPropList(k, getLinkOrText(v._about));
		
		arrResource.push(processAboutOrDefault(currResource));
	}
};

var handleTypeObj = function (typeItem, arrType) {
	var typeOfItem = $.type(typeItem);
	if (typeOfItem === "object") {
		if (typeItem._about === undefined) {
			arrType.push(getLinkOrText(typeItem));
		} else {
			arrType.push(getLinkOrText(typeItem._about, typeItem.label._value));
		}
	} else {
		arrType.push(getLinkOrText(typeItem));
	}
};
var formatResourceLinks = function (elemId, elemLabel, arrResources, menuElem) {
	var bottomInlineItem1 = $('<li/>')
		.attr("id", elemId)
		.text(elemLabel + " (" + arrResources.length + ")");
	menuElem.append(bottomInlineItem1);
	
	bottomInlineItem1.append("<a  class='dropdown-toggle' data-toggle='dropdown' href='#'><span></span></a>");
	
	bottomInlineItem1.click(function (e) {
		$("div.custom-menu").hide();
		
		var cm = $("<div class='custom-menu'>" + elemLabel + "</div>");
		
		$.each(arrResources, function (i, bItem) {
			cm.append("<li>" + bItem + "</li>");
		});
		cm.appendTo("body")
		.css({
			top : e.pageY + "px",
			left : e.pageX + "px"
		});
		
	});
};



var renderSearchResultItem = function (uri, label, data) {
	//var newdiv = document.createElement( "div" ).addClass("res");
	var newdiv = $('<div/>')
		.addClass("res");
	newdiv.append("<h3 class='title'><a href=\"" + currentEndpoint + "/resource?uri=" + uri.replace('#', '%23') + "\" target='out'>" + label + "</a></h3>");
	
	newdiv.append("<div class='dispUri'>" + getLinkOrText(uri) + "</div>");
	
	//var renderProps = document.createElement( "div" ).addClass("renderProps");
	var renderProps = $('<div/>')
		.addClass("renderProps")
		.appendTo(newdiv);
	
	var str = "<div class='res'>";
	var arrIgnoredItems = ["_about", "isPrimaryTopicOf", "prefLabel"];
	var arrSimpleUri = ["exactMatch"];
	var arrLabel = ["altLabel", "prefLabel", "definition", "notation", "label"];
	var labelStr = "";
	var nonLabelStr = "";
	var arrBroader = [];
	var arrType = [];
	var arrNarrower = [];
	var arrNarrowerTransitive = [];
	var arrBroaderTransitive = [];
	var arrInScheme = [];
	var arrSubClassOf = [];
	
	$.each(data.result.primaryTopic, function (k, v) {
		var isIgnored = $.inArray(k, arrIgnoredItems);
		
		if (isIgnored != -1) {}
		else if ($.inArray(k, arrLabel) != -1) {
			if (k == "altLabel") {
	                    if ($.type(v) === "array") {
				$.each(v, function (i, altLabelItem) {
					labelStr = labelStr + formatResPropList(k, altLabelItem._value);
				});
                            }
			    labelStr = labelStr + formatResPropList("altLabel", v);
			} else if (k == "definition") {
				labelStr = labelStr + formatResPropList("definition", v);
			} else if (k == "notation") {
				labelStr = labelStr + formatResPropList(k, v);
			} else if (k == "label") {
				labelStr = labelStr + formatResPropList(k, v);
			} else {
				labelStr = labelStr + formatResPropList(k, getLinkOrText(v));
			}
		} else {
			if (k == "broader") {
				processResourceLinkText(v, arrBroader);
			} else if (k == "broaderTransitive") {
				processResourceLinkText(v, arrBroaderTransitive);
			} else if (k == "narrower") {
				processResourceLinkText(v, arrNarrower);
			} else if (k == "narrowerTransitive") {
				processResourceLinkText(v, arrNarrowerTransitive);
			} else if (k == "inScheme") {
				processResourceLinkText(v, arrInScheme);
			} else if (k == "subClassOf") {
				processResourceLinkText(v, arrSubClassOf);
			} else if (k == "type") {
				if ($.type(v) === "array") {
					$.each(v, function (i, typeItem) {
						handleTypeObj(typeItem, arrType);
					});
				} else {
					handleTypeObj(v, arrType);
				}
			} else {
				nonLabelStr = nonLabelStr + formatResPropList(k, handleUnmappedResources(v));
			}
		}
		
	});
	
	renderProps.append(labelStr + nonLabelStr);
	
	var bottomInlineMenu = $('<ul/>')
		.addClass("inline-menu")
		.appendTo(newdiv);
	
	//str = str + "<ul class='inline-menu'>";
	if (arrBroader.length > 0) {
		formatResourceLinks("broader", "Broader", arrBroader, bottomInlineMenu);
		
	}
	if (arrBroaderTransitive.length > 0) {
		formatResourceLinks("broaderTransitive", "Broader Transitive", arrBroaderTransitive, bottomInlineMenu);
		
	}
	if (arrNarrower.length > 0) {
		formatResourceLinks("narrower", "Narrower", arrNarrower, bottomInlineMenu);
	}
	if (arrNarrowerTransitive.length > 0) {
		formatResourceLinks("narrowerTransitive", "Narrower Transitive", arrNarrowerTransitive, bottomInlineMenu);
		
	}
	if (arrType.length > 0) {
		formatResourceLinks("type", "Type", arrType, bottomInlineMenu);
	}
	if (arrSubClassOf.length > 0) {
		formatResourceLinks("subClassOf", "SubClass Of", arrSubClassOf, bottomInlineMenu);
	}

	if (arrInScheme.length > 0) {
		formatResourceLinks("inScheme", "In Scheme", arrInScheme, bottomInlineMenu);
	}
	
	return newdiv;
}

var keyUpFn = $("#searchterm").keyup(function (e) {
		delay(function () {
			var q = $("#searchterm").val();
			var elem = $("#service-url-value");
			var svc = elem.html();
			searchFn(q, svc);
			
		}, 500);
	});

$("#searchBtn").click(function (e) {
	var q = $("#searchterm").val();
	var elem = $("#service-url-value");
	var svc = elem.html();
	searchFn(q, svc);
});

$(document).bind("click", function (event) {
	$("div.custom-menu").hide();
});

$('form[name="searchform"]').submit(function(event){
     event.preventDefault();
    
		var q = $("#searchterm").val();
			var elem = $("#service-url-value");
			var svc = elem.html();
			searchFn(q, svc);
	  return false;
});
