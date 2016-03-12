# -limit 100000 
# -doc   testlinks 
# -index chap0.html chapters.htm 
# /doc/changes/@ 
# /doc/ref/@
# /doc/tut/@
# ...
# ...

Basename := function(str)
  local len;
  len := Length(str);
  while len > 0 and str[len] <> '/' do
    len := len - 1;
  od;
  if len = 0 then
    return str;
  else
    return str{[len+1..Length(str)]};
  fi;
end;

pkgs:=GAPInfo.PackagesInfo;;
pkgs:=SortedList(ShallowCopy(RecNames(pkgs)));
indexnames:=[];
dirlist:=[];

for pkg in pkgs do
  if IsBound( GAPInfo.PackagesInfo.(pkg)[1].PackageDoc[1].HTMLStart ) then
    dirname := Basename( GAPInfo.PackagesInfo.(pkg)[1].InstallationPath );
    htmlstart := GAPInfo.PackagesInfo.(pkg)[1].PackageDoc[1].HTMLStart;
    indexname := Basename(htmlstart);
    AddSet( indexnames, indexname );
    dirname := Concatenation( dirname, "/", htmlstart );
    dirname := dirname{[1..Length(dirname)-Length(indexname)]};
    if not dirname[Length(dirname)] = '/' then
      Error( pkg, " - can not determine the path!\n");
    fi;
    Add( dirlist, dirname );
  else
    Print( pkg, " - no html version of the manual\n");
  fi;
od;

PrintTo( "testlinks", "=============================================\n");
AppendTo( "testlinks", "# autogenerated with GAP\n");
AppendTo("testlinks", "-limit 100000\n");
AppendTo("testlinks", "-doc   testlinksreports\n"); 
AppendTo("testlinks", "-index ");
for s in indexnames do
  AppendTo("testlinks", s, " ");
od;
AppendTo("testlinks", "\n");
AppendTo("testlinks", "/doc/changes/@\n");
AppendTo("testlinks", "/doc/ref/@\n");
AppendTo("testlinks", "/doc/tut/@\n");
for s in dirlist do
  AppendTo("testlinks", "/pkg/", s, "@\n");
od;
AppendTo( "testlinks", "=============================================\n");

QUIT;

