#!/bin/bash
prj_name=$1
mkdir ./$prj_name
mkdir ./$prj_name/Src
mkdir ./$prj_name/Mcs
mkdir ./$prj_name/Work
mkdir ./$prj_name/Sdk
mkdir ./$prj_name/Scripts
mkdir ./$prj_name/Src/sources
mkdir ./$prj_name/Src/constarins
mkdir ./$prj_name/Src/IPs
cd ./$prj_name
touch .gitignore

cd Scripts
touch create_prj.tcl
echo "set origin_dir \".\"" >> create_prj.tcl

echo "if { [info exists ::origin_dir_loc] } {" >> create_prj.tcl
echo "  set origin_dir $::origin_dir_loc" >> create_prj.tcl
echo "}" >> create_prj.tcl
echo "" >> create_prj.tcl

echo "set _xil_proj_name_ $prj_name" >> create_prj.tcl

echo "if { [info exists ::user_project_name] } {" >> create_prj.tcl
echo "  set _xil_proj_name_ $::user_project_name" >> create_prj.tcl
echo "}" >> create_prj.tcl

echo "variable script_file" >> create_prj.tcl
echo "set script_file \"create_prj.tcl\"" >> create_prj.tcl


echo "if { $::argc > 0 } {" >> create_prj.tcl
echo "  for {set i 0} {$i < $::argc} {incr i} {" >> create_prj.tcl
echo "    set option [string trim [lindex $::argv $i]]" >> create_prj.tcl
echo "    switch -regexp -- $option {" >> create_prj.tcl
echo "      "--origin_dir"   { incr i; set origin_dir [lindex $::argv $i] }" >> create_prj.tcl
echo "      "--project_name" { incr i; set _xil_proj_name_ [lindex $::argv $i] }" >> create_prj.tcl
echo "      "--help"         { print_help }" >> create_prj.tcl
echo "      default {" >> create_prj.tcl
echo "        if { [regexp {^-} $option] } {" >> create_prj.tcl
echo "          puts "ERROR: Unknown option '$option' specified, please type '$script_file -tclargs --help' for usage info.\n"" >> create_prj.tcl
echo "          return 1" >> create_prj.tcl
echo "        }" >> create_prj.tcl
echo "      }" >> create_prj.tcl
echo "    }" >> create_prj.tcl
echo "  }" >> create_prj.tcl
echo "}" >> create_prj.tcl
echo "" >> create_prj.tcl

echo "set orig_proj_dir \"[file normalize \"$origin_dir/../Work\"]\"" >> create_prj.tcl

echo "create_project $prj_name ../Work" >> create_prj.tcl


cd ..

echo "#!/bin/bash" >> rsync.sh
echo "cp ./Work/*.runs/impl*/*.bit ./Mcs" >> rsync.sh
echo "cp ./Work/*.runs/impl*/*.tcl ./Mcs" >> rsync.sh
echo "cp ./Work/*.runs/impl*/*.bin ./Mcs" >> rsync.sh
echo "cp ./Work/*.runs/impl*/*.mcs ./Mcs" >> rsync.sh
echo "find ./Work/*.srcs -name "*.hwh" -type f -exec cp {} ./Mcs \;" >> rsync.sh
echo "sed 's/\.\/\${_xil_proj_name_}/\.\.\/Work/g' ./Scripts/create_prj.tcl > ./Scripts/temp.tcl" >> rsync.sh
echo "cat ./Scripts/temp.tcl > ./Scripts/create_prj.tcl" >> rsync.sh
echo "rm ./Scripts/temp.tcl" >> rsync.sh
chmod +x rsync.sh

echo /Work/* >> .gitignore
echo *.log >> .gitignore
echo *.jou >> .gitignore
git init
git add .
git commit -m "Folders created for $prj_name"
