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
echo "  set _xil_proj_name_ \$::user_project_name" >> create_prj.tcl
echo "}" >> create_prj.tcl

echo "variable script_file" >> create_prj.tcl
echo "set script_file \"create_prj.tcl\"" >> create_prj.tcl




echo "set orig_proj_dir \"[file normalize \"\$origin_dir/../Work\"]\"" >> create_prj.tcl

echo "create_project $prj_name ../Work" >> create_prj.tcl
# Create 'sources_1' fileset (if not found)
echo "if {[string equal [get_filesets -quiet sources_1] \"\"]} {" >> create_prj.tcl
echo "  create_fileset -srcset sources_1" >> create_prj.tcl
echo "}" >> create_prj.tcl

# Set IP repository paths
echo "set obj [get_filesets sources_1]" >> create_prj.tcl
echo "set_property IP_REPO_PATHS ./../Src/IPs [current_project]" >> create_prj.tcl

echo "update_ip_catalog" >> create_prj.tcl
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
git init
git add .
git commit -m "Folders created for $prj_name"