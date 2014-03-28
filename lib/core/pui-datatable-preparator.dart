part of angularprime_dart;

/** Converts <pui-datatable> to a format that can be processed by AngularDart */
void prepareDatatables()
{
  NodeList list = window.document.getElementsByTagName('pui-datatable');
  list.forEach((Element puiDatatable){
    _prepareDatatable(puiDatatable);
  });
}


_prepareDatatable(Element puiDatatable) {
  ElementList columns = puiDatatable.querySelectorAll('pui-column');
  String headers="";
  int c = 0;
  columns.forEach((Element col) {
    col.attributes["data-ci"]=c.toString();
    col.classes.add("pui-datatable-td");
    col.classes.add("ui-widget-content");
    col.style.display="table-cell";
    col.attributes["role"]="gridcell";
    String closable=col.attributes["closable"];
    if (closable==null) closable="false";
    String sortable=col.attributes["sortable"];
    if (sortable==null) sortable="false";

    headers += """<pui-column-header header="${col.attributes["header"]}" closable="$closable"  sortable="$sortable"></pui-column-header>\n""";
    c++;
  });

  String content = puiDatatable.innerHtml;
  ElementList rows = puiDatatable.querySelectorAll('pui-row');
  if (rows.isEmpty)
  {
    String ngRepeat = puiDatatable.attributes["ng-repeat"];
    content = """<pui-row ng-repeat="$ngRepeat" data-ri="{{index}}" role="row" style="display:table-row" class="tr ui-widget-content {{rowClass()}}">$content</pui-row>""";
    puiDatatable.attributes["ng-repeat"]=null;
  }
  else
  {
    rows.forEach((Element row){
      row.attributes["data-ri"]="{{index}}";
      row.classes.add("tr");
      row.classes.add("ui-widget-content");
      row.style.display="table-row";
      row.attributes["role"]="row";
    });
    content = puiDatatable.innerHtml;
  }
  content=headers + content;
  String newContent = content.replaceAll("<pui-row", """<div """)
      .replaceAll("</pui-row>", "</div>")
      .replaceAll("<pui-column ", """<div """)
      .replaceAll("</pui-column>", "</div>");
  Element inside = PuiHtmlUtils.parseResponse("<span>$newContent</span>");
  puiDatatable.children.clear();
  puiDatatable.children.addAll(inside.children);

}

/** Copied from ng-repeat.dart */
String extractNameOfCollection(String ngRepeatStatement) {
  RegExp _SYNTAX = new RegExp(r'^\s*(.+)\s+in\s+(.*?)\s*(\s+track\s+by\s+(.+)\s*)?(\s+lazily\s*)?$');
  Match match = _SYNTAX.firstMatch(ngRepeatStatement);
  if (match == null) {
    throw "[NgErr7] ngRepeat error! Expected expression in form of '_item_ "
        "in _collection_[ track by _id_]' but got '$ngRepeatStatement'.";
  }
  String _listExpr = match.group(2);
  return _listExpr;
}


/** Creates the header of a table and counts the number of columns */
int _addHeaderTags(Element puiDatatable, ElementList columns) {
  int count=0;
  columns.forEach((Element column){
    count++;
    Element h = new Element.header();
    h.attributes["header"]=column.attributes["header"];
    String s = column.attributes["sortable"];
    if (s==null) s="false";
    h.attributes["sortable"]=s;
    String c = column.attributes["closable"];
    if (c==null)c="false";
    h.attributes["closable"]=c;
    puiDatatable.children.add(h);
    print(column.innerHtml);
  });
  return count;
}

_addRowTag(Element puiDatatable, ElementList columns) {
  print("Add Row line");
}



