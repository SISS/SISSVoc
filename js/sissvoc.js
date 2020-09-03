//If not already defined, need to define a current sissvoc endpoint e.g. below:
//var currentEndpoint = 'http://sissvoc.ereefs.info/sissvoc/ereefs';
var sissvocRenderResourceLinks = true;

//this searches Concepts defined in a sissvoc endpoint by 'q' string 
// fnProcessConcepts is a function that does something with the returned json
var searchConcepts = function(q, fnProcessConcepts) {
    var pageSize = 50;
	var currPage = 0;
    var url = currentEndpoint + '/concept.json?_pageSize='+pageSize+'&_page='+currPage+'&_view=all&_orderBy=?l&_where=?item%20a%20skos:Concept&labelcontains=' + q;
    $.get( url, fnProcessConcepts);
};


//this gets all the collections defined in a sissvoc endpoint by 'q' string 
// fnProcessCollections is a function that does something with the returned json
var searchCollections = function(q, fnProcessCollections) {
    var pageSize = 50;
	var currPage = 0;
    var url = currentEndpoint + '/collection.json?_pageSize='+pageSize+'&_page='+currPage+'&_view=all&_orderBy=?l&_where={%20?item%20skos:prefLabel%20?l%20}%20FILTER%20regex%28%20str%28?l%29%20,%20%27'+q+'%27,%20%27i%27%20%29';
    $.get( url, fnProcessCollections);
};

//this gets all the collections defined in a sissvoc endpoint by 'q' string 
// fnProcessCollections is a function that does something with the returned json
var getCollections = function(pageSize, currPage) {
    var url = currentEndpoint + '/collection.json?_pageSize='+pageSize+'&_page='+currPage+'&_view=all';
    $.get( url, function(data) {
	   return data;
	}
	);
};

//this gets all the collections defined in a sissvoc endpoint by 'q' string 
// fnProcessCollections is a function that does something with the returned json
var getResource = function(uri) {
    var url = currentEndpoint + '/resource.json?uri=' + uri;
    $.get( url, function(data) {
	   return data;
	}
	);
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
var handleUnmappedResources = function (resource) {
	if ($.type(resource) === "array") {
		var str = "<ul class=\"collapse in\">";
		console.log(resource);
		$.each(resource, function (i, item) {
			// these are the members
			str = str + "<li>" + processAboutOrDefault(item, true) + "</li> ";
		});
		str = str + "</ul>";
		return str;
		
	} else {
		return processAboutOrDefault(resource);
	}
};
var formatResPropList = function (prop, value) {
	var collapse_attribute = '';
	var collapse_arrow = '';

	if (prop == 'member' || prop == 'broader' || prop == 'narrower' || prop == 'related' || prop == 'broadMatch'){
		collapse_attribute = 'data-toggle="collapse" data-target="#list" style="cursor: pointer"';
		collapse_arrow = '<b class="caret rotate180"></b>';
	}

	if(value !== undefined){
		if (String(value).indexOf('<ul') < 0){
			collapse_attribute = '';
			collapse_arrow = '';
		}
			
	}else{
		return '';
	}

	if(value._value !== undefined) {
		return "<li class='resProp'><span class='resprop-field'" + collapse_attribute + ">" + prop + collapse_arrow + "</span> <span class='resprop-value'>" + value._value + "</span></li>";
	}
	

	return "<li class='resProp'><span class='resprop-field'" + collapse_attribute + ">" + prop + collapse_arrow + "</span><span class='resprop-value'> " + value + "</span></li>";
};

var processAboutOrDefault = function (currResource, isMember) {
	var str;
	console.log('process '+isMember);
	if (currResource === undefined) {
		return;
	}
	if (currResource._about !== undefined) {
		str = getLinkOrText(currResource._about, undefined, isMember)
	}
	//try currResource
	else {
		str = getLinkOrText(currResource, undefined, isMember)
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
var getLinkOrText = function (str, label, isMember) {
	if (str === undefined)
		return str
		
	var regex = /^http:\/\/*/;
	
	if (regex.test(str)) {
		if (isMember){
			var separator = str.lastIndexOf('/');
			label = str.substring(separator + 1);

			if (label.indexOf('#') >= 0){
				separator = str.lastIndexOf('#');
				label = str.substring(separator + 1);
			}
		}
		

		if (label === undefined) {
			if(sissvocRenderResourceLinks) {
				return "<a href=\"" +currentEndpoint + "/resource?uri=" + String(str).replace('#', '%23') + "\">" + str + "</a>";
			}
			return "<a href=\"" + String(str).replace('#', '%23') + "\">" + str + "</a>";
        }
		else {
			if(sissvocRenderResourceLinks) {
				return "<a href=\"" +currentEndpoint + "/resource?uri=" + String(str).replace("#", '%23') + "\">" + label + "</a>";
			}
			return "<a href=\"" + String(str).replace("#", '%23') + "\">" + label + "</a>";
		}
	} else {
		if (label === undefined)
			return str;
		else {
			return label;
		}
	}
	
};

var renderSearchResultItem = function (uri, label, data) {
	//var newdiv = document.createElement( "div" ).addClass("res");
	var newdiv = $('<div/>')
		.addClass("res");
	var resourceEndpoint = currentEndpoint + "/resource?uri=" + uri.replace('#', '%23');
	
	newdiv.append("<h3 class='title'><a href=\"" + resourceEndpoint + "\" target='out'>" + label + "</a></h3>");
	
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
		/*
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
			*/
			nonLabelStr = nonLabelStr + formatResPropList(k, handleUnmappedResources(v));
		}
		
	});
	
	renderProps.append(labelStr + nonLabelStr);
	/*
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
	*/
	return newdiv;
}
