# Git_Compatible_Vivado_prj

This is a shell file to create a git compatible vivado project(Based on 2019.1)

```shell
cd [your project folder]
./create_git_vivado.sh [your project name]
```

After running this, a folder named as the project name should be created. There are several more folders inside the folder:
Mcs:
  Used to save the bit/bin/mcs file for programe the FPGA. For now, I can't automatically setup the vivado to output those files in to this folder, so if you want to keep a version of bitsream, you have to copy those files into this folder after you finishing the generating bitstream. I recommend that at leasy two files should be kept: *.bit and *.tcl. These two files is essential for genrating mcs files and linux devices tree.

Src:
  It contains all the source files including .v(vhd) .xdc and IP files. Again, now the vivado won't create files under this folder by default. My suggestion is creating your source file in the Src folder and add them to vivado project. Notice that you should disable "copy files to project" function so that your modification happens directly to the files in the Src folder, and thereby you are not required to copy paste modified files.
  In addition, you should go to your settings and set the IP output file path to the Src/IPs as tracing IPs is also important.

Scrips:
  Saving the scripts to recreate the project. After running the command line, a script called create_prj.tcl is created. You can start your vivado and cd to the Script folder (essential) in the vivado TCL console and run:
  ```tcl
  source ./create_prj.tcl
  ```
  And then the project is created in the Work folder. You have to setup the IP output path, part name ,etc. After finishing the building of project, you can overwrite this tcl file by
  ```tcl
  write_project_tcl ../Scripts/create_prj.tcl -force
  ```
  However, the script creates the project in the Script folder, so you need to change the folder address:
  ```tcl
  create_project ${_xil_proj_name_} ./${_xil_proj_name_} -part <part_name>
  to
  create_project ${_xil_proj_name_} ../Work -part <part_name>
  ```
  . If you used block diagram design, you also have to run:
  ```tcl
  wirte_bd_tcl ../Scripts/<your_name/.tcl>
  ```
  And so that you are able to recreate the project easily.
  
The git has been initilized and commited. You can enjoy your design and the convenience of git now!
