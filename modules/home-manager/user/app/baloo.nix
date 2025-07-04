{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.user.app.baloo;
in {
  options.user.app.baloo = {
    enable = mkEnableOption "baloo";
    autostart = mkEnableOption "baloo autostart";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kdePackages.baloo
    ];

    home.file.".config/baloofilerc".text = ''
      [Basic Settings]
      Indexing-Enabled=true

      [General]
      dbVersion=2
      exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found,*.ioc,.direnv,build,target,*.c,*.cpp,*.s,*.h,*.hpp,*.rs,*.ts,*.js,*.tsx,*.jsx,*.vue,*.log,test
      exclude mimetypes=text/x-c,application/*,text/x-asm
      exclude filters version=8
      exclude folders[$e]=
      folders[$e]=$HOME/syncthing/
      only basic indexing=false
    '';
  };
}
